import logging
import sys
import threading
import time
import traceback
from urllib.parse import urlparse as parse_url, urljoin, urlencode
from urllib.request import urlopen as _urlopen

from pipe_line_connector import on_item_update
sys.stdout.reconfigure(encoding='utf-8')

SAHAMYAB_SERVER = "https://push.sahamyab.com"


def _url_encode(params):
    return urlencode(params).encode("utf-8")


def _iteritems(d):
    return iter(d.items())


def wait_for_input():
    #time.sleep(60)
    input("{0:-^80}\n".format("HIT CR TO UNSUBSCRIBE AND DISCONNECT FROM LIGHTSTREAMER"))


CONNECTION_URL_PATH = "lightstreamer/create_session.txt"
BIND_URL_PATH = "lightstreamer/bind_session.txt"
CONTROL_URL_PATH = "lightstreamer/control.txt"
OP_ADD = "add"
OP_DELETE = "delete"
OP_DESTROY = "destroy"
PROBE_CMD = "PROBE"
END_CMD = "END"
LOOP_CMD = "LOOP"
ERROR_CMD = "ERROR"
SYNC_ERROR_CMD = "SYNC ERROR"
OK_CMD = "OK"


class Subscription(object):
    def __init__(self, mode, items, fields, adapter=""):
        self.item_names = items
        self._items_map = {}
        self.field_names = fields
        self.adapter = adapter
        self.mode = mode
        self.snapshot = "true"
        self._listeners = []
        self.item_counts=0

    def _decode(self, value, last):
        if value == "$":
            return ""
        elif value == "#":
            return None
        elif not value:
            return last
        elif value[0] in "#$":
            value = value[1:]

        return value

    def addlistener(self, listener):
        self._listeners.append(listener)

    def notifyupdate(self, item_line):
        toks = item_line.rstrip("\r\n").split("|")
        undecoded_item = dict(list(zip(self.field_names, toks[1:])))

        item_pos = int(toks[0])
        curr_item = self._items_map.get(item_pos, {})
        self._items_map[item_pos] = dict(
            [
                (k, self._decode(v, curr_item.get(k)))
                for k, v in list(undecoded_item.items())
            ]
        )
        if item_pos == 1 or item_pos == 2:
            name = self.item_names[item_pos - 1]
        else:
            name = "Other ads"
        item_info = {"pos": item_pos, "name": name, "values": self._items_map[item_pos]}

        for on_item_update in self._listeners:
            on_item_update(item_info)
            self.item_counts += 1
            print("Twitt counts =", self.item_counts)


class LSClient(object):
    def __init__(self, base_url, adapter_set="", user="", password=""):
        self._base_url = parse_url(base_url)
        self._adapter_set = adapter_set
        self._user = user
        self._password = password
        self._session = {}
        self._subscriptions = {}
        self._current_subscription_key = 0
        self._stream_connection = None
        self._stream_connection_thread = None
        self._bind_counter = 0

    def _encode_params(self, params):
        return _url_encode(dict([(k, v) for (k, v) in _iteritems(params) if v]))

    def _call(self, base_url, url, params):
        url = urljoin(base_url.geturl(), url)
        body = self._encode_params(params)
        return _urlopen(url, data=body)

    def _set_control_link_url(self, custom_address=None):
        if custom_address is None:
            self._control_url = self._base_url
        else:
            parsed_custom_address = parse_url("//" + custom_address)
            self._control_url = parsed_custom_address._replace(scheme=self._base_url[0])

    def _control(self, params):
        params["LS_session"] = self._session["SessionId"]
        response = self._call(self._control_url, CONTROL_URL_PATH, params)
        decoded_response = response.readline().decode("utf-8").rstrip()
        return decoded_response

    def _read_from_stream(self):
        line = self._stream_connection.readline().decode("utf-8").rstrip()
        return line

    def connect(self):
        self._stream_connection = self._call(
            self._base_url,
            CONNECTION_URL_PATH,
            {
                "LS_op2": "create",
                "LS_cid": "mgQkwtwdysogQz2BJ4Ji kOj2Bg",
                "LS_adapter_set": self._adapter_set,
                "LS_user": self._user,
                "LS_password": self._password,
            },
        )
        stream_line = self._read_from_stream()
        self._handle_stream(stream_line)

    def bind(self):
        self._stream_connection = self._call(
            self._control_url, BIND_URL_PATH, {"LS_session": self._session["SessionId"]}
        )

        self._bind_counter += 1
        stream_line = self._read_from_stream()
        self._handle_stream(stream_line)

    def _handle_stream(self, stream_line):
        if stream_line == OK_CMD:
            while 1:
                next_stream_line = self._read_from_stream()
                if next_stream_line:
                    session_key, session_value = next_stream_line.split(":", 1)
                    self._session[session_key] = session_value
                else:
                    break

            self._set_control_link_url(self._session.get("ControlAddress"))

            self._stream_connection_thread = threading.Thread(
                name="StreamThread-{0}".format(self._bind_counter), target=self._receive
            )
            self._stream_connection_thread.setDaemon(True)
            self._stream_connection_thread.start()
        else:
            lines = self._stream_connection.readlines()
            lines.insert(0, stream_line)

            raise IOError()

    def _join(self):
        if self._stream_connection_thread:
            self._stream_connection_thread.join()
            self._stream_connection_thread = None

    def disconnect(self):
        if self._stream_connection is not None:
            server_response = self._control({"LS_op": OP_DESTROY})
            self._join()
        else:
            pass

    def subscribe(self, subscription):
        self._current_subscription_key += 1
        self._subscriptions[self._current_subscription_key] = subscription

        server_response = self._control(
            {
                "LS_Table": self._current_subscription_key,
                "LS_op": OP_ADD,
                "LS_data_adapter": subscription.adapter,
                "LS_mode": subscription.mode,
                "LS_schema": " ".join(subscription.field_names),
                "LS_id": " ".join(subscription.item_names),
            }
        )
        return self._current_subscription_key

    def unsubscribe(self, subcription_key):
        if subcription_key in self._subscriptions:
            server_response = self._control(
                {"LS_Table": subcription_key, "LS_op": OP_DELETE}
            )

            if server_response == OK_CMD:
                del self._subscriptions[subcription_key]
        else:
            pass

    def _forward_update_message(self, update_message):
        try:
            tok = update_message.split(",", 1)
            table, item = int(tok[0]), tok[1]
            if table in self._subscriptions:
                self._subscriptions[table].notifyupdate(item)
            else:
                logging.warning("No subscription found!")
        except Exception:
            logging.error(traceback.format_exc())

    def _receive(self):
        rebind = False
        receive = True
        while receive:
            try:
                message = self._read_from_stream()
                if not message.strip():
                    message = None
            except Exception:
                print(traceback.format_exc())
                message = None

            if message is None:
                receive = False
            elif message == PROBE_CMD:
                pass
            elif message.startswith(ERROR_CMD):
                receive = False
            elif message.startswith(LOOP_CMD):
                receive = False
                rebind = True
            elif message.startswith(SYNC_ERROR_CMD):
                receive = False
            elif message.startswith(END_CMD):
                receive = False
            elif message.startswith("Preamble"):
                pass
            else:
                self._forward_update_message(message)

        if not rebind:
            self._stream_connection = None
            self._session.clear()
            self._subscriptions.clear()
            self._current_subscription_key = 0
        else:
            self.bind()


def connect_and_create_lightstreamer_client(server_name):
    lightstreamer_client = LSClient(server_name, "STOCKLISTDEMO_REMOTE")
    try:
        lightstreamer_client.connect()
    except Exception as e:
        logging.error("Unable to connect to Lightstreamer Server")
        logging.error(traceback.format_exc())
        sys.exit(1)
    return lightstreamer_client


def create_subscription(lightstreamer_client):
    subscription = Subscription(
        mode="DISTINCT",
        items=["general ads", "technical ads"],
        fields=[
            "id",
            "ads",
            "parentId",
            "parentSenderName",
            "parentSenderUsername",
            "parentContent",
            "parentSendTime",
            "retwitSenderName",
            "retwitSenderUsername",
            "retwitSendTime",
            "senderName",
            "senderUsername",
            "content",
            "sendTime",
            "likeCount",
            "commentCount",
            "retwitCount",
            "liked",
            "type",
            "senderProfileImage",
            "parentSenderProfileImage",
            "imageUid",
            "fileUid",
            "parentImageUid",
            "senderIsOfficial",
            "videoUid",
            "mediaContentType",
            "editable",
            "sendTimePersian",
            "status",
            "hasChart",
            "parentDeleted",
            "options",
            "finalPullDatePersian",
            "finalPullDate",
            "durationPerHour",
            "durationPerDay",
            "parentType",
            "parentDurationPerDay",
            "parentDurationPerHour",
            "parentOptions",
            "pullStatus",
            "parentPullStatus",
            "voteCount",
            "parentVoteCount",
        ],
        adapter="QUOTE_ADAPTER",
    )
    subscription.addlistener(on_item_update)
    sub_key = lightstreamer_client.subscribe(subscription)
    return sub_key


def run():
    lightstreamer_client = connect_and_create_lightstreamer_client(SAHAMYAB_SERVER)
    sub_key = create_subscription(lightstreamer_client)

    wait_for_input()
    lightstreamer_client.unsubscribe(sub_key)
    lightstreamer_client.disconnect()

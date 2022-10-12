#!/usr/bin/env python
import sys 
import json
import re
from turtle import st
sys.stdout.reconfigure(encoding='utf-8')

from pprint import pformat

def on_item_update(item_update):
    record = item_update
    if record["values"].get("content") != None:
        record["values"]["content"] = record["values"]["content"].encode().decode('unicode_escape') 
        record["values"]["senderName"] = record["values"]["senderName"].encode().decode('unicode_escape') 
        if record["values"].get("parentContent") != None:
            record["values"]["parentContent"] = record["values"]["parentContent"].encode().decode('unicode_escape') 
            record["values"]["parentSenderName"] = record["values"]["parentSenderName"].encode().decode('unicode_escape') 
        
    storing_data = {}
    storing_data['content'] = record["values"]['content']
    storing_data['time'] = record["values"]['sendTimePersian']
    storing_data['type'] = record["values"]['type']
    storing_data['username'] = record["values"]['senderUsername']
    storing_data['hashtags'] = re.findall(r"#(\w+)", record["values"]['content'])

    with open("tweets.json", "a") as outfile:
        json.dump(storing_data, outfile)
        print("done!")
    #print(pformat(record))

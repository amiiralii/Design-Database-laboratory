import json
import re
from elasticsearch import Elasticsearch

import warnings
warnings.filterwarnings("ignore")

def find_hashtags(text):
    return re.findall(r"#(\w+)", text)

es = Elasticsearch("http://localhost:9200")
i = 0
with open('tweets.json', encoding='UTF-8') as raw_data:
    data = raw_data.read().replace("}{", "},{")
    json_docs = json.loads("[" + data + "]")
    print(type(json_docs))
    for json_doc in json_docs:
        # del json_doc['id']
        json_doc['hashtags'] = find_hashtags(json_doc['content'])
        i = i + 1
        # es.index(index='twitter-twits', id=i, body=json.dumps(json_doc))
        print(i, '-->' , json_doc['hashtags'])

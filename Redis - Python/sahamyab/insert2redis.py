import json
import re
import redis

def find_hashtags(text):
    return re.findall(r"#(\w+)", text)

redisClient = redis.StrictRedis(host='localhost', port=6379, db=0)

with open('tweets.json', encoding='UTF-8') as raw_data:
    data = raw_data.read().replace("}{", "},{")
    json_docs = json.loads("[" + data + "]")
    for json_doc in json_docs:
        tweet_time = json_doc['time']
        tweet_day = tweet_time[:10]
        tweet_hour = tweet_time[11:13]
        day_list_name = "hashtags:" + tweet_day
        hour_list_name = day_list_name + ":" + tweet_hour

        json_doc['hashtags'] = find_hashtags(json_doc['content'])
        for hashtag in json_doc['hashtags']:
            current_score = redisClient.zscore(day_list_name, hashtag)
            if current_score is None:
                redisClient.zadd(day_list_name, {hashtag:1.0})
            else:
                redisClient.zadd(day_list_name, { hashtag : current_score + 1})


            current_score = redisClient.zscore(hour_list_name, hashtag)
            if current_score is None:
                redisClient.zadd(hour_list_name, {hashtag:1.0})
            else:
                redisClient.zadd(hour_list_name, { hashtag : current_score + 1})

print("Sample data in redis for one day:")

data = redisClient.zrange("hashtags:1401/01/07", 0, -1, withscores=True)
print("hashtags:1401/01/07")
print(data[-1])
for i in range(1, 24):
    print('----------------------------')
    if i < 10:
        time = "hashtags:1401/01/07:0"+str(i)
    else:
        time = "hashtags:1401/01/07:"+str(i)
    data = redisClient.zrange(time, 0, -1, withscores=True)
    print(time)
    if len(data)>0:
        print(data[-1])



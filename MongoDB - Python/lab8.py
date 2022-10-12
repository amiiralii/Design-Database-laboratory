from pymongo import MongoClient
import pymongo
import requests, json
import time
from persiantools.jdatetime import JalaliDate
import datetime
import hashlib

Client = MongoClient()
myclient = MongoClient('localhost', 27017)
  
my_database = myclient['metadata']  
my_collection = my_database['Users'] 

# url = "https://randomuser.me/api/?nat=ir "
# for i in range(1,21):
#     querystring = {"nat":"ir", "results":"5000"} 
#     response = requests.request("GET", url, params=querystring)
#     data = json.loads(response.text)
#     try:
#         x = mycol.insert_many(data['results'])
#         print(i*5000,"users added to database.")
#     except:
#         print('Wait')
#         time.sleep(70)

Client = MongoClient()
myclient = MongoClient('localhost', 27017)
  
my_database = myclient['metadata']  
my_collection = my_database['Users'] 

mydoc = my_collection.aggregate([
    {"$project":
        {"AgeGroup":
            {"$cond":
                {"if":
                    {"$lte",["$dob.age",24]},
                    "then":"Teenager",
                    "else":
                        {"$cond":
                            {"$if":
                            {"$lte":["$dob.age",30]},
                            "then":"young",
                            "else":"middle_aged"
                            }
                        }
                }
            }
        }
    },
    {"$group":
        {"_id":"$AgeGroup",  "count": { "$sum": 1 } }
    },
    {"$project" : {
            "_id" : 0.0,
            "age_groups" : "$_id",
            "count" : { "$toInt" : "$count" }
        }
    }
])

for i in mydoc:
    print(i)
    print('---------------')

# username = 'tinypeacock278'
# password = 'pass1234'
# mydoc = my_collection.find({"login.username":username, "login.password":password})
# print(hashlib.sha256(password.encode()).hexdigest())
# hashed = hashlib.sha256(password.encode()).hexdigest()
# print("Login succesful!")
# print( "User id is", mydoc[0]['_id'] )
# print( "User name is", mydoc[0]['name'] )
# print( "User id is", mydoc[0]['email'] )
# user_id = mydoc[0]['_id']
# mydoc = my_collection.update_one({"_id":user_id},{"$set":{"login.password":hashed}})
# mydoc = my_collection.find({"login.username":username, "login.password":hashlib.sha256(password.encode()).hexdigest()})
# print("Login succesful!")
# print( "User id is", mydoc[0]['_id'] )
# print( "User name is", mydoc[0]['name'] )
# print( "User id is", mydoc[0]['email'] )
# print( "User password is", mydoc[0]['login']['password'] )

# mydoc = my_collection.find({})
# for i in mydoc:
#     user = my_collection.find({"_id":i['_id']})
#     hashed = hashlib.sha256(user[0]['login']['password'].encode()).hexdigest()
#     my_collection.update_one({"_id":i['_id']},{"$set":{"login.password":hashed}})


#     bd_date = x['dob']['date']
#     year = int(bd_date[:4])
#     month = int(bd_date[5:7])
#     day = int(bd_date[8:10])
    
#     jalali = JalaliDate(datetime.date(year, month, day))

#     jalali_str = str(jalali.year)+"-"
#     if jalali.month<10:
#         jalali_str += '0'
#     jalali_str += str(jalali.month)+"-"
#     if jalali.day<10:
#         jalali_str += '0'
#     jalali_str += str(jalali.day)

#     print(jalali_str)

#     print("------------------") 
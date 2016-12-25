import sys
from pymongo import MongoClient
from Crypto.Hash import SHA256

#####################################
# main program                      #
#####################################

mongoURL = sys.argv[1]
adminPwd = sys.argv[2]

hash = SHA256.new()
hash.update(adminPwd)

client = MongoClient('mongodb://' + mongoURL + '/')

adminUser = {"username": "admin",
             "password": hash.hexdigest()
             }

client.eae.users.insert_one(adminUser)

client.close()

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

db = MongoClient('mongodb://' + mongoURL + '/').eae

adminUser = {"username": "admin",
             "password": hash.hexdigest()
             }

db.users.insert_one(adminUser)

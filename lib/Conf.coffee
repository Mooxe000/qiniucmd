echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'
fs = require 'fs-sync'
jf = require 'jsonfile'
fibrous = require 'fibrous'

# Get conf obj
getConf = fibrous (conffile) -> jf.sync.readFile conffile

# Check
checkBucket = fibrous (confObj) ->
  confObj.bucket = {} unless _.has confObj, 'bucket'
  confObj

checkBucketname = fibrous (confObj, bucketname) ->
  confObj = checkBucket.sync confObj
  confObj.bucket[bucketname] = {} unless _.has confObj.bucket, bucketname
  confObj

# Get buckets array
getBuckets = fibrous (confObj) -> buckets = confObj.bucket

# Get bucketnames arraay
getBucketnames = fibrous (confObj) ->
  confObj = checkBucket.sync confObj
  buckets = getBuckets.sync confObj
  _.keys buckets, 'name'

# get bucket in conf obj
getBucket = fibrous (confObj, bucketname) ->
  confObj = checkBucketname.sync confObj, bucketname
  buckets = getBuckets.sync confObj
  buckets[bucketname]

# Get bucket field obj
getField = fibrous (confObj, bucketname, fieldname) ->
  bucket = getBucket.sync confObj, bucketname
  if bucket[fieldname]?
    bucket[fieldname]
  else confObj

# Set bucket field obj
setField = fibrous (confObj, bucketname, fieldname, fieldobj) ->
  confObj.bucket[bucketname][fieldname] = fieldobj
  confObj

# Del bucket
delBucket = fibrous (confObj, bucketname) ->
  confObj = checkBucketname.sync confObj, bucketname
  delete confObj.bucket[bucketname]
  confObj

# Set bucket
setBucket = fibrous (confObj, bucketname, bucketObj) ->
  confObj.bucket[bucketname] = bucketObj
  confObj

# Save conf obj to conf json file
saveConf = fibrous (confObj, jsonfile) ->
  jsonStr = JSON.stringify confObj, null, 2
  fs.write jsonfile, jsonStr, 'utf8'
  confObj

# LIST BUCKET
list = fibrous (conffile, bucketname) ->
  confObj = getConf.sync conffile
  unless bucketname?
    getBucketnames.sync confObj
  else
    getBucket.sync confObj, bucketname

# DEL BUCKET
del = fibrous (conffile, bucketname) ->
  confObj = getConf.sync conffile
  confObj = checkBucket.sync confObj
  confObj = delBucket.sync confObj, bucketname
  saveConf.sync confObj, conffile

# SET BUCKET
set = fibrous (conffile, bucketname, bucketobj) ->
  confObj = getConf.sync conffile
  confObj = checkBucket.sync confObj
  confObj = setBucket.sync confObj, bucketname, bucketobj
  saveConf.sync confObj, conffile

# MDF BUCKET
mdf = fibrous (conffile, bucketname, fieldname, fieldobj) ->
  confObj = getConf.sync conffile
  confObj = checkBucket.sync confObj
  confObj = setField.sync confObj, bucketname, fieldname, fieldobj
  saveConf.sync confObj, conffile

###
  INTERFACE
###
exports.list = list
exports.del = del
exports.set = set
exports.mdf = mdf

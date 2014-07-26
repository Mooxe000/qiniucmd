#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log
Log = require 'log'
log = new Log 'info'
path = require 'path'
fibrous = require 'fibrous'
qiniu = require 'qiniu'
Util = require './../lib/Util.coffee'
{dfcbhd} = Util
Locale = require './../lib/Locale.coffee'
{getLocalfiles} = Locale
Bucket = require './../lib/Bucket.coffee'
{listkey} = Bucket
{getUptoken} = Bucket
{uploadFiles} = Bucket
{removeAll} = Bucket

##############
qiniu.conf.ACCESS_KEY = 'sk3ih-dmwXSX3JA7fQiakBdukxBNpCr7jZwlFqsc'
qiniu.conf.SECRET_KEY = 'eiHLSqmg7uCRg0bCUpJoUkKEFuIu3mT-AkpcE7uz'
##############

bucketname = 'weixinweb'
prefix = ''
marker = null
limit = 1000
pathroot = path.join __dirname, './../../../dist/public/'

###
  CMD TEST
###
target.list = -> fibrous.run (->
  listkey.sync bucketname, prefix, marker, limit
), (err, ret) -> dfcbhd err, ret

target.remove = -> fibrous.run (->
  keys = listkey.sync bucketname, prefix, marker, limit
  unless keys.length is 0
    removeAll.sync bucketname, keys
  else
    throw new Error 'The Bucket has none file to remove'
), (err, ret) -> dfcbhd err, ret

target.upload = -> fibrous.run (->
  filesObj = getLocalfiles.sync pathroot
  uptoken = getUptoken bucketname
  uploadFiles.sync uptoken, filesObj
), (err, ret) -> dfcbhd err, ret

target.all = ->
  target.list()

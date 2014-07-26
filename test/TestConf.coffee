#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log
Log = require 'log'
log = new Log 'info'
path = require 'path'
fibrous = require 'fibrous'
Util = require './../lib/Util.coffee'
{dfcbhd} = Util
Conf = require './../lib/Conf.coffee'
{list} = Conf
{del} = Conf
{set} = Conf
{mdf} = Conf

###
  CMD TEST
###
conffile = path.join __dirname, "./Testconf.json"
bucketname = 'weixinweb'
keyObj = {
  access_key: 'hello'
  secret_key: 'world'
}
pathroot = path.join __dirname, './../../../dist/public/'
localeObj = [ pathroot ]
bucketObjs = {}
bucketObjs.key = keyObj
bucketObjs.locale = localeObj

# LIST
target.list = -> fibrous.run (->
  list.sync conffile, bucketname
), (err, ret) ->
  dfcbhd err, ret

# DEL
target.del = -> fibrous.run (->
  Conf.del.sync conffile, bucketname
), (err, ret) ->
  dfcbhd err, ret

# SET
target.set = -> fibrous.run (->
  set.sync conffile, bucketname, bucketObjs
), (err, ret) ->
  dfcbhd err, ret

# MDF
target.mdf = -> fibrous.run (->
  mdf.sync conffile, bucketname, 'key', keyObj
  mdf.sync conffile, bucketname, 'locale', localeObj
), (err, ret) ->
  dfcbhd err, ret


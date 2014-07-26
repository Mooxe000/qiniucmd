echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'
path = require 'path'
commander = require 'commander'
fibrous = require 'fibrous'
Util = require './Util.coffee'
{dfcbhd} = Util
rl = require './Readline.coffee'
{question} = rl
Cipher = require './Cipher.coffee'
{coder} = Cipher
{decoder} = Cipher
Conf = require './Conf.coffee'
{list} = Conf
{del} = Conf
{set} = Conf
{mdf} = Conf
Locale = require './Locale.coffee'
{listFiles} = Locale
{getFlsObjs} = Locale
{getlength} = Locale
{getkeys} = Locale
{getfiles} = Locale
{getLocalfiles} = Locale
Bucket = require './Bucket.coffee'
{listkey} = Bucket
{getUptoken} = Bucket
{uploadFiles} = Bucket
{removeAll} = Bucket

conffile = path.join __dirname, "./../conf.json"
# TODO conf
prefix = ''
marker = null
limit = 1000

###
  Main
###
getBucketnames = fibrous ->
  list.sync conffile

###
  echo Action
###
echoAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    bucketObj = list.sync conffile, bucketname
    optfield = getcmdopt 'echo', 'field'
    if optfield is true
      _.keys bucketObj
    else if optfield is false
      bucketObj
    else
      bucketObj[optfield]
), (err, ret) -> dfcbhd err, ret

###
  del Action
###
delAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    del.sync conffile, bucketname
), (err, ret) -> dfcbhd err, ret

###
  add Action
###
getKeys = fibrous ->
  tokens = ['access_key', 'secret_key']
  question.sync tokens

coderKeys = fibrous (keys) ->
  keysnames = ['access_key', 'secret_key']
  pwd = question.sync ['password']
  keys_r = {}
  for keysname in keysnames
    key = keys[keysname]
    key_r = coder key, pwd.password
    keys_r[keysname] = key_r
  keys_r

decoderKeys = fibrous (keys) ->
  keysnames = ['access_key', 'secret_key']
  pwd = question.sync ['password']
  keys_r = {}
  for keysname in keysnames
    key = keys[keysname]
    key_r = decoder key, pwd.password
    keys_r[keysname] = key_r
  keys_r

getLocles = fibrous ->
  pathArr = []
  until path.path is 'end'
    path = question.sync ['path']
    unless path.path is 'end'
      pathArr.push path.path
  pathArr

getBucketObj = fibrous ->
  # key field
  keys = getKeys.sync()
  keys = coderKeys.sync keys
  # locale field
  locales = getLocles.sync()
  # bucket Obj
  bucketObj = {}
  bucketObj.key = keys
  bucketObj.locale = locales
  bucketObj

addAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    bucketObj = getBucketObj.sync()
    # set bucket conf
    set.sync conffile, bucketname, bucketObj
), (err, ret) -> dfcbhd err, ret

###
  mdf Action
###
mdfAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    bucketObj = list.sync conffile, bucketname
    optfield = getcmdopt 'mdf', 'field'
    if optfield is true
      _.keys bucketObj
    else if optfield is false
      bucketObj = getBucketObj.sync()
      # set bucket conf
      set.sync conffile, bucketname, bucketObj
    else
      if optfield is 'key'
        keys = getKeys.sync()
        keys = coderKeys.sync keys
        mdf.sync conffile, bucketname, 'key', keys
      else if optfield is 'locale'
        locales = getLocles.sync()
        mdf.sync conffile, bucketname, 'locale', locales
      else
        _.keys bucketObj
), (err, ret) -> dfcbhd err, ret

###
  list Action
###
getQiniu = fibrous (keys) ->
  qiniu = require 'qiniu'
  keys = decoderKeys.sync keys
  qiniu.conf.ACCESS_KEY = keys.access_key
  qiniu.conf.SECRET_KEY = keys.secret_key
  qiniu

listAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    optlocale = getcmdopt 'list', 'locale'
    optcount = getcmdopt 'list', 'count'
    bucketObj = list.sync conffile, bucketname
    if optlocale is true
      localepaths = bucketObj.locale
      localefiles = []
      count = []
      for localepath in localepaths
        files = listFiles.sync localepath
        fileObjs = getFlsObjs localepath, files
        localefiles.push getfiles fileObjs
        count.push getlength fileObjs
      localefiles = _.flatten localefiles
      total = 0
      for num in count
        total += num
      count.push total
      if optcount is true
        localefiles.push count
      localefiles
    else
      keys = bucketObj.key
      qiniu = getQiniu.sync keys
      qiniu
      bucketfiles = listkey.sync bucketname, prefix, marker, limit
      if optcount is true
        bucketfiles.push bucketfiles.length
      bucketfiles
), (err, ret) -> dfcbhd err, ret

###
  remove Action
###
removeAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    bucketObj = list.sync conffile, bucketname
    keys = bucketObj.key
    qiniu = getQiniu.sync keys
    qiniu
    bucketfiles = listkey.sync bucketname, prefix, marker, limit
    unless bucketfiles.length is 0
      removeAll.sync bucketname, bucketfiles
    else
      throw new Error 'The Bucket has none file to remove'
), (err, ret) -> dfcbhd err, ret

###
  upload Action
###
uploadAction = (bucketname) -> fibrous.run (->
  unless bucketname?
    getBucketnames.sync()
  else
    bucketObj = list.sync conffile, bucketname
    keys = bucketObj.key
    localepaths = bucketObj.locale
    qiniu = getQiniu.sync keys
    qiniu
    uptoken = getUptoken bucketname
    for localepath in localepaths
      filesObj = getLocalfiles.sync localepath
      uploadFiles.sync uptoken, filesObj
), (err, ret) -> dfcbhd err, ret

###
  Util
###
getcmdopt =  (cmdname, optname) ->
  commands = _.flatten commander.commands, '_name'
  index = _.indexOf commands, cmdname
  if commander.commands[index][optname]?
    commander.commands[index][optname]
  else false

exports.echoAction = echoAction
exports.delAction = delAction
exports.addAction = addAction
exports.mdfAction = mdfAction
exports.listAction = listAction
exports.removeAction = removeAction
exports.uploadAction = uploadAction

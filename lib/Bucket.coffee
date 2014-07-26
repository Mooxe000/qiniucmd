echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'
qiniu = require 'qiniu'
fibrous = require 'fibrous'

getUptoken = (bucketname) ->
  putPolicy = new qiniu.rs.PutPolicy(bucketname)
  # putPolicy.callbackUrl = callbackUrl;
  # putPolicy.callbackBody = callbackBody;
  # putPolicy.returnUrl = returnUrl;
  # putPolicy.returnBody = returnBody;
  # putPolicy.asyncOps = asyncOps;
  # putPolicy.expires = expires;
  putPolicy.token()

###
  LIST
###
listFile = fibrous (bucketname, prefix, marker, limit) ->
  fileObjs = qiniu.rsf.listPrefix.sync bucketname, prefix, marker, limit
  fileObjs.items

fieldFilter = (fileObjs, field) -> _.flatten fileObjs, field

listkey = fibrous (bucketname, prefix, marker, limit) ->
  fileObjs = listFile.sync bucketname, prefix, marker, limit
  fieldFilter fileObjs, 'key'

###
  UPLOAD
###
uploadFile = fibrous (uptoken, key, localFile) ->
  extra = new qiniu.io.PutExtra()
  # extra.params = params;
  # extra.mimeType = mimeType;
  # extra.crc32 = crc32;
  # extra.checkCrc = checkCrc;
  qiniu.io.putFile.sync uptoken, key, localFile, extra

uploadFiles = fibrous (uptoken, fileObjs) ->
  for fileObj in fileObjs
    {key} = fileObj
    {file} = fileObj
    log.info "upload file \"#{key}\""
    uploadFile.sync uptoken, key, file

###
  REMOVE
###
removeFile = fibrous (bucketname, key) ->
  client = new qiniu.rs.Client()
  client.remove.sync bucketname, key

removeAll = fibrous (bucketname, keys) ->
  client = new qiniu.rs.Client()
  pathArr = []
  echo bucketname
  for key in keys
    pathobj = new qiniu.rs.EntryPath bucketname, key
    pathArr.push pathobj
  client.batchDelete.sync pathArr

###
  INTERFACE
###
exports.listkey = listkey
exports.getUptoken = getUptoken
exports.uploadFiles = uploadFiles
exports.removeAll = removeAll


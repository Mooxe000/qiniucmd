echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'

fs = require 'fs-sync'
rd = require 'rd'

fibrous = require 'fibrous'

# List Dir Promise
listDir = fibrous (dir) -> rd.sync.read dir

# Get Files Array From Dir
fileFilter = (paths) ->
  files = []
  for _path in paths
    if fs.isFile _path
      files.push _path
  files

# List Files
listFiles = fibrous (dir) ->
  paths = listDir.sync dir
  fileFilter paths

# Separate key form fileObj
getFlsObjs = (pathroot, files) ->
  reg = new RegExp pathroot
  r_files = []
  for file in files
    key = file.replace reg, '/'
    r_files.push {key, file}
  r_files

getlength = (fileObjs) -> fileObjs.length
getkeys = (fileObjs) -> _.flatten fileObjs, 'key'
getfiles = (fileObjs) -> _.flatten fileObjs, 'file'

getLocalfiles = fibrous (pathroot) ->
  files = listFiles.sync pathroot
  getFlsObjs pathroot, files

###
  interface
###
exports.listFiles = listFiles
exports.getFlsObjs = getFlsObjs
exports.getlength = getlength
exports.getkeys = getkeys
exports.getfiles = getfiles
exports.getLocalfiles = getLocalfiles

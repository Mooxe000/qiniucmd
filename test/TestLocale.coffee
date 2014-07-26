#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'
path = require 'path'
fibrous = require 'fibrous'
Util = require './../lib/Util.coffee'
{dfcbhd} = Util
Locale = require './../lib/Locale.coffee'
{listFiles} = Locale
{getFlsObjs} = Locale
{getlength} = Locale
{getkeys} = Locale
{getfiles} = Locale
{getLocalfiles} = Locale

pathroot = path.join __dirname, './../../../dist/public/'

###
  CMD TEST
###
target.all = -> fibrous.run (->
  files = listFiles.sync pathroot
  fileObjs = getFlsObjs pathroot, files
  getlength fileObjs
  getkeys fileObjs
  getfiles fileObjs
  fileObjs
), (err, ret) -> dfcbhd err, ret

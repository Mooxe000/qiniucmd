#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log
Log = require 'log'
log = new Log 'info'

Cipher = require './../lib/Cipher.coffee'

###
  CMD TEST
###
key = "sk3ih-dmwXSX3JA7fQiakBdukxBNpCr7jZwlFqsc"
pwd = 'netserver'

target.coder = ->
  coderStr = Cipher.coder key, pwd
  echo coderStr

target.decoder = ->
  coderStr = Cipher.coder key, pwd
  decoderStr = Cipher.decoder coderStr, pwd
  echo decoderStr

target.all = ->
  target.coder()
  target.decoder()

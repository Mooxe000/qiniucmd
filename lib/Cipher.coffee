echo = console.log
Log = require 'log'
log = new Log 'info'
crypto = require 'crypto'

aes256 = (key, pwd) ->
  cipherType = 'aes-256-cbc'
  cipher = crypto.createCipher cipherType, pwd
  ciphered = cipher.update key, "utf8", "base64"
  ciphered += cipher.final "base64"
  ciphered

deaes256 = (key, pwd) ->
  cipherType = 'aes-256-cbc'
  decipher = crypto.createDecipher cipherType, pwd
  deciphered = decipher.update key, "base64", "utf8"
  deciphered += decipher.final "utf8"
  deciphered

base64 = (coderStr) ->
  buf = new Buffer coderStr
  buf.toString 'base64'
debase64 = (decoderStr) ->
  new Buffer(decoderStr, 'base64').toString()

coder = (key, pwd) ->
  pwd = aes256 pwd, pwd
  key = aes256 key, pwd
  obj = {}
  obj.key = key
  obj.pwd = pwd
  json = JSON.stringify obj
  json = base64 json
  json = json.toString 'base64'
  aes256 json, pwd

decoder = (key, pwd) ->
  pwd = aes256 pwd, pwd
  json = deaes256 key, pwd
  json = debase64 json
  obj = JSON.parse json
  deaes256 obj.key, obj.pwd

###
  INTERFACE
###
exports.coder = coder
exports.decoder = decoder

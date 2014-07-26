echo = console.log
Log = require 'log'
log = new Log 'info'
_ = require 'lodash'

fibrous = require 'fibrous'
rlp = require 'readline-prompter'

cbqs = (tokens, def, skip, callback) ->
  rlp tokens, def, skip
  .end (results) ->
    callback null, results

question = fibrous (tokens, def, skip) ->
  cbqs.sync tokens, def, skip

###
  INTERFACE
###
exports.question = question
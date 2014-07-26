#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log
Log = require 'log'
log = new Log 'info'
fibrous = require 'fibrous'
rl = require './../lib/Readline.coffee'
Util = require './../lib/Util.coffee'
{dfcbhd} = Util

###
  CMD TEST
###
target.all = ->
  tokens = ['first name', 'last name', 'cats name']
  def =
    'first name': 'JP'
  skip =
    'cats name': 'petey'

  fibrous.run (->
    rl.question.sync tokens, def, skip
  ), (err, ret) -> dfcbhd err, ret
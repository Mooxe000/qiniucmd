#!/usr/bin/env coffee
echo = console.log
Log = require 'log'
log = new Log 'info'
commander = require 'commander'
cmdmain = require './lib/CmdMain.coffee'
{echoAction} = cmdmain
{delAction} = cmdmain
{addAction} = cmdmain
{mdfAction} = cmdmain
{listAction} = cmdmain
{removeAction} = cmdmain
{uploadAction} = cmdmain

commander
.version '0.0.1'
# TODO
#.option '-s, --set-conffile <conf_file_path>', 'set config file path'

commander
.command 'echo [bucketname]'
.option '--field [fieldname]', 'echo config of bucketname'
.action echoAction

commander
.command 'del [bucketname]'
.action delAction

commander
.command 'add [bucketname]'
.action addAction

commander
.command 'mdf [bucketname]'
.option '--field [fieldname]', 'mdf config of bucketname'
.action mdfAction

commander
.command 'list [bucketname]'
.option '--locale', 'default list online bucket files'
.option '--count', 'echo count of file\'s number'
.action listAction

commander
.command 'remove [bucketname]'
.action removeAction

commander
.command 'upload [bucketname]'
.action uploadAction

commander.parse process.argv

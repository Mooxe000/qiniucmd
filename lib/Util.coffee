echo = console.log
Log = require 'log'
log = new Log 'info'

dfcbhd = (err, ret) ->
  unless err
    echo ret
  else
    if err.stack?
      echo err.stack
    else
      echo err

exports.dfcbhd = dfcbhd
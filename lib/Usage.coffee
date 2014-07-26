### TODO
cmd echo [bucketname] (echo config)
  option --field [fieldname]

cmd del [bucketname] (del config)

cmd add [bucketname] (add config)
  question password
  question key
    access_key
    secret_key
  question localepath

cmd mdf [bucketname] (mdf config)
  option --field [fieldname]

cmd list [bucketname] (List files)
  option --locale (default list online bucket files)
  option --count (echo count of file's number)

cmd remove [bucketname]

cmd update [bucketname]

# cmd sync
###
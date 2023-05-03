


if (!require(config))
  install.packages("config")


# load config and assign to an object
config <- config::get() 
db_name = config$db_name
db_host = config$db_host
db_port = config$db_port
db_uid = config$db_userid:wq:
db_pwd = config$db_pwd

print( paste("db: ", db_name, db_host, db_port, db_uid, db_pwd))

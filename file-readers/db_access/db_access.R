
createConnection <- function(my_db_driver, my_db_name, my_db_host, my_db_port, my_db_uid, my_db_pwd){

      print(paste( Sys.time(), " - Connecting to Database…"))
      con <- dbConnect(my_db_driver, 
                dbname = my_db_name,
                host = my_db_host, 
                port = my_db_port,
                user = my_db_uid, 
                password = my_db_pwd)
      
      print(paste( Sys.time(), " - Database Connected!"))
      return(con)
}

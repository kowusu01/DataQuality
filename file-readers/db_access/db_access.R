
createConnection <- function(my_db_driver, my_db_name, my_db_host, my_db_port, my_db_uid, my_db_pwd){

      print("Connecting to Database…")
      con <- dbConnect(my_db_driver, 
                dbname = my_db_name,
                host = my_db_host, 
                port = my_db_port,
                user = my_db_uid, 
                password = my_db_pwd)
      
      print("Database Connected!")
      return(con)
}


createConnection_orig <- function(my_db_driver, my_db_name, my_db_host, my_db_port, my_db_uid, my_db_pwd){
  tryCatch( 
    {
      #dbDriver <- dbDriver("PostgreSQL")
      print("Connecting to Database…")
      
      con <- dbConnect(my_db_driver, 
                       dbname = my_db_name,
                       host = my_db_host, 
                       port = my_db_port,
                       user = my_db_uid, 
                       password = my_db_pwd)
      
      print("Database Connected!")
      
      return(con)
    },
    error=function(e) {
      message("Error creating connection")
      print(e)
      return(NA)
    },
    warning=function(w) {
      message("Warning creating connection")
      print(w)
      return(NA)
    }
  )
}

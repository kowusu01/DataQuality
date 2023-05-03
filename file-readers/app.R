################################################################################
##
## reference : 
##  http://rafalab.dfci.harvard.edu/dsbook/string-processing.html#string-splitting 
##  https://viz-ggplot2.rsquaredacademy.com/ggplot2-modify-legend.html
##
## https://gist.github.com/ritchieking/5de10cde6b46f3536967a908fe806b5f
##
## https://medium.com/codex/how-to-persist-and-backup-data-of-a-postgresql-docker-container-9fe269ff4334
## https://www.r-bloggers.com/2018/07/connecting-r-to-postgresql-on-linux/
##
################################################################################

source("load_base_packages.R")
source("db_access/db_access.R")
source("malaria/malaria_csv_reader.R")
source("malaria/malaria_data_processor.R")

#DATA_FOLDER_NAME <- "/home/app_data/"
#COMPLETED_DATA_FOLDER <- "/home/app_data/completed/"
#BAD_DATA_FOLDER <- "/home/app_data/bad/"


DATA_FOLDER_NAME <- "data/"
COMPLETED_DATA_FOLDER <- "data/completed/"
BAD_DATA_FOLDER <- "data/bad/"

MAIN_DB <- "malariadb_dev"
TABLE_LOAD_STATS <- "load_stats"
TABLE_RECORDS_COMPLETE <- "cases_reported_complete"
TABLE_RECORDS_BAD <- "cases_reported_bad"
TABLE_ISSUES_DETAILS <- "data_issues_details"


# malaria dataset
MALARIA_REPORTED_DATA_COL_HEADERS <- c("country", "year","num_cases","num_deaths","region")
MALARIAL_REPORTED_DATA_DB_TABLE <- "reported_data"

fnReadFile <- function(file_name)
{
  print ("in fnReadFile()...")
  
  data_file_path <- paste0(DATA_FOLDER_NAME,file_name)
  print(paste("current file is: ", data_file_path))
  
  if (str_detect(file_name, ".pdf$")){
      print("processing .pdf file...")
      data <- fnReadAndProcessPdfFile(data_file_path)
      fs::file_move(data_file_path, paste0(COMPLETED_DATA_FOLDER, file_name))
      return(data)
    }
  else if (str_detect(file_name, ".csv$")){
    
      print("processing .csv file...")
      data <- fnReadMalariaData(data_file_path, MALARIA_REPORTED_DATA_COL_HEADERS)
      completed_path <- paste0(COMPLETED_DATA_FOLDER, file_name)
      print (completed_path)
      fs::file_move(data_file_path, completed_path)
      print ("done reading csv file!")
      return(data)
    }
  else{
    print( paste0( "file: ", file_name, " not a supported file type."))
    bad_data_path <- paste0(BAD_DATA_FOLDER, file_name)
    print (bad_data_path )
    fs::file_move(data_file_path, bad_data_path)
  }
}



fn_main <- function()
{
  #config <- config::get()
  
  ## db stuff
  #db_driver <- config$db_driver
  #db_name   <- config$db_name
  #db_host   <- config$db_host  
  #db_port   <- config$db_port
  #db_uid    <- config$db_userid
  #db_pwd    <- config$db_pwd
  
  #print(paste("db: ", db_driver, db_name, db_host, db_port, db_uid, db_pwd))
  
  tryCatch(
    {
      
     db_connection = createConnection("PostgreSQL", MAIN_DB, "db.postgres.dev", 5432, "postgres", "postgrespw")
     while (TRUE){
       
       data_files <- list.files(DATA_FOLDER_NAME, pattern = ".pdf|.csv")
       print(length(data_files))
      
       if (length(data_files)==0){
         print("no data found.")
        }
       else{
        for (f in data_files){
           
           data = fnExploreAndSaveStats(f, db_connection)
           print(paste("Done loading ", f, " to db."))
    
  	       # next step: verify that all data have been loaded
        }
      }
  	
      Sys.sleep(60)
      }
    },
    error=function(ex){
      print(ex)
      if (DBI::dbIsValid(db_connection)){
        fnSaveErrorToDB(ex)  
      }
      else{
        print("Unable to save error information to DB, connection object is not valid.")
      }
    },
    finally = function(){
      DBI::dbDisconnect(db_connection)
    }
    
  )
}


################################################################################
#
# entry point
#
################################################################################

result <- fn_main()

# end of file

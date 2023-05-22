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
source("malaria/data_explorer.R")
source("malaria/data_processor.R")

#DATA_FOLDER_NAME <- "/home/app_data/"
#COMPLETED_DATA_FOLDER <- "/home/app_data/completed/"
#BAD_DATA_FOLDER <- "/home/app_data/bad/"


FULL_DEBUG <- TRUE
IN_TEST_MODE <- TRUE

DATA_FOLDER_NAME <- "data/"
COMPLETED_DATA_FOLDER <- "data/completed/"
BAD_DATA_FOLDER <- "data/bad/"


# using environment variables
DB_DRIVER <- Sys.getenv("PostgresDriver")
DB_SERVER_NAME <- Sys.getenv("DBServerName")
DB_INSTANCE <- Sys.getenv("DBInstance")
DB_PORT <- Sys.getenv("DBPort")
DB_USER<- Sys.getenv("DBUsername")
DB_PASSWORD <- Sys.getenv("DBPassword")

env_info <- paste0("ENVIRONMENT INFO - db_diver: ", DB_DRIVER, " db_server: ", DB_SERVER_NAME , " port: ", DB_PORT, " db_instance: ", DB_INSTANCE, " user: ", DB_USER," pw: ", DB_PASSWORD )
if (FULL_DEBUG && IN_TEST_MODE)
  fnLogMessage(env_info)
  
  

TABLE_LOAD_STATS <- "load_stats"
TABLE_RECORDS_COMPLETE <- "cases_reported_complete"
TABLE_RECORDS_BAD <- "cases_reported_bad"
TABLE_ISSUES_DETAILS <- "data_issues_details"


ISSUE_TYPE_ERROR <- "Error"
ISSUE_TYPE_WARNING <- "Warning"


# malaria dataset
MALARIA_REPORTED_DATA_COL_HEADERS <- c("country", "year","num_cases","num_deaths","region")
MALARIAL_REPORTED_DATA_DB_TABLE <- "reported_data"

FILE_APP <- "app.R"

################################################################################
## log message
################################################################################
fnLogMessage <- function(msg){
  print(paste(Sys.time(), "-", msg))
}


################################################################################
## main
################################################################################
fnMain <- function()
{
  
  CURRENT_FUNCTION <- "fnMain()"
  
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
      while (TRUE){
       data_files <- list.files(DATA_FOLDER_NAME, pattern = ".csv")
       fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " - number of csv files found: ", length(data_files)))
      
       if (length(data_files)==0){
         fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " - no data found."))
        }
       else{
         for (f in data_files){
           fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " --------------------------------------------------------------------------"))
           fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " - processing file : ", f))
           fnProcessDataset(f)
           
           data_file_path <- paste0(DATA_FOLDER_NAME, f)
           completed_path <- paste0(COMPLETED_DATA_FOLDER, f)
           fs::file_move(data_file_path, completed_path)
           
           fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " - done loading file ", f, " to db."))
           fnLogMessage(paste0(FILE_APP, ".", CURRENT_FUNCTION, " --------------------------------------------------------------------------"))
         }
       }
       Sys.sleep(60)
      }
    },
    error=function(ex){
      error_msg <- paste(FILE_APP, ".", CURRENT_FUNCTION, " - exception :", ex)
      fnLogMessage(error_msg)
    })
}


################################################################################
#
# entry point
#
################################################################################

result <- fnMain()

# end of file




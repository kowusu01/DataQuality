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
source("malaria/utils.R")
source("malaria/data_explorer.R")
source("malaria/data_processor.R")

FILE_APP <- "app.R"

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




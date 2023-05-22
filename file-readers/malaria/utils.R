

FULL_DEBUG <- TRUE
IN_TEST_MODE <- TRUE

DATA_FOLDER_NAME <- Sys.getenv("FS_READER_DATA_PATH")
COMPLETED_DATA_FOLDER <- Sys.getenv("FS_READER_DATA_COMPLETED_PATH")
BAD_DATA_FOLDER <- Sys.getenv("FS_READER_DATA_BAD_PATH")

# using environment variables
DB_DRIVER <- Sys.getenv("PostgresDriver")
DB_SERVER_NAME <- Sys.getenv("DBServerName")
DB_INSTANCE <- Sys.getenv("DBInstance")
DB_PORT <- Sys.getenv("DBPort")
DB_USER<- Sys.getenv("DBUsername")
DB_PASSWORD <- Sys.getenv("DBPassword")


TABLE_LOAD_STATS <- "load_stats"
TABLE_RECORDS_COMPLETE <- "cases_reported_complete"
TABLE_RECORDS_BAD <- "cases_reported_bad"
TABLE_ISSUES_DETAILS <- "data_issues_details"

ISSUE_TYPE_ERROR <- "Error"
ISSUE_TYPE_WARNING <- "Warning"

# malaria dataset
MALARIA_REPORTED_DATA_COL_HEADERS <- c("country", "year","num_cases","num_deaths","region")
MALARIAL_REPORTED_DATA_DB_TABLE <- "reported_data"

################################################################################
## log message
################################################################################
fnLogMessage <- function(msg){
  print(paste(Sys.time(), "-", msg))
}

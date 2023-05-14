
fnLoadExploreAndSaveStats <- function(data_file_path, db_connection){
  # general stats
  # - number of failures
  # - separate bad data from good
  # - get stats from bad data
  # - in this case we want failures per region
  # - which column fails most
  # - we are looking for nulls
  # - mismatch 
  # 

  data_set <- fnReadFile(data_file_path)
  
  # take a look at what the result looks like
  #glimpse(data_set)
  
  #data |> head() |> gt()
  
  ISSUE_TYPE_ERROR <- "Error"
  ISSUE_TYPE_WARNING <- "Warning"
  
  
  # Add line number (record number to dataset)
  print(paste( Sys.time(), " - adding line numbers to data..."))
  data_set$record_number <- seq(1, nrow(data_set))
  glimpse(data_set)
  
  print(paste( Sys.time(), " - finding nulls in country field..."))
  country_is_na <- data_set[is.na(data_set$country), ]
  if (nrow(country_is_na) > 0){
    country_is_na <- country_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('country', nrow(country_is_na)), 
             issue_type=rep(ISSUE_TYPE_ERROR, nrow(country_is_na)), 
             issue=rep('country is null', nrow(country_is_na)))
  }
  
  print (paste( Sys.time(), " - finding nulls in year field...."))
  year_is_na <- data_set[is.na(data_set$year), ]
  if (nrow(year_is_na) > 0){
    year_is_na <- year_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('year', nrow(year_is_na)), 
             issue_type=rep(ISSUE_TYPE_ERROR, rnow(year_is_na)), 
             issue=rep('year is null', nrow(year_is_na)))
  }
  
  print(paste( Sys.time(), " - finding nulls in num_cases field..."))
  numcases_is_na <- data_set[is.na(data_set$num_cases), ]
  if (nrow(numcases_is_na) > 0){
    numcases_is_na <- numcases_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('num_cases', nrow(numcases_is_na)), 
             issue_type=rep(ISSUE_TYPE_ERROR, nrow(numcases_is_na)), 
             issue=rep('num_cases is null', nrow(numcases_is_na)))
  }
  
  print (paste( Sys.time(), " - finding nulls in num_deaths field..."))
  numdeaths_is_na <- data_set[is.na(data_set$num_deaths), ]
  if (nrow(numdeaths_is_na) > 0){
    numdeaths_is_na <- numdeaths_is_na %>% select(record_number)  %>% 
      mutate(column_name=rep('num_deaths', nrow(numdeaths_is_na)), 
             issue_type=rep(ISSUE_TYPE_ERROR, nrow(numdeaths_is_na)), 
             issue=rep('num_death is null', nrow(numdeaths_is_na)))
  }
  
  print (paste( Sys.time(), " - finding null in region field..."))
  region_is_na <- data_set[is.na(data_set$region), ]
  if (nrow(region_is_na) > 0){
    region_is_na <- region_is_na %>% select(record_number)  %>% 
      mutate(column_name=rep('region', nrow(region_is_na)), 
             issue_type=rep(ISSUE_TYPE_ERROR, nrow(region_is_na)), 
             issue=rep('region is null', nrow(region_is_na) ))
  }
  
  print(paste( Sys.time(), " - finding inconsistent data..."))
  data_set_complete_cases <- data_set[complete.cases(data_set), ]
  deaths_more_than_cases <- data_set_complete_cases %>% filter(num_deaths > num_cases)
  if (nrow(deaths_more_than_cases) > 0){
    deaths_more_than_cases <- deaths_more_than_cases %>% select(record_number)  %>% 
      mutate(column_name=rep('num_deaths', nrow(deaths_more_than_cases)), 
             issue_type=rep(ISSUE_TYPE_WARNING, nrow(deaths_more_than_cases)), 
             issue=rep('num_deaths is greater than num_cases', nrow(deaths_more_than_cases)))
  }
  
  print("-------------- nulls in country column ----------------")
  glimpse(country_is_na)
  print("-----------------------------------------")
  
  print("-------------- nulls in year---------------------------")
  glimpse(year_is_na)
  print("-----------------------------------------")
  
  
  print("------------- nulls in num cases column ----------------------------")
  glimpse(numcases_is_na)
  print("-----------------------------------------")
  
  
  print("-------------- nulls in num death column---------------------------")
  glimpse(numdeaths_is_na)
  print("-----------------------------------------")
  
  issues_details <- data.frame()

  print (paste( Sys.time(), " - creating issues details dataset"))
  
  # attempt to add list of country field errors
  if (nrow(country_is_na) > 0)
    issues_details <- issues_details %>% rbind(country_is_na)
  
  # attempt to add list of nulls in year column
  if (nrow(year_is_na))
    issues_details <- issues_details %>% rbind(year_is_na)
  
  # errors in deaths column
  if(nrow(numcases_is_na))
    issues_details <- issues_details %>% rbind(numcases_is_na)
  
  # errors in deaths column
  if(nrow(numdeaths_is_na))
    issues_details <- issues_details %>% rbind(numdeaths_is_na)
  
  # errors in region column
  if(nrow(region_is_na))
      issues_details <- issues_details %>% rbind(region_is_na)
    
  # warning for inconsistent between numcases and num deaths
  if (nrow(deaths_more_than_cases) > 0)
    issues_details <- issues_details %>% rbind(deaths_more_than_cases)
    
  #issues_details <- country_is_na %>% 
  #  rbind(year_is_na) %>% 
  #  rbind(numcases_is_na) %>% 
  #  rbind(numdeaths_is_na) %>%
  #  rbind(region_is_na)
  
  num_errors <- nrow(country_is_na) + 
    nrow(year_is_na) + 
    nrow(year_is_na) +
    nrow(numcases_is_na) +
    nrow(numdeaths_is_na) + 
    nrow(region_is_na)

  num_warnings <- nrow(deaths_more_than_cases)
  
  print (paste( Sys.time(), " - analysis completed, creating dataset for db..."))

  # is we get this point it means the data load was successful
  final_load_status <- 'Success'
  #err_message - NA
  
  basic_stats <- data.frame(
    descr = c(paste("csv load for", data_file_path)),
    load_timestamp = c( now() ),
    file_path = c(data_file_path),
    load_status = final_load_status,
    num_records = c(nrow(data_set)),
    bad_data_count = c(num_errors),
    warning_data_count = c(num_warnings)
    #error_message = c(err_message)
  )
  
  print (paste( Sys.time(), " - Done creating datasets, attempting to save to db"))
  
  print(paste( Sys.time(), " - saving basic stats"))
  glimpse(basic_stats)
  fnSaveDataInDatabase(basic_stats, TABLE_LOAD_STATS, db_connection)
  
  # load the load_id record just saved
  df <- dbGetQuery(db_connection, paste0("SELECT id from load_stats where file_path='", data_file_path, "'") )
  load_ids <- rep(df[1,1], nrow(data_set_complete_cases))
  load_id_df <- data.frame(load_id=c(load_ids))
  data_set_complete_cases <- load_id_df %>% cbind(data_set_complete_cases)
  
  print (paste(Sys.time(), " - saving good data..."))
  glimpse(data_set_complete_cases)
  fnSaveDataInDatabase(data_set_complete_cases, TABLE_RECORDS_COMPLETE, db_connection)

  print (paste(Sys.time(), " - saving bad data..."))
  bad_data <- data_set[!complete.cases(data_set), ]
  load_ids <- rep(df[1,1], nrow(bad_data))
  load_id_df <- data.frame(load_id=c(load_ids))
  bad_data <- load_id_df %>% cbind(bad_data)
  glimpse(bad_data)
  fnSaveDataInDatabase(bad_data, TABLE_RECORDS_BAD, db_connection)
  
  print (paste( Sys.time(), " - saving issues detail..."))
  load_ids <- rep(df[1,1], nrow(issues_details))
  load_id_df <- data.frame(load_id=c(load_ids))
  issues_details <- load_id_df %>% cbind(issues_details)
  glimpse(issues_details)
  fnSaveDataInDatabase(issues_details, TABLE_ISSUES_DETAILS, db_connection)
  
}

fnSaveDataInDatabase <- function(data_set, db_table, db_connection)
{
  
  #https://stackoverflow.com/questions/33634713/rpostgresql-import-dataframe-into-a-table
  
  
  dbWriteTable(db_connection, db_table, data_set, row.names=FALSE, append=TRUE)
  
  
  # dbWriteTable(con, "MyTable", df, row.names=FALSE, append=TRUE)
  #df <- dbGetQuery(db_connection, "SELECT * FROM env_info")
  #df
  #df <- dbGetQuery(db_connection, paste("SELECT COUNT(*) FROM ", TABLE_LOAD_STATS) )
  #df
  # other commands
  # sbSendQuery(con, "insert into table...")
}

fnSaveErrorToDB <- function(data_file_path, ex, db_table, db_connection){
  
  if(DBI::dbIsValid(db_connection)){
    print("saving error message to db...")  
    
    error_stats <- data.frame(
      descr = c(paste("csv load for", data_file_path)),
      load_timestamp = c( now() ),
      file_path = c(data_file_path),
      load_status = "Error",
      num_records = c(0),
      bad_data_count = c(0),
      warning_data_count = c(0),
      error_message = c(ex)
    )
    dbWriteTable(db_connection, db_table, error_stats, row.names=FALSE, append=TRUE)
    
  }
  else{
    print("unable to save error information to db.")
  }
}
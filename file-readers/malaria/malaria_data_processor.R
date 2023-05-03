
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

  data_set <- fnReadFile(f)
  
  # take a look at what the result looks like
  #glimpse(data_set)
  
  #data |> head() |> gt()
  
  
  # Add line number (record number to dataset)
  print("adding line numbers to data...")
  data$record_number <- seq(1, nrow(data_set))
  glimpse(data_set)
  
  print("finding nulls in country field...")
  country_is_na <- data_set[is.na(data_set$country), ]
  if (nrow(country_is_na) > 0){
    country_is_na <- country_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('country', nrow(country_is_na)), issue=rep('country is null', nrow(country_is_na)))
  }
  
  print ("finding nulls in year field....")
  year_is_na <- data_set[is.na(data_set$year), ]
  if (nrow(year_is_na) > 0){
    year_is_na <- year_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('year', nrow(year_is_na)), issue=rep('year is null', nrow(year_is_na)))
  }
  
  print("finding nulls in num_cases field...")
  numcases_is_na <- data_set[is.na(data_set$num_cases), ]
  if (nrow(numcases_is_na) > 0){
    numcases_is_na <- numcases_is_na %>% select(record_number) %>% 
      mutate(column_name=rep('num_cases', nrow(numcases_is_na)), issue=rep('num_cases is null', nrow(numcases_is_na)))
  }
  
  print ("finding nulls in num_deaths field...")
  numdeaths_is_na <- data_set[is.na(data_set$num_deaths), ]
  if (nrow(numdeaths_is_na) > 0){
    numdeaths_is_na <- numdeaths_is_na %>% select(record_number)  %>% 
      mutate(column_name=rep('num_deaths', nrow(numdeaths_is_na)), issue=rep('num_death is null', nrow(numdeaths_is_na)))
  }
  
  print ("finding null in region field...")
  region_is_na <- data_set[is.na(data_set$region), ]
  if (nrow(region_is_na) > 0){
    numdeaths_is_na <- numdeaths_is_na %>% select(record_number)  %>% 
      mutate(column_name=rep('region', nrow(region_is_na)), issue=rep('region is null', nrow(region_is_na) ))
  }
  
  print("finding inconsistent data...")
  data_set_complete_cases <- data_set[complete.cases(data_set), ]
  deaths_more_than_cases <- data_set_complete_cases %>% filter(num_deaths > num_cases)
  if (nrow(deaths_more_than_cases) > 0){
    deaths_more_than_cases <- deaths_more_than_cases %>% select(record_number)  %>% 
      mutate(column_name=rep('num_deaths', nrow(deaths_more_than_cases)), 
             issue=rep('num_deaths is greater than num_cases', nrow(deaths_more_than_cases)))
  }
  
  print ("creating bad dataset")
  issues_details<- country_is_na %>% rbind(year_is_na) %>% rbind(numcases_is_na) %>% rbind(numdeaths_is_na) %>% rbind(region_is_na)
  num_errors <- nrow(country_is_na) + 
    nrow(year_is_na) + 
    nrow(year_is_na) +
    nrow(numcases_is_na) +
    nrow(numdeaths_is_na) + 
    nrow(region_is_na)

  num_warnings <- nrow(deaths_more_than_cases)
  
  print ("analysis completed, creating dataset for db...")

  # is we get this point it means the data load was successful
  is_success <- 'true'
  #err_message - NA
  
  basic_stats <- data.frame(
    descr = c("test load 1"),
    load_timestamp = c( now() ),
    file_path = c(data_file_path),
    completed = c(is_success),
    num_records = c(nrow(data_set)),
    bad_data_count = c(num_errors),
    warning_data_count = c(num_warnings)
    #error_message = c(err_message)
  )
  
  
  print ("Done creating datasets, attempting to save to db")
  
  print("saving basic stats")
  glimpse(basic_stats)
  fnSaveDataInDatabase(basic_stats, TABLE_LOAD_STATS, db_connection)
  
  # load the load_id record just saved
  df <- dbGetQuery(db_connection, paste0("SELECT load_id from load_stats where file_path='", data_file_path, "'") )
  load_ids <- rep(df[1,1], nrow(data_set_complete_cases))
  load_id_df <- data.frame(load_id=c(load_ids))
  data_set_complete_cases <- load_id_df %>% cbind(data_set_complete_cases)
  
  print ("saving good data...")
  glimpse(data_set_complete_cases)
  fnSaveDataInDatabase(data_set_complete_cases, TABLE_RECORDS_COMPLETE, db_connection)

  
  print ("saving bad data...")
  bad_data <- data_set[!complete.cases(data_set), ]
  load_ids <- rep(df[1,1], nrow(bad_data))
  bad_data <- load_id_df %>% cbind(bad_data)
  glimpse(bad_data)
  fnSaveDataInDatabase(bad_data, TABLE_RECORDS_BAD, db_connection)
  
  
  print ("saving issues detail...")
  load_ids <- rep(df[1,1], nrow(issues_details))
  load_id_df <- data.frame(load_id=c(load_ids))
  issues_details <- load_id_df %>% cbind(issues_details)
  glimpse(issues_details)
  fnSaveDataInDatabase(issues_details, TABLE_ISSUES_DETAILS, db_connection)
  
  #print ("Done saving all !!")

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

fnSaveErrorToDB <- function(ex, db_connection){
  
  if(DBI::dbIsValid(db_connection)){
    print("saving error message to db...")  
  }
}
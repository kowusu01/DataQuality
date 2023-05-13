

fnReadMalariaData <- function(csv_data_path, col_headers){
  
  csv_data <- fread(csv_data_path, col.names = col_headers)
  return(csv_data)
  
  #tryCatch( 
  #  {
  #    #csv_data <- read.csv(csv_data_path, col.names = col_headers)
  #    csv_data <- fread(csv_data_path, col.names = col_headers)
  #    return(csv_data)
      
  #  },
  #  error=function(e) {
  #    message("Error reading csv file")
  #    print(e)
  #    return(NA)
  #  },
  #  warning=function(w) {
  #    message("Warning reading csv file")
  #    print(w)
  #    return(NA)
  #  }
  #)
}


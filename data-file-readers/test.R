

source("csv_reader.R")
fn_main <- function()
{
  print("hello")
}


tryCatch(
  
  # call main 
  fn_main(),
  error=function(e) {
    message("Error creating connection")
    print(e)
  }
  
)
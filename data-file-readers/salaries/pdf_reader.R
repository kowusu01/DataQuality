
################################################################################
##
## process each page in the pds
## - each row of data is a single string 
## - the idea is to create separate regex expressions targeting each column of data
## - then combine all the regex to form a single expression to execute

fnProcessPdfPage <- function(pdfPage){
  
  # convert the data to a table
  dt <- as.data.frame(pdfPage)
  
  # the resulting table from above statement has one column
  # change the column name to "data"
  source_col <- c("data")
  
  data <- pdfPage |> 
    str_trim() |>
    str_replace_all("\\$", "") |>
    str_replace_all("\\,", "") |>
    str_split("\\s{2,}", simplify = TRUE)
}



################################################################################
## processing
################################################################################
fnReadAndProcessPdfFile <- function(data_path){
  
  # load pdf
  pdf <- pdf_text(data_path)
  
  # the pdf data is loaded as long string with pages separated by "\n"
  # we can break the entire document into pages by splitting the data by "\n"
  pdf <- pdf %>% str_split("\n")
  
  # each pdf page contains separate lines each line representing a row of data
  # we process each page, converting each page into a DataFrame, 
  # each line becomes a  rows with columns
  # after this call, we will have a list of dataframes corresponding to the number
  # of pages in the pdf
  listDataFrames <- lapply(pdf, fnProcessPdfPage)
  
  str(listDataFrames)
  
  # merge all to one dataframe
  data <- data.frame(do.call(rbind, listDataFrames))
  colnames(data) <- c("name", "dept", "title", "salary")
  data <- data[-1,] |> mutate(across(c("salary"), as.double))
  
  data[complete.cases(data), ]
  
}

# end of file


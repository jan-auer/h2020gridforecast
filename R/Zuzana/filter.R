library(tidyverse)

#calculate maximum zero sequence length for each time series and return indices of time series that fulfill our criteria

filterdata <- function(train_all, adapt_all, max_zero_length = 120){
  max_length <- numeric(ncol(train_all)-1)

  
  #calculate maximum zero sequence length for each time series
  for (i in 1:(ncol(train_all)-1)){
    full_data <- c(train_all[[i]], adapt_all[[i]])
    zero_length <- rle(full_data == 0)
    max_length[i] <- max(zero_length$lengths[zero_length$values == TRUE])
  }
  
  #create table with numbers of all time series and their maximum zero lengths
  #remove those time series where the max zero length is less than a given parameter
  #get a table with the indices of time series that fulfill requirements and their max zero sequence length
  x <- seq(1:(ncol(train_all)-1))
  table <- data.frame(x, max_length)
  colnames(table) <- c("timeseries","maxsequencelength")
  non_zero_time_series <- table %>% filter(maxsequencelength <= max_zero_length)

  return (non_zero_time_series)
}

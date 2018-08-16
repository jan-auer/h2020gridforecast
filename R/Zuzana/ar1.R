library(tidyverse)

#creates an autoregressive model and returns scaled errors

arerrors <- function(filtered_training_data, filtered_test_data){
  
  entries_in_one_month <- 12*24*30  
  results <- numeric(nrow(filtered_test_data));
  ar1errors <- numeric(ncol(filtered_test_data));
  ar1scaled_errors <- numeric(ncol(filtered_test_data));
  
  #run through each time series
  #create a vector combining last month of training data with the test data
  #pick first month of combined vector
  for(i in seq(1, ncol(filtered_training_data), 1)){
    training_data <- (filtered_training_data[[i]])
    test_data <- (filtered_test_data[[i]])
    one_month <- window(training_data, start = nrow(filtered_training_data)-entries_in_one_month)
    full_data <- c(one_month, test_data)
    last_month <- head(full_data, entries_in_one_month)
    
    #forecast 12 steps ahead, save result
    for (t in seq(13, nrow(filtered_test_data), 12)){
      x <- t - 12
      y <- t - 1
      result <- predict(ar(last_month), n.ahead = 12)
      results[x:y] <- result$pred
      new_data <- window(full_data, start = t)
      last_month <- head(new_data, entries_in_one_month)
      
    }
    
    #calculate rolling msfe and save last rolling msfe entry for each time series into scaled_errors vector 
    ar1rolling_msfe <- cummean(((test_data - results)^2))
    ar1errors[i] <- ar1rolling_msfe[nrow(adapt_all)]
    ar1scaled_errors[i] <- ar1errors[i] / sd(training_data)
    
  }
  
  return (ar1scaled_errors)
  
}


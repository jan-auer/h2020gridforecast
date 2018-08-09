library(tidyverse)

#creates an autoregressive model with a set maximum parameter (default: 24) and returns scaled errors

arimaerrorswithsetparameter <- function(filtered_training_data, filtered_test_data, ar_parameter=24){

entries_in_one_month <- 12*24*30  
results <- numeric(nrow(filtered_test_data));
ar2errors <- numeric(ncol(filtered_test_data));
ar2scaled_errors <- numeric(ncol(filtered_test_data));

#run through each time series
#create a vector combining last month of training data with the test data
#pick first month of combined vector
for(i in seq(1,ncol(filtered_training_data), 1)){
  training_data <- (filtered_training_data[[i]])
  test_data <- (filtered_test_data[[i]])
  one_month <- window(training_data, start = nrow(filtered_training_data)-entries_in_one_month)
  full_data <- c(one_month, test_data)
  last_month <- head(full_data, entries_in_one_month)
  
  #forecast 12 steps ahead with max order arparameter, save result
  for (t in seq(13, nrow(filtered_test_data), 12)){
    x <- t - 12
    y <- t - 1
    result <- predict(ar(last_month, aic = FALSE, order.max = arparameter), n.ahead = 12)
    results[x:y] <- result$pred
    datanew <- window(full_data, start = t)
    last_month <- head(datanew, entries_in_one_month)
    
  }
  
  #calculate rolling msfe and save last rolling msfe entry for each time series into scaled_errors vector 
  ar2rolling_msfe <- cummean(((test_data - results)^2))
  ar2errors[i] <- ar2rolling_msfe[nrow(adapt_all)]
  ar2scaled_errors[i] <- ar2errors[i] / sd(training_data)
  
}

return (ar2scaled_errors)
}
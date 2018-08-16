library(tidyverse)

# create a naive model for the data and return scaled errors

naiveerrors <- function(filtered_training_data, filtered_test_data){
  
  results <- numeric(nrow(filtered_test_data));
  errors <- numeric(ncol(filtered_test_data));
  scaled_errors <- numeric(ncol(filtered_test_data));
  
  # go through each time series, combine last 12 entries of training data (=one hour) with test data
  for(i in seq(1, ncol(filtered_test_data), 1)){
    training_data <- (filtered_training_data[[i]])
    test_data <- (filtered_test_data[[i]])
    last_hour <- tail(training_data, n = 12)
    our_data <- c(last_hour, test_data)
  
    #calculate mean value of each hour to predict next hour  
    for(t in seq(1, nrow(filtered_test_data)-11, 12)){
      vector <- seq(0:11)
      new_vector <- vector + t
      medium <- (sum(our_data[new_vector])) / 12
      results[seq(t, t + 11)] <- rep(medium, 12)
    }
    #calculate rolling msfe and save last rolling msfe entry for each time series into scaled_errors vector 
    rolling_msfe <- cummean(((test_data - results)^2))
    errors[i] <- rolling_msfe[nrow(filtered_test_data)]
    scaled_errors[i] <- errors[i] / sd(training_data)
  }
  
  return (scaled_errors)
}

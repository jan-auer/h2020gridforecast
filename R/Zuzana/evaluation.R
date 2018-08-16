# set parameters
train_all <- readRDS("/home/datascience/local_data/train_all.rds")
adapt_all <- readRDS("/home/datascience/local_data/adapt_all.rds")
max_zero_length <- 120
arparameter <- 24
use_preloaded_data <- TRUE

# load libraries
library(ggplot2)

# load functions
source(file = "transform.R")
source(file = "filter.R")
source(file = "filter_training_data.R")
source(file = "filter_test_data.R")
source(file = "naive.R")
source(file = "ar1.R")
source(file = "ar2.R")
source(file = "whichmodelisbest.R")

# check whether file exists
if (file.exists(file = "../../../local_data/filtered_data.Rds")==TRUE){
  filtered_timeseries_indices <- readRDS(file = "../../../local_data/filtered_data.Rds")
} else {
  # transform input data
  train_all <- transformdata(train_all)
  adapt_all <- transformdata(adapt_all)
  
  #calculate maximum zero sequence length for each time series and return indices of time series that fulfill our criteria
  filtered_timeseries_indices<-filterdata(train_all, adapt_all, max_zero_length)
  
  # same as new object  
  saveRDS(object = filtered_timeseries_indices, file = "../../../local_data/filtered_data.Rds")
}  

# remove time series that are constantly zero for more than 10 hours
filtered_training_data <- filtertrainingdata(train_all, filtered_timeseries_indices)
filtered_test_data <- filtertestdata(adapt_all, filtered_timeseries_indices)

# create a naive model for the data and return scaled errors
naive_errors <- naiveerrors(filtered_training_data, filtered_test_data)

# create two autoregressive models for the data and return scaled errors
ar_errors <- arerrors(filtered_training_data, filtered_test_data)
ar_errors_with_set_parameter <- arerrorswithsetparameter(filtered_training_data, filtered_test_data, arparameter)

#return vector showing which model is best for each time series and plot results
best_model <- bestmodel(naive_errors, ar_errors, ar_errors_with_set_parameter)

#evaluate results
naive_percentage <- (sum(best_model == 1) / length(best_model)) * 100
ar_percentage <- (sum(best_model == 2) / length(best_model)) * 100
ar_with_parameter_percentage <- (sum(best_model == 3) / length(best_model)) * 100

sprintf("The naive model was better %s percent of times", naive_percentage)
sprintf("The ar model was better %s percent of times", ar_percentage)
sprintf("The ar model with a maximum order was better %s percent of times", ar_with_parameter_percentage)


#plot results
x <- seq(1:length(naive_errors))
error_table <- data.frame(naive_errors, ar_errors, ar_errors_with_set_parameter)
errors_for_plot <- data.frame(x, log(error_table))
matplot(errors_for_plot[, 1], errors_for_plot[, 2:4],  type="l", main="Errors Plot", xlab="Time Series", ylab="Errors")    
grid()  

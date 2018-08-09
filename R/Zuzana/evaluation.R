# set parameters
train_all <- readRDS("/home/datascience/local_data/train_all.rds")
adapt_all <- readRDS("/home/datascience/local_data/adapt_all.rds")
max_zero_length <- 120
arparameter <- 24
use_preloaded_data <- TRUE

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
  
  # remove time series that are constantly zero for more than 10 hours
  filtered_training_data <- filtertrainingdata(train_all, filtered_timeseries_indices)
  filtered_test_data <- filtertestdata(adapt_all, filtered_timeseries_indices)
  
  # same as new object  
  saveRDS(object = filtered_timeseries_indices, file = "../../../local_data/filtered_data.Rds")
}


# create a naive model for the data and return scaled errors
naive_errors <- naiveerrors(filtered_training_data, filtered_test_data)

# create two autoregressive models for the data and return scaled errors
arima_errors <- arimaerrors(filtered_training_data, filtered_test_data)
arima_errors_with_set_parameter <- arimaerrorswithsetparameter(filtered_training_data, filtered_test_data, arparameter)

#return vector showing which model is best for each time series and plot results
best_model <- bestmodel(naive_errors, arima_errors, arima_errors_with_set_parameter)

#commit
#slack
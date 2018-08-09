library(tidyverse)

#filter training data by given indices

filtertrainingdata <- function(train_all, filtered_timeseries_indices){

indices <- filtered_timeseries_indices$timeseries
filtered_training_data <- train_all[indices]

return (filtered_training_data)
}


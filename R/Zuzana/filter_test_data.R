library(tidyverse)

#filter training data by given indices

filtertestdata <- function(adapt_all, filtered_timeseries_indices){

indices <- filtered_timeseries_indices$timeseries
filtered_test_data <- adapt_all[indices]

return (filtered_test_data)
}
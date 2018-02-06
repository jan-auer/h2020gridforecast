library(hdf5r)
library(reshape2)
library(ggplot2)
library(dplyr)
library(scales)

### General data configuration
datasets <- list(
  train = list(
    path = 'notebook/See4C_starting_kit/sample_data/train/Xm1/',
    min_file_id = 1,
    max_file_id = 289
  ),
  adapt = list(
    path = 'notebook/See4C_starting_kit/sample_data/adapt/',
    min_file_id = 0,
    max_file_id = 68
  )
)
total_number_of_lines <- 1916

### Get time series for one or more power lines in form of a data.frame
get_power_lines <- function(
  ids = c(), 
  dataset = "train"
) {
  if(length(ids) == 0) {
    ids = 1:total_number_of_lines
  }
  power_lines <- data.frame(matrix(nrow = 0, ncol = (length(ids) + 1)))
  colnames(power_lines) <- c(ids, "timestamp")
  for(file_id in datasets[[dataset]]$min_file_id:datasets[[dataset]]$max_file_id) {
    print(paste("file", file_id, "of", (1 + datasets[[dataset]]$max_file_id - datasets[[dataset]]$min_file_id)))
    filename <- paste0(datasets[[dataset]]$path, "X", file_id, ".h5")
    file <- H5File$new(filename, mode="r")

    # Extract the relevant data
    X <- file[["X/value/X/value"]]
    t <- file[["X/value/t/value"]]
    power_lines_to_add <- t(X[1,ids,])
    power_lines_to_add <- data.frame(cbind(power_lines_to_add, t[1,]))
    colnames(power_lines_to_add) = c(ids, "timestamp")

    file$close_all()
    
    power_lines <- rbind(power_lines, power_lines_to_add)
  }
  return(power_lines)
}

convert_and_save_power_lines <- function(
  ids = c(), 
  dataset = "train", 
  target = "/home/datascience/h2020_grid_forecast/R_data/",
  designation = ""
) {
  power_lines <- get_power_lines(ids = ids, dataset = dataset)
  if(designation == ""){
    if(length(ids) == 0) {
      designation = "all"
    } else {
      designation = paste0(ids, collapse = '_')
    }
  }
  saveRDS(
    object = power_lines, 
    file = paste0(target, dataset, "_", designation, ".rds")
  )
}

### TRYING OUT THE CODE ###

# Inspect recursively the content of the hdf5 file
# file$ls(recursive = TRUE)
# file[["X/value"]]$ls(recursive = TRUE)

# ids = c(1, 3, 123)

# power_lines_test <- get_power_lines(ids = ids, dataset = "adapt")
# power_lines_test$timestamp <- as.POSIXct(power_lines_test$timestamp, origin = "1970-01-01")
# power_lines_test_long <- melt(power_lines_test, id="timestamp")

# Plotting
# ggplot(data=power_lines_test_long,
#        aes(x=timestamp, y=value, colour=variable)) + 
#   geom_line()

# Saving
# convert_and_save_power_lines(ids = ids, dataset = "adapt")

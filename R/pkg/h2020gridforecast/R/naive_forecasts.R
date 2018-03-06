#' Persistence forecast
#' 
#' Takes the last measured value and use them as a constant forecast.
#'
#' @param history Data.frame. Rows are timestamps, columns are power lines.
#' @param start Integer. Unix timestamp of the first forecast time.
#' @param horizon Integer. Number of timesteps to forecast.
#'
#' @return Data.frame. Rows are timestamps, columns are power lines.
#' @export
persistence_forecast <- function(history, start, horizon = 1) {
  fc <- history %>% filter(timestamp == max(history$timestamp)) %>% select(-timestamp)
  fc <- fc[rep(1, horizon), ]
  fc$timestamp <- start + 0:(horizon - 1) * 300
  return(fc)
}

#' Averaged forecast
#' 
#' Takes the average of the last average_period many measured value and use them as a constant forecast.
#'
#' @inheritParams persistence_forecast
#' @param average_period Integer. Number of last observations for which values should be averaged.
#'
#' @return Data.frame. Rows are timestamps, columns are power lines.
#' @export
averaged_forecast <- function(history, start, horizon = 1, average_period = 3) {
  fc <- history %>% arrange(timestamp) %>% select(-timestamp)
  fc <- fc[(dim(fc)[1] - average_period + 1):dim(fc)[1],]
  fc <- matrix(colMeans(fc), nrow = 1)
  fc <- data.frame(fc[rep(1, horizon),])
  fc$timestamp <- start + 0:(horizon - 1) * 300
  return(fc)
}

#' Forecast with last day's values
#'
#' @inheritParams persistence_forecast
#'
#' @return Data.frame. Rows are timestamps, columns are power lines.
#' @export
copy_last_day <- function(history, start, horizon = 1) {
  history$timestamp = history$timestamp + 24*60*60
  return(history %>% filter(timestamp >= start, timestamp <= (start + (horizon - 1) * 60 * 5)))
}

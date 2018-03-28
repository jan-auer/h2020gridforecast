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
  if (horizon == 1) {
    fc <- t(fc)
  }
  fc$timestamp <- start + 0:(horizon - 1) * 300
  return(fc)
}

#' Moving Average forecast (MA[k])
#' 
#' Forecasts with the average value of a window with size k.
#' 
#' @inheritParams averaged_forecast
#' 
#' @return Data.frame Rows are timestamps, columns are power lines
#' @export
moving_average <- function(history, start, horizon = 1, average_period = 3) {
  last_row_number <- dim(history)[1]
  for (i in 1:horizon) {
    history <- rbind(
      history,
      averaged_forecast(
        history = history, 
        start = max(history$timestamp) + 300, 
        horizon = 1,
        average_period = average_period
      )
    )
    last_row_number <- last_row_number + 1
  }
  return(history[(last_row_number - horizon + 1):last_row_number,])
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

#' Evaluates forecasts with RMSE
#' 
#' The RMSE is the root mean square error. The function tests whether dimensions and 
#' timestamps are equal for forecast and actual. If this is not the case, NaN will be
#' returned
#'
#' @param forecast Data.frame. Rows are timestamps, columns are power lines.
#' @param actual Data.frame. Rows are timestamps, columns are power lines.
#'
#' @return Double. RMSE over all forecast steps, horizons and power lines.
#' @export
rmse <- function(forecast, actual) {
  if(min(dim(forecast) == dim(actual)) && min(forecast$timestamp == actual$timestamp)) {
    return(sqrt(1/(dim(forecast)[1] * dim(forecast)[2]) * sum((forecast - actual) ** 2)))
  } else {
    return(NaN)
  }
}

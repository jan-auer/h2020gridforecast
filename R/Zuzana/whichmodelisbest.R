bestmodel <- function(naive_errors, ar_errors, ar_errors_with_set_parameter){

  #prints vector showing which model is best for each time series
  error_table <- data.frame(naive_errors, ar_errors, ar_errors_with_set_parameter)
  colnames(error_table) <- c("naive", "ar", "arwithmaxorder")
  best_model <- apply(error_table, 1, function(x) which(x == min(x, na.rm = TRUE)))
  
  return (best_model)
}

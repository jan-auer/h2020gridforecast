library(ggplot2)

bestmodel <- function(naive_errors, arima_errors, arima_errors_with_set_parameter){

#prints vector showing which model is best for each time series
error_table <- data.frame(scaled_errors, ar1scaled_errors, ar2scaled_errors)
colnames(error_table) <- c("naive", "ar", "arwithmaxorder")
best_model <- apply(error_table, 1, function(x) which(x == min(x, na.rm = TRUE)))

#plots results
x <- seq(1:length(scaled_errors))
errors_for_plot <- data.frame(x, error_table)
colnames(errors_for_plot) <- c("timeseries", "naive", "ar", "arwithmaxorder")
ggplot(errors_for_plot,
       aes(y = naive, x = timeseries)) +
  geom_point()

return (best_model)

}
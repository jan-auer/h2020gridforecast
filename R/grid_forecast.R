library(h2020gridforecast)
library(dplyr)
source(file = "config.R")

train_all <- readRDS(file = "../../local_data/train_all.rds")
adapt_all <- readRDS(file = "../../local_data/adapt_all.rds")

evaluate <- function(target, aux, start, horizon, steps, forecast_function) {
  overall_forecast <- target[c(), ]
  for(i in 1:steps){
    print(paste("### step", i, "of", steps, "###"))
    forecast <- do.call(
      what = forecast_function,
      args = list(
        history = target %>% filter(timestamp < (start + (i - 1) * horizon)),
        start = start + 300 * ((i - 1) * horizon), 
        horizon = horizon
      )
    )
    colnames(forecast) <- colnames(overall_forecast)
    overall_forecast <- bind_rows(overall_forecast, forecast)
  }
  return(overall_forecast)
}

overall_forecast = evaluate(
  target = bind_rows(train_all, adapt_all), 
  aux = NULL, 
  start = 1278007500, 
  horizon = 12, 
  steps = 4,
  forecast_function = "averaged_forecast"
)

rmse(
  forecast = overall_forecast %>% select(-timestamp),
  actual = adapt_all[1:(number_of_steps * horizon),] %>% select(-timestamp)
)


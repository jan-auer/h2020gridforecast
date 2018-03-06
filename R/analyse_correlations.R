library(h2020gridforecast)
library(dplyr)
source(file = "config.R")

train_all <- readRDS(file = "../../local_data/train_all.rds")
aux_opsd_15_train_not_NaN <- readRDS(file = '../../local_data/aux_opsd_15_train_not_NaN.rds')

wind_50Hz_fc_cors <- unlist(lapply(1:1916, function (x) cor(aux_opsd_15_train_not_NaN$DE_50hertz_wind_forecast, (train_all %>% pull(x))[0:105048 %% 3 == 0][1:11750])))
wind_50Hz_gen_cors <- unlist(lapply(1:1916, function (x) cor(aux_opsd_15_train_not_NaN$DE_50hertz_wind_generation, (train_all %>% pull(x))[0:105048 %% 3 == 0][1:11750])))
wind_Ampr_fc_cors <- unlist(lapply(1:1916, function (x) cor(aux_opsd_15_train_not_NaN$DE_amprion_wind_forecast, (train_all %>% pull(x))[0:105048 %% 3 == 0][1:11750])))
wind_Ampr_gen_cors <- unlist(lapply(1:1916, function (x) cor(aux_opsd_15_train_not_NaN$DE_amprion_wind_generation, (train_all %>% pull(x))[0:105048 %% 3 == 0][1:11750])))

summary(wind_Ampr_gen_cors)
hist()

# Analyse correlations
i <- 1916
grid <- expand.grid(x = 1:i, y = 1:i)
cors_sign <- matrix(unlist(lapply(
  1:(i*i), 
  function(x) {
    if(grid[x,1] > grid[x,2]) {
      return(cor(train_all_sign %>% pull(grid[x,1]), train_all_sign %>% pull(grid[x,2])))
    } else {
      return(0)
    }
  }
)), nrow = i)
saveRDS(object = cors_sign, file = "eda/cors_sign.Rds")

which(cors == max(cors, na.rm = TRUE), arr.ind = TRUE)
which(cors == min(cors, na.rm = TRUE), arr.ind = TRUE)

data <- train_all %>% select(timestamp, 73, 72)
data_long <- melt(data = data, id.vars = 'timestamp')
ggplot(data = data_long, mapping = aes(x = timestamp, y = value, colour = variable)) + geom_line()

plot(train_all$`96`, type = "l")
lines(train_all$`96` - train_all$`94`, type="l", col = "red")

plot(train_all$`72`, type = "l")
lines(train_all$`72` + train_all$`73`, type="l", col = "red")



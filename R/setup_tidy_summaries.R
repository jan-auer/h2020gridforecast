# tidy setup:
#
# Starts from transformed data in datascience/local_data and 
# transforms them to tibbles with list columns in order to calculate some aggregates

library(tidyverse)
train_all <- readRDS("/home/datascience/local_data/train_all.rds")

my_names <- paste0("V", names(train_all)[-1917])
names(train_all) <- c(my_names, "time_stamp")

train_all <- train_all %>% 
  mutate(time_stamp = as.POSIXct(time_stamp, origin = "1970-01-01")) %>% as_tibble()

train_all_nested <- train_all %>% 
  select(-time_stamp) %>% 
  gather() %>% 
  group_by(key) %>% 
  nest()

train_all_nested <- train_all_nested %>% select(key, data) 
  
train_all_nested <- train_all_nested %>% 
  mutate(perc_zeros = map_dbl(data, ~ 100*sum(.x == 0)/length(.x[[1]]) ),
         perc_pos = map_dbl(data, ~ 100*sum(.x > 0)/length(.x[[1]]) ),
         perc_neg = map_dbl(data, ~ 100*sum(.x < 0)/length(.x[[1]]) )) %>%
  mutate(ts_length = map_dbl(data, ~ length(.x[[1]]))) %>% 
  mutate(val_max = map_dbl(data, ~ max(.x)),
         val_min = map_dbl(data, ~ min(.x))) %>% 
  mutate(val_avg = map_dbl(data, ~ mean(.x[[1]])),
         val_avg_abs = map_dbl(data, ~ abs(mean(.x[[1]])))) %>% 
  mutate(val_max_abs = pmax(abs(val_max), abs(val_min))) %>% 
  mutate(val_range = val_max - val_min)

train_all_summary_stats <- train_all_nested %>% select(-data)

saveRDS(train_all_summary_stats, file = "/home/datascience/local_data/train_all_summary_stats.rds")

# train_all_nested %>% arrange(desc(perc_pos)) %>% filter(perc_pos >= 90) %>% dim()
# train_all_nested %>% arrange(desc(perc_neg)) %>% filter(perc_pos >= 90) %>% dim()
# train_all_nested %>% arrange(desc(perc_zeros)) %>% filter(perc_zeros == 100) %>% dim()
# train_all_nested %>% arrange(desc(val_max)) %>% View()
# train_all_nested %>% arrange(desc(val_min)) 
# train_all_nested %>% arrange(desc(val_max_abs))
# train_all_nested %>% arrange(desc(val_range)) 
# train_all_nested %>% arrange(desc(val_avg_abs)) 

# This script transforms the raw data (in datascience/starting-kit ) 
# to the data to be used for analysis (in datascience/local_data ) 
# using some functions in the "h2020gridforecast" package (within R-Studio press F2 to navigate to the function where the cursor is)

library(h2020gridforecast)

source(file = "config.R")

convert_and_save_power_lines(dataset = "adapt", target = "../../local_data/")
convert_and_save_power_lines(dataset = "train", target = "../../local_data/")
saveRDS(object = get_gosat(), file = "../../local_data/gosat.rds")

saveRDS(
  object = get_opsd_not_NaN(dataset = "aux_opsd_15_train"), 
  file = "../../local_data/aux_opsd_15_train_not_NaN.rds"
)
saveRDS(
  object = get_opsd_not_NaN(dataset = "aux_opsd_15_adapt"), 
  file = "../../local_data/aux_opsd_15_adapt_not_NaN.rds"
)
saveRDS(
  object = get_opsd_not_NaN(dataset = "aux_opsd_60_adapt"), 
  file = "../../local_data/aux_opsd_60_adapt_not_NaN.rds"
)

saveRDS(
  object = get_opsd(dataset = "aux_opsd_15_train"), 
  file = "../../local_data/aux_opsd_15_train.rds"
)
saveRDS(
  object = get_opsd(dataset = "aux_opsd_15_adapt"), 
  file = "../../local_data/aux_opsd_15_adapt.rds"
)
saveRDS(
  object = get_opsd(dataset = "aux_opsd_60_adapt"), 
  file = "../../local_data/aux_opsd_60_adapt.rds"
)
saveRDS(
  object = get_gosat(dataset = "add_gosat"),
  file = "/home/datascience/local_data/add_gosat.rds"
)
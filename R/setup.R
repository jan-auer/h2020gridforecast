source(file = "hdf5_data_layer.R")
convert_and_save_power_lines(ids = ids, dataset = "adapt", target = "../../local_data/")
convert_and_save_power_lines(ids = ids, dataset = "train", target = "../../local_data/")
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

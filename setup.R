source(file = "hdf5_data_layer.R")
convert_and_save_power_lines(ids = ids, dataset = "adapt", target = "../local_data/")
convert_and_save_power_lines(ids = ids, dataset = "train", target = "../local_data/")

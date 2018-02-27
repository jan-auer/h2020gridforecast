### General data configuration
datasets <- list(
  train = list(
    path = '/home/datascience/starting-kit/notebook/See4C_starting_kit/sample_data/train/Xm1/',
    min_file_id = 1,
    max_file_id = 289
  ),
  adapt = list(
    path = '/home/datascience/starting-kit/notebook/See4C_starting_kit/sample_data/adapt/',
    min_file_id = 0,
    max_file_id = 68
  ),
  aux_gosat_adapt = list(
    path = "/home/datascience/starting-kit/auxiliaryData/adapt/aux/"
  ),
  aux_opsd_15_train = list(
    path = '/home/datascience/starting-kit/auxiliaryData/train/aux/opsd15/'
  ),
  aux_opsd_15_adapt = list(
    path = '/home/datascience/starting-kit/auxiliaryData/adapt/aux/opsd15/'
  ),
  aux_opsd_60_adapt = list(
    path = '/home/datascience/starting-kit/auxiliaryData/adapt/aux/opsd60/'
  ),
  aux_NOAA_train = list(
    path = '/home/datascience/starting-kit/auxiliaryData/train/aux/NOAA_HYCOM/'
  )
)
total_number_of_lines <- 1916

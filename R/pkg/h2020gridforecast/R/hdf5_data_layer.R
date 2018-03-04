#' Converting OPSData to R
#' 
#' This function reads Open Power System Data (OPSD), provided by the organisers, in HDF5 format and converts them to a \link{data.frame}.
#' 
#' @param dataset String. Indicates an element in the config file's \code{datasets} list.
#' 
#' @return Data.frame with all measurement columns and a column timestamp with UNIX epoch timestamps.
#' 
#' @author Jakob Etzel
#' @export
#' @import hdf5r
#' @import dplyr
get_opsd <- function(
  dataset = "aux_opsd_15_train"
) {
  if(exists("opsd")){
    rm("opsd")
  }
  dirname <- datasets[[dataset]]$path
  subdirs <- list.dirs(path = dirname, full.names = FALSE)[-1]
  for (dir in subdirs) {
    files <- list.files(path = paste0(dirname, dir), full.names = FALSE, pattern = "*.h5")
    for(ffile in files) {
      filename <- paste0(dirname, dir, "/", ffile)
      file <- H5File$new(filename = filename, mode = "r")
      t <- file[["X/value/t/value"]]
      column_count <- file[["X/value/metadata/value/feature_names/value/dims"]][1]
      index_width <- nchar(file[["X/value/metadata/value/feature_names/value"]]$ls()$name[1]) - 1
      column_names <- c()
      for (i in 0:(column_count-1)) {
        column_names <- c(
          column_names, 
          paste(
            unlist(lapply(
              file[[
                paste0("X/value/metadata/value/feature_names/value/_", formatC(x = i, width = index_width, flag = "0"), "/value")
                ]][1,], 
              function(n) { rawToChar(as.raw(n)) }
            )), 
            collapse = ''
          )
        )
      }
      X <- data.frame(t(file[["X/value/X/value"]][,]))
      colnames(X) <- column_names
      X$timestamp <- tryCatch(
        {
          t[,1]
        }, error = function(e) {
          return(t[])
        }
      )
      file$close()
      if(exists("opsd")){
        opsd <- bind_rows(opsd, X)
      } else {
        opsd <- X
      }
    }
  }
  return(opsd)
}

#' This function reads OPSD data in HDF5 format and keeps only non-empty columns.
#' 
#' A column is non-empty if at least one value is not \code{NaN}.
#' 
#' @inheritParams get_opsd
#' 
#' @return Data.frame with all measurement columns and a column timestamp with UNIX epoch timestamps.
#' 
#' @author Jakob Etzel
#' @export
#' @import dplyr
get_opsd_not_NaN <- function(dataset = "aux_opsd_15_train") {
  opsd <- get_opsd(dataset)
  not_NaN_columns <- data.frame(
    column = colnames(opsd), 
    average = unlist(lapply(colnames(opsd), function (x) mean(opsd %>% pull(x), na.rm = TRUE)))
  ) %>% filter(!(is.nan(average))) %>% pull(column)
  return(opsd %>% select(one_of(as.character(not_NaN_columns))))
}

#' This function reads GOSAT data in HDF5 format.
#' 
#' @param dataset String. Indicates an element in the config file's \code{datasets} list.
#' @param folders Vector. Defaults to an empty vector which means that all available folders being selectd. 
#' Can designate selected folders.
#' 
#' @return A list of three data.frame objects called CO2, CH4 and H2O.
#' Each data.frame has a column 'timestamp' and different measurement and metadata columns.
#' 
#' @author Jakob Etzel
#' @export
#' @import hdf5r
#' @import dplyr
get_gosat <- function(
  dataset = "aux_gosat_adapt",
  folders = c()
) {

  if(length(folders) == 0) {
    dirname <- paste0(datasets[[dataset]]$path, "gosat_FTS_C01S_2/")
    subdirs <- list.dirs(path = dirname, full.names = FALSE)[-1]
    folders <- unlist(lapply(subdirs, function (x) as.integer(gsub(pattern = "X", replacement = "", x = x))))
  }

  ## C01S ## CO2 data
  dirname <- paste0(datasets[[dataset]]$path, "gosat_FTS_C01S_2/")
  CO2 <- data.frame(
    timestamp = character(),
    lat = double(),
    lon = double(),
    dryAirTotalColumn = double(),
    surfacePressure = double(),
    CO2TotalColumn = double(),
    # CO2TotalColumnExternalError = double(),
    # CO2TotalColumnInterferenceError = double(),
    # CO2TotalColumnRetrievalNoise = double(),
    # CO2TotalColumnSmoothingError = double()
    surfaceAlbedo = double(),
    surfaceWindSpeed = double(),
    temperatureProfile = double(),
    XCO2 = double()
  )
  for(folder in folders) {
    files <- list.files(path = paste0(dirname, "X", folder), full.names = FALSE, pattern = "*.h5")
    for(ffile in files) {
      filename <- paste0(dirname, "X", folder, "/", ffile)
      file <- H5File$new(filename = filename, mode = "r")
  
      datestamp <- file[["Global/MD_Metadata/dateStamp"]][]
      # geoloaction and time
      time <- data.frame(
        timestamp = as.character(file[["scanAttribute/time"]][])
      )
      geolocations <- data.frame(
        lat = file[["Data/geolocation/latitude"]][],
        lon = file[["Data/geolocation/longitude"]][]
      )
      
      # aux params
      auxiliary_parameters <- data.frame(
        #    aerosolOpticalThickness = lapply(1:180, (function (x) file[["Data/auxiliaryParameter/aerosolOpticalThickness"]][,,x])),
        dryAirTotalColumn = file[["Data/auxiliaryParameter/dryAirTotalColumn"]][],
        surfacePressure = file[["Data/auxiliaryParameter/surfacePressure"]][]
      )
      # total columns
      total_column <- data.frame(
        CO2TotalColumn = file[["Data/totalColumn/CO2TotalColumn"]][]#,
#        CO2TotalColumnExternalError = file[["Data/totalColumn/CO2TotalColumnExternalError"]][],
#        CO2TotalColumnInterferenceError = file[["Data/totalColumn/CO2TotalColumnInterferenceError"]][],
#        CO2TotalColumnRetrievalNoise = file[["Data/totalColumn/CO2TotalColumnRetrievalNoise"]][],
#        CO2TotalColumnSmoothingError = file[["Data/totalColumn/CO2TotalColumnSmoothingError"]][]
      )
      # reference data columns
      reference_data <- data.frame(
        surfaceAlbedo = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,],
        surfaceWindSpeed = file[["scanAttribute/referenceData/surfaceWindSpeed"]][],
        temperatureProfile = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,]
      )
      
      # mixing ratio
      mixing_ratio <- data.frame(
        XCO2 = file[["Data/mixingRatio/XCO2"]][]
      )
      
      CO2 <- bind_rows(CO2, bind_cols(
        time,
        geolocations,
        auxiliary_parameters,
        total_column,
        reference_data,
        mixing_ratio
      ))
      file$close()
    }
  }
  
  ## C02S ## CH4 data
  dirname <- paste0(datasets[[dataset]]$path, "gosat_FTS_C02S_2/")
  CH4 <- data.frame(
    timestamp = character(),
    lat = double(),
    lon = double(),
    dryAirTotalColumn = double(),
    surfacePressure = double(),
    CH4TotalColumn = double(),
    # CH4TotalColumnExternalError = double(),
    # CH4TotalColumnInterferenceError = double(),
    # CH4TotalColumnRetrievalNoise = double(),
    # CH4TotalColumnSmoothingError = double()
    surfaceAlbedo = double(),
    surfaceWindSpeed = double(),
    temperatureProfile = double(),
    XCH4 = double()
  )
  for(folder in folders) {
    files <- list.files(path = paste0(dirname, "X", folder), full.names = FALSE, pattern = "*.h5")
    for(ffile in files) {
      filename <- paste0(dirname, "X", folder, "/", ffile)
      file <- H5File$new(filename = filename, mode = "r")
      
      datestamp <- file[["Global/MD_Metadata/dateStamp"]][]
      # geoloaction and time
      time <- data.frame(
        timestamp = as.character(file[["scanAttribute/time"]][])
      )
      geolocations <- data.frame(
        lat = file[["Data/geolocation/latitude"]][],
        lon = file[["Data/geolocation/longitude"]][]
      )
      
      # aux params
      auxiliary_parameters <- data.frame(
        #    aerosolOpticalThickness = lapply(1:180, (function (x) file[["Data/auxiliaryParameter/aerosolOpticalThickness"]][,,x])),
        dryAirTotalColumn = file[["Data/auxiliaryParameter/dryAirTotalColumn"]][],
        surfacePressure = file[["Data/auxiliaryParameter/surfacePressure"]][]
      )
      # total columns
      total_column <- data.frame(
        CH4TotalColumn = file[["Data/totalColumn/CH4TotalColumn"]][]#,
        #        CH4TotalColumnExternalError = file[["Data/totalColumn/CH4TotalColumnExternalError"]][],
        #        CH4TotalColumnInterferenceError = file[["Data/totalColumn/CH4TotalColumnInterferenceError"]][],
        #        CH4TotalColumnRetrievalNoise = file[["Data/totalColumn/CH4TotalColumnRetrievalNoise"]][],
        #        CH4TotalColumnSmoothingError = file[["Data/totalColumn/CH4TotalColumnSmoothingError"]][]
      )
      # reference data columns
      reference_data <- data.frame(
        surfaceAlbedo = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,],
        surfaceWindSpeed = file[["scanAttribute/referenceData/surfaceWindSpeed"]][],
        temperatureProfile = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,]
      )
      
      # mixing ratio
      mixing_ratio <- data.frame(
        XCH4 = file[["Data/mixingRatio/XCH4"]][]
      )
      
      CH4 <- bind_rows(CH4, bind_cols(
        time,
        geolocations,
        auxiliary_parameters,
        total_column,
        reference_data,
        mixing_ratio
      ))
      file$close()
    }
  }
  
  ## C03S ## H2O data
  dirname <- paste0(datasets[[dataset]]$path, "gosat_FTS_C03S_2/")
  H2O <- data.frame(
    timestamp = character(),
    lat = double(),
    lon = double(),
    dryAirTotalColumn = double(),
    surfacePressure = double(),
    H2OTotalColumn = double(),
    # H2OTotalColumnExternalError = double(),
    # H2OTotalColumnInterferenceError = double(),
    # H2OTotalColumnRetrievalNoise = double(),
    # H2OTotalColumnSmoothingError = double()
    surfaceAlbedo = double(),
    surfaceWindSpeed = double(),
    temperatureProfile = double(),
    XH2O = double()
  )
  for(folder in folders) {
    files <- list.files(path = paste0(dirname, "X", folder), full.names = FALSE, pattern = "*.h5")
    for(ffile in files) {
      filename <- paste0(dirname, "X", folder, "/", ffile)
      file <- H5File$new(filename = filename, mode = "r")
      
      datestamp <- file[["Global/MD_Metadata/dateStamp"]][]
      # geoloaction and time
      time <- data.frame(
        timestamp = as.character(file[["scanAttribute/time"]][])
      )
      geolocations <- data.frame(
        lat = file[["Data/geolocation/latitude"]][],
        lon = file[["Data/geolocation/longitude"]][]
      )
      
      # aux params
      auxiliary_parameters <- data.frame(
        #    aerosolOpticalThickness = lapply(1:180, (function (x) file[["Data/auxiliaryParameter/aerosolOpticalThickness"]][,,x])),
        dryAirTotalColumn = file[["Data/auxiliaryParameter/dryAirTotalColumn"]][],
        surfacePressure = file[["Data/auxiliaryParameter/surfacePressure"]][]
      )
      # total columns
      total_column <- data.frame(
        H2OTotalColumn = file[["Data/totalColumn/H2OTotalColumn"]][]#,
        #        H2OTotalColumnExternalError = file[["Data/totalColumn/H2OTotalColumnExternalError"]][],
        #        H2OTotalColumnInterferenceError = file[["Data/totalColumn/H2OTotalColumnInterferenceError"]][],
        #        H2OTotalColumnRetrievalNoise = file[["Data/totalColumn/H2OTotalColumnRetrievalNoise"]][],
        #        H2OTotalColumnSmoothingError = file[["Data/totalColumn/H2OTotalColumnSmoothingError"]][]
      )
      # reference data columns
      reference_data <- data.frame(
        surfaceAlbedo = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,],
        surfaceWindSpeed = file[["scanAttribute/referenceData/surfaceWindSpeed"]][],
        temperatureProfile = file[["scanAttribute/referenceData/surfaceAlbedo"]][1,]
      )
      
      # mixing ratio
      mixing_ratio <- data.frame(
        XH2O = file[["Data/mixingRatio/XH2O"]][]
      )
      
      H2O <- bind_rows(H2O, bind_cols(
        time,
        geolocations,
        auxiliary_parameters,
        total_column,
        reference_data,
        mixing_ratio
      ))
      file$close()
    }
  }
  
  return(list(CO2 = CO2, CH4 = CH4, H2O = H2O))
}

#' This function reads target data (power line measurements) in HDF5 format.
#' 
#' @param dataset String. Indicates an element in the config file's \code{datasets} list.
#' @param ids Vector. Defaults to an empty vector which means that all available power lines are selectd. 
#' Can designate selected power lines by their ids.
#' 
#' @return Data.frame of all measurements with a 'timestamp' column.
#' 
#' @author Jakob Etzel
#' @export
#' @import hdf5r
#' @import dplyr
get_power_lines <- function(
  ids = c(), 
  dataset = "train"
) {
  if(length(ids) == 0) {
    ids = 1:total_number_of_lines
  }
  power_lines <- data.frame(matrix(nrow = 0, ncol = (length(ids) + 1)))
  colnames(power_lines) <- c(ids, "timestamp")
  for(file_id in datasets[[dataset]]$min_file_id:datasets[[dataset]]$max_file_id) {
    print(paste("file", file_id, "of", (1 + datasets[[dataset]]$max_file_id - datasets[[dataset]]$min_file_id)))
    filename <- paste0(datasets[[dataset]]$path, "X", file_id, ".h5")
    file <- H5File$new(filename, mode="r")

    # Extract the relevant data
    X <- file[["X/value/X/value"]]
    t <- file[["X/value/t/value"]]
    power_lines_to_add <- t(X[1,ids,])
    power_lines_to_add <- data.frame(cbind(power_lines_to_add, t[1,]))
    colnames(power_lines_to_add) = c(ids, "timestamp")

    file$close_all()
    
    power_lines <- rbind(power_lines, power_lines_to_add)
  }
  return(power_lines)
}

#' This function reads target data (power line measurements) in HDF5 format and saves it in RDS format.
#' 
#' @inheritParams get_power_lines
#' @param target String. Folder where to save the file.
#' @param designation String. File name.
#' 
#' @author Jakob Etzel
#' @export
#' @import hdf5r
#' @import dplyr
convert_and_save_power_lines <- function(
  ids = c(), 
  dataset = "train", 
  target = "/home/datascience/h2020_grid_forecast/R_data/",
  designation = ""
) {
  power_lines <- get_power_lines(ids = ids, dataset = dataset)
  if(designation == ""){
    if(length(ids) == 0) {
      designation = "all"
    } else {
      designation = paste0(ids, collapse = '_')
    }
  }
  saveRDS(
    object = power_lines, 
    file = paste0(target, dataset, "_", designation, ".rds")
  )
}

### TRYING OUT THE CODE ###

# Inspect recursively the content of the hdf5 file
# file$ls(recursive = TRUE)
# file[["X/value/X/value"]]$ls(recursive = TRUE)

# ids = c(1, 3, 123)

# power_lines_test <- get_power_lines(ids = ids, dataset = "adapt")
# power_lines_test$timestamp <- as.POSIXct(power_lines_test$timestamp, origin = "1970-01-01")
# power_lines_test_long <- melt(power_lines_test, id="timestamp")

# Plotting
# ggplot(data=power_lines_test_long,
#        aes(x=timestamp, y=value, colour=variable)) + 
#   geom_line()

# Saving
# convert_and_save_power_lines(ids = ids, dataset = "adapt")

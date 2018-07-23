library(tidyverse)

# transforms training and test data and adds timestamps
transformdata <- function(ts) {
  my_names <- paste0("V", names(ts)[-1917])
  names(ts) <- c(my_names, "time_stamp")
  ts <- ts %>% 
    mutate(time_stamp = as.POSIXct(time_stamp, origin = "1970-01-01")) %>% 
    as_tibble()
  return(ts)
}

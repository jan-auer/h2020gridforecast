#filter data by given indices
filter_by_indices <- function(ts, idx){
  return(ts[idx$timeseries])
}

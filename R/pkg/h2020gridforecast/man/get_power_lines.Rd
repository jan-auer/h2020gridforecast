% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hdf5_data_layer.R
\name{get_power_lines}
\alias{get_power_lines}
\title{This function reads target data (power line measurements) in HDF5 format.}
\usage{
get_power_lines(ids = c(), dataset = "train")
}
\arguments{
\item{ids}{Vector. Defaults to an empty vector which means that all available power lines are selectd. 
Can designate selected power lines by their ids.}

\item{dataset}{String. Indicates an element in the config file's \code{datasets} list.}
}
\value{
Data.frame of all measurements with a 'timestamp' column.
}
\description{
This function reads target data (power line measurements) in HDF5 format.
}
\author{
Jakob Etzel
}

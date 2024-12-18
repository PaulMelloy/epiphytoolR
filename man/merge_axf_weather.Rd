% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_bom_observations.R
\name{merge_axf_weather}
\alias{merge_axf_weather}
\title{Merge BOM axf weather data}
\usage{
merge_axf_weather(
  File_compressed,
  File_axf = "IDQ60910.99123.axf",
  File_formatted = "NTamborine.csv",
  base_dir = getwd(),
  verbose = FALSE
)
}
\arguments{
\item{File_compressed}{character, file path of compressed weather file "tgz"}

\item{File_axf}{character, uncompressed axf BOM file containing 10 minute weather
observations, default is North Tamborine.}

\item{File_formatted}{character, file name and path to the formatted file for
which to store formatted data and which previously stored data will be merged
with.}

\item{base_dir}{character file path giving the base directory for
\code{file_formatted}}

\item{verbose}{logical print extra messages to assist debugging}
}
\value{
data.table, of merged dataset
}
\description{
Merge BOM axf weather data
}
\details{
This function takes new \acronym{BOM} axf files which hold 72 hours of
weather observations in 10-30 minute intervals and an old formatted weather
data file, row binds them, then saves them back as the File_formatted csv.
\code{File_axf} uncompressed axf BOM file containing 10 minute weather
observations, default is North Tamborine.
\code{File_formatted} previously read axf files with removed headers and
saved as a csv file
\code{base_dir} weather directory which contains folders where weather data
are saved, and where formatted data is saved.
\code{data_dir} Directory with compressed and uncompressed data
}

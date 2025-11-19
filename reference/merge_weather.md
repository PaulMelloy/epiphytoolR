# Merge 'latest' BOM weather data

`merge_weather` takes the 'latest' Bureau of Meteorology BOM weather
observations files which hold 72 hours of weather observations in 10-30
minute intervals and a saved earlier weather data file, row binds the
two data.tables, then overwrites the old File_formatted.csv file with
the joined data.

## Usage

``` r
merge_weather(
  File_compressed,
  station_file = "IDQ60910.99123.json",
  File_formatted = "NTamborine.csv",
  base_dir = getwd(),
  verbose = FALSE
)
```

## Arguments

- File_compressed:

  character, file path of compressed weather file "tgz"

- station_file:

  character, uncompressed BOM file containing 10 minute weather
  observations, default is North Tamborine. Works best with `json`
  files, but can also read `axf` files.

- File_formatted:

  character, file name and path to the formatted file for which to store
  formatted data and which previously stored data will be merged with.

- base_dir:

  character, weather directory which contains folders where weather data
  are saved, and where `File_formatted` data is saved.

- verbose:

  logical print extra messages to assist debugging

## Value

data.table, of merged dataset

# Fill time gaps in data.frame

Fill time gaps in data.frame

## Usage

``` r
fill_time_gaps(
  dat,
  t_col,
  interval = "auto",
  max_interval = 60,
  impute = FALSE
)
```

## Arguments

- dat:

  data.frame or data.table with column of times

- t_col:

  character, colname of column containing times

- interval:

  numeric, expected time interval in minutes between times

- max_interval:

  numeric, maximum acceptable interval between data observaions in
  minutes.

- impute:

  logical, not in operation, possible future functionality. default is
  FALSE

## Value

data.table, with extra rows containing times where there were gaps

## Examples

``` r
# import BOM data file
brisvegas <-
  system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
bris <- data.table::fread(brisvegas)
#> Warning: Some columns are type 'integer64' but package bit64 is not installed. Those columns will print as strange looking floating point data. There is no need to reload the data. Simply install.packages('bit64') to obtain the integer64 print method and print the data again.
dim(bris)
#> [1] 2029   45

bris$aifstime_utc <- as.POSIXct(bris$aifstime_utc,tz = "UTC")
bris <- fill_time_gaps(bris,"aifstime_utc")
dim(bris)
#> [1] 2077   45
```

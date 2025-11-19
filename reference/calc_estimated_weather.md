# Calculate estimated weather from coefficients

Calculate estimated weather from coefficients

## Usage

``` r
calc_estimated_weather(
  w,
  start_date = "2023-04-01",
  end_date = "2023-11-30",
  lat,
  lon,
  n_stations = 1:4,
  na.rm = FALSE
)
```

## Arguments

- w:

  A `data.table` of weather coefficients, output from
  [`get_weather_coefs`](https://paulmelloy.github.io/epiphytoolR/reference/get_weather_coefs.md)\`

- start_date:

  a character string of a date value indicating the first date for in
  the returning data.table Must be in ISO8601 format (YYYY-MM-DD),
  *e.g.* “2020-04-26”

- end_date:

  a character string of a date value indicating the last date for in the
  returning data.table Must be in ISO8601 format (YYYY-MM-DD), *e.g.*
  “2020-04-26”

- lat:

  numeric, latitude of the query coordinates where weather should be
  estimated. If missing all stations will be returned

- lon:

  numeric, longitude of the query coordinates where weather should be
  estimated. If missing all stations will be returned

- n_stations:

  integer or vector of integers indicating the number of station/s to
  return from the closest (1), or 3rd closest (3) or closest five
  stations (1:5), ect.

- na.rm:

  logical, remove all weather data from stations with NA rain_fall
  frequency **Not Recommended**. We advise the best way is to manually
  remove weather stations with NAs or correct the weather data. This
  argument is available if these two options are not available to the
  user. Default is `FALSE`

## Value

A `data.table` output of calculated on
[`get_weather_coefs`](https://paulmelloy.github.io/epiphytoolR/reference/get_weather_coefs.md)
with the following columns: *station* - Weather station name; *lat* -
latitude; *lon* - longitude; *rh* - NA currently not supported see
epiphytoolR github issue \#14; *yearday* - integer, day of the year, see
[`data.table::yday()`](https://rdatatable.gitlab.io/data.table/reference/IDateTime.html);
*wd_rd* - numeric, mean wind direction from raw data; *wd_sd_rd* -
numeric, standard deviation of wind direction from raw data; *ws_rd* -
numeric, mean wind speed from raw data; *ws_sd_rd* - numeric, standard
deviation of wind speed from raw data; *rain_freq* - numeric,
proportional chance of rainfall on this dat 0 - 1

Output can be formatted with
[`format_weather`](https://paulmelloy.github.io/epiphytoolR/reference/format_weather.md)

## Examples

``` r
set.seed(61)
dat <- data.frame(
  station_name = "w_STATION",
  lat = -runif(1, 15.5, 28),
  lon = runif(1, 115, 150),
  state = "SA",
  yearday = 1:365,
  wd_rw = abs(rnorm(365, 180, 90)),
  wd_sd_rw = rnorm(365, 80, 20),
  ws_rw = runif(365, 1, 60),
  ws_sd_rw = abs(rnorm(365, 10, sd = 5)),
  rain_freq = runif(365, 0.05, 0.45)
  )

  calc_estimated_weather(w = dat,
    lat = -25,
    lon = 130,
    n_stations = 1)
#> Warning: 'max_temp' and 'min_temp' not detected, returning NAs for mean daily 'temp'
#>                     times   station yearday       lat      lon  state     wd_rw
#>                    <POSc>    <char>   <int>     <num>    <num> <char>     <num>
#>    1: 2023-04-01 00:00:00 w_STATION      91 -19.89674 147.9869     SA 303.05002
#>    2: 2023-04-01 01:00:00 w_STATION      91 -19.89674 147.9869     SA 303.05002
#>    3: 2023-04-01 02:00:00 w_STATION      91 -19.89674 147.9869     SA 303.05002
#>    4: 2023-04-01 03:00:00 w_STATION      91 -19.89674 147.9869     SA 303.05002
#>    5: 2023-04-01 04:00:00 w_STATION      91 -19.89674 147.9869     SA 303.05002
#>   ---                                                                          
#> 5829: 2023-11-29 20:00:00 w_STATION     333 -19.89674 147.9869     SA 247.95358
#> 5830: 2023-11-29 21:00:00 w_STATION     333 -19.89674 147.9869     SA 247.95358
#> 5831: 2023-11-29 22:00:00 w_STATION     333 -19.89674 147.9869     SA 247.95358
#> 5832: 2023-11-29 23:00:00 w_STATION     333 -19.89674 147.9869     SA 247.95358
#> 5833: 2023-11-30 00:00:00 w_STATION     334 -19.89674 147.9869     SA  67.58693
#>       wd_sd_rw     ws_rw  ws_sd_rw rain_freq distance    rh  rain  temp
#>          <num>     <num>     <num>     <num>    <num> <num> <int> <num>
#>    1: 78.18055  3.682944 10.011768 0.0659163 1933.846    NA     0    NA
#>    2: 78.18055  3.682944 10.011768 0.0659163 1933.846    NA     0    NA
#>    3: 78.18055  3.682944 10.011768 0.0659163 1933.846    NA     0    NA
#>    4: 78.18055  3.682944 10.011768 0.0659163 1933.846    NA     0    NA
#>    5: 78.18055  3.682944 10.011768 0.0659163 1933.846    NA     0    NA
#>   ---                                                                  
#> 5829: 55.64306 56.564044 10.791610 0.2640204 1933.846    NA     0    NA
#> 5830: 55.64306 56.564044 10.791610 0.2640204 1933.846    NA     0    NA
#> 5831: 55.64306 56.564044 10.791610 0.2640204 1933.846    NA     0    NA
#> 5832: 55.64306 56.564044 10.791610 0.2640204 1933.846    NA     0    NA
#> 5833: 73.84805 34.334943  9.999803 0.2522567 1933.846    NA     0    NA
#>             ws        wd    wd_sd  YYYY    MM    DD    hh    mm
#>          <num>     <num>    <num> <int> <int> <int> <int> <int>
#>    1: 17.04809 303.05002 78.18055  2023     4     1     0     0
#>    2: 17.04809 303.05002 78.18055  2023     4     1     1     0
#>    3: 17.04809 303.05002 78.18055  2023     4     1     2     0
#>    4: 17.04809 303.05002 78.18055  2023     4     1     3     0
#>    5: 17.04809 303.05002 78.18055  2023     4     1     4     0
#>   ---                                                          
#> 5829: 45.39426 247.95358 55.64306  2023    11    29    20     0
#> 5830: 45.39426 247.95358 55.64306  2023    11    29    21     0
#> 5831: 45.39426 247.95358 55.64306  2023    11    29    22     0
#> 5832: 45.39426 247.95358 55.64306  2023    11    29    23     0
#> 5833: 40.35103  67.58693 73.84805  2023    11    30     0     0
```

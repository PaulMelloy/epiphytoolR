# Calculate weather coefficients

Calculate weather coefficients

## Usage

``` r
get_weather_coefs(
  raw_bom_file,
  rolling_window = 60,
  meta_data,
  i_year = 2020,
  rainfall_na_fill = "mean"
)
```

## Arguments

- raw_bom_file:

  character, file path to raw bureau of Meteorology txt file

- rolling_window:

  integer, number of days to summarise over a rolling window

- meta_data:

  data.table Bureau of Meteorology, meta-data

- i_year:

  integer, the year the coeffients are likely to be imputed. Defaults to
  `2020`

- rainfall_na_fill:

  numeric proportion, likihood of rain to fill NA values Defaults to
  rainfall_na_fill = "mean", which takes the overall mean proportion.

## Value

data.table, of coefficients to estimate weather during a rainfall event.
If no rainfall data is recorded in the raw weather NULL is returned
without warning. wd_rw, mean wind direction from rolling window;
wd_sd_rw, standard deviation of wind direction from rolling window;
ws_rw, mean wind speed from rolling window; ws_sd_rw, standard deviation
of speed from rolling window; rain_freq, historical probability of
rainfall on this day based on a rolling window.

A `data.table` of coefficients to estimate weather during a rainfall
event. If no rainfall data is recorded in the raw weather NULL is
returned without warning. *station_name* - Weather station name; *lat* -
latitude; *lon* - longitude; *state* - political juristiction or state;
*yearday* - integer, day of the year, see
[`data.table::yday()`](https://rdatatable.gitlab.io/data.table/reference/IDateTime.html);
*temp* - numeric, mean temperature; *rh* - numeric, mean temperature;
*wd_rd* - numeric, mean wind direction from rolling window; *wd_sd_rd* -
numeric, standard deviation of wind direction from rolling window;
*ws_rd* - numeric, mean wind speed from rolling window; *ws_sd_rd* -
numeric, standard deviation of speed from rolling window; *rain_freq* -
numeric, proportional chance of rainfall on this day 0 - 1 based on a
rolling window.

## Details

get_weather_coefs uses historical bom rainfall data to determine the
probability of rainfall on each day of the year. It also summarises the
mean temperatures, wind speed and direction at the time of the rainfall.
Formally called impute_rainywind

## Examples

``` r
if (FALSE) { # \dontrun{
library(data.table)
meta_dat <- fread("cache/bom_stations.csv")
imp_dat <-
   get_weather_coefs(raw_bom_file = "./data/Weather_data/HD01D_Data_090182_999999999959761.txt",
                    rolling_window = 60,
                    meta_data = meta_dat)} # }
```

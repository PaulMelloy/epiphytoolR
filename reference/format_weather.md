# Format weather data into a standardised format.

Formats raw weather data into an object suitable for use in the
affiliated spore dispersal packages such as `ascotraceR` and
`blackspot.sp`. This standardised data format ensures that the supplied
weather data meet the requirements for functions in the aforementioned
packages. Input weather data expects a 'long' data format, where each
line is an observation at a point in time.

## Usage

``` r
format_weather(
  w,
  YYYY = NULL,
  MM = NULL,
  DD = NULL,
  hh = NULL,
  mm = NULL,
  ss = NULL,
  POSIXct_time = NULL,
  time_zone = NULL,
  temp,
  rain,
  rh,
  ws,
  wd,
  wd_sd,
  station,
  lon = NULL,
  lat = NULL,
  lonlat_file = NULL,
  impute_nas = c("temp", "rh"),
  fill_missing = NULL,
  Irolling_window = 70,
  data_check = TRUE,
  verbose = TRUE
)
```

## Arguments

- w:

  a [`data.frame`](https://rdrr.io/r/base/data.frame.html) object of
  weather station data for formatting.

- YYYY:

  Column name `character` or index in `w` that refers to the year when
  the weather was logged.

- MM:

  Column name `character` or index in `w` that refers to the month
  (numerical) when the weather was logged.

- DD:

  Column name `character` or index in `w` that refers to the day of
  month when the weather was logged.

- hh:

  Column name `character` or index in `w` that refers to the hour (24
  hour) when the weather was logged.

- mm:

  Column name `character` or index in `w` that refers to the minute when
  the weather was logged.

- ss:

  Column name `character` or index in `w` that refers to the second when
  the weather was logged.

- POSIXct_time:

  Column name `character` or index in `w` which contains a `POSIXct`
  formatted time. This can be used instead of arguments `YYYY`, `MM`,
  `DD`, `hh`, `mm.`.

- time_zone:

  Time zone (Olsen time zone format) `character` where the weather
  station is located. May be in a column or supplied as a character
  string. Optional, see also `r`. See details.

- temp:

  Column name `character` or index in `x` that refers to temperature in
  degrees Celsius.

- rain:

  Column name `character` or index in `w` that refers to rainfall in
  millimetres.

- rh:

  Column name `character` or index in `w` that refers to relative
  humidity as a percentage.

- ws:

  Column name `character` or index in `w` that refers to wind speed in
  km / h.

- wd:

  Column name `character` or index in `w` that refers to wind direction
  in degrees.

- wd_sd:

  Column name `character` or index in `w` that refers to wind speed
  columns standard deviation. This is only applicable if weather data is
  already summarised to hourly increments. See details.

- station:

  Column name `character` or index in `w` that refers to the weather
  station name or identifier. See details.

- lon:

  Column name `character` or index in `w` that refers to weather
  station's longitude. See details.

- lat:

  Column name `character` or index in `w` that refers to weather
  station's latitude. See details.

- lonlat_file:

  A file path (`character`) to a CSV which included station name/id and
  longitude and latitude coordinates if they are not supplied in the
  data. Optional, see also `lon` and `lat`.

- impute_nas:

  `character` vector indicating which variables to impute missing or
  `NA` values. Options include, "temp" (see
  [`epiphytoolR::impute_temp()`](https://paulmelloy.github.io/epiphytoolR/reference/impute_temp.md)),
  "rh"(see
  [`epiphytoolR::impute_rh()`](https://paulmelloy.github.io/epiphytoolR/reference/impute_rh.md)).
  "rain" will be filled with zeros. If `TRUE` (logical) it will impute
  missing values for all available options. If `FALSE` (logical) it will
  not impute any missing values. The default is c("temp,"rh) to impute
  only temperature and humidity.

- fill_missing:

  If `TRUE` the function will use
  [openmeteo](https://CRAN.R-project.org/package=openmeteo) to fill
  missing weather data. Still experimental!!!

- Irolling_window:

  `integer` value indicating the number of hours to use for the rolling
  window to impute missing values. See `impute_nas`

- data_check:

  If `TRUE`, it checks for NA values in all 'rain', 'temp', 'rh', 'wd'
  and 'ws' data and if any values which are unlikely. Use a character
  vector of variable names, (wither any of 'rain', 'temp', 'rh', 'wd' or
  'ws') to check data from specific variables. If FALSE it ignores all
  variables and could cause subsequent models using this data to fail.

- verbose:

  If `TRUE` (default) it will print messages and warnings associated
  with the internal handling of the weather formatting. It is not
  recommended to use `FALSE` to suppress these messages. Instead

## Value

A `epiphy.weather` object (an extension of
[data.table](https://CRAN.R-project.org/package=data.table)) containing
the supplied weather aggregated to each hour in a suitable format for
use with disease models. Depending on the input weather, classes will be
given to the output object to indicate which models it meets the data
requirements for. Some of the columns returned are as follows:

|              |                                                      |
|--------------|------------------------------------------------------|
| **times**:   | Time in POSIXct format with "UTC" time-zone          |
| **rain**:    | Rainfall in mm                                       |
| **temp**:    | Temperature in degrees celcius                       |
| **ws**:      | Wind speed in km / h                                 |
| **wd**:      | Wind direction in compass degrees                    |
| **wd_sd**:   | Wind direction standard deviation in compass degrees |
| **lon**:     | Station longitude in decimal degrees                 |
| **lat**:     | Station latitude in decimal degrees                  |
| **station**: | Unique station identifying name                      |
| **YYYY**:    | Year                                                 |
| **MM**:      | Month                                                |
| **DD**:      | Day                                                  |
| **hh**:      | Hour                                                 |
| **mm**:      | Minute                                               |

## Details

`time_zone` The time-zone in which the `time` was recorded. All weather
stations in `w` must fall within the same time-zone. If the required
stations are located in differing time zones, `format_weather()` should
be run separately on each object, then data can be combined after
formatting.

`wd_sd` If weather data is provided in hourly increments, a column with
the standard deviation of the wind direction over the hour is required
to be provided. If the weather data are sub-hourly, the standard
deviation will be calculated and returned automatically.

`lon`, `lat` and `lonlat_file` If `w` provides longitude and latitude
values for station locations, these may be specified in the `lon` and
`lat` columns. If the coordinates are not relevant to the study location
`NA` can be specified and the function will drop these column variables.
If these data are not included, (`NULL`) a separate file may be provided
that contains the longitude, latitude and matching station name to
provide station locations in the final `epiphy.weather` object that is
created by specifying the file path to a CSV file using `lonlat_file`.

## Examples

``` r
# Weather data files for Newmarracara for testing and examples have been
# included in ascotraceR. The weather data files both are of the same format,
# so they will be combined for formatting here.

# load the weather data to be formatted
scaddan <-
   system.file("extdata", "scaddan_weather.csv",package = "epiphytoolR")
naddacs <-
   system.file("extdata", "naddacs_weather.csv",package = "epiphytoolR")

weather_file_list <- list(scaddan, naddacs)
weather_station_data <-
   lapply(X = weather_file_list, FUN = read.csv)

weather_station_data <- do.call("rbind", weather_station_data)

weather_station_data$Local.Time <-
   as.POSIXct(weather_station_data$Local.Time, format = "%Y-%m-%d %H:%M:%S",
              tz = "UTC")

weather <- format_weather(
   w = weather_station_data,
   POSIXct_time = "Local.Time",
   ws = "meanWindSpeeds",
   wd_sd = "stdDevWindDirections",
   rain = "Rainfall",
   temp = "Temperature",
   wd = "meanWindDirections",
   lon = "Station.Longitude",
   lat = "Station.Latitude",
   station = "StationID",
   time_zone = "UTC"
)
#> Weather data is compliant with the following models:  blackspot.sp, ascotraceR
#> Warning: Relative humidity data contains NA values, imputing missing values
#> Warning: All relative humidity values are 'NA' or missing, check data if this is not intentional

# Reformat saved weather

# Create file path and save data
file_path_name <- paste(tempdir(), "weather_saved.csv", sep = "\\")
write.csv(weather, file = file_path_name,
          row.names = FALSE)

# Read data back in to
weather2 <- read.csv(file_path_name, stringsAsFactors = FALSE)

# reformat the data to have appropriate column classes and data class
weather2 <- format_weather(weather2,
                           time_zone = "UTC")
#> Warning: All relative humidity values are 'NA' or missing, check data if this is not intentional
unlink(file_path_name) # remove temporary weather file
```

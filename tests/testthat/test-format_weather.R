set.seed(27)
dat_minutes <- 10080 # equal to, 7 * 24 * 60

weather_station_data <- data.table(
   Local.Time.YYYY = rep(2020, dat_minutes),
   Local.Time.MM = rep(6, dat_minutes),
   Local.Time.DD = rep(10:16, each = 24 * 60),
   Local.Time.HH24 = rep(1:24, each = 60, times = 7),
   Local.Time.MI = rep(0:59, times = 7 * 24),
   Precipitation.since.last.observation.in.mm = round(abs(rnorm(
      dat_minutes, mean = 0, sd = 0.2
   )), 1),
   Wind.speed.in.km.h = abs(rnorm(
      dat_minutes, mean = 5, sd = 10
   )),
   Wind.direction.in.degrees.true = runif(n = dat_minutes,
                                          min = 0, max = 359),
   Temperature.in.Degrees.c = rnorm(10080,15,3),
   Relative.Humidity = impute_diurnal(1:10080,
                                      max_obs = 100,
                                      min_obs = 35,
                                      max_hour = 24,
                                      min_hour = 16) * runif(10080,0.8,1.2),
   Station.Number = "16096"
)

# identify lon lat from file ---------------------------------------------------
test_that("`format_weather()` is able to identify the correct lat and lon values
          from file", {
             # create data.frame of station coordinates
             write.csv(data.frame(
                station = c("69061", "16096"),
                lon = c(134.2734, 135.7243),
                lat = c(-33.52662, -33.26625)
             ),
             file = file.path(tempdir(), "stat_coord.csv"))

             dat_minutes <- 10080 # equal to, 7 * 24 * 60

             weather_dt <- format_weather(
                w = weather_station_data,
                YYYY = "Local.Time.YYYY",
                MM = "Local.Time.MM",
                DD = "Local.Time.DD",
                hh = "Local.Time.HH24",
                mm = "Local.Time.MI",
                rain = "Precipitation.since.last.observation.in.mm",
                ws = "Wind.speed.in.km.h",
                wd = "Wind.direction.in.degrees.true",
                temp = "Temperature.in.Degrees.c",
                rh = "Relative.Humidity",
                station = "Station.Number",
                lonlat_file = file.path(tempdir(), "stat_coord.csv"),
                time_zone = "UTC"
             )

             expect_s3_class(weather_dt, "epiphy.weather")
             expect_equal(
                names(weather_dt),
                c(
                   "times",
                   "temp","rh",
                   "rain",
                   "ws",
                   "wd",
                   "wd_sd",
                   "lon",
                   "lat",
                   "station",
                   "YYYY",
                   "MM",
                   "DD",
                   "hh",
                   "mm"
                )
             )
             expect_equal(dim(weather_dt), c(168, 15))
             expect_true(anyNA(weather_dt$lon) == FALSE)
             expect_true(anyNA(weather_dt$lat) == FALSE)
             expect_equal(unique(weather_dt$lon), 135.7243)
             expect_equal(unique(weather_dt$lat), -33.26625)
             expect_s3_class(weather_dt$times, "POSIXct")
             expect_equal(attributes(weather_dt$times)$tzone, "UTC")
             expect_equal(as.character(min(weather_dt$times)),
                          "2020-06-10 01:00:00")
             expect_equal(as.character(max(weather_dt$times)), "2020-06-17")
             expect_equal(round(min(weather_dt$rain), 0), 7)
             expect_equal(round(max(weather_dt$rain), 1), 12.4)
             expect_equal(round(min(weather_dt$ws), 1), 6.5)
             expect_equal(round(max(weather_dt$ws), 2), 10.99, tolerance = 0.00001)
             expect_equal(round(min(weather_dt$wd), 0), 1)
             expect_equal(round(max(weather_dt$wd), 1), 358.3)
             expect_equal(round(min(weather_dt$wd_sd), 0), 82)
             expect_equal(round(max(weather_dt$wd_sd), 0), 195)
             expect_equal(mean(weather_dt$YYYY), 2020)
             expect_equal(mean(weather_dt$MM), 6)
             expect_equal(min(weather_dt$DD), 10)
             expect_equal(max(weather_dt$DD), 16)
             expect_equal(min(weather_dt$hh), 1)
             expect_equal(max(weather_dt$hh), 24)
             expect_equal(mean(weather_dt$mm), 0)
             expect_equal(lubridate::year(weather_dt[,times]), weather_dt[,YYYY])
             expect_equal(lubridate::month(weather_dt[,times]), weather_dt[,MM])
             # expect_equal(lubridate::day(weather_dt[,times]), weather_dt[,DD])
             # expect_equal(lubridate::hour(weather_dt[,times]), weather_dt[,hh])
             expect_equal(lubridate::minute(weather_dt[,times]), weather_dt[,mm])

             unlink(file.path(tempdir(), "stat_coord.csv"))
          })

# when more than one station is supplied, lapply is used -----------------------

test_that("`format_weather()` handles multiple stations", {
   scaddan <-
      system.file("extdata", "scaddan_weather.csv", package = "epiphytoolR")
   naddacs <-
      system.file("extdata", "naddacs_weather.csv", package = "epiphytoolR")

   weather_file_list <- list(scaddan, naddacs)
   weather_station_data <-
      lapply(X = weather_file_list, FUN = read.csv)

   weather_station_data <- do.call("rbind", weather_station_data)

   weather_station_data$Local.Time <-
      as.POSIXct(weather_station_data$Local.Time, format = "%Y-%m-%d %H:%M:%S")


   # a missing time at "2020-10-03 16:00:00" in scaddan data causes NAs to be
   #  filled into all data inputs
   # this creates a error later due to .check_weather()
   expect_error(suppressWarnings(
      format_weather(
         w = weather_station_data[c(1:4123,4125:8785),], # remove one row
         POSIXct_time = "Local.Time",
         ws = "meanWindSpeeds",
         wd_sd = "stdDevWindDirections",
         rain = "Rainfall",
         temp = "Temperature",
         wd = "meanWindDirections",
         lon = "Station.Longitude",
         lat = "Station.Latitude",
         station = "StationID",
         time_zone = "Australia/Brisbane",
         impute_nas = FALSE
      )
   ), regexp = "NA values in *")

   expect_warning(expect_warning(
   weather_dat <- format_weather(
      w = weather_station_data[c(1:4123,4125:8785),],
      POSIXct_time = "Local.Time",
      ws = "meanWindSpeeds",
      wd_sd = "stdDevWindDirections",
      rain = "Rainfall",
      wd = "meanWindDirections",
      lon = "Station.Longitude",
      lat = "Station.Latitude",
      station = "StationID",
      time_zone = "Australia/Adelaide",
      impute_nas = FALSE,
      data_check = FALSE
      )))

   expect_s3_class(weather_dat, "epiphy.weather")
   expect_equal(
      names(weather_dat),
      c(
         "times",
         "temp",
         "rh",
         "rain",
         "ws",
         "wd",
         "wd_sd",
         "lon",
         "lat",
         "station",
         "YYYY",
         "MM",
         "DD",
         "hh",
         "mm"
      )
   )
   expect_equal(dim(weather_dat), c(8786, 15))
   expect_true(anyNA(weather_dat$lon) == FALSE)
   expect_true(anyNA(weather_dat$lat) == FALSE)
   expect_equal(round(unique(weather_dat$lon), 1), c(135.9,135.7))
   expect_equal(round(unique(weather_dat$lat), 1), c(-33.3,-33.1))
})

# identify lon lat from cols ---------------------------------------------------
test_that("`format_weather()` works when lat lon are in data", {
   dat_minutes <- 10080 # equal to, 7 * 24 * 60

   w_station_data <- weather_station_data[ , c("lon","lat") := .(135.7243, -33.26625)]


   weather_dt <- format_weather(
      w = w_station_data,
      YYYY = "Local.Time.YYYY",
      MM = "Local.Time.MM",
      DD = "Local.Time.DD",
      hh = "Local.Time.HH24",
      mm = "Local.Time.MI",
      rain = "Precipitation.since.last.observation.in.mm",
      temp = "Temperature.in.Degrees.c",
      rh = "Relative.Humidity",
      ws = "Wind.speed.in.km.h",
      wd = "Wind.direction.in.degrees.true",
      station = "Station.Number",
      lon = "lon",
      lat = "lat",
      time_zone = "UTC",
      data_check = c("temp","rain","ws","wd")
   )

   expect_s3_class(weather_dt, "epiphy.weather")
   expect_named(
      weather_dt,
      c(
         "times",
         "temp",
         "rh",
         "rain",
         "ws",
         "wd",
         "wd_sd",
         "lon",
         "lat",
         "station",
         "YYYY",
         "MM",
         "DD",
         "hh",
         "mm"
      )
   )
   expect_equal(dim(weather_dt), c(168, 15))
   expect_s3_class(weather_dt$times, "POSIXct")
   expect_true(anyNA(weather_dt$times) == FALSE)
   expect_true(max(weather_dt$wd, na.rm = TRUE) < 360)
   expect_true(min(weather_dt$wd, na.rm = TRUE) > 0)
   expect_true(lubridate::tz(weather_dt$times) == "UTC")
})

# stop if `x` is not a data.frame object ---------------------------------------
test_that("`format_weather()` stops if `x` is not a data.frame object", {
   expect_error(
      weather_dt <- format_weather(
         w = list(),
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lon = "lon",
         lat = "lat",
         POSIXct_time = "times"
      ),
      regexp = "`w` must be provided as a `data.frame` object*"
   )
})

# stop if time isn't given in any col ------------------------------------------
test_that("`format_weather()` stops if time cols are not provided", {
   dat_minutes <- 10080 # equal to, 7 * 24 * 60

   weather_dt <- format_weather(
      w = weather_station_data,
      YYYY = "Local.Time.YYYY",
      MM = "Local.Time.MM",
      DD = "Local.Time.DD",
      hh = "Local.Time.HH24",
      mm = "Local.Time.MI",
      rain = "Precipitation.since.last.observation.in.mm",
      temp = "Temperature.in.Degrees.c",
      rh = "Relative.Humidity",
      ws = "Wind.speed.in.km.h",
      wd = "Wind.direction.in.degrees.true",
      station = "Station.Number",
      lon = "lon",
      lat = "lat",
      time_zone = "UTC",
      data_check = c("temp","rain","ws","wd")
      )

   expect_error(
      weather_dt <- format_weather(
         w = weather_station_data,
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lon = "lon",
         lat = "lat"
      ),
      regexp = "You must provide time values either as a*"
   )
})

# stop if lonlat file lacks proper field names ---------------------------------
test_that("`format_weather() stops if lonlat input lacks proper names", {
   # create a dummy .csv with misnamed cols
   write.csv(data.frame(
      stats = c("69061", "16096"),
      long = c(134.2734, 135.7243),
      lat = c(-33.52662, -33.26625)
   ),
   file = file.path(tempdir(), "stat_coord.csv"))

   dat_minutes <- 10080 # equal to, 7 * 24 * 60


   # weather_station_data <- data.table(
   #    Local.Time.YYYY = rep(2020, dat_minutes),
   #    Local.Time.MM = rep(6, dat_minutes),
   #    Local.Time.DD = rep(10:16, each = 24 * 60),
   #    Local.Time.HH24 = rep(1:24, each = 60, times = 7),
   #    Local.Time.MI = rep(0:59, times = 7 * 24),
   #    Precipitation.since.last.observation.in.mm = round(abs(rnorm(
   #       dat_minutes, mean = 0, sd = 0.2
   #    )), 1),
   #    Wind.speed.in.km.h = abs(rnorm(
   #       dat_minutes, mean = 5, sd = 10
   #    )),
   #    Wind.direction.in.degrees.true =
   #       runif(n = dat_minutes, min = 0, max = 359),
   #    Station.Number = "16096",
   #    lon = 135.7243,
   #    lat = -33.26625
   # )

   expect_error(
      format_weather(
         w = weather_station_data,
         YYYY = "Local.Time.YYYY",
         MM = "Local.Time.MM",
         DD = "Local.Time.DD",
         hh = "Local.Time.HH24",
         mm = "Local.Time.MI",
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lonlat_file = file.path(tempdir(), "stat_coord.csv"),
         time_zone = "UTC"
      ), regexp = "The CSV file of weather station coordinates should contain column names *"
   )

   unlink(file.path(tempdir(), "stat_coord.csv"))
})

# stop if no lonlat info provided ----------------------------------------------
test_that("`format_weather() stops if lonlat input lacks proper names", {
   dat_minutes <- 10080 # equal to, 7 * 24 * 60

   # weather_station_data <- data.table(
   #    Local.Time.YYYY = rep(2020, dat_minutes),
   #    Local.Time.MM = rep(6, dat_minutes),
   #    Local.Time.DD = rep(10:16, each = 24 * 60),
   #    Local.Time.HH24 = rep(1:24, each = 60, times = 7),
   #    Local.Time.MI = rep(0:59, times = 7 * 24),
   #    Precipitation.since.last.observation.in.mm = round(abs(rnorm(
   #       dat_minutes, mean = 0, sd = 0.2
   #    )), 1),
   #    Wind.speed.in.km.h = abs(rnorm(
   #       dat_minutes, mean = 5, sd = 10
   #    )),
   #    Wind.direction.in.degrees.true =
   #       runif(n = dat_minutes, min = 0, max = 359),
   #    Station.Number = "16096",
   #    lon = 135.7243,
   #    lat = -33.26625
   # )

   expect_error(
      weather_dt <- format_weather(
         w = weather_station_data,
         YYYY = "Local.Time.YYYY",
         MM = "Local.Time.MM",
         DD = "Local.Time.DD",
         hh = "Local.Time.HH24",
         mm = "Local.Time.MI",
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         time_zone = "UTC"
      ),
      regexp = "You must provide lonlat values for the weather *"
   )
   unlink(file.path(tempdir(), "stat_coord.csv"))
})


# fill missing mm --------------------------------------------------------------
test_that("`format_weather() creates a `mm` column if not provided", {
   dat_minutes <- 10080 # equal to, 7 * 24 * 60

   time1 <- seq(from = as.POSIXct("2020-06-10 00:00:00"),
                to = as.POSIXct("2020-06-16 23:59:59"),
                length.out = 10080)

   weather_station_data <- data.table(
      Local.Time.YYYY = year(time1),
      Local.Time.MM = month(time1),
      Local.Time.DD = as.numeric(format(time1, format = "%d")),
      Local.Time.HH24 = hour(time1),
      Local.Time.mm = minute(time1),
      Precipitation.since.last.observation.in.mm = round(abs(rnorm(
         dat_minutes, mean = 0, sd = 0.2
      )), 1),
      Wind.speed.in.km.h = abs(rnorm(
         dat_minutes, mean = 5, sd = 10
      )),
      Temperature = rnorm(10080, cos((1:25+18)/3.8)*11+25, sd = 2),
      RelativeHumidity = impute_diurnal(h = 1:10080,
                                        l_out = 1440),
      Wind.direction.in.degrees.true =
         runif(n = dat_minutes, min = 0, max = 359),
      Station.Number = "16096",
      lon = 135.7243,
      lat = -33.26625
   )

   expect_named(
      weather_dt <- format_weather(
         w = weather_station_data,
         YYYY = "Local.Time.YYYY",
         MM = "Local.Time.MM",
         DD = "Local.Time.DD",
         hh = "Local.Time.HH24",
         mm = "Local.Time.mm",
         rain = "Precipitation.since.last.observation.in.mm",
         temp = "Temperature",
         rh = "RelativeHumidity",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lat = "lat",
         lon = "lon",
         time_zone = "UTC",
         data_check = c("temp","rain","ws","wd")
      ),
      c(
         "times",
         "temp",
         "rh",
         "rain",
         "ws",
         "wd",
         "wd_sd",
         "lon",
         "lat",
         "station",
         "YYYY",
         "MM",
         "DD",
         "hh",
         "mm"
      )
   )
})

# fill create YYYY, MM, DD hhmm cols from POSIXct ------------------------------
test_that("`format_weather() creates a YYYY MM DD... cols", {
   dat_minutes <- 10080 # equal to, 7 * 24 * 60

   weather_station_data <- data.table(
      Precipitation.since.last.observation.in.mm = round(abs(rnorm(
         dat_minutes, mean = 0, sd = 0.2
      )), 1),
      Wind.speed.in.km.h = abs(rnorm(
         dat_minutes, mean = 5, sd = 10
      )),
      Wind.direction.in.degrees.true =
         runif(n = dat_minutes, min = 0, max = 359),
      Station.Number = "16096",
      Ptime = seq(ISOdate(2000, 1, 1), by = "1 min", length.out = dat_minutes),
      lon = 135.7243,
      lat = -33.26625,
      time_zone = c("Australia/Adelaide"),
      Temperature = rnorm(dat_minutes,20,10),
      RelativeHumidity = impute_diurnal(h = 1:10080,
                                        l_out = 1440)
   )

   expect_warning(
   expect_named(
      format_weather(
         w = weather_station_data,
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         temp = "Temperature",
         rh = "RelativeHumidity",
         station = "Station.Number",
         lat = "lat",
         lon = "lon",
         POSIXct_time = "Ptime",
         time_zone = "Australia/Brisbane",
         data_check = c("temp","rain","ws","wd")
      ),
      c(
         "times",
         "temp",
         "rh",
         "rain",
         "ws",
         "wd",
         "wd_sd",
         "lon",
         "lat",
         "station",
         "YYYY",
         "MM",
         "DD",
         "hh",
         "mm"
      )
   ))
})

# Warning if `wd_sd` is missing or cannot be calculated ---------------------------
test_that("`format_weather() warns if `wd_sd` is not available", {
   # weather_station_data <- data.table(
   #    Precipitation.since.last.observation.in.mm = round(abs(rnorm(
   #       24, mean = 0, sd = 0.2
   #    )), 1),
   #    Wind.speed.in.km.h = abs(rnorm(24, mean = 5, sd = 10)),
   #    Wind.direction.in.degrees.true =
   #       runif(n = 24, min = 0, max = 359),
   #    Station.Number = "16096",
   #    Ptime = seq(ISOdate(2000, 1, 1), by = "1 hour", length.out = 24),
   #    lon = 135.7243,
   #    lat = -33.26625
   # )
   w_station_data <-
      cbind(weather_station_data,
            data.table("Ptime" = seq(ISOdate(2000, 1, 1),
                                            by = "1 hour",
                                            length.out = 10080)))

   expect_warning(
   expect_error(
      format_weather(
         w = w_station_data,
         YYYY = "Local.Time.YYYY",
         MM = "Local.Time.MM",
         DD = "Local.Time.DD",
         hh = "Local.Time.HH24",
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         temp = "Temperature.in.Degrees.c",
         rh = "Relative.Humidity",
         station = "Station.Number",
         lat = "lat",
         lon = "lon",
         POSIXct_time = "Ptime",
         time_zone = "Australia/Brisbane"
      ),
      regexp = "*Relative humidity inputs are outside expected ranges*"
   ),regexp = "*was unable to detect or calculate `wd_sd`*")
})

# stop if no raster, `r` or `time_zone` provided -------------------------------
test_that("`format_weather() stops if `time_zone` cannot be determined", {
   weather_station_data <- data.table(
      Precipitation.since.last.observation.in.mm = round(abs(rnorm(
         24, mean = 0, sd = 0.2
      )), 1),
      Wind.speed.in.km.h = abs(rnorm(24, mean = 5, sd = 10)),
      Wind.direction.in.degrees.true =
         runif(n = 24, min = 0, max = 359),
      Station.Number = "16096",
      Ptime = seq(ISOdate(2000, 1, 1), by = "1 hour", length.out = 24),
      lon = 135.7243,
      lat = -33.26625
   )

   expect_error(
      format_weather(
         w = weather_station_data,
         YYYY = "Local.Time.YYYY",
         MM = "Local.Time.MM",
         DD = "Local.Time.DD",
         hh = "Local.Time.HH24",
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lat = "lat",
         lon = "lon",
         POSIXct_time = "Ptime"
      ),
      regexp =  "Please include the `time_zone*"
   )
})


test_that("format_weather detects impossible times", {
   raw_weather <- data.table(
      Year = rep(2020, 14 * 24 * 60),
      Month = rep(6, 14 * 24 * 60),
      Day = rep(rep(1:7, each = 24 * 60), 2),
      Hour = rep(rep(0:23, each = 60), 14),
      Minute = rep(1:60, 14 * 24),
      WindSpeed = abs(rnorm(14 * 24 * 60, 1, 3)),
      WindDirectionDegrees = round(runif(14 * 24 * 60, 0, 359)),
      Rainfall = floor(abs(rnorm(14 * 24 * 60, 0, 1))),
      stationID = rep(c("12345", "54321"), each = 7 * 24 * 60),
      StationLongitude = rep(c(134.123, 136.312), each = 7 * 24 * 60),
      StationLatitude = rep(c(-32.321, -33.123), each = 7 * 24 * 60)
   )


   expect_warning(expect_error(
      format_weather(
         w = raw_weather,
         YYYY = "Year",
         MM = "Month",
         DD = "Day",
         hh = "Hour",
         mm = "Minute",
         ws = "WindSpeed",
         rain = "Rainfall",
         wd = "WindDirectionDegrees",
         lon = "StationLongitude",
         lat = "StationLatitude",
         station = "stationID",
         time_zone = "Australia/Darwin"
      ), regexp = "Time records contain NA values or duplicated times *"
   ))
})

set.seed(27)
# create data.frame of station coordinates
write.csv(data.frame(
   station = c("069061", "016096"),
   lon = c(134.2734, 135.7243),
   lat = c(-33.52662,-33.26625)
),
file = file.path(tempdir(), "stat_coord.csv"))

dat_minutes <- 60 * 24 * 365

weather_station_data <- data.table(
   Time = seq(from = as.POSIXct("2020-01-01 01:00:00", format = "%Y-%m-%d %H:%M:%S"),
              length.out = dat_minutes,
              by = "1 min"),
   Precipitation.since.last.observation.in.mm = round(abs(rnorm(
      dat_minutes, mean = 0, sd = 0.2
   )), 1),
   Wind.speed.in.km.h = abs(rnorm(
      dat_minutes, mean = 5, sd = 10
   )),
   Wind.direction.in.degrees.true = runif(n = dat_minutes,
                                          min = 0, max = 359),
   Station.Number = rep("016096", dat_minutes),
   Temperature.in.Degrees.c = rnorm(dat_minutes,15,3),
   Relative.Humidity = impute_diurnal(1:dat_minutes,
                                      max_obs = 100,
                                      min_obs = 35,
                                      max_hour = 24,
                                      min_hour = 16) * runif(dat_minutes,0.8,1.2)
)

test_that("format weather can handle local timezones with daylight savings and
          save and read back in preformated data",{
expect_no_error({
      test10 <- format_weather(
      w = weather_station_data,
      POSIXct_time = "Time",
      rain = "Precipitation.since.last.observation.in.mm",
      ws = "Wind.speed.in.km.h",
      wd = "Wind.direction.in.degrees.true",
      #temp = "Temperature.in.Degrees.c",
      rh = "Relative.Humidity",
      station = "Station.Number",
      lonlat_file = file.path(tempdir(), "stat_coord.csv"),
      time_zone = "Australia/Sydney",
      data_check = FALSE,
      verbose = FALSE)
   }
   )
   expect_false(test10[, any(is.na(lat))])
   expect_false(test10[, any(is.na(lon))])

   # since R 4.3 write.csv saves midnight date-times as date without 00:00:00
   # therefore we need data.tables fwrite function
   w_path <- paste(tempdir(), "weather_saved.csv", sep = "\\")

   write.csv(test10, file = w_path,
             row.names = FALSE)
   weather2 <- read.csv(w_path, stringsAsFactors = FALSE)

   # Verbose = valse to suppress warnings on original run but not on reformating
   expect_warning(test11 <- format_weather(weather2, time_zone = "UTC",
                                           data_check = c("temp","rain","ws","wd")),
                  regexp = "All temperature values are 'NA' or missing*")
   expect_warning(format_weather(weather2, time_zone = "Australia/Perth",
                                 data_check = c("temp","rain","ws","wd")),
                  regexp = "All temperature values are 'NA' or missing*")


   expect_equal(class(test11), c("epiphy.weather", "data.table", "data.frame"))
   expect_equal(class(test11[,times]), c("POSIXct", "POSIXt"))
   expect_equal(dim(test11), c(8760,15))

   expect_warning(format_weather(weather2, time_zone = "Australia/Sydney",
                                 data_check = c("temp","rain","ws","wd")),
                  regexp = "All temperature values are 'NA' or missing*")
   # tidy up
   unlink(w_path)
})


test_that("lat and lon are correctly parsed from file to dataset", {


   weather_station_data[, Station.Number := 016096]

   expect_error(
      test10.1 <- format_weather(
         w = weather_station_data,
         POSIXct_time = "Time",
         rain = "Precipitation.since.last.observation.in.mm",
         ws = "Wind.speed.in.km.h",
         wd = "Wind.direction.in.degrees.true",
         station = "Station.Number",
         lonlat_file = file.path(tempdir(), "stat_coord.csv"),
         time_zone = "Australia/Sydney"
      ),
      regexp = "'station' name '16096' cannot be found in latlon_file."
   )
})


test_that("`format_weather()` fills missing time", {
   scaddan <-
      system.file("extdata", "scaddan_weather.csv", package = "epiphytoolR")

   weather_station_data <- read.csv(scaddan)

   weather_station_data$Local.Time <-
      as.POSIXct(weather_station_data$Local.Time, format = "%Y-%m-%d %H:%M:%S",tz = "Australia/Brisbane")

   # remove ten readings
   weather_station_data <-
      weather_station_data[-(10:19),]

   expect_warning(
      expect_warning(
         expect_warning(
     weather_dat <- format_weather(
        w = weather_station_data,
        POSIXct_time = "Local.Time",
        ws = "meanWindSpeeds",
        wd_sd = "stdDevWindDirections",
        rain = "Rainfall",
        wd = "meanWindDirections",
        lon = "Station.Longitude",
        lat = "Station.Latitude",
        station = "StationID",
        time_zone = "Australia/Brisbane",
        data_check = c("temp","rain","ws","wd")),
     regexp = "*data contains NA values, imputing missing values"),
     regexp = "*data contains NA values, imputing missing values"),
     regexp = "Non-continuous data detected. Extra lines will be merged into data")


})

test_that("`format_weather()` works with blackspot vignette", {
   naddacs_weather <-
      read.csv(system.file("extdata", "naddacs_weather.csv", package = "epiphytoolR"))
   scaddan_weather <-
      read.csv(system.file("extdata", "scaddan_weather.csv", package = "epiphytoolR"))

   raw_weather <- rbind(naddacs_weather,
                        scaddan_weather)

   # All 'rain' data must be entered with no missing data
   # Replace NA values in rain with zeros
   # raw_weather[is.na(raw_weather$Rainfall),]

   # Format time into POSIX central time
   raw_weather$Local.Time <-
      lubridate::as_datetime(raw_weather$Local.Time)
   raw_weather$RelativeHumidity <-
      impute_diurnal(h = 1:dim(raw_weather)[1],
                     l_out = 1440)

   weather <- format_weather(
      w = raw_weather,
      POSIXct_time = "Local.Time",
      ws = "meanWindSpeeds",
      wd_sd = "stdDevWindDirections",
      rain = "Rainfall",
      temp = "Temperature",
      rh = "RelativeHumidity",
      wd = "meanWindDirections",
      lon = "Station.Longitude",
      lat = "Station.Latitude",
      station = "StationID",
      time_zone = "UTC",
      data_check = c("temp","rain","ws","wd")
   )
   expect_equal(dim(weather), c(8786,15))

})

test_that("I can make fake datasets and format them through preformat",{

   set.seed(753)
   for(i in 1:10) {
      dat <- data.table(
         station_name = paste0("w_STATION", i),
         lat = runif(1, 15.5, 28),
         lon = -runif(1, 115, 150),
         state = "SA",
         yearday = 1:365,
         temp = replicate(365,
                          mean(impute_diurnal(max_obs = runif(1,20,35),
                               min_obs = runif(1,-4,20),
                               max_hour = 14,min_hour = round(runif(1,3,6))
                               ))),
         rh = replicate(365,
                               mean(impute_diurnal(max_obs = runif(1,75,100),
                                                   min_obs = runif(1,30,75))
                               )),
         wd_rw = abs(rnorm(365, 180, 90)),
         wd_sd_rw = rnorm(365, 80, 20),
         ws_rw = runif(365, 1, 60),
         ws_sd_rw = abs(rnorm(365, 10, sd = 5)),
         rain_freq = runif(365, 0.05, 0.45)
      )
      if (i == 1) {
         test_dat <- dat
      } else{
         test_dat <- rbind(test_dat, dat)
      }

   }

   out1 <- calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1)
   out1$rh <- 70
   #expect_warning(format_weather(out1, time_zone = "UTC"))
   format_weather(out1, time_zone = "UTC",
                  data_check = FALSE)

   expect_s3_class(out1,"epiphy.weather")

})

test_that("Fill missing pulls weather from openmet",{
   brisvegas <-
      system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
   bris <- fread(brisvegas)
   # Format times
   bris[,aifstime_utc := as.POSIXct(aifstime_utc,tz = "UTC")]

   # suppress all the other warnings indicating what is wrong
      suppressWarnings({
         expect_error(
            format_weather(w = bris,
                        POSIXct_time = "aifstime_utc",
                        temp = "air_temp",
                        rain = "rain_ten",
                        rh = "rel_hum",
                        ws = "wind_spd_kmh",
                        wd = "wind_dir_deg",
                        lon = "lon",
                        lat = "lat",
                        station = "name",
                        time_zone = "UTC"),
         regexp = "NA values")
      })
      bris_fixed <-
         fill_time_gaps(bris,"aifstime_utc")

      # suppress circular warnings
      suppressWarnings({
         expect_no_error(
            format_weather(w = bris_fixed,
                           POSIXct_time = "aifstime_utc",
                           temp = "air_temp",
                           rain = "rain_ten",
                           rh = "rel_hum",
                           ws = "wind_spd_kmh",
                           wd = "wind_dir_deg",
                           lon = "lon",
                           lat = "lat",
                           station = "name",
                           time_zone = "UTC",
                           fill_missing = TRUE,)
         )
         })


})



# import BOM data file
brisvegas <-
   system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
bris <- fread(brisvegas)
# Format times
bris[,aifstime_utc := as.POSIXct(aifstime_utc,tz = "UTC")]

# fill time gaps
bris <- fill_time_gaps(bris,"aifstime_utc")

# replace dashes with zeros
bris[rain_trace == "-", rain_trace := "0"]
bris[, rain_trace := as.numeric(rain_trace)]
# get rainfall for each time
bris[, rain := rain_trace - shift(rain_trace, type = "lead")][rain < 0, rain := rain_trace ]

# order the data by time
bris <- bris[order(aifstime_utc)]

#impute temperature
bris[is.na(air_temp), air_temp := impute_diurnal(aifstime_utc,
                                                 min_obs = 10,max_obs = 28,
                                                 max_hour = 14, min_hour = 5)]
bris[is.na(rain), rain := 0]


test_that("Non-unique stations and coordinates are detected",{

   b_wther <-
      system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
   b_wther<- fread(b_wther)

   # This function causes a warning due to non-continuous weather data
   # data_check is set to false to
   expect_warning(
      expect_warning(
         expect_warning(
      out <-
      format_weather(w = b_wther,
                  POSIXct_time = "aifstime_utc",
                  temp = "air_temp",
                  rain = "rain_ten",
                  rh = "rel_hum",
                  ws = "wind_spd_kmh",
                  wd = "wind_dir_deg",
                  lon = "lon",
                  lat = "lat",
                  station = "name",
                  time_zone = "UTC",
                  data_check = FALSE),
      regexp = "*data contains NA values, imputing missing values"),
   regexp = "*data contains NA values, imputing missing values"),
regexp = "Non-continuous data detected. Extra lines will be merged into data")

   expect_false(any(duplicated(out$times)))
})
#-----------------------------------------------------------------
# enter test with non-unique station lat lon combinations here


# test_that("Relative humidity formats",{
#    # expect_warning(expect_no_error(
#    # bris_formated <- format_weather(
#    #    w = bris,
#    #    POSIXct_time = "aifstime_utc",
#    #    time_zone = "UTC",
#    #    temp = "air_temp",
#    #    rh = "rel_hum",
#    #    rain = "rain_trace",
#    #    ws = "wind_spd_kmh",
#    #    wd = "wind_dir_deg",
#    #    station = "name",
#    #    lon = "lon",
#    #    lat = "lat",
#    #    data_check = c("temp","rain")
#    # )),regexp = "No observations*")
#
#    bris_formated[,rh := fifelse(is.na(rh),shift(rh,n=24,type = "lag"),
#                                rh)]
#
# })

# Relative humidity added
# test_that("weather values are imputed",{
#    wdata <- fread("/home/paul/weather_data/23-24_Applethorpe.csv")
#
#    wdata[,aifstime_utc := as.POSIXct(as.character(aifstime_utc),
#                                      format = "%Y%m%d%H%M%S",
#                                      tz = "UTC")]
#
#    wdata <- wdata[order(aifstime_utc)]
#
#    # Check for error entries
#    wdata[rain_ten < 0, rain_ten := 0]
#
#    tm_out <- which(wdata$air_temp < -30 |
#                       wdata$air_temp > 60)
#    wdata[tm_out,air_temp := NA_real_]
#    wdata[tm_out, air_temp := frollmean(air_temp,
#                                        n = 5,
#                                        align = "center",
#                                        na.rm = TRUE)]
#
#    rh_out <- which(wdata$rel_hum < 0 |
#                       wdata$rel_hum > 100)
#    wdata[rh_out,rel_hum := NA_real_]
#    wdata[rh_out, rel_hum := frollmean(rel_hum,
#                                       n = 5,
#                                       align = "center",
#                                       na.rm = TRUE)]
#
#    ws_out <- which(wdata$wind_spd_kmh < 0 |
#                       wdata$wind_spd_kmh > 150)
#    wdata[ws_out, wind_spd_kmh := NA_real_]
#    wdata[ws_out, wind_spd_kmh := frollmean(wind_spd_kmh,
#                                            n = 5,
#                                            align = "center",
#                                            na.rm = TRUE)]
#
#    wd_out <- which(wdata$wind_dir_deg < 0 |
#                       wdata$wind_dir_deg > 360)
#    wdata[wd_out, wind_dir_deg := NA_real_]
#    circle_mean <- function(x){
#       as.numeric(circular::mean.circular(
#          circular::circular(x,
#                             units = "degrees",
#                             modulo = "2pi"),
#          na.rm = TRUE))}
#    wdata[wd_out, wind_dir_deg := frollapply(wind_dir_deg,
#                                             n = 3,
#                                             FUN = circle_mean,
#                                             align = "center")]
#
#    data <-
#       epiphytoolR::format_weather(
#          wdata,
#          POSIXct_time = "aifstime_utc",
#          time_zone = "UTC",
#          temp = "air_temp",
#          rain = "rain_ten",
#          rh = "rel_hum",
#          ws = "wind_spd_kmh",
#          wd = "wind_dir_deg",
#          station = "name",
#          lon = "lon",
#          lat = "lat",
#          impute_nas = c("temp","rh","rain"),
#          Irolling_window = 60)
#
# })

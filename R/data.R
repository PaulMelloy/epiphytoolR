#' Simulated weather data
#'
#' Simulated weather data from two weather stations
#'
#' @format ## `weather`
#' A data frame with 8,786 rows and 15 columns:
#' \describe{
#'   \item{times}{record time from weather station}
#'   \item{temp}{hourly mean temperature in degrees}
#'   \item{rh}{hourly mean relative humidity}
#'   ...
#' }
#' @source simlulated
"weather"


#raw_bom_file <- system.file("/extdata/bom_data.csv",package = "epiphytoolR")
#raw_bom <- fread(raw_bom_file)

#' Mock Bureau of Meteorology weather data
#'
#' Simulated raw weather data from AWS weather station
#'
#' @return A data frame with 8,786 rows and 15 columns:
#' \describe{
#'   \item{times}{record time from weather station}
#'   \item{temp}{hourly mean temperature in degrees}
#'   \item{rh}{hourly mean relative humidity}
#'   ...
#' }
#' @source simlulated
#' @export
#'
#' @examples
#' raw_bom <- make_bom_data()
make_bom_data <-
   function() {
      set.seed(124)
      time_series <-
         as.POSIXct("2019-01-01") +
         seq(from = 0,
             to = 365 * 24 * 60 * 60 * 3,
             by = 60)
      ts_length <- length(time_series)

      raw_bom <- data.table::data.table(
         hd = "hd",
         `Station Number` = 90666,
         `Year Month Day Hour Minutes in YYYY` =
            data.table::year(time_series),
         MM = data.table::month(time_series),
         DD = data.table::mday(time_series),
         HH24 = data.table::hour(time_series),
         `MI format in Local time` = data.table::minute(time_series),
         `Precipitation since last (AWS) observation in mm` = rbinom(ts_length, 1, prob = 0.006),
         # frollapply(sapply(rep(0,365*24*60+1),prop_rain,p= 0.007),
         #            n = 3*60,fill = 0,
         #            FUN = prop_rain,p = 0.00007, multiplyr = 2),
         `Quality of precipitation since last (AWS) observation value` = "Y",
         `Period over which precipitation since last (AWS) observation is measured in minutes` = 1,
         `Air Temperature in degrees Celsius` =
            c(replicate(
               365 * 3,
               epiphytoolR::impute_diurnal(
                  h = rep(0:23, each = 60),
                  max_obs = rnorm(1, 26, 3),
                  min_obs = rnorm(1, 10, 3),
                  max_hour = round(runif(1, 12, 16)),
                  min_hour = round(runif(1, 3, 5))
               )
            ), 24),
         `Quality of air temperature` = "Y",
         `Wet bulb temperature in degrees Celsius` =
            c(replicate(
               365 * 3,
               epiphytoolR::impute_diurnal(
                  h = rep(0:23, each = 60),
                  max_obs = rnorm(1, 22, 3),
                  min_obs = rnorm(1, 8, 3),
                  max_hour = round(runif(1, 12, 16)),
                  min_hour = round(runif(1, 3, 5))
               )
            ), 22),
         `Quality of Wet bulb temperature` = "Y",
         `Dew point temperature in degrees Celsius` =
            c(replicate(
               365 * 3,
               epiphytoolR::impute_diurnal(
                  h = rep(0:23, each = 60),
                  max_obs = rnorm(1, 20, 1),
                  min_obs = rnorm(1, 4, 1),
                  max_hour = round(runif(1, 12, 16)),
                  min_hour = round(runif(1, 3, 5))
               )
            ), 18),
         `Quality of dew point temperature` = "Y",
         `Relative humidity in percentage %` =
            c(replicate(
               365 * 3,
               epiphytoolR::impute_diurnal(
                  h = rep(0:23, each = 60),
                  max_obs = runif(1, 70, 100),
                  min_obs = runif(1, 50, 69)
               )
            ), 88),
         `Quality of relative humidity` = "Y",
         `Wind (1 minute) speed in km/h` = round(abs(rnorm(
            ts_length, mean = 4, 7
         )), 3),
         `Wind (1 minute) speed quality` = "Y",
         `Wind (1 minute) direction in degrees true` = round(runif(ts_length, 0, 359), 2),
         `Wind (1 minute) direction quality` = "Y",
         `Standard deviation of wind (1 minute)` = round(runif(ts_length, 0, 5), 2),
         `Standard deviation of wind (1 minute) direction quality` = "Y",
         `Maximum wind gust (over 1 minute) in km/h` = round(abs(rnorm(
            ts_length, mean = 6, 10
         )), 3),
         `Maximum wind gust (over 1 minute) quality` = "N",
         `#` = "#"
      )
      return(raw_bom)
   }

# prop_rain <- function(weit, p = 0.01, multiplyr = 2){
#    stats::rbinom(1,1,prob = p+(mean(weit)*multiplyr))
# }

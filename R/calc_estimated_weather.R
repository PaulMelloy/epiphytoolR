#' Calculate estimated weather from coefficients
#'
#' @param w A `data.table` of weather coefficients, output from `epiphytoolR::get_weather_coefs`
#' @param start_date a character string of a date value indicating the first date
#'  for in the returning data.table Must be in \acronym{ISO8601} format (YYYY-MM-DD),
#'  \emph{e.g.} \dQuote{2020-04-26}
#' @param end_date a character string of a date value indicating the last date
#'  for in the returning data.table Must be in \acronym{ISO8601} format (YYYY-MM-DD),
#'  \emph{e.g.} \dQuote{2020-04-26}
#' @param lat numeric, latitude of the query coordinates where weather should be
#'  estimated
#' @param lon numeric, longitude of the query coordinates where weather should be
#'  estimated
#' @param n_stations integer or vector of integers indicating the number of station/s
#'  to return from the closest (1), or 3rd closest (3) or closest five stations
#'  (1:5). ect
#'
#' @return
#' @export
#'
#' @examples
calc_estimated_weather <- function(w,
                                   start_date = "2023-04-01",
                                   end_date = "2023-11-30",
                                   lat,
                                   lon,
                                   n_stations = 1:4){

   # set some time parameters
   start_date <- as.POSIXct(start_date, tz = "UTC")
   end_date <- as.POSIXct(end_date, tz = "UTC")
   day_in_secs <- (60*60*24)
   year_day1 <- as.POSIXct(paste0(year(start_date),"-01-01"), tz = "UTC") - day_in_secs

   # return weather estimate from the most proximal station
   w_prox <- .closest_station(lat = lat,
                              lon = lon,
                              bom_dat = w,
                              station_indexs = n_stations)

   # add date_time column
   w_prox[,date_times := year_day1 + (day_in_secs * yearday)]

   # subset to date window
   w_prox <- w_prox[date_times >= start_date &
                       date_times <= end_date]

   # NA handling
   if(any(is.na(w_prox$rain_freq)))stop("NA values in rain_freqency")

   if(any(is.na(w_prox$wd_rw))){
      warning(w_prox$station_name[1],": ",sum(is.na(w_prox$wd_rw), " lines have NA data. This is replaced with
                  the overall mean wind direction\n"))
      w_prox[is.na(wd_rw), ]$wd_rw <- mean(w_prox$wd_rw, na.rm = TRUE)
   }
   if(any(is.na(w_prox$wd_sd_rw))){
      warning(w_prox$station_name[1],": ",sum(is.na(w_prox$wd_sd_rw), " wd_sd_rw lines have NA data. This is replaced with
                  the overall mean stdev wind direction\n"))
      w_prox[is.na(wd_sd_rw), ]$wd_sd_rw <- mean(w_prox$wd_sd_rw, na.rm = TRUE)
   }
   if(any(is.na(w_prox$ws_rw))){
      warning(w_prox$station_name[1],": ",sum(is.na(w_prox$ws_rw), " ws_rw lines have NA data. This is replaced with
                  the overall mean stdev wind direction\n"))
      w_prox[is.na(ws_rw), ]$ws_rw <- mean(w_prox$ws_rw, na.rm = TRUE)
   }
   if(any(is.na(w_prox$ws_sd_rw))){
      warning(w_prox$station_name[1],": ",sum(is.na(w_prox$ws_sd_rw), " ws_sd_rw lines have NA data. This is replaced with
                  the overall mean stdev wind direction\n"))
      w_prox[is.na(ws_sd_rw), ]$ws_sd_rw <- mean(w_prox$ws_sd_rw, na.rm = TRUE)
   }

   # Do imputation
   w_prox[, c("rain","temp" ,"ws","wd","wd_sd") :=
             .(rbinom(1,1,rain_freq),
               NA_real_,
               rnorm(1,mean = ws_rw,
                     sd = ws_sd_rw),
               wd_rw,
               wd_sd_rw),
          by = yearday]

   # correct outside normal values
   w_prox[ws < 0, ws := abs(ws)/3]

   w_prox[wd < 0, wd := 360 - wd]
   w_prox[wd >= 360, wd := wd - 360]

   # create a data.table that has date.time in hour increments
   new_w <- data.table::data.table(times = seq(start_date,end_date, by = 3600))

   for(st in unique(w_prox$station_name)){
      if(st == unique(w_prox$station_name)[1]){
         newer_w<- new_w[,station_name := st]
      }else{
         newer_w <-
            rbind(newer_w,
                  new_w[, .(times = times,
                            station_name = st)])
      }
   }
   new_w <- newer_w

   # make a column to merge data.tables on
   new_w[,yearday := yday(times)]

   # merge data.tables so the output is a row for each hour
   new_w <- new_w[w_prox, on = c("yearday","station_name")]

   # Add columns to match format_weather output
   new_w[, c("date_times",
             "YYYY",
             "MM",
             "DD",
             "hh",
             "mm") :=
            .(NULL,
              year(times),
              month(times),
              mday(times),
              hour(times),
              minute(times))]
   setnames(x = new_w,
            old = "station_name",
            new = "station")

   return(new_w)

}

# return a data.set with the closest station to the provided lat and longs
#  or closest stations by an index ie 1:3
# imports data.table
#' Return closest BOM station to coordinates
#'
#' @param lat numeric, latitude of query point
#' @param lon numeric, longitude of query point
#' @param bom_dat A `data.table` an output of `get_weather_coefs.R` with the
#' following columns:
#'  *station_name* - Weather station name;
#'  *lat* - latitude;
#'  *lon* - longitude;
#'  *yearday* - integer, day of the year, see `data.table::yday()`;
#'  *wd_rd* - numeric, mean wind direction from raw data;
#'  *wd_sd_rd* - numeric, standard deviation of wind direction from raw data;
#'  *ws_rd* - numeric, mean wind speed from raw data;
#'  *ws_sd_rd* - numeric, standard deviation of wind speed from raw data;
#'  *rain_freq* - numeric, proportional chance of rainfall on this dat 0 - 1
#' @param station_indexs integer or vector of integers indicating which station
#'  to return from the closest (1), or 3rd closest (3) or closest five stations
#'  (1:5). ect
#'
#' @return  The same input `data.table` but only containing the closest weather
#'  station/s to the query coordinates.
#' @noRd
#' @examples
.closest_station <- function(lat,lon,bom_dat, station_indexs = 1){
   # put queried longitude and latitude in an object for ease on interpretation
   ll <- c(lon,lat)

   # calculate the distance from queried lat and lon to each station
   simp_dat <- unique(bom_dat[,.(station_name,lon,lat)])

   simp_dat$distance <-
      apply(simp_dat, 1, function(Row, ll = c(lon,lat)){
         geosphere::distHaversine(ll,
                                  as.numeric(c(Row["lon"],Row["lat"])))/1000})

   bom_dat <- bom_dat[simp_dat, on = .(station_name, lon,lat)]

   # Simplify the response by returning a vector of unique distances in order from
   #  lowest to highest. This will be used to return the closest stations using the
   #  station index argument.
   S_I <- sort(unique(bom_dat$distance))[station_indexs]

   # return sorted data.table
   return(bom_dat[distance %in% S_I,][order(distance,station_name,yearday)])
}

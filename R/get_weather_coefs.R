#' Calculate weather coefficients
#'
#' @details
#' get_weather_coefs uses historical bom rainfall data to determine the probability of
#'  rainfall on each day of the year. It also summarises the mean temperatures,
#'  wind speed and direction at the time of the rainfall.
#'  Formally called impute_rainywind
#'
#' @param raw_bom_file character, file path to raw bureau of Meteorology txt file
#' @param rolling_window integer, number of days to summarise over a rolling window
#' @param meta_data data.table Bureau of Meteorology, meta-data
#'
#' @return data.table, of coefficients to estimate weather during a rainfall event.
#'  If no rainfall data is recorded in the raw weather NULL is returned without
#'  warning.
#'    wd_rw, mean wind direction from rolling window;
#'    wd_sd_rw, standard deviation of wind direction from rolling window;
#'    ws_rw, mean wind speed from rolling window;
#'    ws_sd_rw, standard deviation of speed from rolling window;
#'    rain_freq, historical probability of rainfall on this day based on a rolling
#'    window.
#' @return A `data.table` of coefficients to estimate weather during a rainfall event.
#'  If no rainfall data is recorded in the raw weather NULL is returned without
#'  warning.
#'  *station_name* - Weather station name;
#'  *lat* - latitude;
#'  *lon* - longitude;
#'  *state* - political juristiction or state;
#'  *yearday* - integer, day of the year, see `data.table::yday()`;
#'  *wd_rd* - numeric, mean wind direction from rolling window;
#'  *wd_sd_rd* - numeric, standard deviation of wind direction from rolling window;
#'  *ws_rd* - numeric, mean wind speed from rolling window;
#'  *ws_sd_rd* - numeric, standard deviation of speed from rolling window;
#'  *rain_freq* - numeric, proportional chance of rainfall on this day 0 - 1 based
#'  on a rolling window.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(data.table)
#' meta_dat <- fread("cache/bom_stations.csv")
#' imp_dat <-
#'    get_weather_coefs(raw_bom_file = "./data/Weather_data/HD01D_Data_090182_999999999959761.txt",
#'                     rolling_window = 60,
#'                     meta_data = meta_dat)}
get_weather_coefs <- function(raw_bom_file,
                             rolling_window = 60,
                             meta_data){

   # Read in raw BOM weather data
   d1 <- fread(raw_bom_file,
               keepLeadingZeros = TRUE,
               colClasses = c(`Station Number` = "character"))


   # correct station number
   st_num <- d1[1,`Station Number`]
   if(nchar(st_num) == 4) st_num <- paste0("00",st_num)
   if(nchar(st_num) == 5) st_num <- paste0("0",st_num)


   # remove duplicate columns
   d1 <- d1[,-c(3:7)]
   d1[,MM := as.integer(MM)]
   d1[,DD := as.integer(DD)]

   # add meta_data
   # find meta_data
   setDT(meta_data)
   meta_data[,station_number := as.character(station_number)][
      ,station_number := fcase(nchar(station_number) == 4, paste0("00",station_number),
                               nchar(station_number) == 5, paste0("0",station_number),
                               nchar(station_number) == 6, station_number,
                               default = NA_character_)]

   mdat <- meta_data[station_number == st_num,.(station_name,lat,lon,state)]

   # create as.numeric columns from minute data
   d1[, mm := as.numeric(`MI format in Local standard time`)]

   # number of NAs to allow, ie half the number of values in the sliding window
   # set middle of rolling window
   n_NA <- ceiling(rolling_window/2)

   # rename columns
   setnames(d1,
            old = c("Year Month Day Hour Minutes in YYYY",
                    "Precipitation since last (AWS) observation in mm",
                    "Air Temperature in degrees Celsius",
                    "Wind (1 minute) direction in degrees true",
                    "Wind (1 minute) speed in km/h",
                    "Air temperature (1-minute minimum) in degrees Celsius",
                    "Air temperature (1-minute maximum) in degrees Celsius"
            ),
            new = c("YYYY",
                    "rain",
                    "tm",
                    "wd",
                    "ws",
                    "min_temp",
                    "max_temp"),
            skip_absent = TRUE
   )

   # if all rain was not collected return nothing
   if(d1[, any(is.na(rain) == FALSE)] == FALSE) return(NULL)

   # initialise coefficient data.table
   dat_coef <- data.table(station_name = mdat$station_name,
                          station_number = mdat$station_number,
                          lat = mdat$lat,
                          lon = mdat$lon,
                          state = mdat$state,
                          yearday = 1:365,
                          min_temp = NA_real_,
                          max_temp = NA_real_,
                          wd_rw = NA_real_,
                          wd_sd_rw = NA_real_,
                          ws_rw = NA_real_,
                          rain_freq = NA_real_)

   # rolling imputation function
   for(index in 1:365){
      # get index day
      index_date <- as.POSIXct("2020-12-31")+(index *(86400)) # 86400 seconds in a day
      index_mon <- data.table::month(index_date)
      index_day <- data.table::mday(index_date)

      # set month day of the year columns in input bom data and filter out data with
      #  large time gaps
      rw_dat <- d1[(MM == data.table::month(as.POSIXct("2020-12-31")+((index-n_NA) *(86400))) &
                       DD >= data.table::mday(as.POSIXct("2020-12-31")+((index-n_NA) *(86400)))) |
                      (MM == data.table::month(as.POSIXct("2020-12-31")+((index+n_NA) *(86400))) &
                          DD <= data.table::mday(as.POSIXct("2020-12-31")+((index+n_NA) *(86400)))) |
                      (MM > data.table::month(as.POSIXct("2020-12-31")+((index-n_NA) *(86400))) &
                          MM < data.table::month(as.POSIXct("2020-12-31")+((index+n_NA) *(86400)))),
      ]



      # get data.table of rainfall days
      daily_rain_frequency <- rw_dat[,.(rain_day = any(rain > 0)),
                                     by= .(YYYY,MM,DD)]

      # fill NAs based on rainfall probabilities
      daily_rain_frequency[is.na(rain_day),
                           rain_day := as.logical(rbinom(1,1,
                                                         mean(daily_rain_frequency$rain_day,
                                                              na.rm = TRUE)))]
      # return the rainfall frequency
      daily_rain_frequency <-
         daily_rain_frequency[,fifelse(
            sum(rain_day,na.rm = TRUE) == 0 |
               is.na(sum(rain_day,na.rm = TRUE)),
            0, mean(rain_day,na.rm = TRUE))]

      if (nrow(rw_dat[rain > 0]) == 0) {
         # if no rainfall in the rolling window return NAs
         dat_coef[index, c("min_temp",
                           "max_temp",
                           "wd_rw",
                           "wd_sd_rw",
                           "ws_rw",
                           "ws_sd_rw",
                           "rain_freq") := .(NA_real_,
                                             NA_real_,
                                             NA_real_,
                                             NA_real_,
                                             NA_real_,
                                             NA_real_,
                                             NA_real_)]
         next
      } else{
         dat_coef[index, c("min_temp",
                           "max_temp",
                           "wd_rw",
                           "wd_sd_rw",
                           "ws_rw",
                           "ws_sd_rw") :=
                     rw_dat[rain >0,
                            .(mean(min_temp, na.rm = TRUE),
                              mean(max_temp, na.rm = TRUE),
                              wd_rw = as.numeric(circular::mean.circular(
                                 circular::circular(wd,
                                                    units = "degrees",
                                                    modulo = "2pi"),
                                 na.rm = TRUE)),
                              wd_sd_rw = as.numeric(circular::sd.circular(
                                 circular::circular(wd,
                                                    units = "degrees",
                                                    modulo = "2pi"),
                                 na.rm = TRUE)*57.29578),
                              ws_rw = mean(ws, na.rm = TRUE),
                              ws_sd_rw = sd(ws, na.rm = TRUE)
                            )]
         ]

      }




      dat_coef[index, rain_freq := daily_rain_frequency]


      # if(index == 1){
      #
      #    # define data.table indexs for window
      #
      #    wind_dat <- rw_dat[rain >0,
      #                       .(wd_rw = as.numeric(circular::mean.circular(
      #                            circular::circular(wd,
      #                                                        units = "degrees",
      #                                                        modulo = "2pi"),
      #                                               na.rm = TRUE)),
      #                         wd_sd_rw = as.numeric(circular::sd.circular(
      #                            circular::circular(wd,
      #                                                         units = "degrees",
      #                                                         modulo = "2pi"),
      #                                                na.rm = TRUE)*57.29578),
      #                         ws_rw = mean(ws, na.rm = TRUE),
      #                         ws_sd_rw = sd(ws, na.rm = TRUE),
      #                         rain_freq = daily_rain_frequency)]# in weather data with minute frequency find the daily probability
      #
      #    if(nrow(wind_dat) == 0){
      #       wind_dat <- rw_dat[,
      #                          .(station_name = mdat$station_name,
      #                            station_number = mdat$station_number,
      #                            lat = mdat$lat,
      #                            lon = mdat$lon,
      #                            state = mdat$state,
      #                            yearday = index,
      #                            wd_rw = as.numeric(circular::mean.circular(
      #                               circular::circular(wd,
      #                                                  units = "degrees",
      #                                                  modulo = "2pi"),
      #                               na.rm = TRUE)),
      #                            wd_sd_rw = as.numeric(circular::sd.circular(
      #                               circular::circular(wd,
      #                                                  units = "degrees",
      #                                                  modulo = "2pi"),
      #                               na.rm = TRUE)*57.29578),
      #                            ws_rw = mean(ws, na.rm = TRUE),
      #                            ws_sd_rw = sd(ws, na.rm = TRUE),
      #                            rain_freq = 0)]
      #    }
      # }else{
      #    # Are there any rain observations which are larger than 0 and not NA
      #    if(nrow(rw_dat[rain >0,] > 0)){
      #       line_dat <-
      #          rw_dat[rain > 0,
      #                 .( station_name = mdat$station_name,
      #                    station_number = mdat$station_number,
      #                    lat = mdat$lat,
      #                    lon = mdat$lon,
      #                    state = mdat$state,
      #                    yearday = index,
      #                    wd_rw = as.numeric(circular::mean.circular(circular::circular(wd,
      #                                                                       units = "degrees",
      #                                                                       modulo = "2pi"),
      #                                                    na.rm = TRUE)),
      #                    wd_sd_rw = as.numeric(circular::sd.circular(circular::circular(wd,
      #                                                                        units = "degrees",
      #                                                                        modulo = "2pi"),
      #                                                     na.rm = TRUE) * 57.29578),
      #                    ws_rw = mean(ws, na.rm = TRUE),
      #                    ws_sd_rw = sd(ws, na.rm = TRUE),
      #                    rain_freq = daily_rain_frequency
      #                 )]
      #
      #       wind_dat <- rbind(wind_dat,line_dat)
      #    }else{
      #       wind_dat <- rbind(wind_dat,
      #                         rw_dat[, .(station_name = mdat$station_name,
      #                                    station_number = mdat$station_number,
      #                                    lat = mdat$lat,
      #                                    lon = mdat$lon,
      #                                    state = mdat$state,
      #                                    yearday = index,
      #                                    wd_rw = as.numeric(circular::mean.circular(
      #                                       circular::circular(wd,
      #                                                          units = "degrees",
      #                                                          modulo = "2pi"),
      #                                       na.rm = TRUE)),
      #                                  wd_sd_rw = as.numeric(circular::sd.circular(
      #                                       circular::circular(wd,
      #                                                          units = "degrees",
      #                                                          modulo = "2pi"),
      #                                       na.rm = TRUE)*57.29578),
      #                                ws_rw = mean(ws, na.rm = TRUE),
      #                                ws_sd_rw = sd(ws, na.rm = TRUE),
      #                                rain_freq = 0)])
      #    }
      # }}
   }
   return(dat_coef)
}
#' Format weather data into a standardised format.
#'
#' Formats raw weather data into an object suitable for use in the affiliated
#'  spore dispersal packages such as `ascotraceR` and `blackspot.sp`. This
#'  standardised data format ensures that the supplied weather data meet the
#'  requirements for functions in the aforementioned packages. Input weather
#'  data expects a 'long' data format, where each line is an observation at
#'  a point in time.
#'
#' @param w a \code{\link{data.frame}} object of weather station data for
#'  formatting.
#' @param YYYY Column name `character` or index in `w` that refers to the year when the
#'   weather was logged.
#' @param MM Column name `character` or index in `w` that refers to the month (numerical)
#'   when the weather was logged.
#' @param DD Column name `character` or index in `w` that refers to the day of month when
#'   the weather was logged.
#' @param hh Column name `character` or index in `w` that refers to the hour (24 hour) when
#'   the weather was logged.
#' @param mm Column name `character` or index in `w` that refers to the minute when the
#'   weather was logged.
#' @param ss Column name `character` or index in `w` that refers to the second when the
#'   weather was logged.
#' @param POSIXct_time Column name `character` or index in `w` which contains a `POSIXct`
#'   formatted time. This can be used instead of arguments `YYYY`, `MM`, `DD`,
#'   `hh`, `mm.`.
#' @param time_zone Local time zone (Olsen time zone format) `character` which was used
#'   for `times` when recording observations times at the weather station. If unsure
#'   and time data has continuity, use "UTC".
#' @param temp Column name `character` or index in `w` that refers to temperature in degrees
#'   Celsius.
#' @param time_zone Time zone (Olsen time zone format) `character` where the
#'   weather station is located. May be in a column or supplied as a character string.
#'   Optional, see also `r`. See details.
#' @param temp Column name `character` or index in `x` that refers to temperature in degrees
#'   Celsius.
#' @param lon Column name `character` or index in `w` that refers to weather station's
#'  `check_weather_warnings()`.
#'   Celsius.
#' @param rain Column name `character` or index in `w` that refers to rainfall in millimetres.
#' @param ws Column name `character` or index in `w` that refers to wind speed in km / h.
#' @param wd Column name `character` or index in `w` that refers to wind direction in
#'   degrees.
#' @param wd_sd Column name `character` or index in `w` that refers to wind speed columns
#'   standard deviation.  This is only applicable if weather data
#'   is already summarised to hourly increments. See details.
#' @param station Column name `character` or index in `w` that refers to the weather station
#'   name or identifier. See details.
#' @param lon Column name `character` or index in `w` that refers to weather station's
#'   longitude. See details.
#' @param lat Column name `character` or index in `w` that refers to weather station's
#'   latitude. See details.
#' @param lonlat_file A file path (`character`) to a \acronym{CSV} which included station
#'   name/id and longitude and latitude coordinates if they are not supplied in
#'   the data. Optional, see also `lon` and `lat`.
#' @param data_check If `TRUE`, it checks for NA values in all 'rain', 'temp',
#'  'rh', 'wd' and 'ws' data and if any values which are unlikely. Use a character
#'  vector of variable names, (wither any of 'rain', 'temp', 'rh', 'wd' or 'ws')
#'  to check data from specific variables. If FALSE it ignores all variables and
#'  could cause subsequent models using this data to fail.
#' @param rh Column name `character` or index in `w` that refers to relative
#'   humidity as a percentage.
#' @details `time_zone` The time-zone in which the `time` was recorded. All weather
#'   stations in `w` must fall within the same time-zone.  If the required stations
#'   are located in differing time zones, `format_weather()` should be run separately
#'   on each object, then data can be combined after formatting.
#' @details `wd_sd` If weather data is
#'   provided in hourly increments, a column
#'   with the standard deviation of the wind direction over the hour is required
#'   to be provided. If the weather data are sub-hourly, the standard deviation
#'   will be calculated and returned automatically.
#' @details `lon`, `lat` and `lonlat_file` If `w` provides longitude and
#'   latitude values for station locations, these may be specified in the `lon`
#'   and `lat` columns.  If the coordinates are not relevant to the study
#'   location `NA` can be specified and the function will drop these column
#'   variables.  If these data are not included, (`NULL`) a separate file may be
#'   provided that contains the longitude, latitude and matching station name to
#'   provide station locations in the final `epiphy.weather` object that is
#'   created by specifying the file path to a \acronym{CSV} file using
#'   `lonlat_file`.
#' @import data.table
#' @return A `epiphy.weather` object (an extension of \CRANpkg{data.table})
#'   containing the supplied weather aggregated to each hour in a suitable
#'   format for use with disease models. Depending on the input weather, classes
#'   will be given to the output object to indicate which models it meets the data
#'   requirements for. Some of the columns returned are as follows:
#'   \tabular{rl}{
#'   **times**: \tab Time in POSIXct format with "UTC" time-zone\cr
#'   **rain**: \tab Rainfall in mm \cr
#'   **temp**: \tab Temperature in degrees celcius \cr
#'   **ws**: \tab Wind speed in km / h \cr
#'   **wd**: \tab Wind direction in compass degrees \cr
#'   **wd_sd**: \tab Wind direction standard deviation in compass degrees \cr
#'   **lon**: \tab Station longitude in decimal degrees \cr
#'   **lat**: \tab Station latitude in decimal degrees \cr
#'   **station**: \tab Unique station identifying name \cr
#'   **YYYY**: \tab Year \cr
#'   **MM**: \tab Month \cr
#'   **DD**: \tab Day \cr
#'   **hh**: \tab Hour \cr
#'   **mm**: \tab Minute \cr}
#'
#' @examples
#' # Weather data files for Newmarracara for testing and examples have been
#' # included in ascotraceR. The weather data files both are of the same format,
#' # so they will be combined for formatting here.
#'
#' # load the weather data to be formatted
#' scaddan <-
#'    system.file("extdata", "scaddan_weather.csv",package = "epiphytoolR")
#' naddacs <-
#'    system.file("extdata", "naddacs_weather.csv",package = "epiphytoolR")
#'
#' weather_file_list <- list(scaddan, naddacs)
#' weather_station_data <-
#'    lapply(X = weather_file_list, FUN = read.csv)
#'
#' weather_station_data <- do.call("rbind", weather_station_data)
#'
#' weather_station_data$Local.Time <-
#'    as.POSIXct(weather_station_data$Local.Time, format = "%Y-%m-%d %H:%M:%S",
#'               tz = "UTC")
#'
#' weather <- format_weather(
#'    w = weather_station_data,
#'    POSIXct_time = "Local.Time",
#'    ws = "meanWindSpeeds",
#'    wd_sd = "stdDevWindDirections",
#'    rain = "Rainfall",
#'    temp = "Temperature",
#'    wd = "meanWindDirections",
#'    lon = "Station.Longitude",
#'    lat = "Station.Latitude",
#'    station = "StationID",
#'    time_zone = "UTC"
#' )
#'
#' # Reformat saved weather
#'
#' # Create file path and save data
#' file_path_name <- paste(tempdir(), "weather_saved.csv", sep = "\\")
#' write.csv(weather, file = file_path_name,
#'           row.names = FALSE)
#'
#' # Read data back in to
#' weather2 <- read.csv(file_path_name, stringsAsFactors = FALSE)
#'
#' # reformat the data to have appropriate column classes and data class
#' weather2 <- format_weather(weather2,
#'                            time_zone = "UTC")
#' unlink(file_path_name) # remove temporary weather file
#' @export
format_weather <- function(w,
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
                           data_check = TRUE) {
  # CRAN Note avoidance
  times <- V1 <- NULL

  # Check w class
  if (!is.data.frame(w)) {
    stop(call. = FALSE,
         "`w` must be provided as a `data.frame` object for formatting.")
  }

  # If a warnings object exists delete it
  if(exists("warn")){
     warn <- NULL
  }

  # is this a pre-formatted data.frame that needs to be reformatted?
  if (all(
    c(
      "times",
      "temp",
      "rain",
      "rh",
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
    ) %in% colnames(w)
  )) {
    # set as data.table
    w <- data.table(w)

    if (is.null(time_zone)) {
      stop(
        "Please provide the timezone of the source weather stations. If this
              was pre-formatted, use 'UTC'"
      )
    } else{
       # check for any midnight times convertee to dates and append HMS
       w[inherits(times,"character") &
            grepl(":", times) == FALSE, times := paste0(times," 00:00:00")]

      w[, times := as.POSIXct(times, tz = "UTC")]
    }
    if (any(is.na(w[, times])) ||
        any(w[, duplicated(times), by = factor(station)][,V1])) {
       stop(
          call. = FALSE,
          times,
          "Time records contain NA values or duplicated times. If this was ",
          "previously formatted with `format_weather()` enter `time_zone = 'UTC'`"
       )}

    setattr(w, "class", union("epiphy.weather", class(w)))

    if(isFALSE(FALSE %in% data_check)) .check_weather(w, data_check)

    return(w)
  }

  # Check for missing inputs before proceeding
  if (is.null(POSIXct_time) &&
      is.null(YYYY) && is.null(MM) && is.null(DD) && is.null(hh)) {
    stop(
      call. = FALSE,
      "You must provide time values either as a `POSIXct_time` column or ",
      "values for `YYYY``, `MM`, `DD` and `hh`."
    )
  }else{
     if(is.null(POSIXct_time) == FALSE){
     if(POSIXct_time %in% colnames(w) == FALSE){
        stop(
           call. = FALSE,
           "`POSIXct_time` column name '",POSIXct_time,
           "' not found in dataset 'w'`."
        )}
     }
  }

  if (is.null(lon) && is.null(lat) && is.null(lonlat_file)) {
    stop(
      call. = FALSE,
      "You must provide lonlat values for the weather station(s) either in ",
      "the `lon` & `lat` cols or as a file through `lonlat_file`."
    )
  }

  if (is.null(time_zone)) {
    stop(
      call. = FALSE,
      "Please include the `time_zone` (Olsen time zone format) for which",
      "the weather station `time` was recorded."
    )
  }

  if (is.null(hh) & is.null(POSIXct_time)) {
    stop(
      call. = FALSE,
      "Can't detect the hour time increment in supplied data (hh), Weather ",
      "data defining hour increments, must be supplied"
    )
  }

  if (length(time_zone) > 1) {
    stop(call. = FALSE,
         "Separate weather inputs for the model are required for",
         "each time zone.")
  }

  # convert to data.table and start renaming and reformatting -----------------
  w <- data.table(w)

  # check missing args
  # If some input are missing input defaults
  if (missing(mm)) {
    w[, mm := rep(0, .N)]
    mm <- "mm"
  }else{
     if(mm %in% colnames(w) == FALSE){
        stop("colname `mm`:", mm, " not found in 'w'")
     }
  }
  if (missing(ss)) {
     w[, ss := rep(0, .N)]
     ss <- "ss"
  }else{
     if(ss %in% colnames(w) == FALSE){
        stop("colname `ss`:", ss, " not found in 'w'")
     }
  }
  if (missing(wd_sd)) {
    w$wd_sd <- NA
    wd_sd <- "wd_sd"
  }else{
     if(wd_sd %in% colnames(w) == FALSE){
        stop("colname `wd_sd`:", wd_sd, " not found in 'w'")
     }
  }
  if (missing(temp)) {
    w[, temp := rep(NA, .N)]
    temp <- "temp"
  }else{
     if(temp %in% colnames(w) == FALSE){
        stop("colname `temp`:", temp, " not found in 'w'")
     }
  }
  if (missing(rh)) {
     w[, rh := rep(NA, .N)]
     rh <- "rh"
  }else{
     if(rh %in% colnames(w) == FALSE){
        stop("colname `rh`:", rh, " not found in 'w'")
     }
  }

  # make sure other column names supplied in arguments are in the supplied '
  #  w' data
  if (all(c(rain, ws, wd, station) %in% colnames(w)) == FALSE) {
     stop(call. = FALSE,
          "Supplied column names for rain, ws, wd and station are not",
          "found in column names of `w`.")
  }

  # import and assign longitude and latitude from a file if provided
  if (!is.null(lonlat_file)) {
    ll_file <- data.table(fread(lonlat_file,keepLeadingZeros = TRUE))

    if (any(c("station", "lon", "lat") %notin% colnames(ll_file))) {
      stop(
        call. = FALSE,
        "The CSV file of weather station coordinates should contain ",
        "column names 'station','lat' and 'lon'."
      )
    }

    if (any(as.character(unique(w[, get(station)])) %notin%
            as.character(ll_file[, station]))) {
      stop(
        call. = FALSE,
        "'station' name '",as.character(unique(w[, get(station)])),"' cannot be ",
        "found in latlon_file."
      )
    }

    r_num <-
      which(as.character(ll_file[, station]) ==
              as.character(unique(w[, get(station)])))

    w[, lat := rep(ll_file[r_num, lat], .N)]
    w[, lon := rep(ll_file[r_num, lon], .N)]
  }

  # If lat and long are specified as NA
  if (!is.null(lat) & !is.null(lon)) {
    if (is.na(lat) & is.na(lon)) {
      w[, lat := rep(NA, .N)]
      w[, lon := rep(NA, .N)]
      lat <- "lat"
      lon <- "lon"
    }
  }

  # rename the columns if needed
  if (!is.null(YYYY)) {
    setnames(
      w,
      old = c(YYYY, MM, DD, hh, mm,ss),
      new = c("YYYY", "MM", "DD", "hh", "mm", "ss"),
      skip_absent = TRUE
    )
  }

  setnames(w,
           old = temp,
           new = "temp",
           skip_absent = TRUE)

  setnames(w,
           old = rain,
           new = "rain",
           skip_absent = TRUE)
  setnames(w,
           old = rh,
           new = "rh",
           skip_absent = TRUE)

  setnames(w,
           old = ws,
           new = "ws",
           skip_absent = TRUE)

  setnames(w,
           old = wd,
           new = "wd",
           skip_absent = TRUE)

  setnames(w,
           old = wd_sd,
           new = "wd_sd",
           skip_absent = TRUE)

  setnames(w,
           old = station,
           new = "station",
           skip_absent = TRUE)

  if (!is.null(lat)) {
    setnames(w,
             old = lat,
             new = "lat",
             skip_absent = TRUE)
  }

  if (!is.null(lon)) {
    setnames(w,
             old = lon,
             new = "lon",
             skip_absent = TRUE)
  }

  if(nrow(unique(w[,list(station,lat,lon)])) != length(unique(w$station))){
     stop("length of unique station names and unique 'lat' 'lon' entries don't match")
  }

  if (!is.null(POSIXct_time)) {
    setnames(w,
             old = POSIXct_time,
             new = "times",
             skip_absent = TRUE)
    w[, times := as.POSIXct(times, tz = time_zone)]
    w[, YYYY := lubridate::year(w[, times])]
    w[, MM := lubridate::month(w[, times])]
    w[, DD := lubridate::day(w[, times])]
    w[, hh :=  lubridate::hour(w[, times])]
    w[, mm := lubridate::minute(w[, times])]

  } else {
    # if POSIX formatted times were not supplied, create a POSIXct
    # formatted column named 'times'

     w[, times := paste(YYYY, "-",
                       MM, "-",
                       DD, " ",
                       hh, ":",
                       mm, ":",
                       ss,sep = "")][, times :=
                                        lubridate::ymd_hms(times,
                                                          tz = time_zone)]
  }

  # set times into UTC
  w[,times := lubridate::with_tz(times,
                                 tzone = "UTC")]

  if (any(is.na(w[, times])) ||
      any(w[, duplicated(times), by = station][,V1])) {
    stop(
      call. = FALSE,
      times,
      "Time records contain NA values or duplicated times. Check you are entering",
      " the correct `time_zone` and the continuity of weather station logging time.",
      " Perhaps your times are `time_zone = 'UTC'`"
    )
  }

  # workhorse of this function that does the reformatting
  .do_format <- function(x_dt,
                         YYYY = YYYY,
                         MM = MM,
                         DD = DD,
                         hh = hh,
                         mm = mm,
                         temp = temp,
                         rain = rain,
                         rh = rh,
                         ws = ws,
                         wd = wd,
                         wd_sd = wd_sd,
                         station = station,
                         lon = lon,
                         lat = lat,
                         lonlat_file = lonlat_file,
                         times = times,
                         time_zone = time_zone) {
    # calculate the approximate logging frequency of the weather data

    log_freq <-
      lubridate::int_length(lubridate::int_diff(c(x_dt[1, times],
                                                  x_dt[.N, times]))) /
      (nrow(x_dt) * 60)

    # if the logging frequency is less than 50 minutes aggregate to hourly
    if (log_freq < 50) {
       w_dt_agg <- x_dt[, list(
          rain = sum(rain, na.rm = TRUE),
          temp = mean(temp, na.rm = TRUE),
          rh = mean(rh, na.rm = TRUE),
          ws = mean(ws, na.rm = TRUE),
          wd = as.numeric(circular::mean.circular(
                circular::circular(wd,
                                   units = "degrees",
                                   modulo = "2pi"),
                na.rm = TRUE
             )),
          wd_sd = as.numeric(circular::sd.circular(
             circular::circular(wd,
                                units = "degrees",
                                modulo = "2pi"),
                na.rm = TRUE
             )) * 57.29578,
          # this is equal to (180 / pi), this is because
          # sd.circular returns in radians, but mean.circular returns degrees
          lon = unique(lon),
          lat = unique(lat),
          YYYY = unique(YYYY),
          MM = unique(MM),
          DD = unique(DD),
          hh = unique(hh)

       ),
       by = list(times = lubridate::floor_date(times,unit = "hours"), station)]

       # insert a minute col that was removed during this aggregation
       w_dt_agg[, mm := rep(0, .N)]
       mm <- "mm"

       w_dt_agg <- w_dt_agg[order(station,times)]

       return(.fill_times(w_dt_agg))

    } else{
      if (all(is.na(x_dt[, wd_sd]))) {
        stop(
          call. = FALSE,
          "`format_weather()` was unable to detect or calculate `wd_sd`. ",
          "Please supply a standard deviation of wind direction."
        )
      }
      x_dt <- x_dt[order(station,times)]
      return(.fill_times(x_dt))
    }
  }

  if (length(unique(w[, "station"])) > 1) {
    # split data by weather station
    w <- split(w, by = "station")

    x_out <- lapply(
      X = w,
      FUN = .do_format,
      YYYY = YYYY,
      MM = MM,
      DD = DD,
      hh = hh,
      mm = mm,
      temp = temp,
      rain = rain,
      rh = rh,
      ws = ws,
      wd = wd,
      wd_sd = wd_sd,
      station = station,
      lon = lon,
      lat = lat,
      lonlat_file = lonlat_file,
      times = times,
      time_zone = time_zone
    )
    x_out <- rbindlist(x_out)
  } else {
    x_out <- .do_format(
      x_dt = w,
      YYYY = YYYY,
      MM = MM,
      DD = DD,
      hh = hh,
      mm = mm,
      temp = temp,
      rain = rain,
      rh = rh,
      ws = ws,
      wd = wd,
      wd_sd = wd_sd,
      station = station,
      lon = lon,
      lat = lat,
      lonlat_file = lonlat_file,
      times = times,
      time_zone = time_zone
    )
  }

  setcolorder(
     x_out,
     c("times",
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

  # remove lat lon columns if they are NA. Presume that if lat is `NA` then the
  # values of lon have no real utility either so we only check if lat is `NA`
  if (all(is.na(unique(x_out[, lat])))) {
    x_out[, lat := NULL]
    x_out[, lon := NULL]
  }

  if(isFALSE(FALSE %in% data_check)) .check_weather(x_out, data_check)

  setattr(x_out, "class", union("epiphy.weather", class(x_out)))
  return(x_out[])
}

# Function to fill times
.fill_times <- function(w_dt){
   # nocov on Cran
   times <- station <- lon <- lat <- NULL

   for(stat1 in unique(w_dt$station)){

      # create station specific data
      w_bystat <- w_dt[station == stat1]

   # Create a sequence of times by each hour
   tseq_dt <- data.table(times = seq(from = w_bystat[1,times],
                                     to = w_bystat[.N,times],
                                     by = "hours"))

   if(length(tseq_dt$times) != length(w_bystat$times)) {
      warning("Non-continuous data detected. Extra lines will be merged into data
              to ensure no time gaps. All weather data will be filled as NA.",
              "\n This format request will likely cause the function to fail if
              dat_check = TRUE. If set to false ensure data is imputed to prevent
               model run errors.")
      # merge in missing times
      w_bystat <- merge(
         x = tseq_dt,
         y = w_bystat,
         by.x = "times",
         by.y = "times",
         all.x = TRUE
      )

      # fill station and time data
      w_bystat[is.na(station) &
              is.na(lon) &
              is.na(lat), c("lon", "lat", "station") :=
              list(w_bystat[1, lon], w_bystat[1, lat], w_bystat[1, station])]

      # remove old station data
      w_dt <- w_dt[station != stat1]

      # add new station data with all times added
      w_dt <- rbind(w_dt,w_bystat)

   }}

   return(w_dt)
}

.check_weather <- function(final_w, var_check) {
  # note on cran avoidance (nocov) from data.table
  temp <- times <- rain <- ws <- wd <- rh <- NULL
  if(TRUE %in% var_check){
     var_check <- c("temp","rh","rain","ws","wd")
  }

  # Check temperatures
  # For NAs
  if ("temp" %in% var_check) {
     if (nrow(final_w[is.na(temp),]) != 0) {
        if (all(is.na(final_w[, temp]))) {
           warning(
              "All temperature values are 'NA' or missing, check data if this",
              " is not intentional"
           )
        } else{
           stop(
              call. = FALSE,
              "NA values in temperature; \n",
              paste0(as.character(final_w[is.na(temp), times]), sep = ",  "),
              "\nplease use a complete dataset"
           )
        }
     }

     # for outside range
     if (nrow(final_w[temp < -30 |
                      temp > 60,]) != 0) {
        stop(
           call. = FALSE,
           "Temperature inputs are outside expected ranges (-30 and +60 degrees Celcius); \n",
           paste(as.character(final_w[temp < -30 |
                                         temp > 60, times])),
           "\nplease correct these inputs and run again"
        )
     }
  }

  # Check relative humidity
  # For NAs
  if ("rh" %in% var_check) {
     if (nrow(final_w[is.na(rh), ]) != 0) {
        if (all(is.na(final_w[, rh]))) {
           warning(
              "All relative humidity values are 'NA' or missing, check data if ",
              "this is not intentional"
           )
        } else{
           stop(
              call. = FALSE,
              "data includes NA 'rh' values; \n",
              paste0(as.character(final_w[is.na(rh), times]), sep = ",  "),
              "\n if a complete dataset does not require 'rh' use data_check = FALSE"
           )
        }
     }

     # for outside range
     if (nrow(final_w[rh < 0 |
                      rh > 100,]) != 0) {
        stop(
           call. = FALSE,
           "Relative humidity inputs are outside expected ranges (0 and 100%); \n",
           paste(as.character(final_w[rh < 0 |
                                         rh > 100, times])),
           "\nplease correct these inputs and run again"
        )
     }
  }


  # Check rainfall
  # For NAs
  if ("rain" %in% var_check) {
     if (nrow(final_w[is.na(rain),]) != 0) {
        stop(
           call. = FALSE,
           "NA values in rainfall; \n",
           paste(as.character(final_w[is.na(rain), times])),
           "\nplease use a complete dataset"
        )
     }
     # for outside range
     if (nrow(final_w[rain < 0 |
                      rain > 100,]) != 0) {
        stop(
           call. = FALSE,
           "rain inputs are outside expected ranges (0 and 100 mm); \n",
           paste(as.character(final_w[rain < 0 |
                                         rain > 100, times])),
           "\nplease correct these inputs and run again"
        )
     }
  }

  # Check windspeed
  # For NAs
  if ("ws" %in% var_check) {
     if (nrow(final_w[is.na(ws),]) != 0) {
        stop(
           call. = FALSE,
           "NA values in wind speed; \n",
           paste(as.character(final_w[is.na(ws), times])),
           "\nplease use a complete dataset"
        )
     }
     # for outside range
     if (nrow(final_w[ws < 0 |
                      ws > 150,]) != 0) {
        stop(
           call. = FALSE,
           "wind speed inputs are outside expected ranges (0 and 150 kph); \n",
           paste(as.character(final_w[ws < 0 |
                                         ws > 150, times])),
           "\nplease correct these inputs and run again"
        )
     }
  }

  # Check Wind direction
  # For NAs
  if ("wd" %in% var_check) {
     if (nrow(final_w[is.na(wd),]) != 0) {
        stop(
           call. = FALSE,
           "NA values in wind direction; \n",
           paste(as.character(final_w[is.na(wd), times])),
           "\nplease use a complete dataset"
        )
     }
     # for outside range
     if (nrow(final_w[wd < 0 |
                      wd > 360,]) != 0) {
        stop(
           call. = FALSE,
           "wind direction are outside expected ranges (0 and 360); \n",
           paste(as.character(final_w[wd < 0 |
                                         rain > 360, times])),
           "\nplease correct these inputs and run again"
        )
     }
  }}

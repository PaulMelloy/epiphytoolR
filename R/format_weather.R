#' Format weather data into a standardised format.
#'
#' Formats raw weather data into an object suitable for use in the affiliated
#'  spore dispersal packages such as `ascotraceR` and `blackspot.sp`. This
#'  standardised data format ensures that the supplied weather data meet the
#'  requirements for functions in the aforementioned packages. Input weather
#'  data expects a 'long' data format, where each line is an observation at
#'  a point in time.
#'
#' @param x a \code{\link{data.frame}} object of weather station data for
#'  formatting.
#' @param YYYY Column name `character` or index in `x` that refers to the year when the
#'   weather was logged.
#' @param MM Column name `character` or index in `x` that refers to the month (numerical)
#'   when the weather was logged.
#' @param DD Column name `character` or index in `x` that refers to the day of month when
#'   the weather was logged.
#' @param hh Column name `character` or index in `x` that refers to the hour (24 hour) when
#'   the weather was logged.
#' @param mm Column name `character` or index in `x` that refers to the minute when the
#'   weather was logged.
#' @param POSIXct_time Column name `character` or index in `x` which contains a `POSIXct`
#'   formatted time. This can be used instead of arguments `YYYY`, `MM`, `DD`,
#'   `hh`, `mm.`.
#' @param time_zone Local time zone (Olsen time zone format) `character` which was used
#'   for `times` when recording observations times at the weather station. If unsure
#'   and time data has continuity, use "UTC".
#' @param temp Column name `character` or index in `x` that refers to temperature in degrees
#'   Celsius.
#' @param rain Column name `character` or index in `x` that refers to rainfall in millimetres.
#' @param ws Column name `character` or index in `x` that refers to wind speed in km / h.
#' @param wd Column name `character` or index in `x` that refers to wind direction in
#'   degrees.
#' @param wd_sd Column name `character` or index in `x` that refers to wind speed columns
#'   standard deviation.  This is only applicable if weather data
#'   is already summarised to hourly increments. See details.
#' @param station Column name `character` or index in `x` that refers to the weather station
#'   name or identifier. See details.
#' @param lon Column name `character` or index in `x` that refers to weather station's
#'   longitude. See details.
#' @param lat Column name `character` or index in `x` that refers to weather station's
#'   latitude. See details.
#' @param lonlat_file A file path (`character`) to a \acronym{CSV} which included station
#'   name/id and longitude and latitude coordinates if they are not supplied in
#'   the data. Optional, see also `lon` and `lat`.
#'
#' @details `time_zone` The time-zone in which the `time` was recorded. All weather
#'   stations in `x` must fall within the same time-zone.  If the required stations
#'   are located in differing time zones, `format_weather()` should be run separately
#'   on each object, then data can be combined after formatting.
#'
#' @details `wd_sd` If weather data is
#'   provided in hourly increments, a column
#'   with the standard deviation of the wind direction over the hour is required
#'   to be provided. If the weather data are sub-hourly, the standard deviation
#'   will be calculated and returned automatically.
#'
#' @details `lon`, `lat` and `lonlat_file` If `x` provides longitude and
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
#'               tz = "Australia/Adelaide")
#'
#' weather <- format_weather(
#'    x = weather_station_data,
#'    POSIXct_time = "Local.Time",
#'    ws = "meanWindSpeeds",
#'    wd_sd = "stdDevWindDirections",
#'    rain = "Rainfall",
#'    temp = "Temperature",
#'    wd = "meanWindDirections",
#'    lon = "Station.Longitude",
#'    lat = "Station.Latitude",
#'    station = "StationID",
#'    time_zone = "Australia/Adelaide"
#' )
#'
#' # Reformat saved weather
#'
#' # Create file path and save data
#' file_path_name <- paste(tempdir(), "weather_saved.csv", sep = "\\")
#' write.csv(weather,
#'           file = file_path_name,
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
format_weather <- function(x,
                           YYYY = NULL,
                           MM = NULL,
                           DD = NULL,
                           hh = NULL,
                           mm = NULL,
                           POSIXct_time = NULL,
                           time_zone = NULL,
                           temp,
                           rain,
                           ws,
                           wd,
                           wd_sd,
                           station,
                           lon = NULL,
                           lat = NULL,
                           lonlat_file = NULL) {
  # CRAN Note avoidance
  times <- NULL #nocov

  # Check x class
  if (!is.data.frame(x)) {
    stop(call. = FALSE,
         "`x` must be provided as a `data.frame` object for formatting.")
  }

  # is this a pre-formatted data.frame that needs to be reformatted?
  if (all(
    c(
      "times",
      "temp",
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
    ) %in% colnames(x)
  )) {
    # set as data.table
    x <- data.table(x)

    if (is.null(time_zone)) {
      stop(
        "Please provide the timezone of the source weather stations. If this
              was pre-formatted, use 'UTC'"
      )
    } else{
      x[, times := lubridate::ymd_hms(times, tz = "UTC")]
    }
    if (any(is.na(x[, times])) ||
        any(x[, duplicated(times), by = factor(station)][,V1])) {
       stop(
          call. = FALSE,
          times,
          "Time records contain NA values or duplicated times. If this was ",
          "previously formatted with `format_weather()` enter `time_zone = 'UTC'`"
       )
    }

    .check_weather(x)
    setattr(x, "class", union("epiphy.weather", class(x)))

    return(x)
  }

  # Check for missing inputs before proceeding
  if (is.null(POSIXct_time) &&
      is.null(YYYY) && is.null(MM) && is.null(DD) && is.null(hh)) {
    stop(
      call. = FALSE,
      "You must provide time values either as a `POSIXct_time` column or ",
      "values for `YYYY``, `MM`, `DD` and `hh`."
    )
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
  x <- data.table(x)

  # check missing args
  # If some input are missing input defaults
  if (missing(mm)) {
    x[, mm := rep(0, .N)]
    mm <- "mm"
  }
  if (missing(wd_sd)) {
    x$wd_sd <- NA
    wd_sd <- "wd_sd"
  }
  if (missing(temp)) {
    x[, temp := rep(NA, .N)]
    temp <- "temp"
  }

  if (all(c(temp, rain, ws, wd, wd_sd, station) %in% colnames(x)) == FALSE) {
    stop(call. = FALSE,
         "Supplied column names are not found in column names of `x`.")
  }

  # import and assign longitude and latitude from a file if provided
  if (!is.null(lonlat_file)) {
    ll_file <- data.table(fread(lonlat_file))

    if (any(c("station", "lon", "lat") %notin% colnames(ll_file))) {
      stop(
        call. = FALSE,
        "The CSV file of weather station coordinates should contain ",
        "column names 'station','lat' and 'lon'."
      )
    }

    if (any(as.character(unique(x[, get(station)])) %notin%
            as.character(ll_file[, station]))) {
      stop(
        call. = FALSE,
        "The CSV file of weather station coordinates should contain ",
        "station coordinates for each weather station identifier."
      )
    }

    r_num <-
      which(as.character(ll_file[, station]) ==
              as.character(unique(x[, get(station)])))

    x[, lat := rep(ll_file[r_num, lat], .N)]
    x[, lon := rep(ll_file[r_num, lon], .N)]
  }

  # If lat and long are specified as NA
  if (!is.null(lat) & !is.null(lon)) {
    if (is.na(lat) & is.na(lon)) {
      x[, lat := rep(NA, .N)]
      x[, lon := rep(NA, .N)]
      lat <- "lat"
      lon <- "lon"
    }
  }

  # rename the columns if needed
  if (!is.null(YYYY)) {
    setnames(
      x,
      old = c(YYYY, MM, DD, hh, mm),
      new = c("YYYY", "MM", "DD", "hh", "mm"),
      skip_absent = TRUE
    )
  }


  setnames(x,
           old = temp,
           new = "temp",
           skip_absent = TRUE)

  setnames(x,
           old = rain,
           new = "rain",
           skip_absent = TRUE)

  setnames(x,
           old = ws,
           new = "ws",
           skip_absent = TRUE)

  setnames(x,
           old = wd,
           new = "wd",
           skip_absent = TRUE)

  setnames(x,
           old = wd_sd,
           new = "wd_sd",
           skip_absent = TRUE)

  setnames(x,
           old = station,
           new = "station",
           skip_absent = TRUE)

  if (!is.null(lat)) {
    setnames(x,
             old = lat,
             new = "lat",
             skip_absent = TRUE)
  }

  if (!is.null(lon)) {
    setnames(x,
             old = lon,
             new = "lon",
             skip_absent = TRUE)
  }

  if (!is.null(POSIXct_time)) {
    setnames(x,
             old = POSIXct_time,
             new = "times",
             skip_absent = TRUE)
    x[, times := as.POSIXct(times, tz = time_zone)]
    x[, YYYY := lubridate::year(x[, times])]
    x[, MM := lubridate::month(x[, times])]
    x[, DD := lubridate::day(x[, times])]
    x[, hh :=  lubridate::hour(x[, times])]
    x[, mm := lubridate::minute(x[, times])]

  } else {
    # if POSIX formatted times were not supplied, create a POSIXct
    # formatted column named 'times'

    x[, times := paste(YYYY, "-",
                       MM, "-",
                       DD, " ",
                       hh, ":",
                       mm, sep = "")][, times :=
                                        lubridate::ymd_hm(times,
                                                          tz = time_zone)]
  }

  # set times into UTC
  x[,times := lubridate::with_tz(times,
                                 tzone = "UTC")]

  if (any(is.na(x[, times])) ||
      any(x[, duplicated(times), by = station][,V1])) {
    stop(
      call. = FALSE,
      times,
      "Time records contain NA values or duplicated times. Check you are entering",
      "the correct `time_zone` and the continuity of weather station logging time"
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
        times = unique(lubridate::floor_date(times,
                                             unit = "hours")),
        temp = mean(temp, na.rm = TRUE),
        rain = sum(as.numeric(rain), na.rm = TRUE),
        ws = mean(ws, na.rm = TRUE),
        wd = as.numeric(
          circular::mean.circular(
            circular::circular(wd,
                               units = "degrees",
                               modulo = "2pi"),
            na.rm = TRUE
          ) # ** see line 310 below
        ),
        wd_sd = as.numeric(
          circular::sd.circular(
            circular::circular(wd,
                               units = "degrees",
                               modulo = "2pi"),
            na.rm = TRUE
          )
        ) * 57.29578,
        # this is equal to (180 / pi)
        # why multiply by (180 / pi) here but not on mean.circular above **
        lon = unique(lon),
        lat = unique(lat)
      ),
      by = list(YYYY, MM, DD, hh, station)]

      # insert a minute col that was removed during this aggregation
      w_dt_agg[, mm := rep(0, .N)]
      mm <- "mm"

      return(w_dt_agg)

    } else{
      if (all(is.na(x_dt[, wd_sd]))) {
        stop(
          call. = FALSE,
          "`format_weather()` was unable to detect or calculate `wd_sd`. ",
          "Please supply a standard deviation of wind direction."
        )
      }
      return(x_dt)
    }
  }

  if (length(unique(x[, "station"])) > 1) {
    # split data by weather station
    x <- split(x, by = "station")

    x_out <- lapply(
      X = x,
      FUN = .do_format,
      YYYY = YYYY,
      MM = MM,
      DD = DD,
      hh = hh,
      mm = mm,
      temp = temp,
      rain = rain,
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
      x_dt = x,
      YYYY = YYYY,
      MM = MM,
      DD = DD,
      hh = hh,
      mm = mm,
      temp = temp,
      rain = rain,
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
    c(
      "times",
      "temp",
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

  .check_weather(x_out)

  setattr(x_out, "class", union("epiphy.weather", class(x_out)))
  return(x_out[])
}

.check_weather <- function(final_w) {
  # note on cran avoidance (nocov) from data.table
  temp <- times <- rain <- ws <- wd <- NULL

  # Check temperatures
  # For NAs
  if (nrow(final_w[is.na(temp), ]) != 0)
    stop(
      call. = FALSE,
      "NA values in temperature; \n",
      paste(as.character(final_w[is.na(temp), times])),
      "\nplease use a complete dataset"
    )
  # for outside range
  if (nrow(final_w[temp < -30 |
                   temp > 60, ]) != 0)
    stop(
      call. = FALSE,
      "Temperature inputs are outside expected ranges (-30 and +60 degrees Celcius); \n",
      paste(as.character(final_w[temp < -30 |
                                   temp > 60, times])),
      "\nplease correct these inputs and run again"
    )

  # Check rainfall
  # For NAs
  if (nrow(final_w[is.na(rain), ]) != 0)
    stop(
      call. = FALSE,
      "NA values in rainfall; \n",
      paste(as.character(final_w[is.na(rain), times])),
      "\nplease use a complete dataset"
    )
  # for outside range
  if (nrow(final_w[rain < 0 |
                   rain > 100, ]) != 0)
    stop(
      call. = FALSE,
      "rain inputs are outside expected ranges (0 and 100 mm); \n",
      paste(as.character(final_w[rain < 0 |
                                   rain > 100, times])),
      "\nplease correct these inputs and run again"
    )

  # Check windspeed
  # For NAs
  if (nrow(final_w[is.na(ws), ]) != 0)
    stop(
      call. = FALSE,
      "NA values in wind speed; \n",
      paste(as.character(final_w[is.na(ws), times])),
      "\nplease use a complete dataset"
    )
  # for outside range
  if (nrow(final_w[ws < 0 |
                   ws > 150, ]) != 0)
    stop(
      call. = FALSE,
      "wind speed inputs are outside expected ranges (0 and 150 kph); \n",
      paste(as.character(final_w[ws < 0 |
                                   ws > 150, times])),
      "\nplease correct these inputs and run again"
    )

  # Check Wind direction
  # For NAs
  if (nrow(final_w[is.na(wd), ]) != 0)
    stop(
      call. = FALSE,
      "NA values in wind direction; \n",
      paste(as.character(final_w[is.na(wd), times])),
      "\nplease use a complete dataset"
    )
  # for outside range
  if (nrow(final_w[wd < 0 |
                   wd > 360, ]) != 0)
    stop(
      call. = FALSE,
      "wind direction are outside expected ranges (0 and 360); \n",
      paste(as.character(final_w[wd < 0 |
                                   rain > 360, times])),
      "\nplease correct these inputs and run again"
    )
}

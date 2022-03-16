#' Check for daylight savings
#'
#' Function checks a vector of POSIXct times for continuity and duplicated times
#' that could be explained by daylight savings.
#'
#' @param x_t a vector of times
#' @param addDay Month and day in the year when a hour is subtracted to start
#'  daylight savings leading to an hour of duplicated times. Format should be
#'  "Month-day" or `format = "%b-%d"`
#' @param subDay Month and day in the year when a hour is added to end
#'  daylight savings leading to an hour of missing times. Format should be
#'  "Month-day" or `format = "%b-%d"`
#' @param verbose Will add messages to output informing the changes to the time
#'  vector.
#'
#' @return A vector of times `POSIXct` in adjusted to `UTC`
#' @export
#'
#' @examples
check_DS <- function(x_t,
                     time_zone,
                     addDay = "Oct-03",
                     subDay = "Mar-03",
                     verbose = FALSE){
   dupes <- NULL

   if(is(x_t, "POSIXct") == FALSE) stop("Please provide POSIXct formatted time")
   #if(is.vector(x_t) == FALSE) stop("Time input is class ",class(x_t), " and should be a vector")
#warning("Function is incomplete and under construction")
# needs to be able to handle different hemispheres
# needs to be able to handle minute data

   # get the timezone of input
   t_zone <- unique(format(x_t,format = "%Z"))
   # if(length(t_zone) > 1) stop("more than one timezone detected on input, please",
   #                             " use time from only one timezone")

   # find the time frequency in the input
   t_freq <- NULL
   while(length(t_freq) != 1) {
      iter <- ifelse(is.null(t_freq),0,iter + 1)
      if(iter > 5) stop("time intervals between observations too variable, check
                        consistancy of time inputs")
      rand_sample <- sample(1:length(x_t), 10)
      t_freq <-
         unique(
            difftime(time1 = x_t[rand_sample + 1],
                     time2 = x_t[rand_sample],
                     units = "secs")
         )
   }

   # find duplicates
   dupes <- x_t[duplicated(x_t)]

   # create vector of times with no gaps
   synth_x <- seq(from = x_t[1],
                  to = tail(x_t,n = 1),
                  by = t_freq)

   # do all the times in x_t appear in synth_x?
   t_miss <- synth_x[(x_t %in% synth_x) == FALSE]

   # if no missing times and
   # synthetic vector is the same length as input vector and
   # the target timezone does not enjoy daylight savings
   # return input vector
   if(length(t_miss) == 0 &
      length(x_t) == length(synth_x) &
      lubridate::dst(as.POSIXct("2020-12-25", tz = time_zone))==FALSE){
      return(
         as.POSIXct(
            lubridate::with_tz(
               as.POSIXlt(x_t,
                          tz = time_zone),
               tzone = "UTC")))
   }

   # if no missing times and
   # synthetic vector is the same length as input vector and
   # the target timezone does enjoy daylight savings
   # return adjusted input vector
   if(length(t_miss) == 0 &
      length(x_t) == length(synth_x) &
      lubridate::dst(as.POSIXct("2020-12-25", tz = time_zone))){
      return(
         as.POSIXct(
            lubridate::with_tz(
               lubridate::with_tz(x_t,
                          tzone = time_zone),
               tzone = "UTC")))
   }



   # check the duplicated or missing occur at expected time of year when daylight
   # savings shifts
   if(dupes != 0 &
      addDay != format(dupes, format = "%b-%d")){
      stop("'time' input contains duplicated days are not the expected daylight savings 'addDay': .",
           addDay,"
           Check your time data for continuity")}
   if(t_miss !=0 &
      subDay != format(t_miss, format = "%b-%d")){
      stop("'time' input contains duplicated days are not the expected daylight savings 'subDay': .",
           subDay,"
           Check your time data for continuity")}




   # when times only contain the duplicated hour, add an hour over summer
   if(length(t_miss) == 0 &
      length(dupes > 0)){


   }



   Years <- unique(year(x_t))

   for(y in Years){

             # subset dupe and missing
             miss_y <- t_miss[t_miss >= as.POSIXct(paste0(y,"-01-01")) &
                                 t_miss <= as.POSIXct(paste0(y + 1,"-01-01"))]
             dupe_y <- dupes[dupes >= as.POSIXct(paste0(y,"-01-01")) &
                                dupes <= as.POSIXct(paste0(y + 1,"-01-01"))]

             if(length(t_miss) > 0) {
                # Southern Hemisphere
                # add an hour to all the datetimes after duplicate
                x_t[x_t <= miss_y &
                       x_t >= as.POSIXct(paste0(
                          y - 1,
                          "-",
                          addDay,
                          " ",
                          hour(miss_y),
                          ":",
                          minute(miss_y),
                          ":",
                          second(miss_y)
                       ),
                       format = "%Y-%b-%d %H:%M:%S")] <-
                   x_t[x_t <= miss_y &
                          x_t >= as.POSIXct(paste0(
                             y - 1,
                             "-",
                             addDay,
                             " ",
                             hour(miss_y),
                             ":",
                             minute(miss_y),
                             ":",
                             second(miss_y)
                          ),
                          format = "%Y-%b-%d %H:%M:%S")] + 3600
                if (verbose == TRUE) {
                   message("\nmissing datetime: ", miss_y)
                }
                if(length(dupe_y) > 0 &
                   length(t_miss) > 1 &
                   y == tail(year(miss_y),n=1)){
                   # If this is the last year in data and there is a duplicate
                   x_t[which(x_t %in% dupe_y)[2]:(length(x_t))] <-
                      x_t[which(x_t %in% dupe_y)[2]:(length(x_t))] + 3600
                }
                return()

             }else{
                x_t[which(x_t %in% dupes)[2]:(length(x_t))] <-
                       x_t[which(x_t %in% dupes)[2]:(length(x_t))] + 3600
             }





             # subset to the addDay
             add_day_x   <- x_t[addDay == format(y_x, format = "%b-%d")]

             # find the duplicated hour
             dup_hour <- format(add_day_x[duplicated(add_day_x)], format = "%h")


          }


   return(as.POSIXct(lubridate:with_tz(x_t, tz = "UTC")))

}


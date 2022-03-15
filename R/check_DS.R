#' Check for daylight savings
#'
#' Function checks a vector of POSIXct times for continuity and duplicated times
#' that could be explained by daylight savings.
#'
#' @param x a vector of times
#' @param addDay Month and day in the year when a hour is subtracted to start
#'  daylight savings. format should be "Month-day" or `format = "%b-%d"`
#' @param subDay Month and day in the year when a hour is added to end
#'  daylight savings. format should be "Month-day" or `format = "%b-%d"`
#' @param verbose Will add messages to output informing the changes to the time
#'  vector.
#'
#' @return either nothing or a vector of times POSIXct in UTC
#' @export
#'
#' @examples
check_DS <- function(x, addDay = "Oct-03", subDay = "Mar-03", verbose = FALSE){
   if(is(x, "POSIXct") == FALSE) stop("Please provide POSIXct formatted time")
   #if(is.vector(x) == FALSE) stop("Time input is class ",class(x), " and should be a vector")
warning("Function is incomplete and under construction")
   # get the timezone of input
   t_zone <- unique(format(x,format = "%Z"))
   if(length(t_zone) > 1) stop("more than one timezone detected on input, please",
                               " use time from only one timezone")

   # find the time frequency in the input
   t_freq <- NULL
   while(length(t_freq) != 1) {
      iter <- ifelse(is.null(t_freq),0,iter + 1)
      if(iter > 5) stop("time intervals between observations too variable, check
                        consistancy of time inputs")
      rand_sample <- sample(1:length(x), 10)
      t_freq <-
         unique(
            difftime(time1 = x[rand_sample + 1],
                     time2 = x[rand_sample],
                     units = "secs")
         )
   }

   # find duplicates
   dupes <- x[duplicated(x)]

   # create vector of times with no gaps
   synth_x <- seq(from = x[1],
                  to = data.table::last(x),
                  by = t_freq)

   # do all the times in x appear in synth_x?
   t_miss <- x[x %in% synth_x == FALSE]

   # if no missing times and they are the same length
   # return input vector
   if(length(t_miss) == 0 &
      length(x) == length(synth_x)){
      return(as.POSIXct(as.POSIXlt(x, tz = "UTC")))
   }



   # check the duplicated or missing occur at expected time of year when daylight
   # savings shifts
   if(addDay != format(dupes, format = "%b-%d")){
      stop("duplicated days are not the expected daylight savings 'addDay'.
           Check your time data for continuity")}
   if(subDay != format(t_miss, format = "%b-%d")){
      stop("skipped daylight savings hour not detected in the expected 'subDay'.
           Check your time data for continuity")}

   # when times only contain the duplicated hour, add an hour over summer
   if(length(t_miss) == 0 &
      length(dupes > 0)){

      # add an hour to all the datetimes after duplicate
      x[which(x %in% dupes)[2]:(length(x))] <-
         x[which(x %in% dupes)[2]:(length(x))] + 3600
      if(verbose == TRUE){message("\nduplicated datetime: ",dupes)}
   }

   #Year <- format(x,format = "%Y")

   lapply(format(t1, format = "%Y"),
          FUN = function(y){

             # subset the year
             y_x <- x[format(x, format = "%Y") == y]

             # subset to the addDay
             add_day_x   <- x[addDay == format(y_x, format = "%b-%d")]

             # find the duplicated hour
             dup_hour <- format(add_day_x[duplicated(add_day_x)], format = "%h")


          })

   t_dt <- data.table(
      tm = x,
      YYYY = as.numeric(format(x, format = "%Y")),
      MM = as.numeric(format(x, format = "%m")),
      DD = as.numeric(format(x, format = "%d")),
      HH = as.numeric(format(x, format = "%H"))
   )


   return(as.POSIXct(as.POSIXlt(x, tz = "UTC")))


}


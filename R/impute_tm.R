#' Impute hourly temperatures
#'
#' @details
#' Impute hourly temperatures from daily maximums and minimums
#'
#'
#' @param max_tm numeric, maximum daily temperature
#' @param min_tm numeric, minimum daily temperature
#' @param max_hour integer, hour in the day when maximum temperature occurred
#' @param min_hour integer, hour in the day when minimum temperature occurred
#'
#' @return numeric vector of length 24. An estimation for each hour of the day
#' @export
#'
#' @examples
#' impute_tm()
#' impute_tm(max_tm = 22,
#'           min_tm = 18)
#' impute_tm(max_hour = 10,
#'           min_hour = 1)

impute_tm <- function(max_tm = 28, min_tm = 10, max_hour = 14, min_hour = 5){

   min2max_time <- max_hour - min_hour
   max2min_time <- (24 - max_hour) + min_hour
   tm_diff <- max_tm - min_tm

   occilating_factor <- c(seq(6,18,length.out = max2min_time+1)[-1],
                          seq(18,30,length.out = min2max_time+1)[-1])

   tm_hourly <- ((sin((occilating_factor)/3.81972) +1) * 0.5 * tm_diff) + min_tm

   min_ind <- which(tm_hourly == min(tm_hourly))
   max_ind <- which(tm_hourly == max(tm_hourly))


   day_hourly <- vector(mode = "numeric", length = 24)
   day_hourly[min_hour:max_hour] <- tm_hourly[min_ind:max_ind]
   day_hourly[(max_hour+1):24] <- tm_hourly[1:(24 - max_hour)]
   day_hourly[1:min_hour] <- tm_hourly[(24 - max_hour+1):min_ind]

   return(day_hourly)

}

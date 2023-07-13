#' Impute hourly relative humidity
#'
#' @details
#' Impute hourly relative humidity from daily maximums and minimums and rainfall
#'
#' @param x numeric or POSIX, vector. numeric vectors indicate which hour to
#'  return. A POSIX formatted vector can also be used and the imputed relative
#'  humidity for the hour returned.
#' @param max_rh numeric, maximum daily relative humidity
#' @param min_rh numeric, minimum daily relative humidity
#' @param max_hour integer, hour in the day when maximum relative humidity occurred
#' @param min_hour integer, hour in the day when minimum relative humidity occurred
#'
#' @return numeric vector of length 24. An estimation for each hour of the day
#' @export
#'
#' @examples
#' impute_rh()
#' impute_rh(Sys.time())
#' impute_rh(max_rh = 22,
#'           min_rh = 18)
#' impute_rh(max_hour = 3,
#'           min_hour = 9)

impute_rh <-
   function(x = 1:24,
            max_rh = 95,
            min_rh = 45,
            max_hour = 4,
            min_hour = 15,
            l_out = 1) {

   if(max_rh < min_rh)stop("'min_rh': ",min_rh,
                           " is larger than 'max_rh': ", max_rh)

   min2max_time <- abs(max_hour - min_hour)
      #max_hour - min_hour
   max2min_time <- 24 - min2max_time

   rh_diff <- max_rh - min_rh

   # occilating_factor <- c(seq(6,18,length.out = max2min_time+1),
   #                        seq(18,30,length.out = min2max_time+1)[-c(1,min2max_time+1)])
   occilating_factor <- c(seq(6,18,length.out = (min2max_time+1)*l_out),
                          seq(18,30,length.out = max2min_time+1*l_out)[-c(1,(max2min_time+1)*l_out)])

   rh_hourly <- ((sin((occilating_factor)/3.81972) +1) * 0.5 * rh_diff) + min_rh

   min_ind <- which(rh_hourly == min(rh_hourly))
   max_ind <- which(rh_hourly == max(rh_hourly))

   return_rh <- function(i_max,h_max, q){
      i_diff <- i_max - (h_max)
      query_index <- (q + i_diff) %% (24*l_out)
      query_index[query_index == 0] <- (24*l_out)
      return(query_index)
   }
   day_hourly <- rh_hourly[return_rh(i_max = max_ind, h_max = max_hour, q = 1:(24*l_out))]

   # day_hourly <- vector(mode = "numeric", length = 24)
   # day_hourly[1:(max_hour-1)] <- rh_hourly[(min_ind - (min_hour)+1):24]
   # day_hourly[(max_hour):24] <- rh_hourly[1:(min_ind - min_hour)]

   if(inherits(x, "numeric") |
      inherits(x, "integer")){
      h_ind <- x %% (24*l_out)
      h_ind[h_ind == 0] <- (24*l_out)
      return(day_hourly[h_ind])
   }
   if(inherits(x, "POSIXt")){
      h_ind <- data.table::hour(x) %% (24*l_out)
      h_ind[h_ind == 0] <- (24*l_out)
      return(day_hourly[h_ind])
   }else{
      stop("'x' should be a numeric or POSIXt vector")
   }
}

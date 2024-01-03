#' Impute hourly diurnal weather fluctuations.
#'
#' @details
#' Impute hourly fluctuations in temperature or relative humidity from daily
#'   maximums and minimums. This function uses a sin function to estimate the
#'   diurnal fluctuations of temperature or humidity.
#'
#' @param h numeric or POSIX, vector. numeric vectors indicate which hour to
#'  return. A POSIX formatted vector can also be used and the imputed relative
#'  humidity for the hour returned.
#' @param max_obs numeric, maximum daily observation of relative humidity or temperature
#' @param min_obs numeric, minimum daily observation of relative humidity or temperature
#' @param max_hour integer, hour in the day when maximum observation was made.
#' @param min_hour integer, hour in the day when minimum observation was made.
#' @param l_out integer, length out of function. `24` for hourly observations (default.
#'  `1440` for minute. `48` for half hourly **Still Experimental!**
#' @param ind_out integer, select the output useing an index number similar it
#'  `1:10[ind_out]`
#'
#' @return numeric vector equal to the of length h. An the respective hour from
#'  the day
#' @export
#'
#' @examples
#' impute_diurnal()
#' impute_diurnal(Sys.time())
#' impute_diurnal(max_obs = 22,
#'                min_obs = 18)
#' impute_diurnal(max_hour = 3,
#'                min_hour = 9)
#' impute_diurnal(max_obs = 99,
#'                min_obs = 45)
#' impute_diurnal(max_hour = 6,
#'                min_hour = 14)
#'
#' w_dt <- weather
#' w_dt[3000 : 3050, temp := NA_real_]
#' plot(w_dt[2900:3200, temp], type = "l")
#'
#' rolling_window <- 24
#' w_dt[, tm_imp := round(data.table::frollapply(
#'                       data.table::hour(times),
#'                       n = rolling_window,
#'                       fill = NA_real_,
#'                       FUN = impute_diurnal,
#'                       max_obs = max(temp, na.rm = TRUE),
#'                       min_obs = min(temp, na.rm = TRUE),
#'                       max_hour = data.table::hour(times[which(temp == max(temp, na.rm = TRUE))]),
#'                       min_hour = data.table::hour(times[which(temp == min(temp, na.rm = TRUE))]),
#'                       align = "center",
#'                       ind_out = ceiling(rolling_window/2)),3)]
#' plot(w_dt[2900:3200, temp], type = "l")
#' lines(w_dt[2900:3200, tm_imp], type = "l", col = "red")
impute_diurnal <-
   function(h = 1:24,
            max_obs = 95,
            min_obs = 45,
            max_hour = 4,
            min_hour = 15,
            l_out = 24,
            ind_out = "all") {
      # define unknown data.table globals

         if (max_obs < min_obs){
            stop("'min_obs': ",
                 min_obs,
                 " is larger than 'max_obs': ",
                 max_obs)}

         # adjust to 24 hour
         l_out <- (l_out / 24)

         if (max_hour > min_hour) {
            max2min_time <- (24 - max_hour) + min_hour
         } else{
            if (max_hour == min_hour)
               stop("max_hour can not be equal to min_hour")
            max2min_time <- min_hour - max_hour
         }
         min2max_time <- 24 - max2min_time

         rh_diff <- max_obs - min_obs

         # occilating_factor <- c(seq(6,18,length.out = max2min_time+1),
         #                        seq(18,30,length.out = min2max_time+1)[-c(1,min2max_time+1)])
         occilating_factor <-
            c(seq(6, 18, length.out = (max2min_time + 1) * l_out),
              seq(18, 30, length.out = (min2max_time + 1) *
                     l_out)[-c(1, (min2max_time + 1) * l_out)])

         rh_hourly <-
            ((sin((
               occilating_factor
            ) / 3.81972) + 1) * 0.5 * rh_diff) + min_obs

         min_ind <- which(rh_hourly == min(rh_hourly))
         max_ind <- which(rh_hourly == max(rh_hourly))

         return_rh <- function(i_max, h_max, q) {
            i_diff <- i_max - (h_max)
            query_index <- (q + i_diff) %% (24 * l_out)
            query_index[query_index == 0] <- (24 * l_out)
            return(query_index)
         }
         day_hourly <-
            rh_hourly[return_rh(i_max = max_ind,
                                h_max = max_hour,
                                q = 1:(24 * l_out))]

         # day_hourly <- vector(mode = "numeric", length = 24)
         # day_hourly[1:(max_hour-1)] <- rh_hourly[(min_ind - (min_hour)+1):24]
         # day_hourly[(max_hour):24] <- rh_hourly[1:(min_ind - min_hour)]

         if (inherits(h, "numeric") |
             inherits(h, "integer")) {
            h_ind <- h %% (24 * l_out)
            h_ind[h_ind == 0] <- (24 * l_out)
            out <- day_hourly[h_ind]
            if(ind_out == "all"){ return(out)
               }else{
               return(out[ind_out])
            }
         }
         if (inherits(h, "POSIXt")) {
            h_ind <- data.table::hour(h) %% (24 * l_out)
            h_ind[h_ind == 0] <- (24 * l_out)
            out <- day_hourly[h_ind]
            out <- day_hourly[h_ind]
            if(ind_out == "all"){ return(out)
            }else{
               return(out[ind_out])
            }
         } else{
            stop("'h' should be a numeric or POSIXt vector")
         }
   }

#_______________________________________________
# Rolling over 2 day period
rolling_window <- 2 * 24

#' Fill Imputation
#'
#' Imputes a new vector of variables which can be used to fill NA values.
#'
#' @param ind index vector
#' @param var numeric vector of values containing NA_real values for imputation
#' @param times POSIXct vector of time in hourly increments
#' @param FUN_n rolling window size
#'
#' @return vector of var values filling NA
#' @export
#'
#' @examples
#' dt <- weather
#' rolling_window <- length(dt[is.na(temp),temp])*2
#' dt[,indx := .I]
#'
#' dt[, tm_imp := round(data.table::frollapply(
#'   indx,
#'   n = rolling_window,
#'   fill = NA_real_,
#'   FUN = impute_fill,
#'   FUN_n = rolling_window,
#'   times = times,
#'   var = temp,
#'   align = "center"
#'   ),3)]
#'
#' plot(dt[2950:3100, temp], type = "l")
#' lines(dt[2950:3100, tm_imp], type = "l", col = "red")
impute_fill <- function(ind,var,times, FUN_n){

   # define data.table globals
   HOUR <- TEMP <- NULL

   n_NA <- ceiling(FUN_n/2)
   time_vec <- times[ind]
   var_vec <- var[ind]

   #if(sum(is.na(var_vec)) > n_NA) return(NA)

   # get the hour in the middle of the rolling window
   # We want to estimate this hour
   t1 <- as.numeric(format(time_vec[n_NA], "%H"))
#cat(as.character(ind), "\n")

   dt_2 <- data.table::data.table(TIME = time_vec,
                                  TEMP = var_vec,
                                  HOUR = data.table::hour(time_vec))

   # max_tm <- max(var_vec, na.rm = TRUE)
   # min_tm <- min(var_vec, na.rm = TRUE)
   # max_h <- hour(time_vec)[which(max_tm)]
   # min_h <- hour(time_vec)[which(min_tm)]
   # # Do rolling window of impute diurnal here####################3
   # dt_2[, i_di := impute_diurnal(
   #    h = HOUR,
   #    max_obs = max_tm,
   #    min_obs = min_tm,
   #    max_hour = max_h,
   #    min_hour = min_h
   # )]

   # filter data to include data one hour prior and one hour after the center of
   #  the rolling window hour
   dt_3 <- dt_2[HOUR >= (t1 - 1) &
                   HOUR <= (t1 + 1),]

   # find the mean of these values
   tm1 <- dt_3[, mean(TEMP, na.rm = TRUE)]
   #cat(colnames(tm1), "   ")
   #tm1 <- tm1[order(HOUR),av_tm]
   return(tm1)

}


#' Impute Relative Humidity
#'
#' @details
#' Impute missing relative humidity using a rolling impute fill function on a `epiphy.weather`
#' class data.table. `epiphy.weather` class is created from `epiphytoolR::format_weather()`
#'
#'
#' @param w Weather data of class `epiphy.weather`, an output from `epiphytoolR::format_weather()`
#' @param rolling_window integer, number of hours used to determine the rolling
#'  window
#'
#' @return Weather data of class `epiphy.weather`, _See_ `epiphytoolR::format_weather()`
#' @export
#'
#' @examples
#' set.seed(111)
#' weather[round(rnorm(50,
#'                     mean = nrow(weather)/2,
#'                     sd = nrow(weather)/10)),
#'         rh := NA_real_]
#' w2 <- impute_rh(weather)
impute_rh <- function(w, rolling_window = 40){
   indx <- rh <- var_imp <- times <- NULL
   wI <- data.table::copy(w)
   # set an index variable
   wI[,indx := .I]

   # Get the number of nas
   n_nas <- length(wI[is.na(rh), indx])

   if(n_nas == 0){
      message("No NA relative humidity")
      return(wI)}

   # Check how many NAs remain
   dif <- n_nas

   while(dif > 0) {
      #get nas
      n_nas <- length(wI[is.na(rh), indx])
      wI[, var_imp := round(
         data.table::frollapply(
            indx,
            n = rolling_window,
            fill = NA_real_,
            FUN = epiphytoolR::impute_fill,
            FUN_n = rolling_window,
            times = times,
            var = rh,
            align = "center"
         ),
         3
      )]

      # set the NAs in temperature with the estimated temperature
      wI[is.na(rh), rh := var_imp]

      # Record how many NAs remain
      dif <- n_nas - length(wI[is.na(rh), indx])

   }
   # remove added columns
   wI[, c("indx","var_imp") := list(NULL,NULL)]
   return(wI)
}

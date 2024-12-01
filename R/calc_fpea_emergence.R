#' Calculate field-pea emergence
#'
#' @description
#' Function calculates the time, in degree days, between sowing and
#' emergence (when 50% of sown seeds have produces at least one true leaf).
#'
#' @details
#' Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
#' Pathology. Formula is reported to correlate to R^2 = 0.91 for pea cultivar
#' Cheyenne grown in the west of France
#' @source <https://doi.org/10.1007/978-1-4020-6065-6_9>
#'
#'
#' @param sowing_date sowing date \code{POSIXct.date}
#' @param hemisphere 'North' or 'South' hemisphere
#'
#' @return number of degree days predicted from time of sowing to emergence
#' @export
#'
#' @examples
#' calc_fpea_emergence("2021-05-10")
calc_fpea_emergence <- function(sowing_date, hemisphere = "south"){

   # calibrate the sowing date to suit the input for northern or southern hemisphere
   # the Schoeny paper was in France and centred on 19/9/2003 8 days before the
   # autumn equinox, hence the adjustment
   if (hemisphere == "north" |
       hemisphere == "N" |
       hemisphere == "North") {
      autumn_equinox <- 226 - 8
   } else{
      if (hemisphere == "south" |
          hemisphere == "S" |
          hemisphere == "South") {
         autumn_equinox <- 79 - 8
      } else{
         stop("Can't understand 'hemisphere' input/n please input 'north' or 'south'.")
      }
   }

   tryCatch(
      {sowing_day <- lubridate::yday(as.Date(sowing_date))},
      error = function(e){
         stop("Check 'sowing_date' can be coersed to 'date' class")
      })

   x1 <- (sowing_day - autumn_equinox)/14

   y1 <- (-4.08 * (x1^2)) +
      (57.36 * x1) +
      97.49
   return(y1)
}

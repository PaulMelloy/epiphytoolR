#' Splash Distance Dispersal Parameter
#'
#' `splash_distance()` determines the distance conidia travel, in metres, via a
#' rain splash by sampling from a half-Cauchy distribution.
#'
#' @param splash_cauchy_parameter A Cauchy scaling parameter
#' @param PSPH A numeric vector estimated from '.estimate_spore_discharge()'
#' @return numerical vector, which returns distance conidia dispersed by a rain
#'   splash from the source of infection
#' @examples
#' splash_distance(0.015) # returns a single estimate
#' splash_distance(0.015, PSPH = 10) # returns 10 estimates
#' splash_distance(0.02, PSPH = c(5, 5)) # returns 10 estimates
#' @keywords internal
#' @noRd


splash_distance <-
   function(splash_cauchy_parameter = 0.015,
            PSPH = 1) {
      s_d <- lapply(PSPH, function(peakSPH) {
         abs(stats::rcauchy(
            n = peakSPH,
            location = 0,
            scale = splash_cauchy_parameter
         ))
      })
      return(unlist(s_d))
   }

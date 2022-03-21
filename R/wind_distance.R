#' Estimate the distance of spore dispersal from wind speed
#'
#' Samples from a half-Cauchy distribution to estimate the distance in meters
#' an spore has dispersed from an inoculum source in meters due to wind speed
#'
#' `wind_distance()` Determines distance conidia disperse, in metres, by wind
#' driven rain Conidia are assumed to spread from the centre of each subunit.
#' The destination subunit, where conidia land, could be the same subunit or
#' another subunit within or outside the paddock.
#'
#' @param mean_wind_speed *numeric* wind speed in km / h
#' @param wind_cauchy_multiplier A scaling parameter to estimate a Cauchy
#'  distribution which resembles the mean distance a spore travels due
#'  to wind dispersal.
#' @param PSPH A numeric vector estimated from '.estimate_spore_discharge()'
#' @return Numerical vector, which returns distance a spore is dispersed by wind
#'   from the source of infection
#' @examples
#' wind_distance(mean_wind_speed = 10,
#'               wind_cauchy_multiplier = 50) # returns a single estimate
#' wind_distance(mean_wind_speed = 10,
#'               wind_cauchy_multiplier = 50,
#'               PSPH = 10) # returns 10 estimates
#' wind_distance(mean_wind_speed = 10,
#'               wind_cauchy_multiplier = 50,
#'               PSPH = c(5, 5)) # returns 10 estimates
#' @export
wind_distance <-
  function(mean_wind_speed,
           wind_cauchy_multiplier,
           PSPH = 1) {
    w_d <- lapply(PSPH, function(peakSPH) {
      abs(
        stats::rcauchy(
          n = peakSPH,
          location = 0,
          scale = wind_cauchy_multiplier * mean_wind_speed
        )
      )
    })
    return(unlist(w_d))
  }

#' Estimates Bearing of Conidia Dispersed by a Rain Splash
#'
#' `splash_angle()` gives the angle of dispersal due to rain splash, which is a
#' random number with uniform probability from 1 to 360 degrees.
#'
#' @return numeric, a single bearing in degrees drawn from a uniform
#'   distribution between 1 and 360.
#' @keywords internal
#' @noRd

splash_angle <- function() {
  stats::runif(n = 1,
               min =  1,
               max = 360)
}

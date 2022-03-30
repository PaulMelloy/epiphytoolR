#' Estimates Bearing Conidia Dispersed by Wind Driven Rain
#'
#' `wind_angle()` samples from normal distribution to estimate the bearing of
#' spore or conidia dispersal wind.
#'
#' @param mean_wind_direction A numeric vector representing mean wind direction
#'   at a particular time interval
#' @param stdev_wind_direction Refer to standard deviation of wind_direction at
#'   a particular time interval
#' @param PSPH A numeric vector, estimated from `.estimate_spore_discharge()`
#' @param min_stdev the minimum possible standard deviation of wind direction
#'   permitted. This should reflect the turbulent effect of wind movements to
#'   prevent std deviations of near zero when wind direction is averaged.
#'
#' @return A numeric vector giving information on the angle component of conidia
#'   dispersed by wind driven rain.
#'
#' @examples
#' wind_angle(10, 2) # returns a single estimate
#' wind_angle(10, 2, PSPH = 10) # returns 10 estimates
#' wind_angle(15, 2, PSPH = c(5, 5)) # returns 10 estimates
#'
#' @export
wind_angle <-
  function(mean_wind_direction,
           stdev_wind_direction,
           PSPH = 1,
           min_stdev = 1) {

    w_angle <-
      lapply(X = PSPH,
             FUN = stats::rnorm,
             mean = mean_wind_direction,
             sd = fifelse(stdev_wind_direction < min_stdev,
                          min_stdev,
                          stdev_wind_direction)
             )

    w_angle <- unlist(w_angle)

    # if rnorm() approximates beyond 360 or lower than 0 correct for this
    w_angle <- lapply(w_angle, function(w_a) {
      if (w_a < 0) {
        w_a <- w_a + 360
      }
      if (w_a >= 360) {
        w_a <- w_a - 360
      }
      return((w_a))
    })
    return(unlist(w_angle))
  }

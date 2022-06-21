#' Calculate the influence of 2 dimensional vectors
#'
#' @details This function determines the circular vector influence on a 1 to -1
#'  scale. For example if the wind is blowing on a northerly vector (0 degrees)
#'  There is no influence reduction. If wind blows at a 90 degree angle there is
#'  no influence on the north south plane.
#'
#' @param x degrees (numeric)
#'
#'
#' @return numberic double of same length as input
#' @export
#'
#' @examples
#' # Wind speed strength from a northerly wind
#' ws <- 5 # kph
#' wd <- 0 # degrees
#' ws * circular_influence(wd)
#'
#' # Wind speed strength from a north east wind
#' ws <- 5 # kph
#' wd <- 45 # degrees
#' ws * circular_influence(wd)
#'
#' # Wind speed strength from a south west wind
#' ws <- 5 # kph
#' wd <-225 # degrees
#' ws * circular_influence(wd)
circular_influence <- function(x) {
   if(x < 0 | x > 360) stop("'x' must be a number between 0 and 360")
   out <- sapply(
      x,
      FUN = function(x1) {
         mmm_pi <- (3.14159)
         # convert to radians
         rad <- (x1 / 360) * (2 * mmm_pi)
         # invert for 180-360 degrees
         if (rad > mmm_pi) {
            rad <- rad - (2 * (rad - mmm_pi))
         }
         return(1 - (2 * rad / mmm_pi))
      }
   )
   return(unlist(out))
}

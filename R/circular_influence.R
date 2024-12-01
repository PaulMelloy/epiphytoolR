#' Calculate the influence of 2 dimensional vectors
#'
#' @details This function determines the circular vector influence on a 1 to -1
#'  scale. For example if the wind is blowing on a northerly vector (0 degrees)
#'  there is no influence reduction. If wind blows at a 90 degree angle there is
#'  no influence on the north south plane.
#'
#' @param x degrees (numeric), numeric of length one
#' @param offset degrees (numeric), what angle should the function offset to and
#'  the returned value be 1.
#'
#' @return numeric double vector giving the proportion of influence from two
#'  dimensions, the \emph{x} dimension and \emph{y} dimension between -1 and 1
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
circular_influence <- function(x, offset = 0) {
   if(length(x) != 1) stop("'x' must be numeric of length one")
   if(isFALSE(class(x) == "numeric") &
      isFALSE(class(x) == "integer"))
      stop("'x' must be numeric of length one"
      )
   if (x < 0 |
       x > 360)
      stop("'x' must be a number between 0 and 360", call. = FALSE)
   mmm_pi <- (3.14159)
   # convert to radians
   rad <- (x / 360) * (2 * mmm_pi)
   offset_rad <- (offset / 360) * (2 * mmm_pi)
   rad <- rad - offset_rad
   # invert for 180-360 degrees
   # if (abs(rad) > mmm_pi) {
   #    rad <- abs(rad) - (2 * (abs(rad) - mmm_pi))
   # }
   #return(1 - (2 * abs(rad) / mmm_pi))
   cart_out <- c(x = sin(rad),
                 y = cos(rad))
   return(cart_out)
}

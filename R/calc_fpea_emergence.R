#' Calculate field-pea emergence
#'
#' @description
#' Function calculates the time, in degree days, between sowing and
#' emergence (when 50% of sown seeds have produces at least one true leaf).
#'
#' @details
#' Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
#' Pathology. Formula is reported to correlate to R^2 = 0.91 for pea cultivae
#' Cheyenne grown in the west of France
#' @source <https://doi.org/10.1007/978-1-4020-6065-6_9>
#'
#'
#' @param das number of days after sowing (integer)
#'
#' @return number of degree days predicted from time of sowing to emergence
#' @export
#'
#' @examples
#' calc_fpea_emergence(14)
calc_fpea_emergence <- function(das){
   x1 <- das/14
   y1 <- (-4.08 * (x1^2)) +
      (57.36 * x1) +
      97.49
   return(y1)
}

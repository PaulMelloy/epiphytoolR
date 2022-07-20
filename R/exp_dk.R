#' Exponential dispersal kernel
#'
#' Exponential dispersal kernel function as described by Karisto et al. (2022)
#'
#' @param r Distance from the source to the destination
#' @param a Scale parameter
#' @references
#' Petteri Karisto, Frédéric Suffert and Alexey Mikaberidze. (2022). Measuring Splash
#' Dispersal of a Major Wheat Pathogen in the Field. *PhytoFrontiers™* **2**, 30-40.
#'
#' @return a numeric value indicating the
#' @export
#'
#' @examples
#' exp_dk(r = 0:10)
#' exp_dk(r = 0:10, a = 5)
exp_dk <- function(r, a = 1) {
   (exp(-r / a) / (2 * pi * (a ^ 2)))
}

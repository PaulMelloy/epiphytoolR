#' Power lax dispersal kernal
#'
#' Dispersal kernal using the power law, as described by Sackett and Mundt (2005)
#'
#' @param x numeric, Distance in meters.
#' @param a numeric, scale parameter. Defaults to parameter used for stripe rust
#'  (*Pucinnia striiformis*) dispersal by Sackett and Mundt (2005).
#' @param b numeric, dimensionless parameter. Defaults to parameter used for
#'  stripe rust (*Pucinnia striiformis*) dispersal by Sackett and Mundt (2005).
#'
#' @return estimated lesions per leaf
#' @export
#' @references https://apsjournals.apsnet.org/doi/pdf/10.1094/PHYTO-95-0983
#'
#' @examples
#' power_dk(5)
#' power_dk(1:20)
power_dk <- function(x,a = 184.9,b = 2.07){
   return(a*x^(-b))
}

#' Calculate Vapour-pressure
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967) to calculate the vapour pressure from temperature in degrees
#'  Celsius and relative humidity.
#'
#' @param RH Relative humidity
#' @param Tm Temperature in degrees Celsius
#' @param eq Type of equation to use while calculation VPD. defaults `"Murray"`.
#'  Other option `"Sapak"`
#'
#' @return Vapour-pressure in kPa
#' @references
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#' @examples
#' calc_vp(Tm = 30)
#' calc_vp(RH = 99,Tm = 30, eq = "Sapak)
calc_vp <- function(RH, Tm, eq = "Murray"){
   return(calc_svp(Tm, eq = eq) * (RH/100))
}

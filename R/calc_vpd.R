#' Calculate Vapour-pressure deficit from relative humidity and temperature
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967)
#'
#' @param RH Relative humidity
#' @param Tm Temperature in degrees celcius
#' @param eq Type of equation to use while calculation VPD. defaults to the `BOM`
#'  (Bureau of Meterology equation, Australia). Other options, `"Murray"` and
#'  `"Sapak"`
#' @param verbose prints saturated vapour pressure (SVP) and vapour pressure
#'  in kPa before returning the VPD result
#'
#' @return Vapour-pressure deficit in kPa
#' @references
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#'
#'
#' @examples
#' calc_vpd(RH = 99, Tm = 30)
calc_vpd <- function(RH, Tm, eq = "BOM", verbose = FALSE){
   return((1-(RH/100))*calc_svp(Tm = Tm, eq = eq))

   #
   # SVP <- exp(17.27*Tm/(T+237.3))
   #
   # https://physics.stackexchange.com/questions/4343/how-can-i-calculate-vapor-pressure-deficit-from-temperature-and-relative-humidit
   # SVP <- 6.1078*exp(17.2693882*(Tm-273.16))
   #


   #(RH/100 * SVP) - SVP
}

#' Calculate Vapour-pressure deficit from relative humidity and temperature
#'
#' @description This formula uses the same formula described by the Bureau of
#'  Meteorology (BOM) and the American Meteorological Society. Other formulas
#'  described by described by Murray (1967) or Tetens (1930) to calculate
#'  vapour pressure from temperature in degrees and Celsius and relative
#'  humidity can also be called.
#'
#' @param RH numeric, Relative humidity
#' @param Tm numeric, Temperature in degrees Celsius
#' @param eq character, Type of equation to use while calculation VPD. defaults
#'  to the "BOM" (Bureau of Meteorology equation, Australia). Other options,
#'  "Murray" and "Sapak"
#' @param verbose logical, prints saturated vapour pressure (SVP) and vapour
#'  pressure in kPa before returning the VPD result.
#'
#' @return Vapour-pressure deficit kPa, class \CRANpkg{units}
#' @references
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#'
#' @examples
#' calc_vpd(RH = 99, Tm = 30)
calc_vpd <- function(RH, Tm, eq = "BOM", verbose = FALSE){
   vpd <- (1-(RH/100))*calc_svp(Tm = Tm, eq = eq)

   #
   # SVP <- exp(17.27*Tm/(T+237.3))
   #
   # https://physics.stackexchange.com/questions/4343/how-can-i-calculate-vapor-pressure-deficit-from-temperature-and-relative-humidit
   # SVP <- 6.1078*exp(17.2693882*(Tm-273.16))
   #

   #(RH/100 * SVP) - SVP

   return(units::set_units(vpd, "kPa"))
}

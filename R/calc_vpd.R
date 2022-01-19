#' Calculate Vapour-pressure deficit from relative humidity and temperature
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967)
#'
#' @param RH Relative humidity
#' @param Tm Temperature in degrees celcius
#'
#' @return Vapour-pressure deficit in KPa
#' @references
#' @export
#'
#' @examples
#' calc_vpd()
#' calc_vpd(RH = 99, Tm = 30)
calc_vpd <- function(RH = 70, Tm = 24){
   #SVP <- 610.7*10^((7.5*Tm)/237.3 + Tm)

   #
   # SVP <- exp(17.27*Tm/(T+237.3))
   #
   # https://physics.stackexchange.com/questions/4343/how-can-i-calculate-vapor-pressure-deficit-from-temperature-and-relative-humidit
   # SVP <- 6.1078*exp(17.2693882*(Tm-273.16))
   #
   SVP <- (10^(((Tm * 7.5)/(Tm + 237.3))+0.7858))*0.1
   (1-(RH/100))*SVP

   #(RH/100 * SVP) - SVP
}

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
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#'
#'
#' @examples
#' calc_vpd()
#' calc_vpd(RH = 99, Tm = 30)
calc_vpd <- function(RH = 70, Tm = 24, eq = "Murray", verbose = FALSE){
   if(eq == "Sapak"){
      SVP <- 610.7*(10^((7.5*Tm)/237.3 + Tm))
      return((1-(RH/100))*SVP)
   }else{
      # Murray 1967
      SVP <- (10^(((Tm * 7.5)/(Tm + 237.3))+0.7858))*0.1
      if(verbose){
         cat("SVP =",SVP, "\n VP =",SVP*(RH/100),"\n")
      }
      return((1-(RH/100))*SVP)
   }


   #
   # SVP <- exp(17.27*Tm/(T+237.3))
   #
   # https://physics.stackexchange.com/questions/4343/how-can-i-calculate-vapor-pressure-deficit-from-temperature-and-relative-humidit
   # SVP <- 6.1078*exp(17.2693882*(Tm-273.16))
   #


   #(RH/100 * SVP) - SVP
}

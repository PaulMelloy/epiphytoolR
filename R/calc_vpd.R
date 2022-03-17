#' Calculate Vapour-pressure deficit from relative humidity and temperature
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967)
#'
#' @param RH Relative humidity
#' @param Tm Temperature in degrees celcius
#' @param eq Type of equation to use while calculation VPD. defaults `"Murray"`.
#'  Other option `"Sapak"`
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
calc_vpd <- function(RH, Tm, eq = "Murray", verbose = FALSE){
   return((1-(RH/100))*calc_svp(Tm = Tm, eq = eq))

   #
   # SVP <- exp(17.27*Tm/(T+237.3))
   #
   # https://physics.stackexchange.com/questions/4343/how-can-i-calculate-vapor-pressure-deficit-from-temperature-and-relative-humidit
   # SVP <- 6.1078*exp(17.2693882*(Tm-273.16))
   #


   #(RH/100 * SVP) - SVP
}

#' Calculate saturated Vapour-pressure
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967) to calculate the saturated vapour pressure from temperature in degrees
#'  Celsius.
#'
#' @param Tm Temperature in degrees Celsius
#' @param eq Type of equation to use while calculation VPD. defaults `"Murray"`.
#'  Other option `"Sapak"`
#'
#' @return Saturated vapour-pressure in kPa
#' @references
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#' @examples
#' calc_svp()
#' calc_svp(Tm = 30)
#' calc_svp(Tm = 30, eq = "Sapak)
calc_svp <- function(Tm, eq = "Murray"){
   if(eq == "Sapak"){
      SVP <- 610.7*(10^((7.5*Tm)/237.3 + Tm))
      return((1-(RH/100))*SVP)
   }else{
      # Murray 1967
      return((10^(((Tm * 7.5)/(Tm + 237.3))+0.7858))*0.1)}
}

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
#' calc_vp()
#' calc_vp(Tm = 30)
#' calc_vp(RH = 99,Tm = 30, eq = "Sapak)
calc_vp <- function(RH, Tm, eq = "Murray"){
   return(calc_svp(Tm, eq = eq) * (RH/100))
}

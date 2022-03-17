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
#' calc_svp(Tm = 30)
#' calc_svp(Tm = 30, eq = "Sapak)
calc_svp <- function(Tm, eq = "Murray"){
   if(eq == "Sapak"){
      return(610.7*(10^((7.5*Tm)/237.3 + Tm)))
   }else{
      # Murray 1967
      return((10^(((Tm * 7.5)/(Tm + 237.3))+0.7858))*0.1)}
}

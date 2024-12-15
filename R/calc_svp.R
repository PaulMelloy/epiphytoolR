#' Calculate Saturated Vapour-Pressure (SVP)
#'
#' @description This formula uses the same formula described by the Bureau of
#'  Meteorology (BOM) and the American Meteorological Society. Other formulas
#'  described by described by Murray (1967) or Tetens (1930) to calculate
#'  saturated vapour pressure from temperature in degrees and Celsius and
#'  relative humidity can also be called.
#'
#' @param Tm numeric, Temperature in degrees Celsius
#' @param eq character, Type of equation to use while calculation VPD. defaults to the "BOM"
#'  (Bureau of Meteorology equation, Australia). Other options, "Murray" and
#'  "Sapak".
#'
#' @return Saturated vapour-pressure in kPa, class \CRANpkg{units}
#' @references
#'  Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
#'  *J. Appl. Meteor. Climatol.*, \emph{6}, 203–204,
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#' @examples
#' calc_svp(Tm = 30)
#' calc_svp(Tm = 30, eq = "Murray")
calc_svp <- function(Tm, eq = "BOM"){
   if(eq == "Sapak"){
      svp <- 610.7*(10^((7.5*Tm)/237.3 + Tm))
   }
   if(eq == "Murray"){
      # Murray 1967
      svp <- (10^(((Tm * 7.5)/(Tm + 237.3))+0.7858))*0.1
   }
   if(eq == "BOM"){
         #BOM
      svp <- exp (1.8096 + (17.269425 * Tm)/(237.3 + Tm))/10
   }
   return(units::set_units(svp, "kPa"))
}

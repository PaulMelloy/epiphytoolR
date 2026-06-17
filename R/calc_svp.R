#' Calculate Saturated Vapour-Pressure (SVP)
#'
#' @description Calculates saturated vapour pressure from air temperature.
#'  By default the equation described by the Bureau of Meteorology (BOM) and the
#'  American Meteorological Society is used. The equations described by
#'  Murray (1967) or Tetens (1930) can also be selected via the `eq` argument.
#'
#' @param Tm numeric, Temperature in degrees Celsius
#' @param eq character, type of equation to use. Defaults to `"BOM"`
#'  (Bureau of Meteorology equation, Australia). Other options are `"Murray"`
#'  (Murray 1967) and `"Tetens"` (Tetens 1930). `"Sapak"` is accepted as a
#'  deprecated alias of `"Tetens"`.
#'
#' @return Saturated vapour-pressure in kPa, class \CRANpkg{units}
#' @references
#'  Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
#'  *J. Appl. Meteor. Climatol.*, \emph{6}, 203–204,
#'  \doi{10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2}
#'
#'  Tetens, O., 1930: Uber einige meteorologische Begriffe.
#'  *Zeitschrift fur Geophysik*, \emph{6}, 297–309.
#' @export
#' @examples
#' calc_svp(Tm = 30)
#' calc_svp(Tm = 30, eq = "Murray")
#' calc_svp(Tm = 30, eq = "Tetens")
calc_svp <- function(Tm, eq = "BOM"){
   if(eq %in% c("BOM", "Murray", "Tetens", "Sapak") == FALSE){
      stop("'eq' must be one of \"BOM\", \"Murray\" or \"Tetens\"")
   }
   if(eq == "Tetens" || eq == "Sapak"){
      # Tetens (1930), saturation vapour pressure over water in kPa
      svp <- 0.61078 * exp((17.27 * Tm) / (Tm + 237.3))
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

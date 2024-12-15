#' Calculate Vapour-pressure
#'
#' @description This formula uses the same formula described by the Bureau of
#'  Meteorology (BOM) and the American Meteorological Society. Other formulas
#'  described by described by Murray (1967) or Tetens (1930) to calculate
#'  vapour pressure from temperature in degrees and Celsius and relative
#'  humidity can also be called.
#'
#' @param RH numeric, relative humidity
#' @param Tm numeric, Temperature in degrees Celsius
#' @param eq character, Type of equation to use while calculation VPD. defaults to the
#'  "BOM" (Bureau of Meteorology equation, Australia). Other options are
#'  "Murray" and "Sapak"
#' @param dp numeric, Dew point, in degrees Celsius
#'
#' @return Vapour-pressure in kPa class \CRANpkg{units}
#' @references
#'  http://www.bom.gov.au/climate/austmaps/about-vprp-maps.shtml
#'
#'  Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
#'  *J. Appl. Meteor. Climatol.*, \emph{6}, 203–204,
#'  https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
#' @export
#' @examples
#' calc_vp(RH = 99,Tm = 30)
#' calc_vp(RH = 99,Tm = 30, eq = "Murray")
#' calc_vp(dp = 10)
calc_vp <- function(RH, Tm, dp = NULL, eq = "BOM") {
   if (is.null(dp)) {
      vp <- calc_svp(Tm, eq = eq) * (RH / 100)
   } else{
      # equation from the Australian Bureau of Meteorology
      # divided by 10 to convert from hectopascals to kPa
      if (missing(RH) == FALSE |
          missing(Tm) == FALSE) {
         message("Ignoring RH or Tm inputs and calculating vp from dew point `dp`")
      }
      vp <- exp(1.8096 + (17.269425 * dp) / (237.3 + dp)) /
                                 10
}
   return(units::set_units(vp,"kPa"))
}

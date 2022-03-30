#' Calculate Vapour-pressure
#'
#' @description This formula uses Tetens (1930) equation as described by Murray
#'  (1967) to calculate the vapour pressure from temperature in degrees
#'  Celsius and relative humidity.
#'
#' @param RH Relative humidity
#' @param Tm Temperature in degrees Celsius
#' @param eq Type of equation to use while calculation VPD. defaults to the `BOM`
#'  (Bureau of Meterology equation, Australia). Other options, `"Murray"` and
#'  `"Sapak"`
#' @param dp Dew point, in degrees Celsius
#'
#' @return Vapour-pressure in kPa class \CRANpkg{units}
#' @references
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
      # equation from the Australian Beureu of meteorology
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

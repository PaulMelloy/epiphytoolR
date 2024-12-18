% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_vp.R
\name{calc_vp}
\alias{calc_vp}
\title{Calculate Vapour-pressure}
\usage{
calc_vp(RH, Tm, dp = NULL, eq = "BOM")
}
\arguments{
\item{RH}{numeric, relative humidity}

\item{Tm}{numeric, Temperature in degrees Celsius}

\item{dp}{numeric, Dew point, in degrees Celsius}

\item{eq}{character, Type of equation to use while calculation VPD. defaults to the
"BOM" (Bureau of Meteorology equation, Australia). Other options are
"Murray" and "Sapak"}
}
\value{
Vapour-pressure in kPa class \CRANpkg{units}
}
\description{
This formula uses the same formula described by the Bureau of
Meteorology (BOM) and the American Meteorological Society. Other formulas
described by described by Murray (1967) or Tetens (1930) to calculate
vapour pressure from temperature in degrees and Celsius and relative
humidity can also be called.
}
\examples{
calc_vp(RH = 99,Tm = 30)
calc_vp(RH = 99,Tm = 30, eq = "Murray")
calc_vp(dp = 10)
}
\references{
http://www.bom.gov.au/climate/austmaps/about-vprp-maps.shtml

Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
\emph{J. Appl. Meteor. Climatol.}, \emph{6}, 203–204,
https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
}

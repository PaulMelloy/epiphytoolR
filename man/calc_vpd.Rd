% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_vpd.R
\name{calc_vpd}
\alias{calc_vpd}
\title{Calculate Vapour-pressure deficit from relative humidity and temperature}
\usage{
calc_vpd(RH, Tm, eq = "BOM", verbose = FALSE)
}
\arguments{
\item{RH}{Relative humidity}

\item{Tm}{Temperature in degrees Celsius}

\item{eq}{Type of equation to use while calculation VPD. defaults to the \code{BOM}
(Bureau of Meteorology equation, Australia). Other options, \code{"Murray"} and
\code{"Sapak"}}

\item{verbose}{prints saturated vapour pressure (SVP) and vapour pressure
in kPa before returning the VPD result}
}
\value{
Vapour-pressure deficit kPa, class \CRANpkg{units}
}
\description{
This formula uses Tetens (1930) equation as described by Murray
(1967)
}
\examples{
calc_vpd(RH = 99, Tm = 30)
}
\references{
https://doi.org/10.1175/1520-0450(1967)006<0203:OTCOSV>2.0.CO;2
}

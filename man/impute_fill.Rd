% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/impute_diurnal.R
\name{impute_fill}
\alias{impute_fill}
\title{Fill Imputation}
\usage{
impute_fill(ind, var, times, FUN_n)
}
\arguments{
\item{ind}{index vector}

\item{var}{numeric vector of values containing NA_real values for imputation}

\item{times}{POSIXct vector of time in hourly increments}

\item{FUN_n}{rolling window size}
}
\value{
vector of var values filling NA
}
\description{
Imputes a new vector of variables which can be used to fill NA values.
}
\examples{
dt <- weather
rolling_window <- length(dt[is.na(temp),temp])*2
dt[,indx := .I]

dt[, tm_imp := round(data.table::frollapply(
  indx,
  n = rolling_window,
  fill = NA_real_,
  FUN = impute_fill,
  FUN_n = rolling_window,
  times = times,
  var = temp,
  align = "center"
  ),3)]

plot(dt[2950:3100, temp], type = "l")
lines(dt[2950:3100, tm_imp], type = "l", col = "red")
}

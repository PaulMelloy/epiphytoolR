#' Stochastically rounds up or down real numbers.
#'
#' Randomly rounds up or down real numbers with weighting to the closest integer
#'
#' @keywords internal
#' @noRd

random_integer_from_real <- function (r) {
  fraction <- r %% 1
  r_stand <- stats::runif(1)
  fcase(
    fraction == 0,
    as.integer(r),
    r_stand < fraction,
    as.integer(ceiling(r)),
    r_stand >= fraction,
    as.integer(floor(r))
  )
}

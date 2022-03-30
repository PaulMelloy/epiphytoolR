
# nocov start
#' @import data.table
NULL

# used in format_weather()
`%notin%` <- function(x, table) {
   match(x, table, nomatch = 0L) == 0L
}

# a warnings environment is needed for capture.warnings
warn <- new.env(parent = .GlobalEnv)
warn$logs <- list()

# This function is never called.
# It only makes `sf` available in the package for `lutz` to use.
# `lutz` only has `sf` in Suggests, but it is needed for the function we use
# from `lutz`

stub <- function() {
   sf::st_as_sf()
}
# nocov end

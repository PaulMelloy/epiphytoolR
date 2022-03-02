
# nocov start
#' @import data.table
NULL

# used in format_weather()
`%notin%` <- function(x, table) {
   match(x, table, nomatch = 0L) == 0L
}

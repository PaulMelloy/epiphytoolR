
# nocov start
#' @import data.table
NULL

# used in format_weather()
`%notin%` <- function(x, table) {
   match(x, table, nomatch = 0L) == 0L
}

# This function is never called.
# It only makes `sf` available in the package for `lutz` to use.
# `lutz` only has `sf` in Suggests, but it is needed for the function we use
# from `lutz`

stub <- function() {
   sf::st_as_sf()
}
# nocov end



#' Read Australian Bureau of Meteorology json
#'
#' Wrapper for \code{\link[jsonlite]{read_JSON}} specific for BOM weather data
#'
#' @param f_path character, file path to BOM weather data in json format.
#' @param header logical, weather to display the copyright header or not. Default
#' is 'TRUE'
#' @param ... additional arguments to be parsed to \code{\link[jsonlite]{read_JSON}}
#'
#' @returns data.frame of weather data
#'
#' @noRd
read_bom_json <- function(f_path,
                          header = TRUE,
                          ...){
   weathr_j <- jsonlite::read_json(path = f_path,
                                   simplifyVector = TRUE,
                                   ...)

   if(header){
      message(weathr_j$observations$notice$copyright)
   }

   out <- as.data.table(weathr_j$observations$data)
   return(out)
}


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


.uq_fleet <- function(km, Days, half_days = 0){
   cat("Minibus: ", (125 * Days)+ (65 * half_days) + (0.15 * km))
   cat("\nPeople Mover: ", (140 * Days)+ (70 * half_days) + (0.17 * km))
   cat("\nTesla: ", (160 * Days)+ (80 * half_days) + (0.05 * km))
   cat("\nCamry Hybrid: ", (125 * Days)+ (62.50 * half_days) + (0.12 * km))
   cat("\nHyundai Staria: ", (130 * Days)+ (70 * half_days) + (0.18 * km))
   cat("\nKia Hybrid wagon: ", (90 * Days)+ (55 * half_days) + (0.10 * km))
   cat("\nMitsubisho Outlander: ", (125 * Days)+ (62.50 * half_days) + (0.20 * km))
   cat("\nHiLux Extra Cab: ", (135 * Days)+ (67.5 * half_days) + (0.20 * km))
   cat("\nHiLux Double Cab: ", (100 * Days)+ (60 * half_days) + (0.18 * km))

}

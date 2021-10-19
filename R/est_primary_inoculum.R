#' Estimate blackspot primary inoculum
#'
#' @description Estimate the amount of blackspot lesions per plant caused by
#'  primary inoculumn, or ascospores. Formula interpreted from Schoeny. et al.
#'  (2007) in European Journal of Plant Pathology.
#'
#' @source <https://doi.org/10.1007/978-1-4020-6065-6_9>
#'
#' @param degree_days sum degree days in celcius over 7 days
#' @param rainfall vector of daily rainfall, or maximum rainfall in a week
#'
#' @return number of new blackspot lesions per plant over 7 days
#' @export
#'
#' @examples
#' est_primary_inoculum(degree_days = 250,
#'                rainfall = 15)
est_primary_inoculum <- function(degree_days, rainfall){
   IP <- 0.02198 * degree_days + 0.11185 * max(rainfall, na.rm = TRUE)

   return(IP)
}

#' Daily Infection Values
#'
#' @description
#' Calculates the Temperature index for day i and hour j. Temperature index is used
#'  to calculate the Daily Infection Values (DIV) for the model published by Shoeny et. al
#'  (2007).
#'
#' @details
#' Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
#' Pathology.
#'
#' @source <https://doi.org/10.1007/978-1-4020-6065-6_9>
#'
#' @param RH relative humitiy percentage (numeric)
#' @param Tm daily average temperature in degrees celcius
#' @param rainfall daily rainfall in millimeters
#'
#' @return infection value for day i ranging between 0 (no fungal growth) and 1
#'  (optimal growth)
#' @export
#'
#' @examples
#' DIV(70,20, rainfall = 0)
DIV <- function(RH, Tm, rainfall = 0.2){
   if(rainfall >= 0.2 | RH >= 70){
      Mij <- 1
   }else{
      Mij <- 0}

   Tij <- DIV_Tm_index(temp = Tm,
                       rainfall = rainfall)

   DIV_i <- Mij * Tij

   return(DIV_i)
}

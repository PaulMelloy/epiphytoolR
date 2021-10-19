#' Daily Infection Value - temperature index
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
#' @param temp daily average temperature in degrees celcius
#' @param rainfall rainfall in mm
#'
#' @return Temperature index value (numeric), used in calculating DIV
#' @export
#'
#' @examples
#' DIV_Tm_index(25)
DIV_Tm_index <- function(temp, rainfall = 0.2){
   if(temp <=0){
      warning("Average temperature below zero, temperature range for growth. NA returned")
      return(0)
   }

   if(rainfall >= 0.2){
      IPt <- ((0.0171*(temp^2)) - (0.6457*temp) + 6.8)
      }else{
         IPt <- ((0.0307*(temp^2)) - (1.195*temp) + 12.1)
      }
   # return(abs(rnorm(n = 1,
   #              mean = 1/IPt,
   #              sd = 1)))
   if(1/IPt >= 1){
      return(1)
   }else{
      return(1/IPt)
   }

}


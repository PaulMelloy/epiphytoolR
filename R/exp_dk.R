#' Exponential dispersal kernel
#'
#' Exponential dispersal kernel function as described by Karisto et al. (2022)
#'
#' @param r Distance from the source to the destination
#' @param a Scale parameter
#' @references
#' Petteri Karisto, Frédéric Suffert and Alexey Mikaberidze. (2022). Measuring Splash
#' Dispersal of a Major Wheat Pathogen in the Field. *PhytoFrontiers™* **2**, 30-40.
#'
#' @return a numeric value indicating the
#' @export
#'
#' @examples
#' exp_dk(r = 0:10)
#' exp_dk(r = 0:10, a = 5)
exp_dk <- function(r, a = 1) {
   (exp(-r / a) / (2 * pi * (a ^ 2)))
}

#' Function two in Karisto et al. (2022)
#'
#' @param initial_intensity numeric, Initial inoculum intensity
#' @param transmission_rate numeric, rate at which spores are produced and dispersed
#' @param dist numeric, distance from source in which to query the inoculum risk
#' @param border the border, needs description
#' @param source_width numeric, width of the inoculum source in centimetres
#' @param destination_width numeric, width in centimetres
#' @param source_length numeric, length of the inoculum source in centimetres
#' @param a numeric, exponential dispersal kernel constant
#'
#' @return numeric, the number of spores estimated to have dispersed to the defined
#'  location
#'
#' @examples
#' @noRd
f2 <- function(initial_intensity,
               transmission_rate = 2,
               dist,
               border = 12.5,
               source_width = 40,
               destination_width = 10,
               source_length = 112.5,
               a = 1){

   width <- source_length
   area <-
      (initial_intensity * transmission_rate)/
      (width * 2*border)

   area *
      (exp(-(
         sqrt(
            (dist - source_width)^2 +
            (destination_width - source_length)^2)/
            a))/
          2*pi*a^2
      )
}

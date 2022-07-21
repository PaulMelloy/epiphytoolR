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
#' @param initial_intensity
#' @param transmission_rate
#' @param dist
#' @param measurement_width
#' @param border
#' @param source_width
#' @param destination_width
#' @param source_length
#' @param a
#'
#' @return
#'
#' @examples
f2 <- function(initial_intensity,
               transmission_rate = 2,
               dist,
               measurement_width = 10,
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
            (measurement_width - source_length)^2)/
            a))/
          2*pi*a^2
      )
}

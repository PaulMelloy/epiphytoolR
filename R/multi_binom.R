#' Splash dispersal multi-binomial
#'
#' @description Generate a two dimensional probability distribution representing
#'  the probability of spore dispersal from an inoculum source. Generates the
#'  probability distribution with each entry representing a single plant
#'
#' @param row_spacing Crop row spacing in meters
#' @param width paddock with in meters
#' @param px pixel size, length and width of rectangular pixel
#' @param seeding_r number of plants sown in a pixel (`px`)
#' @param IO number of infective sites within the pixel
#' @param m (optional) a matrix representing each plant and the number of
#'  infective sites for each plant
#'
#' @return probabilty matrix where each entry gives the probabiltiy of splash
#'  dispersal from infective sites to the respective entry
#' @export
#'
#' @examples
#' set.seed(1)
#' # obtain matrix of probabilities
#' mvb <- multi_var_binom()
#' image(t(mvb))
#' # sample the plant (matrix cell) where the spore may drop
#' sample(seq_along(mvb), size = 10, prob = mvb, replace = TRUE)
#' # sample the cardinal coordinates (matrix cell) where the spore may drop
#' sample(seq_along(mvb), size = 10, prob = mvb, replace = TRUE)
multi_var_binom <- function(row_spacing = 0.3,
                            width = 1,
                            px = 1,
                            seeding_r = 40,
                            n_inf = 1,
                            m){

   if(missing(m)){
      # Create a matrix representing the plants in the pixel dimensions
      m <- mat_it(rs = row_spacing,
                  px = px,
                  seeding_r = seeding_r)

      #randomly infect one of the plants
      m[runif(n_inf, 1, seeding_r)] <- 1
      }


   # return incidies for locations which are greater than 0
  ind <- which(m >0)

  n_c <- ncol(m)
  n_r <- nrow(m)

  out <-
    lapply(ind,function(i){

      r <- i %% n_r
      cl <- ceiling(i / n_r)
      lateral <- dnorm(1:n_r,mean = r)
      lon <- dnorm(1:n_c, mean = cl)
      rs_diff <-

      new_m <-
        matrix(
          unlist(
            lapply(seq_along(lon), function(i2) {
              off_set <- abs(i2 - cl)
              (lon[i2] * (1-((row_spacing * off_set) /width)))*lateral
              })
            ),
          nrow = n_r)

      return(new_m)
  })

  return(out[[1]])
}

mat_it <- function(rs = 0.3, px = 1, seeding_r = 40){

   rows <- floor(px/rs) + rbinom(1,1,rs %% 1)

   plants_per_row <- seeding_r / (px/rs)

   plant_m <- matrix(0, nrow = plants_per_row, ncol = rows)

   return(plant_m)
}

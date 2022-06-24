#' Splash dispersal multi-binomial
#'
#' @description Generate a two dimensional probability distribution representing
#'  the probability of spore dispersal from an inoculum source. Generates the
#'  probability distribution with each entry representing a single plant
#'
#' @param row_spacing Crop row spacing in meters
#' @param stdev Standard deviation of splash distribution. defaults to pixel size
#' @param width paddock width in meters
#' @param px pixel size, length and width of square pixel
#' @param seeding_r number of plants sown in a pixel (`px`)
#' @param IO number of infective sites within the pixel
#' @param m (optional) a matrix representing each plant and the number of
#'  infective sites for each plant
#'
#' @return probabilty matrix where each entry gives the probabiltiy of splash
#'  dispersal from infective sites to the respective entry
#' @import stats
#' @export
#'
#' @examples
#' set.seed(7)
#' # obtain matrix of probabilities
#' mvb <- multi_var_binom()
#' image(t(mvb))
#' # sample the plant (matrix cell) where the spore may drop
#' sample(seq_along(mvb), size = 10, prob = mvb, replace = TRUE)
#' # sample the cardinal coordinates (matrix cell) where the spore may drop
#' sam_mvb <- sample(seq_along(mvb), size = 10, prob = mvb, replace = TRUE)
#' data.frame(x = sapply(sam_mvb,FUN = function(x) ceiling(x/ nrow(mvb))),
#'            y = sapply(sam_mvb,FUN = function(x) x %% nrow(mvb)))
#'
#' # simulate spore dispersal over 40 spread events
#' for(sp in 1:40){
#' if(sp == 1){
#'   m1 <- multi_var_binom()
#'   m0 <- matrix(0,nrow = nrow(m1),ncol = ncol(m1))
#'   ind1 <- sample(seq_along(m1), size = 1, prob = m1, replace = TRUE)
#'   m0[ind1] <- 1
#' }else{
#'   m1 <- multi_var_binom(m = m0)
#'   ind1 <- sample(seq_along(m1), size = 1, prob = m1, replace = TRUE)
#'   m0[ind1] <- m0[ind1] + 1
#' }
#' }
#' image(t(m1))
multi_var_binom <- function(row_spacing = 0.3,
                            stdev = NULL,
                            width = 1,
                            px = 1,
                            seeding_r = 40,
                            IO = 1,
                            m){

   if(is.null(stdev)){
      stdev <- px
   }

   if(missing(m)){
      # Create a matrix representing the plants in the pixel dimensions
      m <- mat_it(rs = row_spacing,
                  px = px,
                  seeding_r = seeding_r)

      #randomly infect one of the plants
      m[round(runif(IO, 1, length(m)))] <- 1
   }

  # Check m is a matrix
  if(is.matrix(m) == FALSE) stop("'m' is not a matrix")


   # return incidies for locations which are greater than 0
  ind <- which(m >0)

  n_c <- ncol(m)
  n_r <- nrow(m)

  out <-
    lapply(ind,function(i){

      r <- i %% n_r
      cl <- ceiling(i / n_r)
      lateral <- dnorm(1:n_r,mean = r,sd = stdev)
      lon <- dnorm(1:n_c, mean = cl,sd = stdev)

      new_m <-
        matrix(
          unlist(
            lapply(seq_along(lon), function(i2) {
              # what is the distance from the inoculum source to the plant in columns/rows
               off_set <- abs(i2 - cl)
               # Find real distance between inoculumn source and plant
               #  then adjust for the width of the
              (lon[i2] * (1-((row_spacing * off_set) /width)))*lateral
              })
            ),
          nrow = n_r)

      return(new_m)
  })

  return(Reduce('+',out)/length(out))
}

mat_it <- function(rs = 0.3, px = 1, seeding_r = 40){

   rows_per_pixel_frac <- px/rs
   # adjust to row number with the random chance of adding a row from leftover space
   rows_per_pixel <-
      floor(rows_per_pixel_frac) +
      rbinom(1,1,rows_per_pixel_frac %% 1)

   plants_per_row <- seeding_r / rows_per_pixel_frac

   plant_m <- matrix(rep(0,plants_per_row*rows_per_pixel),
                     nrow = plants_per_row,
                     ncol = rows_per_pixel)

   return(as.matrix(plant_m))
}

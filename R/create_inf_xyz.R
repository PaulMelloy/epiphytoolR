#' Create xyz data.frame with z plots
#'
#' Creates an xy data.frame and a z column "load" with a specified value in paddock
#'  plots
#'
#' @param plot_length numeric, length of experimental plots in paddock (meters)
#' @param plot_width numeric, width of experimental plots in paddock (meters)
#' @param paddock_length numeric, length of paddock (meters)
#' @param paddock_width numeric, width of paddock (meters)
#' @param infected_plots numeric vector of plot numbers which are infected. Plot 1
#'  starts in the corner and then are allocated across the width (x) of the paddock
#'  as plot numbers increase. Default is `"random"` and will randomly assign infected
#'  `n_plots` in quantity.
#' @param n_plots numeric, number of infected plots, used when infected_plots is
#'  specified as `"random"`
#' @param infection_weight the value applied to the *z* `load` column of infected
#'  plots
#'
#' @return and xyz `data.frame` with colnames `x`,`y` amd `load`
#' @export
#'
#' @examples
#' p1 <- create_inf_xyz()
#' plot(p1$x,p1$y)
#' points(p1[p1$load > 0,"x"],
#'        p1[p1$load > 0,"y"],
#'        col = "red")
create_inf_xyz <- function(plot_length = 20,
                                       plot_width = 10,
                                       paddock_length = 100,
                                       paddock_width = 100,
                                       infected_plots = "random",
                                       n_plots = 15,
                                       infection_weight = 1) {
   if (paddock_length %% plot_length != 0)
      stop("'paddock_length' must be equally divisable by 'plot_length'")
   if (paddock_width %% plot_width != 0)
      stop("'paddock_width' must be equally divisable by 'plot_width'")

   w_n <- paddock_width / plot_width
   l_n <- paddock_length / plot_length

   total_plots <- w_n * l_n

   if (n_plots > total_plots)
      stop("'n_plots' can't be larger than total plots")

   if (length(infected_plots) == 1) {
      if (infected_plots == "random") {
         infected_plots <- sample(1:total_plots, n_plots)
      }
   }

   if(any(infected_plots > total_plots))
      stop("'infected_plots' includes a plot number higher than the number of calculated plots")


   paddock <-
      expand.grid(x = 1:paddock_width,
                  y = 1:paddock_length)

   paddock$load <- 0

   for (i in infected_plots) {
      ra_ge <- i %% w_n
      if(ra_ge == 0) ra_ge <- w_n
      r_w <- ceiling(i / w_n)

      x_inf <- (1 + (plot_width * (ra_ge - 1))):(plot_width * ra_ge)
      y_inf <- (1 + (plot_length * (r_w - 1))):(plot_length * r_w)

      paddock$load[paddock$x %in% x_inf &
                      paddock$y %in% y_inf] <- infection_weight
   }

   return(paddock)
}
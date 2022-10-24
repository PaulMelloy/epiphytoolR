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
#' @param external_buffer_end numeric, length of buffers on the end of the paddock
#'  (meters)
#' @param external_buffer_adj numeric, length of buffers on the sides of the paddock
#'  (meters)
#' @param internal_buffer_adj numeric, length of buffers between plots adjacent to the
#'  row direction (meters)
#' @param internal_buffer_end numeric, length of buffers between plots ends in the
#'  row direction (meters)
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
#' points(p1[p1$load == 0,"x"],
#'        p1[p1$load == 0,"y"],
#'        col = "darkgreen")
create_inf_xyz <- function(plot_length = 20,
                           plot_width = 10,
                           paddock_length = 100,
                           paddock_width = 100,
                           infected_plots = "random",
                           n_plots = 15,
                           infection_weight = 1,
                           external_buffer_end = 2,
                           external_buffer_adj = 2,
                           internal_buffer_adj = 1,
                           internal_buffer_end = 1) {


   # trim paddock to exclude buffer dimensions
   # estimate total n plots
   adj_plot_width <-
      internal_buffer_adj + plot_width
      # remove buffer from plot number  calculation
   adj_paddock_width <-
      paddock_width - (external_buffer_adj * 2) +
      internal_buffer_adj # correct for added interal puffer in adj_plot_width

   adj_plot_length <-
      internal_buffer_end + plot_length
   # remove buffer from plot number  calculation
   adj_paddock_length <-
      paddock_length - (external_buffer_end * 2) +
      internal_buffer_end # correct for added interal puffer in adj_plot_width

   w_n <- floor(adj_paddock_width / adj_plot_width)
   w_extra <- adj_paddock_width %% adj_plot_width
   if(w_extra != 0) message("Field plan has ", w_extra, " meters in excess width")

   l_n <- floor(adj_paddock_length / adj_plot_length)
   l_extra <- adj_paddock_length %% adj_plot_length
   if(l_extra != 0) message("Field plan has ", l_extra, " meters in excess length")

   total_plots <- w_n * l_n

   if (n_plots > total_plots)
      stop("'n_plots' can't be larger than total plots ", (total_plots))

   if (length(infected_plots) == 1) {
      if (infected_plots == "random") {
         infected_plots <- sample(1:total_plots, n_plots)
      }
   }

   if(any(infected_plots > total_plots))
      stop("'infected_plots' includes a plot number higher than the number of calculated plots ", total_plots)


   paddock <-
      expand.grid(x = 1:paddock_width,
                  y = 1:paddock_length)

   paddock$load <- NA

   for (i in infected_plots) {
      ra_ge <- i %% w_n
      if(ra_ge == 0) ra_ge <- w_n
      r_w <- ceiling(i / w_n)

      x_inf <-
         (1 + (adj_plot_width * (ra_ge - 1))):((adj_plot_width * ra_ge) - internal_buffer_adj) + external_buffer_adj
      y_inf <-
         (1 + (adj_plot_length * (r_w - 1))):((adj_plot_length * r_w) - internal_buffer_end) + external_buffer_end

      paddock$load[paddock$x %in% x_inf &
                      paddock$y %in% y_inf] <- infection_weight
   }

   non_infected_plots <- seq_len(total_plots)[-infected_plots]

   for (i in non_infected_plots) {
      ra_ge <- i %% w_n
      if(ra_ge == 0) ra_ge <- w_n
      r_w <- ceiling(i / w_n)

      x_inf <-
         (1 + (adj_plot_width * (ra_ge - 1))):((adj_plot_width * ra_ge) -
                                                             internal_buffer_adj) + external_buffer_adj
      y_inf <-
         (1 + (adj_plot_length * (r_w - 1))):((adj_plot_length * r_w) - internal_buffer_end) + external_buffer_end

      paddock$load[paddock$x %in% x_inf &
                      paddock$y %in% y_inf] <- 0
   }

   return(paddock)
}

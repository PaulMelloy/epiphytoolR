test_that("create_inf_xyz works as expected", {
   t1 <- create_inf_xyz(
      plot_length = 20,
      plot_width = 10,
      paddock_length = 100,
      paddock_width = 100,
      infected_plots = "random",
      n_plots = 15,
      infection_weight = 1
   )

   expect_s3_class(t1,class = "data.frame")
   expect_equal(nrow(t1), 100*100)
   expect_equal(colnames(t1), c("x","y","load"))

   # get infected paddock
   ind1 <- min(which(t1$load == 1))
   x1 <- t1[ind1,"x"]
   y1 <- t1[ind1,"y"]
   x2 <- t1[ind1,"x"] + 9
   y2 <- t1[ind1,"y"] + 19

   plot1 <- t1[t1$x %in% x1:x2 &
                  t1$y %in% y1:y2,]

   expect_equal(nrow(plot1), 10*20)
   expect_equal(nrow(plot1[plot1$load == 1,]), 10*20)
   expect_equal(colnames(plot1), c("x","y","load"))

})

test_that("create_inf_xyz adds expected plots", {

   t2 <- create_inf_xyz(
      plot_length = 20,
      plot_width = 10,
      paddock_length = 100,
      paddock_width = 100,
      infected_plots = c(5,10,15,30),
      n_plots = 15,
      infection_weight = 1
   )

   # plot(t2$x,t2$y)
   # points(t2[t2$load > 0,"x"],
   #        t2[t2$load > 0,"y"],
   #        col = "red",
   #        pch = 15)

   expect_s3_class(t2,class = "data.frame")
   expect_equal(nrow(t2), 100*100)
   expect_equal(colnames(t2), c("x","y","load"))

   # get infected paddock
   ind1 <- min(which(t2$load == 1))
   x1 <- t2[ind1,"x"]
   y1 <- t2[ind1,"y"]
   x2 <- t2[ind1,"x"] + 9
   y2 <- t2[ind1,"y"] + 19

   plot1 <- t2[t2$x %in% x1:x2 &
                  t2$y %in% y1:y2,]

   expect_equal(nrow(plot1), 10*20)
   expect_equal(nrow(plot1[plot1$load == 1,]), 10*20)
   expect_equal(colnames(plot1), c("x","y","load"))

})

test_that("create_inf_xyz adds expected plots", {
   plot_sample <- sample(1:30,4)

   t3 <- create_inf_xyz(
      plot_length = 20,
      plot_width = 10,
      paddock_length = 100,
      paddock_width = 100,
      infected_plots = plot_sample,
      n_plots = 15,
      infection_weight = 1
   )

   # plot(t3$x,t3$y)
   # points(t3[t3$load > 0,"x"],
   #        t3[t3$load > 0,"y"],
   #        col = "red",
   #        pch = 15)

   expect_s3_class(t3,class = "data.frame")
   expect_equal(nrow(t3), 100*100)
   expect_equal(colnames(t3), c("x","y","load"))

   # get infected paddock
   ind1 <- min(which(t3$load == 1))
   x1 <- t3[ind1,"x"]
   y1 <- t3[ind1,"y"]
   x2 <- t3[ind1,"x"] + 9
   y2 <- t3[ind1,"y"] + 19

   plot1 <- t3[t3$x %in% x1:x2 &
                  t3$y %in% y1:y2,]

   expect_equal(nrow(plot1), 10*20)
   expect_equal(nrow(plot1[plot1$load == 1,]), 10*20)
   expect_equal(colnames(plot1), c("x","y","load"))

})

test_that("create_inf_xyz can produce layout for 2023 asco trial", {
   treat_n <-
      1 * # varieties
      2 * # infected/non-infected
      3 * # destructive sampling
      3  # fungicide treatments
       # Reps
   Reps <- 5

   plot_n <- treat_n * Reps # reps

   plot_sample <- sample(1:plot_n,treat_n)

   completly_randomised <-
      data.table(treat = rep(1:treat_n, each = Reps),
              plot = sample(1:plot_n,plot_n,replace = FALSE))

   t3 <- create_inf_xyz(
      plot_length = 10,
      plot_width = 4,
      paddock_length = 150,
      paddock_width = 50,
      infected_plots = completly_randomised$plot,
      infection_weight = completly_randomised$treat,
      internal_buffer_adj = 2,
      internal_buffer_end = 2,
      n_plots = plot_n,
      verbose = TRUE
   )

   # 30 cm row spacing
   # singulated planter

   # t3 |>
   #    ggplot(aes(x = x, y = y, fill = as.factor(load)))+
   #    geom_tile()+
   #    xlab("paddock width, (meters)")+
   #    ylab("paddock length, (meters)")+
   #    scale_fill_viridis_d()+
   #    guides(fill=guide_legend(title="Treatment\nnumber"))+
   #    theme_minimal()

   expect_s3_class(t3,class = "data.frame")
   expect_equal(nrow(t3), 150*50)
   expect_equal(colnames(t3), c("x","y","load"))

   # get infected paddock
   ind1 <- min(which(t3$load == 1))
   x1 <- t3[ind1,"x"]
   y1 <- t3[ind1,"y"]
   x2 <- t3[ind1,"x"] + 9
   y2 <- t3[ind1,"y"] + 19

   plot1 <- t3[t3$x %in% x1:x2 &
                  t3$y %in% y1:y2,]

   expect_equal(nrow(plot1), 10*20)
   expect_equal(nrow(plot1[plot1$load == 1,]), 96)
   expect_equal(colnames(plot1), c("x","y","load"))

   # NEED MORE TESTS HERE TO TEST WHEN MULTIPLE INFECTION LOADS ARE USED

})

test_that("create_inf_xyz fails when expected", {
   # expect_error(create_inf_xyz(plot_width = 7),
   #              regexp = "'paddock_width' must be equally divisable by 'plot_width'")
   # expect_error(create_inf_xyz(plot_length = 7),
   #              regexp = "'paddock_length' must be equally divisable by 'plot_length'")
   expect_error(create_inf_xyz(infected_plots =  1:51),
                regexp = "'infected_plots' includes a plot number higher than the number of calculated plots")
   expect_error(create_inf_xyz(n_plots = 51),
                regexp = "'n_plots' can't be larger than total plots")

})

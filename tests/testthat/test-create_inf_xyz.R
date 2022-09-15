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
      infected_plots = c(10,20,30,40,50),
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
   plot_sample <- sample(1:50,4)

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


test_that("create_inf_xyz fails when expected", {
   expect_error(create_inf_xyz(plot_width = 7),
                regexp = "'paddock_width' must be equally divisable by 'plot_width'")
   expect_error(create_inf_xyz(plot_length = 7),
                regexp = "'paddock_length' must be equally divisable by 'plot_length'")
   expect_error(create_inf_xyz(infected_plots =  1:51),
                regexp = "'infected_plots' includes a plot number higher than the number of calculated plots")
   expect_error(create_inf_xyz(n_plots = 51),
                regexp = "'n_plots' can't be larger than total plots")

})

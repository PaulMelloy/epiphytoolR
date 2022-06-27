test_that("mulit_biom examples work", {
   set.seed(7)
   # obtain matrix of probabilities
   mvb <- multi_var_binom()

   expect_type(mvb, "double")
   expect_equal(class(mvb), c("matrix", "array"))
   expect_equal(nrow(mvb),12)
   expect_equal(ncol(mvb),4)
   expect_equal(round(max(mvb),4),0.1592)

   # sample the plant (matrix cell) where the spore may drop
   expect_equal(sample(seq_along(mvb),
          size = 10,
          prob = mvb,
          replace = TRUE),c(20, 20, 32, 7, 19, 6, 32, 21, 32, 32))

   # sample the cardinal coordinates (matrix cell) where the spore may drop

})


test_that("mulit_biom with custom rows and columns", {

   m1 <- matrix(nrow = 100,
                ncol = 100,
                data = rbinom(100*100,1,0.001))

   mvb1 <- multi_var_binom(m = m1)
   expect_equal(dim(mvb1),dim(m1))

})

test_that("exponetial dispersal kernal works", {
   expect_equal(length(exp_dk(r = 0:10)), 11)
   expect_true(class(exp_dk(r = 0:10)) == "numeric")
   expect_equal(
      round(exp_dk(r = 0:10), 6),
      c(
         0.159155,
         0.05855,
         0.021539,
         0.007924,
         0.002915,
         0.001072,
         0.000395,
         0.000145,
         5.3e-05,
         2e-05,
         7e-06
      ),
      tolerance = 0.000001
   )
   expect_equal(
      round(exp_dk(r = 0:10, a = 5), 6),
      c(
         0.006366,
         0.005212,
         0.004267,
         0.003494,
         0.002861,
         0.002342,
         0.001917,
         0.001570,
         0.001285,
         0.001052,
         0.000862
      ),
      tolerance = 0.000001
   )


})

test_that("examples work", {
   set.seed(27)
   expect_equal(
      wind_distance(
         mean_wind_speed = 10,
         wind_cauchy_multiplier = 50
      ),
      44.49151,
      tolerance = 1e-6
   )

   # returns 10 estimates
   expect_equal(
      wind_distance(
         mean_wind_speed = 10,
         wind_cauchy_multiplier = 50,
         PSPH = 10
      ),
      c(134.688982,209.189537,840.813322,419.692484, 1566.393606,115.891326,3.848894,229.730326,
        344.201381, 1309.567139),
      tolerance = 1e-6
   )

   # returns 10 estimates
   expect_equal(
      wind_distance(
         mean_wind_speed = 10,
         wind_cauchy_multiplier = 50,
         PSPH = c(5, 5)
      ), c(255.52000, 57934.86301,138.10040, 204.44751, 397.24601, 25.77647, 146.43586, 1643.64583,
        72.87056, 161.37322),
      tolerance = 1e-2
   )
})

test_that("wind_distance returns an expected range",{
   set.seed(1999)
   expect_equal(mean(wind_distance(10,50,1000)),
                2454.4317, tolerance = 1e-4)
   expect_equal(median(wind_distance(10,50,100000)),
                10*50, tolerance = 5)

})







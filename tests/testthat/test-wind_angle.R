
w_a <- wind_angle(mean_wind_direction = 1,
                  stdev_wind_direction = 30,
                  PSPH =  1)
w_a10 <- wind_angle(mean_wind_direction = 1,
                    stdev_wind_direction = 30,
                    PSPH =  10)

test_that("wind_angle returns a number between 0 and 360", {

  # test that function returns a number below 360
  expect_true(w_a < 360)

  # test that function returns a number above 0
  expect_true(w_a >= 0)
  # add extra comment

})


test_that("wind_angle returns the correct number of elements", {
  # test that the length of w_a == 1
  expect_equal(length(w_a), 1)
  # test that the length of w_a10 == 10
  expect_equal(length(w_a10), 10)
})


test_that("wind_angle returns the correct class", {
  # test the class of output
  expect_true(is.numeric(w_a))
  expect_true(is.vector(w_a))

})

test_that("wind_angle has a minimum standard deviation", {
   # test the class of output
   sd1 <- wind_angle(
      mean_wind_direction = 180,
      stdev_wind_direction = 0.5,
      PSPH =  10000,
      min_stdev = 1
   )
   expect_equal(sd(sd1),1,tolerance = 0.005)
   sd40 <- wind_angle(
      mean_wind_direction = 180,
      stdev_wind_direction = 30,
      PSPH =  10000,
      min_stdev = 40
   )
   expect_equal(sd(sd40),40,tolerance = 0.05)

})

test_that("tests work", {
   # Wind speed strength from a northerly wind
   ws <- 5 # kph
   wd <- 0 # degrees
   expect_equal(ws * circular_influence(wd),ws)

   # Wind speed strength from a north east wind
   wd <- 45 # degrees
   expect_equal(ws * circular_influence(wd),ws * 0.5)

   # Wind speed strength from a south west wind
   wd <-225 # degrees
   expect_equal(ws * circular_influence(wd),ws * -0.5)

})

test_that("vector inputs work", {
   # Wind speed strength from a northerly wind
   ws <- 5 # kph
   wd <- 1:360 # degrees
   expect_length(ws * circular_influence(wd),360)
   expect_equal(sum(ws * circular_influence(wd)),0)
})

test_that("circ_influence stops expectantly", {
   expect_error(circular_influence(361),regexp = "'x' must be a number between 0 and 360")
   expect_error(circular_influence(-1),regexp = "'x' must be a number between 0 and 360")
})

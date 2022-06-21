test_that("circ_influence tests work", {
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

test_that("circ_influence vector inputs work", {
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

test_that("circ_influence offset works", {
   expect_equal(sum(circular_influence(x= 1:360, offset = 10)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 25)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 65)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 90)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 120)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 180)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 200)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 225)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = 290)),0)

   expect_equal(sum(circular_influence(x= 1:360, offset = -10)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = -25)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = -65)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = -90)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = -120)),0)
   expect_equal(sum(circular_influence(x= 1:360, offset = -180)),0)
   #expect_equal(sum(circular_influence(x= 1:360, offset = -200)),0)
   #expect_equal(sum(circular_influence(x= 1:360, offset = -225)),0)
   #expect_equal(sum(circular_influence(x= 1:360, offset = -290)),0)

})

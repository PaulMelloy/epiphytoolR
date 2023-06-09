test_that("circ_influence tests work", {
   # Wind speed strength from a northerly wind
   ws <- 5 # kph
   wd <- 0 # degrees
   expect_equal(ws * circular_influence(wd), c(x = 0,
                                               y = ws))

   # Wind speed strength from a north east wind
   wd <- 45 # degrees
   expect_equal(ws * circular_influence(wd),
                c(x = sin((wd/360) *(2*pi))*ws,
                  y = cos((wd/360) *(2*pi))*ws),
                tolerance = 0.0001
                  )

   # Wind speed strength from a south west wind
   wd <-225 # degrees
   expect_equal(ws * circular_influence(wd),
                c(x = sin((wd/360) *(2*pi))*ws,
                  y = cos((wd/360) *(2*pi))*ws),
                tolerance = 0.0001
   )

})


test_that("circ_influence stops expectantly", {
   expect_error(circular_influence(361),regexp = "'x' must be a number between 0 and 360")
   expect_error(circular_influence(-1),regexp = "'x' must be a number between 0 and 360")
})

test_that("circ_influence offset works", {
   expect_equal(circular_influence(x= 1, offset = 10),
                circular_influence(x= 351),
                tolerance = 0.00001)
   expect_equal(circular_influence(x= 360, offset = 25),
                circular_influence(x= 360 - 25),
                tolerance = 0.00001)

   expect_equal(circular_influence(x= 1, offset = -10),
                circular_influence(x= 11),
                tolerance = 0.00001)
   expect_equal(circular_influence(x= 360, offset = -25),
                circular_influence(x= 0 + 25),
                tolerance = 0.00001)

})

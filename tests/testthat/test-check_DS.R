# This function should check the time quality of a vector of times
w1 <-
   fread(system.file("extdata", "naddacs_weather.csv", package = "epiphytoolR"))
w1[,Local.Time := lubridate::with_tz(Local.Time,tzone = "Australia/Adelaide")]
w1[,Local.Time := c(seq(from = w1$Local.Time[1],
                      to = w1$Local.Time[.N],
                      by = 3600))]
unique(format(w1[,Local.Time], format = "%Z"))
fwrite(w1, file = "inst/extdata/naddacs_weather.csv")

#### Delete after testing
#x <- w1$Local.Time
####

test_that("check_DS errors on inappropriate input", {
   expect_error(check_DS(as.character(w1$Local.Time)),
                regexp = "Please provide POSIXct formatted time")


})

test_that("check_DS returns expected output to simple inputs", {
   expect_equal(w1$Local.Time[100:200],
                check_DS(w1$Local.Time[100:200]))
   expect_equal(seq(from = w1$Local.Time[1],
                    to = w1$Local.Time[length(w1$Local.Time)] + 3600, # add an hour for the duplicated hour
                    by = 3600), # one hour in seconds
                check_DS(w1$Local.Time))
   expect_s3_class(check_DS(w1$Local.Time),"POSIXct")
})


test_that("time vectors with no Daylight savings shift from non-DS location returns input vector",{
   tv1 <- seq(
      from = as.POSIXct("2020-12-25 01:00:00"),
      to = as.POSIXct("2021-12-25 01:00:00"),
      by = 3600
   )
   expect_equal(check_DS(tv1, time_zone = "Australia/Brisbane"),
                lubridate::with_tz(tv1, tzone = "UTC"))

})

test_that("time vectors with no Daylight savings shift from DS location returns UTC vector",{
   tv2 <- seq(
      from = as.POSIXct("2020-12-25 01:00:00"),
      to = as.POSIXct("2021-12-25 01:00:00"),
      by = 3600
   )

   expect_equal(check_DS(tv2, time_zone = "Australia/Sydney"),
                lubridate::with_tz(
                   lubridate::with_tz(tv2, tzone = "Australia/Sydney"),
                   tzone = "UTC"))
   expect_equal(check_DS(tv2, time_zone = "Australia/Adelaide"),
                lubridate::with_tz(
                   lubridate::with_tz(tv2, tzone = "Australia/Adelaide"),
                   tzone = "UTC"))

})

test_that("time vectors with Daylight savings shift returns a UTC time with
          continuity",{
   tv3 <- seq(
      from = as.POSIXct("2020-12-25 01:00:00"),
      to = as.POSIXct("2021-12-25 01:00:00"),
      by = 3600
   )
   tv3 <- lubridate::force_tz(tv3, "Australia/Sydney")
   any(is.na(tv3))

   expect_equal(check_DS(tv3, time_zone = "Australia/Sydney"),
                lubridate::with_tz(
                   lubridate::with_tz(tv2, tzone = "Australia/Sydney"),
                   tzone = "UTC"))

})

# This function should check the time quality of a vector of times
w1 <-
   fread(system.file("extdata", "scaddan_weather.csv", package = "epiphytoolR"))

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

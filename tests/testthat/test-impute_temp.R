test_that("example works", {
   set.seed(111)
   weather[round(rnorm(50,
                        mean = nrow(weather)/2,
                     sd = nrow(weather)/10)),
         temp := NA_real_]
   expect_true(any(is.na(weather[,temp])))

   w2 <- impute_temp(weather)

   expect_false(any(is.na(w2[,temp])))
   expect_s3_class(w2,"epiphy.weather")

})
# no rh in weather
# test_that("example works", {
#    set.seed(111)
#    weather[round(rnorm(50,
#                        mean = nrow(weather)/2,
#                        sd = nrow(weather)/10)),
#            rh := NA_real_]
#    expect_true(any(is.na(weather[,rh])))
#
#    w2 <- impute_rh(weather)
#
#    expect_false(any(is.na(w2[,rh])))
#    expect_s3_class(w2,"epiphy.weather")
#
# })

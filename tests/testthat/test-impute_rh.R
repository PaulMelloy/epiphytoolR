# The bundled `weather` dataset has no relative humidity values, so a synthetic
#  diurnal `rh` series is created here to exercise impute_rh().

test_that("impute_rh fills scattered NA relative humidity", {
   set.seed(111)
   w <- data.table::copy(weather)
   # build a realistic diurnal rh series (weather$rh is all NA)
   w[, rh := impute_diurnal(h = data.table::hour(times),
                            max_obs = 95, min_obs = 45)]
   data.table::setattr(w, "class", union("epiphy.weather", class(w)))

   # knock out scattered values
   w[round(rnorm(50, mean = nrow(w) / 2, sd = nrow(w) / 10)),
     rh := NA_real_]
   expect_true(any(is.na(w[, rh])))

   w2 <- impute_rh(w)

   expect_false(any(is.na(w2[, rh])))
   expect_s3_class(w2, "epiphy.weather")
   # imputed values should remain within a plausible humidity range
   expect_true(all(w2[, rh] >= 0 & w2[, rh] <= 100))
})

test_that("impute_rh returns unchanged data with a message when no NAs", {
   w <- data.table::copy(weather)
   w[, rh := 80]
   data.table::setattr(w, "class", union("epiphy.weather", class(w)))

   expect_message(w2 <- impute_rh(w), "No NA relative humidity")
   expect_false(any(is.na(w2[, rh])))
})

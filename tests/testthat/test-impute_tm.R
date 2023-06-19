test_that("returns expected values", {
   expect_equal(length(impute_tm()),24)
   expect_equal(max(impute_tm(max_tm = 28)),28)
   expect_equal(min(impute_tm(min_tm = 8)),8)

})

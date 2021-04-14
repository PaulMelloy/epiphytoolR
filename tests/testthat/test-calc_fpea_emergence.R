test_that("formula generates expected output", {
   # Can calculate with one number
   expect_equal(calc_fpea_emergence("2021-03-26"), 150.77)

   # Can calculate with many
   expect_equal(round(calc_fpea_emergence(c("2021-03-13",
                                            "2021-03-14",
                                            "2021-03-15")),4),
                c(101.5663, 105.601, 109.5941))
   })

test_that("formula works with negative numbers ", {
   # Can calculate with one number
   expect_equal(calc_fpea_emergence("2021-03-01"), 49.902653)
})

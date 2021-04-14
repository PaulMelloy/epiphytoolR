test_that("formula generates expected output", {
   # Can calculate with one number
   expect_equal(calc_fpea_emergence(14), 150.77)

   # Can calculate with many
   expect_equal(round(calc_fpea_emergence(1:14),4),
                c(101.5663, 105.601, 109.5941, 113.5455, 117.4553,
                  121.3235, 125.15, 128.9349, 132.6782, 136.3798,
                  140.0398, 143.6582, 147.2349, 150.77))
})

test_that("formula works with negative numbers ", {
   # Can calculate with one number
   expect_equal(calc_fpea_emergence(-1), 93.37204)

   # Can calculate with many
   expect_equal(round(calc_fpea_emergence(-1:-14),4),
                c(93.372, 89.2124, 85.0112, 80.7684, 76.4839, 72.1578,
                  67.79, 63.3806, 58.9296, 54.4369, 49.9027, 45.3267,
                  40.7092, 36.05))
})

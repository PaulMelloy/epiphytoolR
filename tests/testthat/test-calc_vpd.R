test_that("calc_vpd returns expected output", {
  expect_equal(calc_vpd(RH = 90, Tm = 26), 0.336047,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 96,18.8), 0.0867813,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 70,
                         Tm = 20), 0.7012911,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 38.6,
                         Tm = 30), 2.604469,tolerance = 1e-06)
})

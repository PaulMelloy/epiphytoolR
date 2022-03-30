test_that("calc_vpd returns expected output (Murray)", {
  expect_equal(calc_vpd(RH = 90, Tm = 26, eq = "Murray"), 0.336047,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 96,18.8, eq = "Murray"), 0.0867813,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 70,
                         Tm = 20, eq = "Murray"), 0.7012911,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 38.6,
                         Tm = 30, eq = "Murray"), 2.604469,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 50,
                         Tm = 25, eq = "Murray"),
                calc_svp(25, eq = "Murray")- calc_vp(50,25, eq = "Murray"),tolerance = 1e-06)
})

test_that("calc_vpd returns expected output (BOM)", {
   expect_equal(calc_vpd(RH = 90, Tm = 26), 0.3361251,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 96,18.8), 0.08680138,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 70,
                         Tm = 20), 0.7014535,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 38.6,
                         Tm = 30), 2.605075,tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 50,
                         Tm = 25), calc_svp(25)- calc_vp(50,25))
})

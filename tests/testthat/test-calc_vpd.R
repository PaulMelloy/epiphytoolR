test_that("calc_vpd returns expected output (Murray)", {
  expect_equal(calc_vpd(RH = 90, Tm = 26, eq = "Murray"),
               units::set_units(0.336047, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 96,18.8, eq = "Murray"),
                units::set_units(0.0867813, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 70,
                         Tm = 20, eq = "Murray"),
                units::set_units(0.7012911, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 38.6,
                         Tm = 30, eq = "Murray"),
                units::set_units(2.604469, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 50,
                         Tm = 25, eq = "Murray"),
                calc_svp(25, eq = "Murray")- calc_vp(50,25, eq = "Murray"),tolerance = 1e-06)
})

test_that("calc_vpd returns expected output (BOM)", {
   expect_equal(calc_vpd(RH = 90, Tm = 26),
                units::set_units(0.3361251, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 96,18.8),
                units::set_units(0.08680138, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 70,
                         Tm = 20),
                units::set_units(0.7014535, "kPa"),tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 38.6,
                         Tm = 30),
                units::set_units(2.605075, "kPa"),
                tolerance = 1e-06)
   expect_equal(calc_vpd(RH = 50,
                         Tm = 25), calc_svp(25)- calc_vp(50,25))
})

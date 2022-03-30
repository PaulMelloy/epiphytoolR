test_that("calc_svp returns expected output (Murray)", {
   expect_equal(calc_svp(25, eq = "Murray"),
                units::set_units(3.166871, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(18.8, eq = "Murray"),
                units::set_units(2.169533, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(Tm = 20, eq = "Murray"),
                calc_vpd(RH = 100, Tm = 20, eq = "Murray") +
                   calc_vp(RH = 100, Tm = 20, eq = "Murray"))
   expect_equal(calc_svp(Tm = 25, eq = "Sapak"),
                units::set_units(3.766752e+28, "kPa"),tolerance = 1e-06)
})

test_that("calc_svp returns expected output (BOM)", {
   expect_equal(calc_svp(25),
                units::set_units(3.167606, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(18.8),
                units::set_units(2.170035, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(Tm = 20),
                calc_vpd(RH = 100, Tm = 20) +
                   calc_vp(RH = 100, Tm = 20))
})

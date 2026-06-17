test_that("calc_svp returns expected output (Murray)", {
   expect_equal(calc_svp(25, eq = "Murray"),
                units::set_units(3.166871, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(18.8, eq = "Murray"),
                units::set_units(2.169533, "kPa"),tolerance = 1e-06)
   expect_equal(calc_svp(Tm = 20, eq = "Murray"),
                calc_vpd(RH = 100, Tm = 20, eq = "Murray") +
                   calc_vp(RH = 100, Tm = 20, eq = "Murray"))
   expect_equal(calc_svp(Tm = 25, eq = "Tetens"),
                units::set_units(3.167674, "kPa"),tolerance = 1e-06)
   # "Sapak" is a deprecated alias of "Tetens" and returns the same value
   expect_equal(calc_svp(Tm = 25, eq = "Sapak"),
                calc_svp(Tm = 25, eq = "Tetens"))
   # unrecognised equations error
   expect_error(calc_svp(Tm = 25, eq = "nonsense"),
                regexp = "'eq' must be one of")
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

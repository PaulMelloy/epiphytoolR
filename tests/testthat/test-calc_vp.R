test_that("calc_vp returns expected output (Murray)", {
   expect_equal(calc_vp(RH = 90, Tm = 26, eq = "Murray"),
                units::set_units(3.024423, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 96, 18.8, eq = "Murray"),
                units::set_units(2.082751, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 70,
                        Tm = 20, eq = "Murray"),
                units::set_units(1.636346, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6,
                        Tm = 30, eq = "Murray"),
                units::set_units(1.637337, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6, Tm = 25, eq = "Sapak"),
                units::set_units(1.453966e+28, "kPa"),
                tolerance = 1e-06)
   expect_equal(
      calc_vp(RH = 50,
              Tm = 25, eq = "Murray"),
      calc_svp(25, eq = "Murray") -
         calc_vpd(50, 25, eq = "Murray"),
      tolerance = 1e-06
   )

})

test_that("calc_vp returns expected output (BOM)", {
   expect_equal(calc_vp(RH = 90, Tm = 26),
                units::set_units(3.025126, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 96, 18.8),
                units::set_units(2.083233, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 70,
                        Tm = 20),
                units::set_units(1.636725, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6,
                        Tm = 30),
                units::set_units(1.637718, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(RH = 50,
                        Tm = 25),
                calc_svp(25) - calc_vpd(50, 25))

})

test_that("calc_vp can calculate from dew point (BOM)", {
   expect_equal(calc_vp(dp = 10),
                units::set_units(1.227935, "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(dp = 18),
                units::set_units(2.063907 , "kPa"), tolerance = 1e-06)
   expect_equal(calc_vp(dp = 25),
                units::set_units(3.167606 , "kPa"), tolerance = 1e-06)
   expect_message(calc_vp(RH = 38.6,
                          Tm = 30,
                          dp = 5),
                  regexp = "Ignoring RH or Tm inputs and calculating vp from dew point")

})

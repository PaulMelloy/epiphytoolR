test_that("calc_vp returns expected output (Murray)", {
   expect_equal(calc_vp(RH = 90, Tm = 26, eq = "Murray"), 3.024423, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 96, 18.8, eq = "Murray"), 2.082751, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 70,
                        Tm = 20, eq = "Murray"), 1.636346, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6,
                        Tm = 30, eq = "Murray"), 1.637337, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6, Tm = 25, eq = "Sapak"),
                1.453966e+28,
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
   expect_equal(calc_vp(RH = 90, Tm = 26), 3.025126, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 96, 18.8), 2.083233, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 70,
                        Tm = 20), 1.636725, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6,
                        Tm = 30), 1.637718, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 50,
                        Tm = 25),
                calc_svp(25) - calc_vpd(50, 25))

})

test_that("calc_vp can calculate from dew point (BOM)", {
   expect_equal(calc_vp(RH = 90, Tm = 26), 3.025126, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 96, 18.8), 2.083233, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 70,
                        Tm = 20), 1.636725, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 38.6,
                        Tm = 30), 1.637718, tolerance = 1e-06)
   expect_equal(calc_vp(RH = 50,
                        Tm = 25),
                calc_svp(25) - calc_vpd(50, 25))

})

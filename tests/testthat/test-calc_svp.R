test_that("calc_spd returns expected output", {
   expect_equal(calc_svp(25), 3.166871,tolerance = 1e-06)
   expect_equal(calc_svp(18.8), 2.169533,tolerance = 1e-06)
   expect_equal(calc_svp(Tm = 20),
                calc_vpd(RH = 100, Tm = 20) +
                   calc_vp(RH = 100, Tm = 20),tolerance = 1e-06)
   expect_equal(calc_svp(Tm = 25, eq = "Sapak"), 3.766752e+28,tolerance = 1e-06)
})

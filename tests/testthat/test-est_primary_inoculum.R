test_that("function works", {
  expect_equal(est_primary_inoculum(150, 0), 3.297)
   expect_equal(est_primary_inoculum(250, 15), 7.17275)
   expect_equal(est_primary_inoculum(150, 15), 4.97475)
   expect_equal(est_primary_inoculum(150, 0.2), 3.31937)


})

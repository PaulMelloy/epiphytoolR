test_that("function works", {
  expect_equal(DIV(70, 11, rainfall = 0.2), 0.5661232,tolerance = 0.000001)
   expect_equal(DIV(70, 20, rainfall = 0.2), 1,tolerance = 0.000001)
   expect_equal(DIV(70, 11, rainfall = 0), 0.3745739,tolerance = 0.000001)
   expect_equal(DIV(69, 11, rainfall = 0), 0,tolerance = 0.000001)
})

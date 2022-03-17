test_that("formula works", {
   expect_warning(expect_equal(round(disease_aug_soil(50),6), 0.511935))
   expect_warning(expect_equal(round(disease_aug_soil(500),6), 0.938405))
})

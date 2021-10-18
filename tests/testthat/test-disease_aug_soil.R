test_that("formula works", {
   expect_equal(disease_aug_soil(50), 0.50823901)
   expect_equal(disease_aug_soil(500), 0.93803224)
})

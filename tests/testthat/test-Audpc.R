test_that("Audpc returns without NA", {

   dates <- c(14,21,28,32,39,41,50) # days
   evaluation <- c(1,2,4,15,40,80,90)

   expect_equal(Audpc(evaluation,dates),
                agricolae::audpc(evaluation,dates))

   # add NA values
   evaluatioNA <- c(1,2,4,NA_integer_,40,80,90)

   expect_equal(Audpc(evaluatioNA,dates, na.rm = TRUE),
                as.numeric(agricolae::audpc(evaluatioNA[-4],dates[-4])))

   # if NA is at the start or end of vector it will return NA
   dates <- c(14,21,28,32,39,41,NA) # days
   expect_equal(Audpc(evaluation,dates),NA_real_)

})

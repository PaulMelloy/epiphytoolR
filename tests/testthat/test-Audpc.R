test_that("Audpc returns without NA", {

   dates <- c(14,21,28,32,39,41,50) # days
   evaluation <- c(1,2,4,15,40,80,90)

   expect_equal(Audpc(evaluation,dates),
                agricolae::audpc(evaluation,dates))

   # add NA values
   evaluatioNA <- c(1,2,4,NA_integer_,40,80,90)

   expect_equal(Audpc(evaluatioNA,dates, na.rm = TRUE),
                as.numeric(agricolae::audpc(evaluatioNA[-4],dates[-4])))
   dates <- c(14,21,28,NA_integer_,39,41,50) # days
   expect_equal(Audpc(evaluatioNA,dates, na.rm = TRUE),
                as.numeric(agricolae::audpc(evaluatioNA[-4],dates[-4])))

   # if NA is at the start or end of vector it will return NA
   dates <- c(14,21,28,32,39,41,NA) # days
   expect_equal(Audpc(evaluation,dates),NA_real_)

})
test_that("Audpc works with table format", {

   dates <- c(14,21,28,32,39,41,50) # days
   evaluation <- rbind(1,2,4,15,40,80,90)

   expect_error(Audpc(evaluation,dates),
                regexp = "The number of dates of evaluation")

})
test_that("Audpc 'relative' returns without NA", {

   dates <- c(14,21,28,32,39,41,50) # days
   evaluation <- c(1,2,4,15,40,80,90)

   expect_equal(Audpc(evaluation,dates,type = "relative"),
                agricolae::audpc(evaluation,dates,type = "relative"))

   # add NA values
   evaluatioNA <- c(1,2,4,NA_integer_,40,80,90)

   expect_equal(Audpc(evaluatioNA,dates, na.rm = TRUE,type = "relative"),
                as.numeric(agricolae::audpc(evaluatioNA[-4],dates[-4],type = "relative")))

   # if NA is at the start or end of vector it will return NA
   dates <- c(14,21,28,32,39,41,NA) # days
   expect_equal(Audpc(evaluation,dates,type = "relative"),NA_real_)

})

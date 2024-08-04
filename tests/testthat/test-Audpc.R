test_that("Audpc remove NAs as described", {
   # see examples in help(agricolae::audpc)
   dates<-c(14,21,28,35) # days
   # example 1: evaluation - vector
   evaluation<-c(40,80,90,95)
   expect_equal(Audpc(evaluation,dates),agricolae::audpc(evaluation,dates))
   dates<-c(14,21,NA,35) # days
   expect_equal(Audpc(evaluation,dates),agricolae::audpc(evaluation,dates))

   Audpc(evaluation,dates)
   Audpc(evaluation,dates,na.rm = TRUE)
   # agricolae::audpc(evaluation,dates)
   dates<-c(14,21,28) # days
   evaluation<-c(40,80,NA)
   Audpc(evaluation,dates)
   Audpc(evaluation,dates,na.rm = TRUE)
   # agricolae::audpc(evaluation,dates)
})

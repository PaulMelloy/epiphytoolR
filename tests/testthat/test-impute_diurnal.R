test_that("small then large as returns expected values", {
   expect_equal(length(impute_diurnal()),24)
   expect_equal(max(impute_diurnal(min_obs = 11, max_obs = 28)),28)
   expect_equal(min(impute_diurnal(min_obs = 8)),8)

   expect_equal(impute_diurnal(min_obs = 10,max_obs = 28,
                               max_hour = 14, min_hour = 5),
                c(12.97783,11.71885,10.7781,10.19667,10,10.54276,
                              12.10559,14.49998,17.43715,20.56281,23.49998,
                              25.89439,27.45723,28,27.80333,27.22191,26.28116,
                              25.02218,23.50001,21.78116,19.94077,18.05925,
                              16.21886,14.50001),
                tolerance = 0.00001)

   expect_equal(impute_diurnal(0:23,
                               min_obs = 10,max_obs = 28,
                               max_hour = 14, min_hour = 5),
                c(14.50001,12.97783,11.71885,10.7781,10.19667,10,10.54276,
                              12.10559,14.49998,17.43715,20.56281,23.49998,
                              25.89439,27.45723,28,27.80333,27.22191,26.28116,
                              25.02218,23.50001,21.78116,19.94077,18.05925,
                              16.21886),
                tolerance = 0.00001)

   # Test time input
   t_v <- seq(as.POSIXct("2023-07-07 01:00:00"),
              as.POSIXct("2023-07-08"),
              by = "hours")

   expect_equal(impute_diurnal(t_v,min_obs = 10,max_obs = 28,
                               max_hour = 14, min_hour = 5),c(12.97783,11.71885,10.7781,10.19667,10,10.54276,
                              12.10559,14.49998,17.43715,20.56281,23.49998,
                              25.89439,27.45723,28,27.80333,27.22191,26.28116,
                              25.02218,23.50001,21.78116,19.94077,18.05925,
                              16.21886,14.50001),tolerance = 0.000001)

})

test_that("large then small as returns expected values", {
   expect_equal(length(impute_diurnal()),24)
   expect_equal(max(impute_diurnal(min_obs = 45, max_obs = 99)),99)
   expect_equal(min(impute_diurnal(min_obs = 45)),45)
   expect_equal(which(round(impute_diurnal(max_hour = 6, max_obs = 99)) == 99),6)
   expect_equal(which(round(impute_diurnal(max_hour = 6,min_hour = 14, min_obs = 45),1) == 45),14)

   expect_equal(impute_diurnal(min_obs = 45,max_obs = 99,
                               max_hour = 6, min_hour = 14),
                c(87.00034,91.09183,94.44964,96.94472,
                  98.48119,99,96.94475,91.0919,
                  82.33248,72.00003,61.66758,52.90814,
                  47.05527,45,45.51879,47.05523,
                  49.55029,52.90808,56.99956,61.66749,
                  66.7325,71.99994,77.26738,82.33239),
                tolerance = 0.00001)

   expect_equal(impute_diurnal(0:23,
                               min_obs = 45,max_obs = 99,
                                max_hour = 6, min_hour = 14),
                c(82.33239,
                  87.00034,91.09183,94.44964,96.94472,
                  98.48119,99,96.94475,91.0919,
                  82.33248,72.00003,61.66758,52.90814,
                  47.05527,45,45.51879,47.05523,
                  49.55029,52.90808,56.99956,61.66749,
                  66.7325,71.99994,77.26738),
                tolerance = 0.00001)

   # Test time input
   t_v <- seq(as.POSIXct("2023-07-07 01:00:00"),
              as.POSIXct("2023-07-08"),
              by = "hours")

   expect_equal(impute_diurnal(t_v,min_obs = 10,max_obs = 28,
                               max_hour = 14, min_hour = 5),c(12.97783,11.71885,10.7781,10.19667,10,10.54276,
                                                              12.10559,14.49998,17.43715,20.56281,23.49998,
                                                              25.89439,27.45723,28,27.80333,27.22191,26.28116,
                                                              25.02218,23.50001,21.78116,19.94077,18.05925,
                                                              16.21886,14.50001),tolerance = 0.000001)

})

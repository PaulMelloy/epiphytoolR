# Mock up data.set

set.seed(753)
for(i in 1:10) {
   dat <- data.table(
      station_name = paste0("w_STATION", i),
      lat = -runif(1, 15.5, 28),
      lon = runif(1, 115, 150),
      state = "SA",
      yearday = 1:365,
      max_temp = runif(365,18,35),
      min_temp = runif(365,1,17.9),
      wd_rw = abs(rnorm(365, 180, 90)),
      wd_sd_rw = rnorm(365, 80, 20),
      ws_rw = runif(365, 1, 60),
      ws_sd_rw = abs(rnorm(365, 10, sd = 5)),
      rain_freq = runif(365, 0.05, 0.45)
   )
   if (i == 1) {
      test_dat <- dat
   } else{
      test_dat <- rbind(test_dat, dat)
   }
}

for(i in 1:10) {
   dat2 <- data.table(
      station_name = paste0("w_STATION", i),
      lat = -runif(1, 15.5, 28),
      lon = runif(1, 115, 150),
      state = "SA",
      yearday = 1:365,
      wd_rw = abs(rnorm(365, 180, 90)),
      wd_sd_rw = rnorm(365, 80, 20),
      ws_rw = runif(365, 1, 60),
      ws_sd_rw = abs(rnorm(365, 10, sd = 5)),
      rain_freq = runif(365, 0.05, 0.45)
   )
   if (i == 1) {
      test_dat2 <- dat2
   } else{
      test_dat2 <- rbind(test_dat2, dat2)
   }
}

test_that("calc_estimated_weather example works", {

   # one station
   out1 <- calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1)
   expect_s3_class(out1, "data.table")
   expect_s3_class(out1$times, "POSIXct")
   expect_equal(dim(out1),c((24*334)+1,25))
   expect_true(all(c("times","temp","rain","rh","ws","wd","wd_sd","lon","lat","station","YYYY",
                     "MM","DD","hh","mm") %in% colnames(out1)))

})

test_that("calc_estimated_weather example works", {

   # four station
   out2 <- calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1:4)
   expect_s3_class(out2, "data.table")
   expect_s3_class(out2$times, "POSIXct")
   expect_equal(nrow(out2[station == "w_STATION5"]),c((24*334)+1))
   expect_equal(dim(out2),c((24*334*4)+4,25))
   expect_equal(length(out2[, unique(station)]),4)

   expect_true(all(c("times","temp","rain","ws","wd","wd_sd","lon","lat","station","YYYY",
                     "MM","DD","hh","mm") %in% colnames(out2)))

})

test_that("format_weather can format it",{
   out1 <- calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1)
   out2 <- calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1:4)

   out1$rh <- runif(nrow(out1),min = 50, max = 100)
   out2$rh <- runif(nrow(out2),min = 50, max = 100)

   expect_no_warning(format_weather(w = out1, time_zone = "UTC"))
   expect_no_warning(format_weather(w = out2,time_zone = "UTC"))

   expect_s3_class(out1, "epiphy.weather")
   expect_s3_class(out2, "epiphy.weather")


})

test_that("Warnings for no temperature",{
   expect_warning(
   out1 <- calc_estimated_weather(w = test_dat2,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  lat = mean(test_dat$lat),
                                  lon = mean(test_dat$lon),
                                  n_stations = 1),
   regexp = "'max_temp' and 'min_temp' not detected, returning NAs for mean daily 'temp'")
})


test_that("formats for multiple stations when lat and long not provided",{
   expect_no_error(calc_estimated_weather(w = test_dat,
                                  start_date = "2023-01-10",
                                  end_date = "2023-12-10",
                                  na.rm = TRUE))
})

### temperature is taken as a preference

# set.seed(753)
# for(i in 1:10) {
#    dat <- data.table(
#       station_name = paste0("w_STATION", i),
#       lat = runif(1, 15.5, 28),
#       lon = -runif(1, 115, 150),
#       state = "SA",
#       yearday = 1:365,
#       temp = replicate(365,
#                        mean(impute_diurnal(max_obs = runif(1,20,35),
#                                            min_obs = runif(1,-4,20),
#                                            max_hour = 14,min_hour = round(runif(1,3,6))
#                        ))),
#       rh = replicate(365,
#                      mean(impute_diurnal(max_obs = runif(1,75,100),
#                                          min_obs = runif(1,30,75))
#                      )),
#       wd_rw = abs(rnorm(365, 180, 90)),
#       wd_sd_rw = rnorm(365, 80, 20),
#       ws_rw = runif(365, 1, 60),
#       ws_sd_rw = abs(rnorm(365, 10, sd = 5)),
#       rain_freq = runif(365, 0.05, 0.45)
#    )
#    if (i == 1) {
#       test_dat <- dat
#    } else{
#       test_dat <- rbind(test_dat, dat)
#    }
# }








#### ADD TESTS FOR WARNINGS

# test_that("Warnings for no temperature",{
#    d2 <- fread("../validate_blackspot_risk/cache/BOM_weather_station_coefs.csv")
#    out1 <- calc_estimated_weather(w = d2,
#                                    lat = -33.8763,
#                                    lon = 136,
#                                    n_stations = 1:150,
#                                    na.rm = TRUE)
#
#    out1$rh <- runif(nrow(out1),min = 50, max = 100)
#
#    out2 <- format_weather(out1, time_zone = "UTC")
#
#    expect_warning(calc_estimated_weather(w = d2,
#                                      start_date = "2023-01-10",
#                                      end_date = "2023-12-10",
#                                      lat = mean(test_dat$lat),
#                                      lon = mean(test_dat$lon),
#                                      n_stations = 1),
#       regexp = "'max_temp' and 'min_temp' not detected, returning NAs for mean daily 'temp'")
# })



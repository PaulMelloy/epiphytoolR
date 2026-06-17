test_that("fill_time_gaps fills gaps in an hourly time series", {
   times <- seq(as.POSIXct("2024-01-01 00:00:00", tz = "UTC"),
                by = "hour", length.out = 24)
   # drop a 5-hour block to create a gap
   times_gappy <- times[-(10:14)]
   dat <- data.table::data.table(
      time = times_gappy,
      station = "A",
      value = seq_along(times_gappy))

   filled <- fill_time_gaps(dat, "time")

   expect_s3_class(filled, "data.table")
   # the missing rows are added back
   expect_equal(nrow(filled), length(times))
   # times are now continuous at the hourly (3600 s) interval
   expect_true(all(diff(as.numeric(filled$time)) == 3600))
   # single-value columns are carried into the new rows
   expect_true(all(filled$station == "A"))
})

test_that("fill_time_gaps errors when times are not in UTC", {
   times <- as.POSIXct("2024-01-01 00:00:00", tz = "Australia/Brisbane") +
      (0:5) * 3600
   dat <- data.table::data.table(time = times, station = "A")

   expect_error(fill_time_gaps(dat, "time"), regexp = "convert time to UTC")
})

test_that("fill_time_gaps leaves continuous data unchanged", {
   times <- seq(as.POSIXct("2024-01-01 00:00:00", tz = "UTC"),
                by = "hour", length.out = 24)
   dat <- data.table::data.table(time = times, station = "A")

   filled <- fill_time_gaps(dat, "time")
   expect_equal(nrow(filled), length(times))
})

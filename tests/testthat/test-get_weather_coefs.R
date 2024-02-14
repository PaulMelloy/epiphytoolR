#raw_bom_file <- system.file("/extdata/bom_data.csv",package = "epiphytoolR")
temp_bom_file <- tempfile(fileext = ".csv")
fwrite(make_bom_data(),file = temp_bom_file)
bom_meta <- data.table::fread(system.file("/extdata/bom_meta.csv",package = "epiphytoolR"))
test_that("Function returns data.table with correct columns", {
   # Assuming you have a sample raw BOM file and meta_data to use for testing

   result <- get_weather_coefs(
      raw_bom_file = temp_bom_file,
      rolling_window = 30,
      meta_data = bom_meta
   )
   expected_columns <- c("station_name", "lat", "lon", "state",
                         "yearday", "min_temp", "max_temp", "temp", "rh",
                         "wd_rw", "wd_sd_rw", "ws_rw", "ws_sd_rw", "rain_freq")
   expect_true(all(expected_columns %in% names(result)))
})

test_that("Function handles non-existent file gracefully", {

   expect_error(get_weather_coefs(
      raw_bom_file = "non_existent_file.txt",
      rolling_window = 30,
      meta_data = bom_meta
   ))
})
temp_bom_file2 <- tempfile(fileext = ".csv")
test_that("Function returns NULL for dataset without rain data", {
   fwrite(fread(temp_bom_file)[,`Precipitation since last (AWS) observation in mm` := NA_real_],
          temp_bom_file2)

   result <- suppressWarnings({get_weather_coefs(
      raw_bom_file = temp_bom_file2,
      rolling_window = 30,
      meta_data = bom_meta
   )})
   expect_null(result)
})

test_that("Rainfall NA fill works as expected", {
   # You need a sample file with some NA values in the rain column
   fwrite(fread(temp_bom_file)[sample(1:.N,size = round(.N/3)),
                  `Precipitation since last (AWS) observation in mm` := NA_real_],
          temp_bom_file2)

   result_mean <- get_weather_coefs(
      raw_bom_file = temp_bom_file2,
      rolling_window = 30,
      meta_data = bom_meta,
      rainfall_na_fill = "mean"
   )
   # Check if NA values in rain_day column are filled appropriately
   # This requires inspecting the data and ensuring NA values are handled as described
   expect_true(all(!is.na(result_mean$rain_freq)))
})

test_that("Invalid rolling_window values are handled", {
   expect_error(get_weather_coefs(
      raw_bom_file = temp_bom_file,
      rolling_window = -10, # Invalid rolling window size
      meta_data = bom_meta
   ))
})

test_that("detects multiple station numbers in metadata", {
   bom_meta2 <- rbind(bom_meta,bom_meta[station_name == "ATLANTIS"])
   expect_error(get_weather_coefs(
      raw_bom_file = temp_bom_file,
      rolling_window = -10, # Invalid rolling window size
      meta_data = bom_meta2
   ))
})

# Add more tests as needed to cover other scenarios and edge cases.


# new_meta <- rbind(bom_meta,
#       data.table(recorder = "st",
#                     station_number = 90666,
#                     district_code = 27,
#                     station_name = "ATLANTIS",
#                     opened = "01/2019",
#                     closed = "",
#                     lat = -25.123,
#                     lon = 142.123,
#                     pos_method = "GPS",
#                     state = "QLD",
#                     stat_height = 12.3,
#                     barom_height = 12.7,
#                     WMO_number = 94166,
#                     first_year = 2019,
#                     last_year= 2022,
#                     percent_complete = 100,
#                     percent_Y = 100,
#                     percent_N = "*",
#                     percent_W = 0,
#                     percent_S = "*",
#                  percent_I = "*",
#                  end_line = "#"))
# fwrite(new_meta,"inst/extdata/bom_meta.csv")

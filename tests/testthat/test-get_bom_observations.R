# These tests require network access and external data hosts. They are skipped
#  on CRAN and when offline, and skip gracefully (rather than erroring) when a
#  remote resource is unavailable.

# Helper: download a file, skipping the calling test if it cannot be retrieved
download_or_skip <- function(url, destfile) {
   testthat::skip_on_cran()
   testthat::skip_if_offline()
   ok <- tryCatch(
      suppressWarnings(
         utils::download.file(url, destfile = destfile, quiet = TRUE, mode = "wb")
      ),
      error = function(e) 1L
   )
   if (!identical(as.integer(ok), 0L) ||
       !file.exists(destfile) ||
       file.size(destfile) == 0) {
      testthat::skip(paste("resource unavailable:", url))
   }
}

test_that("get_bom_observations works", {
   skip_on_cran()
   skip_if_offline()
   expect_no_error({
      dl_location <- tempdir()
      suppressMessages({
         dl_loc <-
            get_bom_observations(
               ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
               download_location = dl_location,
               access_warning = FALSE
            )
      })
   })
})


test_that("merge_axf_weather works", {
   tmp_dir <- tempdir()
   wethr_dl <- tempfile("IDQ60910_", fileext = ".tgz", tmpdir = tmp_dir)
   download_or_skip(
      "https://filedn.eu/lKw35gljYV2BIxxlGg9SUJb/weather/tgz/240825_0750_IDQ60910.tgz",
      wethr_dl)

   expect_warning(
      merge_weather(File_compressed = wethr_dl,
                    station_file = "IDQ60910.99123.axf",
                    File_formatted = "NTamborine.csv",
                    base_dir = getwd()),
     "NTamborine.csv not found, creating new file"
     )
  # clean up
  file.remove("NTamborine.csv")
})


test_that("read_bom_json works", {
   tmp_dir <- tempdir()
   wethr_dl <- tempfile("RenmarkWeather_json_", fileext = ".tgz", tmpdir = tmp_dir)
   download_or_skip(
      "https://filedn.eu/lKw35gljYV2BIxxlGg9SUJb/weather/RenmarkWeather_json.tgz",
      wethr_dl)

   untar(tarfile = wethr_dl, exdir = tmp_dir)
   renmark_weather <- list.files(tmp_dir,
                                 pattern = "DS60910.95687.json",
                                 full.names = TRUE)
   skip_if(length(renmark_weather) == 0, "expected json file not found in archive")

   js1 <- read_bom_json(renmark_weather[1])

   expect_s3_class(js1, "data.table")
   expect_named(js1, c("sort_order", "wmo", "name",
                       "history_product","time_zone_name", "TDZ",
                       "aifstime_utc", "aifstime_local", "lat",
                       "lon", "apparent_t", "cloud",
                       "cloud_base_m", "cloud_oktas", "cloud_type_id",
                       "cloud_type", "delta_t", "gust_kmh",
                       "gust_kt", "air_temp", "dewpt",
                       "press", "press_msl", "press_qnh",
                       "press_tend", "rain_hour", "rain_ten",
                       "rain_trace", "rain_trace_time", "rain_trace_time_utc",
                       "local_9am_date_time", "local_9am_date_time_utc", "duration_from_local_9am_date",
                       "rel_hum", "sea_state", "swell_dir_worded",
                       "swell_height", "swell_period", "vis_km",
                       "weather", "wind_dir", "wind_dir_deg",
                       "wind_spd_kmh", "wind_spd_kt", "wind_src"))

   by_col <- unlist(lapply(js1,class))
   names(by_col) <- NULL
   expect_equal(by_col,c("integer", "integer", "character",
                         "character", "character", "character",
                         "character", "character", "numeric",
                         "numeric", "numeric", "character",
                         "integer", "integer", "logical",
                         "character", "numeric", "integer",
                         "integer", "numeric", "numeric",
                         "numeric", "numeric", "numeric",
                         "character", "numeric", "numeric",
                         "character", "character", "character",
                         "character", "character", "integer",
                         "integer", "character", "character",
                         "logical", "logical", "character",
                         "character", "character", "integer",
                         "integer", "integer", "character"))
})


test_that("merge_json_weather works", {
   skip_on_cran()
   # This test relies on a local collection of weather archives that only exists
   #  on the maintainer's machines. Skip elsewhere.
   SA_weather <- character(0)
   if (Sys.info()["nodename"] == "PURPLE-DP") {
      SA_weather <-
         list.files("P:/Public Folder/weather/tgz",
                    full.names = TRUE,
                    pattern = "IDS60910")
   }
   if (Sys.info()["nodename"] == "pepper") {
      SA_weather <-
         list.files("/home/paul/Documents/weather/tgz",
                    full.names = TRUE,
                    pattern = "IDS60910")
   }
   skip_if(length(SA_weather) == 0,
           "local SA weather archives not available on this machine")

   expect_warning(
      merge_weather(SA_weather[1],
                    station_file = "IDS60910.95687.json",
                    File_formatted = "Renmark.csv",
                    base_dir = getwd()),
      "Renmark.csv not found, creating new file")

   # read in all the weather station data as json
   lapply(SA_weather,
          merge_weather,
          station_file = "IDS60910.95687.json",
          File_formatted = "Renmark.csv",
          base_dir = getwd())

   ren_dat <- fread(file.path(getwd(),"Renmark.csv"))

   expect_s3_class(ren_dat, "data.table")
   expect_named(ren_dat, c("sort_order", "wmo", "name",
                           "history_product","time_zone_name", "TDZ",
                           "aifstime_utc", "aifstime_local", "lat",
                           "lon", "apparent_t", "cloud",
                           "cloud_base_m", "cloud_oktas", "cloud_type_id",
                           "cloud_type", "delta_t", "gust_kmh",
                           "gust_kt", "air_temp", "dewpt",
                           "press", "press_msl", "press_qnh",
                           "press_tend", "rain_hour", "rain_ten",
                           "rain_trace", "rain_trace_time", "rain_trace_time_utc",
                           "local_9am_date_time", "local_9am_date_time_utc", "duration_from_local_9am_date",
                           "rel_hum", "sea_state", "swell_dir_worded",
                           "swell_height", "swell_period", "vis_km",
                           "weather", "wind_dir", "wind_dir_deg",
                           "wind_spd_kmh", "wind_spd_kt", "wind_src"))

   unlink(file.path(getwd(),"Renmark.csv"))
})

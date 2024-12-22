test_that("get_bom_observations works", {
   expect_no_error({
   dl_location <- tempdir()
  suppressMessages({
   dl_loc <-
     get_bom_observations(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
                          download_location = dl_location,
                          access_warning = FALSE)})
   })
})


test_that("merge_axf_weather works", {
   tmp_dir <- tempdir()
   wethr_dl <- tempfile("IDQ60910_",fileext = ".tgz",tmpdir = tmp_dir)
   download.file("https://filedn.eu/lKw35gljYV2BIxxlGg9SUJb/weather/tgz/240825_0750_IDQ60910.tgz",
                 destfile = wethr_dl)

   untar(tarfile = wethr_dl,exdir = tmp_dir)
   list.files(tmp_dir)

  suppressWarnings(dat <-
     merge_axf_weather(File_compressed = dl_loc,
                    File_axf = "IDQ60910.99123.axf",
                    File_formatted = "NTamborine.csv",
                    base_dir = getwd()))
  file.remove("NTamborine.csv")
})

# Set up weather import
tmp_dir <- tempdir()
wethr_dl <- tempfile("RenmarkWeather_json_",fileext = ".tgz",tmpdir = tmp_dir)
download.file("https://filedn.eu/lKw35gljYV2BIxxlGg9SUJb/weather/RenmarkWeather_json.tgz",
              destfile = wethr_dl)

untar(tarfile = wethr_dl,exdir = tmp_dir)
renmark_weather <- list.files(tmp_dir,
                              pattern = "DS60910.95687.json",
                              full.names = TRUE)


test_that("read_bom_json works", {

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


   # w_dat <- do.call(what = "rbind",
   #                  lapply(renmark_weather,
   #                         read_bom_json,
   #                         header = FALSE))
   # w_dat[,sort_order := NULL]
   #
   # W_dat <- unique(w_dat)
   #
   # expect_true(any(duplicated(w_dat)))
   # expect_false(any(duplicated(W_dat)))
   # expect_true(any(duplicated(w_dat$aifstime_utc)))
   # expect_false(any(duplicated(W_dat$aifstime_utc)))
   #
   # dtimes <- W_dat[duplicated(W_dat$aifstime_utc),aifstime_utc]
   # W_dat[aifstime_utc %in% dtimes,]

})



test_that("merge_json_weather works", {

   SA_weather <-
      list.files("/home/paul/Documents/weather/tgz",
                 full.names = TRUE,
                 pattern = "IDS60910")

   lapply(SA_weather,
          merge_weather,
          station_file = "IDS60910.95687.json",
          File_formatted = "Renmark.csv",
          base_dir = getwd())

   fread()
})


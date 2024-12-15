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
download.file(https://filedn.eu/lKw35gljYV2BIxxlGg9SUJb/weather/tgz/)




test_that("bom download works", {
   expect_no_error({
   dl_location <- tempdir()
  suppressMessages({
   dl_loc <-
     get_bom_observations(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
                          download_location = dl_location,
                          access_warning = FALSE)})
   })

  suppressWarnings(dat <-
     merge_axf_weather(File_compressed = dl_loc,
                    File_axf = "IDQ60910.99123.axf",
                    File_formatted = "NTamborine.csv",
                    base_dir = getwd()))
  file.remove("NTamborine.csv")
})

test_that("bom download works", {
  dl_loc <-
     get_bom_observations(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
                          download_location = tempdir())

  dat <-
     merge_axf_weather(File_compressed = dl_loc,
                    File_axf = "IDQ60910.99123.axf",
                    File_formatted = "NTamborine.csv",
                    base_dir = getwd())
})

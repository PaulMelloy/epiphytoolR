test_that("Code defaults work", {
   expect_warning(
      expect_no_error(
         get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
          download_location = tempdir())
      ))

   # Queensland City forecast XML package
   expect_warning(
      expect_no_error(
         get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
           product_id = "IDQ10605",
           download_location = tempdir())
         ))

   expect_warning(
   expect_no_error(
      get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
           product_id = "IDQ10700",
           download_location = tempdir())))

   # ftp_con <- curl::curl("ftp://ftp.bom.gov.au/anon/gen/fwo/")
   # file_list <- readLines(ftp_con)
   # close(ftp_con)

   # fp <- "C:/repos/Docker/bom_observations/data/tgz/260714_0130_IDQ60910.tgz"
   # fp_out <- "./temp/"
   # utils::untar(tarfile = fp, exdir = fp_out)
   #

})

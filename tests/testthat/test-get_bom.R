test_that("Code defaults work", {
   testthat::skip_if_offline()
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

test_that("monthly_water work", {
   testthat::skip_if_offline()
   # This product id is valid however I am not sure where it lives on the FTP
   #  server


      expect_error(
      get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/fwo/",
              product_id = "IDA30006",
              download_location = tempdir(),
              verbose = FALSE))

   #list.files(monthly_water)

})

test_that("Get climate data", {
   testthat::skip_if_offline()
   temp_dir <- paste0(tempdir(),"/clim_dat")
   dir.create(temp_dir)

   daily_clim <- get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/clim_data/",
                            product_id = "IDCK000082",
                            download_location = temp_dir,
                            verbose = FALSE)

   unzip(zipfile = daily_clim,
         exdir = temp_dir)

   #clim_dat <- jsonlite::read_json(path = "sstOutlooks.iod.20260818.json")
   #jsonlite::fromJSON("sstOutlooks.iod.20260818.json",simplifyDataFrame = TRUE)

   # clim <- sf::st_read("sam_index.daily.20260818.nc")


   daily_clim2 <- get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/clim_data/",
                         product_id = "IDCK000081",
                         download_location = temp_dir,
                         verbose = FALSE)

   unzip(zipfile = daily_clim2, exdir = temp_dir)

   expect_true(file.exists(file.path(temp_dir,"iod.csv")))
   expect_true(file.exists(file.path(temp_dir,"sam_index.daily.csv")))
   expect_true(file.exists(file.path(temp_dir,"soi.csv")))

})
test_that("test all common product codes listed in the documentation details",{
   testthat::skip_if_offline()
   docs_prod_codes <- c("IDCK000081", "IDCK000082", "IDD60910",
                        "IDQ60910", "IDW60910", "IDN60910", "IDS60910",
                        "IDT60910", "IDV60910", "IDN10031", "IDQ10700",
                        "IDS10033", "IDT13100", "IDV10310", "IDV17300",
                        "IDW10100")

   expect_no_error(
      lapply(docs_prod_codes, function(pdc){
         get_bom(ftp_url = "ftp://ftp.bom.gov.au/anon/gen/",
                 folder = ifelse(grepl("IDCK",pdc),"clim_data","fwo"),
                 product_id = pdc,
                 download_location = tempdir(),
                 verbose = FALSE)
      }
      ))


})

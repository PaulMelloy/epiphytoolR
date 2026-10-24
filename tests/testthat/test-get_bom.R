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

test_that("monthly_water work", {

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

   clim_iod <- read.csv(file.path(temp_dir,"iod.csv"))
   clim_sam <- read.csv(file.path(temp_dir,"sam_index.daily.csv"))
   clim_soi <- read.csv(file.path(temp_dir,"soi.csv"))
   clim_iod <- read.csv(file.path(temp_dir,"iod.csv"))

})

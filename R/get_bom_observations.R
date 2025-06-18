#' Download state weather observations
#'
#' Function downloads a compressed file to a designated location. The downloaded
#'  file contains three file formats for all automated weather station, xml, axf,
#'  and json.
#' An FTP URL is needed for this function, find this on the Bureau of Meteorology
#'  (\acronym{BOM}) website.
#'  Please read the copyright and disclaimer for use of the data while
#'  you are there.
#'
#' @param ftp_url character, ftp URL obtained from the BOMs website
#' @param download_location character, Folder location of where to download the
#'  compressed data
#' @param access_warning logical, default = `TRUE`. Elects whether to print the warning
#'  when the function is run
#' @param state character, Australian state for which weather observations files
#'  will be downloaded. Options include `"QLD"`,`"NSW"`,`"NT"`,`"VIC"`,`"SA"`,
#'   `"TAS"`,`"WA"`
#' @param file_prefix character, prefix applied to file name. Default is the date
#'  and time in hours and minutes.
#'
#' @return character string of the download file location of the downloaded compressed
#'    file `.tgz`
#' @export
#' @source http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state ;
#'  http://www.bom.gov.au/other/copyright.shtml;
#'  http://reg.bom.gov.au/other/disclaimer.shtml
#'
#' @examples
#' \dontrun{
#' get_bom_observations(ftp_url = ftp://ftp.bom.gov.au/???????,
#'                      download_location = tempdir())
#'}
get_bom_observations <- function(ftp_url,
                                 download_location,
                                 access_warning = TRUE,
                                 state = "QLD",
                                 file_prefix = format(Sys.time(), format = "%y%m%d_%H%M")) {

   if (missing(ftp_url)) {
      stop(
         "'get_bom_observations' requires the Bureau of Meterology FTP address. ",
         "This can be obtained from the BOM website. Please read their policies on ",
         "scraping data and accessing their public FTP site before using this function.
           The author of this function provides the code as is, and is free to use but takes no ",
         "responsibility for how this code is used and assumes the user has done their ",
         "due diligence in understanding the copyright assigned to BOM weather data. ",
         "Read more at the BOM website:
              http://www.bom.gov.au/other/copyright.shtml
              http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state
              http://reg.bom.gov.au/other/disclaimer.shtml
          "
      )
   }
   if (access_warning) {
      warning(
         "The author of this function provides the code as is, and is free to use but takes no ",
         "responsibility for how this code is used and assumes the user has done their ",
         "due diligence in understanding the copyright assigned to BOM weather data. ",
         "Data is not to be used for third parties unless the user (you) is a registered user with",
         "The Bureau of Meterology",
         "Read more at the BOM website:
              http://www.bom.gov.au/other/copyright.shtml
              http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state
              http://reg.bom.gov.au/other/disclaimer.shtml
          "
      )
   }

   if (dir.exists(download_location) == FALSE) {
      dir.create(download_location)
   }

   # detect if last character is a / and add if needed
   if (substr(download_location,
              nchar(download_location),
              nchar(download_location)) !=
       "/") {
      download_location <- paste0(download_location, "/")
   }

   state <- casefold(state, upper = TRUE)
   state <- switch(
      state,
      "NSW" = "IDN60910.tgz",
      "NT" = "IDD60910.tgz",
      "QLD" = "IDQ60910.tgz",
      "SA" = "IDS60910.tgz",
      "VIC" = "IDV60910.tgz",
      "TAS" = "IDT60910.tgz",
      "WA" = "IDW60910.tgz"
   )
   # save the download file location
   dl_floc <-
      paste0(download_location,
             file_prefix,
             "_", state)


   # download the tar zipped file to download location
   utils::download.file(url = paste0(ftp_url, state),
                        destfile = dl_floc)
   message("Compressed file saved to ", dl_floc)
   return(dl_floc)
}






#' Merge 'latest' BOM weather data
#'
#'  \code{merge_weather} takes the 'latest' Bureau of Meteorology \acronym{BOM}
#'  weather observations files which hold 72 hours of weather observations in
#'  10-30 minute intervals and a saved earlier weather data file, row binds the
#'  two data.tables, then overwrites the old File_formatted.csv file with the
#'  joined data.
#'
#' @param File_compressed character, file path of compressed weather file "tgz"
#' @param station_file character, uncompressed BOM file containing 10 minute weather
#'  observations, default is North Tamborine. Works best with \code{json} files,
#'  but can also read \code{axf} files.
#' @param File_formatted character, file name and path to the formatted file for
#'  which to store formatted data and which previously stored data will be merged
#'  with.
#' @param base_dir character, weather directory which contains folders where
#'  weather data are saved, and where \code{File_formatted} data is saved.
#' @param verbose logical print extra messages to assist debugging
#'
#' @return data.table, of merged dataset
#' @export
merge_weather <- function(File_compressed,
                          # uncompressed
                          station_file = "IDQ60910.99123.json",
                          File_formatted = "NTamborine.csv",
                          base_dir = getwd(),
                          verbose = FALSE) {
   # define data.table reference
   aifstime_utc <- NULL

   # create temp folder and file
   Temp_folder <- paste0(tempdir(check = TRUE),
                         "/",
                         format(Sys.time(), format = "%y%m%d_%H%M%S"),
                         "/")
   dir.create(Temp_folder,
              recursive = TRUE,
              showWarnings = FALSE)

   # uncompress data to temporary folder
   if (verbose) {
      cat(" Uncompressing: ", File_compressed, "\n")
   }
   # Extract
   utils::untar(tarfile = File_compressed, exdir = Temp_folder)

   # Check 'station_file' is contained in tar archive
   if (file.exists(file.path(Temp_folder, station_file)) == FALSE) {
      stop("'station_file' not found")
   }

   # check the extension of the file name and read in data
   s_file_ext <- tools::file_ext(station_file)
   if (s_file_ext == "axf") {
      if (verbose) {
         cat("   Read in new data", "\n")
      }

      # Read data
      dat_new <-
         data.table::fread(
            file.path(Temp_folder, station_file),
            skip = 24,
            nrows = 144,
            na.strings = c("-"),
            integer64 = "character"
         )

      colnames(dat_new) <-
         gsub(pattern = "\\[80]",
              replacement = "",
              colnames(dat_new))

      # detect if last character is a / and add if needed
      if (substr(base_dir, nchar(base_dir), nchar(base_dir)) !=
          "/") {
         base_dir <- paste0(base_dir, "/")
      }
   }else{
      # read in weather json
      if (s_file_ext == "json") {
         if (verbose) {
            cat("   Read in new data", "\n")
         }
         dat_new <- read_bom_json(f_path = file.path(Temp_folder, station_file),
                                  header = verbose)
         data.table::setDT(dat_new)
      } else{
         stop("file extension '", s_file_ext, "' not recognised")
      }

   }



   # Look for the file to be merged into, if it does not exist create a new file
   if (file.exists(file.path(base_dir, File_formatted)) == FALSE) {
      warning(File_formatted, " not found, creating new file\n")

      fwrite(dat_new, file = file.path(base_dir, File_formatted))
      unlink(Temp_folder)
      return(dat_new)
   } else{
      if (verbose) {
         cat("   Read in old data", "\n")
      }
      dat_old <-
         data.table::fread(file = file.path(base_dir, File_formatted),
                           integer64 = "character")

      if (verbose) {
         cat("   Merge data", "\n")
      }
      Merged <- rbind(dat_old, dat_new)

      Merged <- Merged[order(aifstime_utc),]

      Merged <- Merged[!duplicated(aifstime_utc)]

      if (verbose) {
         cat("   Write out successfully merged data", "\n")
      }
      fwrite(Merged, file = file.path(base_dir, File_formatted))
      unlink(Temp_folder)
      return(Merged)
   }



}

#' Download state weather observations
#'
#' Function downloads a compressed file to a desegnated location. The downloaded
#'  file contains three file formats for all automated weather station, xml, axf,
#'  and json.
#' An FTP url is needed for this function, find this on the Bureau of Meterology
#'  website. Please read the copyright and disclaimer for use of the data while
#'  you are there.
#'
#' @param ftp_url character, ftp url obtained from the BOMs website
#' @param download_location character, Folder location of where to download the
#'  compreseed data
#' @param access_warning logical, default = `TRUE`. Elects whether to print the warning
#'  when the function is run
#' @param state character, Australian state for which weather observations files
#'  will be downloaded. Options include `"QLD"`,`"NSW"`,`"NT"`,`"VIC"`,`"SA"`,
#'   `"TAS"`,`"WA"`
#' @param file_prefix character, prefix applied to file name. Default is the date
#'  and time in hours and minutes.
#'
#' @return character string of the download file loaction of the downloaded compressed
#'    file `.tgz`
#' @export
#' @source http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state ;
#'  http://www.bom.gov.au/other/copyright.shtml; http://reg.bom.gov.au/other/disclaimer.shtml
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
         "scraping data and accessing thier public FTP site before using this function.
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
   # save the download file locaiton
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






#' Merge BOM axf weather data
#'
#'  @details
#'   This function takes new BOM axf files which hold 72 hours of weather observations
#`   in 10 minute intervals and an old formatted weather data file, row binds them,
#`   then saves them back as the File_formatted csv.
#`  `File_axf` uncompressed axf BOM file containing 10 minute weather observations. default is North Tamborine
#`  `File_formatted` previously read axf files with removed headers and saved as a csv file
#`   `base_dir` weather directory which folders of weather data are saved and where formatted data is put
#`   `data_dir` Directory with compressed and uncompressed data
#'
#' @param File_compressed character, file path of compressed weather file "tgz"
#' @param File_axf character, filename of axf weather data observation file from
#'  bom
#' @param File_formatted character, filename and path to the formated file which
#'  has previously merged data
#' @param base_dir character file path giving the base directory for file_formatted
#'
#' @return data.table, of merged dataset
#' @export
#'
#' @examples
merge_axf_weather <- function(File_compressed, # uncompressed
                              File_axf = "IDQ60910.99123.axf",
                              File_formatted = "NTamborine.csv",
                              base_dir = getwd()){
   # define data.table reference
   aifstime_utc <- NULL

   # uncompress data to temporary folder
   Temp_folder <- paste0(tempdir(),"/",format(Sys.time(), format = "%y%m%d_%H%M%S"),"/")
   dir.create(Temp_folder,
              recursive = TRUE)
   utils::untar(tarfile = File_compressed,
                exdir = Temp_folder)

   # Read data
   dat_new <-
      data.table::fread(paste0(Temp_folder, File_axf),
                        skip = 24,
                        nrows = 144)

   colnames(dat_new) <-
      gsub(pattern = "\\[80]", replacement = "", colnames(dat_new))

   # detect if last character is a / and add if needed
   if (substr(base_dir,
              nchar(base_dir),
              nchar(base_dir)) !=
       "/") {
      base_dir <- paste0(base_dir, "/")
   }

   if(file.exists(paste0(base_dir,File_formatted)) == FALSE){
      warning(File_formatted, " not found, creating new file\n")
      fwrite(dat_new,file = paste0(base_dir,File_formatted))
      unlink(Temp_folder)
      return(dat_new)
   }else{

      dat_old <- fread(file = paste0(base_dir,File_formatted))

      Merged <- rbind(dat_old,dat_new)

      Merged <- Merged[!duplicated(aifstime_utc)]

      fwrite(Merged,file = paste0(base_dir,File_formatted))
      unlink(Temp_folder)
      return(Merged)
   }



}

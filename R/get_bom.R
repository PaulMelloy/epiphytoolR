#' Get Bureau of Meterology data
#'
#' @description
#' Wrapper function that accesses the Bureau of Meterology (BOM) FTP site and
#' download it to a specified file path.
#' For more information see https://www.bom.gov.au/catalogue/anon-ftp.shtml
#'
#' An FTP URL is needed for this function, find this on the Bureau of Meteorology
#'  (\acronym{BOM}) website.
#'  Please read the copyright and disclaimer for use of the data while
#'  you are there.
#'
#' @param ftp_url character, ftp URL obtained from the BOMs website
#' @param folder character, ftp folder where product ID is
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
get_bom <- function(ftp_url,
                    product_id = "IDQ60910",
                    folder = "fwo",
                    download_location,
                    filetype = NULL,
                    file_prefix = format(Sys.time(), format = "%y%m%d_%H%M"),
                    verbose = TRUE
                    ){

   if (missing(ftp_url)) {
      stop(
         paste("'get_bom_observations' requires the Bureau of Meterology FTP address. ",
               "This can be obtained from the BOM website. Please read their policies on ",
               "scraping data and accessing their public FTP site before using this function.\n",
               bom_warning_string)
      )
   }
   if (verbose) {
      warning(bom_warning_string)
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

   # detect filetype
   if(is.null(filetype)){
      ftp_con <- curl::curl(ftp_url)
      file_list <- readLines(ftp_con)
      close(ftp_con)

      #shortlist <- strsplit(grep(product_id, file_list,value = TRUE),product_id)
      shortlist <- strsplit(grep(product_id, file_list,value = TRUE),"ID")

      if(length(shortlist) == 0) stop(product_id," not found in BOM FTP site")

      bom_ftp_files <-
         lapply(shortlist,function(x){
            fname <- paste0("ID",x[grepl(gsub("ID","",product_id),x)])
            return(fname)
            })
      bom_ftp_files <- unlist(bom_ftp_files)

   }else{
      bom_ftp_files <- paste0(product_id,filetype)
   }


      # save the download file location
   dl_floc <-
      paste0(download_location,
             file_prefix,
             "_", bom_ftp_files)


   # download the tar zipped file to download location
   for(i in seq_along(bom_ftp_files)){
      utils::download.file(url = paste0(ftp_url, bom_ftp_files[i]),
                           destfile = dl_floc[i],quiet = !verbose)
      }
   message("Compressed file saved to ", paste0(dl_floc,sep = "  \n"))
   return(dl_floc)

}

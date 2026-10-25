#' Get Bureau of Meteorology data
#'
#' @description
#' Wrapper function that accesses the Bureau of Meterology (BOM) FTP site and
#' download it to a specified file path.
#' For more information see https://www.bom.gov.au/catalogue/anon-ftp.shtml
#' Works with most codes on the catalogue, however some have not been linked with
#' this current version.
#' Leave a issue on github if you want a specific product code patched.
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
#'  http://reg.bom.gov.au/other/disclaimer.shtml;
#'  https://www.bom.gov.au/catalogue/anon-ftp.shtml
#'
#' @details
#' Some common product id codes:
#'  "IDCK000081":	Climate indices weekly observations (IOD, NINO, MJO, SAM, SOI)
#'  "IDCK000082":	Climate indices daily forecasts (IOD, MJO, SAM)
#'  "IDD60910":	Weather Observations 72hr History - Northern Territory - XML (NT)
#'  "IDQ60910":	Weather Observations 72hr History - Queensland - XML (QLD)	Observation	0
#'  "IDW60910":	Weather Observations 72hr History - Western Australia - XML (WA)
#'  "IDN60910":	Weather Observations 72hr History - New South Wales and Australian Capital Territory - XML (NSW)
#'  "IDS60910":	Weather Observations 72hr History - South Australia - XML (SA)
#'  "IDT60910":	Weather Observations 72hr History - Tasmania - XML (TAS)
#'  "IDV60910":	Weather Observations 72hr History - Victoria - XML (VIC)
#'  "IDD60910":	Weather Observations 72hr History - Northern Territory - XML (NT)
#'  "IDN10031":	State Forecast (NSW)	240 hours
#'  "IDQ10700":	State Forecast (QLD)	240 hours
#'  "IDS10033":	State Forecast (SA)	15 hours
#'  "IDT13100":	State Forecast (TAS)	24 hours
#'  "IDV10310":	State Forecast (VIC)	24 hours
#'  "IDV17300":	Interstate Cities Forecast (VIC)	24 hours
#'  "IDW10100":	State Forecast (WA)	24 hours
#'
#'  More codes searchable on the BOM website https://www.bom.gov.au/catalogue/anon-ftp.shtml
#'
#' @examples
#' \dontrun{
#' get_bom_observations(ftp_url = ftp://ftp.bom.gov.au/???????,
#'                      download_location = tempdir())
#'}
get_bom <- function(ftp_url,
                    product_id = "IDQ60910",
                    folder = NULL,
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
   if (substr(ftp_url,
              nchar(ftp_url),
              nchar(ftp_url)) !=
       "/") {
      ftp_url <- paste0(ftp_url, "/")
   }


   # detect folders
   if(is.null(folder)){
      foldr_lvl <- last(unlist(strsplit(ftp_url,"/")))
      # if specific folder is not provided
      if(foldr_lvl == "gen"){
         folder <- .get_ftp_folder(prod_code = product_id)
         ftp_url <- paste0(ftp_url,folder,"/")
      }else if(foldr_lvl == "anon"){
         folder <- .get_ftp_folder(prod_code = product_id)
         ftp_url <- paste0(ftp_url,"gen/",folder,"/")
      }else if(foldr_lvl == "ftp.bom.gov.au"){
         folder <- .get_ftp_folder(prod_code = product_id)
         ftp_url <- paste0(ftp_url,"anon/gen/",folder,"/")
      }
   }else{
      ftp_url <- paste0(ftp_url,folder,"/")
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


.get_ftp_folder <- function(prod_code){

   gen_fold <-
      data.table::fcase(
         grepl("IDCKWCDE",prod_code),"fault",
         grepl("IDCK",prod_code),"clim_data",
         grepl("IDX0",prod_code),"difacs",
         grepl("IDE00",prod_code),"gms",
         grepl("IDG",prod_code),"nmgu",
         grepl("IDR",prod_code),"radar", #Also could be "radar_transparencies"
         grepl("IDY",prod_code),"fault", #volcano alerts also need year
         grepl("IDA",prod_code),"fwo",
         grepl("IDD",prod_code),"fwo",
         grepl("IDN",prod_code),"fwo",
         grepl("IDQ",prod_code),"fwo",
         grepl("IDS",prod_code),"fwo",
         grepl("IDT",prod_code),"fwo",
         grepl("IDV",prod_code),"fwo",
         grepl("IDW",prod_code),"fwo",
         # grepl("IDY0",prod_code),"fwo",
         # grepl("IDY1",prod_code),"fwo",
         # grepl("IDY2",prod_code),"fwo",
         # grepl("IDY4",prod_code),"fwo",
         # grepl("IDY6",prod_code),"fwo",
         grepl("IDZ",prod_code),"fwo",
         default = "fault")
   if(gen_fold == "fault"){
      stop("Can't determine the FTP location of this product",
           "check entry or specify a folder to get around error",
           "If it still fails submit a issue on github to include in next version")
   }
   return(gen_fold)

}

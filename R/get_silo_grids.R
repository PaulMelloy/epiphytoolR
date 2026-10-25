#' Get gridded SILO weather data
#'
#' @description
#' Wrapper to help download full gridded weather datasets from Digital Earth
#' Australia's acronym(DEA) aws s3 bucket.
#'
#' seealso calc_wthr_coefs(), est_weather()
#'
#' @param w_var character, name of the weather variable to download from DEA
#' @param years integer, year range to download
#' @param path character, folder path to save the netCDF files
#' @param verbose logical, return downloaded confirmation on each file
#' @param overwrite logical, if the file already exists should it be overwritten
#'
#' @returns NULL
#' @export
#'
#' @examples
#' \dontrun{
#' get_silo_grids(w_var = c("max_temp"),
#'                years = 1950,
#'                path = tempdir())
#' }
get_silo_grids <- function(w_var = c("daily_rain", "max_temp", "min_temp"),
                           years = 1950,
                           path = tempdir(),
                           overwrite = FALSE,
                           verbose = TRUE){

   if(isFALSE(all(w_var %in% c("daily_rain", "max_temp", "min_temp")))){
      stop("'w_war' not recognised")
   }

   for(wv in w_var){
      for(y in years){
         if(file.exists(file.path(path,paste(y,"_silo_",wv,".nc", sep = ""))) & isFALSE(overwrite)) next

         bouquet_df <-
            aws.s3::get_bucket_df(
               bucket = "s3://silo-open-data/",
               region = "ap-southeast-2",
               prefix = paste("Official/annual", wv, y, sep = "/")
            )
         if(nrow(bouquet_df) != 1){
            stop("Query is not matched by a gridded silo dataset")
         }

         aws.s3::save_object(
            object = paste("Official/annual/", wv, "/", y, ".", wv, ".nc", sep = ""),
            bucket = "s3://silo-open-data/",
            region = "ap-southeast-2",
            file = file.path(path, paste(y, "_silo_", wv, ".nc", sep = ""))
         )

         if(verbose){cat(file.path(path,paste(y,"_silo_",wv,".nc", sep = ""))," --- saved\n")}
      }
   }
}

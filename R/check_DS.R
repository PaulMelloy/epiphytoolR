check_DS <- function(x){
   if(is.POSIXct(x) == FALSE) stop("Please provide POSIXct formatted time")

   Year <- format(x,format = "%Y")


}


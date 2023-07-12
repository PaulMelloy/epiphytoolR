#' Fill time gaps in data.frame
#'
#' @param dat data.frame or data.table with column of times
#' @param t_col character, colname of column containing times
#' @param interval numeric, expected time interval in minutes between times
#' @param impute logical, not in operation, possible future functionability.
#'  default is FALSE
#' @param max_interval numeric, maximum acceptable interval between data
#'  observaions in minutes.
#'
#' @return
#' @export
#'
#' @examples
fill_time_gaps <- function(dat,t_col, interval = "auto", max_interval = 60, impute = FALSE){
   data.table::setDT(dat)


   # give a colname to dat
   dat$t1mes <- dat[,..t_col]

   if(attr(x = dat$t1mes,"tzone") != "UTC"){
   stop("please convert time to UTC\n
     eg. 'as.POSIXct(times, tz = \"UTC\")")
      }
   # ensure it is in order
   dat <- dat[order(t1mes)]

   # find the time difference
   dat[, t_diff := difftime(t1mes, shift(t1mes), units = "secs")]

   if(interval == "auto") {
      interval <-
         as.numeric(names(sort(table(dat$t_diff), decreasing = TRUE)[1]))
   }else{
      interval <- interval * 60
   }

   gaps <- which(dat$t_diff > max_interval * 60)

   for(g in gaps){
      seq_time <- seq(dat[g-1,t1mes], dat[g,t1mes],by = interval)
      last1 <-length(seq_time)-1
      seq_time <- seq_time[2:last1]

      if(impute){
         # Future updates
         # impute_tm
      }

      dat2 <- rbind(dat,data.table(t1mes = seq_time),
                   fill = TRUE)

      # if only one variable in column, fill all with this same value
      for(i in colnames(dat)){
         if(nrow(unique(dat[,..i])) == 1){
            x1 <- unlist(unique(dat[,..i]))
            dat2[,c(i) := x1]
         }
      }
      dat <- dat2

   }

   # order the data.table again
   dat <- dat[order(t1mes)]
   # transfer back to input column
   dat[,c(t_col) := t1mes]
   dat[, c("t1mes", "t_diff") := NULL]

   return(dat)

}

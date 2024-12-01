#' Calculate area under the disease progress curve (AUPDC)
#'
#' @details
#' This is a wrapper for \CRANpkg{agricolae} which checks for NA values and will
#'  return omit NA values if specified. However it will still return NA if the
#'  first or last values contain \code{NA}
#'  This is intentional as audpc values are completely not comparable when these
#'  values are missing.
#'  See help \code{\link[agricolae]{audpc}} for more details.
#'
#' @param evaluation Table of data of the evaluations: Data frame with
#'  evaluations as columns; or a vector of evaluations
#' @param dates Vector of dates corresponding to each evaluation
#' @param type "relative" or "absolute", relative returns a proportion,
#' whereas absolute returns the area.
#' @param na.rm logical, remove observations with either an \code{NA} in the evaluation
#'  or the date. Does not allow \code{NA} values at the start or end observations.
#'
#' @return Vector with relative or absolute area under the disease progress curve
#' @export
#'
#' @examples
#' # see examples in help(agricolae::audpc)
#' dates <- c(14,21,28,32,39,41,50) # days
#' # example 1: evaluation - vector
#' evaluation <- c(1,2,4,15,40,80,90)
#' Audpc(evaluation,dates)
#'
#' # add NA values
#' evaluation<-c(1,2,4,NA,40,80,90)
#' Audpc(evaluation,dates, na.rm = TRUE)
#' \dontrun{agricolae::audpc(evaluation,dates)}
#' # if NA is at the start or end of vector it will return NA
#' dates<-c(14,21,28,32,39,41,NA) # days
#' Audpc(evaluation,dates)
Audpc <-
  function (evaluation,
            dates,
            type = "absolute",
            na.rm = FALSE) {
    if (!(is.matrix(evaluation) | is.data.frame(evaluation))) {
      evaluation <- rbind(evaluation)}

    n <- length(dates)
    k <- ncol(evaluation)

    if (n != k) {
      stop("Error:\nThe number of dates of evaluation \nmust agree with the number of evaluations\n")
    }

    # check start and end have observations
    if(na.rm & (is.na(evaluation[,1]) | is.na(evaluation[,k]) |
                is.na(dates[1]) | is.na(dates[n]))){
       return(NA)}

    if(na.rm){
       # identify NA index
       na_i <- c(which(is.na(evaluation)),
                 which(is.na(dates)))

       # remove indices with NA
       evaluation <- rbind(evaluation[,-na_i])
       dates <- dates[-na_i]

       # update lengths
       n <- length(dates)
       k <- ncol(evaluation)

    }

    audpc <- 0
    area.total <- 100 * (dates[n] - dates[1])




    for (i in 1:(n - 1)) {
      if(na.rm & is.na(evaluation[,i])) next

      audpc <- audpc + (evaluation[, i] + evaluation[, i +1]) * (dates[i + 1] - dates[i]) / 2
    }
    if(is.na(audpc))
      return(NA_real_)
    if(audpc == 0)
      return(NA_real_)
    if (type == "relative")
      audpc <- audpc / area.total
    if (type == "absolute" | type == "relative") {
      return(audpc)
    }
    else
      stop("Error: type is 'absolute' or 'relative'\n\n")
  }

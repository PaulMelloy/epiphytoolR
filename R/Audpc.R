#' Calculate area under the disease progress curve
#'
#' @details
#' This is a wrapper for \CRANpkg{agricolae} which checks for NA values and will
#'  return NA values if specified in the argument
#'  see help[agricolae::audpc] for more details.
#'
#' @param evaluation Table of data of the evaluations: Data frame
#' @param dates Vector of dates corresponding to each evaluation
#' @param type relative, absolute
#' @param na.rm weather to remove NA values or return NA when there are only NA
#'  vales
#'
#' @return Vector with relative or absolute audpc.
#' @export
#'
#' @examples
#' # see examples in help(agricolae::audpc)
#' dates<-c(14,21,28) # days
#' # example 1: evaluation - vector
#' evaluation<-c(40,80,90)
#' Audpc(evaluation,dates)
#' dates<-c(14,21,NA) # days
#' Audpc(evaluation,dates)
#' # agricolae::audpc(evaluation,dates)
#' dates<-c(14,21,28) # days
#' evaluation<-c(40,80,NA)
#' Audpc(evaluation,dates)
#' # agricolae::audpc(evaluation,dates)
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

    audpc <- 0
    area.total <- 100 * (dates[n] - dates[1])

    # check start and end have observations
    if(na.rm & (is.na(evaluation[,1]) | is.na(evaluation[,n])))
      return(NA)

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

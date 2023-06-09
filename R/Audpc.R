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
    cat(audpc)
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
      cat("Error: type is 'absolute' or 'relative'\n\n")
  }

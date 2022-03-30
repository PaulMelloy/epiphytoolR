#' Check format_weather warnings
#'
#' Print internal warnings produced during the running of format_weather
#'
#' @return lines of messages with the function, type (either a message
#'  or warning) and the output of the message or warning
#' @export
#'
#' @examples
#' f <- function(x) {
#'    warning("This is a warning")
#'    message("This is a message")
#'    x + x}
#' epiphytoolR::.capture_warnings(f(1))
#' check_weather_warnings()
check_weather_warnings <- function() {
   invisible(lapply(warn$captured_warnings, function(x) {
      x <- unique(unlist(x))
      message(paste0(x, sep = " - "))

   }))
}

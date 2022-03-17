#' Internal function to capture warnings
#'
#' Use with caution, excessive use will bloat the `warn` object and slow down the
#'  R session. Clear the environment between each use if possible.
#'
#' @param f a function call
#' @param silent logical. specifies whether to muffle warnings and messages
#'  outright.
#'
#' @return list with two elements, results (res) and warning/message logs
#'  as a data.frame (logs)
#'
#' @noRd
#' @export
#' @examples
#' f <- function(x) {
#'    warning("This is a warning")
#'    message("This is a message")
#'    x + x}
#' .capture_warnings(f(1))
#' warn$captured_warnings
.capture_warnings <- function(f, silent = FALSE) {
   if(!exists("logs",where = warn)){
      warn <- new.env(parent = .GlobalEnv)
      warn$logs <- list()
   }
   res <- withCallingHandlers(
      f,
      warning = function(w) {
         if(silent) {
            invokeRestart("muffleWarning")
            }else{
         warn$logs[[length(warn$logs) + 1]] <-
            list(
               function_call = as.character(conditionCall(w))[1],
               type = attributes(w)$class[2],
               message = conditionMessage(w)
            )
         invokeRestart("muffleWarning")}
      },
      message = function(m) {
         if(silent){
            invokeRestart("muffleMessage")
            }else{
         warn$logs[[length(warn$logs) + 1]] <-
            list(
               function_call = as.character(conditionCall(m))[1],
               type = attributes(m)$class[2],
               message = conditionMessage(m)
            )
         invokeRestart("muffleMessage")}
      }
   )

   if (exists("captured_warnings", envir = warn)) {
      warn$captured_warnings <- c(warn$captured_warnings, warn$logs)
   } else{
      warn$captured_warnings <- warn$logs
   }
   return(res)
}

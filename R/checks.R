#' Warn an argument is missing
#' 
#' Warn that an argument is missing.
#' 
#' @param what Name of argument (string) that is missing.
#' 
#' @noRd 
#' @keywords internal
warnMissing <- function(what){
  warning("Missing `", what, "` [ignoring]", call. = FALSE)
}

#' @noRd 
#' @keywords internal
stopMissing <- function(var, what){
  if(missing(var))
    stop("Missing `", what, "`", call. = FALSE)
}

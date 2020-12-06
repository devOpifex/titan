#' Warn an argument is missing
#' 
#' Warn that an argument is missing.
#' 
#' @param what Name of argument (string) that is missing.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @noRd 
#' @keywords internal
warnIfMissing <- function(what){
  warning("Missing `", what, "` [ignoring]", call. = FALSE)
}

#' @noRd 
#' @keywords internal
stopIfMissing <- function(var, what = deparse(substitute(var))){
  if(missing(var))
    stop("Missing `", what, "`", call. = FALSE)
}

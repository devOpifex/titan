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

#' Get all names of objects in registry
#' 
#' @param name the name of an object to
#' check in the registry.
#' 
#' @noRd
#' @keywords internal
getRegistryNames <- function(){
  names(titanCollector)
}

#' @noRd
#' @keywords internal
hasRegistryName <- function(name){
  names <- getRegistryNames()
  if(any(name %in% names))
    return(TRUE)

  return(FALSE)
}
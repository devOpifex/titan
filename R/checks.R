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

#' Health Check
#' 
#' Performs a health check on titan and attempts
#' at identifying potential issues with the setup.
#' 
#' @importFrom dplyr count filter
#' 
#' @export 
healthCheck <- function(){
  cat("Do no run this in production!\n")

  names <- getRegistryNames()

  nameCounts <- count(
    data.frame(names = names),
    names
  )

  duplicates <- filter(nameCounts, n > 1)

  if(nrow(duplicates) > 0){
    apply(duplicates, 1, function(x){
      warning(x$names, "is used", x$n, "times!")
    })
  } else {
    cat("Looks good!")
  }

  invisible()
}

getRegistryNames <- function(){
  names <- c()
  items <- ls(titanCollector)
  for(item in items){
    metric <- titanCollector[[item]]
    
    names <- append(names, metric$getName())
  }
  return(names)
}

hasRegistryName <- function(name){
  names <- getRegistryNames()
  if(any(name %in% names))
    return(TRUE)

  return(FALSE)
}
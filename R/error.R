# escalate errors
# allows avoiding running `stop`
# would be too ironic that prometheus breaks a service
# used here while {err} devOpifex/err is not on CRAN
Error <- function(obj = ""){
  attr(obj, "error") <- TRUE
  return(obj) 
}

is.error <- function(obj){
  iserror <- attr(obj, "error")

  if(is.null(iserror))
    return(FALSE)

  return(TRUE)
}
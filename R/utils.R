`%||%` <- function(lhs, rhs){
  if(is.null(lhs))
    return(rhs)

  lhs
}

checkInstalled <- function(pkg){
  has_it <- base::requireNamespace(pkg, quietly = TRUE)

  if(!has_it)
    stop(sprintf("This function requires the package {%s}", pkg), call. = FALSE)
}
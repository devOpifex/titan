# argument is not missing
not_missing <- function(x) {
  !missing(x)
}

assertthat::on_failure(not_missing) <- function(call, env) {
  paste0(deparse(call$x), " is missing")
}

# x is an appobj from shiny
is_app <- function(x){
  inherits(x, "shiny.appobj")
}

assertthat::on_failure(is_app) <- function(call, env){
  paste0(deparse(call$x), "is not a shiny application")
}
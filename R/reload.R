#' Reload the configuration
#' 
#' Tell Prometheus to reload the configuration file.
#' Note that this only works if Prometheus was launched
#' with the `--web.enable-lifecycle` flag.
#' 
#' @param prometheus URL to the prometheus service, including
#' the port if necessary.
#' 
#' @export
reloadConfig <- function(prometheus = "http://localhost:9090"){
  checkInstalled("httr")
  prometheus <- gsub("/$", "", prometheus)
  prometheus <- sprintf("%s/-/reload", prometheus)
  httr::POST(prometheus)
}
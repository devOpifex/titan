#' Management
#' 
#' Interact with the management API of Prometheus.
#' 
#' @param uri URL to the prometheus service, including
#' the port if necessary. It defaults to the `PROMETHEUS_URL`
#' environment variable and if this is not set uses 
#' `http://localhost:9090`.
#' @param prompt Whether to prompt the user for an input,
#' used for the dangerous `PromQuit` which shuts down the 
#' Prometheus server. Defaults to `TRUE`.
#' 
#' @section Functions:
#' 
#' - `PromReload`: Tell Prometheus to reload the configuration file.
#'  Note that this only works if Prometheus was launched
#'  with the `--web.enable-lifecycle` flag.
#' - `PromReady`: Check whether Prometeus is ready to serve traffic 
#'  (i.e. respond to queries). Returns `TRUE` if Prometheus is ready.
#' - `PromHealthy`: Checks Prometheus' health. 
#'  Returns `TRUE` if Prometheus is healthy.
#' - `PromQuit`: riggers a graceful shutdown of Prometheus. 
#' It's disabled by default and can be enabled via the 
#'  `--web.enable-lifecycle` flag.
#' 
#' @note All management-related functions start with a capital
#' letter.
#' 
#' @name mgmt
#' 
#' @export
PromReload <- function(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090")){
  uri <- buildUrl(uri, "reload")
  response <- httr::POST(uri)
  status2bool(response)
}

#' @rdname mgmt
#' @export 
PromHealthy <- function(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090")){
  uri <- buildUrl(uri, "healthy")
  response <- httr::GET(uri)
  status2bool(response)
}

#' @rdname mgmt
#' @export 
PromReady <- function(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090")){
  uri <- buildUrl(uri, "ready")
  response <- httr::GET(uri)
  status2bool(response)
}

#' @rdname mgmt
#' @export 
PromQuit <- function(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090"), prompt = TRUE){
  uri <- buildUrl(uri, "quit")
  
  if(prompt){
    answer <- readline("Are you sure you want to shut down Prometheus? (y/n) ")

    while(!tolower(answer) %in% c("y", "n")){
      answer <- readline("Are you sure you want to shut down Prometheus? (y/n) ")
    }

    if(tolower(answer) == "n"){
      cat("NOT shutting down Prometheus")
      return(invisible())
    }
  }
  
  httr::POST(uri)
}

#' Clean the URL
#' 
#' @param uri URL to clean.
#' 
#' @noRd 
#' @keywords internal
cleanUrl <- function(uri){
  gsub("/$", "", uri)
}

#' Build the URL
#' 
#' Builds the URL for the management API.
#' 
#' @param uri Base URL.
#' @param endpoint Endpoint to use.
#' 
#' @noRd 
#' @keywords internal
buildUrl <- function(uri, endpoint = c("healthy", "reload", "ready", "quit")){
  checkInstalled("httr")
  
  endpoint <- match.arg(endpoint)
  
  uri <- cleanUrl(uri)
  sprintf("%s/-/%s", uri, endpoint)
}

#' Status as Boolean
#' 
#' @param response Response from the httr package.
#' 
#' @return `TRUE` if the status is `200` and `FALSE` otherwise.
#' 
#' @noRd 
#' @keywords internal
status2bool <- function(response){
  status <- httr::status_code(response)

  if(status == 200L)
    return(TRUE)

  FALSE
}
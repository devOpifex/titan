#' Generate Authorization Header
#' 
#' Generate the basic authorization header for
#' authentication.
#' 
#' @param username,password Credentials to encode.
#' @param string Base64 encoded string, as returned by
#' [generateBasicAuth()].
#' 
#' @details Use the output of `generateBasicAuth` as
#' input to `setAuthentication`. This makes it such
#' that the `/metrics` endpoint requires the authentication
#' defined. Then use the credentials in the prometheus
#' configuration file.
#' 
#' basic_auth:
#'  username: usr
#'  password: pwd
#' 
#' @name auth
#' 
#' @export
generateBasicAuth <- function(username, password){
  if(missing(username))
    stop("Missing `username`", call. = FALSE)

  if(missing(password))
    stop("Missing `password`", call. = FALSE)

  warning("Do not deploy or share this", call. = FALSE)

  checkInstalled("base64enc")
  string <- sprintf("%s:%s", username, password)
  encoded <- base64enc::base64encode(charToRaw(string))
  paste("Basic", encoded)
}

#' @rdname auth
#' @export
setAuthentication <- function(string = Sys.getenv("TITAN_BASIC_AUTH")){
  if(string == "") string <- NULL
  
  options(TITAN_BASIC_AUTH = string)
}

#' @rdname auth
#' @export
getAuthentication <- function(){
  getOption("TITAN_BASIC_AUTH", NULL)
}

#' Retrieve Metrics from Endpoint
#' 
#' Retrieve the metrics via the endpoint,
#' useful for testing authentication.
#' 
#' @param endpoint URL to the endpoint.
#' @param auth Authentication string as returned
#' by [generateBasicAuth()].
#' 
#' @export
getMetrics <- function(endpoint, auth = NULL){

  checkInstalled("httr")

  if(missing(endpoint))
    stop("Must pass `endpoint`", call. = FALSE)

  endpoint <- parseEndpoint(endpoint)

  if(!is.null(auth))
    httr::GET(endpoint, httr::add_headers(Authorization = auth))
  else
    httr::GET(endpoint)
}

#' Parse endpoint
#' 
#' @param endpoint URL to endpoint.
#' 
#' @noRd 
#' @keywords internal
parseEndpoint <- function(endpoint){
  parsed <- httr::parse_url(endpoint)
  hasMetrics <- grepl("metrics", parsed$path)

  if(!hasMetrics){
    path <- gsub("/$", "", parsed$path)
    path <- paste0(path, "/metrics")
    parsed$path <- path
  }
  
  httr::build_url(parsed)
}
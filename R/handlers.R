# serve metrics
shinyHandler <- function(req){
  if(!req$PATH_INFO == "/metrics")
    return()

  auth <- getAuthentication()

  if(is.null(auth))
    return(res(200L, "text/plain", renderMetrics()))

  unauthorized <- res(401L, "text/plain", "Unauthorized")

  if(is.null(req$HTTP_AUTHORIZATION))
    return(unauthorized)

  if(req$HTTP_AUTHORIZATION != auth)
    return(unauthorized)

  res(200L, "text/plain", renderMetrics())
  
}

# serve metrics
plumberHandler <- function(req, res){
  
  auth <- getAuthentication()

  res$setHeader("Content-Type", "text/plain")
  res$status <- 200L

  if(is.null(auth)){
    res$body <- renderMetrics()
    return(res)
  }

  res$status <- 401L
  res$body <- "Unauthorized"

  if(is.null(req$HTTP_AUTHORIZATION))
    return(res)

  if(req$HTTP_AUTHORIZATION != auth)
    return(res)

  res$status <- 200L
  res$body <- renderMetrics()
  
  return(res)
}
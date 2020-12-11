#' Plumber
#' 
#' Serve a plumber API with metrics, use this function
#' like you would use [plumber::pr()].
#' 
#' @param file Plumber file as passed to [plumber::pr()].
#' @param ... Any other argument to pass to [plumber::pr()].
#' @param latency Pass a character string to use as metric name
#' to track request latency. Leave on `NULL` to not track.
#' 
#' @export 
prTitan <- function(file = NULL, ..., latency = NULL){
  checkInstalled("plumber")

  pr <- plumber::pr(file, ...)

  if(!is.null(latency))
    pr <- plumber::pr_hook(pr, "preroute", function(req){
      req$TITAN_START <- Sys.time()
    })
  

  pr <- plumber::pr_hook(pr, "postroute", function(req, res){

    if(!is.null(latency)){
      latencyHist <- Histogram$new(
        latency,
        "Time it takes to serve requests (ms)",
        predicate = requestLatency,
        labels = c("method", "path", "status")
      )

      diff <- Sys.time() - req$TITAN_START

      latencyHist$observe(
        diff,
        method = req$REQUEST_METHOD,
        path = req$PATH_INFO,
        status = as.character(res$status)
      )
    }

  })

  pr <- plumber::pr_get(pr, "/metrics", plumberHandler)

  pr
}

requestLatency <- function(val){
  v <- as.numeric(val)

  if(v < .005)
    return(bucket("5", val))

  if(v < .01)
    return(bucket("10", val))  

  if(v < .1)
    return(bucket("100", val)) 

  if(v < .3)
    return(bucket("500", val)) 

  if(v < .5)
    return(bucket("500", val)) 

  if(v < 1)
    return(bucket("1000", val))  

  if(v < 2)
    return(bucket("2000", val))

  if(v < 3)
    return(bucket("2000", val))  

  bucket("+inf", val)
}
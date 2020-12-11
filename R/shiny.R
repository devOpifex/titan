#' @importFrom utils getFromNamespace
res <- getFromNamespace("httpResponse", "shiny")

#' Serve Application with metrics
#' 
#' @param ui,server UI definition and server function
#' as passed to [shiny::shinyApp()].
#' @param ... Any other arguments passed to [shiny::shinyApp()].
#' @param inputs Pass a character string to use as metric name
#' to track input changes. Leave on `NULL` to not track.
#' @param visits Pass a character string to use as metric name
#' to track the number of visits. Leave on `NULL` to not track.
#' @param concurrent Pass a character string to use as metric name
#' to track the number of concurrent users. 
#' Leave on `NULL` to not track.
#' @param duration Pass a character string to use as metric name
#' to track session duration. Leave on `NULL` to not track.
#' 
#' @export
titanApp <- function(ui, server, ..., inputs = NULL, visits = NULL,
  concurrent = NULL, duration = NULL){
  # create native app
  app <- shiny::shinyApp(ui, server, ...)

  # defaults
  inputCounter <- NULL
  visitsCounter <- NULL
  concurrentGauge <- NULL
  durationHist <- NULL

  if(!is.null(inputs))
    inputCounter <- Counter$new(
      inputs,
      "Number of times inputs were triggered",
      labels = "name"
    )

  if(!is.null(visits))
    visitsCounter <- Counter$new(
      visits,
      "Number of visits to the application"
    )

  if(!is.null(concurrent))
    concurrentGauge <- Gauge$new(
      concurrent,
      "Number of concurrent users"
    )

  if(!is.null(duration)){
    binit <- function(val){

      v <- as.numeric(val)

      if(v < 30)
        return(bucket("30", v))

      if(v < 45)
        return(bucket("45", v))

      if(v < 60)
        return(bucket("60", v))

      if(v < 120)
        return(bucket("120", v))

      if(v < 300)
        return(bucket("300", v))

      if(v < 600)
        return(bucket("600", v))

      if(v < 1200)
        return(bucket("1200", v))

      if(v < 1800)
        return(bucket("1800", v))

      bucket("+inf", v)
    }

    durationHist <- Histogram$new(
      duration,
      "Session duration",
      predicate = binit
    )
  }

  # hijack server function
  serverFnSource <- app$serverFuncSource()

  app$serverFuncSource <- function(){
    function(input, output, session){

      # duration
      if(!is.null(durationHist))
        start <- Sys.time()

      # increment
      if(!is.null(concurrentGauge))
        concurrentGauge$inc()

      # track inputs
      if(!is.null(inputCounter)){
        session$onInputReceived(function(val){
          inputNames <- names(val)

          sapply(inputNames, function(n){
            inputCounter$inc(1, name = n)
          })

          return(val)
        })
      }

      # track visits
      if(!is.null(visitsCounter))
        visitsCounter$inc()

      # onsessionend
      onEnd <- function(concurrentGauge, durationHist){
        return(
          function(){
            if(!is.null(concurrentGauge))
              concurrentGauge$dec()

            if(!is.null(durationHist)){
              end <- Sys.time()
              diff <- end - start
              durationHist$observe(diff)
            }
          }
        )
      }

      onSessionEnd <- onEnd(concurrentGauge, durationHist)
      shiny::onSessionEnded(onSessionEnd)

      app <- tryCatch(serverFnSource(input, output, session), error = function(e) e)
      
      if(inherits(app, "error"))
        serverFnSource(input, output)
    }
  }

  # get handler
  handlerManager <- getFromNamespace("handlerManager", "shiny")

  # serve metrics
  handler <- function(req){
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

  # add handler
  handlerManager$addHandler(handler, "/metrics")

  return(app)
}

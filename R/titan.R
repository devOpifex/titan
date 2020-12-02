registry <- new.env(hash = TRUE)

#' Registry
#' 
#' @importFrom assertthat assert_that
#' 
#' @export 
Titan <- R6::R6Class(
  "Titan",
  public = list(
    initialize = function(namespace = NULL){

      if(!is.null(namespace))
        namespace <- sprintf("%s_", namespace)
      
      private$.namespace <- namespace
    },
    counter = function(name, help, label = NULL){
      Counter$new(name, help, label = NULL)
    },
    runApp = function(app){
      original <- app$httpHandler

      app$httpHandler <- function(req){
        if(req$PATH_INFO == "/metrics"){
          resp <- private$.render()
          fn <- getFromNamespace("httpResponse", "shiny")
          return(
            fn(200, content = resp, content_type = "text/plain")
          )
        }
        original(req)
      }

      return(app)
    }
  ),
  private = list(
    .namespace = "",
    .storage = function(x, val){

      nm <- sprintf("%s%s", private$.namespace, x)

      if(missing(val))
        return(registry[[nm]])

      registry[[nm]] <- val
    },
    .render = function(){
      metrics <- ls(registry)

      resp <- ""
      for(i in 1:length(metrics)){
        m <- registry[[metrics[i]]]$retrieve()

        h <- sprintf("#HELP %s%s %s\n", private$.namespace, m$name, m$help)
        t <- sprintf("#TYPE %s%s %s\n", private$.namespace, m$name, m$type)
        v <- sprintf("%s%s %s\n", private$.namespace, m$name, m$value)

        resp <- sprintf("%s%s%s", h, t, v)
      }

      return(resp)
    }
  )
)

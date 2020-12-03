registry <- new.env(hash = TRUE)

#' Registry
#' 
#' @importFrom assertthat assert_that
#' 
#' @export 
Titan <- R6::R6Class(
  "Titan",
  public = list(
#' @details Initialise a registry
#' @param namespace Namespace to prefix all metric
#' names from this registry.
    initialize = function(namespace = NULL){

      if(!is.null(namespace))
        namespace <- sprintf("%s_", namespace)
      
      private$.namespace <- namespace
    },
#' @details Create a counter
#' @param name Name of the counter, must be unique
#' and match the following regex 
#' `[a-zA-Z_:][a-zA-Z0-9_:]*`.
#' @param help Help text describing the counter.
    counter = function(name, help){
      Counter$new(name, help)
    },
#' @details Runs shiny application with titan.
#' 
#' Runs the application and serves the metrics
#' on the `/metrics` endpoint.
#' 
#' @param app An object of class `shiny.appobj`
#' as returned by [shiny::shinyApp()].
#' 
#' @return A modified version of the shiny application.
    runApp = function(app){
      assert_that(is_app(app))
      original_http_handler <- app$httpHandler

      app$httpHandler <- function(req){
        if(req$PATH_INFO == "/metrics"){
          resp <- private$.render()
          return(http_response(resp))
        }
        original_http_handler(req)
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
        m <- registry[[metrics[i]]]$render(private$.namespace)
        resp <- sprintf("%s%s", resp, m)
      }

      return(resp)
    }
  )
)

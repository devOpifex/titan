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
      Counter$new(name, help, namespace = private$.namespace)
    }
  ),
  private = list(
    .namespace = ""
  )
)

storage = function(x, val, namespace = ""){

  nm <- sprintf("%s%s", namespace, x)

  if(missing(val))
    return(registry[[nm]])

  registry[[nm]] <- val
}

#' With Titan
#' 
#' Run a shiny application with titan.
#' 
#' @param app An object of class `shiny.appobj`
#' as returned by [shiny::shinyApp()].
#' 
#' @return A modified version of the shiny application.
#' 
#' @export
withTitan <- function(app){
  assert_that(is_app(app))
  original_http_handler <- app$httpHandler

  app$httpHandler <- function(req){
    if(req$PATH_INFO == "/metrics"){
      resp <- render_metrics()
      return(http_response(resp))
    }
    original_http_handler(req)
  }

  return(app)
}

#' Titan App
#'
#' Run a shiny application with titan.
#' 
#' @param ... Arguments passed to [shiny::shinyApp()]. 
#' 
#' @export
#' @importFrom shiny shinyApp
titanApp <- function(...){
  app <- shinyApp(...)
  withTitan(app)
}

#' Render the recorded metrics
#' 
#' Loops over the registry to render the metrics for prometheus.
#' 
#' @noRd 
#' @keywords internal
render_metrics <- function(){
  metrics <- ls(registry)

  resp <- ""
  for(i in 1:length(metrics)){
    m <- registry[[metrics[i]]]$render()
    resp <- sprintf("%s%s", resp, m)
  }

  return(resp)
}
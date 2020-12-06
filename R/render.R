#' With Titan
#' 
#' Run a shiny application with titan.
#' 
#' @param app An object of class `shiny.appobj`
#' as returned by [shiny::shinyApp()].
#' 
#' @return A modified version of the shiny application.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export
withTitan <- function(app){
  originalHttpHandler <- app$httpHandler

  app$httpHandler <- function(req){
    if(req$PATH_INFO == "/metrics"){
      resp <- renderMetrics()
      return(httpResponse(resp))
    }
    originalHttpHandler(req)
  }

  return(app)
}

#' Titan App
#'
#' Run a shiny application with titan.
#' 
#' @param ... Arguments passed to [shiny::shinyApp()]. 
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export
#' @importFrom shiny shinyApp
titanApp <- function(...){
  app <- shinyApp(...)
  withTitan(app)
}

#' Titan Plumber
#' 
#' Serve titan metrics for plumber
#' 
#' @export 
titanPlumber <- function(){
  renderMetrics()
}

#' Render the recorded metrics
#' 
#' Loops over the registry to render the metrics for prometheus.
#' 
#' @noRd 
#' @keywords internal
renderMetrics <- function(){
  metrics <- ls(titanCollector)

  resp <- ""
  for(i in 1:length(metrics)){
    m <- titanCollector[[metrics[i]]]$renderMetric()
    resp <- sprintf("%s%s", resp, m)
  }

  return(resp)
}

#' Reset
#' 
#' Resets all titan counters, gauges, histograms, and summaries.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export 
resetTitan <- function(){
  rm(list = ls(titanCollector), envir = titanCollector)
  invisible()
}

#' Preview metrics
#' 
#' Preview the metrics by printing on the screen the 
#' metrics as will be served by the endpoint.
#' 
#' @export 
previewMetrics <- function(){
  cat(renderMetrics())
}
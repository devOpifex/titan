#' @importFrom utils getFromNamespace
res <- getFromNamespace("httpResponse", "shiny")

#' Serve Application with metrics
#' 
#' @param ui,server UI definition and server function
#' as passed to [shiny::shinyApp()].
#' @param ... Any other arguments passed to [shiny::shinyApp()].
#' 
#' @export
titanApp <- function(ui, server, ...){
  app <- shiny::shinyApp(ui, server, ...)

  handlerManager <- getFromNamespace("handlerManager", "shiny")

  handler <- function(req){
    if(!req$PATH_INFO == "/metrics")
      return()

    res(200, "text/plain", renderMetrics())
    
  }

  handlerManager$addHandler(handler, "/metrics")

  return(app)
}

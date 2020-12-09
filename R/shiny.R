res <- getFromNamespace("httpResponse", "shiny")

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

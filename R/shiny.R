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

  handlerManager$addHandler(handler, "/metrics")

  return(app)
}

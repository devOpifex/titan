# httpResponse is not exported
shinyResponse <- getFromNamespace("httpResponse", "shiny")

#' HTTP Response
#' 
#' Returns an httpuv plain text response.
#' 
#' @param content Content of the response. 
#' 
#' @noRd 
#' @keywords internal
httpResponse <- function(content){
  shinyResponse(
    200, 
    content = content, 
    content_type = "text/plain"
  )
}

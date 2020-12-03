# httpResponse is not exported
httpResponse <- getFromNamespace("httpResponse", "shiny")

#' HTTP Response
#' 
#' Returns an httpuv plain text response.
#' 
#' @param content Content of the response. 
#' 
#' @noRd 
#' @keywords internal
http_response <- function(content){
  httpResponse(
    200, 
    content = content, 
    content_type = "text/plain"
  )
}
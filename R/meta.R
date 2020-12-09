#' Render Metadata
#' 
#' Render metadata.
#' 
#' @param name Name of the metric.
#' @param text Text to fill in, help text, metric type, or unit.
#' 
#' @noRd 
#' @keywords internal
renderMeta <- function(name, text, type = c("type", "help", "unit")){
  if(is.null(text))
    return("")

  type <- match.arg(type)
  type <- toupper(type)

  sprintf("# %s %s %s\n", type, name, text)
}

#' @noRd 
#' @keywords internal
renderHelp <- function(name, text){
  renderMeta(name, text, "help")
}

#' @noRd 
#' @keywords internal
renderType <- function(name, text){
  renderMeta(name, text, "type")
}

#' @noRd 
#' @keywords internal
renderUnit <- function(name, text){
  renderMeta(name, text, "unit")
}

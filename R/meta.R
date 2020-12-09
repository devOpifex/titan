Value <- R6::R6Class(
  "Value", 
  public = list(
    initialize = function(name, value, labels = NULL){
      private$.name <- name
      private$.value <- value
      private$.labels <- labels
    },
    render = function(){
      if(!is.null(private$.labels)) {
        sprintf(
          "%s %s %s\n",
          private$.name,
          private$.labels,
          private$.value
        )
      }else {
        sprintf(
          "%s %s\n",
          private$.name,
          private$.value
        )
      }
    }
  ),
  private = list(
    .name = "",
    .value = 0,
    .labels = NULL
  )
)

renderMeta <- function(name, text, type = c("type", "help", "unit")){
  if(is.null(text))
    return("")

  type <- match.arg(type)
  type <- toupper(type)

  sprintf("# %s %s %s\n", type, name, text)
}

renderHelp <- function(name, text){
  renderMeta(name, text, "help")
}

renderType <- function(name, text){
  renderMeta(name, text, "type")
}

renderUnit <- function(name, text){
  renderMeta(name, text, "unit")
}

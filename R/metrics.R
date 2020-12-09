Metric <- R6::R6Class(
  "Metric",
  public = list(
    initialize = function(name, help, labels = NULL, unit = NULL,
      type = c("gauge", "counter", "histogram", "summary"),
      renderMeta = TRUE){

        # store name we need it later
        private$.name <- name
        private$.renderMeta <- renderMeta

        # render those, no need to re-render at every ping
        private$.help <- renderHelp(name, help)
        private$.unit <- renderUnit(name, unit)
        private$.type <- renderType(name, match.arg(type))

        # allow NULL
        if(is.null(labels))
          labels <- c()

        # force character
        labels <- as.character(labels)
        # order for upsert to work correctly
        private$.labels <- orderLabels(labels) 
    },
    set = function(val, ...){
      name <- private$.makeLabelName(...)
      private$.values[[name]] <- val

      invisible(self)
    },
    get = function(...){
      name <- private$.makeLabelName(...)
      private$.values[[name]] %||% 0
    },
    inc = function(val = 1, ...){
      current <- self$get(...)
      newValue <- current + val
      self$set(newValue, ...)

      invisible(self)
    },
    dec = function(val, ...){
      current <- self$get(...)
      newValue <- current - val
      self$set(newValue, ...)

      invisible(self)
    },
    render = function(){
      # no value return nothing
      if(length(private$.values) == 0)
        return("")

      # render values
      if(length(private$.values) == 1){
        values <- paste(
          private$.name, 
          private$.values
        )
      } else {
        values <- paste(
          private$.name, 
          names(private$.values), 
          private$.values
        )
      }

      values <- paste0(values, collapse = "\n")

      # render meta
      if(private$.renderMeta){
        meta <- sprintf(
          "%s%s%s",
          private$.help,
          private$.type,
          private$.unit 
        )

        values <- paste0(meta, values)
      }

      return(values)
    }
  ),
  private = list(
    .registry = NULL,
    .values = list(),
    .name = "",
    .help = "",
    .labels = c(),
    .unit = "",
    .type = "",
    .renderMeta = TRUE,
    .makeLabelName = function(...){
      labels <- c(...)
      
      private$.validateLabels(labels)

      if(length(labels) == 0)
        labels <- ""

      labels <- orderLabels(labels)

      values <- paste0(
        names(labels), '="', unname(labels), '"', 
        collapse = ","
      )

      paste0("{", values, "}")
    },
    .validateLabels = function(labels){
      if(length(private$.labels) != length(labels))
        stop("Aaah")

      if(length(private$.labels) == 0 && length(labels) == 0)
        return()

      if(length(labels) != length(private$.labels))
        stop("Not enough labels")

      match <- all(names(labels) %in% private$.labels)

      if(!match)
        stop("labels missing")
    }
  )
)

orderLabels <- function(labels){
  labels[order(labels)]
}

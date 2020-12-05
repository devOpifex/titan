#' Metric
#' 
#' Metric system build on top of the storage.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @noRd 
#' @keywords internal
Metric <- R6::R6Class(
  "Metric",
  inherit = Store,
  public = list(
    initialize = function(labels){
      super$initialize(labels)
      private$.id <- generateId()
    },
    type = function(type = c("counter", "gauge", "histogram", "summary")){
      private$.type <- match.arg(type)
      invisible(self)
    },
    name = function(text){
      stopMissing(text, "name")
      private$checkName(text)
      private$.name <- text
      invisible(self)
    },
    help = function(text){
      stopMissing(text, "help")
      private$.help <- text
      invisible(self)
    },
    print = function(){
      cat("A", private$.type, "\n")
    },
    renderMetric = function(){
      help <- sprintf("# HELP %s %s\n", private$.name, private$.help)
      type <- sprintf("# TYPE %s %s\n", private$.name, private$.type)
      labels <- super$renderLabel(private$.name)
      sprintf("%s%s%s", help, type, labels)
    }
  ),
  private = list(
    .id = "",
    .name = "",
    .help = "",
    .type = "counter",
    checkName = function(name){
      hasSpace <- grep("\\s", name)
      doubleUnderscore <- grepl("^__", name)
      if(any(hasSpace, doubleUnderscore))
        stop(
          "Incorrect name, may not start with `__` or include spaces", 
          call. = FALSE
        )
    }
  )
)

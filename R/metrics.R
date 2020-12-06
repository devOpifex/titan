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
    initialize = function(name, help, type = c("counter", "gauge", "histogram", "summary"), labels = NULL){
      stopIfMissing(name)
      stopIfMissing(help)

      super$initialize(labels)

      private$.name <- name
      private$checkName()
      private$.help <- help
      private$.id <- generateId()
      private$.type <- match.arg(type)
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
    checkName = function(){
      name <- private$.name
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

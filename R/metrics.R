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
    initialize = function(name, help, type = c("counter", "gauge", "histogram", "summary"), labels = NULL, render = c("h", "t", "v")){
      stopIfMissing(name)
      stopIfMissing(help)

      super$initialize(labels)

      private$.render <- render
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
      output <- ""

      if("h" %in% private$.render){
        help <- sprintf(
          "# HELP %s %s\n", 
          private$.name, 
          private$.help
        )
        output <- paste0(output, help)
      }

      if("t" %in% private$.render){
        type <- sprintf("# TYPE %s %s\n", private$.name, private$.type)
        output <- paste0(output, type)
      }

      if("v" %in% private$.render){
        labels <- super$renderLabel(private$.name)
        output <- paste0(output, labels)
      }

      return(output)
    }
  ),
  private = list(
    .id = "",
    .name = "",
    .help = "",
    .type = "counter",
    .render = c("h", "t", "v"),
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

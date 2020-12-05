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
    }
  ),
  private = list(
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

#' Counter
#' 
#' Counter for Prometheus. The value of a counter,
#' can only increase over time.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export
Counter <- R6::R6Class(
  "Counter",
  public = list(
#' @details Initialise a counter
#' @param name The name of the counter.
#' @param help The help text discribing the counter.
#' @param labels Labels to use for this counter, a
#' character vector.
#' 
#' @examples 
#' c <- Counter$new(
#'  "refresh_btn_total", 
#'  "Button that refreshes the data",
#'  labels = c("module")
#' ) 
#' 
#' c$inc(1, module = "homepage")
#' c$inc(1, module = "tableview")
    initialize = function(name, help, labels = NULL){
      private$.metric <- Metric$
        new(labels)$
        type("counter")$
        name(name)$
        help(help)
    },
#' @details Increase the value of the counter.
#' 
#' @param val Value to increase the counter by.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c <- Counter$new(
#'  "refresh_btn_total", 
#'  "Loads data button count",
#'  labels = c("module")
#' ) 
#' 
#' c$inc(1, module = "homepage")
#' c$inc(1, module = "tableview")
    inc = function(val = 1, ...){
      private$.value <- private$.value + val
      private$.metric$setValue(private$.value, ...)
      invisible(self)
    },
#' @details Set the counter to a certain value.
#' 
#' @param val Value to set the counter to.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c <- Counter$new(
#'  "refresh_btn_total", 
#'  "Loads data button count"
#' ) 
#' 
#' c$set(1)
#' c$set(5)
#' 
#' # will throw warning: 3 < 5
#' \dontrun{c$set(3)}
    set = function(val, ...){
      if(missing(val)){
        warnMissing(val)
        return(invisible())
      }

      if(val < private$.value){
        warning(
          "`val` too low, must be higher than: ", 
          private$.value, " [ignoring]", 
          call. = FALSE
        )
        return(invisible())
      }
      private$.value <- val
      private$.metric$setValue(private$.value, ...)
      invisible(self)
    },
#' @details Print the counter.
    print = function(){
      print(private$.metric)
    }
  ),
  private = list(
    .value = 0,
    .metric = NULL
  )
)

#' Warn an argument is missing
#' 
#' Warn that an argument is missing.
#' 
#' @param what Name of argument (string) that is missing.
#' 
#' @noRd 
#' @keywords internal
warnMissing <- function(what){
  warning("Missing `", what, "` [ignoring]", call. = FALSE)
}

#' @noRd 
#' @keywords internal
stopMissing <- function(var, what){
  if(missing(var))
    stop("Missing `", what, "`", call. = FALSE)
}
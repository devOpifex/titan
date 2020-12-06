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
  inherit = Registry,
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
      super$initialize(name)
      
      metric <- Metric$new(name, help, "counter", labels)

      super$store(metric)
    },
#' @details Increase the value of the counter.
#' 
#' @param val Value to increase the counter by.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' cnter <- Counter$new(
#'  "load_btn_total", 
#'  "Loads data button count",
#'  labels = "module"
#' ) 
#' 
#' cnter$inc(1, module = "homepage")
#' cnter$inc(1, module = "tableview")
    inc = function(val = 1, ...){
      value <- super$get()$getCurrentValue(...) + val
      super$get()$setValue(value, ...)
      invisible(self)
    },
#' @details Set the counter to a certain value.
#' 
#' @param val Value to set the counter to.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c1 <- Counter$new(
#'  "relaod_btn_total", 
#'  "Re-Loads data button count"
#' ) 
#' 
#' c1$set(1)
#' c1$set(5)
#' 
#' # will throw warning: 3 < 5
#' \dontrun{c$set(3)}
    set = function(val, ...){
      if(missing(val)){
        warnIfMissing(val)
        return(invisible())
      }

      if(val < super$get()$getCurrentValue(...)){
        warning(
          "`val` too low, must be higher than: ", 
          private$.value, " [ignoring]", 
          call. = FALSE
        )
        return(invisible())
      }
      super$get()$setValue(val, ...)
      invisible(self)
    },
#' @details Print the counter.
    print = function(){
      print(super$get())
    }
  ),
  private = list(
    .id = "",
    .metric = NULL
  )
)

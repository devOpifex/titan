#' Gauge
#' 
#' Gauge for Prometheus. The value of a gauge,
#' can go up or down, as opposed to counters.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export
Gauge <- R6::R6Class(
  "Gauge",
  inherit = Registry,
  public = list(
#' @details Initialise a 
#' @param name The name of the gauge.
#' @param help The help text discribing the gauge.
#' @param labels Labels to use for this gauge, a
#' character vector.
#' 
#' @examples 
#' c <- Gauge$new(
#'  "refresh_btn_total", 
#'  "Button that refreshes the data",
#'  labels = c("module")
#' ) 
#' 
#' c$inc(1, module = "homepage")
#' c$inc(1, module = "tableview")
    initialize = function(name, help, labels = NULL){
      super$initialize(name)
      
      metric <- Metric$new(name, help, "gauge", labels)

      super$store(metric)
    },
#' @details Increase the value of the gauge.
#' 
#' @param val Value to increase the gauge by.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c <- Gauge$new(
#'  "refresh_btn_total", 
#'  "Loads data button count",
#'  labels = c("module")
#' ) 
#' 
#' c$inc(1, module = "homepage")
#' c$inc(1, module = "tableview")
    inc = function(val = 1, ...){
      value <- super$get()$getCurrentValue(...) + val
      super$get()$setValue(value, ...)
      invisible(self)
    },
#' @details Decrease the value of the gauge.
#' 
#' @param val Value to decrease the gauge by.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c <- Gauge$new(
#'  "refresh_btn_total", 
#'  "Loads data button count",
#'  labels = c("module")
#' ) 
#' 
#' c$inc(5)
#' c$dec(1)
#' c$dec()
    dec = function(val = 1, ...){
      value <- super$get()$getCurrentValue(...) - val
      super$get()$setValue(value, ...)
      invisible(self)
    },
#' @details Set the gauge to a certain value.
#' 
#' @param val Value to set the gauge to.
#' @param ... Named label and value pair(s). 
#' 
#' @examples 
#' c <- Gauge$new(
#'  "visitors_total", 
#'  "Total visitors right now"
#' ) 
#' 
#' c$set(9)
#' c$set(4)
#' 
#' # will throw warning: 3 < 5
#' \dontrun{c$set(3)}
    set = function(val, ...){
      if(missing(val)){
        warnIfMissing(val)
        return(invisible())
      }
      super$get()$setValue(val, ...)
      invisible(self)
    },
#' @details Print the gauge.
    print = function(){
      print(super$get())
    }
  ),
  private = list(
    .id = "",
    .metric = NULL
  )
)

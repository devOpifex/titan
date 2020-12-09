#' Counter
#' 
#' Create a new counter.
#' 
#' @export 
Counter <- R6::R6Class(
  "Counter",
  inherit = MetricInterface,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
    initialize = function(name, help, labels = NULL, unit = NULL){
      super$initialize(name, help, labels = labels, unit = unit, type = "counter")
    },
#' @details Set the metrics to a specific value
#' @param val Value to set the metric.
#' @param ... Key value pairs of labels.
    set = function(val, ...){
      current <- super$get()

      if(val < current)
        stop("Less than current")

      super$set(val, ...)
    }
  )
)

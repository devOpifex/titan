#' Gauge
#' 
#' @export 
Gauge <- R6::R6Class(
  "Gauge",
  inherit = MetricInterface,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
    initialize = function(name, help, labels = NULL, unit = NULL){
      super$initialize(name, help, labels = labels, unit = unit, type = "gauge")
    }
  )
)

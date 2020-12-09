Gauge <- R6::R6Class(
  "Gauge",
  inherit = Metric,
  public = list(
    initialize = function(name, help, labels = NULL, unit = NULL){
      super$initialize(name, help, labels = labels, unit = unit, type = "gauge")
    }
  )
)

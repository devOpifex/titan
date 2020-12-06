Histogram <- R6::R6Class(
  "Histogram",
  inherit = Registry,
  public = list(
    initialize = function(name, help, labels){
      stopIfMissing(labels, "labels")

      super$initialize()
      
      metric <- Metric$
        new(name, help, "histogram", labels)

      super$store(metric)
    }
  )
)
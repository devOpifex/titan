Histogram <- R6::R6Class(
  "Histogram",
  inherit = Registry,
  public = list(
    initialize = function(name, help, labels, predicate){
      stopIfMissing(labels)
      stopIfMissing(predicate)

      super$initialize()
      
      metric <- Metric$
        new(name, help, "histogram", labels)

      super$store(metric)
    }
  )
)
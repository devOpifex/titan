Counter <- R6::R6Class(
  "Counter",
  inherit = MetricInterface,
  public = list(
    initialize = function(name, help, labels = NULL, unit = NULL){
      super$initialize(name, help, labels = labels, unit = unit, type = "counter")
    },
    set = function(val, ...){
      current <- super$get()

      if(val < current)
        stop("Less than current")

      super$set(val, ...)
    }
  )
)

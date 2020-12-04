Store <- R6::R6Class(
  "Store",
  public = list(
    initialize = function(name, type = c("counter", "gauge", "histogram", "summary"), labels = ""){
      df <- data.frame(labels = labels, values = 0)
      private$.data <- df
      private$.name <- name
    },
    getName = function(){
      private$.name
    }
  ),
  private = list(
    .name = "",
    .type = "counter",
    .data = data.frame(),
    setVal = function(val, label = ""){
      private$.data[private$.data$labels == label, "values"] <- val
      invisible(self)
    },
    getVal = function(label = ""){
      private$.data[private$.data$labels == label, "values"]
    }
  )
)
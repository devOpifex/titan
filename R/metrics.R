Metric <- R6::R6Class(
  "Metric",
  inherit = Store,
  private = list(
    .type = "counter",
    .store = NULL
  )
)

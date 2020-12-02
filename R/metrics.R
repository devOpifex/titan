#' Metrics
#' Store Prometheus metrics
#' @importFrom assertthat assert_that
Metric <- R6::R6Class(
  "Metric",
  inherit = Titan,
  public = list(
    initialize = function(name, help, type = c("counter", "gauge", "histogram", "summary"), label = NULL){
      private$.name <- name
      private$.help <- help
      private$.label <- label
      private$.type <- match.arg(type)
    },
    value = function(value){
      assert_that(not_missing(value))
      private$.value <- value
      invisible(self)
    },
    retrieve = function(){
      list(
        name = private$.name,
        label = private$.label,
        help = private$.help,
        type = private$.type,
        value = private$.value
      )
    }
  ),
  private = list(
    .name = "",
    .help = "",
    .type = "counter",
    .value = 0,
    .label = NULL
  )
)
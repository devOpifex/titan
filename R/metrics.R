#' Metrics
#' Store Prometheus metrics
#' @importFrom assertthat assert_that
Metric <- R6::R6Class(
  "Metric",
  inherit = Titan,
  public = list(
#' @details Create a new metric
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param type Metric type.
    initialize = function(name, help, type = c("counter", "gauge", "histogram", "summary")){
      private$.name <- name
      private$.help <- help
      private$.type <- match.arg(type)
    },
#' @details Add a label to the metric
#' @param name Label name.
#' @param value Value of the label.
    label = function(name, value){
      assert_that(not_missing(name), not_missing(value))
      lab <- list()
      lab[[name]] <- value
      private$.labels <- append(private$.labels, lab)
    },
#' @details Set the metric value
#' @param value Value to set the metric to.
    value = function(value){
      assert_that(not_missing(value))
      private$.value <- value
      invisible(self)
    },
#' @details Retrieve the metrics.
    retrieve = function(){
      list(
        help = private$.help,
        type = private$.type,
        name = private$.name,
        labels = private$.labels,
        value = private$.value
      )
    },
#' @details Render the metric
#' @param ns The namespace.
    render = function(ns){
      h <- sprintf("#HELP %s%s %s\n", ns, private$.name, private$.help)
      t <- sprintf("#TYPE %s%s %s\n", ns, private$.name, private$.type)
      v <- sprintf("%s%s %s\n", ns, private$.name, private$.value)
      paste0(h, t, v)
    }
  ),
  private = list(
    .name = "",
    .help = "",
    .type = "counter",
    .value = 0,
    .labels = NULL
  )
)
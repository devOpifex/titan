#' Binned
#' 
#' Superclass for binned metrics: [Histogram] and [Summary],
#' used for convenience and DRY, do not use directly.
#' 
#' @export
Binned <- R6::R6Class(
  "Binned",
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
#' @param type Metric type.
#' @param predicate Predicate function to bin observations.
    initialize = function(name, help, predicate, 
      labels = NULL, unit = NULL, 
      type = c("histogram", "summary")){

        type <- match.arg(type)
        private$.type <- type
        
        # names
        nameCount <- sprintf("%s_count", name)
        nameSum <- sprintf("%s_sum", name)

        bucketLabel <- ifelse(type == "histogram", "le", "quantile")
        labelsBucket <- c(labels, bucketLabel)

        # predicate
        if(!is.function(predicate))
          stop("Predicate must be a function")
        private$.predicate <- predicate

        private$.buckets <- MetricInterface$new(
          name, help, labels = labelsBucket, unit = unit,
          type = type
        )

        private$.count <- MetricInterface$new(
          nameCount, help, labels = labels, unit = unit,
          type = "counter", renderMeta = FALSE
        )

        private$.sum <- MetricInterface$new(
          nameSum, help, labels = labels, unit = unit,
          type = "counter", renderMeta = FALSE
        )
    },
#' @details Observe
#' @param val Value to observe and bin using the `predicate`.
#' @param ... Key value pair of labels.
    observe = function(val, ...){
      pred <- private$.predicate(val)

      if(!is.bucket(pred)){
        warning(
          "[IGNORING] `predicate` must return an object of class `bucket`",
          call. = FALSE
        )
        return(invisible())
      }

      if(private$.type == "histogram")
        args <- list(1, le = pred$label, ...)
      else 
        args <- list(pred$value, quantile = pred$label, ...)
      
      do.call(private$.buckets$inc, args)

      private$.count$inc(1)
      private$.sum$inc(pred$value)
    }
  ),
  private = list(
    .buckets = NULL,
    .count = NULL,
    .sum = NULL,
    .predicate = NULL,
    .type = "histogram"
  )
)

#' Histogram
#' 
#' Create a histogram to bin observed metrics. Values
#' observed at preprocessed with the `predicate` function
#' passed at instantiation. This `predicate` function,
#' **must** return an object of class `bucket`, see
#' [bucket()].
#' 
#' While the [Histogram] counts up the values in each 
#' bucket, the [Summary] sums these up over time.
#' 
#' @export 
Histogram <- R6::R6Class(
  "Histogram",
  inherit = Binned,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
#' @param predicate Predicate function to bin observations.
    initialize = function(name, help, predicate, 
      labels = NULL, unit = NULL){
      
      super$initialize(
        name, help, predicate, labels, unit, "histogram"
      )

    }
  )
)

#' Summary
#' 
#' Create a histogram to bin observed metrics. Values
#' observed at preprocessed with the `predicate` function
#' passed at instantiation. This `predicate` function,
#' **must** return an object of class `bucket`, see
#' [bucket()].
#' 
#' While the [Histogram] counts up the values in each 
#' bucket, the [Summary] sums these up over time.
#' 
#' @export 
Summary <- R6::R6Class(
  "Summary",
  inherit = Binned,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
#' @param predicate Predicate function to bin observations.
    initialize = function(name, help, predicate, 
      labels = NULL, unit = NULL){
      
      super$initialize(
        name, help, predicate, labels, unit, "summary"
      )

    }
  )
)

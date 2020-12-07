#' Summary
#' 
#' Create a summary.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export 
Summary <- R6::R6Class(
  "Summary",
  inherit = Registry,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the summary.
#' @param help Help text describing the summary.
#' @param labels Labels to use for the summary, a
#' character vector.
#' @param predicate A callback function that take a 
#' single argument, a numeric vector of length 1 and 
#' returns a [bucket()].
    initialize = function(name, help, predicate, labels = NULL){
      stopIfMissing(predicate)

      super$initialize()

      cntName <- sprintf("%s_count", name)
      sumName <- sprintf("%s_sum", name)
      labelsQuantile <- c(labels, "quantile")

      # buckets & quantiles
      metric <- Metric$new(name, help, "summary", labelsQuantile)
      # sum & count
      count <- Metric$new(cntName, help, "counter", labels, "v")
      sum <- Metric$new(sumName, help, "counter", labels, "v")

      # Store
      super$store(metric)

      # create new registries for sum & count
      regSum <- Registry$new(sumName)$store(sum)
      regCnt <- Registry$new(cntName)$store(count)

      private$.regSum <- regSum
      private$.regCnt <- regCnt
      private$.name <- name
      private$.predicate <- predicate
      private$checkPredicate()
    },
#' @details Observe a value.
#' 
#' This runs the value through the `predicate` and 
#' updates meta data.
#' 
#' @param val Value observed.
#' @param ... Labels.
    observe = function(val, ...){
      if(missing(val)){
        warnIfMissing(val)
        return(invisible())
      }
      
      results <- private$pred(val)
      if(!is.bucket(results)){
        warning(
          "Result from `predicate` is not of class `bucket` [ignoring]", 
          call. = FALSE
        )
        return(invisible())
      }

      current <- super$get()$getCurrentValue(quantile = results$label, ...) %||% 0
      super$get()$setValue(current + results$value, quantile = results$label, ...)

      private$increaseCnt(...)
      private$increaseSum(val, ...)
      
      invisible(self)
    }
  ),
  private = list(
    .regSum = NULL,
    .regCnt = NULL,
    .name = "",
    .predicate = NULL,
    increaseCnt = function(...){
      val <- private$.regCnt$get()$getCurrentValue(...) + 1
      private$.regCnt$get()$setValue(val, ...)
    },
    increaseSum = function(val, ...){
      val <- private$.regSum$get()$getCurrentValue(...) + val
      private$.regSum$get()$setValue(val, ...)
    },
    checkPredicate = function(){
      isFn <- is.function(private$.predicate)

      if(!isFn)
        stop("`predicate` must be a function", call. = FALSE)
    },
    pred = function(x){
      private$.predicate(x)
    }
  )
)

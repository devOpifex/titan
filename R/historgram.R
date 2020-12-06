#' Histogram
#' 
#' Create a histogram.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export 
Histogram <- R6::R6Class(
  "Histogram",
  inherit = Registry,
  public = list(
#' @details Initialise
#' 
#' @param name Name of the histogram.
#' @param help Help text describing the histogram.
#' @param labels Labels to use for the historgram, a
#' character vector.
#' @param predicate A callback function that take a 
#' single argument, a numeric vector of length 1 and 
#' returns a [bucket()].
    initialize = function(name, help, predicate, labels = NULL){
      stopIfMissing(labels)
      stopIfMissing(predicate)

      super$initialize()

      cntName <- sprintf("%s_count", name)
      sumName <- sprintf("%s_sum", name)
      labelsLe <- c(labels, "le")

      # buckets & quantiles
      metric <- Metric$new(name, help, "histogram", labelsLe)
      # sum & count
      count <- Metric$new(cntName, help, "counter", labels, "v")
      sum <- Metric$new(sumName, help, "counter", labels, "v")

      # Store
      super$store(metric)

      # create new registries for sum & count
      regSum <- Registry$new()$store(sum)
      regCnt <- Registry$new()$store(count)

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

      private$increaseCnt(...)
      private$increaseSum(val, ...)

      current <- super$get()$getCurrentValue(le = results$label, ...) %||% 0
      super$get()$setValue(current + 1, le = results$label, ...)

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
      val <- private$.regCnt$get()$getCurrentValue(...) + val
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

#' bucket
#' 
#' Create a Bucket, needed for the `predicate` of
#' the [Histogram] which must return an object of
#' class `bucket`.
#' 
#' @param label Name of the label.
#' @param value Value of the label.
#' @param obj Object to check.
#' 
#' @examples 
#' bucket("0.3", 2)
#' 
#' pred <- function(x){
#'  if(x > .5)
#'    return(bucket("1", x))
#' 
#'  bucket(".5", x)
#' }
#' 
#' result <- pred(.8)
#' is.bucket(result)
#' 
#' @return An object of class `bucket`.
#' 
#' @name bucket
#' @export
bucket <- function(label, value){
  stopIfMissing(label)
  stopIfMissing(value)

  label <- as.character(label)

  if(!is.numeric(value)){
    warning("value of bucket must be a numeric", call. = FALSE)
    return(FALSE)
  }

  pair <- list(label = label[1], value = value[1])
  structure(pair, class = c("bucket", class(pair)))
}

#' @rdname bucket
#' @export
is.bucket <- function(obj){
  if(inherits(obj, "bucket"))
    return(TRUE)
  
  return(FALSE)
}

#' @export 
print.bucket <- function(x, ...){
  cat("bucket:", x$label, "-", x$value)
}

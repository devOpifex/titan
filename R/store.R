#' Storage
#' 
#' Simple storage system for a single metric.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @importFrom dplyr anti_join bind_rows
#' 
#' @noRd 
#' @keywords internal
Store <- R6::R6Class(
  "Store",
  public = list(
    initialize = function(labels = NULL){
      private$.labels <- labels
      private$.data <- initStorage(labels)
    },
    setValue = function(val, ...){
      labels <- labelsOrNull(...)
      match <- private$checkLabelsMatch(labels)
      
      if(!match) return(invisible())

      private$upsert(val, labels)

      invisible(self)
    },
    getData = function(){
      return(private$.data)
    }
  ),
  private = list(
    .labels = NULL,
    .data = data.frame(),
    upsert = function(val, labels = NULL){
      newLabels <- list(value = val, labels)
      newLabels <- dropNulls(newLabels)
      newData <- as.data.frame(newLabels)

      if(is.null(labels)){
        private$.data <- newData
        return()
      }

      old <- anti_join(private$.data, newData, by = private$.labels)
      data <- tryCatch(
        bind_rows(old, newData),
        error = function(e) e
      )

      if(inherits(data, "error")){
        warning(
          "Failed to process metric value - ", 
          data, 
          " [ignoring]",
          call. = FALSE
        )
        return()
      }

      private$.data <- data
    },
    checkLabelsMatch = function(labels = NULL){
      m <- all(private$.labels %in% names(labels))

      if(!m) private$wrongLabels(labels)
      
      return(m)
    },
    wrongLabels = function(labels = NULL){
      existing <- labelToString(private$.labels)
      passed <- labelToString(labels)
      warning(
        "Labels mismatch, must have ", existing, " received ", passed,
        call. = FALSE
      )
    }
  )
)

#' Labels to string
#' 
#' Turns labels to single strings for use in warning messages.
#' 
#' @param labels Vector of labels.
#' 
#' @return A character vector of length one. If `lables` is 
#' `NULL` returns `"none"`.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @noRd 
#' @keywords internal
labelToString <- function(labels = NULL){
  if(is.null(labels))
    return("none")
  lab <- paste(labels, collapse = "`, `")
  paste0("`", lab, "`")
}

#' Labels of NULL
#' 
#' Returns vector of character labels or `NULL`
#' if nothing is passed to `...`.
#' 
#' @param ... Labels to register.
#' 
#' @return Vector of labels or `NULL`.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @noRd 
#' @keywords internal
labelsOrNull <- function(...){
  labs <- list(...)
  if(length(labs) == 0)
    return(NULL)

  return(labs)
}

#' Initialise the Storage
#' 
#' Initialse the storage based on the labels used.
#' 
#' @param labels A vector of labels or `NULL` if none
#' are used. 
#' 
#' @return A `data.frame`.
#' 
#' @noRd 
#' @keywords internal
initStorage <- function(labels = NULL){

  df <- data.frame(value = numeric())
  for(lab in labels){
    df[[lab]] <- character()
  }

  return(df)
}

#' Drop nulls
#' 
#' Removes `NULL` entries from `list`.
#' 
#' @param x A `list`.
#' 
#' @return A modified version of the input `list`.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @noRd 
#' @keywords internal
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}

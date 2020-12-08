#' Storage
#' 
#' Simple storage system for a single metric.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @importFrom dplyr anti_join inner_join bind_rows
#' 
#' @noRd 
#' @keywords internal
Store <- R6::R6Class(
  "Store",
  public = list(
#' @details Initialise a metric storage
#' 
#' @param labels Labels to use for this metric
    initialize = function(labels = NULL){
      private$.labels <- labels
      private$.data <- initStorage(labels)
    },
#' @details Set value of metric
#' @param val Value to give.
#' @param ... Labels and values pairs.
    setValue = function(val, ...){
      labels <- labelsOrNull(...)
      match <- private$checkLabelsMatch(labels)
      
      if(!match) return(invisible())

      private$upsert(val, labels)

      invisible(self)
    },
#' @details Get the data as stored by the class
    getData = function(){
      return(private$.data)
    },
#' @details Get the current value of a metric given labels
#' @param ... Labels and values pairs.
    getCurrentValue = function(...){
      labels <- labelsOrNull(...)
      match <- private$checkLabelsMatch(labels)
      
      if(!match) return(invisible())

      if(is.null(labels))
        return(private$.data$value %||% 0)
      
      newData <- labelsAsDataframe(val = 0, labels)
      newData$value <- NULL
      
      current <- inner_join(private$.data, newData, by = private$.labels)
      
      return(current$value %||% 0)
    }
  ),
  private = list(
    .labels = NULL,
    .data = data.frame(),
    upsert = function(val, labels = NULL){
      newData <- labelsAsDataframe(val, labels)

      # if no labels are used then dataset can
      # simply be replaced
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
    },
    renderLabel = function(name){
      # split labels and values
      labels <- private$.data
      values <- labels$value
      labels$value <- NULL

      if(length(values) == 0)
        values <- "NaN"

      labs <- apply(labels, 1, as.list)
      labs <- lapply(labs, renderLabels)
      string <- paste(name, labs, values, "\n", collapse = "")
      # remove empty string (when no labels are used)
      gsub("  ", " ", string)
    }
  )
)

#' Values and labels as data.frame
#' 
#' Turns values and list of labels (key value pairs)
#' as data.frame.
#' 
#' @param value A numeric vector of length 1.
#' @param labels A `list` of labels.
#' 
#' @noRd 
#' @keywords internal
labelsAsDataframe <- function(val, labels){
  newLabels <- list(value = val, labels)
  newLabels <- dropNulls(newLabels)
  as.data.frame(newLabels)
}

#' Render Labels
#' 
#' Render labels as Prometheus metrics.
#' 
#' @param labels Vector of labels or `NULL`.
#' 
#' @noRd 
#' @keywords internal
renderLabels <- function(labels = NULL){
  if(length(labels) == 0)
    return("")

  labels <- paste0(names(labels), "=\"", labels, "\"", collapse = ",")  

  paste0("{", labels, "}")
}

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

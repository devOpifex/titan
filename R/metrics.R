#' Metrics
#' 
#' @noRd 
#' @keywords internal
Metric <- R6::R6Class(
  "Metric",
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
#' @param type Metric type.
#' @param renderMeta Whether to render the metadata.
    initialize = function(name, help, labels = NULL, unit = NULL,
      type = c("gauge", "counter", "histogram", "summary"),
      renderMeta = TRUE){

        type <- match.arg(type)
        ns <- getTitanNamespace()

        if(!is.null(ns))
          name <- sprintf("%s_%s", ns, name)

        # store name we need it later
        private$.name <- name
        private$.renderMeta <- renderMeta

        # save for retrieval checks
        private$.metricType <- type

        # render those, no need to re-render at every ping
        private$.help <- renderHelp(name, help)
        private$.unit <- renderUnit(name, unit)
        private$.type <- renderType(name, type)

        # allow NULL
        if(is.null(labels))
          labels <- c()

        # force character
        labels <- as.character(labels)
        # order for upsert to work correctly
        private$.labels <- orderLabels(labels) 
    },
#' @details Set the metric to a current value given labels.
#' @param val Value to set the metric.
#' @param ... Key value pairs of labels.
    set = function(val, ...){
      name <- private$.makeLabelName(...)
      private$.values[[name]] <- val

      invisible(self)
    },
#' @details Retrieve the value of a metric given labels
#' @param ... Key value pairs of labels.
    get = function(...){
      name <- private$.makeLabelName(...)
      private$.values[[name]] %||% 0
    },
#' @details Increase the metric to a current value given labels.
#' @param val Value to increase the metric.
#' @param ... Key value pairs of labels.
    inc = function(val = 1, ...){
      current <- self$get(...)
      newValue <- current + val
      self$set(newValue, ...)

      invisible(self)
    },
#' @details Decrease the metric to a current value given labels.
#' @param val Value to decrease the metric.
#' @param ... Key value pairs of labels.
    dec = function(val = 1, ...){
      current <- self$get(...)
      newValue <- current - val
      self$set(newValue, ...)

      invisible(self)
    },
#' @details Retrieve the metric type
    getType = function(){
      private$.metricType
    },
#' @details Render the metric
    render = function(){

      # no value return nothing
      if(length(private$.values) == 0)
        return("")

      values <- paste0(
        private$.name,
        names(private$.values)," ",
        private$.values
      )

      values <- paste0(values, collapse = "\n")

      # render meta
      if(private$.renderMeta){
        meta <- sprintf(
          "%s%s%s",
          private$.help,
          private$.type,
          private$.unit 
        )

        values <- paste0(meta, values)
      }

      paste0(values, sep = "\n", collapse = "")
    }
  ),
  private = list(
    .registry = NULL,
    .values = list(),
    .name = "",
    .help = "",
    .labels = c(),
    .unit = "",
    .type = "",
    .metricType = "",
    .renderMeta = TRUE,
    .makeLabelName = function(...){
      labels <- c(...)
      
      private$.validateLabels(labels)

      if(length(labels) == 0)
        return("")

      labels <- orderLabels(labels)

      values <- paste0(
        names(labels), '="', unname(labels), '"', 
        collapse = ","
      )

      paste0("{", values, "}")
    },
    .validateLabels = function(labels){
      if(length(private$.labels) != length(labels))
        stop("Labels mismatch")

      if(length(private$.labels) == 0 && length(labels) == 0)
        return()

      if(length(labels) != length(private$.labels))
        stop("Not enough labels")

      match <- all(names(labels) %in% private$.labels)

      if(!match)
        stop("labels missing")
    }
  )
)

#' Metrics Interface
#' 
#' Exposed interface to the metrics.
#' 
#' @export
MetricInterface <- R6::R6Class(
  "MetricInterface",
  public = list(
#' @details Initialise
#' 
#' @param name Name of the metric.
#' @param help Help text describing the metric.
#' @param labels Character vector of labels available.
#' @param unit Unit of metric.
#' @param type Metric type.
#' @param renderMeta Whether to render the metadata.
    initialize = function(name, help, labels = NULL, unit = NULL,
      type = c("gauge", "counter", "histogram", "summary"),
      renderMeta = TRUE){

      private$.name <- name

      # don't override!
      existing <- registryGet(name)
      if(!is.null(existing)){
        existingType <- existing$getType()

        if(existingType != type)
          stop("Metric name already used")

        return(self)
      }
      
      registrySet(
        name,
        Metric$new(
          name, help, labels = labels, unit = unit,
          type = type, renderMeta = renderMeta
        )
      )
    },
#' @details Set the metric to a current value given labels.
#' @param val Value to set the metric.
#' @param ... Key value pairs of labels.
    set = function(val, ...){
      registryGet(private$.name)$set(val, ...)
    },
#' @details Retrieve the value of a metric given labels
#' @param ... Key value pairs of labels.
    get = function(...){
      registryGet(private$.name)$get(...)
    },
#' @details Increase the metric to a current value given labels.
#' @param val Value to increase the metric.
#' @param ... Key value pairs of labels.
    inc = function(val = 1, ...){
      registryGet(private$.name)$inc(val, ...)
    },
#' @details Decrease the metric to a current value given labels.
#' @param val Value to decrease the metric.
#' @param ... Key value pairs of labels.
    dec = function(val = 1, ...){
      registryGet(private$.name)$dec(val, ...)
    },
#' @details Render the metric
    render = function(){
      registryGet(private$.name)$render()
    }
  ),
  private = list(
    .name = ""
  )
)

#' Order labels
#' 
#' Orders the labels to ensure they are always stored 
#' in the same order regardless of the order in which
#' they are passed to the various functions. This ensures
#' the "upsert" mechanism works.
#' 
#' @param labels Character vector of labels.
#' 
#' @noRd 
#' @keywords internal
orderLabels <- function(labels){
  labels[order(labels)]
}

# global registry
.registry <- new.env(hash = TRUE)

#' Registry Interface
#' 
#' Light interface to the registry.
#' 
#' @noRd 
#' @keywords internal
registrySet <- function(name, obj){
  .registry[[name]] <- obj
}

#' @noRd 
#' @keywords internal
registryGet <- function(name){
  .registry[[name]]
}

#' @noRd 
#' @keywords internal
registryRmv <- function(name){
  rm(name, envir = .registry) 
}

#' @noRd 
#' @keywords internal
registryCln <- function(){
  rm(list = ls(.registry), envir = .registry)
}

#' Render All Metrics
#' 
#' Renders all metrics from the registry.
#' 
#' @seealso [previewMetrics()] for a more readable
#' output.
#' 
#' @export
renderMetrics <- function(){
  metricNames <- ls(.registry)

  metricsRendered <- lapply(metricNames, function(m){
    .registry[[m]]$render()
  })

  paste0(metricsRendered, collapse = "")

}

#' Preview Metrics
#' 
#' Preview the metrics as are served by titan.
#' 
#' @export 
previewMetrics <- function(){
  cat(renderMetrics())
}

#' Clean Registry
#' 
#' Empties the registry from all metrics.
#' 
#' @export 
cleanRegistry <- function(){
  registryCln()
  options(TITAN_NAMESPACE = NULL)
  options(TITAN_BASIC_AUTH = NULL)
}

#' Set a Namespace
#' 
#' Set a namespace, all metrics name will
#' be preceded by the namespace and an underscore:
#' `namespace_metricName`.
#' 
#' @param name Namespace.
#' 
#' @note Rerun the function to remove the namespace.
#' 
#' @name ns
#' 
#' @export 
setTitanNamespace <- function(name = NULL){
  options(TITAN_NAMESPACE = name)
}

#' @rdname ns
#' @export 
getTitanNamespace <- function(){
  getOption("TITAN_NAMESPACE", NULL)
}
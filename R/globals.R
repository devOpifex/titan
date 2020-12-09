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
#' @export
renderMetrics <- function(){
  metricNames <- ls(.registry)

  metricsRendered <- lapply(metricNames, function(m){
    .registry[[m]]$render()
  })

  paste0(metricsRendered, collapse = "")

}

#' Set a Namespace
#' 
#' Set a namespace, all metrics name will
#' be preceded by the namespace and an underscore:
#' `namespace_metricName`.
#' 
#' @param name Namespace.
#' 
#' @name ns
#' 
#' @export 
setTitanNamespace <- function(name){
  options(TITAN_NAMESPACE = name)
}

#' @rdname ns
#' @export 
getTitanNamespace <- function(){
  getOption("TITAN_NAMESPACE", NULL)
}
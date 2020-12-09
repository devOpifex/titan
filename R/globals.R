# global registry
.registry <- new.env(hash = TRUE)

registrySet <- function(name, obj){
  .registry[[name]] <- obj
}

registryGet <- function(name){
  .registry[[name]]
}

registryRmv <- function(name){
  rm(name, envir = .registry) 
}

registryCln <- function(){
  rm(list = ls(.registry), envir = .registry)
}

renderAll <- function(){
  metricNames <- ls(.registry)

  metricsRendered <- lapply(metricNames, function(m){
    .registry[[m]]$render()
  })

  paste0(metricsRendered, collapse = "")

}

setTitanNamespace <- function(name){
  options(TITAN_NAMESPACE = name)
}

getTitanNamespace <- function(){
  getOption("TITAN_NAMESPACE", NULL)
}
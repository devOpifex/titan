#' Registry
#' 
#' Interface to the main registry of metrics of titan, 
#' should not be interacted with directly.
#' 
#' @author John Coene, \email{john@@opifex.org}
#' 
#' @export 
Registry <- R6::R6Class(
  "Registry",
  public = list(
#' @details Initialise a new storage for a metric.
    initialize = function(){
      private$.id <- generateId()
    },
#' @details Store something in the registry.
#' @param obj Object to store.
    store = function(obj){
      store(private$.id, obj)
      invisible(self)
    },
#' @details Retrieve something from the registry.
    get = function(){
      get(private$.id)
    }
  ),
  private = list(
    .id = ""
  )
)

#' Store
#' 
#' @param id Identifier of the element.
#' @param obj Object to store.
#' 
#' @noRd 
#' @keywords internal
store <- function(id, obj){
  titanCollector[[id]] <- obj
}

#' @noRd 
#' @keywords internal
get <- function(id){
  titanCollector[[id]]
}

#' Generate an Identifier
#' 
#' Generate a valid unique identified for an object.
#' 
#' @noRd 
#' @keywords internal
generateId <- function(){
  smp <- sample(c(letters, LETTERS), 52)
  paste0(smp, collapse = "")
}
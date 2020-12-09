Registry <- R6::R6Class(
  "Registry",
  public = list(
    initialize = function(){
      private$.env <- new.env(hash = TRUE)
    },
    store = function(name, obj){
      private$.env[[name]] <- obj
      private$.index <- private$.index + 1 
      invisible(self)
    },
    get = function(name){
      private$.env[[name]]
    },
    clean = function(){
      private$.env <- new.env(hash = TRUE)
      private$.index <- 0
      invisible(self)
    }
  ),
  private = list(
    .env = NULL,
    .index = 0
  )
)

# global registry
.registry <- Registry$new()

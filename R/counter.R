#' Counter
#' @importFrom assertthat assert_that
Counter <- R6::R6Class(
  "Counter",
  inherit = Titan,
  public = list(
    initialize = function(name, help, label = NULL){
      assert_that(not_missing(name))
      assert_that(not_missing(help))

      private$.name <- name

      super$.storage(
        name,
        Metric$new(
          name, help, 
          type = "counter", 
          label = NULL
        )
      )
    },
    inc = function(value = 1){
      if(value < 0){
        warning("`value` is negative")
        return(invisible())
      }
      private$.value <- private$.value + value
      private$.run()$value(private$.value)
    },
    set = function(value){
      if(private$value < value){
        warning("`value` is too low")
        return(invisible())
      }
      private$.value <- private$.value + value
      private$.run()$value(private$.value)
    }
  ),
  private = list(
    .name = "",
    .value = 0,
    .run = function(){
      super$.storage(private$.name)
    }
  )
) 
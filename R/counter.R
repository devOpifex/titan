#' Counter
#' @importFrom assertthat assert_that
Counter <- R6::R6Class(
  "Counter",
  inherit = Titan,
  public = list(
#' @details Create a counter.
#' @param name Name of the counter.
#' @param help Help text for the counter.
    initialize = function(name, help){
      assert_that(not_missing(name))
      assert_that(not_missing(help))

      private$.name <- name

      super$.storage(
        name,
        Metric$new(
          name, help, 
          type = "counter"
        )
      )
    },
#' @details Increase the counter.
#' @param value _Positive_ value (integer or numeric) to increase the 
#' counter by.
#' 
#' @details If a negative value is passed the method
#' throws a warning and does not log metric.
    inc = function(value = 1L){
      if(value < 0){
        warning("`value` is negative")
        return(invisible())
      }
      private$.value <- private$.value + value
      private$.run()$value(private$.value)
    },
#' @details Set the counter to a specific value.
#' @param value Value to set the counter to. This
#' value must be greater than the current counter 
#' value or a warning is thrown and the value is
#' not logged.
    set = function(value){
      if(private$value <= value){
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
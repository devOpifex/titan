#' Ambiorix Middleware
#' 
#' Middleware for ambiorix.
#' 
#' @param path Path on which to serve the metrics.
#' Default recommended.
#' 
#' @export
titan <- function(
  path = "metrics"
) {
  function(req, res) {
    if(!req$PATH_INFO == "/metrics")
      return()

    res$test(renderMetrics())
  }
}
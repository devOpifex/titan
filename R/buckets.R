#' Bucket
#' 
#' Create buckets as must be returned by the 
#' [Histogram] and [Summary] predicates.
#' 
#' @param obj Object to check.
#' @param label Label of bucket.
#' @param value Value of the bucket.
#' 
#' @name bucket
#' 
#' @export
bucket <- function(label, value){
  label <- as.character(label)
  b <- list(label = label, value = value)
  structure(b, class = c("bucket", class(b)))
}

#' @rdname bucket
#' @export 
is.bucket <- function(obj){
  if(inherits(obj, "bucket"))
    return(TRUE)
  
  FALSE
}

#' @export
print.bucket <- function(x, ...){
  cat("Bucket\nlabel:", x$label, "\nvalue:", x$value)
}

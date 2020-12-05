titanCollector <- NULL

.onLoad <- function(libname, pkgname) {
  titanCollector <<- new.env(hash = TRUE, parent = parent.frame(1))
}

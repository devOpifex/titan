# Plumber APIs

The metrics and how they are used never changes, the only thing that changes across projects is how the metrics are served.

Create the plumber API as you normally would.

```r
#* Increment a counter
#* @get /
function() {
  return("Hello titan!")
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}
```

Then use the function `prTitan` as you would normally use `pr`. This example here will serve the metrics but _none are currently tracked._

```r
library(plumber)

titan::prTitan("file.R") %>% 
  pr_run()
```

As with shiny, titan provides an out-of-the-box metric to track: `latency`. As with shiny (`titanApp`), the `latency` argument defaults to `NULL` meaning this is not being tracked, to turn on that tracking pass it a character string: the name of the metric.

Latency tracks the time it takes for the API to serve requests. This is tracked with a Histogram that uses predefined `bucket`s that put the request time in milliseconds in various bins (e.g.: 300 milliseconds, 600 milliseconds, etc.). It also uses some labels to track:

1. The method used for the request, e.g.: `GET` or `POST`.
2. The path of the request, e.g.: `/plot`.
3. The status of the request, e.g.: `200` or `404`.

```r
library(plumber)

titan::prTitan("file.R", latency = "latency") %>% 
  pr_run()
```

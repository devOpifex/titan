# Plumber APIs

The metrics and how they are used never changes, the only thing that changes across projects is how the metrics are served.

Use the function `renderMetrics` to serve the metrics so Prometheus can `GET` them. Make sure you serve that endpoint as `@serializer text`.

```r
library(titan)

cnter <- Counter$new(
  "home", 
  "Counts number of pings"
)

#* Increment a counter
#* @get /
function() {
  cnter$inc()
  return("Hello titan!")
}

#* Render Metrics
#*
#* @serializer text
#* @get /metrics
renderMetrics
```


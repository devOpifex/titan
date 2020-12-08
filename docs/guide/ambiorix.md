# Ambiorix

Then again, the metrics themselves and their usage does not differ, only the way the metrics are served.

Create a new `get` method on the `/metrics` endpoint, and have it return the results of `renderMetrics`.

```r
library(titan)
library(ambiorix)

# basic counter
c <- Counter$new(
  name = "visits_total", 
  help = "Total visit to the site",
  labels = "path"
)

app <- Ambiorix$new()

app$get("/", function(req, res){
  c$inc(path = "/")
  res$send("Using {titan} with {ambiorix}!")
})

app$get("/about", function(req, res){
  c$inc(path = "/about")
  res$send("About {titan} and {ambiorix}!")
})

app$get("/metrics", function(req, res){
  res$text(renderMetrics())
})

app$start()
```

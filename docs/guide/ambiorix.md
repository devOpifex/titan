---
title: Using titan with ambiorix
summary: How to monitor metrics for ambiorix applications.
authors:
    - John Coene
---

# Ambiorix

Then again, the metrics themselves and their usage does not differ, only the way the metrics are served.

With [ambiorix](https://github.com/JohnCoene/ambiorix), create a new `get` method on the `/metrics` endpoint, and have it return the results of `renderMetrics`.

```r hl_lines="23 24 25"
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

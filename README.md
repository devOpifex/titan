<!-- badges: start -->
[![R build status](https://github.com/devOpifex/titan/workflows/R-CMD-check/badge.svg)](https://github.com/devOpifex/titan/actions)
[![Travis build status](https://travis-ci.com/devOpifex/titan.svg?branch=master)](https://travis-ci.com/devOpifex/titan)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/devOpifex/titan?branch=master&svg=true)](https://ci.appveyor.com/project/devOpifex/titan)
<!-- badges: end -->

# titan

[Prometheus](prometheus.io/) monitoring for shiny applications, plumber APIs, and other R web services.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/titan")
```

## Shiny

A simple counter, a value that can only increase, and never decrease.

``` r
library(titan)
library(shiny)

# basic counter
cnter <- Counter$new(
  name = "visits_total", 
  help = "Total visit to the app"
)

ui <- fluidPage(
  h1("Hello!")
)

server <- function(input, output){
  # increment at every visit
  cnter$inc()
}

titanApp(ui, server)
```


## Plumber

Using titan in plumber.

```r
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

## Ambiorix

Using titan with ambiorix.

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

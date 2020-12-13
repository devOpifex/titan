<div align="center">

<img src="docs/images/titan.png" height = "200px" />

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/devOpifex/titan.svg?branch=master)](https://travis-ci.com/devOpifex/titan)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/devOpifex/titan?branch=master&svg=true)](https://ci.appveyor.com/project/devOpifex/titan)
[![Coveralls test coverage](https://coveralls.io/repos/github/devOpifex/titan/badge.svg)](https://coveralls.io/r/devOpifex/titan?branch=master)
<!-- badges: end -->

[Website](https://titan.opifex.org) | [Monitoring](https://titan.opifex.org/about/monitoring/)

[Prometheus](prometheus.io/) monitoring for shiny applications, plumber APIs, and other R web services.

</div>

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

ui <- fluidPage(
  h1("Hello!")
)

server <- function(input, output){}

# use titanApp
titanApp(
  ui, server,
  inputs = "inputs",
  visits = "visits",
  concurrent = "concurrent",
  duration = "duration"
)
```


## Plumber

Using titan in plumber.

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

```r
library(plumber)

titan::prTitan("file.R", latency = "latency") %>% 
  pr_run()
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

## Acknowledgement 

I have put this package together in order to 1) grasp a better understanding of Prometheus metrics and 2) have some direct control over the source code of software I deploy for clients. I have written and re-written this three times before discovering [openmetrics](https://github.com/atheriel/openmetrics/), an R package that provides the same functionalities. I have taken much inspiration from it.

## Related work

There are other packages out there that will let you serve Prometheus metrics.

- [openmetrics](https://github.com/atheriel/openmetrics/) provides support for all metrics as well as authentication, and goes a step further in enforcing [OpenMetrics](https://openmetrics.io/) standards.
- [pRometheus](https://github.com/cfmack/pRometheus/) Provides support for Gauge and Counter.

## Code of Conduct

Please note that the titan project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

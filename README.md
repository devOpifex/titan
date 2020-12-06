<!-- badges: start -->
[![R build status](https://github.com/devOpifex/titan/workflows/R-CMD-check/badge.svg)](https://github.com/devOpifex/titan/actions)
[![Travis build status](https://travis-ci.com/devOpifex/titan.svg?branch=master)](https://travis-ci.com/devOpifex/titan)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/devOpifex/titan?branch=master&svg=true)](https://ci.appveyor.com/project/devOpifex/titan)
<!-- badges: end -->

# titan

[Prometheus](prometheus.io/) monitoring for shiny applications.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/titan")
```

## Basic Example

``` r
library(titan)
library(shiny)

cnter <- Counter$new(
  "visits_total", 
  "Total visit to the app"
)

ui <- fluidPage(
  h1("Hello!")
)

server <- function(input, output){
  cnter$inc()
}

titanApp(ui, server)
```


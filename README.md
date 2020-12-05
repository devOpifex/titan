<!-- badges: start -->
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


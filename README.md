<!-- badges: start -->
<!-- badges: end -->

# titan

[Prometheus](prometheus.io/) monitoring for shiny applications.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/titan")
```

## Example

``` r
library(titan)
library(shiny)

# create a registry
reg <- Titan$new(namespace = "shiny")

ui <- fluidPage(
  actionButton("click", "Click me")
)

server <- function(input, output){

  # create counter
  cnter <- reg$counter(name = "btn_click", "Buttons clicked")

  observeEvent(input$click, {
    cnter$inc()
    print("button clicked")
  })

}

app <- shinyApp(ui, server, options = list(port = 3000))

# serve metrics
reg$runApp(app)
```


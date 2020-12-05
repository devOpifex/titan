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

ui <- fluidPage(
  actionButton("click1", "Click"),
  actionButton("click2", "Click")
)

server <- function(input, output){
  cnter <- Counter$new(
    "btn_click_total", 
    "Total button click",
    labels = "button_id"
  )
  
  observeEvent(input$click1, {
    cnter$inc(button_id = "first")
  })

  observeEvent(input$click2, {
    cnter$inc(button_id = "second")
  })
}

titanApp(ui, server)
```


<!-- badges: start -->
<!-- badges: end -->

# titan

The goal of titan is to ...

## Installation

You can install the released version of titan from [CRAN](https://CRAN.R-project.org) with:

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/titan")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(titan)

# create a registry
registry <- Titan$new()

ui <- fluidPage(
  actionButton("click", "Click me")
)

server <- function(input, output){

  # create counter
  cnter <- registry$new()

  observeEvent(input$click, {
    cnter$inc()
    print("button clicked")
  })

}

app <- shinyApp(ui, server)

# serve metrics
registry$runApp(app)
```


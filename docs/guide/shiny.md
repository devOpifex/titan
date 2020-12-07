# Shiny Basics

In this wee vignette we give just basic examples of how to use titan in shiny applications.

## Counter

Below is a very basic shiny application that simply logs clicks of a button.

```r
library(shiny)

ui <- fluidPage(
  actionButton("click", "click me!")
)

server <- function(input, output){
  observeEvent(input$click, {
    cat("Logging one click\n")
  })
}

shinyApp(ui, server)
```

Let's use titan to track the number of clicks on this button. We can use a counter since the number of clicks can only increase over time.

Load the titan package then create the counter. Note that it is created outside the application, as it only needs to be created once, placing it in the `server` would recreate it every time. Though this should not be an issue as titan prevents you from overwriting an already created counter it is best to avoid it.

In the observer we increment the counter, then note that we launch the application with `titanApp` and not `shinyApp`, it works the exact same way but exposes the metrics.

```r
library(titan)
library(shiny)

# create the counter
c <- Counter$new(
  name = "btn_click_total",
  help = "Number of clicks of the button"
)

ui <- fluidPage(
  actionButton("click", "click me!")
)

server <- function(input, output){
  observeEvent(input$click, {
    c$inc()
    cat("Logging one click\n")
  })
}

# use titanApp
titanApp(ui, server)
```

![](../images/shiny-basic.png)

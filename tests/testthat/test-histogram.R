source("../utils.R")

test_that("Histogram", {
  expect_error(Histogram$new())

  pred <- function(x){
    if(x > .5)
      return(bucket("0", 0))
    
    bucket("1", 1)
  }

  hist <- Histogram$new(
    "histo1",
    help = "Something random",
    predicate = pred
  )

  metric3 <- getStorage("histo1")

  hist$observe(0)
  expect_equal(
    metric3$renderMetric(),
    "# HELP histo1 Something random\n# TYPE histo1 histogram\nhisto1 {le=\"1\"} 1 \n"
  )

  hist$observe(1)
  expect_equal(
    metric3$renderMetric(),
    "# HELP histo1 Something random\n# TYPE histo1 histogram\nhisto1 {le=\"1\"} 1 \nhisto1 {le=\"0\"} 1 \n"
  )
})

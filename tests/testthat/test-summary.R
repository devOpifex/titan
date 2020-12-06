source("../utils.R")

test_that("Summary", {
  expect_error(Summary$new())

  pred <- function(x){
    if(x > .5)
      return(bucket("0", 0))
    
    bucket("1", 1)
  }

  hist <- Summary$new(
    "sum1",
    help = "Something random",
    predicate = pred
  )

  metric3 <- getStorage("sum1")

  hist$observe(0)
  expect_equal(
    metric3$renderMetric(),
    "# HELP sum1 Something random\n# TYPE sum1 summary\nsum1 {quantile=\"1\"} 1 \n"
  )

  hist$observe(1)
  expect_equal(
    metric3$renderMetric(),
    "# HELP sum1 Something random\n# TYPE sum1 summary\nsum1 {quantile=\"1\"} 1 \nsum1 {quantile=\"0\"} 0 \n"
  )
})

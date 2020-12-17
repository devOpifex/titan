test_that("Histogram", {

  cleanRegistry()

  expect_error(Histogram$new())
  expect_error(Histogram$new("name"))
  expect_error(Histogram$new("name", "help"))
  expect_error(Histogram$new("name", "help", "string"))

  pred <- function(v){
    if(v < 1)
      return(bucket("1", v))

    bucket("+", v)
  }

  temp <- Histogram$new(
    "temp",
    "temperature of stuff",
    predicate = pred,
    labels = "room"
  )

  temp$observe(1, room = "kitchen")
  temp$observe(.1, room = "kitchen")
  temp$observe(.3, room = "kitchen")
  temp$observe(1, room = "bathroom")

  expect_equal(
    renderMetrics(),
    "# HELP temp temperature of stuff\n# TYPE temp histogram\ntemp{le=\"+\",room=\"kitchen\"} 1\ntemp{le=\"1\",room=\"kitchen\"} 2\ntemp{le=\"+\",room=\"bathroom\"} 1\ntemp_count{room=\"kitchen\"} 3\ntemp_count{room=\"bathroom\"} 1\ntemp_sum{room=\"kitchen\"} 1.4\ntemp_sum{room=\"bathroom\"} 1\n"
  )

  cleanRegistry()

  wrongPred <- function(x){
    "error"
  }

  temp2 <- Histogram$new(
    "temp2",
    "temperature of stuff",
    predicate = wrongPred
  )

  expect_warning(temp2$observe(1))
  
})

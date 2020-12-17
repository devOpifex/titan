test_that("Summary", {

  cleanRegistry()

  expect_error(Summary$new())
  expect_error(Summary$new("name"))
  expect_error(Summary$new("name", "help"))
  expect_error(Summary$new("name", "help", "string"))

  pred <- function(v){
    if(v < 1)
      return(bucket("1", v))

    bucket("+", v)
  }

  temp <- Summary$new(
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
    "# HELP temp temperature of stuff\n# TYPE temp summary\ntemp{quantile=\"+\",room=\"kitchen\"} 1\ntemp{quantile=\"1\",room=\"kitchen\"} 0.4\ntemp{quantile=\"+\",room=\"bathroom\"} 1\ntemp_count{room=\"kitchen\"} 3\ntemp_count{room=\"bathroom\"} 1\ntemp_sum{room=\"kitchen\"} 1.4\ntemp_sum{room=\"bathroom\"} 1\n"
  )
})

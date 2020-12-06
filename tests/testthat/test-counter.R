source("../utils.R")

test_that("Counter", {
  expect_error(Counter$new())

  cnter <- Counter$new(
    "counter1",
    help = "Button example"
  )

  cnter$inc()

  metric <- getStorage("counter1")
  expect_s3_class(metric, "Metric")

  metricRendered <- metric$renderMetric()
  expect_type(metricRendered, "character")
  expect_equal(metricRendered, "# HELP counter1 Button example\n# TYPE counter1 counter\ncounter1 1 \n")

  cnter$set(3)
  metricRendered <- metric$renderMetric()
  expect_equal(metricRendered, "# HELP counter1 Button example\n# TYPE counter1 counter\ncounter1 3 \n")

  cnter2 <- Counter$new(
    "counter2",
    help = "Button example",
    labels = "module"
  )

  metric2 <- getStorage("counter2")

  expect_warning(cnter2$inc())
  cnter2$inc(module = "home")
  
  expect_equal(metric2$renderMetric(), "# HELP counter2 Button example\n# TYPE counter2 counter\ncounter2 {module=\"home\"} 1 \n")

  cnter2$inc(module = "data")
  expect_equal(metric2$renderMetric(), "# HELP counter2 Button example\n# TYPE counter2 counter\ncounter2 {module=\"home\"} 1 \ncounter2 {module=\"data\"} 1 \n")
})

source("../utils.R")

test_that("Gauge", {
  expect_error(Gauge$new())

  cnter <- Gauge$new(
    "gauge1",
    help = "Button example"
  )

  cnter$inc(2)

  metric <- getStorage("gauge1")
  expect_s3_class(metric, "Metric")

  metricRendered <- metric$renderMetric()
  expect_type(metricRendered, "character")
  expect_equal(metricRendered, "# HELP gauge1 Button example\n# TYPE gauge1 gauge\ngauge1 2 \n")

  cnter$dec(1)
  metricRendered <- metric$renderMetric()
  expect_equal(metricRendered, "# HELP gauge1 Button example\n# TYPE gauge1 gauge\ngauge1 1 \n")

  cnter2 <- Gauge$new(
    "gauge2",
    help = "Button example",
    labels = "module"
  )

  metric2 <- getStorage("gauge2")

  expect_warning(cnter2$inc())
  cnter2$inc(module = "home")
  
  expect_equal(metric2$renderMetric(), "# HELP gauge2 Button example\n# TYPE gauge2 gauge\ngauge2 {module=\"home\"} 1 \n")

  cnter2$inc(module = "data")
  expect_equal(metric2$renderMetric(), "# HELP gauge2 Button example\n# TYPE gauge2 gauge\ngauge2 {module=\"home\"} 1 \ngauge2 {module=\"data\"} 1 \n")
})

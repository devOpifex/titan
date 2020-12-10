test_that("Gauge", {
  cleanRegistry()

  expect_error(Gauge$new())
  expect_error(Gauge$new("name"))

  g <- Gauge$new("btn_clicks", "total clicks")
  g$inc()
  expect_equal(g$get(), 1)
  g$dec()
  expect_equal(g$get(), 0)

  g$set(3)
  expect_equal(g$get(), 3)
  g$set(2)
  expect_equal(g$get(), 2)

  expect_equal(
    renderMetrics(),
    "# HELP btn_clicks total clicks\n# TYPE btn_clicks gauge\nbtn_clicks 2\n"
  )
})

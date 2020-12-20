test_that("Counter", {
  cleanRegistry()

  expect_error(Counter$new())
  expect_error(Counter$new("name"))

  cnter <- Counter$new("btn_total", "total clicks")
  cnter$inc()
  expect_equal(cnter$get(), 1)
  expect_warning(cnter$dec())

  cnter$set(3)
  expect_equal(cnter$get(), 3)
  expect_error(cnter$set(2))
  cnter$set(4)
  expect_equal(cnter$get(), 4)

  expect_equal(
    renderMetrics(),
    "# HELP btn_total total clicks\n# TYPE btn_total counter\nbtn_total 4\n"
  )

  testthat::expect_output(previewMetrics())
})

test_that("Namespace", {
  cleanRegistry()

  setTitanNamespace("ns")

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
    "# HELP ns_btn_total total clicks\n# TYPE ns_btn_total counter\nns_btn_total 4\n"
  )

  # reset
  setTitanNamespace()
})

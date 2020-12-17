test_that("Labels", {
  cleanRegistry()

  cnter <- Counter$new("btn_total", "total clicks", labels = "color")
  expect_warning(cnter$inc())
  expect_equal(cnter$get(color = "red"), 0)
  expect_warning(cnter$dec())
  expect_warning(cnter$inc(wrong = "hello"))

  cnter$inc(1, color = "blue")
  expect_equal(cnter$get(color = "blue"), 1)

  expect_equal(
    renderMetrics(),
    "# HELP btn_total total clicks\n# TYPE btn_total counter\nbtn_total{color=\"blue\"} 1\n"
  )
})

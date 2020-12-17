test_that("Type", {
  cleanRegistry()

  # init
  cnter <- Counter$new("btn_total", "total clicks")
  cnter$inc()
  x <- cnter$get()

  # don't override
  cnter <- Counter$new("btn_total", "total clicks")
  y <- cnter$get()

  expect_equal(x, y)

  # fails
  expect_error(Gauge$new("btn_total", "total clicks"))

})

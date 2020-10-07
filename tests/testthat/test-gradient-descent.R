library(testthat)

context("Test the output of gradient descent.")

test_that("Your gradient_descent() function returns the same coefficients as lm.", {

  data(iris)

  fit_grad_desc <- gradient_descent(Sepal.Length ~ ., iris)

  fit_lm <- lm(Sepal.Length  ~ ., iris)

  expect_equivalent(fit_lm$coefficients, fit_grad_desc$coefficients,
                    tolerance = 1e-3)
})

library(testthat)

context("Test the output of ridge regression.")

test_that("Your gradient_descent() function returns very good approximation",{
  
  formula = mpg ~.
  
  coefficient = as.numeric(lm(formula,mtcars)$coefficient)
  
  my_coeff = as.numeric(ridge_regression(formula,mtcars))
  
  expect_equal(my_coeff,coefficient,tolerance = 0.001) #just 0.001 difference is tolerated.
})
library(testthat)
library(foreach)
library(rsample)
library(dplyr)

context("Test the output of gradient descent out of sample accuracy")

test_that("Your gradient descent out of sample accuracy is optimized",{
  set.seed(100)
  ogd = data.frame(red = runif(100,0,1), yellow = runif(100,0,1),blue=runif(100,0,1))
  ogd$price = 0.2*ogd$red + (0.4*(ogd$yellow **2)) + 0.5 * ogd$blue
  form = price ~ .

  flds = vfold_cv(ogd, v=10)

  error = function(x,x_pred){
    return(mean((x - x_pred)^2))
  }

  #create folds using rsample:
  maxc = 1+ (length(testing(flds$splits[[2]])))

  a = as.matrix(gradient_descent(form,training(flds$splits[[2]]))$coefficients)
  b = as.matrix(cbind(1,testing(flds$splits[[2]]))[-maxc])
  pred = b %*% a
  err1 = error(
    testing(flds$splits[[2]])[[as.character(form[2])]],
    pred)

  err= out_gradient_descent(formula = form,ogd)
  err2 = err[1]

  expect_lt(err2,err1)
})

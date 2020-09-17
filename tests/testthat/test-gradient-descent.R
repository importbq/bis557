library(testthat)

context("Test the output of gradient descent.")

test_that("Your gradient_descent() function returns very good approximation",{
  
  X = matrix(runif(9),nrow = 3, ncol = 3)
  Y = as.matrix(c(1,2,3))
  
  beta = as.matrix(gradient_descent(X,Y, N=10000))
  
  loss = sum((Y - X %*% beta)^2) #squared loss
  
  expect_lt(loss, 0.1)
          })
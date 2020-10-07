library(testthat)
library(foreach)
library(rsample)

context("Test the output of find lambda")

test_that("Your find_lambda function finds the optimal lambda",{

  df = mtcars

  formula = mpg~.

  pred = find_lambda(formula, df)

  lambdas =seq(0.1,0.9,by=0.1)

  set.seed(110)

  folds = vfold_cv(df, v=10)

  error = function(x,x_pred){
    return(mean((x - x_pred)^2))
  }

  mse = foreach(i = lambdas, .combine = c) %do% {
    #calculate mse
    error(
      testing(folds$splits[[1]])[[as.character(formula[2])]],
      predict(ridge_regression(formula, training(folds$splits[[1]]),
                               lambda = i),
              testing(folds$splits[[1]])))
    }

  expect_equal(pred,lambdas[which.min(mse)])

})


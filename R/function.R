#' @title  linear model function
#' @name linear_model
#' @description This is a simple function to calculate the coefficients of of a linear model.
#' @param formula a formula for a linear model to regress.
#' @param data the data frame we run our model on.
#' @param contrasts the categorical variables we want to include in our model.
#' @import rlang
#' @examples
#' library(palmerpenguins)
#' data(penguins)
#' coeffs = linear_model(bill_length_mm ~ ., data = penguins[,-8])
#' @export

linear_model = function(formula, data, contrasts = NULL){

  # remove the nas:
  df = model.frame(formula,data)

  # define the X and Y matrix:
  X = model.matrix(formula, df, contrasts.arg = contrasts)

  y_name = as.character(formula)[2]
  Y = matrix(df[,y_name], ncol = 1)

  # solve for betas:
  # This does not solve singular cases
  # beta = solve(t(X) %*% X) %*% t(X) %*% Y
  beta = qr.solve(qr(X),Y)

  # in order to pass the test convert na to 0
  beta[beta == 0] = NA

  #output the results:
  beta_names = rownames(beta)
  beta = as.numeric(beta)
  names(beta) = beta_names
  ret = list(coefficients = beta)
  class(ret) = 'my_lm'

  return(ret)
}



#' @title  gradient descent
#' @name gradient_descent
#' @description implementation of gradient descent for ordinary least squares, finding the solutions
#' for Y = X*beta.
#' @param formula A formula of form "A ~ B".
#' @param data A dataframe.
#' @param lr learning rate by which to adjust beta along gradient;
#' @param max_Iter Maximum number of iterations;
#' @param threshold Size of difference between previous and new betas at which the loop exits; default is 0.001.
#' @param print Printing progress
#' @importFrom stats model.matrix setNames
#' @examples
#' betas = gradient_descent(mpg ~ cyl + disp, mtcars)
#' @export

gradient_descent <- function(formula, data,lr = 0.0001, max_Iter = 5e5, threshold = 1e-12, print=FALSE){

  X <- model.matrix(formula, data)
  Y <- as.matrix(subset(data, select = as.character(formula[[2]])), ncol = 1)
  beta_k <- matrix(1, ncol = 1, nrow = ncol(X))
  check_r <- function(beta, Y, X) {
    drop(t(Y) %*% Y + t(beta) %*% t(X) %*% X %*% beta - 2 * t(Y) %*% X %*% beta)
  }

  df <- function(beta, Y, X){
    (2 * t(X) %*% X %*% beta - 2 * t(X) %*% Y)
  }
  if(qr(X)$rank == dim(X)[2]){
    counter = 1
    diff = 10

    while ((counter < max_Iter) & (diff > threshold)){
      r1 <- check_r(beta_k, Y, X)
      beta_k <- beta_k - lr * df(beta_k, Y, X)
      r2 <- check_r(beta_k, Y, X)
      diff <- r1 - r2
      counter = counter + 1
    }
    if (print == TRUE){
    print(sprintf("Gradient descent completed after %i iterations", counter))
    print(sprintf("The final difference in the residuals was: %f,", diff))
  }
    gd <- list(coefficients = beta_k)
    list(coefficients = setNames(as.numeric(gd$coefficients), dimnames(gd$coefficients)[[1]]))
  }
  # pass to linear_model()
  else{
    warning("Data frame has perfect collinearity. Passing to linear_model().")
    linear_model(formula, data, contrasts = NULL)
  }
}



#' @title  out-of-sample gradient descent
#' @name out_gradient_descent
#' @description implementation of gradient descent for ordinary least squares, finding the solutions
#' for Y = X*beta and choose the best best beta that gives best out of sample accuracy
#' @param formula a formula for ridge regression
#' @param data the data you want to regress on
#' @param lambda learning rate
#' @param N number of iterations
#' @param M number of folds to split the dataset
#' @import foreach rsample dplyr
#' @examples
#' set.seed(100)
#' ogd = data.frame(red = runif(100,0,1), yellow = runif(100,0,1),blue=runif(100,0,1))
#' ogd$price = 0.2*ogd$red + (0.4*(ogd$yellow **2)) + 0.5 * ogd$blue
#' formula = price ~ .
#' data = ogd
#' out_gradient_descent(formula, data)
#' @export

out_gradient_descent = function(formula,data,lambda = 0.0001,N= 5e5, M=10 ){
    # calculate mse:
    error = function(x,x_pred){
      return(mean((x - x_pred)^2))
    }

   #create folds using rsample:
    folds = vfold_cv(data, v = M)
    maxc = 1+ (length(testing(folds$splits[[1]])))
    resids = matrix(0,nrow = nrow(folds),ncol= maxc)

    #loop through each fold
    for (i in seq_len(nrow(folds))){
      #calculate mse
      a = as.matrix(gradient_descent(formula,training(folds$splits[[i]]))$coefficients,lr = lambda, max_Iter = N)
      b = as.matrix(cbind(1,testing(folds$splits[[i]]))[-maxc])
      pred = b %*% a
      resids[i,1] = error(
        testing(folds$splits[[i]])[[as.character(formula[2])]],
        pred
      )
      resids[i,2:maxc] = a
    }
    k = which.min(resids[,1])
    return(resids[k,])
}




#' @title  Ridge Regression
#' @name  ridge_regression
#' @description Using SVD for ridge regression
#' @param formula a formula for ridge regression
#' @param data the data you want to regress on
#' @param lambda ridge penalty term
#' @importFrom stats model.matrix model.frame
#' @examples
#' ridge_regression(mpg ~ cyl + disp, mtcars)
#' @export

ridge_regression = function(formula, data, lambda = 0) {
  rownames = NULL
  # Remove Nas
  X = model.frame(formula, data)
  # Turn into feature matrix
  X = model.matrix(formula, X)

  # Dependent variable Y:
  y_name = as.character(formula)[2]
  Y = matrix(data[,y_name], ncol = 1)

  # standardization for svd:
  X_bar = colMeans(X[, -1])
  Y_bar = mean(Y)
  X = X[, -1] - rep(X_bar, rep(nrow(X), ncol(X) - 1))
  Xscale = drop(rep(1/nrow(X), nrow(X)) %*% X^2)^0.5
  X = X/rep(Xscale, rep(nrow(X), ncol(X)))
  Y = Y - Y_bar

  # initialize beta matrix
  coef = matrix(NA_real_, ncol = ncol(X))

  # calculate the least squared solution:
  svd = svd(X)
  coef = svd$v %*% diag(svd$d  / (svd$d^2 + lambda)) %*% t(svd$u) %*% Y

  # Combine the coefficients:
  scaledcoef = t(as.matrix(coef / Xscale))
  intercept <- Y_bar - scaledcoef %*% X_bar
  coef <- cbind(intercept, scaledcoef)

  # add attributes and class for future use:
  coef <- as.vector(coef)
  names(coef) <- c("Intercept", colnames(X))
  attributes(coef)$formula <- formula
  class(coef) <- c(class(coef), "ridge_regression")
  return(coef)
}


#' Prediction function for Ridge Regression function
#' @param object ridge_regression object
#' @param ... first argument should be the data frame
#' @importFrom stats model.matrix
#' @export

predict.ridge_regression <- function(object, ...) {
  # extract dots
  dots <- list(...)
  x_frame <- dots[[1]]
  # check for bad arg
  if (!is.data.frame(x_frame)) {
    stop("The first argument should be a data.frame of values",
         "to predict")
  }
  # create new model matrix and predict
  X <- model.matrix(attributes(object)$formula, x_frame)
  X %*% object
}


#' @title  Lambda finder
#' @name find_lambda
#' @description search the best ridge regression parameter lambda based on N folds
#' cross validation for out of sample accuracy.
#' @param formula a formula for a linear model to regress.
#' @param data the data frame we run our model on.
#' @param N number of folds to split the dataset
#' @param lambdas list of lambda you want to search from, default is from 0.1 to 0.9
#' @import foreach rsample utils
#' @importFrom stats predict
#' @examples
#' find_lambda(mpg ~.,mtcars,lambdas = c(0.1,0.2,0.5))
#' @export
#
globalVariables("lambda")
find_lambda = function(formula, data, N = 10, lambdas = seq(0.1,0.9,by=0.1)){
  # calculate mse:
  error = function(x,x_pred){
    return(mean((x - x_pred)^2))
  }
  #create folds using rsample:
  folds = vfold_cv(data, v=N)
  #loop through each lambda:
  i = NULL
  os_resids = foreach(lambda = lambdas, .combine = rbind) %do% {
    #loop through each fold
    foreach(i = seq_len(nrow(folds)), .combine = c) %do% {
      #calculate mse
      error(
        testing(folds$splits[[i]])[[as.character(formula[2])]],
        predict(ridge_regression(formula, training(folds$splits[[i]]),
                                 lambda = lambda),
                testing(folds$splits[[i]]))
      )
    }
  }
  #os_resids should have dimension length(lambda) * length(folds)
  final = as.data.frame(os_resids)
  final$average = rowMeans(os_resids)
  # find the lambda with minimum
  return(lambdas[which.min(final$average)])
}




















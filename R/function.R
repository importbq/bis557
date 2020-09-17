#' @title  linear model function
#' @name linear_model
#' @description This is a simple function to calculate the coefficients of of a linear model.
#' @param formula a formula for a linear model to regress.
#' @param data the data frame we run our model on.
#' @param contrasts the categorical variables we want to include in our model.
#' @import rlang stats
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
#' @param X the feature vector
#' @param Y the label vector
#' @param lambda learning rate
#' @param N number of iterations
#' @param print Used to hide or show the progress
#' @import stats
#' @examples
#' X = matrix(runif(9),nrow = 3, ncol = 3)
#' Y = as.matrix(c(1,2,3))
#' beta = gradient_descent(X,Y)
#' @export




gradient_descent = function(X, Y, lambda = 0.01, N = 5000, print = FALSE){
    # Do we need to add intercept term?
    # add intercept term:
    # X = as.matrix(cbind(1,X))
    # initialize the betas at all 0s:
    beta = as.matrix(rep(0,length(X[1,])))

    # calculate the gradient function:
    update = function(beta){
      increment = (2 * t(X) %*% X %*% beta - 2 * t(X) %*% Y)
      return(increment)
    }

    # monitor the loss function:
    loss = function(beta){
      pred.y = X %*% beta
      loss = sum((pred.y - Y)^2)
      return(loss)
    }

    for (i in 1:N){
      beta = beta - lambda*update(beta)
      los = loss(beta)
      # monitor the process:
      if (print == TRUE){
      print(paste("Epoch number:", i,"   Current Loss is:", los))
      }
    }

    return(beta)
}











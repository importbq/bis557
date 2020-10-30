#' @title  first-order solution for the GLM maximum likelihood
#' @name glmfo
#' @description implementation of a first-order solution for the GLM maximum likelihood problem using only gradient information.
#' @param x feature variables
#' @param y response variables
#' @param method optimization method
#' @param family family object and link function
#' @param maxit Maximum number of iterations
#' @param lr learning rate
#' @param print whether to print to track progress
#' @param er allowed errors
#' @examples
#' set.seed(100)
#' n <- 1000
#' X <- cbind(1, matrix(rnorm(n * 3), ncol = 3))
#' beta <- c(-1, 0.2, 0.5, 0.6 )
#' Y = rpois(n,exp(X %*% beta))
#' glmfo(X,Y,poisson(link='log'))
#' @export

glmfo = function(x, y, family, method = 'constant', lr = 0.0001,maxit=10000, er = 1e-12,print = FALSE){

  #initiate betas
  beta = rep(0, ncol(x))

  #optimize, based on lecture
  for (i in 1:maxit) {
    b_old = beta
    mu = family$linkinv(x %*% beta)
    score = t(x) %*% (y - mu)
    if (print == TRUE){
      print(c(beta,i))
    }
    else{

      if(method == "constant"){
        beta = beta +  lr* score
      }else{
        #using momentum method using ita = 0.3
        beta = beta +  sum(0.3^(1:i-1)) * lr * score
      }

      # stop if not updating
      if (sum((beta - b_old)^2) < er) {
        break
      }
    }
  }
  return(list("coefficients" = beta))
}



#' @title  Multiclass Logistic regression
#' @name multiclass
#' @description implementation of multiclass logistic regression capable of classifying more than 2 classes
#' @param formula feature variables and response variables specification
#' @param data dataframe
#' @param maxit maximum iteration
#' @param er allowed errors
#' @examples
#' multiclass(Species ~.,iris)
#' @export

multiclass = function(formula, data, maxit = 50, er = 0.0001){

    # remove the nas:
    df = model.frame(formula,data)

    # define the X and Y matrix:
    X = model.matrix(formula, df)
    y_name = as.character(formula)[2]
    Y = as.factor(matrix(df[,y_name], ncol = 1))
    n = length(levels(Y))

    #initialize betas and probabilities for logistic regression
    betas = matrix(0, nrow = n, ncol = ncol(X))
    probs = matrix(0, nrow = n, ncol = nrow(X))

    for (i in 1:n) {

      # turn y to either 1 or 0
      y.class = as.numeric(Y == levels(Y)[i])
      beta = betas[i,]

      #simple logistic regression from lecture
      for (j in 1:maxit) {
        b_old = beta
        p = 1 / (1 + exp(-X %*% beta))
        D = as.numeric(p * (1 - p))
        H = t(X) %*% diag(D) %*% X
        score = t(X) %*% (y.class - p)
        beta = beta + (solve(H) %*% score)
        if (sum((beta - b_old)^2) < er) {
          break
        }
      }

      # Keep the probabilities calculated above
      probs[i,] = p
      betas[i,] = beta
    }

    # identify the class with highest probabiliy for each observation:
    pred = apply(probs,2,which.max)
    return(levels(Y)[pred])
}






ridge_hw4<- function(X,y,lambda) {

  # use svd for decomp:
  X = cbind(1,X)
  decop = svd(X)
  U = decop$u
  V = decop$v
  sigmas = decop$d

  # svd update with ridge regression:
  D = diag(sigmas / (sigmas^2 + lambda))
  b_hat = V %*% D %*% t(U) %*% y
  inter = b_hat[1]
  rest = b_hat[2:length(b_hat)]
  cat("coefficients for intercept: ",inter,"\ncoefficients for X: ", rest)
}




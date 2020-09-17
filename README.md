
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Bis557

<!-- badges: start -->

![Travis build
status](https://travis-ci.com/importbq/bis557.svg?token=XyjFaGxnEDaFXgSHunRQ&branch=master)
[![codecov](https://codecov.io/gh/importbq/bis557/branch/master/graph/badge.svg)](https://codecov.io/gh/importbq/bis557)
<!-- badges: end -->

This Package contains my homeworks for Bis 557

## Installation

The development version of the packages

``` r
install.packages("bis557")
#> Installing package into '/private/var/folders/ch/jflkjh557xs44kl3fsk78hnc0000gn/T/Rtmpla6n5m/temp_libpath1f2d697040fe'
#> (as 'lib' is unspecified)
#> Warning: package 'bis557' is not available (for R version 3.6.1)
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("importbq/bis557")
```

## Example

We have two examples here to show the usage of linear\_model and
gradient descent:

``` r
library(bis557)
#> Loading required package: rlang
#> Warning: package 'rlang' was built under R version 3.6.2
data(iris)
fit_linear_model <- linear_model(Sepal.Length ~ ., iris)
print(fit_linear_model)
#> $coefficients
#>       (Intercept)       Sepal.Width      Petal.Length       Petal.Width 
#>         2.1712663         0.4958889         0.8292439        -0.3151552 
#> Speciesversicolor  Speciesvirginica 
#>        -0.7235620        -1.0234978 
#> 
#> attr(,"class")
#> [1] "my_lm"
```

``` r
# create the feature vectors X and the label vectors Y:
X = matrix(runif(9),nrow = 3, ncol = 3)
Y = as.matrix(c(1,2,3))

#estimate beta from gradient descent:
beta = as.matrix(gradient_descent(X,Y, N=10000))

#print the loss after 10K iterations:  
loss = sum((Y - X %*% beta)^2) 
print(loss)
#> [1] 9.758979e-24
```

We see that gradient descent achieved very good results for OLS.

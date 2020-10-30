
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
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("importbq/bis557")
```

## Example

We have an example here to show the usage of linear\_model:

``` r
library(bis557)
#> Loading required package: rlang
#> Warning: package 'rlang' was built under R version 3.6.2
#> Loading required package: dplyr
#> Warning: package 'dplyr' was built under R version 3.6.2
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: foreach
#> Loading required package: rsample
#> Warning: package 'rsample' was built under R version 3.6.2
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

We see that gradient descent achieved very good results for OLS.

# Please read Vignette for details

# HW2 Vignette has the solution to HW2

# HW3 Pdf has been included in the Vignette folder


<!-- README.md is generated from README.Rmd. Please edit that file -->

# bis557

<!-- badges: start -->

![Travis build
status](https://travis-ci.com/importbq/bis557.svg?token=XyjFaGxnEDaFXgSHunRQ&branch=master)
[![Codecov test
coverage](https://codecov.io/gh/importbq/bis557/branch/master/graph/badge.svg)](https://codecov.io/gh/importbq/bis557?branch=master)
<!-- badges: end -->

The goal of bis557 is to illustrate how to create a R package for the
Yale Biostatistics biss557 class

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

This is a basic example which shows you how to solve a common problem:

``` r
library(bis557)
#> Loading required package: rlang
#> Warning: package 'rlang' was built under R version 3.6.2
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(lm_patho)
#>        y                  x1                 x2          
#>  Min.   :-1.0e+00   Min.   :-1.0e+00   Min.   :-1.00000  
#>  1st Qu.: 2.5e+08   1st Qu.: 2.5e+08   1st Qu.:-0.75000  
#>  Median : 5.0e+08   Median : 5.0e+08   Median :-0.50000  
#>  Mean   : 5.0e+08   Mean   : 5.0e+08   Mean   :-0.50000  
#>  3rd Qu.: 7.5e+08   3rd Qu.: 7.5e+08   3rd Qu.:-0.24999  
#>  Max.   : 1.0e+09   Max.   : 1.0e+09   Max.   : 0.00001
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!

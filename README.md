
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bis557

<!-- badges: start -->

\[![Travis build
status](https://travis-ci.com/importbq/bis557.svg?token=XyjFaGxnEDaFXgSHunRQ&branch=master)
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
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!

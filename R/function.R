#' @title Linear Model function
#' @description This is a simple function to calculate the coefficients of of a linear model
#' @param formula a formula for a linear model to regress
#' @param data the data frame we run our model on
#' @param contrasts the categorical variables we want to include in our model
#' @examples
#' library(palmerpenguins)
#' data(penguins)
#' coeffs = linear_model(bill_length_mm ~ ., data = penguins[,-8])
#' @export

library(palmerpenguins)
library(GGally)
library(dplyr)
library(DT)
library(rlang)

linear_model = function(formula , data, contrasts = NULL){
  # check if there is a formula:
  if (is_formula(formula) == FALSE){
    stop('Please enter a formula')
  }
  if (is.data.frame(data) == FALSE){
    stop('Please enter a data frame')
  }
  mm = lm(formula = formula,data = data, contrasts=contrasts)
  return(mm$coefficients)
}


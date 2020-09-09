library(testthat)
library(bis557)
library(palmerpenguins)

fit = lm(bill_length_mm ~ ., data = penguins[,-8])
grab_coeffs(fit)
test_check("bis557")

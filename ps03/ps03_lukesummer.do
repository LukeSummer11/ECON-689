*pull environment variables and set up ps03 folder/log
global projects: env projects
global output    "$projects/econ689/ps03/output"
capture mkdir "$projects/econ689/ps03"
capture mkdir "$output"

capture log close
log using "$output/log_lukesummer.log", replace text

*Problem 1: generate the data
set seed 2026
clear
set obs 500 

*generate x1, x2, and the true model for y
gen x1 = rnormal(2,1)
summarize x1

gen v = rnormal(0,1)
gen x2 = 0.5*x1 + v 
summarize x2 

gen u = rnormal(0,2)
gen y = 3 + 2*x1 - x2 + u
summarize y x1 x2 

*scatterplots of y against x1 and x2 with fitted lines 
twoway (scatter y x1) (lfit y x1), title("Scatterplot of Y against X1") xtitle("x1") ytitle("Y")

twoway (scatter y x2) (lfit y x2), title("Scatterplot of Y against X2") xtitle("x2") ytitle("Y")

*Problem 2: regression and orthogonality checks
regress y x1 x2
predict yhat, xb 
predict ehat, resid 

*verify residuals are orthogonal to x1 and x2 
gen x1e = x1*ehat
gen x2e = x2*ehat
summarize x1e

display r(mean)*r(N)
summarize x2e
display r(mean)*r(N)

*scatterplots of residuals against x1 and x2 
twoway (scatter ehat x1) (lfit ehat x1), yline(0) ///
title("Residuals against X1") xtitle("X1") ///
ytitle("Residuals")

twoway (scatter ehat x2) (lfit ehat x2), yline(0) ///
title("Residuals against X2") xtitle("X2") ///
ytitle("Residuals")

*Problem 3: residual properties associated with the intercept
summarize ehat
display r(mean)*r(N)

summarize yhat y

*histogram of residuals 
histogram ehat, xline(0) ///
title("Histogram of Residuals") xtitle("Residuals") ///
ytitle("Density")

*Problem 4: verify prediction at the average observation 
summarize x1, meanonly
scalar x1bar = r(mean)
summarize x2, meanonly
scalar x2bar = r(mean)

scalar yhat_bar =_b[_cons] + _b[x1]*x1bar + _b[x2]*x2bar 
display yhat_bar

*close log 
log close 
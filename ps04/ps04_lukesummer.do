*pull environment variables and set up ps04 folder/log
global projects: env projects 
global output    "$projects/econ689/ps04/output"
capture mkdir "$projects/econ689/ps04"
capture mkdir "$output"

capture log close
log using "$output/log_lukesummer.log", replace text 

*Problem 1: generate the data 
set seed 2026 
clear
set obs 500 

*generate x2, x1 and the true model for y 
gen x2 = rnormal(1,1)
gen v = rnormal(0,1)
gen x1 = 0.7*x2 + v 
gen u = rnormal(0,2)
gen y = 5 +3*x1 - 2*x2 + u 
summarize y x1 x2

*estimate the full regression and store the coefficient on x1 
regress y x1 x2
scalar b1_full = _b[x1]
display b1_full 

*Problem 2: verify the FWL theorem 
regress y x2 
predict y_resid, resid 

*partial x2 out of x1 
regress x1 x2 
predict x1_resid, resid 

*scatterplot of the two residuals with fitted line 
twoway (scatter y_resid x1_resid) (lfit y_resid x1_resid), ///
title("Y Residuals against X1 Residuals") /// 
xtitle("X1 Residuals") ytitle("Y Residuals")

*regress the residuals on each other, no constant, to get b1_fwl 
regress y_resid x1_resid, noconstant
scalar b1_fwl = _b[x1_resid]

*compare b1_full and b1_fwl to verify FWL 
display "b1_full = " b1_full
display "b1_fwl = " b1_fwl
display "difference = " b1_full - b1_fwl 

*close log 
log close 
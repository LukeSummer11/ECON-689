*pull environment variables and set up the ps05 folder and log
global projects : env projects
global storage  : env storage
global dataready "$storage/econ689_data/ps01/data"
global output    "$projects/econ689/ps05/output"
capture mkdir "$projects/econ689/ps05"
capture mkdir "$output"

capture log close
log using "$output/log_lukesummer.log", replace text

*Problem 2(a): unrestricted model, save SSR and degrees of freedom
clear
use "$dataready/card.dta", clear

regress lwage educ exper expersq black south smsa smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669
scalar ssr_u = e(rss)
scalar df_u = e(df_r)
display ssr_u
display df_u

*Problem 2(b): joint test that the region dummies are zero (J = 8)
test reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669
scalar F_test = r(F)
display "F = " r(F)
display "p-value = " r(p)

*Problem 2(c): restricted model and the SSR form of the F statistic
regress lwage educ exper expersq black south smsa smsa66
scalar ssr_r = e(rss)

scalar J = 8
scalar F_ssr = ((ssr_r - ssr_u)/J) / (ssr_u/df_u)
display "SSR restricted = " ssr_r
display "F (SSR form) = " F_ssr
display "F (test command) = " F_test
display "difference = " F_ssr - F_test

*Problem 3(a): simulate the data and estimate the model
set seed 2026
clear
set obs 500

gen x1 = rnormal(0,1)
gen v = rnormal(0,1)
gen x2 = 0.5*x1 + v
gen x3 = rnormal(1,1)
gen u = rnormal(0,2)
gen y = 1 + 1*x1 + 0.5*x2 - 0.5*x3 + u

summarize y x1 x2 x3
regress y x1 x2 x3

*Problem 3(b): joint test with Stata's test command
test (x1 = 1) (x2 + x3 = 0)
scalar F_t = r(F)
display "F = " r(F)
display "p-value = " r(p)

*Problem 3(c): the same F statistic with matrices R and r
matrix b = e(b)
matrix V = e(V)
matrix R = (1, 0, 0, 0 \ 0, 1, 1, 0)
matrix r = (1 \ 0)
matrix d = R*b' - r
matrix W = d' * invsym(R*V*R') * d
scalar F_mat = W[1,1] / 2
display "F (matrix) = " F_mat
display "F (test command) = " F_t
display "difference = " F_mat - F_t

*close log
log close

global projects : env projects
global storage  : env storage

display "$projects"
display "$storage"

global dataready "$storage/econ689_data/ps01/data"
global code      "$projects/econ689/ps01"
global output    "$projects/econ689/ps01/output"

display "$dataready"
display "$code"
display "$output"

capture mkdir "$dataready"
capture mkdir "$code"
capture mkdir "$output"

capture log close
log using "$output/log_lukesummer.log", replace text 


set seed 68901
clear
set obs 500

gen v= rnormal(8, 2.5)
gen study_hours = cond(v<0, 0, v)
summarize study_hours

gen w = rnormal(3, 0.45)
gen prior_gpa =cond(w <0, 0, cond(w > 4, 4, w))

gen u = rnormal(0,5)
gen exam_score = 45 + 2.5*study_hours + 6*prior_gpa + u 

summarize prior_gpa exam_score

regress exam_score study_hours 

predict yhat_simple, xb
predict resid_simple, resid
summarize resid_simple 

regress exam_score study_hours prior_gpa
predict yhat_multi, xb
predict resid_multi, resid
summarize resid_multi 

save "$dataready/simulated_ps01.dta", replace 

use "$dataready/card.dta", clear 

describe 
summarize lwage educ exper expersq black south smsa nearc4

regress lwage educ
display 100*_b[educ] 
display 100*(exp(_b[educ]) - 1)

regress lwage educ exper expersq black south smsa


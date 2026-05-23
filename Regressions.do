*Statistics Table

tab occupation_code
ssc install asdoc

asdoc tab occupation_code, replace

tabstat age year, statistics(n mean sd min max) columns(statistics)
asdoc tabstat age year, statistics(n mean sd min max) replace


asdoc tabstat age year, stat(n mean sd min max) replace

tab age if age==99

tab sex

tabstat age year, statistics(n mean sd min max)

asdoc tabstat age year, stat(N mean sd min max) replace

asdoc tab marital_status, append
asdoc tab education_code, append
asdoc tab occupation_code, append
asdoc tab addr_region_code, append
asdoc tab place_of_death, append
asdoc tab death_time, append

tab sex
tab marital_status
tab occupation_code
tab place_of_death

ssc install asdoc

gen female = sex == 2

tab female
gen married = marital_status == 1
tab married

gen student_unemployed = occupation_code == 13

tab student_unemployed

asdoc tabstat age female married student_unemployed year, stat(N mean sd) replace


tab age if age==999

replace age = . if age == 999

asdoc tabstat age female married student_unemployed, stat(N mean sd min max) replace

asdoc tabstat age female married student_unemployed, stat(N mean sd) replace

asdoc tabstat age female married student_unemployed, stat(mean sd N) replace


graph export "figure1.pdf", replace

graph use Monthlytrend.gph

graph export "Monthlytrend.png", replace width(4000)

ssc install estout

estpost tabstat age female married student_unemployed, stat(mean sd N)

esttab using summary_table.tex, cells("mean sd count") replace

estpost tabstat age female married student_unemployed report_year, ///
statistics(count mean sd) columns(statistics)

esttab using summary_table.tex, ///
cells("count mean sd") ///
label ///
nonumber ///
replace

esttab using summary_table.tex, ///
cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3))") ///
label ///
nonumber ///
noobs ///
unstack ///
replace
clear

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19

tab treat

gen window = 0
replace window = 1 if month == 2 & day >= 20
replace window = 1 if month == 3 & day <= 12
keep if window == 1

describe death_date

drop year

gen year  = year(death_date_st)
gen month = month(death_date_st)
gen day   = day(death_date_st)

tab month

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19

tab treat

gen window = 0
replace window = 1 if month == 2 & day >= 20
replace window = 1 if month == 3 & day <= 12
keep if window == 1





* Regression 

gen suicide = 0
replace suicide = 1 if cause104_code == 102 & cause57_code == 55

tab suicide
tab cause104_code cause57_code if suicide == 1

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19

tostring death_date, gen(date_str)
gen date = date(date_str,"YMD")
format date %td

list death_date date in 1/10

drop year

gen year  = year(date)
gen month = month(date)
gen day   = day(date)

tab month

gen window = 0
replace window = 1 if month == 2 & day >= 20
replace window = 1 if month == 3 & day <= 12
keep if window == 1

gen post = 0
replace post = 1 if month == 3 & day >= 2

gen dow = dow(date)

logit suicide i.treat##i.post i.year i.dow

*reg suicide i.treat##i.post



*Regression 

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19

gen window = 0
replace window = 1 if month == 2 & day >= 20
replace window = 1 if month == 3 & day <= 12
keep if window == 1

gen post = 0
replace post = 1 if month == 3 & day >= 2

reg suicide i.treat##i.post

reg suicide i.treat##i.post i.year i.dow



*Table 

ssc install outreg2

reg suicide i.treat##i.post

outreg2 using regression_table.doc, replace ctitle(DiD Model)

outreg2 using regression_table.doc, replace drop(0b.treat#0b.post 0b.treat#1o.post 1o.treat#0b.post)


ssc install estout

reg suicide i.treat##i.post
eststo model1

esttab model1 using regression_table.rtf, ///
replace ///
keep(1.treat 1.post 1.treat#1.post) ///
coeflabels(1.treat "Student" ///
           1.post "Post (After March 2)" ///
           1.treat#1.post "Student × Post") ///
se ///
star(* 0.10 ** 0.05 *** 0.01) ///
stats(N r2, labels("Observations" "R-squared"))





ssc install estout

reg suicide i.treat##i.post i.year i.dow
eststo model1

esttab model1 using regression_table.rtf, ///
replace ///
keep(1.treat#1.post 1.treat 1.post) ///
order(1.treat#1.post 1.treat 1.post) ///
coeflabels(1.treat#1.post "Student × Post" ///
           1.treat "Student" ///
           1.post "Post (After March 2)") ///
se ///
star(* 0.10 ** 0.05 *** 0.01) ///
stats(N r2, labels("Observations" "R-squared"))



ssc install outreg2

reg suicide i.treat##i.post i.year i.dow

outreg2 using regression_table.doc, replace keep(1.treat#1.post 1.treat 1.post) ///
label ctitle("DiD Regression")



* Regression x Saqib 

gen month2 = string(month,"%02.0f")

gen week = week(date)

gen month_date = year*100 + month

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19
gen post = 0
replace post = 1 if month == 3 & day >= 2


gen treatXpost = treat*post

ssc install reghdfe
ssc install ftools

reghdfe suicide treatXpost, a(addr_region_code year) vce(cluster addr_region_code)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year) vce(cluster addr_region_code)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year month) vce(cluster addr_region_code)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year#month) vce(cluster addr_region_code)
***********
reghdfe suicide treatXpost, a(addr_region_code year) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year month) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year#month) ///
vce(cluster addr_region_code age)


eststo clear

eststo m1: reghdfe suicide treatXpost, ///
a(addr_region_code year) vce(cluster addr_region_code)

eststo m2: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year) vce(cluster addr_region_code)

eststo m3: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year month) vce(cluster addr_region_code)

eststo m4: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year#month) vce(cluster addr_region_code)

esttab m1 m2 m3 m4 using regression_results.tex, ///
replace se label ///
star(* 0.10 ** 0.05 *** 0.01) ///
title("Difference-in-Differences Regression Results") ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
compress


eststo clear

reghdfe suicide treatXpost, a(addr_region_code year) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year month) ///
vce(cluster addr_region_code age)

reghdfe suicide treatXpost, a(addr_region_code occupation_code year#month) ///
vce(cluster addr_region_code age)
************
eststo m1: reghdfe suicide treatXpost, ///
a(addr_region_code year) vce(cluster addr_region_code)

eststo m2: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year) vce(cluster addr_region_code)

eststo m3: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year month) vce(cluster addr_region_code)

eststo m4: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year#month) vce(cluster addr_region_code)


estadd local region_fe "Yes": m1
estadd local occupation_fe "No": m1
estadd local year_fe "Yes": m1
estadd local month_fe "No": m1

estadd local region_fe "Yes": m2
estadd local occupation_fe "Yes": m2
estadd local year_fe "Yes": m2
estadd local month_fe "No": m2

estadd local region_fe "Yes": m3
estadd local occupation_fe "Yes": m3
estadd local year_fe "Yes": m3
estadd local month_fe "Yes": m3

estadd local region_fe "Yes": m4
estadd local occupation_fe "Yes": m4
estadd local year_fe "Yes": m4
estadd local month_fe "Yes": m4


esttab m1 m2 m3 m4 using regression_results.tex, ///
replace se label ///
star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
stats(region_fe occupation_fe year_fe month_fe N, ///
labels("Region FE" "Occupation FE" "Year FE" "Month FE" "Observations")) ///
compress



eststo m1: reghdfe suicide treatXpost, ///
a(addr_region_code year) vce(cluster addr_region_code age)

eststo m2: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year) vce(cluster addr_region_code age)

eststo m3: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year month) vce(cluster addr_region_code age)

eststo m4: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year#month) vce(cluster addr_region_code age)



*Table

eststo m1: reghdfe suicide treatXpost, a(addr_region_code year) vce(cluster addr_region_code)

eststo m2: reghdfe suicide treatXpost, a(addr_region_code occupation_code year) vce(cluster addr_region_code)

eststo m3: reghdfe suicide treatXpost, a(addr_region_code occupation_code year month) vce(cluster addr_region_code)

eststo m4: reghdfe suicide treatXpost, a(addr_region_code occupation_code year#month) vce(cluster addr_region_code)


esttab m1 m2 m3 m4 using regression_results.rtf, se star(* 0.10 ** 0.05 *** 0.01) replace

*********

esttab m1 m2 m3 m4 using regression_results.tex, ///
replace se label ///
star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
stats(region_fe occupation_fe year_fe month_fe N, ///
labels("Region FE" "Occupation FE" "Year FE" "Month FE" "Observations")) ///
compress

ssc install reghdfe
ssc install ftools
ssc install estout



* Revision Regressions 

eststo clear

eststo m1: reghdfe suicide treatXpost, ///
a(addr_region_code year) vce(cluster addr_region_code age)

eststo m2: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year) vce(cluster addr_region_code age)

eststo m3: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year month) vce(cluster addr_region_code age)

eststo m4: reghdfe suicide treatXpost, ///
a(addr_region_code occupation_code year#month) vce(cluster addr_region_code age)


estadd local region_fe "Yes": m1
estadd local occupation_fe "No": m1
estadd local year_fe "Yes": m1
estadd local month_fe "No": m1

estadd local region_fe "Yes": m2
estadd local occupation_fe "Yes": m2
estadd local year_fe "Yes": m2
estadd local month_fe "No": m2

estadd local region_fe "Yes": m3
estadd local occupation_fe "Yes": m3
estadd local year_fe "Yes": m3
estadd local month_fe "Yes": m3

estadd local region_fe "Yes": m4
estadd local occupation_fe "Yes": m4
estadd local year_fe "Yes": m4
estadd local month_fe "Yes": m4

esttab m1 m2 m3 m4 using regression_results.tex, ///
replace se label ///
star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
stats(region_fe occupation_fe year_fe month_fe N, ///
labels("Region FE" "Occupation FE" "Year FE" "Month FE" "Observations")) ///
compress


* Event Study 


gen event_time = month - 3
gen event_time_shift = event_time + 3

reghdfe suicide i.event_time_shift##i.treat, ///
a(addr_region_code occupation_code year#month) ///
vce(cluster addr_region_code age)

coefplot, ///
keep(*event_time_shift#1.treat*) ///
vertical ///
yline(0) ///
ciopts(recast(rcap)) ///
xlabel(1 "-2" 2 "-1" 3 "0" 4 "1" 5 "2" 6 "3" 7 "4" 8 "5" 9 "6") ///
xtitle("Months Relative to Start of Academic Year") ///
ytitle("Effect on Suicide Incidence")

* Graphs 

collapse (count) suicide, by(year)

twoway ///
(line suicide year, lcolor(gray) lwidth(medthick)), ///
xtitle("Year", size(small)) ///
ytitle("Number of Suicide Deaths", size(small)) ///
xlabel(1997(2)2023, labsize(small) nogrid) ///
ylabel(, labsize(small) angle(horizontal) nogrid) ///
scheme(s2color) ///
graphregion(color(white)) ///
plotregion(color(white))

graph export suicide_trend_Annual.pdf, replace

*Monthlytrend

preserve
collapse (count) suicide, by(month)

describe death_date_st

gen month = month(death_date_st)

preserve
collapse (count) suicide, by(month)

twoway ///
(line suicide month, lcolor(gray) lwidth(medthick)), ///
xtitle("Month", size(vsmall)) ///
ytitle("Number of Suicide Deaths", size(vsmall)) ///
xlabel(1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
       7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", labsize(vsmall)) ///
ylabel(, labsize(vsmall) angle(horizontal) nogrid) ///
scheme(plotplain) ///
graphregion(color(white)) ///
plotregion(color(white))

graph export monthly_trend.pdf, replace

restore



* Event Study

gen suicide = 0
replace suicide = 1 if cause104_code == 102 & cause57_code == 55

tab suicide
tab cause104_code cause57_code if suicide == 1

tostring death_date, gen(date_str)
gen date = date(date_str,"YMD")
format date %td

list death_date date in 1/10

drop year

gen year  = year(date)
gen month = month(date)
gen day   = day(date)

tab month

gen window = 0
replace window = 1 if month == 2 & day >= 20
replace window = 1 if month == 3 & day <= 12
keep if window == 1

gen treat = 0
replace treat = 1 if occupation_code == 13 & age >= 11 & age <= 19

gen post = 0
replace post = 1 if month == 3 & day >= 2

* define event date (March 2 each year)
gen event_date = mdy(3,2,year)

* days relative to the event
gen event_time = date - event_date

* keep event window (about ±10 days)
keep if event_time >= -10 & event_time <= 10

* shift so values are positive (needed for factor variables)
gen event_time_shift = event_time + 10

reghdfe suicide i.treat##ib9.event_time_shift, ///
a(addr_region_code occupation_code year#month) ///
vce(cluster addr_region_code age)

ssc install regsave

regsave using event_results, ci level(95) replace

use event_results, clear
browse

drop if strpos(var,"0b.treat")
drop if var=="_cons"
gen time = real(regexs(1)) if regexm(var,"#([0-9]+)")
replace time = time - 10

sort time

twoway ///
(line coef time, lc(black)) ///
(scatter coef time, mc(black) msize(small)) ///
(rcap ci_lower ci_upper time, lc(black)), ///
yline(0, lpattern(dash)) ///
xtitle("Days Relative to Start of Academic Year (March 2)") ///
ytitle("Effect on Suicide Incidence") ///
xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10) ///
graphregion(color(white))

tab time
drop time

gen time = real(regexs(1)) if regexm(var,"#([0-9]+)\.")
replace time = time - 10

sort time
list var time in 1/20

twoway ///
(line coef time, lc(black)) ///
(scatter coef time, mc(black) msize(small)) ///
(rcap ci_lower ci_upper time, lc(black)), ///
yline(0, lpattern(dash)) ///
xtitle("Days Relative to Start of Academic Year (March 2)") ///
ytitle("Effect on Suicide Incidence") ///
xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10) ///
graphregion(color(white))


sort time

twoway ///
(rcap ci_lower ci_upper time, lc(black)) ///
(scatter coef time, mc(black) msize(small)), ///
yline(0, lpattern(dash)) ///
xtitle("Days Relative to Start of Academic Year (March 2)") ///
ytitle("Effect on Suicide Incidence") ///
xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10) ///
legend(off) ///
graphregion(color(white))


twoway ///
(rcap ci_lower ci_upper time, lc(black)) ///
(scatter coef time, mc(black) msize(small)), ///
yline(0, lpattern(dash)) ///
xline(0, lpattern(dash) lcolor(gray)) ///
xtitle("Days Relative to Start of Academic Year (March 2)") ///
ytitle("Effect on Suicide Incidence") ///
xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10) ///
legend(off) ///
graphregion(color(white))


drop if time == -1

twoway ///
(rcap ci_lower ci_upper time, lc(black)) ///
(scatter coef time, mc(black) msize(small)), ///
yline(0, lpattern(dash)) ///
xline(0, lpattern(dash) lcolor(gs8)) ///
xtitle("Days Relative to Start of Academic Year (March 2)") ///
ytitle("Effect on Suicide Incidence") ///
xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10) ///
legend(off) ///
graphregion(color(white))

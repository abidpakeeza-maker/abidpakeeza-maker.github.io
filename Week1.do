

* Verification of monthly trend (March spike)
*=============================================
use "/Users/pakeeza/Documents/Thesis_Alldatafiles/merged_data_translatedvnames copy.dta", clear

keep if cause57_code == 55
 
* gen suicide = 1
gen suicide = cause57_code == 55



tostring death_date, replace

drop year
gen year = substr(death_date, 1, 4)
gen month = substr(death_date, 5, 2)
gen day = substr(death_date, -2, 2)

foreach v of var year month day {
	destring `v', replace
}

collapse (sum) suicide , by(month)

two (connected suicide month) 


*=======

label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", replace
label values month monthlbl

twoway connected suicide month, ///
xlabel(1(1)12, valuelabel) ///
xtitle("Month") ///
ytitle("Number of Suicide Deaths") ///
legend(off)

twoway (connected suicide month, ///
lcolor(gs8) mcolor(gs8)), ///
xlabel(1(1)12, valuelabel) ///
xtitle("Month") ///
ytitle("Number of Suicide Deaths") ///
legend(off)

twoway (connected suicide month, ///
lcolor(gs6) mcolor(gs6) msymbol(o)), ///
xlabel(1(1)12, valuelabel) ///
xtitle("Month") ///
ytitle("Number of Suicide Deaths") ///
legend(off) ///
xlabel(, nogrid) ///
ylabel(, nogrid)

* collapse to monthly totals within each year
collapse (sum) suicide, by(year month)

* compute average across years
collapse (mean) suicide, by(month)

two (connected suicide month)

*==============================================================

******************************************************
*  OCCUPATION 13: AGE <25 VS AGE >55
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only occupation_code 13 ---*
keep if occupation_code == 13

*--- Step 4: Create age-based group variable ---*
gen group = ""
replace group = "Age <25" if age < 25
replace group = "Age >55" if age > 55

* Drop anyone not in these two groups
drop if missing(group)

*--- Step 5: Collapse suicides by month and group (all years) ---*
collapse (sum) suicide, by(death_month group)

*--- Step 6: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 7: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Age <25", sort lcolor(red) lwidth(medthick)) ///
       (line suicide death_month if group=="Age >55", sort lcolor(green) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Occupation 13 by Age Group") ///
       subtitle("All years collapsed (1997–2023), Age <25 vs Age >55") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Age <25" 2 "Age >55") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 8: Save the collapsed data ---*
save "monthly_occ13_age_extremes.dta", replace



******************************************************
*  HIGH SCHOOL VS NO SCHOOLING YOUTH
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only relevant education codes ---*
keep if inlist(education_code, 1,4)

*--- Step 4: Keep relevant age ranges ---*
* High School: 12–22
* No Schooling: 12 and above
keep if (education_code == 4 & age >= 12 & age <= 22) | (education_code == 1 & age >= 12)

*--- Step 5: Create group variable ---*
gen group = ""
replace group = "No Schooling" if education_code == 1
replace group = "High School" if education_code == 4

*--- Step 6: Collapse suicides by month and group ---*
collapse (sum) suicide, by(death_month group)

*--- Step 7: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 8: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="No Schooling", sort lcolor(black) lwidth(medthick)) ///
       (line suicide death_month if group=="High School", sort lcolor(red) lpattern(dash)) ///
       , title("Monthly Suicide Trend: High School vs No Schooling") ///
       subtitle("All years collapsed (1997–2023)") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "No Schooling" 2 "High School") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 9: Save the collapsed data ---*
save "monthly_highschool_vs_noschooling.dta", replace





******************************************************
*  OCCUPATION 13: AGE <25 VS AGE ≥25
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only occupation_code 13 ---*
keep if occupation_code == 13

*--- Step 4: Create age-based group variable ---*
gen group = ""
replace group = "Age <25" if age < 25
replace group = "Age ≥25" if age >= 25

* Drop anyone not in these two groups (shouldn't be any)
drop if missing(group)

*--- Step 5: Collapse suicides by month and group (all years) ---*
collapse (sum) suicide, by(death_month group)

*--- Step 6: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 7: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Age <25", sort lcolor(red) lwidth(medthick)) ///
       (line suicide death_month if group=="Age ≥25", sort lcolor(blue) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Occupation 13 by Age Group") ///
       subtitle("All years collapsed (1997–2023)") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Age <25" 2 "Age ≥25") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 8: Save the collapsed data ---*
save "monthly_occ13_agegroups.dta", replace





******************************************************
*  MIDDLE SCHOOL VS HIGH SCHOOL YOUTH
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only age 12–18 ---*
keep if age >= 12 & age <= 18

*--- Step 4: Keep only education_code 3 or 4 ---*
keep if inlist(education_code, 3,4)

*--- Step 5: Create group variable ---*
gen group = ""
replace group = "Middle School" if education_code == 3
replace group = "High School"   if education_code == 4

*--- Step 6: Collapse suicides by month and group ---*
collapse (sum) suicide, by(death_month group)

*--- Step 7: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 8: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Middle School", sort lcolor(orange) lwidth(medthick)) ///
       (line suicide death_month if group=="High School", sort lcolor(red) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Middle School vs High School Youth") ///
       subtitle("All years collapsed (1997–2023), Age 12–18") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Middle School" 2 "High School") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 9: Save the collapsed data ---*
save "monthly_middle_vs_highschool.dta", replace





******************************************************
*  HIGH SCHOOL VS UNIVERSITY YOUTH
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only age 12–22 ---*
keep if age >= 12 & age <= 22

*--- Step 4: Keep only education_code 4 or 5 ---*
keep if inlist(education_code, 4,5)

*--- Step 5: Create group variable ---*
gen group = ""
replace group = "High School" if education_code == 4
replace group = "University"  if education_code == 5

*--- Step 6: Collapse suicides by month and group ---*
collapse (sum) suicide, by(death_month group)

*--- Step 7: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 8: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="High School", sort lcolor(red) lwidth(medthick)) ///
       (line suicide death_month if group=="University", sort lcolor(blue) lpattern(dash)) ///
       , title("Monthly Suicide Trend: High School vs University Youth") ///
       subtitle("All years collapsed (1997–2023), Age 12–22") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "High School" 2 "University") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 9: Save the collapsed data ---*
save "monthly_highschool_vs_university.dta", replace





*****************************************************
*  EDUCATION-BASED YOUTH GROUPS
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Define groups based on education and age ---*
gen group = ""
replace group = "Uneducated youth" if education_code == 1 & age > 22
replace group = "Educated youth"   if inlist(education_code, 2,3,5) & age < 22

* Drop observations not in either group
drop if missing(group)

*--- Step 4: Collapse suicides by month and group (all years) ---*
collapse (sum) suicide, by(death_month group)

*--- Step 5: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 6: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Uneducated youth", sort lcolor(red) lwidth(medthick)) ///
       (line suicide death_month if group=="Educated youth", sort lcolor(blue) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Education-based Youth Groups") ///
       subtitle("All years collapsed (1997–2023)") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Uneducated youth" 2 "Educated youth") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

save "monthly_educated_vs_uneducated_youth.dta", replace



*===================================================


*---------------------------------------------*
* Suicides within Week (Code = 13) Students 
*---------------------------------------------*
use suicide_only_data, clear

gen str8 death_str = string(death_date, "%08.0f")

gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
gen death_day   = real(substr(death_str, 7, 2))

gen death_date1 = mdy(death_month, death_day, death_year)
format death_date1 %td

* --- Create day-of-week variable (1=Monday, ..., 7=Sunday) ---
gen death_dow = mod(dow(death_date1) + 6, 7) + 1
label define dow_lbl 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday" 7 "Sunday"
label values death_dow dow_lbl

*keep if occupation_code ~= 13
keep if occupation_code == 13
keep if age>=11 & age<=19
keep if death_year >= 1997 & death_year <= 2023
collapse (sum) suicide, by(death_dow occupation_code)

line suicide death_dow, by(occupation_code) ///
 xlabel(1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday" 7 "Sunday")
 
line suicide death_dow, by(occupation_code, ///
    graphregion(color(white))) ///
xlabel(1 "Mon" 2 "Tue" 3 "Wed" 4 "Thu" 5 "Fri" 6 "Sat" 7 "Sun", labsize(vsmall) nogrid) ///
ylabel(, labsize(vsmall) angle(horizontal) nogrid) ///
xtitle("Day of Week", size(vsmall)) ///
ytitle("Number of Suicide Deaths", size(vsmall)) ///
scheme(plotplain) ///
graphregion(color(white)) ///
plotregion(color(white))


line suicide death_dow if occupation_code==13, ///
xlabel(1 "Mon" 2 "Tue" 3 "Wed" 4 "Thu" 5 "Fri" 6 "Sat" 7 "Sun", labsize(vsmall) nogrid) ///
ylabel(, labsize(vsmall) angle(horizontal) nogrid) ///
xtitle("Day of Week", size(vsmall)) ///
ytitle("Number of Suicide Deaths", size(vsmall)) ///
scheme(plotplain) ///
graphregion(color(white)) ///
plotregion(color(white))

graph export weekly_trend_students.pdf, replace
graph export weekly_trend_students.pdf, replace width(2000)
*====================================
* All Codes (Within Week)
*===================================== 

use suicide_only_data, clear

gen str8 death_str = string(death_date, "%08.0f")

gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
gen death_day   = real(substr(death_str, 7, 2))

gen death_date1 = mdy(death_month, death_day, death_year)
format death_date1 %td

* --- Create day-of-week variable (1=Monday, ..., 7=Sunday) ---
gen death_dow = mod(dow(death_date1) + 6, 7) + 1
label define dow_lbl 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday" 7 "Sunday"
label values death_dow dow_lbl

keep if death_year >= 1997 & death_year <= 2023
collapse (sum) suicide, by(death_dow occupation_code)

line suicide death_dow, by(occupation_code) ///
 xlabel(1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday" 7 "Sunday")
 
 
tab occupation_code 

*========================================
* Trend Within Month (All years Collapsed)
*=========================================

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* --- Keep years 1997-2023 ---
keep if death_year >= 1997 & death_year <= 2023

preserve
* --- Collapse suicides by month & day across all years ---
collapse (sum) suicide, by(death_month death_day)

* --- Drop impossible days ---
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

sort death_month death_day

* --- Month names ---
local monthnames "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
local graphs ""  // to store graph names

* --- Loop to create 12 graphs ---
forvalues m = 1/12 {
    count if death_month == `m'
    if r(N) > 0 {
        local mname : word `m' of `monthnames'
        
        twoway ///
            (line suicide death_day if death_month==`m', lcolor(gray) lwidth(medthick)) ///
            (scatter suicide death_day if death_month==`m', msymbol(circle) msize(vsmall) mcolor(blue%50)), ///
            title("`mname'") xtitle("Day of Month") ytitle("Number of Suicides") ///
            name(month`m', replace) nodraw ///
			yscale(range(600 1000)) ylabel(600(100)1000) ///
            scheme(s2color) graphregion(color(white)) plotregion(color(white))
        
        local graphs "`graphs' month`m'"
    }
}

* --- Combine all 12 graphs into one panel ---
graph combine `graphs', cols(4) title("Daily Suicide Trends Within Each Month (1997–2023)") imargin(2 2 2 2) graphregion(color(white)) plotregion(color(white)) name(daily_trends_all_months, replace)

* --- Save & export ---
graph save "daily_trends_all_months.gph", replace
graph export "daily_trends_all_months.png", width(2400) replace


*========================================
* One graph 
*========================================

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* Keep 1997–2023
keep if death_year >= 1997 & death_year <= 2023

* Collapse suicides by month & day
collapse (sum) suicide, by(death_month death_day)

* Drop impossible days
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

* ---- Create continuous day-of-year (DOY) ----
gen doy = mdy(death_month, death_day, 2000) - mdy(1,1,2000) + 1

sort doy

* ---- One single graph ----
twoway ///
    (line suicide doy, lcolor(navy) lwidth(medthick)), ///
    xtitle("Month of Year (Jan → Dec)") ///
    ytitle("Number of Suicides (Sum across 1997–2023)") ///
    title("Daily Suicide Pattern Across the Year (1997–2023)") ///
    xlabel(1 "Jan" 32 "Feb" 60 "Mar" 91 "Apr" 121 "May" 152 "Jun" ///
           182 "Jul" 213 "Aug" 244 "Sep" 274 "Oct" 305 "Nov" 335 "Dec") ///
    scheme(s1color) graphregion(color(white)) plotregion(color(white))

graph export "yearly_suicide_trend.png", replace width(2400)

restore
 
preserve
keep if age<=18
* --- Collapse suicides by month & day across all years ---
collapse (sum) suicide, by(death_month death_day)

* --- Drop impossible days ---
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

sort death_month death_day

* --- Month names ---
local monthnames "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
local graphs ""  // to store graph names

* --- Loop to create 12 graphs ---
forvalues m = 1/12 {
    count if death_month == `m'
    if r(N) > 0 {
        local mname : word `m' of `monthnames'
        
        twoway ///
            (line suicide death_day if death_month==`m', lcolor(red) lwidth(medthick)) ///
            (scatter suicide death_day if death_month==`m', msymbol(circle) msize(vsmall) mcolor(red%50)), ///
            title("`mname'") xtitle("Day of Month") ytitle("Number of Suicides") ///
            name(month`m', replace) nodraw ///
			yscale(range(0 50)) ylabel(0(10)50) ///
            scheme(s1color) graphregion(color(white)) plotregion(color(white))
        
        local graphs "`graphs' month`m'"
    }
}

* --- Combine all 12 graphs into one panel ---
graph combine `graphs', cols(4) title("Daily Suicide Trends Within Each Month (1997–2023)") imargin(2 2 2 2) graphregion(color(white)) plotregion(color(white)) name(daily_trends_all_months, replace)

* --- Save & export ---
graph save "daily_trends_all_months_under19.gph", replace
graph export "daily_trends_all_months_under19.png", width(2400) replace

restore

*========================================
* One Graph (Code = 13 , age <=18)

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* Keep 1997–2023
keep if death_year >= 1997 & death_year <= 2023

* --- Filter for age <= 18 and occupation_code = 13 ---
keep if age <= 18 & occupation_code == 13

* Collapse suicides by month & day
collapse (sum) suicide, by(death_month death_day)

* Drop impossible days
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

* ---- Create continuous day-of-year (DOY) ----
gen doy = mdy(death_month, death_day, 2000) - mdy(1,1,2000) + 1

sort doy

* ---- One single graph ----
twoway ///
    (line suicide doy, lcolor(navyblue) lwidth(medthick)), ///
    xtitle("Months") ///
    ytitle("Number of Suicides") ///
    title("Daily Suicide Pattern- Students (1997–2023)") ///
    xlabel(1 "Jan" 32 "Feb" 60 "Mar" 91 "Apr" 121 "May" 152 "Jun" ///
           182 "Jul" 213 "Aug" 244 "Sep" 274 "Oct" 305 "Nov" 335 "Dec") ///
    scheme(s1color) graphregion(color(white)) plotregion(color(white))

graph export "yearly_suicide_trend_under18_occ13.png", replace width(2400)

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* Keep 1997–2023
keep if death_year >= 1997 & death_year <= 2023


* Collapse suicides by month & day
collapse (sum) suicide, by(death_month death_day)

* Drop impossible days
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

* ---- Create continuous day-of-year (DOY) ----
gen doy = mdy(death_month, death_day, 2000) - mdy(1,1,2000) + 1

sort doy

	* ---- One single graph with dotted vertical lines at month starts ----
twoway (line suicide doy, lcolor(black) lwidth(medthick)) ///
       , xline(1 32 60 91 121 152 182 213 244 274 305 335, lpattern(dash) lcolor(gs12)) ///
         xtitle("Months") ///
         ytitle("Number of Suicides") ///
         title("Daily Suicide Pattern (1997–2023)") ///
         xlabel(1 "Jan" 32 "Feb" 60 "Mar" 91 "Apr" 121 "May" 152 "Jun" ///
                182 "Jul" 213 "Aug" 244 "Sep" 274 "Oct" 305 "Nov" 335 "Dec") ///
         scheme(s1color) graphregion(color(white)) plotregion(color(white))

*
*========================================
* One Graph (Code = 13 , age <=18) with month start lines
*========================================

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* Keep 1997–2023
keep if death_year >= 1997 & death_year <= 2023

* --- Filter for age <= 18 and occupation_code = 13 ---
keep if age <= 19 & occupation_code == 13

* Collapse suicides by month & day
collapse (sum) suicide, by(death_month death_day)

* Drop impossible days
drop if death_day > 28 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

* ---- Create continuous day-of-year (DOY) ----
gen doy = mdy(death_month, death_day, 2000) - mdy(1,1,2000) + 1

sort doy

	* ---- One single graph with dotted vertical lines at month starts ----
twoway (line suicide doy, lcolor(black) lwidth(medthick)) ///
       , xline(1 32 60 91 121 152 182 213 244 274 305 335, lpattern(dash) lcolor(gs12)) ///
         xtitle("Months") ///
         ytitle("Number of Suicides") ///
         title("Daily Suicide Pattern- Students (1997–2023)") ///
         xlabel(1 "Jan" 32 "Feb" 60 "Mar" 91 "Apr" 121 "May" 152 "Jun" ///
                182 "Jul" 213 "Aug" 244 "Sep" 274 "Oct" 305 "Nov" 335 "Dec") ///
         scheme(s1color) graphregion(color(white)) plotregion(color(white))

graph export "yearly_suicide_trend_under18_occ13.png", replace width(2400)


*==================================================
* Trend Within Months (Only Code = 13)
*==================================================

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* --- Keep years 1997-2023 ---
keep if death_year >= 1997 & death_year <= 2023
keep if occupation_code == 13
keep if age >50

* --- Collapse suicides by month & day across all years ---
collapse (sum) suicide, by(death_month death_day)

* --- Drop impossible days ---
drop if death_day > 29 & death_month == 2
drop if death_day > 30 & inlist(death_month,4,6,9,11)

sort death_month death_day

* --- Month names ---
local monthnames "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
local graphs ""  // to store graph names

* --- Loop to create 12 graphs ---
forvalues m = 1/12 {
    count if death_month == `m'
    if r(N) > 0 {
        local mname : word `m' of `monthnames'
        
        twoway ///
            (line suicide death_day if death_month==`m', lcolor(navy) lwidth(medthick)) ///
            (scatter suicide death_day if death_month==`m', msymbol(circle) msize(vsmall) mcolor(blue%50)), ///
            title("`mname'") xtitle("Day of Month") ytitle("Number of Suicides") ///
            name(month`m', replace) nodraw ///
            scheme(s1color) graphregion(color(white)) plotregion(color(white))
        
        local graphs "`graphs' month`m'"
    }
}

* --- Combine all 12 graphs into one panel ---
graph combine `graphs', cols(4) title("Daily Suicide Trends Within Each Month (Code=13)") imargin(2 2 2 2) graphregion(color(white)) plotregion(color(white)) name(daily_trends_all_months, replace)



*=========================================================

* Feb Vs March (Within Month trend - All years Collapsed)

*=========================================================

use suicide_only_data, clear
drop report_*

* --- Extract year, month, day ---
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

* --- Limit to years 1997–2023 ---
keep if death_year >= 1997 & death_year <= 2023

* --- Collapse suicides by month & day across all years ---
collapse (sum) suicide, by(death_month death_day)

* --- Drop impossible days ---
drop if death_day > 29 & death_month == 2
drop if death_day > 30 & death_month == 4

* --- February vs March graph ---
twoway ///
    (line suicide death_day if death_month==2, lcolor(red) lwidth(medthick) lpattern(solid)) ///
    (scatter suicide death_day if death_month==2, msymbol(circle) msize(vsmall) mcolor(red%50)) ///
    (line suicide death_day if death_month==3, lcolor(blue) lwidth(medthick) lpattern(solid)) ///
    (scatter suicide death_day if death_month==3, msymbol(circle) msize(vsmall) mcolor(blue%50)), ///
    xtitle("Day of Month") ytitle("Number of Suicides") ///
    title("Daily Suicide Trends: February vs March (1997–2023)") ///
    legend(order(1 "Feb" 3 "Mar")) ///
    graphregion(color(white)) plotregion(color(white)) ///
    scheme(s1color)

	graph save "FebvsMarch_WithinMonth.gph", replace
	
	
	
*==========================================================

******************************************************
*  OCCUPATION 13: AGE <25 VS AGE >55
*  Monthly suicide trend (all years collapsed)
******************************************************

*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only occupation_code 13 ---*
keep if occupation_code == 13

*--- Step 4: Create age-based group variable ---*
gen group = ""
replace group = "Age <25" if age < 25
replace group = "Age >55" if age > 55

* Drop anyone not in these two groups
drop if missing(group)

*--- Step 5: Collapse suicides by month and group (all years) ---*
collapse (sum) suicide, by(death_month group)

*--- Step 6: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 7: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Age <25", sort lcolor(red) lwidth(medthick)) ///
       (line suicide death_month if group=="Age >55", sort lcolor(green) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Occupation 13 by Age Group") ///
       subtitle("All years collapsed (1997–2023), Age <25 vs Age >55") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Age <25" 2 "Age >55") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

*--- Step 8: Save the collapsed data ---*
save "monthly_occ13_age_extremes.dta", replace



*-------------------------------------------*
* March Daily Suicide Trend - Occupation 13
* Age Groups: 6–12, 12–15, 15–18, 18–22, 22–27
*-------------------------------------------*

use suicide_only_data, clear

* Extract date parts
gen str8 death_str = string(death_date, "%08.0f")
gen year_  = real(substr(death_str, 1, 4))
gen month = real(substr(death_str, 5, 2))
gen day   = real(substr(death_str, 7, 2))
drop death_str

* Keep only March and occupation_code = 13
keep if month == 3 & occupation_code == 13 & !missing(age)

* Define age groups
gen age_group = .
replace age_group = 1 if age >= 6  & age <= 12
replace age_group = 2 if age >= 12 & age <= 15
replace age_group = 3 if age >= 15 & age <= 18
replace age_group = 4 if age >= 18 & age <= 22
replace age_group = 5 if age >= 22 & age <= 27

label define agegrp 1 "6–12 (Elementary)" ///
                   2 "12–15 (Middle)" ///
                   3 "15–18 (High School)" ///
                   4 "18–22 (University)" ///
                   5 "22–27 (Young Unemployed)"
label values age_group agegrp

drop if missing(age_group)

* Collapse by day and age group
collapse (sum) suicide, by(age_group day)

* Keep only March days
keep if day >= 1 & day <= 30


twoway ///
(line suicide day if age_group==1, lcolor(blue) lwidth(medthick) msymbol(circle) msize(tiny)) ///
(line suicide day if age_group==2, lcolor(teal) lwidth(medthick) msymbol(circle) msize(tiny)) ///
(line suicide day if age_group==3, lcolor(orange) lwidth(medthick) msymbol(circle) msize(tiny)) ///
(line suicide day if age_group==4, lcolor(red) lwidth(medthick) msymbol(circle) msize(tiny)) ///
(line suicide day if age_group==5, lcolor(purple) lwidth(medthick) msymbol(circle) msize(tiny)), ///
xtitle("Day of March", size(medlarge)) ///
ytitle("Number of Suicides", size(medlarge)) ///
xlabel(1(2)30, labsize(medium)) ///
ylabel(, labsize(medium)) ///
title("March Daily Suicide Trend - Occupation 13", size(large)) ///
subtitle("All years collapsed (1997–2023)", size(small)) ///
legend(order(1 "6–12" 2 "12–15" 3 "15–18" 4 "18–22" 5 "22–27") ///
       region(lcolor(white)) position(3) ring(0) rows(1) size(medsmall)) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
scheme(s1color)





*==========================================
*--- Step 1: Load dataset ---*
use "suicide_only_data.dta", clear

*--- Step 2: Extract year and month from death_date ---*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
drop death_str

*--- Step 3: Keep only occupation_code 13 ---*
keep if occupation_code == 13

*--- Step 4: Create age-based group variable ---*
gen group = ""
replace group = "Age <25" if age < 25
replace group = "Age >=25 <=54" if age >=25 & age <=54
replace group = "Age >55" if age > 55

* Drop anyone not in these two groups
drop if missing(group)

*--- Step 5: Collapse suicides by month and group (all years) ---*
collapse (sum) suicide, by(death_month group)

*--- Step 6: Label months for clarity ---*
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values death_month monthlbl

*--- Step 7: Plot monthly suicide trends ---*
twoway (line suicide death_month if group=="Age <25", sort lcolor(red) lwidth(medthick)) ///
(line suicide death_month if group=="Age >=25 <=54", sort lcolor(balck) lwidth(medthick)) ///
       (line suicide death_month if group=="Age >55", sort lcolor(green) lpattern(dash)) ///
       , title("Monthly Suicide Trend: Occupation 13 by Age Group") ///
       subtitle("All years collapsed (1997–2023), Age <25 vs Age >55") ///
       xtitle("Month") ytitle("Number of Suicides") ///
       xlabel(1(1)12, valuelabel) ///
       legend(order(1 "Age <25" 2 "Age >=25 <=54" 3 "Age >55") region(lcolor(white))) ///
       graphregion(color(white)) bgcolor(white)

	   
	   
	   
*=====================================
* Week 2 . 30/10/25
*=====================================

*------------------------------------------------------*
* STEP 1. Load data and extract year, month, day
*------------------------------------------------------*
use suicide_only_data, clear
drop report_*

gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
drop death_str

keep if inrange(death_year, 2005, 2017)

*------------------------------------------------------*
* STEP 2. Keep students (occupation 13) aged 6–18
*------------------------------------------------------*
keep if occupation_code == 13
keep if age >= 6 & age <= 18

*------------------------------------------------------*
* STEP 3. Create treatment variable by region
*------------------------------------------------------*
gen treatment = .

replace treatment = 1 if addr_region_code == 11   // Seoul
replace treatment = 2 if addr_region_code == 24   // Gwangju
replace treatment = 3 if addr_region_code == 35   // Jeonbuk (North Jeolla)
replace treatment = 4 if addr_region_code == 31   // Gyeonggi-do
replace treatment = 5 if inlist(addr_region_code, 21,22,23,25,26,32,33,36,37,38) // Controls

label define trt 1 "Seoul (2012)" 2 "Gwangju (2012)" 3 "Jeonbuk (2013)" 4 "Gyeonggi-do (2012)" 5 "Control Regions"
label values treatment trt

drop if missing(treatment)

*------------------------------------------------------*
* STEP 4. Collapse to yearly treatment-level suicides
*------------------------------------------------------*
collapse (count) suicide, by(death_year treatment)
rename death_year year

*------------------------------------------------------*
* STEP 5. Plot the trends
*------------------------------------------------------*

twoway ///
(line suicide year if treatment==1, lcolor(blue) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==2, lcolor(red) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==3, lcolor(green) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==4, lcolor(orange) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==5, lcolor(gs8) lpattern(dash) lwidth(medthick)) ///
legend(order(1 "Seoul (2012)" 2 "Gwangju (2012)" 3 "Jeonbuk (2013)" 4 "Gyeonggi-do (2010)" 5 "Control Regions"), ///
region(lstyle(none) col(1)) position(6) ring(0) cols(5) labsize(small)) ///
xline(2010, lpattern(dash) lcolor(black) lwidth(thin)) ///
xline(2012, lpattern(dash) lcolor(black) lwidth(thin)) ///
xline(2013, lpattern(dash) lcolor(black) lwidth(thin)) ///
text(2010 180 "Gyeonggi-do Policy", place(w) size(small)) ///
text(2012 180 "Seoul & Gwangju Policy", place(w) size(small)) ///
text(2013 180 "Jeonbuk Policy", place(w) size(small)) ///
title("Student (Age 6–18) Suicide Trends by Region Group (2005–2017)", size(medium) margin(medsmall)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Year", size(small)) ///
xlabel(2005(1)2017, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)


*=========================
* Seoul
*=========================

twoway ///
(line suicide year if treatment==1, lcolor(blue) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Seoul (2012)" 2 "Control Regions") ///
region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
xline(2012, lpattern(dash) lcolor(black) lwidth(thin)) ///
text(2012 180 "Policy Enacted (2012)", place(w) size(small)) ///
title("Student (Age 6–18) Suicide Trends: Seoul vs Control (2005–2017)", size(medium) margin(medsmall)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Year", size(small)) ///
xlabel(2005(1)2017, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)

*=========================
* Gwangju
*=========================

twoway ///
(line suicide year if treatment==2, lcolor(red) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Gwangju (2012)" 2 "Control Regions") ///
region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
xline(2012, lpattern(dash) lcolor(black) lwidth(thin)) ///
text(2012 180 "Policy Enacted (2012)", place(w) size(small)) ///
title("Student (Age 6–18) Suicide Trends: Gwangju vs Control (2005–2017)", size(medium) margin(medsmall)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Year", size(small)) ///
xlabel(2005(1)2017, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)



*==========================
* Jeongbuk
*==========================

twoway ///
(line suicide year if treatment==3, lcolor(green) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Jeonbuk (2013)" 2 "Control Regions") ///
region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
xline(2013, lpattern(dash) lcolor(black) lwidth(thin)) ///
text(2013 180 "Policy Enacted (2013)", place(w) size(small)) ///
title("Student (Age 6–18) Suicide Trends: Jeonbuk vs Control (2005–2017)", size(medium) margin(medsmall)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Year", size(small)) ///
xlabel(2005(1)2017, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)

*==========================
* Gyeonggi-do
*==========================

twoway ///
(line suicide year if treatment==4, lcolor(orange) lwidth(medthick) lpattern(solid)) ///
(line suicide year if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Gyeonggi-do (2010)" 2 "Control Regions") ///
region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
xline(2010, lpattern(dash) lcolor(black) lwidth(thin)) ///
text(2010 180 "Policy Enacted (2010)", place(w) size(small)) ///
title("Student (Age 6–18) Suicide Trends: Gyeonggi-do vs Control (2005–2017)", size(medium) margin(medsmall)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Year", size(small)) ///
xlabel(2005(1)2017, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)



*==================================
* March Specific
*==================================

use "suicide_only_data.dta", clear

*------------------------------------------------------*
* STEP 1: Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

*------------------------------------------------------*
* STEP 2: Keep only March
*------------------------------------------------------*
keep if death_month == 3

*------------------------------------------------------*
* STEP 3. Create treatment variable by region
*------------------------------------------------------*
gen treatment = .

replace treatment = 1 if addr_region_code == 11   // Seoul
replace treatment = 2 if addr_region_code == 24   // Gwangju
replace treatment = 3 if addr_region_code == 35   // Jeonbuk (North Jeolla)
replace treatment = 4 if addr_region_code == 31   // Gyeonggi-do
replace treatment = 5 if inlist(addr_region_code, 21,22,23,25,26,32,33,36,37,38) // Controls

label define trt 1 "Seoul (2012)" 2 "Gwangju (2012)" 3 "Jeonbuk (2013)" 4 "Gyeonggi-do (2012)" 5 "Control Regions"
label values treatment trt

drop if missing(treatment)
*------------------------------------------------------*
* STEP 3: Collapse daily counts by day of March, treatment, and year
*------------------------------------------------------*
collapse (sum) suicide, by(death_day treatment death_year)

*=============================
* Graph
*=============================

* 2005–2013 graph
preserve
keep if death_year >= 2005 & death_year <= 2013 & inlist(treatment,1,5)
collapse (sum) suicide, by(death_day treatment)
twoway ///
(line suicide death_day if treatment==1, lcolor(blue) lwidth(medthick)) ///
(line suicide death_day if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
yscale(range(0 250)) ///
legend(order(1 "Seoul (2005–2013)" 2 "Control Regions") region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
title("March Daily Suicides: Seoul vs Control (2005–2013)", size(medium)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Day of March", size(small)) ///
xlabel(1(1)31, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono) ///
name(g1, replace)
restore

* 2013–2022 graph
preserve
keep if death_year >= 2013 & death_year <= 2022 & inlist(treatment,1,5)
collapse (sum) suicide, by(death_day treatment)
twoway ///
(line suicide death_day if treatment==1, lcolor(blue) lwidth(medthick)) ///
(line suicide death_day if treatment==5, lcolor(gs8) lwidth(medthick) lpattern(dash)), ///
yscale(range(0 250)) ///
legend(order(1 "Seoul (2013–2022)" 2 "Control Regions") region(lstyle(none)) col(1) size(small) pos(12) ring(0)) ///
title("March Daily Suicides: Seoul vs Control (2013–2022)", size(medium)) ///
ytitle("Number of Suicides", size(small)) ///
xtitle("Day of March", size(small)) ///
xlabel(1(1)31, labsize(small)) ///
ylabel(, labsize(small)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono) ///
name(g2, replace)
restore

* Combine the two graphs
graph combine g1 g2, title("March Daily Suicides: Seoul vs Control (Two Periods)")



*======================================================*
* Suicide Analysis: Single vs Married Women (1997–2023)
* Policy: Abortion Decriminalization (Jan 1, 2021)
*======================================================*

use "suicide_only_data.dta", clear
*------------------------------------------------------*
* STEP 0: Keep only relevant marital statuses
*------------------------------------------------------*
keep if inlist(marital_status, 1, 2)

*------------------------------------------------------*
* STEP 1: Convert death_date (19970101) to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

*------------------------------------------------------*
* STEP 2: Treatment indicator (single = 1, married = 0)
*------------------------------------------------------*
gen single = (marital_status==1)

*------------------------------------------------------*
* STEP 3: Collapse suicides by year and marital status
*------------------------------------------------------*
collapse (count) suicide, by(death_year single)

*------------------------------------------------------*
* STEP 4: Create post-policy indicator after collapse
*------------------------------------------------------*
gen post2021 = (death_year >= 2021)
gen treat_post = single*post2021

*------------------------------------------------------*
* STEP 5: Difference-in-Differences regression
*------------------------------------------------------*
reg suicide i.single##i.post2021, robust

* Optional: add year fixed effects
* reg suicide i.single##i.post2021 i.death_year, robust

*------------------------------------------------------*
* STEP 6: Visualization - yearly suicide counts
*------------------------------------------------------*
twoway ///
(line suicide death_year if single==1, lcolor(blue) lwidth(medthick)) ///
(line suicide death_year if single==0, lcolor(red) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Single" 2 "Married") pos(12) ring(0) col(1)) ///
xline(2021, lpattern(dash) lcolor(black) lwidth(thin)) ///
title("Yearly Suicides: Single vs Married Women (2017–2023)", size(medium)) ///
ytitle("Number of Suicides") xtitle("Year") ///
xlabel(1997(1)2023, labsize(small)) ///
yscale(range(0 250)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)


*===============================================================
* Married vs Single/divorced/widowed (Domestic Violence Policy)


use "suicide_only_data.dta", clear

*------------------------------------------------------*
* Keep only single, married, widowed, or divorced
*------------------------------------------------------*
keep if inlist(marital_status,1,2,3,4)

*------------------------------------------------------*
* Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

*------------------------------------------------------*
* Keep only years 2017 to 2023
*------------------------------------------------------*
keep if death_year >= 2017 & death_year <= 2023

*------------------------------------------------------*
* Create treatment and control group indicator
*------------------------------------------------------*
gen treated = (marital_status==2)       // 1 = Married (treatment)
gen control = inlist(marital_status,1,3,4) // 0 = Single, Widowed, Divorced (control)

* Make treated = 0 for control
replace treated = 0 if control==1

*------------------------------------------------------*
* Collapse suicides by year and treatment group
*------------------------------------------------------*
collapse (count) suicide, by(death_year treated)

*------------------------------------------------------*
* Plot yearly trend
*------------------------------------------------------*
twoway ///
(line suicide death_year if treated==1, lcolor(blue) lwidth(medthick)) ///
(line suicide death_year if treated==0, lcolor(red) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Married (Treatment)" 2 "Others (Control)") pos(7) ring(0) col(1)) ///
xline(2020, lpattern(dash) lcolor(black) lwidth(thin)) ///
title("Yearly Suicides: Married vs Single/Widowed/Divorced Women (2017–2023)", size(medium)) ///
ytitle("Number of Suicides") xtitle("Year") ///
xlabel(2017(1)2023, labsize(small)) ///
yscale(range(100 250)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)


*=======================================================
* Married vs Divorced (Domestic Violence Policy)

use "suicide_only_data.dta", clear
*------------------------------------------------------*
* Keep only married or divorced women
*------------------------------------------------------*
keep if inlist(marital_status,2,3)  // 2=Married, 3=Divorced

*------------------------------------------------------*
* Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

*------------------------------------------------------*
* Keep only years 2017 to 2023
*------------------------------------------------------*
keep if death_year >= 2017 & death_year <= 2023

*------------------------------------------------------*
* Create treatment indicator
*------------------------------------------------------*
gen treated = (marital_status==2)  // 1 = Married (treatment)
replace treated = 0 if marital_status==3  // 0 = Divorced (control)
*------------------------------------------------------*
* Collapse suicides by year and treatment group
*------------------------------------------------------*
collapse (sum) suicide, by(death_year treated male addr_region_code)
reghdfe suicide treated##male, a(death_year addr_region_code)

gen female = sex == 2
keep if marital_status == 2
collapse (sum) suicide, by(death_year female)
two (connected suicide death_year if female == 1) ///
(line suicide death_year if female == 0)





*=======================================================
* Married vs Divorced (Domestic Violence Policy)

use "suicide_only_data.dta", clear
*------------------------------------------------------*
* Keep only married or divorced women
*------------------------------------------------------*
keep if inlist(marital_status,2,3)  // 2=Married, 3=Divorced

*------------------------------------------------------*
* Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td
gen crisis_impact_group = .
replace crisis_impact_group = 1 if inlist(occupation_code, 5, 7, 8, 9, 13)
replace crisis_impact_group = 2 if inlist(occupation_code, 1, 2, 3, 4, 6, 99)

label define crisisgrp 1 "High Impact" 2 "Low Impact"
label values crisis_impact_group crisisgrp
drop if occupation_code == 13

collapse (sum) suicide, by(death_year crisis_impact_group)

keep if death_year >= 2005 & death_year <= 2014

twoway (line suicide death_year if crisis_impact_group==1, lcolor(red) lpattern(solid)) ///
       (line suicide death_year if crisis_impact_group==2, lcolor(blue) lpattern(dash)), ///
       legend(order(1 "High Impact" 2 "Low Impact")) ///
       title("Suicide Trends by Occupation Group (2005–2012)") ///
       xtitle("Year") ytitle("Number of Suicides")

	   
	   
	   
	   
	   
	   
	   
	   
*------------------------------------------------------*
* Plot yearly trend
*------------------------------------------------------*
twoway ///
(line suicide death_year if treated==1, by(sex) lcolor(blue) lwidth(medthick)) ///
(line suicide death_year if treated==0, by(sex) lcolor(red) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Married (Treatment)" 2 "Divorced (Control)") ///
       position(0) ring(0) col(1) region(lstyle(none))) ///
xline(2019, lpattern(dash) lcolor(black) lwidth(thin)) ///
title("Yearly Suicides: Married vs Divorced Women (2017–2023)", size(medium)) ///
ytitle("Number of Suicides") xtitle("Year") ///
xlabel(2017(1)2023, labsize(small)) ///
yscale(range(0 250)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)

reghdfe suicide treated##sex, a(death_year treated)
*=======================================================
* Married vs Single (Domestic Violence Policy)

*------------------------------------------------------*
* Keep only married or single women
*------------------------------------------------------*
keep if inlist(marital_status,1,2)  // 1=Single, 2=Married

*------------------------------------------------------*
* Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

*------------------------------------------------------*
* Keep only years 2017 to 2023
*------------------------------------------------------*
keep if death_year >= 2017 & death_year <= 2023

*------------------------------------------------------*
* Create treatment indicator
*------------------------------------------------------*
gen treated = (marital_status==2)  // 1 = Married (treatment)
replace treated = 0 if marital_status==1  // 0 = Single (control)

*------------------------------------------------------*
* Collapse suicides by year and treatment group
*------------------------------------------------------*
collapse (count) suicide, by(death_year treated)

*------------------------------------------------------*
* Plot yearly trend
*------------------------------------------------------*
twoway ///
(line suicide death_year if treated==1, lcolor(blue) lwidth(medthick)) ///
(line suicide death_year if treated==0, lcolor(red) lwidth(medthick) lpattern(dash)), ///
legend(order(1 "Married (Treatment)" 2 "Single (Control)") ///
       position(0) ring(0) col(1) region(lstyle(none))) ///
xline(2020, lpattern(dash) lcolor(black) lwidth(thin)) ///
title("Yearly Suicides: Married vs Single Women (2017–2023)", size(medium)) ///
ytitle("Number of Suicides") xtitle("Year") ///
xlabel(2017(1)2023, labsize(small)) ///
yscale(range(0 250)) ///
graphregion(color(white)) ///
plotregion(margin(zero)) ///
scheme(s1mono)



*--------------------------------------------*
* Monthly Suicides: Married vs Divorced Women (1997–2023)
*--------------------------------------------*

use suicide_only_data, clear

*------------------------------------------------------*
* Convert death_date to Stata date
*------------------------------------------------------*
gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

* Generate monthly date variable
gen ym = ym(death_year, death_month)
format ym %tm

*------------------------------------------------------*
* Monthly Suicide Trends: Married vs Divorced Women
* Collapsed across all years (1997–2023)
*------------------------------------------------------*

use suicide_only_data, clear

* Keep only Married (2) and Divorced (3) women
keep if marital_status == 2 | marital_status == 3

* Label marital status
label define marital 2 "Married Women" 3 "Divorced Women"
label values marital_status marital

* Collapse to get total suicides per month for each marital group
collapse (sum) suicide, by(death_month marital_status)

*--------------------------------------------*
* Plot Monthly Trend (1–12)
*--------------------------------------------*
twoway ///
    (line suicide death_month if marital_status == 2, ///
        lcolor(blue) lwidth(medthick) msymbol(circle) msize(small)) ///
    (line suicide death_month if marital_status == 3, ///
        lcolor(red) lpattern(dash) lwidth(medthick) msymbol(square) msize(small)), ///
    legend(order(1 "Married Women" 2 "Divorced Women") position(6) ring(0) region(lcolor(white))) ///
    xlabel(1(1)12, labsize(small)) ///
    xtitle("Month") ///
    ytitle("Number of Suicides") ///
    title("Average Monthly Suicide Trends: Married vs Divorced Women (1997–2023)") ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    plotregion(color(white))

	
	
	
*------------------------------------------------------*
* Monthly Suicide Trends: Married vs Divorced Women
* Collapsed across all years (1997–2023)
*------------------------------------------------------*

use suicide_only_data, clear

gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

* Generate monthly date variable
gen ym = ym(death_year, death_month)
format ym %tm

* Keep only Married (2) and Divorced (3) women
keep if marital_status == 2 | marital_status == 3

* Label marital status
label define marital 2 "Married Women" 3 "Divorced Women"
label values marital_status marital

* Collapse to get total suicides per month for each marital group
collapse (sum) suicide, by(death_month marital_status)

*--------------------------------------------*
* Plot Monthly Trend (1–12)
*--------------------------------------------*
twoway ///
    (line suicide death_month if marital_status == 2, ///
        lcolor(black) lwidth(medthick) msymbol(circle) msize(small)) ///
    (line suicide death_month if marital_status == 3, ///
        lcolor(red) lpattern(dash) lwidth(medthick) msymbol(square) msize(small)), ///
    legend(order(1 "Married Women" 2 "Divorced Women") ///
           position(25) ring(1) region(lcolor(white)) col(1)) ///
    xlabel(1(1)12, labsize(small)) ///
    xtitle("Months") ///
    ytitle("Number of Suicides") /////
    title("Average Monthly Suicide Trends: Married vs Divorced") ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    legend(rows(2) region(lwidth(none)))


* ================================================
* Single VS Married 
* ================================================
	
use suicide_only_data, clear

gen str8 death_str = string(death_date,"%08.0f")
gen death_year  = real(substr(death_str,1,4))
gen death_month = real(substr(death_str,5,2))
gen death_day   = real(substr(death_str,7,2))
gen death_dt = mdy(death_month, death_day, death_year)
format death_dt %td

* Generate monthly date variable
gen ym = ym(death_year, death_month)
format ym %tm

* Keep only Married (2) and Divorced (3) women
keep if marital_status == 1 | marital_status == 2

* Label marital status
label define marital 1 "Single Women" 2 "Married Women"
label values marital_status marital

* Collapse to get total suicides per month for each marital group
collapse (sum) suicide, by(death_month marital_status)

*--------------------------------------------*
* Plot Monthly Trend (1–12)
*--------------------------------------------*
twoway ///
    (line suicide death_month if marital_status == 1, ///
        lcolor(black) lwidth(medthick) msymbol(circle) msize(small)) ///
    (line suicide death_month if marital_status == 2, ///
        lcolor(red) lpattern(dash) lwidth(medthick) msymbol(square) msize(small)), ///
    legend(order(1 "Single Women" 2 "<Married Women") ///
           position(25) ring(1) region(lcolor(white)) col(1)) ///
    xlabel(1(1)12, labsize(small)) ///
    xtitle("Months") ///
    ytitle("Number of Suicides") /////
    title("Average Monthly Suicide Trends: Single vs Married") ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    legend(rows(2) region(lwidth(none)))

	
*======================================================
*Unemployed after policy (jan-2021)
*======================================================

*------------------------------------------------------*
* STEP 1. Load and prepare data
*------------------------------------------------------*
use suicide_only_data, clear

* Keep unemployed adults only
keep if occupation_code == 13 & age > 22

* Convert date
gen str8 death_str = string(death_date, "%08.0f")
gen death_year  = real(substr(death_str, 1, 4))
gen death_month = real(substr(death_str, 5, 2))
gen death_day   = real(substr(death_str, 7, 2))
gen death_dt = mdy(death_month, death_day, death_year)

* Keep only from Jan 2019 to Dec 2022 (2 years before and 2 after)
keep if death_dt >= mdy(1,1,2019) & death_dt <= mdy(12,31,2022)

* Create year-month variable
gen ym = ym(death_year, death_month)
format ym %tm

*------------------------------------------------------*
* STEP 2. Collapse to monthly suicides
*------------------------------------------------------*
collapse (sum) suicide, by(ym)

*------------------------------------------------------*
* STEP 3. Plot the trend (2019–2022)
*------------------------------------------------------*
twoway line suicide ym, ///
    lcolor(navy) lwidth(medthick) ///
    msymbol(circle) msize(small) ///
    ytitle("Number of Suicides (Unemployed, Age > 22)") ///
    xtitle("Year-Month") ///
    xlabel(2019m1(3)2022m12, angle(45) labsize(small)) ///
    title("Monthly Suicide Trend: Unemployed Adults (2019–2022)") ///
    xline(2021m1, lpattern(dash) lcolor(red) lwidth(thin)) ///
    text(200 2021m1 "Policy Enacted: Jan 2021", place(w) size(small)) ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    plotregion(color(white))

*=====================================	
* 19/11/2025
* ====================================

use suicide_only_data, clear

tostring death_date, gen(dstr) format(%08.0f)
gen deathdate = date(dstr, "YMD")
format deathdate %td

gen death_month = month(deathdate)
gen death_year  = year(deathdate)

* Treatment = Age 19, Control = Age 18
gen treat = (age==19)
keep if age==18 | age==19

* Keep only October and November
*keep if death_month == 10 | death_month == 11

* Period: 0 = October (pre), 1 = November (CSAT)
*gen period = 0 if death_month == 10
*replace period = 1 if death_month == 11

* Collapse to monthly counts
collapse (count) suicide, by(death_month treat)

* Label groups
label define treatlbl 0 "Age 18 (Control)" 1 "Age 19 (Treatment)"
label values treat treatlbl

twoway ///
(line suicide death_month if treat==0, lp(solid) lwidth(med)) ///
(line suicide death_month if treat==1, lp(dash)  lwidth(med)), ///
xtitle("Month (All Years)") ///
ytitle("Suicide Count") ///
title("Pre (Oct) vs CSAT (Nov) Suicide Trends: Age 18 vs Age 19") ///
legend(order(1 "Age 18 Control" 2 "Age 19 Treatment") ) ///
xlabel(1(1)12)







* ========================================================================

use suicide_only_data, clear

tostring death_date, gen(dstr) format(%08.0f)
gen deathdate = date(dstr, "YMD")
format deathdate %td

gen week = week(deathdate)
gen biweek = ceil(week/2)


* Treatment = Age 19, Control = Age 18
gen treat = (age==19)
keep if age==18 | age==19

* Keep only October and November
*keep if death_month == 10 | death_month == 11

* Period: 0 = October (pre), 1 = November (CSAT)
*gen period = 0 if death_month == 10
*replace period = 1 if death_month == 11

* Collapse to monthly counts
collapse (count) suicide, by(biweek treat)

* Label groups
label define treatlbl 0 "Age 18 (Control)" 1 "Age 19 (Treatment)"
label values treat treatlbl

twoway ///
(line suicide biweek if treat==0, lpattern(solid) lwidth(medium)) ///
(line suicide biweek if treat==1, lpattern(dash) lwidth(medium)), ///
xtitle("Week (All Years)") ///
ytitle("Suicide Count") ///
title("Pre (Oct) vs CSAT (Nov) Suicide Trends: Age 18 vs Age 19") ///
legend(order(1 "Age 18 Control" 2 "Age 19 Treatment")) ///
xlabel(1(1)26) scheme(s1color) ///
xline(24)




* ========================================================================

use suicide_only_data, clear

tostring death_date, gen(dstr) format(%08.0f)
gen deathdate = date(dstr, "YMD")
format deathdate %td

gen week = week(deathdate)


* Treatment = Age 19, Control = Age 18
gen treat = (age==19)
keep if age==18 | age==19

* Keep only October and November
*keep if death_month == 10 | death_month == 11

* Period: 0 = October (pre), 1 = November (CSAT)
*gen period = 0 if death_month == 10
*replace period = 1 if death_month == 11

* Collapse to monthly counts
collapse (count) suicide, by(week treat)

* Label groups
label define treatlbl 0 "Age 18 (Control)" 1 "Age 19 (Treatment)"
label values treat treatlbl

twoway ///
(line suicide week if treat==0, lpattern(solid) lwidth(medium)) ///
(line suicide week if treat==1, lpattern(dash) lwidth(medium)), ///
xtitle("Week (All Years)") ///
ytitle("Suicide Count") ///
title("CSAT (Nov) Suicide Trends: Age 18 vs Age 19") ///
legend(order(1 "Age 18 Control" 2 "Age 19 Treatment")) ///
xlabel(1(2)52) scheme(s1color) ///
xline(46)

*========================================================================
use suicide_only_data, clear

tostring death_date, gen(dstr) format(%08.0f)
gen deathdate = date(dstr, "YMD")
format deathdate %td

gen week = week(deathdate)
gen biweek = ceil(week/2)


* Treatment = Age 19, Control = Age 18

keep if age==20 | age==19 | age == 18
gen treat = 1 if age == 18
replace treat = 2 if age == 19
replace treat = 3 if age == 20
* Keep only October and November
*keep if death_month == 10 | death_month == 11

* Period: 0 = October (pre), 1 = November (CSAT)
*gen period = 0 if death_month == 10
*replace period = 1 if death_month == 11

* Collapse to monthly counts
collapse (count) suicide, by(biweek treat)

* Label groups
label define treatlbl 0 "Age 20 (Control)" 1 "Age 19 (Treatment)"
label values treat treatlbl

twoway ///
(line suicide biweek if treat==1, lpattern(solid) lwidth(medium)) ///
(line suicide biweek if treat==2, lpattern(dash) lwidth(medium)) ///
(line suicide biweek if treat==3, lpattern(dash) lwidth(medium)), ///
xtitle("Week (All Years)") ///
ytitle("Suicide Count") ///
title("Pre (Oct) vs CSAT (Nov) Suicide Trends: Age 20 vs Age 19") ///
legend(order(1 "18" 2 "19" 3 "20")) ///
xlabel(1(1)26) scheme(s1color) ///
xline(24)


*========================================================================
use suicide_only_data, clear

tostring death_date, gen(dstr) format(%08.0f)
gen deathdate = date(dstr, "YMD")
format deathdate %td

gen week = week(deathdate)
gen biweek = ceil(week/2)


* Treatment = Age 19, Control = Age 18

keep if age==20 | age==19 | age == 18
gen treat = 1 if age == 18
replace treat = 2 if age == 19
replace treat = 3 if age == 20
* Keep only October and November
*keep if death_month == 10 | death_month == 11

* Period: 0 = October (pre), 1 = November (CSAT)
*gen period = 0 if death_month == 10
*replace period = 1 if death_month == 11

* Collapse to monthly counts
collapse (count) suicide, by(biweek treat)

* Label groups
label define treatlbl 0 "Age 20 (Control)" 1 "Age 19 (Treatment)"
label values treat treatlbl
keep if biweek > 19
twoway ///
(line suicide biweek if treat==1, lpattern(solid) lwidth(medium)) ///
(line suicide biweek if treat==2, lpattern(dash) lwidth(medium)) ///
(line suicide biweek if treat==3, lpattern(dash) lwidth(medium)), ///
xtitle("Week (All Years)") ///
ytitle("Suicide Count") ///
title("Pre (Oct) vs CSAT (Nov) Suicide Trends: Age 20 vs Age 19") ///
legend(order(1 "18" 2 "19" 3 "20")) ///
xlabel(20(1)26) scheme(s1color) ///
xline(24)



use suicide_only_data, clear
drop report_*

* --- Total suicides for each occupation ---
collapse (sum) suicide, by(occupation_code)

* --- Calculate total suicides ---
egen total_suicide = total(suicide)

* --- Calculate percentage ---
gen pct = (suicide / total_suicide) * 100

sort pct
list occupation_code suicide pct, noobs


use suicide_only_data, clear
drop report_*

* --- Create new occupation variable with split for code 13 ---
gen occ_split = occupation_code
replace occ_split = 131 if occupation_code == 13 & age < 19
replace occ_split = 132 if occupation_code == 13 & age >= 19

* --- Collapse suicides by new occupation variable ---
collapse (sum) suicide, by(occ_split)

* --- Sort descending by total suicides ---
gsort -suicide

* --- Display the table ---
list occ_split suicide, noobs

* --- Optional: export ---
export excel using "suicide_by_occupation_split.xlsx", firstrow(variables) replace

*==============================
* 23/11/2025
*==============================


* ===========================================================	
* Age 18/17	
* ===========================================================
use suicide_only_data.dta, clear

tostring death_date, gen(death_date_str)
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td

keep if inlist(age, 17, 18) & occupation_code == 13

save suicide_only_data_filtered.dta, replace

capture confirm file csat_dates_actual.dta
if _rc {
    clear
    input test_year str11 csat_str
    1996 "13nov1996"
    1997 "19nov1997"
    1998 "18nov1998"
    1999 "17nov1999"
    2000 "15nov2000"
    2001 "07nov2001"
    2002 "06nov2002"
    2003 "05nov2003"
    2004 "17nov2004"
    2005 "23nov2005"
    2006 "16nov2006"
    2007 "15nov2007"
    2008 "13nov2008"
    2009 "12nov2009"
    2010 "18nov2010"
    2011 "10nov2011"
    2012 "08nov2012"
    2013 "07nov2013"
    2014 "13nov2014"
    2015 "12nov2015"
    2016 "17nov2016"
    2017 "23nov2017"
    2018 "15nov2018"
    2019 "14nov2019"
    2020 "03dec2020"
    2021 "18nov2021"
    2022 "17nov2022"
	2023 "16nov2023"
    end

    gen csat_actual_date = date(csat_str,"DMY")
    format csat_actual_date %td
    save csat_dates_actual.dta, replace
}

gen test_year = year(death_date_st)
merge m:1 test_year using csat_dates_actual.dta, keep(match) nogen

gen day_rel = death_date_st - csat_actual_date

keep if inrange(day_rel, -30, 30)

collapse (sum) suicide, by(day_rel age)
sort age day_rel

twoway line suicide day_rel if age==17 || ///
       line suicide day_rel if age==18, ///
    legend(order(1 "Age 17 (control)" 2 "Age 18 (treatment)")) ///
    xline(0, lcolor(black)) ///
    xlabel(-30(5)30) ///
    ytitle("Suicides") ///
    xtitle("Days relative to CSAT")

* ========================================================
* Age 18/19
* ========================================================

use suicide_only_data.dta, clear

tostring death_date, gen(death_date_str)
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td

keep if inlist(age, 18, 19) & occupation_code == 13

capture confirm file csat_dates_actual.dta
if _rc {
    clear
    input test_year str11 csat_str
    1996 "13nov1996"
    1997 "19nov1997"
    1998 "18nov1998"
    1999 "17nov1999"
    2000 "15nov2000"
    2001 "07nov2001"
    2002 "06nov2002"
    2003 "05nov2003"
    2004 "17nov2004"
    2005 "23nov2005"
    2006 "16nov2006"
    2007 "15nov2007"
    2008 "13nov2008"
    2009 "12nov2009"
    2010 "18nov2010"
    2011 "10nov2011"
    2012 "08nov2012"
    2013 "07nov2013"
    2014 "13nov2014"
    2015 "12nov2015"
    2016 "17nov2016"
    2017 "23nov2017"
    2018 "15nov2018"
    2019 "14nov2019"
    2020 "03dec2020"
    2021 "18nov2021"
    2022 "17nov2022"
	2023 "16nov2023"
    end

    gen csat_actual_date = date(csat_str,"DMY")
    format csat_actual_date %td
    save csat_dates_actual.dta, replace
}

gen test_year = year(death_date_st)
merge m:1 test_year using csat_dates_actual.dta, keep(match) nogen

gen day_rel = death_date_st - csat_actual_date
keep if inrange(day_rel, -30, 30)

collapse (sum) suicide, by(day_rel age)
sort age day_rel

twoway line suicide day_rel if age==18 || ///
       line suicide day_rel if age==19, ///
    legend(order(1 "Age 18 (treatment)" 2 "Age 19 (control)")) ///
    xline(0, lcolor(black)) ///
    xlabel(-30(5)30) ///
    ytitle("Suicides") ///
    xtitle("Days relative to CSAT")

graph save Graph_Age18/19.gph, replace




use suicide_only_data.dta, clear

tostring death_date, gen(death_date_str)
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td


keep if inlist(age, 19, 18) & occupation_code == 13

save suicide_only_data_filtered.dta, replace

capture confirm file csat_dates_actual.dta
if _rc {
    clear
    input test_year str11 csat_str
    1996 "13nov1996"
    1997 "19nov1997"
    1998 "18nov1998"
    1999 "17nov1999"
    2000 "15nov2000"
    2001 "07nov2001"
    2002 "06nov2002"
    2003 "05nov2003"
    2004 "17nov2004"
    2005 "23nov2005"
    2006 "16nov2006"
    2007 "15nov2007"
    2008 "13nov2008"
    2009 "12nov2009"
    2010 "18nov2010"
    2011 "10nov2011"
    2012 "08nov2012"
    2013 "07nov2013"
    2014 "13nov2014"
    2015 "12nov2015"
    2016 "17nov2016"
    2017 "23nov2017"
    2018 "15nov2018"
    2019 "14nov2019"
    2020 "03dec2020"
    2021 "18nov2021"
    2022 "17nov2022"
	2023 "16nov2023"
    end

    gen csat_actual_date = date(csat_str,"DMY")
    format csat_actual_date %td
    save csat_dates_actual.dta, replace
}

gen test_year = year(death_date_st)
merge m:1 test_year using csat_dates_actual.dta, keep(match) nogen

gen day_rel = death_date_st - csat_actual_date

keep if inrange(day_rel, -30, 30)

collapse (sum) suicide, by(day_rel age)
sort age day_rel

twoway line suicide day_rel if age==19 || ///
       line suicide day_rel if age==18, ///
    legend(order(1 "Age 30 (control)" 2 "Age 18 (treatment)")) ///
    xline(0, lcolor(black)) ///
    xlabel(-30(5)30) ///
    ytitle("Suicides") ///
    xtitle("Days relative to CSAT")

	
* ======================================================
* 8/12/2025
* ======================================================
use suicide_only_data, clear 

keep if occupation_code == 13
keep if age < 30

* define three groups:
gen age_group = .
replace age_group = 1 if age < 10
replace age_group = 2 if inrange(age,10,19)
replace age_group = 3 if inrange(age,20,29)

label define ageg 1 "age<10 (ctrl1)" 2 "10–19 (treat)" 3 "20–29 (ctrl2)"
label values age_group ageg
drop if missing(age_group)

* step 1: make it string
tostring death_date, gen(death_date_str) format(%08.0f)

* step 2: convert string YYYYMMDD to Stata daily date
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td

replace year = year(death_date_st)

* date for March 2 of that year
gen march2 = mdy(3,2,year)

* relative day: negative = before, 0 = March 2, positive = after
gen day_rel = death_date_st - march2

keep if inrange(day_rel,-6,6)

* one observation = one death, so sum suicides by year, relative day, and group
gen suicides = 1

collapse (sum) suicides, by(year day_rel age_group)

collapse (mean) suicides, by(day_rel age_group)

twoway ///
    line suicides day_rel if age_group==2, lcolor(red) || ///
    line suicides day_rel if age_group==1, lcolor(blue) || ///
    line suicides day_rel if age_group==3, lcolor(green) ///
    , legend(order(1 "10–19 (treat)" 2 "<10 (ctrl1)" 3 "20–29 (ctrl2)")) ///
      xline(0, lcolor(black)) ///
      xlabel(-6(1)6) ///
      ytitle("Mean suicides") ///
      xtitle("Days relative to March 2") ///
      title("Student suicides ±6 days around March 2")

* ==================================================================
	 
use suicide_only_data, clear  

keep if occupation_code == 13
keep if age < 40

* define three groups:
gen age_group = .
replace age_group = 1 if inrange(age,30,39)
replace age_group = 2 if inrange(age,10,19)
replace age_group = 3 if inrange(age,20,29)

label define ageg 1 "age30-39 (control1)" 2 "10–19 (treatment)" 3 "20–29 (control2)"
label values age_group ageg
drop if missing(age_group)

* step 1: make it string
tostring death_date, gen(death_date_str) format(%08.0f)

* step 2: convert string YYYYMMDD to Stata daily date
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td

replace year = year(death_date_st)

* date for March 2 of that year
gen march2 = mdy(3,2,year)

* relative day: negative = before, 0 = March 2, positive = after
gen day_rel = death_date_st - march2

keep if inrange(day_rel,-6,6)

* one observation = one death, so sum suicides by year, relative day, and group
gen suicides = 1

collapse (sum) suicides, by(year day_rel age_group)

collapse (mean) suicides, by(day_rel age_group)

twoway ///
    line suicides day_rel if age_group==2, lcolor(red) || ///
    line suicides day_rel if age_group==1, lcolor(blue) || ///
    line suicides day_rel if age_group==3, lcolor(green) ///
    , legend(order(1 "10–19 (treatment)" 2 "30-39 (control1)" 3 "20–29 (control2)")) ///
      xline(0, lcolor(black)) ///
      xlabel(-6(1)6) ///
      ytitle("Mean suicides") ///
      xtitle("Days relative to March 2") ///
      title("Student suicides ±6 days around March 2")
	  
	  
	  
	  
	  
	  
use suicide_only_data, clear  

keep if occupation_code == 13
keep if age < 40

* define three groups:
gen age_group = .
replace age_group = 1 if inrange(age,6,12)
replace age_group = 2 if inrange(age,12,18)
replace age_group = 3 if inrange(age,22,28)

label define ageg 1 "age6-12 (control1)" 2 "12-18(treatment)" 3 "22–28 (control2)"
label values age_group ageg
drop if missing(age_group)

* step 1: make it string
tostring death_date, gen(death_date_str) format(%08.0f)

* step 2: convert string YYYYMMDD to Stata daily date
gen death_date_st = date(death_date_str, "YMD")
format death_date_st %td

replace year = year(death_date_st)

* date for March 2 of that year
gen march2 = mdy(3,2,year)

* relative day: negative = before, 0 = March 2, positive = after
gen day_rel = death_date_st - march2

keep if inrange(day_rel,-6,6)

* one observation = one death, so sum suicides by year, relative day, and group
gen suicides = 1

collapse (sum) suicides, by(year day_rel age_group)

collapse (mean) suicides, by(day_rel age_group)

twoway ///
    line suicides day_rel if age_group==2, lcolor(red) || ///
    line suicides day_rel if age_group==1, lcolor(blue) || ///
    line suicides day_rel if age_group==3, lcolor(green) ///
    , legend(order(1 "12-18 (treatment)" 2 "6-12 (control1)" 3 "22-28 (control2)")) ///
      xline(0, lcolor(black)) ///
      xlabel(-6(1)6) ///
      ytitle("Mean suicides") ///
      xtitle("Days relative to March 2") ///
  title("Student suicides ±6 days around March 2")
  
  
* ================================
  
use suicide_only_data, clear 

keep if occupation_code == 13
keep if age < 19
drop if place_of_death == 99

tabulate place_of_death, sort
table place_of_death, statistic(percent)

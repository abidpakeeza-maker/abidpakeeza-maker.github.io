//Pakeeza Abid
// ERC Really Credible Exam 

//====================================================================

//Exercise 1, (h)

clear
set seed 12345

matrix results = J(1000,2,.)

forvalues s = 1/1000 {
    clear
    set obs 100
    gen y = uniform()
    summarize y
    scalar thetaMM = 2*r(mean)
    scalar thetaML = r(max)
    matrix results[`s',1] = thetaMM
    matrix results[`s',2] = thetaML
}

clear
svmat results
rename results1 thetaMM
rename results2 thetaML
summarize thetaMM thetaML

//===================================================================

//Exercise 3

//Exercise 3, //Question-1

ssc install did_multiplegt_dyn, replace
ssc install gtools, replace

use "exercise3_data.dta", clear

did_multiplegt_dyn exp_dens_share distnum year president, ///
    effects(5) ///
    placebo(5) ///
    cluster(distnum)
	
//Exercise 3, //Question-2

* Creating time-interacted controls

gen pop1962_t     = pop1962     * year
gen area_t        = area        * year
gen urbrate1962_t = urbrate1962 * year
gen earnings_t        = earnings        * year
gen wage_employment_t = wage_employment * year
gen value_cashcrops_t = value_cashcrops * year

* Column 2: Demographic controls only
did_multiplegt_dyn exp_dens_share distnum year president, ///
    effects(5) placebo(5) cluster(distnum) ///
    controls(pop1962_t area_t urbrate1962_t)

* Column 3: Demographic + Economic controls
did_multiplegt_dyn exp_dens_share distnum year president, ///
    effects(5) placebo(5) cluster(distnum) ///
    controls(pop1962_t area_t urbrate1962_t ///
             earnings_t wage_employment_t value_cashcrops_t)
			 
//Exercise 3, //Question-3

did_multiplegt_dyn exp_dens_share distnum year president, ///
    effects(5) ///
    placebo(5) ///
    cluster(distnum) ///
    switchers(out)
	
//======================================================================

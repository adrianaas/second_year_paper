* Set path
local datafile "$dir\data\nhis_00003_clean_mortweight100split.dta"

clear all

local settings ///
    "1 1 0" /// all FEMALE
    "2 0 0" /// all MALE
	"3 1 1" /// 2000 FEMALE
    "4 0 1" /// 2000 MALE
    "5 1 2" /// 2010 FEMALE
    "6 0 2" /// 2010 MALE
	
	
* Define your settings as a list of strings
local settings `" "1 1 0" "2 0 0" "3 1 1" "4 0 1" "5 1 2" "6 0 2" "'

* Loop through each set of values
foreach setting of local settings {
    tokenize `setting'
    local wa = `1'
    local female_val = `2'
    local period = `3'

    display "Running analysis `wa' (female=`female_val', period=`period')"

    * Load data
    use "`datafile'", clear

    * Tag analysis number
    gen which_analysis = `wa'

    * Create dummy65
	gen dummy65 = exact_age_quarter >= 65
    gen dummy55 = exact_age_quarter >= 55
	gen dummy75 = exact_age_quarter >= 75

    * Drop by sex
    drop if female != `female_val'

    * Drop by region
    if `period' == 1 {
        drop if decade2010 == 1
    }
    else if `period' == 2 {
        drop if decade2010 == 0
    }

    * Apply weights
    replace _d = _d * mortweight
    replace py = py * mortweight
	

**********************RAW ONLY?*******
******to use the raw data, run this and comment out the rest of the loop
	* We only include those aged 30-84 in the modeling (can be changed)
	
/*
drop if exact_age_quarter<30
drop if exact_age_quarter>=85
collapse (sum) _d py, by(age_fiveyr which_analysis)
gen nMx=_d/py
do 22_NVSS_compare_lifetables nMx which_analysis

*/
***************************THIS IS THE SETUP FOR THE ANALYSIS*******
**********************INCLUDE DUMMIES IN COLLAPSE IF USING MODELING APPROACH*******
    collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr which_analysis)
	

    * Offset for nbreg
    gen log_py = log(py)

	* We only include those aged 30-84 in the modeling (can be changed)
	drop if exact_age_quarter<30
	drop if exact_age_quarter>=85


***************************THIS IS THE COMMAND FOR THE ANALYSIS*******
**************************************THERE ARE OPTIONS**************

    eststo clear
	
******for a fully interacted model with two dummies at ages 55 and 7 (spline), run this
	*eststo: nbreg _d exact_age_quarter dummy55#c.exact_age_quarter dummy75#c.exact_age_quarter tenter, offset(log_py) irr

******for a fully interacted model with one dummy at age 65 (spline), run this
    *eststo: nbreg _d c.exact_age_quarter##c.tenter c.exact_age_quarter#i.dummy65#c.tenter, offset(log_py) irr
	
******for a fully interacted model with stata-made cubic splines with three knots, run this
	mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
	*eststo: nbreg _d smooth_age1 smooth_age2 tenter c.smooth_age1#c.tenter c.smooth_age2#c.tenter, offset(log_py) irr
	*not fully interacted:
	eststo: nbreg _d smooth_age1 smooth_age2 tenter, offset(log_py) irr
	estat ic


*****************
    * Predict deaths
    predict predicted_deaths, n

    * Aggregate and calc nMx
    collapse (sum) predicted_deaths py, by(age_fiveyr which_analysis)
    gen nMx = predicted_deaths / py

    * Run lifetable
    do 202_NVSS_compare_lifetables nMx which_analysis
	*/
}

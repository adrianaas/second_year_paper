* Set path
local datafile "$dir\data\nhis_00003_clean_mortweight100split.dta"

clear all

local settings ///
    "1 1 0 0" /// FEMALE all 2000-09
    "2 0 0 0" /// MALE all 2000-09
	"3 1 1 0" /// FEMALE native 2000-09
    "4 0 1 0" /// MALE native2000-09
    "5 1 2 0" /// FEMALE foreign 2000-09
    "6 0 2 0" /// MALE foreign 2000-09
	"7 1 2 0" /// FEMALE americas 2000-09
    "8 0 2 0" /// MALE americas 2000-09
	"9 1 2 0" /// FEMALE europe 2000-09
    "10 0 2 0" /// MALE europe 2000-09
	"11 1 2 0" /// FEMALE asia 2000-09
    "12 0 2 0" /// MALE asia 2000-09
	"13 1 0 1" /// FEMALE all 2010-18
    "14 0 0 1" /// MALE all 2010-18
	"15 1 1 1" /// FEMALE native 2010-18
    "16 0 1 1" /// MALE native 2010-18
    "17 1 2 1" /// FEMALE foreign 2010-18
    "18 0 2 1" /// MALE foreign 2010-18
	"19 1 2 1" /// FEMALE americas 2010-18
    "20 0 2 1" /// MALE americas 2010-18
	"21 1 2 1" /// FEMALE europe 2010-18
    "22 0 2 1" /// MALE europe 2010-18
	"23 1 2 1" /// FEMALE asia 2010-18
    "24 0 2 1" /// MALE asia 2010-18
	
	local settings `" "1 1 0 0" "2 0 0 0" "3 1 1 0" "4 0 1 0" "5 1 2 0" "6 0 2 0" "7 1 2 0" "8 0 2 0" "9 1 2 0" "10 0 2 0" "11 1 2 0" "12 0 2 0" "13 1 0 1" "14 0 0 1" "15 1 1 1" "16 0 1 1" "17 1 2 1" "18 0 2 1" "19 1 2 1" "20 0 2 1" "21 1 2 1" "22 0 2 1" "23 1 2 1" "24 0 2 1" "'


* Loop through each set of values
foreach setting of local settings {
    tokenize `setting'
    local wa = `1'
    local female_val = `2'
    local nativity_flag = `3'
	local decade2010_val = `4'

    display "Running analysis `wa' (female=`female_val', nativity_flag=`nativity_flag', decade2010=`decade2010_val')"

    * Load data
    use "`datafile'", clear

    * Tag analysis number
    gen which_analysis = `wa'

    * Drop by sex
    drop if female != `female_val'
	
	    * Drop by period
    drop if decade2010 != `decade2010_val'
	
	    * Apply weights
    replace _d = _d * mortweight
    replace py = py * mortweight


	* We only include those aged 30-90 in the modeling (can be changed) - turns out we need to do that open age interval to subtract (maybe this is wrong...)
	drop if exact_age_quarter<30
	drop if exact_age_quarter>=85

	if `nativity_flag' == 0 {
		
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  smooth_age1 smooth_age2 tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths, n
	}
	
	
	else if `nativity_flag' == 1 {
        drop if regionbr != 1
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  smooth_age1 smooth_age2 tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths, n
    }
	
	
	else if `nativity_flag' == 2 {
		
	drop if regionbr == 1
	
	gen world_region=.
	replace world_region=1 if regionbr==2 | world_region==3
	replace world_region=2 if regionbr==4
	replace world_region=3 if regionbr==8 | regionbr==9 | regionbr==10
	label define world_region 1 "Americas" 2 "Europe" 3 "Asia"
	label values world_region world_region
		
	if 	`wa'==5 | `wa'==6 | `wa'==17 | `wa'==18 {
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  smooth_age1 smooth_age2 tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths, n
		}
	
	if 	`wa' ==7 | `wa'==8 | `wa'==19 | `wa' ==20 {
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr world_region which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  c.smooth_age1##i.world_region c.smooth_age2##i.world_region tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths if world_region==1, n
			drop if world_region!=1
		}
		
	if 	`wa' ==9 | `wa'==10 | `wa'==21 | `wa' ==22 {
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr world_region which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  c.smooth_age1##i.world_region c.smooth_age2##i.world_region tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths if world_region==2, n
			drop if world_region!=2
		}
		
	if 	`wa' ==11 | `wa'==12 | `wa'==23 | `wa' ==24 {
		collapse (sum) _d py, by(exact_age_quarter tenter age_fiveyr world_region which_analysis)
			gen log_py = log(py)
			eststo clear
			mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
			eststo: nbreg _d  c.smooth_age1##i.world_region c.smooth_age2##i.world_region tenter, offset(log_py) irr
			estat ic
			predict predicted_deaths if world_region==3, n
			drop if world_region!=3
		}
		
    }
	
    * Aggregate and calc nMx
    collapse (sum) predicted_deaths py, by(age_fiveyr which_analysis)
    gen nMx = predicted_deaths / py

    * Run lifetable
    do  302_NHIS_world_regions_lifetables nMx which_analysis
	
***
}


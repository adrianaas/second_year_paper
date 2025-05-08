global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'
global texdir `"C:\Users\adria\Documents\penn\yr2\NHIS\tex"'

local datafile "$dir\data\nhis_00003_clean_mortweight25split.dta"

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

* Temp file for results
tempname results
local resultsfile "$dir\intermediate\resultsfile.dta"

* Define structure for post
postfile `results' int which_analysis str30 model_type double(bic aic df) using `resultsfile', replace

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
	label define which_analysis_lbl ///
    1 "All Female" ///
    2 "All Male" ///
    3 "2000-2009 Female" ///
    4 "2000-2009 Male" ///
    5 "2010-2018 Female" ///
    6 "2010-2018 Male"
	
	label values which_analysis which_analysis_lbl
	label variable which_analysis "Model"

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
	

    collapse (sum) _d py, by(exact_age_quarter tenter female age_fiveyr which_analysis dummy55 dummy65 dummy75)
    gen log_py = log(py)

    drop if exact_age_quarter<30
    drop if exact_age_quarter>=85

	* MODEL 1: dummy65 spline
    quietly nbreg _d exact_age_quarter dummy65#c.exact_age_quarter tenter, offset(log_py)
    estat ic
    matrix stats1 = r(S)
    post `results' (`wa') ("Linear_Spline_Age_65") (stats1[1,6]) (stats1[1,5]) (stats1[1,4])
	
    * MODEL 2: dummy55 and dummy75 spline
    quietly nbreg _d exact_age_quarter dummy55#c.exact_age_quarter dummy75#c.exact_age_quarter tenter, offset(log_py)
    estat ic
    matrix stats2 = r(S)
    post `results' (`wa') ("Linear_Spline_Ages_55_75") (stats2[1,6]) (stats2[1,5]) (stats2[1,4])

    *****************************************************
	* Re-load data for stata spline models
	*****************************************************

    use "`datafile'", clear

    * Tag analysis number
    gen which_analysis = `wa'

    drop if female != `female_val'

   * Drop by region
    if `period' == 1 {
        drop if decade2010 == 1
    }
    else if `period' == 2 {
        drop if decade2010 == 0
    }

    replace _d = _d * mortweight
    replace py = py * mortweight

    collapse (sum) _d py, by(exact_age_quarter tenter female age_fiveyr which_analysis)
    gen log_py = log(py)

    drop if exact_age_quarter<30
    drop if exact_age_quarter>=85

    * MODEL 3: spline no interactions
    mkspline smooth_age = exact_age_quarter, cubic nk(3)
    quietly nbreg _d smooth_age1 smooth_age2 tenter, offset(log_py)
    estat ic
    matrix stats3 = r(S)
    post `results' (`wa') ("Cubic_Spline_No_Interaction Interaction") (stats3[1,5]) (stats3[1,6]) (stats3[1,4])
	
	* MODEL 4: spline fully interacted
    quietly nbreg _d smooth_age1 smooth_age2 tenter c.smooth_age1#c.tenter c.smooth_age2#c.tenter, offset(log_py)
    estat ic
    matrix stats4 = r(S)
    post `results' (`wa') ("Cubic_Spline_Time_Interaction") (stats4[1,5]) (stats4[1,6]) (stats4[1,4])

}
* Close postfile
postclose `results'

* Load and display
use `resultsfile', clear
list, sepby(which_analysis)

* Load your results dataset
use "$dir\intermediate\resultsfile.dta", clear
gen obs=_n

* Now create a matrix of the numeric variables
mkmat bic aic df, matrix(myresults)
matrix colnames myresults ="BIC" "AIC" "DF"
matrix rownames myresults = "2000-2018_Fem_Linear_Spl" "2000-2018_Fem_Linear_Spl_55-75" "2000-2018_Fem_Cubic_Spl_No_Time" "2000-2018_Fem_Cubic_Spl_Time" "2000-2018_Male_Linear_Spl" "2000-2018_Male_Linear_Spl_55-75" "2000-2018_Male_Cubic_Spl_No_Time" "2000-2018_Male_Cubic_Spl_Time" "2000-2009_Fem_Linear_Spl" "2000-2009_Fem_Linear_Spl_55-75" "2000-2009_Fem_Cubic_Spl_No_Time" "2000-2009_Fem_Cubic_Spl_Time" "2000-2009_Male_Linear_Spl" "2000-2009_Male_Linear_Spl_55-75" "2000-2009_Male_Cubic_Spl_No_Time" "2000-2009_Male_Cubic_Spl_Time" "2010-2018_Fem_Linear_Spl" "2010-2018_Fem_Linear_Spl_55-75" "2010-2018_Fem_Cubic_Spl_No_Time" "2010-2018_Fem_Cubic_Spl_Time" "2010-2018_Male_Linear_Spl" "2010-2018_Male_Linear_Spl_55-75" "2010-2018_Male_Cubic_Spl_No_Time" "2010-2018_Male_Cubic_Spl_Time"

* Export
outtable using "$texdir\bic", mat(myresults) replace caption("Model Selection Statistics for Age Spline") nobox
global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'

*regressions
use "$dir\data\nhis_00003_clean_mortweight25split.dta", clear
*drop if exact_age_quarter<30
drop if age<=30
*Aggregate data (collapse death counts and person-years by covariates)
replace _d=_d*mortweight
replace py=py*mortweight
*collapse (sum) _d py, by(exact_age_quarter tenter regionbr age_fiveyr decade female noncitizen yrsinusg schooling marital)

*Create the offset variable (log of person-years)
*gen log_py = log(py)
recode yrsinusg (0=1)(4=1)(1=4)(2=3)(3=2)
label define yrsinusg 4 "Under 5 Yrs in U.S." 3 "5-9 Yrs in U.S." 2 "10-14 Yrs in U.S." 1 "NIU or 15+ Yrs in U.S.", modify


eststo clear
mkspline smooth_age = exact_age_quarter, cubic nk(3) displayknots
****instead of weighting the regression i weighted the collapsed sums of py & _d
eststo: nbreg _d smooth_age1 smooth_age2 tenter i.regionbr i.decade2010 i.female, offset(log_py) irr
*nbreg _d c.smooth_age1##i.regionbr c.smooth_age2##i.regionbr tenter i.decade2010 i.female, offset(log_py) irr

eststo: nbreg _d smooth_age1 smooth_age2 tenter i.regionbr i.decade2010 i.female i.noncitizen i.yrsinusg, offset(log_py) irr

eststo: nbreg _d smooth_age1 smooth_age2 tenter i.regionbr i.decade2010 i.female i.noncitizen i.yrsinusg i.schooling i.marital, offset(log_py) irr

label define schooling 0 "<HS" 1 "HS/GED" 2 "Some College" 3 "Bachelor's" 4 "Graduate", modify
label define marital 2 "Sep/Div/Wid", modify
label define regionbr 2 "Mex/Carib/CentAm" 5 "Russia and FSU", modify
label variable tenter "Exposure in Quarter-Years"
label variable smooth_age1  "Age Spline 1"
label variable smooth_age2  "Age Spline 2"
label variable decade "Decade"
label variable female "Sex"


esttab using "$texdir\negbin.tex", eform wide se(%8.2f) compress bic nobaselevels replace mtitles("\textbf{M1}" "\textbf{M2}" "\textbf{M3}") collabels("\text{IRR}" "\text{SE}") eqlabels(, none) label varlabel(`var') title("Mortality Risk by Region of Birth: Negative Binomial Regressions with Offset by Period") refcat(2.regionbr "\textbf{Region of Birth: (Ref: Native-Born)}" 1.decade2010 "\textbf{Period (Ref: 2000-2009 Decade)}" 1.noncitizen "\textbf{Citizenship (Ref: U.S. Citizen)}" 1.female "\textbf{Gender (Ref: Male)}" 2.yrsinusg "\textbf{Years in U.S. (Ref: US-Born or 15+ Yrs)}" 1.schooling "\textbf{Schooling (Ref: Less than H.S.)}" 2.marital "\textbf{Marital Status (Ref: Married/Cohab)}", nolabel) stats(bic N, fmt(%11.0fc) labels("BIC" "\textbf{Observations (in Quarter-Years)}")) note("Observations refers to quarter-person-years of exposure. Analysis based on unweighted N of 801916 subjects.") booktabs style(tex) alignment(D{.}{.}{3.4} D{.}{.}{3.4})

/* THIS IS THE NMX WE NEED TO DO
collapse (sum) _d py, by(exact_age_single tenter regionbr age_fiveyr decade female)
collapse (sum) predicted_deaths py, by(regionbr age_fiveyr decade female)
gen predicted_rate=predicted_deaths/py
gen logpred=log(predicted_rate)
mkspline spline=logpred, cubic
graph twoway (line logpred tenter if regionbr==1 & tenter>=2010 & tenter<=2015 & female==0, by(age_fiveyr) title("Raw Mortality Rates by Age for US Males"))

gen predicted_rate=predicted_deaths/py
gen logpred=log(predicted_rate)
graph twoway (line logpred tenter if regionbr==1 & tenter>=2010 & tenter<=2015 & female==0, by(age_fiveyr) title("Raw Mortality Rates by Age for US Males"))



collapse (sum) predicted_deaths py, by(regionbr age_fiveyr decade female)
gen nMx = predicted_deaths / py
do lifetable_regionbr_v0 nMx
*/


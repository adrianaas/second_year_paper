global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'
global texdir `"C:\Users\adria\Documents\penn\yr2\NHIS\tex"'

***********************DOESNT DROP OBSERVATIONS OVER 40 QUARTER PY****
use "$dir\data\nhis_00003_clean.dta", clear		

stset tdeath, failure(dead) enter(tenter) origin(tbirth) id(nhispid)
gen py=_t-_t0
drop if py==0
replace _d=0 if py>10
replace py=10 if py>10
gen py_weights=py*mortweight
gen _d_weights=_d*mortweight
collapse (sum) _d py _d_weights py_weights, by(regionbr)
gen a=1
gen b=1
gen c=1
gen d=1

label variable a "Deaths"
label variable b "Deaths"
label variable c "Exposures"
label variable d "Exposures"
label define unweighted 1 "Unweighted"
label define weighted 1 "Weighted"
label values a unweighted
label values b weighted
label values c unweighted
label values d weighted

table (regionbr) (a) [pweight=_d], statistic(sumw) nformat(%9.0fc) name(tablepy) totals(a) replace
table (regionbr) (b) [pweight=_d_weights], statistic(sumw) nformat(%9.0fc) name(tablepy) totals(b) append
table (regionbr) (c) [pweight=py], statistic(sumw) nformat(%9.0fc) name(tablepy) totals(c) append
table (regionbr) (d) [pweight=py_weights], statistic(sumw) nformat(%17.0fc) name(tablepy) totals(d) append


collect layout (regionbr) (a b c d)
collect title "Weighted and Unweighted Death Counts and Person-Years of Exposure by Detailed Region of Birth (2000-2018)"
collect export "$texdir\tablepy.tex", tableonly replace


use "$dir\data\nhis_00003_clean.dta", clear
label define regionbr 9 "East Asia", modify
stset tdeath, failure(dead) enter(tenter) origin(tbirth) id(nhispid)
gen py=_t-_t0
drop if py==0
replace _d=0 if py>10
replace py=10 if py>10
gen py_weights=py*mortweight
gen _d_weights=_d*mortweight


gen world_region=.
	replace world_region=0 if regionbr==1
	replace world_region=1 if regionbr==2 | world_region==3
	replace world_region=2 if regionbr==4
	replace world_region=3 if regionbr==8 | regionbr==9 | regionbr==10
	label define world_region 0 "Native-Born" 1 "Americas" 2 "Europe" 3 "Asia"
	label values world_region world_region
	label variable world_region "Broad Region of Birth"
		
collapse (sum) _d py _d_weights py_weights, by(world_region)
gen a=1
gen b=1
gen c=1
gen d=1


label variable a "Deaths"
label variable b "Deaths"
label variable c "Exposures"
label variable d "Exposures"
label define unweighted 1 "Unweighted"
label define weighted 1 "Weighted"
label values a unweighted
label values b weighted
label values c unweighted
label values d weighted


table (world_region) (a) [pweight=_d], statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(a) replace
table (world_region) (b) [pweight=_d_weights], statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(b) append
table (world_region) (c) [pweight=py], statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(c) append
table (world_region) (d) [pweight=py_weights], statistic(sumw) nformat(%17.0fc)  name(tablepy) totals(d) append


collect layout (world_region) (a b c d)
collect title "Weighted and Unweighted Death Counts and Person-Years of Exposure by Broad World Region of Birth (2000-2018)"
collect export "$texdir\tablepy_broad.tex", tableonly replace

****
use "$dir\data\nhis_00003_clean.dta", clear
label define regionbr 9 "East Asia", modify
stset tdeath, failure(dead) enter(tenter) origin(tbirth) id(nhispid)
gen py=_t-_t0
drop if py==0
replace _d=0 if py>10
replace py=10 if py>10
gen decade=0
replace decade=1 if tenter>=2010
collapse (sum) _d py, by(regionbr female decade)
gen a=1
gen b=1
gen c=1
gen d=1

label variable a "Deaths"
label variable b "Deaths"
label variable c "Exposures"
label variable d "Exposures"
label define male 1 "Male"
label values a female
label values b male
label values c female
label values d male

table (regionbr) (a) [pweight=_d] if female==1, statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(a) replace
table (regionbr) (b) [pweight=_d] if female==0, statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(b) append
table (regionbr) (c) [pweight=py] if female==1, statistic(sumw) nformat(%11.2fc)  name(tablepy) totals(c) append
table (regionbr) (d) [pweight=py] if female==0, statistic(sumw) nformat(%17.0fc)  name(tablepy) totals(d) append


collect layout (regionbr) (a b c d)
collect title "Unweighted Death Counts and Person-Years of Exposure by Detailed Region of Birth and Sex (2000-2018)"
collect export "$texdir\tablepy_sex.tex", tableonly replace
******************************Person-Year Calculations******
use "$dir\data\nhis_00003_clean.dta", clear
label define regionbr 9 "East Asia", modify
*here we use the origin setting to calculate exact person-year contributions in each five-year age group, e.g. splitting at ages 15, 20, 25, 30, etc.
stset tdeath, failure(dead) enter(tenter) origin(tbirth) id(nhispid)
stsplit t_split, at(0(5)max)
gen py=_t-_t0
drop if py==0
replace _d=0 if py>10
replace py=10 if py>10

*calculating person-years and deaths
forvalues i = 15(5)100{
gen fiveL`i' = 0
replace fiveL`i' = py if t_split==`i'
label variable fiveL`i' "5L`i'"
gen fiveD`i'=0
replace fiveD`i' = 1 if _d==1 & t_split==`i'
label variable fiveD`i' "5D`i'"
label variable fiveL15 "2L18"
label variable fiveD15 "2D18"
}

*************************Death Tables**********************
label variable mortdody "Year of Death"

replace fiveD85=fiveD85+fiveD95+fiveD100
replace fiveL85=fiveL85+fiveL95+fiveL100
label variable fiveD85 "D85+"
label variable fiveL85 "L85+"

dtable fiveD15 fiveD20 fiveD25 fiveD30 fiveD35 fiveD40 fiveD45 fiveD50 fiveD55 fiveD60 fiveD65 fiveD70 fiveD75 fiveD80 fiveD85 if mortdody<2010 & regionbr!=1, by(mortdody, totals) nformat(%9.0g) nosample continuous(, statistics(rawtotal)) title("Foreign-Born Age-Specific Deaths By Year of Death (2000-2009)") export("$texdir\ndx_fb1.tex", as(tex) tableonly replace)

dtable fiveD15 fiveD20 fiveD25 fiveD30 fiveD35 fiveD40 fiveD45 fiveD50 fiveD55 fiveD60 fiveD65 fiveD70 fiveD75 fiveD80 fiveD85 if mortdody>=2010 & regionbr!=1, by(mortdody, totals) nformat(%9.0g) nosample continuous(, statistics(rawtotal)) title("Foreign-Born Age-Specific Deaths By Year of Death (2010-2019)") export("$texdir\ndx_fb2.tex", as(tex) tableonly replace)

dtable fiveD15 fiveD20 fiveD25 fiveD30 fiveD35 fiveD40 fiveD45 fiveD50 fiveD55 fiveD60 fiveD65 fiveD70 fiveD75 fiveD80 fiveD85 if mortdody<2010, by(mortdody, totals) nformat(%9.0g) nosample continuous(, statistics(rawtotal)) title("All Age-Specific Deaths By Year of Death (2000-2009)") export("$texdir\ndx_1.tex", as(tex) tableonly replace)

dtable fiveD15 fiveD20 fiveD25 fiveD30 fiveD35 fiveD40 fiveD45 fiveD50 fiveD55 fiveD60 fiveD65 fiveD70 fiveD75 fiveD80 fiveD85 if mortdody>=2010, by(mortdody, totals) nformat(%9.0g) nosample continuous(, statistics(rawtotal)) title("All Age-Specific Deaths By Year of Death (2010-2019)") export("$texdir\ndx_2.tex", as(tex) tableonly replace)
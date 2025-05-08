global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'
global texdir `"C:\Users\adria\Documents\penn\yr2\NHIS\tex"'

use "$dir\data\nhis_00003_clean.dta", clear
gen exact_age_quarter = round(exact_age*4)/4
egen age_fiveyr=cut(exact_age_quarter), at(0(5)105)

gen py=tdeath-tenter
drop if py==0

drop if exact_age_quarter<30 | age<30 

*drop if miss_regionbr==1 | miss_noncitizen==1 | miss_schooling==1 | miss_yrsinusg==1 | miss_marital==1

tab sex


*****801906

label variable age "Age"
recode yrsinusg (0=9)
label define yrsinusg 9 "NIU", modify
label values yrsinusg yrsinusg
gen N_unwt=1
label values N_unwt N
label variable N_unwt "N In Thousands (Unweighted)"
label define N_unwt 1 "Total"
label values N_unwt N_unwt
label variable female "Sex (Prct)"
label variable noncitizen "Citizenship (Prct)"
label variable yrsinusg "Years in U.S. (Prct)"
label variable period "Interview Year (Prct)"
label variable schooling "Schooling (Prct)"
label variable marital "Marital Status (Prct)"

label define schooling 0 "<HS" 1 "HS/GED" 2 "Some College" 3 "Bachelor's" 4 "Graduate", modify
label define regionbr 2 "Mex/CA", modify
label define regionbr 3 "S. Amer.", modify
label define regionbr 5 "R. & FSU", modify
label define regionbr 8 "Ind Subc", modify
label define regionbr 9 "E Asia", modify
label define regionbr 10 "SE Asia", modify
label define regionbr 11 "Else", modify
label define marital 2 "Sep/Div/Wid", modify


***missing
quietly: table (regionbr) (miss_noncitizen) [pweight=mortweight], statistic(percent, across(miss_noncitizen))  name(table4) totals(miss_noncitizen) replace
quietly: table (regionbr) (miss_yrsinusg) [pweight=mortweight], statistic(percent, across(miss_yrsinusg))  name(table4) totals(miss_yrsinusg) append
quietly: table (regionbr) (miss_schooling) [pweight=mortweight], statistic(percent, across(miss_schooling))  name(table4) totals(miss_schooling) append
quietly: table (regionbr) (miss_marital) [pweight=mortweight], statistic(percent, across(miss_marital))  name(table4) totals(miss_marital) nformat(%9.2f) append


collect layout (regionbr) (miss_noncitizen miss_yrsinusg miss_schooling miss_marital)
collect title "Percent Missing (Dropped) for Any Variables With Missing Data by Region of Birth"
collect export "$texdir\table4.tex", tableonly replace

drop if miss_regionbr==1 | miss_noncitizen==1 | miss_schooling==1 | miss_yrsinusg==1 | miss_marital==1

bysort regionbr: egen mean_age=mean(age)
label variable mean_age "Mean Age"
gen a=1
label variable a "Age"
label define a 1 "Mean"
label values a a

gen b=1
label variable b "Age"
label define b 1 "SD"
label values b b

gen c=1
label variable c "N In Thousands (Weighted)"
label define c 1 "Total"
label values c c
recode yrsinusg (0=1)(4=1)(1=4)(2=3)(3=2)(9=1)
label define yrsinusg 4 "Under 5 Yrs in U.S." 3 "5-9 Yrs in U.S." 2 "10-14 Yrs in U.S." 1 "NIU or 15+ Yrs in U.S.", modify


table (a) (regionbr), statistic(mean age) name(table1) nototals nformat(%9.1fc) replace
table (b) (regionbr), statistic(sd age) name(table1) nototals append
table (female) (regionbr) [pweight=mortweight], statistic(percent, across(female)) name(table1) totals(female) append
table (marital) (regionbr) [pweight=mortweight], statistic(percent, across(marital)) name(table1) totals(marital) append
table (schooling) (regionbr) [pweight=mortweight], statistic(percent, across(schooling)) name(table1) totals(schooling) append
table (noncitizen) (regionbr) [pweight=mortweight], statistic(percent, across(noncitizen)) name(table1) totals(noncitizen) append
table (yrsinusg) (regionbr) [pweight=mortweight], statistic(percent, across(yrsinusg)) name(table1) totals(yrsinusg) append
table (period) (regionbr) [pweight=mortweight], statistic(percent, across(period)) name(table1) totals(period) append
table (N_unwt) (regionbr) [pweight=1/1000], statistic(sumw) name(table1) totals(N_unwt) append
table (c) (regionbr) [pweight=mortweight/1000], statistic(sumw) name(table1) totals(c) append

collect layout (a b female marital schooling noncitizen yrsinusg period N_unwt c) (regionbr)
collect title "Sample Descriptives by Region of Birth: Percents are weighted, total N is given both weighted and unweighted."
collect export "$texdir\descriptives.tex", tableonly replace

/*
****model 1
quietly: table (regionbr) (N) [pweight=mortweight], statistic(frequency) nformat(%11.2f)  name(table1) totals(N) replace
quietly: table (regionbr) (N2), statistic(frequency) name(table1) totals(N2) append
quietly: table (regionbr) (female) [pweight=mortweight], statistic(percent, across(female)) name(table1) totals(female) append
quietly: table (regionbr) (period) [pweight=mortweight], statistic(percent, across(period)) name(table1) totals(period) append

collect layout (regionbr) (N N2 female period)
collect title "Baseline Descriptives by Region of Birth"
collect export "$texdir\table1.tex," tableonly replace


***model 2
quietly: table (regionbr) (noncitizen) [pweight=mortweight], statistic(percent, across(noncitizen)) nformat(%5.2f)  name(table2) totals(noncitizen) replace
quietly: table (regionbr) (yrsinusg) [pweight=mortweight], statistic(percent, across(yrsinusg)) nformat(%5.2f)  name(table2) totals(yrsinusg) append

collect layout (regionbr) (noncitizen yrsinusg)
collect title "Migration Descriptives by Region of Birth"
collect export "$texdirtable2.tex", tableonly replace

***model 3
quietly: table (regionbr) (schooling) [pweight=mortweight], statistic(percent, across(schooling)) nformat(%5.2f)  name(table3) totals(schooling) replace
quietly: table (regionbr) (marital) [pweight=mortweight], statistic(percent, across(marital)) nformat(%5.2f)  name(table3) totals(marital) append

collect layout (regionbr) (schooling marital)
collect title "Socioeconomic Descriptives by Region of Birth"
collect export "$texdir\table3.tex", tableonly replace




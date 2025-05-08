****calculate your lt's for one year age groups and set nax at 0.5 for each
****read HMD 
****what NVSS does is model til 65 and project at older ages

global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'
global texdir `"C:\Users\adria\Documents\penn\yr2\NHIS\tex"'


do `"$dir/201_NVSS_compare_models.do"'



import excel using "$dir\201_NHIS_lifetables_100.xlsx", ///
    sheet("females") cellrange(A1:D16) firstrow clear

rename nmxAll nMx_all_f
rename nmx200009 nMx_NHIS_2000s_f
rename nmx201018 nMx_NHIS_2010s_f

save "$dir\intermediate\nMx_f.dta", replace

import excel using "$dir\201_NHIS_lifetables_100.xlsx", ///
    sheet("males") cellrange(A1:D16) firstrow clear

rename nmxAll nMx_all_m
rename nmx200009 nMx_NHIS_2000s_m
rename nmx201018 nMx_NHIS_2010s_m

save "$dir\intermediate\nMx_m.dta", replace

import excel "$dir\200_NVSS_lifetables.xlsx", ///
    sheet("master") firstrow clear

keep MaleNVSS2005 FemaleNVSS2005 MaleNVSS2014 FemaleNVSS2014
replace MaleNVSS2005    = log(10000 * MaleNVSS2005)
replace FemaleNVSS2005  = log(10000 * FemaleNVSS2005)
replace MaleNVSS2014    = log(10000 * MaleNVSS2014)
replace FemaleNVSS2014  = log(10000 * FemaleNVSS2014)

rename MaleNVSS2005 nMx_NVSS_2005_m
rename FemaleNVSS2005 nMx_NVSS_2005_f
rename MaleNVSS2014 nMx_NVSS_2014_m
rename FemaleNVSS2014 nMx_NVSS_2014_f

save "$dir\intermediate\NVSS.dta", replace


use "$dir\intermediate\nMx_f.dta", clear
merge 1:1 _n using "$dir\intermediate\nMx_m.dta", nogen
merge 1:1 _n using "$dir\intermediate\NVSS.dta", nogen


gen ratio_NVSS2005_NHIS2000s_f = nMx_NVSS_2005_f / nMx_NHIS_2000s_f
gen ratio_NVSS2014_NHIS2010s_f = nMx_NVSS_2014_f / nMx_NHIS_2010s_f

gen ratio_NVSS2005_NHIS2000s_m = nMx_NVSS_2005_m / nMx_NHIS_2000s_m
gen ratio_NVSS2014_NHIS2010s_m = nMx_NVSS_2014_m / nMx_NHIS_2010s_m

drop if age_fiveyr > 80

local gridlines 0.8 0.9 1.1 1.2

* Female 2000s ratio
twoway ///
    (line ratio_NVSS2005_NHIS2000s_f age_fiveyr, lcolor(black) lpattern(solid)) ///
    (scatter ratio_NVSS2005_NHIS2000s_f age_fiveyr, mcolor(black)) ///
    , yline(1, lcolor(gs1) lpattern(dash)) ///
      yline(`gridlines', lcolor(gs12) lpattern(dot)) ///
    yscale(r(0.8 1.2)) ///
    ylabel(0.8(0.1)1.2, grid) ///
    legend(order(1 "NVSS 2005/NHIS 2000-2009") position(6)) ///
    title("Females 2000-2009") ///
    ytitle("Ratio: NVSS-to-NHIS") xtitle("Age x") name(ratio_female_2000s, replace)

* Female 2010s ratio
twoway ///
    (line ratio_NVSS2014_NHIS2010s_f age_fiveyr, lcolor(black) lpattern(solid)) ///
    (scatter ratio_NVSS2014_NHIS2010s_f age_fiveyr, mcolor(black)) ///
    , yline(1, lcolor(gs1) lpattern(dash)) ///
      yline(`gridlines', lcolor(gs12) lpattern(dot)) ///
    yscale(r(0.8 1.2)) ///
    ylabel(0.8(0.1)1.2, grid) ///
    legend(order(1 "NVSS 2014/NHIS 2010-2018") position(6)) ///
    title("Females 2010-2018") ///
    ytitle("Ratio: NVSS-to-NHIS") xtitle("Age x") name(ratio_female_2010s, replace)

* Male 2000s ratio
twoway ///
    (line ratio_NVSS2005_NHIS2000s_m age_fiveyr, lcolor(black) lpattern(solid)) ///
    (scatter ratio_NVSS2005_NHIS2000s_m age_fiveyr, mcolor(black)) ///
    , yline(1, lcolor(gs1) lpattern(dash)) ///
      yline(`gridlines', lcolor(gs12) lpattern(dot)) ///
    yscale(r(0.8 1.2)) ///
    ylabel(0.8(0.1)1.2, grid) ///
    legend(order(1 "NVSS 2005/NHIS 2000-2009") position(6)) ///
    title("Males 2000-2009") ///
    ytitle("Ratio: NVSS-to-NHIS") xtitle("Age x") name(ratio_male_2000s, replace)

* Male 2010s ratio
twoway ///
    (line ratio_NVSS2014_NHIS2010s_m age_fiveyr, lcolor(black) lpattern(solid)) ///
    (scatter ratio_NVSS2014_NHIS2010s_m age_fiveyr, mcolor(black)) ///
    , yline(1, lcolor(gs1) lpattern(dash)) ///
      yline(`gridlines', lcolor(gs12) lpattern(dot)) ///
    yscale(r(0.8 1.2)) ///
    ylabel(0.8(0.1)1.2, grid) ///
    legend(order(1 "NVSS 2014/NHIS 2010-2018") position(6)) ///
    title("Males 2010-2018") ///
    ytitle("Ratio: NVSS-to-NHIS") xtitle("Age x") name(ratio_male_2010s, replace)

* Combine the four graphs into separate panels (no colors, just black)
graph combine ratio_female_2000s ratio_female_2010s ratio_male_2000s ratio_male_2010s, cols(2)

* Export the final image
graph export "$texdir/nvss_compare_period_sex_100.jpg", width(8000) height(6000) replace

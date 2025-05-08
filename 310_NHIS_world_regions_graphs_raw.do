global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'
global texdir `"C:\Users\adria\Documents\penn\yr2\NHIS\tex"'

do `"$dir\311_NHIS_world_regions_raw.do"'

clear all
set more off

* Define the sheets
local sheets females_2000_09 females_2010_18 males_2000_09 males_2010_18

* Temporary file to combine all sheets
tempfile master
save `master', emptyok

* Loop for importing nMx data
foreach sheet of local sheets {
    * Step 1: Import nMx data from A1:G12 (this includes the first 11 rows)
    import excel using "311_NHIS_world_regions_lifetables_raw_100", ///
        sheet("`sheet'") cellrange(A1:G12) firstrow clear

    * Add sex variable based on sheet name
    gen sex = cond(strpos("`sheet'", "female"), "female", "male")

    * Replace the en-dash with a hyphen for period consistency
    gen period = cond(strpos("`sheet'", "2000_09"), "2000-2009", "2010-2018")

    * Step 2: Append nMx data to master dataset
    append using `master'
    save `master', replace
}

* Now load the master file with the nMx data
use `master', clear

label variable age_fiveyr "Age x"

* PANEL 1: All vs Native vs Foreign (Female 2000-09)
twoway ///
    (line nmxAll age_fiveyr if sex=="female" & period=="2000-2009", lcolor(black)) ///
    (line nmxNative age_fiveyr if sex=="female" & period=="2000-2009", lcolor(blue) lpattern(dash)) ///
    (line nmxForeign age_fiveyr if sex=="female" & period=="2000-2009", lcolor(red) lpattern(dash)) ///
    (scatter nmxAll age_fiveyr if sex=="female" & period=="2000-2009", mcolor(black)) ///
    (scatter nmxNative age_fiveyr if sex=="female" & period=="2000-2009", mcolor(blue)) ///
    (scatter nmxForeign age_fiveyr if sex=="female" & period=="2000-2009", mcolor(red)), ///
    legend(order(1 "All" 2 "Native-born" 3 "Foreign-born") rows(1)) ///
	 ytitle("log (10000*nMx)") title("Females 2000–2009") name(p1a, replace)

* Female 2010-18
twoway ///
    (line nmxAll age_fiveyr if sex=="female" & period=="2010-2018", lcolor(black)) ///
    (line nmxNative age_fiveyr if sex=="female" & period=="2010-2018", lcolor(blue) lpattern(dash)) ///
    (line nmxForeign age_fiveyr if sex=="female" & period=="2010-2018", lcolor(red) lpattern(dash)) ///
    (scatter nmxAll age_fiveyr if sex=="female" & period=="2010-2018", mcolor(black)) ///
    (scatter nmxNative age_fiveyr if sex=="female" & period=="2010-2018", mcolor(blue)) ///
    (scatter nmxForeign age_fiveyr if sex=="female" & period=="2010-2018", mcolor(red)), ///
    legend(off)  ytitle("log (10000*nMx)") title("Females 2010–2018") name(p1b, replace)

* Male 2000–09
twoway ///
    (line nmxAll age_fiveyr if sex=="male" & period=="2000-2009", lcolor(black)) ///
    (line nmxNative age_fiveyr if sex=="male" & period=="2000-2009", lcolor(blue) lpattern(dash)) ///
    (line nmxForeign age_fiveyr if sex=="male" & period=="2000-2009", lcolor(red) lpattern(dash)) ///
    (scatter nmxAll age_fiveyr if sex=="male" & period=="2000-2009", mcolor(black)) ///
    (scatter nmxNative age_fiveyr if sex=="male" & period=="2000-2009", mcolor(blue)) ///
    (scatter nmxForeign age_fiveyr if sex=="male" & period=="2000-2009", mcolor(red)), ///
    legend(off)  ytitle("log (10000*nMx)") title("Males 2000–2009") name(p1c, replace)

* Male 2010–18
twoway ///
    (line nmxAll age_fiveyr if sex=="male" & period=="2010-2018", lcolor(black)) ///
    (line nmxNative age_fiveyr if sex=="male" & period=="2010-2018", lcolor(blue) lpattern(dash)) ///
    (line nmxForeign age_fiveyr if sex=="male" & period=="2010-2018", lcolor(red) ) ///
    (scatter nmxAll age_fiveyr if sex=="male" & period=="2010-2018", mcolor(black)) ///
    (scatter nmxNative age_fiveyr if sex=="male" & period=="2010-2018", mcolor(blue)) ///
    (scatter nmxForeign age_fiveyr if sex=="male" & period=="2010-2018", mcolor(red)), ///
    legend(off)  ytitle("log (10000*nMx)") title("Males 2010–2018") name(p1d, replace)

* Combine into 2x2
grc1leg p1a p1b p1c p1d, legendfrom(p1a)
graph export "$texdir\panel1_nmx_all_native_foreign_raw_100.jpg", width(8000) height(6000) replace




* PANEL 2: By region (Female 2000–09)
twoway ///
    (line nmxAmericas age_fiveyr if sex=="female" & period=="2000-2009", lcolor(blue) lwidth(medthick) lpattern(dash)) ///
    (line nmxEurope age_fiveyr if sex=="female" & period=="2000-2009", lcolor(dkgreen) lwidth(medthick) ) ///
    (line nmxAsia age_fiveyr if sex=="female" & period=="2000-2009", lcolor(purple) lwidth(medthick) lpattern(shortdash)) ///
    (scatter nmxAmericas age_fiveyr if sex=="female" & period=="2000-2009", mcolor(blue)) ///
    (scatter nmxEurope age_fiveyr if sex=="female" & period=="2000-2009", mcolor(dkgreen)) ///
    (scatter nmxAsia age_fiveyr if sex=="female" & period=="2000-2009", mcolor(purple)), ///
    legend(order(1 "Americas" 2 "Europe" 3 "Asia") rows(1)) ///
    ytitle("log (10000*nMx)") title("Females 2000–2009") name(p2a, replace)

* Female 2010–18
twoway ///
    (line nmxAmericas age_fiveyr if sex=="female" & period=="2010-2018", lcolor(blue) lwidth(medthick) lpattern(dash)) ///
    (line nmxEurope age_fiveyr if sex=="female" & period=="2010-2018", lcolor(dkgreen) lwidth(medthick)) ///
    (line nmxAsia age_fiveyr if sex=="female" & period=="2010-2018", lcolor(purple) lwidth(medthick) lpattern(shortdash)) ///
    (scatter nmxAmericas age_fiveyr if sex=="female" & period=="2010-2018", mcolor(blue)) ///
    (scatter nmxEurope age_fiveyr if sex=="female" & period=="2010-2018", mcolor(dkgreen)) ///
    (scatter nmxAsia age_fiveyr if sex=="female" & period=="2010-2018", mcolor(purple)), ///
    ytitle("log (10000*nMx)") legend(off) title("Females 2010–2018") name(p2b, replace)

* Male 2000–09
twoway ///
    (line nmxAmericas age_fiveyr if sex=="male" & period=="2000-2009", lcolor(blue) lwidth(medthick) lpattern(dash)) ///
    (line nmxEurope age_fiveyr if sex=="male" & period=="2000-2009", lcolor(dkgreen) lwidth(medthick) ) ///
    (line nmxAsia age_fiveyr if sex=="male" & period=="2000-2009", lcolor(purple) lwidth(medthick) lpattern(shortdash)) ///
    (scatter nmxAmericas age_fiveyr if sex=="male" & period=="2000-2009", mcolor(blue)) ///
    (scatter nmxEurope age_fiveyr if sex=="male" & period=="2000-2009", mcolor(dkgreen)) ///
    (scatter nmxAsia age_fiveyr if sex=="male" & period=="2000-2009", mcolor(purple)), ///
    ytitle("log (10000*nMx)") legend(off) title("Males 2000–2009") name(p2c, replace)

* Male 2010–18
twoway ///
    (line nmxAmericas age_fiveyr if sex=="male" & period=="2010-2018", lcolor(blue) lwidth(medthick) lpattern(dash)) ///
    (line nmxEurope age_fiveyr if sex=="male" & period=="2010-2018", lcolor(dkgreen) lwidth(medthick) ) ///
    (line nmxAsia age_fiveyr if sex=="male" & period=="2010-2018", lcolor(purple) lwidth(medthick) lpattern(shortdash)) ///
    (scatter nmxAmericas age_fiveyr if sex=="male" & period=="2010-2018", mcolor(blue)) ///
    (scatter nmxEurope age_fiveyr if sex=="male" & period=="2010-2018", mcolor(dkgreen)) ///
    (scatter nmxAsia age_fiveyr if sex=="male" & period=="2010-2018", mcolor(purple)), ///
    ytitle("log (10000*nMx)") legend(off) title("Males 2010–2018") name(p2d, replace)

* Combine into 2x2
grc1leg p2a p2b p2c p2d, legendfrom(p2a)
graph export "$texdir\panel2_nmx_by_region_raw_100.jpg", width(8000) height(6000) replace

clear all
set more off

* Define the sheets
local sheets females_2000_09 females_2010_18 males_2000_09 males_2010_18

* Temporary file to combine all sheets
tempfile master
save `master', emptyok

* Loop for importing life expectancy data
foreach sheet of local sheets {
    * Step 1: Import life expectancy values from B18:G18
    import excel using "311_NHIS_world_regions_lifetables_raw_100.xlsx", ///
        sheet("`sheet'") cellrange(B18:G20) clear

    * Step 2: Assign life expectancy values to variables
    rename B e30_aAll
    rename C e30_bNative
    rename D e30_cForeign
    rename E e30_dAmericas
    rename F e30_eEurope
    rename G e30_fAsia
	
	
	* Add sex variable based on sheet name
    gen sex = cond(strpos("`sheet'", "females"), "female", "male")

    * Replace the en-dash with a hyphen for period consistency
    gen period = cond(strpos("`sheet'", "2000_09"), "2000-2009", "2010-2018")

	append using `master'
    save `master', replace
}

* Now load the master file with the life expectancy data
use `master', clear
gen expectancy=mod(_n-1, 3) + 1
label define expectancy 1 "30–85" 2 "30–65" 3 "65–85"
label values expectancy expectancy

gen obs=_n
reshape long e30_, i(obs) string
rename _j region
drop obs
reshape wide e30_, i(region sex period) j(expectancy)
rename e30_1 e30_85
rename e30_2 e30_65
rename e30_3 e65_85

gen decade=0
replace decade=1 if period=="2010-2018"

gen female=0
replace female=1 if sex=="female"

gen region_num = ceil(_n/4)
label define region_labels 1 "All" 2 "Native-Born" 3 "Foreign-Born" 4 "Americas" 5 "Europe" 6 "Asia"
label values region_num region_labels

label variable region_num "Region of Birth"

gen e30_85_label = round(e30_85, 0.01)

label define female 0 "Males" 1 "Females"
label values female female
label variable female "Gender"

graph twoway ///
    (scatter e30_85 region_num, mcolor(dkgreen) mlabel(e30_85_label) mlabcolor(dkgreen) mlabangle(45) mlabp(6)) ///
    (scatter e30_65 region_num, mcolor(navy)) ///
    (scatter e65_85 region_num, mcolor(purple)) ///
    (line e30_85 region_num, lcolor(dkgreen)) ///
    (line e30_65 region_num, lcolor(navy)) ///
    (line e65_85 region_num, lcolor(purple)), ///
    by(period female) ///
    xlabel(#5, valuelabel angle(45)) ///
    xtick(1/5, valuelabel) ///
    ytitle("Region of Birth") /// 
    legend(label(1 "e30_85") label(2 "e30_65") label(3 "e65_85") order(1 2 3))
	
graph export "$texdir\temp_le_scatter_region_raw_100.jpg", width(8000) height(6000) replace

gen a=1 if decade==0
gen b=1 if decade==0
gen c=1 if decade==0

gen d=1 if decade==1
gen k=1 if decade==1
gen f=1 if decade==1


collapse (mean) e30_85 e30_65 e65_85, by(a b c d k f region_num female decade)

label variable a "Temp LE 30-65"
label variable b "Temp LE 65-85"
label variable c "Temp LE 30-85"
label define years 1 "(Years)"

label variable d "Temp LE 30-65"
label variable k "Temp LE 65-85"
label variable f "Temp LE 30-85"
label values a b c d k f years

table (region_num) (a female) [pweight=e30_65], statistic(sumw) nformat(%11.2f)  name(tle1) nototals replace
table (region_num) (b female) [pweight=e65_85], statistic(sumw) nformat(%11.2f)  name(tle1) nototals append
table (region_num) (c female) [pweight=e30_85], statistic(sumw) nformat(%11.2f)  name(tle1) nototals append


collect layout (region_num) (a#female b#female c#female)
collect title "Temporary Life Expectancy by Region of Birth: 2000-2009. Raw Estimates from NHIS Data (Weighted)."
collect export "$texdir\tle1_raw.tex", tableonly replace

table (region_num) (d female) [pweight=e30_65], statistic(sumw) nformat(%11.2f)  name(tle2) nototals replace
table (region_num) (k female) [pweight=e65_85], statistic(sumw) nformat(%11.2f)  name(tle2) nototals append
table (region_num) (f female) [pweight=e30_85], statistic(sumw) nformat(%11.2f)  name(tle2) nototals append

collect layout (region_num) (d#female k#female f#female)
collect title "Temporary Life Expectancy by Region of Birth: 2010-2018. Raw Estimates from NHIS Data (Weighted)."
collect export "$texdir\tle2_raw.tex", tableonly replace
	
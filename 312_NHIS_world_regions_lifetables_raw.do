args nMx which_analysis
insobs 1
gen nax=2.5
gen n=5
gen nmx=nMx
gen nqx=(nMx*n)/(1+((n-nax)*(nMx)))
gen npx=1-nqx
drop if age_fiveyr<30
sort age_fiveyr
gen lx=.
replace lx=1000 if age==30
replace lx = lx[_n-1] * npx[_n-1] if _n > 1
gen ndx=lx*nqx
gen nLx=nax*ndx + l[_n+1]*n
gen cumsum30=[sum(nLx)]/1000
gen e30_temp85=cumsum30[_N]

gen nLx65=0
replace nLx65=nLx if _n>=8
scalar l65=lx[8]
gen cumsum65=[sum(nLx65)]/l65
gen e65_temp85=cumsum65[_N]

gen nLx30_65=0
replace nLx30_65=nLx if _n<8
gen cumsum30_65=[sum(nLx30_65)]/1000
gen e30_temp65=cumsum30_65[_N]




**formatting output for excel

replace nmx = log(10000*nmx)

****MAKING EXCEL
putexcel set "311_NHIS_world_regions_lifetables_raw", replace

* 2000-2009: FEMALES
if which_analysis==1 {
    export excel age_fiveyr nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", replace) cell(A1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel B1 = "nmx All"
    putexcel B18 = e30_temp85
	putexcel B19 = e30_temp65
	putexcel B20 = e65_temp85
}
if which_analysis==3 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", modify) cell(C1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel C1 = "nmx Native"
    putexcel C18 = e30_temp85
	putexcel C19 = e30_temp65
	putexcel C20 = e65_temp85
}
if which_analysis==5 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", modify) cell(D1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel D1 = "nmx Foreign"
    putexcel D18 = e30_temp85
	putexcel D19 = e30_temp65
	putexcel D20 = e65_temp85
}
if which_analysis==7 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", modify) cell(E1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel E1 = "nmx Americas"
    putexcel E18 = e30_temp85
	putexcel E19 = e30_temp65
	putexcel E20 = e65_temp85
}
if which_analysis==9 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", modify) cell(F1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel F1 = "nmx Europe"
    putexcel F18 = e30_temp85
	putexcel F19 = e30_temp65
	putexcel F20 = e65_temp85
}
if which_analysis==11 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2000_09", modify) cell(G1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2000_09") modify
    putexcel G1 = "nmx Asia"
    putexcel G18 = e30_temp85
	putexcel G19 = e30_temp65
	putexcel G20 = e65_temp85
}

* 2000-2009: MALES
if which_analysis==2 {
    export excel age_fiveyr nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", replace) cell(A1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel B1 = "nmx All"
    putexcel B18 = e30_temp85
	putexcel B19 = e30_temp65
	putexcel B20 = e65_temp85
}
if which_analysis==4 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", modify) cell(C1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel C1 = "nmx Native"
    putexcel C18 = e30_temp85
	putexcel C19 = e30_temp65
	putexcel C20 = e65_temp85
}
if which_analysis==6 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", modify) cell(D1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel D1 = "nmx Foreign"
    putexcel D18 = e30_temp85
	putexcel D19 = e30_temp65
	putexcel D20 = e65_temp85
}
if which_analysis==8 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", modify) cell(E1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel E1 = "nmx Americas"
    putexcel E18 = e30_temp85
	putexcel E19 = e30_temp65
	putexcel E20 = e65_temp85

}
if which_analysis==10 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", modify) cell(F1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel F1 = "nmx Europe"
    putexcel F18 = e30_temp85
	putexcel F19 = e30_temp65
	putexcel F20 = e65_temp85
}
if which_analysis==12 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2000_09", modify) cell(G1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2000_09") modify
    putexcel G1 = "nmx Asia"
    putexcel G18 = e30_temp85
	putexcel G19 = e30_temp65
	putexcel G20 = e65_temp85
}

* 2010-2018: FEMALES
if which_analysis==13 {
    export excel age_fiveyr nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", replace) cell(A1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel B1 = "nmx All"
    putexcel B18 = e30_temp85
	putexcel B19 = e30_temp65
	putexcel B20 = e65_temp85
}
if which_analysis==15 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", modify) cell(C1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel C1 = "nmx Native"
    putexcel C18 = e30_temp85
	putexcel C19 = e30_temp65
	putexcel C20 = e65_temp85
}
if which_analysis==17 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", modify) cell(D1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel D1 = "nmx Foreign"
    putexcel D18 = e30_temp85
	putexcel D19 = e30_temp65
	putexcel D20 = e65_temp85
}
if which_analysis==19 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", modify) cell(E1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel E1 = "nmx Americas"
    putexcel E18 = e30_temp85
	putexcel E19 = e30_temp65
	putexcel E20 = e65_temp85
}
if which_analysis==21 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", modify) cell(F1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel F1 = "nmx Europe"
    putexcel F18 = e30_temp85
	putexcel F19 = e30_temp65
	putexcel F20 = e65_temp85
}
if which_analysis==23 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("females_2010_18", modify) cell(G1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("females_2010_18") modify
    putexcel G1 = "nmx Asia"
    putexcel G18 = e30_temp85
	putexcel G19 = e30_temp65
	putexcel G20 = e65_temp85
}

* 2010-2018: MALES
if which_analysis==14 {
    export excel age_fiveyr nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", replace) cell(A1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel B1 = "nmx All"
    putexcel B18 = e30_temp85
	putexcel B19 = e30_temp65
	putexcel B20 = e65_temp85
}
if which_analysis==16 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", modify) cell(C1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel C1 = "nmx Native"
    putexcel C18 = e30_temp85
	putexcel C19 = e30_temp65
	putexcel C20 = e65_temp85
}
if which_analysis==18 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", modify) cell(D1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel D1 = "nmx Foreign"
    putexcel D18 = e30_temp85
	putexcel D19 = e30_temp65
	putexcel D20 = e65_temp85
}
if which_analysis==20 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", modify) cell(E1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel E1 = "nmx Americas"
    putexcel E18 = e30_temp85
	putexcel E19 = e30_temp65
	putexcel E20 = e65_temp85
}
if which_analysis==22 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", modify) cell(F1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel F1 = "nmx Europe"
    putexcel F18 = e30_temp85
	putexcel F19 = e30_temp65
	putexcel F20 = e65_temp85
}
if which_analysis==24 {
    export excel nmx using "311_NHIS_world_regions_lifetables_raw", first(var) sheet("males_2010_18", modify) cell(G1)
    putexcel set "311_NHIS_world_regions_lifetables_raw", sheet("males_2010_18") modify
    putexcel G1 = "nmx Asia"
    putexcel G18 = e30_temp85
	putexcel G19 = e30_temp65
	putexcel G20 = e65_temp85
}


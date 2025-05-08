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
gen temp=[sum(nLx)]/1000
gen e30_temp85=temp[_N]

**formatting output for excel

replace nmx = log(10000*nmx)

****MAKING EXCEL
putexcel set "201_NHIS_lifetables", replace

if which_analysis==1 {
export excel age_fiveyr nmx using "201_NHIS_lifetables" if which_analysis==1, first(var) sheet("females", replace) cell(A1)
putexcel set "201_NHIS_lifetables", sheet(females) modify
putexcel B1="nmx All"
putexcel B18=e30_temp85
}
if which_analysis==2 {
export excel age_fiveyr nmx using "201_NHIS_lifetables" if which_analysis==2, first(var) sheet("males", replace) cell(A1)
putexcel set "201_NHIS_lifetables", sheet(males) modify
putexcel B1="nmx All"
putexcel B18=e30_temp85
}

if which_analysis==3 {
export excel nmx using "201_NHIS_lifetables" if which_analysis==3, first(var) sheet("females", modify) cell(C1)
putexcel set "201_NHIS_lifetables", sheet(females) modify
putexcel C1="nmx 2000-09"
putexcel C18=e30_temp85
} 

if which_analysis==4 {
export excel nmx using "201_NHIS_lifetables" if which_analysis==4, first(var) sheet("males", modify) cell(C1)
putexcel set "201_NHIS_lifetables", sheet(males) modify
putexcel C1="nmx 2000-09"
putexcel C18=e30_temp85
}

if which_analysis==5 {
export excel nmx using "201_NHIS_lifetables" if which_analysis==5, first(var) sheet("females", modify) cell(D1)
putexcel set "201_NHIS_lifetables", sheet("females") modify
putexcel D1="nmx 2010-18"
putexcel D18=e30_temp85
}

if which_analysis==6 {
export excel nmx using "201_NHIS_lifetables" if which_analysis==6, first(var) sheet("males", modify) cell(D1)
putexcel set "201_NHIS_lifetables", sheet(males) modify
putexcel D1="nmx 2010-18"
putexcel D18=e30_temp85
}

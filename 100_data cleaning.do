global dir `"C:\Users\adria\Documents\penn\yr2\NHIS\analysis"'

use "$dir\data\nhis_00003.dta", clear

drop if year==2019
tab age
*note mortwtsa is available for 1997-2018 adjusting for ineligible respondents in analyses of data linking NHIS participants to the national death index (ND) with mortality follow-up through dec 31 2019

drop if mortelig!=1
tab age
*********************************** start tracking missing cases here ***************************
*case count: 1,068,588
*************************************************************************************************
*gen mortweight=mortwtsa/19

gen mortweight=mortwt/19 if year<2015
replace mortweight=mortwtsa/19 if year>=2015
*svyset psu [pweight=mortweight], strata(strata)
*svy: mean regionbr

label define missing 0 "Valid" 1 "Missing"

mvdecode regionbr, mv(99)
fre regionbr
*missing 2606 regionbr
gen miss_regionbr=0
replace miss_regionbr=1 if regionbr==.
label variable miss_regionbr "Missing Region of Birth"
label values miss_regionbr missing

gen raceth=.
replace raceth=0 if racenew==100 & hispeth==10
replace raceth=1 if racenew==200 & hispeth==10
replace raceth=2 if racenew==400 & hispeth==10
replace raceth=3 if hispeth>10
label define raceth 0 "NH white" 1 "NH Black" 2 "NH Asian" 3 "Hispanic"
label values raceth raceth
label variable raceth "Race/Ethnicity"
*no missing in each base variable, but we exclude AIAN, Other, Not Releasable, and Multiple from race variable (no exclusions from hisp eth variable)
*missing AIAN 9835
*missing other 9206
*missing not releasable 1791
*missing multiple race 15933
gen drop_raceth=0
replace drop_raceth=1 if racenew==300
replace drop_raceth=2 if racenew==520
replace drop_raceth=3 if racenew==530
replace drop_raceth=4 if racenew==541
label define drop_raceth 1 "AIAN" 2 "Other" 3 "Not Releasable" 4 "Multiple"
label values drop_raceth drop_raceth
label variable drop_raceth "Dropped Race/Ethnicity"

gen island_born_pr = 0
replace island_born_pr=1 if hispeth==30 & regionbr==2
replace island_born_pr=1 if hispeth==30 & usborn==11
gen native_pr=0
replace native_pr=1 if hispeth==30 & regionbr==1 & usborn==20

****************************************************PUERTO RICANS RECODED AS NATIVE-B
replace regionbr=1 if island_born_pr==1
replace yrsinusg=0 if island_born_pr==1

label define regionbr 1 "U.S." 2 "Mexico, Central America, Caribbean"  3 "South America" 4 "Europe" 5 "Russia & FSU" 6 "Africa" 7 "Middle East" 8 "Indian Subcontinent" 9 "East Asia" 10 "Southeast Asia" 11 "Elsewhere"
label values regionbr regionbr
label variable yrsinusg "Years in U.S."
label variable regionbr "Global Region of Birth"
label variable region "U.S. Region"
label define region 1 "Northeast" 2 "North Central/Midwest" 3 "South" 4 "West"
label values region region
*no missing region


mvdecode citizen, mv(7 8 9)
gen noncitizen = citizen
recode noncitizen (2=0)
label define noncitizen 0 "US Citizen" 1 "Non-Citizen"
label values noncitizen noncitizen
label variable noncitizen "Citizenship"

*missing 4715 citizen
gen miss_noncitizen=0
replace miss_noncitizen=1 if noncitizen==.
label variable miss_noncitizen "Citizenship"
label values miss_noncitizen missing

generate foreignborn=.
replace foreignborn=0 if regionbr==1
replace foreignborn=1 if regionbr>1
label define foreignborn 0 "US-Born" 1 "Foreign-Born"
label values foreignborn foreignborn
label variable foreignborn "Foreign-Born"
*based on regionbr

mvdecode age, mv(997 999)
label define age 85 "85+"
label values age age
label variable age "Age"
gen age2 = age*age
label variable age2 "Age Squared"
*no missing

generate female=.
replace female=0 if sex==1
replace female=1 if sex==2
label define female 0 "Male" 1 "Female"
label values female female
label variable female "Female"
label variable female "Gender"
*no missing

generate dead=.
replace dead=1 if mortstat==1
replace dead=0 if mortstat==2
label define dead 0 "Assumed Alive" 1 "Assumed Dead"
label values dead dead
label variable dead "Mortality Status"

mvdecode yrsinusg, mv(8)
*missing 6840
gen miss_yrsinusg=0
replace miss_yrsinusg=1 if yrsinusg==.
label variable miss_yrsinusg "Years in U.S."
label values miss_yrsinusg missing

generate schooling=.
replace schooling=0 if educ>100 & educ<200
replace schooling=1 if educ>200 & educ < 300
replace schooling=2 if educ>300 & educ<400
replace schooling=3 if educ==400
replace schooling=4 if educ>500 & educ<600
label define schooling 0 "<12 grades (no diploma)" 1 "HS diploma or GED" 2 "Some college" 3 "Bachelor's degree" 4 "Graduate/professional degree"
label values schooling schooling
label variable schooling "Schooling"
*missing 15785
gen miss_schooling=0
replace miss_schooling=1 if schooling==.
label variable miss_schooling "Schooling"
label values miss_schooling missing


recode yrsinusg (2=1)(3=2)(4=3)(5=4)
label define yrsinusg 0 "Not In Universe" 1 "<5 yrs" 2 "5 to <10yrs" 3 "10 to <15 yrs" 4 "15+ yrs"
label values yrsinusg yrsinusg


gen marital=.
replace marital=1 if marstcohab==1 | marstcohab==2 | marstcohab==7
replace marital=2 if marstcohab==4 | marstcohab==5 | marstcohab==6
replace marital=3 if marstcohab==8
label define marital 1 "Married/Cohab" 2 "Separated/Divorced/Widowed" 3 "Never Married"
label values marital marital
label variable marital "Marital/Cohab Status"
*unknown marstcohab 2946
gen miss_marital=0
replace miss_marital=1 if marital==.
label variable miss_marital "Marital Status"
label values miss_marital missing

*note intervwyr is often one more than year, with intervwmo being january
gen period=.
replace period=1 if year>=2000 & year<2005
replace period=2 if year>=2005 & year<2010
replace period=3 if year>=2010 & year<2015
replace period=4 if year>=2015
label define period 1 "2000-2004" 2 "2005-2009" 3 "2010-2014" 4 "2015-2018"
label values period period
label variable period "Interview Year"
*no missing year

label variable age "Age"

*******************AGE****************************
*cleaning variables
mvdecode mortdody, mv(9999)
*no missing, just NIU because still alive
mvdecode mortdodq, mv(9)
*no missing, just NIU because still alive

mvdecode birthyr, mv(9997 9998 9999)
*missing 93913
*after dropping everything else except age 18-30, missing 35547
*after dropping below 30, missing 27382

mvdecode birthmo, mv(99 98 97)
*missing 165834
*after dropping everything else (but not age 18-30), missing 41193
*after dropping below age 30, missing 31743
mvdecode intervwyr, mv(9998)
replace intervwyr=year if intervwyr==.
*missing 12 intervwyr - replace with year
*same after dropping everything else
mvdecode intervwmo, mv(98)
*no missing intervwmo

*handling missing intervwyr & birthyr using age to deduce the missing piece

*from iPUMS: "BIRTHYR is bottom coded to 84 years before the survey year (e.g. for 1997, bottom code is 1913: birth year 1913 and before; for 1998, bottom code is 1914: birth year 1914 and before)."
*note--birthyr missing: in the "replace birthyr=intervwyr-age if birthyr==." line, a LOT of changes are made (9000 in the 10% sample)
gen birthyr_flag=1 if birthyr==.
replace birthyr=intervwyr-age if birthyr==.
*84,602 changes made after other stuff dropped

*replace birthyr=intervwyr-age if intervwyr-birthyr>84
*below, we will handle missing birthmo cases to set birth month to mid-year (equally dist between 2nd and 3rd q)

*here, we set any missing birthmo (and therefore birthq) randomly between quarters 2 and 3
*note lots of mirthmo are missing
gen birthmo_flag=1 if birthmo==.
replace birthmo= 6 + (runiform() > 0.5) if birthmo==.
*124,803 changes made for pop age 30-84


*we set birth quarter assuming births are at the midpoint of each quarter
egen birthq= cut(birthmo), at(0,4,7,10,13)
recode birthq (0=.125)(4=.375)(7=.625)(10=.875)
tab2 birthmo birthq


*similarly, we assume interviews are at the midpoint of each quarter
egen intervwq=cut(intervwmo), at(0,4,7,10,13)
recode intervwq (0=.125)(4=.375)(7=.625)(10=.875)
tab2 intervwmo intervwq

*we set time of entry into study to interview time (tenter - midpoint of quarter, tenter_exact - midpoint of month)
gen tenter=intervwyr+intervwq
gen tenter_exact=intervwyr+((intervwmo-(0.5))/12)

*we calculate time of birth in two ways: by midpoint of quarter (tbirth) and by midpoint of birth month (tbirth_exact)
gen tbirth=birthyr+birthq
gen tbirth_exact=birthyr+((birthmo-(0.5))/12)

*we calculate exact age at time of interview using midpoints of interview & birth months (if birth month missing, exact age assuming birthmo=intervwmo)
gen exact_age=tenter_exact-tbirth_exact

*similar to births and interviews, we assume deaths were at the midpoint of the quarter (the 1/8, 3/8, 5/8, 7/8 points of the year)
recode mortdodq (1=.125)(2=.375)(3=.625)(4=.875)
gen tdeath = mortdody+mortdodq

*we set the last analysis time to what appears to be the latest follow up, the end of 2019 (rounding to the midpoint of the last quarter)
recode tdeath (.=2019.875)


*************************drop missing cases*****************************/*
dtable i.miss_noncitizen i.miss_yrsinusg i.miss_schooling i.miss_marital if regionbr<6, by(regionbr, nototals notests) nosample title("Missing Independent Variables by Region of Birth") export("C:\Users\adria\Documents\penn\yr2\NHIS\tex\missing1.tex", as(tex) tableonly replace)

dtable i.miss_noncitizen i.miss_yrsinusg i.miss_schooling i.miss_marital if regionbr>=6, by(regionbr, nototals notests) nosample title("Missing Independent Variables by Region of Birth") export("C:\Users\adria\Documents\penn\yr2\NHIS\tex\missing2.tex", as(tex) tableonly replace)

*/
drop if age>=85
*21,252 observations deleted


*drop if miss_regionbr==1 | miss_noncitizen==1 | miss_schooling==1 | miss_yrsinusg==1 | miss_marital==1
*24,595 observations deleted before dropping 85+
*23,772 observations deleted after dropping 85+


save "$dir\data\nhis_00003_clean.dta", replace
**************************************************UNWEIGHTED 25 SPLIT*************************************************
use "$dir\data\nhis_00003_clean.dta", clear
drop if miss_regionbr==1 | miss_noncitizen==1 | miss_schooling==1 | miss_yrsinusg==1 | miss_marital==1
*take a sample - stset on the whole thing is tough for my computer
sample 25

save "$dir\data\nhis_00003_clean_25.dta", replace

use "$dir\data\nhis_00003_clean_25.dta", clear
stset tdeath, failure(dead) enter(tenter) origin(tenter) id(nhispid)
stsplit t_split, at(0(0.25)41)
bysort nhispid (t_split): gen obs=_N
if obs>40 {
	bysort nhispid (obs): drop if _n>40
}
*2,450,131 observations deleted

*replace mortweight=mortweight/obs
replace exact_age=exact_age+_t0
replace tenter=tenter+_t0
*take a sample - stset on the whole thing is tough for my computer



************MAKING LTs - from raw counts**********
gen py=_t-_t0
*Round exact_age to the nearest quarter-year (0.25 years)
gen exact_age_quarter = round(exact_age*4)/4

*Create the offset variable (log of person-years)
gen log_py = log(py)

eststo clear

*For now we think having two life tables (2000-2009 & 2010-2018) would make sense
gen decade2010=0
replace decade2010=1 if tenter>2010

label define decade 0 "2000-2009" 1 "2010-2018"
label values decade decade


egen age_fiveyr=cut(exact_age_quarter), at(0(5)105)

save "$dir\data\nhis_00003_clean_mortweight25split.dta", replace


***********************************************
***********************************************
** The Causal Effects of Korea's Quota Tariff Policy on Agricultural Product Retail Prices (Replication Code)
** Deokjae Jeong, Youngmi Kim
** 2026
** Korea Customs and Trade Development Institute
***********************************************
***********************************************



// #sr How to set up the replication
* 1) Point the global path below to the folder holding this replication package. Everything in
*    Stata runs from this main.do. The custom command check_TRQquota.ado ships with the package;
*    the adopath line below lets Stata find it. Install rangestat once: ssc install rangestat.
* 2) Raw files larger than 100MB are not stored on GitHub. Download them from the NAS link given
*    in README.md and place them here first: 도매가격(전국도매시장).txt (and optionally d1.dta).
* 3) R is optional: the three R outputs (q_all_*_STL_result.csv) ship with the package, so
*    main.do runs end-to-end without R. Python is needed only for Paper Table 1 and Paper
*    Table 4 — see the "How to ..." blocks further down.
* 4) One manual hand-off: WTO_TRQ_gen.do rebuilds WTO_TRQ.dta from a mid-pipeline dataset
*    (m1_temp5). The ready-made WTO_TRQ.dta ships with the package, so a straight run works.
* 5) Paper Table 8 (onset/washout classification) is a hand-made table and is not reproduced
*    by code; the rules it follows (30-day bridging, 120-day washout) are implemented in the
*    LPseparate_*.do files. The quota figures in Paper Table 2 (p.11) appear as the hard-coded
*    max_quota values in the threshold-check block of this file.
// #er



global path="Your path to the replication package folder"
cd "${path}"
adopath + "${path}"
set more off, permanent



// #sr Calculation of effective tariff rates
//! Stata 19
forval i=2021(1)2025 {
    import excel "${path}/`i'_selected_finished_processed_v2", sheet("Sheet1") firstrow allstring clear
    gen year=`i'
    save `i'_sp, replace 
}

use 2021_sp, clear
forval i=2022(1)2025 {
    append using `i'_sp 
}
order year month HS10
gen idn=_n
destring month, replace 
gen time = ym(year, month)
format time %tm
save sp0, replace 


//! STATA 14
use sp0, clear  
rename IMP_인도 IMP_인도인디아 
foreach var of varlist CUS_* {
    destring `var', replace 
}
foreach var of varlist IMP_* {
    destring `var', replace 
}


* No CUS_F prefix variables matching the patterns MY, BN, LA, or TH were found.
foreach var of varlist CUS_FCEPA1_1 CUS_FCEPA1_2 CUS_FCEPA2_1 CUS_FCEPA2_2 CUS_FCEPA3_1 CUS_FCEPA3_2 CUS_FCEPA4_1 CUS_FCEPA4_2 CUS_FCEPA5_1 CUS_FCEPA5_2 CUS_FCEPA6_1 CUS_FCEPA6_2 CUS_FCEPA7_1 CUS_FCEPA7_2 CUS_FCEPA8_1 CUS_FCEPA8_2 {
    replace `var' = . if time<=733
}

foreach var of varlist CUS_FIL1_1 CUS_FIL1_2 CUS_FIL2_1 CUS_FIL2_2 CUS_FIL3_1 CUS_FIL3_2 CUS_FIL4_1 CUS_FIL4_2 CUS_FIL5_1 CUS_FIL5_2 CUS_FIL7_1 CUS_FIL7_2 {
    replace `var' = . if time<=754
}

foreach var of varlist CUS_FKH1_1 CUS_FKH1_2 CUS_FKH2_1 CUS_FKH2_2 CUS_FKH3_1 CUS_FKH3_2 CUS_FKH4_1 CUS_FKH4_2 {
    replace `var' = . if time<=754
}

foreach var of varlist CUS_FID1_1 CUS_FID1_2 CUS_FID2_1 CUS_FID2_2 CUS_FID3_1 CUS_FID3_2 {
    replace `var' = . if time<=755
}

foreach var of varlist CUS_FPH1_1 CUS_FPH1_2 CUS_FPH2_1 CUS_FPH2_2 CUS_FPH3_1 CUS_FPH3_2 {
    replace `var' = . if time<=779
}

foreach var of varlist CUS_FRCCN1_1 CUS_FRCCN1_2 CUS_FRCCN2_1 CUS_FRCCN2_2 CUS_FRCCN3_1 CUS_FRCCN3_2 CUS_FRCCN4_1 CUS_FRCCN4_2 CUS_FRCCN5_1 CUS_FRCCN5_2 {
    replace `var' = . if time<=744
}

foreach var of varlist CUS_FRCJP1_1 CUS_FRCJP1_2 CUS_FRCJP2_1 CUS_FRCJP2_2 CUS_FRCJP3_1 CUS_FRCJP3_2 CUS_FRCJP4_1 CUS_FRCJP4_2 CUS_FRCJP5_1 CUS_FRCJP5_2 CUS_FRCJP6_1 CUS_FRCJP6_2 CUS_FRCJP9_1 CUS_FRCJP9_2 {
    replace `var' = . if time<=744
}

foreach var of varlist CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2 {
    replace `var' = . if time<=744
}

foreach var of varlist CUS_FRCAU1_1 CUS_FRCAU1_2 CUS_FRCAU2_1 CUS_FRCAU2_2 CUS_FRCAU3_1 CUS_FRCAU3_2 CUS_FRCAU4_1 CUS_FRCAU4_2 CUS_FRCAU5_1 CUS_FRCAU5_2 CUS_FRCAU6_1 CUS_FRCAU6_2 CUS_FRCAU7_1 CUS_FRCAU7_2 CUS_FRCAU8_1 CUS_FRCAU8_2 {
    replace `var' = . if time<=744
}

foreach var of varlist CUS_FRCNZ1_1 CUS_FRCNZ1_2 CUS_FRCNZ2_1 CUS_FRCNZ2_2 CUS_FRCNZ3_1 CUS_FRCNZ3_2 CUS_FRCNZ4_1 CUS_FRCNZ4_2 CUS_FRCNZ5_1 CUS_FRCNZ5_2 CUS_FRCNZ6_1 CUS_FRCNZ6_2 CUS_FRCNZ7_1 CUS_FRCNZ7_2 CUS_FRCNZ8_1 CUS_FRCNZ8_2 {
    replace `var' = . if time<=744
}
save sp0_temp1, replace


** Reflecting seasonal tariffs or quota tariffs (Phase1)
use sp0_temp1, clear
sort HS10
//soybeans
gen IMP_콩_중국=0
foreach var of varlist IMP_중국 {
    replace IMP_콩_중국=IMP_콩_중국+`var' if `var'!=.
}
replace IMP_콩_중국=IMP_콩_중국/1000
bysort HS10 year (month): gen IMP_콩_중국_누적 = sum(IMP_콩_중국)
replace CUS_FCN6_1=CUS_FCN1_1 if IMP_콩_중국_누적>7000&inlist(HS10,"1201909000")
replace IMP_콩_중국_누적=IMP_콩_중국_누적-7000
replace IMP_콩_중국_누적=0 if IMP_콩_중국_누적<=0

gen IMP_콩_호주=0
foreach var of varlist IMP_호주 {
    replace IMP_콩_호주=IMP_콩_호주+`var' if `var'!=.
}
replace IMP_콩_호주=IMP_콩_호주/1000
bysort HS10 year (month): gen IMP_콩_호주_누적 = sum(IMP_콩_호주)
replace CUS_FAU8_1=CUS_FAU1_1 if IMP_콩_호주_누적>1000&inlist(HS10,"1201909000")
replace IMP_콩_호주_누적=IMP_콩_호주_누적-1000
replace IMP_콩_호주_누적=0 if IMP_콩_호주_누적<=0

gen IMP_콩_캐나다=0
foreach var of varlist IMP_캐나다 {
    replace IMP_콩_캐나다=IMP_콩_캐나다+`var' if `var'!=.
}
replace IMP_콩_캐나다=IMP_콩_캐나다/1000
bysort HS10 year (month): gen IMP_콩_캐나다_누적 = sum(IMP_콩_캐나다)
replace CUS_FCA2_1=CUS_FCA1_1 if IMP_콩_캐나다_누적>17000&inlist(HS10,"1201909000")
replace IMP_콩_캐나다_누적=IMP_콩_캐나다_누적-17000
replace IMP_콩_캐나다_누적=0 if IMP_콩_캐나다_누적<=0
//U.S. soybeans are excluded from the calculation


//red beans (adzuki)
gen IMP_팥_중국=0
foreach var of varlist IMP_중국 {
    replace IMP_팥_중국=IMP_팥_중국+`var' if `var'!=.
}
replace IMP_팥_중국=IMP_팥_중국/1000
bysort HS10 year (month): gen IMP_팥_중국_누적 = sum(IMP_팥_중국)
replace CUS_FCN6_1=CUS_FCN1_1 if IMP_팥_중국_누적>3000&inlist(HS10,"0713329000")
replace IMP_팥_중국_누적=IMP_팥_중국_누적-3000
replace IMP_팥_중국_누적=0 if IMP_팥_중국_누적<=0

gen IMP_팥_캐나다=0
foreach var of varlist IMP_캐나다 {
    replace IMP_팥_캐나다=IMP_팥_캐나다+`var' if `var'!=.
}
replace IMP_팥_캐나다=IMP_팥_캐나다/1000
bysort HS10 year (month): gen IMP_팥_캐나다_누적 = sum(IMP_팥_캐나다)
replace CUS_FCA1_1=CUS_FCA8_1 if IMP_팥_캐나다_누적>547&inlist(HS10,"0713329000")
replace IMP_팥_캐나다_누적=IMP_팥_캐나다_누적-547
replace IMP_팥_캐나다_누적=0 if IMP_팥_캐나다_누적<=0

gen IMP_팥_미국=0
foreach var of varlist IMP_미국 {
    replace IMP_팥_미국=IMP_팥_미국+`var' if `var'!=.
}
replace IMP_팥_미국=IMP_팥_미국/1000
bysort HS10 year (month): gen IMP_팥_미국_누적 = sum(IMP_팥_미국)
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_팥_미국_누적>619&inlist(HS10,"0713329000")
replace IMP_팥_미국_누적=IMP_팥_미국_누적-619
replace IMP_팥_미국_누적=0 if IMP_팥_미국_누적<=0

// Sesame
gen IMP_참깨_중국=0
foreach var of varlist IMP_중국 {
    replace IMP_참깨_중국=IMP_참깨_중국+`var' if `var'!=.
}
replace IMP_참깨_중국=IMP_참깨_중국/1000
bysort HS10 year (month): gen IMP_참깨_중국_누적 = sum(IMP_참깨_중국)
replace CUS_FCN6_1=CUS_FCN1_1 if IMP_참깨_중국_누적>24000&inlist(HS10,"1207400000")
replace IMP_참깨_중국_누적=IMP_참깨_중국_누적-24000
replace IMP_참깨_중국_누적=0 if IMP_참깨_중국_누적<=0

//Banana
gen CUS_FPH5=30 if year==2025&HS10=="0803900000"
gen IMP_바나나_필리핀=0
foreach var of varlist IMP_필리핀 {
    replace IMP_바나나_필리핀=IMP_바나나_필리핀+`var' if `var'!=.
}
replace IMP_바나나_필리핀=IMP_바나나_필리핀/1000
bysort HS10 year (month): gen IMP_바나나_필리핀_누적 = sum(IMP_바나나_필리핀)
replace CUS_FPH1_1=CUS_FPH5 if IMP_바나나_필리핀_누적>325687&year==2025&HS10=="0803900000"



egen FIMP_그리스 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_네덜란드 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_노르웨이 = rowmin(CUS_FEF1_1 CUS_FEF1_2 CUS_FEF2_1 CUS_FEF2_2 CUS_FEF3_1 CUS_FEF3_2 CUS_FEF4_1 CUS_FEF4_2 CUS_FEFCH1_1 CUS_FEFCH1_2 CUS_FEFCH_1 CUS_FEFCH_2 CUS_FEFIS1_1 CUS_FEFIS1_2 CUS_FEFIS2_1 CUS_FEFIS2_2 CUS_FEFIS_1 CUS_FEFIS_2 CUS_FEFNO1_1 CUS_FEFNO1_2 CUS_FEFNO_1 CUS_FEFNO_2)
egen FIMP_뉴질랜드 = rowmin(CUS_FNZ10_1 CUS_FNZ10_2 CUS_FNZ11_1 CUS_FNZ11_2 CUS_FNZ12_1 CUS_FNZ12_2 CUS_FNZ1_1 CUS_FNZ1_2 CUS_FNZ2_1 CUS_FNZ2_2 CUS_FNZ3_1 CUS_FNZ3_2 CUS_FNZ4_1 CUS_FNZ4_2 CUS_FNZ5_1 CUS_FNZ5_2 CUS_FNZ6_1 CUS_FNZ6_2 CUS_FNZ7_1 CUS_FNZ7_2 CUS_FNZ8_1 CUS_FNZ8_2 CUS_FNZ9_1 CUS_FNZ9_2 CUS_FRCNZ1_1 CUS_FRCNZ1_2 CUS_FRCNZ2_1 CUS_FRCNZ2_2 CUS_FRCNZ3_1 CUS_FRCNZ3_2 CUS_FRCNZ4_1 CUS_FRCNZ4_2 CUS_FRCNZ5_1 CUS_FRCNZ5_2 CUS_FRCNZ6_1 CUS_FRCNZ6_2 CUS_FRCNZ7_1 CUS_FRCNZ7_2 CUS_FRCNZ8_1 CUS_FRCNZ8_2)
egen FIMP_니카라과 = rowmin(CUS_FCENI1_1 CUS_FCENI1_2 CUS_FCENI2_1 CUS_FCENI2_2 CUS_FCENI3_1 CUS_FCENI3_2 CUS_FCENI4_1 CUS_FCENI4_2 CUS_FCENI5_1 CUS_FCENI5_2 CUS_FCENI6_1 CUS_FCENI6_2 CUS_FCENI7_1 CUS_FCENI7_2)
egen FIMP_덴마크 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_독일 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_라오스 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_라트비아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_루마니아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_리투아니아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_말레이시아 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASMY_1 CUS_FASMY_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_모나코 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_몰타 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_미국 = rowmin(CUS_FUS10_1 CUS_FUS10_2 CUS_FUS11_1 CUS_FUS11_2 CUS_FUS12_1 CUS_FUS12_2 CUS_FUS1_1 CUS_FUS1_2 CUS_FUS2_1 CUS_FUS2_2 CUS_FUS3_1 CUS_FUS3_2 CUS_FUS4_1 CUS_FUS4_2 CUS_FUS5_1 CUS_FUS5_2 CUS_FUS6_1 CUS_FUS6_2 CUS_FUS8_1 CUS_FUS8_2 CUS_FUS9_1 CUS_FUS9_2)
egen FIMP_미얀마 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASMM_1 CUS_FASMM_2)
egen FIMP_베트남 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASVN1_1 CUS_FASVN1_2 CUS_FASVN2_1 CUS_FASVN2_2 CUS_FVN10_1 CUS_FVN10_2 CUS_FVN1_1 CUS_FVN1_2 CUS_FVN2_1 CUS_FVN2_2 CUS_FVN3_1 CUS_FVN3_2 CUS_FVN4_1 CUS_FVN4_2 CUS_FVN5_1 CUS_FVN5_2 CUS_FVN6_1 CUS_FVN6_2 CUS_FVN7_1 CUS_FVN7_2 CUS_FVN8_1 CUS_FVN8_2 CUS_FVN9_1 CUS_FVN9_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_벨기에 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_불가리아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_브루나이 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_스웨덴 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_스위스 = rowmin(CUS_FEF1_1 CUS_FEF1_2 CUS_FEF2_1 CUS_FEF2_2 CUS_FEF3_1 CUS_FEF3_2 CUS_FEF4_1 CUS_FEF4_2 CUS_FEFCH1_1 CUS_FEFCH1_2 CUS_FEFCH_1 CUS_FEFCH_2)
egen FIMP_스페인 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_슬로바키아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_슬로베니아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_싱가포르 = rowmin(CUS_FSG1_1 CUS_FSG1_2 CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_아이슬란드 = rowmin(CUS_FEF1_1 CUS_FEF1_2 CUS_FEF2_1 CUS_FEF2_2 CUS_FEF3_1 CUS_FEF3_2 CUS_FEF4_1 CUS_FEF4_2 CUS_FEFCH1_1 CUS_FEFCH1_2 CUS_FEFCH_1 CUS_FEFCH_2 CUS_FEFIS1_1 CUS_FEFIS1_2 CUS_FEFIS2_1 CUS_FEFIS2_2 CUS_FEFIS_1 CUS_FEFIS_2 CUS_FEFNO1_1 CUS_FEFNO1_2 CUS_FEFNO_1 CUS_FEFNO_2)
egen FIMP_아일랜드 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_에스토니아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_엘살바도르 = rowmin(CUS_FCESV1_1 CUS_FCESV1_2 CUS_FCESV2_1 CUS_FCESV2_2 CUS_FCESV3_1 CUS_FCESV3_2 CUS_FCESV4_1 CUS_FCESV4_2 CUS_FCESV5_1 CUS_FCESV5_2 CUS_FCESV6_1 CUS_FCESV6_2 CUS_FCESV7_1 CUS_FCESV7_2)
egen FIMP_영국 = rowmin(CUS_FGB1_1 CUS_FGB1_2 CUS_FGB2_1 CUS_FGB2_2 CUS_FGB3_1 CUS_FGB3_2 CUS_FGB4_1 CUS_FGB4_2 CUS_FGB5_1 CUS_FGB5_2 CUS_FGB6_1 CUS_FGB6_2 CUS_FGB7_1 CUS_FGB7_2 CUS_FGB8_1 CUS_FGB8_2 CUS_FGB9_1 CUS_FGB9_2)
egen FIMP_오스트리아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_온두라스 = rowmin(CUS_FCEHN1_1 CUS_FCEHN1_2 CUS_FCEHN2_1 CUS_FCEHN2_2 CUS_FCEHN3_1 CUS_FCEHN3_2 CUS_FCEHN4_1 CUS_FCEHN4_2 CUS_FCEHN5_1 CUS_FCEHN5_2 CUS_FCEHN6_1 CUS_FCEHN6_2 CUS_FCEHN7_1 CUS_FCEHN7_2)
egen FIMP_이스라엘 = rowmin(CUS_FIL1_1 CUS_FIL1_2 CUS_FIL2_1 CUS_FIL2_2 CUS_FIL3_1 CUS_FIL3_2 CUS_FIL4_1 CUS_FIL4_2 CUS_FIL5_1 CUS_FIL5_2 CUS_FIL7_1 CUS_FIL7_2)
egen FIMP_이탈리아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_인도네시아 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASID_1 CUS_FASID_2 CUS_FID1_1 CUS_FID1_2 CUS_FID2_1 CUS_FID2_2 CUS_FID3_1 CUS_FID3_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_인도인디아 = rowmin(CUS_FIN1_1 CUS_FIN1_2 CUS_FIN2_1 CUS_FIN2_2)
egen FIMP_일본 = rowmin(CUS_FRCJP1_1 CUS_FRCJP1_2 CUS_FRCJP2_1 CUS_FRCJP2_2 CUS_FRCJP3_1 CUS_FRCJP3_2 CUS_FRCJP4_1 CUS_FRCJP4_2 CUS_FRCJP5_1 CUS_FRCJP5_2 CUS_FRCJP6_1 CUS_FRCJP6_2 CUS_FRCJP9_1 CUS_FRCJP9_2)
egen FIMP_중국 = rowmin(CUS_FCN10_1 CUS_FCN10_2 CUS_FCN11_1 CUS_FCN11_2 CUS_FCN1_1 CUS_FCN1_2 CUS_FCN2_1 CUS_FCN2_2 CUS_FCN3_1 CUS_FCN3_2 CUS_FCN4_1 CUS_FCN4_2 CUS_FCN5_1 CUS_FCN5_2 CUS_FCN6_1 CUS_FCN6_2 CUS_FCN7_1 CUS_FCN7_2 CUS_FCN8_1 CUS_FCN8_2 CUS_FCN9_1 CUS_FCN9_2 CUS_FRCCN1_1 CUS_FRCCN1_2 CUS_FRCCN2_1 CUS_FRCCN2_2 CUS_FRCCN3_1 CUS_FRCCN3_2 CUS_FRCCN4_1 CUS_FRCCN4_2 CUS_FRCCN5_1 CUS_FRCCN5_2)
egen FIMP_체코 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_칠레 = rowmin(CUS_FCL1_1 CUS_FCL1_2 CUS_FCL2_1 CUS_FCL2_2 CUS_FCL5_1 CUS_FCL5_2)
egen FIMP_캄보디아 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FKH1_1 CUS_FKH1_2 CUS_FKH2_1 CUS_FKH2_2 CUS_FKH3_1 CUS_FKH3_2 CUS_FKH4_1 CUS_FKH4_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_캐나다 = rowmin(CUS_FCA10_1 CUS_FCA10_2 CUS_FCA11_1 CUS_FCA11_2 CUS_FCA12_1 CUS_FCA12_2 CUS_FCA1_1 CUS_FCA1_2 CUS_FCA2_1 CUS_FCA2_2 CUS_FCA3_1 CUS_FCA3_2 CUS_FCA4_1 CUS_FCA4_2 CUS_FCA5_1 CUS_FCA5_2 CUS_FCA6_1 CUS_FCA6_2 CUS_FCA7_1 CUS_FCA7_2 CUS_FCA8_1 CUS_FCA8_2 CUS_FCA9_1 CUS_FCA9_2)
egen FIMP_코스타리카 = rowmin(CUS_FCECR1_1 CUS_FCECR1_2 CUS_FCECR2_1 CUS_FCECR2_2 CUS_FCECR3_1 CUS_FCECR3_2 CUS_FCECR4_1 CUS_FCECR4_2 CUS_FCECR5_1 CUS_FCECR5_2 CUS_FCECR6_1 CUS_FCECR6_2)
egen FIMP_콜롬비아 = rowmin(CUS_FCO1_1 CUS_FCO1_2 CUS_FCO2_1 CUS_FCO2_2 CUS_FCO3_1 CUS_FCO3_2 CUS_FCO4_1 CUS_FCO4_2 CUS_FCO5_1 CUS_FCO5_2 CUS_FCO6_1 CUS_FCO6_2 CUS_FCO7_1 CUS_FCO7_2 CUS_FCO8_1 CUS_FCO8_2 CUS_FCO9_1 CUS_FCO9_2)
egen FIMP_크로아티아 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_태국 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASTH_1 CUS_FASTH_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_튀르키예 = rowmin(CUS_FTR1_1 CUS_FTR1_2 CUS_FTR2_1 CUS_FTR2_2 CUS_FTR3_1 CUS_FTR3_2 CUS_FTR4_1 CUS_FTR4_2 CUS_FTR5_1 CUS_FTR5_2 CUS_FTR6_1 CUS_FTR6_2 CUS_FTR7_1 CUS_FTR7_2 CUS_FTR8_1 CUS_FTR8_2 CUS_FTR9_1 CUS_FTR9_2)
egen FIMP_파나마 = rowmin(CUS_FCEPA1_1 CUS_FCEPA1_2 CUS_FCEPA2_1 CUS_FCEPA2_2 CUS_FCEPA3_1 CUS_FCEPA3_2 CUS_FCEPA4_1 CUS_FCEPA4_2 CUS_FCEPA5_1 CUS_FCEPA5_2 CUS_FCEPA6_1 CUS_FCEPA6_2 CUS_FCEPA7_1 CUS_FCEPA7_2 CUS_FCEPA8_1 CUS_FCEPA8_2)
egen FIMP_페루 = rowmin(CUS_FPE1_1 CUS_FPE1_2 CUS_FPE2_1 CUS_FPE2_2 CUS_FPE3_1 CUS_FPE3_2 CUS_FPE4_1 CUS_FPE4_2 CUS_FPE5_1 CUS_FPE5_2 CUS_FPE6_1 CUS_FPE6_2)
egen FIMP_폴란드 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_프랑스 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_포르투갈 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_핀란드 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_필리핀 = rowmin(CUS_FAS1_1 CUS_FAS1_2 CUS_FAS2_1 CUS_FAS2_2 CUS_FAS3_1 CUS_FAS3_2 CUS_FAS4_1 CUS_FAS4_2 CUS_FASPH1_1 CUS_FASPH1_2 CUS_FASPH2_1 CUS_FASPH2_2 CUS_FASPH3_1 CUS_FASPH3_2 CUS_FPH1_1 CUS_FPH1_2 CUS_FPH2_1 CUS_FPH2_2 CUS_FPH3_1 CUS_FPH3_2 CUS_FRCAS1_1 CUS_FRCAS1_2 CUS_FRCAS2_1 CUS_FRCAS2_2 CUS_FRCAS3_1 CUS_FRCAS3_2 CUS_FRCAS4_1 CUS_FRCAS4_2 CUS_FRCAS5_1 CUS_FRCAS5_2 CUS_FRCAS6_1 CUS_FRCAS6_2 CUS_FRCAS7_1 CUS_FRCAS7_2 CUS_FRCAS8_1 CUS_FRCAS8_2)
egen FIMP_헝가리 = rowmin(CUS_FEU10_1 CUS_FEU10_2 CUS_FEU1_1 CUS_FEU1_2 CUS_FEU2_1 CUS_FEU2_2 CUS_FEU3_1 CUS_FEU3_2 CUS_FEU4_1 CUS_FEU4_2 CUS_FEU5_1 CUS_FEU5_2 CUS_FEU6_1 CUS_FEU6_2 CUS_FEU7_1 CUS_FEU7_2 CUS_FEU8_1 CUS_FEU8_2 CUS_FEU9_1 CUS_FEU9_2)
egen FIMP_호주 = rowmin(CUS_FAU10_1 CUS_FAU10_2 CUS_FAU11_1 CUS_FAU11_2 CUS_FAU1_1 CUS_FAU1_2 CUS_FAU2_1 CUS_FAU2_2 CUS_FAU3_1 CUS_FAU3_2 CUS_FAU4_1 CUS_FAU4_2 CUS_FAU5_1 CUS_FAU5_2 CUS_FAU6_1 CUS_FAU6_2 CUS_FAU7_1 CUS_FAU7_2 CUS_FAU8_1 CUS_FAU8_2 CUS_FAU9_1 CUS_FAU9_2 CUS_FRCAU1_1 CUS_FRCAU1_2 CUS_FRCAU2_1 CUS_FRCAU2_2 CUS_FRCAU3_1 CUS_FRCAU3_2 CUS_FRCAU4_1 CUS_FRCAU4_2 CUS_FRCAU5_1 CUS_FRCAU5_2 CUS_FRCAU6_1 CUS_FRCAU6_2 CUS_FRCAU7_1 CUS_FRCAU7_2 CUS_FRCAU8_1 CUS_FRCAU8_2)
save sp1_temp, replace 



** Reflecting seasonal tariffs or quota tariffs (Phase2)
use sp1_temp, clear 
sort HS10
//pineapple
replace FIMP_영국=2.7 if HS10=="0804300000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0804300000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0804300000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0804300000"&time>=738
}
//onion
gen IMP_양파=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_양파=IMP_양파+`var' if `var'!=.
}
replace IMP_양파=IMP_양파/1000
bysort HS10 year (month): gen IMP_양파_누적 = sum(IMP_양파)
replace CUS_W1=CUS_W2 if IMP_양파_누적>20645&inlist(HS10,"0703101090","0703101000")
//garlic
gen IMP_마늘=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_마늘=IMP_마늘+`var' if `var'!=.
}
replace IMP_마늘=IMP_마늘/1000
bysort HS10 year (month): gen IMP_마늘_누적 = sum(IMP_마늘)
replace CUS_W1=CUS_W2 if IMP_마늘_누적>14467&inlist(HS10,"0703201000")
//peanuts
gen IMP_땅콩=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_우크라이나 IMP_인도인디아 IMP_필리핀 IMP_일본 IMP_칠레 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_스위스 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_아랍에미리트 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_에콰도르 IMP_탄자니아 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_르완다 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_땅콩=IMP_땅콩+`var' if `var'!=.
}
replace IMP_땅콩=IMP_땅콩/1000
bysort HS10 year (month): gen IMP_땅콩_누적 = sum(IMP_땅콩)
replace CUS_W1=CUS_W2 if IMP_땅콩_누적>4907.3&inlist(HS10,"2008119000")

replace FIMP_영국=5.8 if HS10=="2008119000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="2008119000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=5.8 if HS10=="2008119000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="2008119000"&time>=738
}
//soybeans
gen IMP_콩=0
foreach var of varlist IMP_브라질 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_콩=IMP_콩+`var' if `var'!=.
}
replace IMP_콩=IMP_콩/1000
bysort HS10 year (month): gen IMP_콩_누적 = sum(IMP_콩)
rename IMP_콩_누적 IMP_콩_누적_temp
egen IMP_콩_누적=rowtotal(IMP_콩_누적_temp IMP_콩_중국_누적 IMP_콩_호주_누적 IMP_콩_캐나다_누적)
replace CUS_W1=CUS_W2 if IMP_콩_누적>185787&inlist(HS10,"1201909000")&year==2021
replace CUS_W1=CUS_W2 if IMP_콩_누적>263749&inlist(HS10,"1201909000")&year==2022
replace CUS_W1=CUS_W2 if IMP_콩_누적>263749&inlist(HS10,"1201909000")&year==2023
replace CUS_W1=CUS_W2 if IMP_콩_누적>223987&inlist(HS10,"1201909000")&year==2024
replace CUS_W1=CUS_W2 if IMP_콩_누적>263749&inlist(HS10,"1201909000")&year==2025
//paprika (bell pepper)
gen IMP_파프리카=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_파프리카=IMP_파프리카+`var' if `var'!=.
}
replace IMP_파프리카=IMP_파프리카/1000
bysort HS10 year (month): gen IMP_파프리카_누적 = sum(IMP_파프리카)
replace CUS_W1=CUS_W2 if IMP_파프리카_누적>7185&inlist(HS10,"0709601000")
//red chili pepper, green chili pepper
gen IMP_고추류=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_고추류=IMP_고추류+`var' if `var'!=.
}
replace IMP_고추류=IMP_고추류/1000
bysort HS10 year (month): gen IMP_고추류_누적 = sum(IMP_고추류)
replace CUS_W1=CUS_W2 if IMP_고추류_누적>7185&inlist(HS10,"0709609000")
//dried red pepper
gen IMP_건고추=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_건고추=IMP_건고추+`var' if `var'!=.
}
replace IMP_건고추=IMP_건고추/1000
bysort HS10 year (month): gen IMP_건고추_누적 = sum(IMP_건고추)
replace CUS_W1=CUS_W2 if IMP_건고추_누적>7185&inlist(HS10,"0904210000")
//watermelon
replace FIMP_영국=10.3 if HS10=="0807110000"&inrange(time,732,737)
replace FIMP_영국=6.9 if HS10=="0807110000"&inrange(time,738,749)
replace FIMP_영국=3.4 if HS10=="0807110000"&inrange(time,750,761)
replace FIMP_영국=0 if HS10=="0807110000"&time>761

foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=10.3 if HS10=="0807110000"&inrange(time,732,737)
    replace FIMP_`name'=6.9 if HS10=="0807110000"&inrange(time,738,749)
    replace FIMP_`name'=3.4 if HS10=="0807110000"&inrange(time,750,761)
    replace FIMP_`name'=0 if HS10=="0807110000"&time>761
}
// Sweet potatoes are skipped because the import volume is negligible

//red beans (adzuki)
** For red beans, the WTO quota is set on mung beans and red beans combined; outside the WTO scheme the two are handled separately
//! WTO case (red beans + mung beans)
gen IMP_팥=0
foreach var of varlist IMP_중국 IMP_미국 IMP_캐나다 IMP_가나 IMP_가이아나 IMP_과들루프 IMP_과테말라 IMP_괌 IMP_그리스 IMP_기타국 IMP_나미비아 IMP_나이지리아 IMP_남수단공화국 IMP_남아프리카_공화국 IMP_네덜란드 IMP_네팔 IMP_노르웨이 IMP_뉴질랜드 IMP_뉴칼레도니아 IMP_니제르 IMP_니카라과 IMP_대만 IMP_덴마크 IMP_도미니카공화국 IMP_독일 IMP_동티모르 IMP_라오스 IMP_라트비아 IMP_러시아 IMP_레바논 IMP_레소토 IMP_루마니아 IMP_룩셈부르크 IMP_르완다 IMP_리투아니아 IMP_마다가스카르 IMP_마카오 IMP_마케도니아_공화국 IMP_말라위 IMP_말레이시아 IMP_말리 IMP_멕시코 IMP_모나코 IMP_모로코 IMP_모리셔스 IMP_모잠비크 IMP_몰도바 IMP_몰타 IMP_몽골 IMP_미국령_버진아일랜드 IMP_미얀마 IMP_바베이도스 IMP_방글라데시 IMP_베냉 IMP_베네수엘라 IMP_베트남 IMP_벨기에 IMP_벨라루스 IMP_벨리즈 IMP_볼리비아 IMP_부룬디 IMP_부르키나파소 IMP_북마리아나_제도 IMP_불가리아 IMP_브라질 IMP_사모아 IMP_사우디아라비아 IMP_산마리노 IMP_세르비아 IMP_수단 IMP_스리랑카 IMP_스웨덴 IMP_스위스 IMP_스페인 IMP_슬로바키아 IMP_슬로베니아 IMP_시리아 IMP_싱가포르 IMP_아랍에미리트 IMP_아르메니아 IMP_아르헨티나 IMP_아이슬란드 IMP_아이티 IMP_아일랜드 IMP_아제르바이잔 IMP_알바니아공화국 IMP_알제리 IMP_에스토니아 IMP_에콰도르 IMP_에티오피아 IMP_엘살바도르 IMP_영국 IMP_예멘 IMP_오스트리아 IMP_온두라스 IMP_요르단 IMP_우간다 IMP_우루과이 IMP_우즈베키스탄 IMP_우크라이나 IMP_이란 IMP_이스라엘 IMP_이집트 IMP_이탈리아 IMP_인도네시아 IMP_인도인디아 IMP_일본 IMP_자메이카 IMP_잠비아 IMP_조지아 IMP_짐바브웨 IMP_체코 IMP_칠레 IMP_카메룬 IMP_카자흐스탄 IMP_카타르 IMP_캄보디아 IMP_케냐 IMP_코모로 IMP_코스타리카 IMP_코트디부아르 IMP_콜롬비아 IMP_콩고 IMP_콩고민주공화국 IMP_쿠바 IMP_크로아티아 IMP_키르기스스탄 IMP_키프로스공화국 IMP_탄자니아 IMP_태국 IMP_토고 IMP_통가 IMP_튀니지 IMP_튀르키예 IMP_트리니다드_토바고 IMP_파나마 IMP_파라과이 IMP_파키스탄 IMP_파푸아뉴기니 IMP_팔레스타인 IMP_페루 IMP_포르투갈 IMP_폴란드 IMP_푸에르토리코 IMP_프랑스 IMP_프랑스령_폴리네시아 IMP_피지 IMP_핀란드 IMP_필리핀 IMP_헝가리 IMP_호주 IMP_홍콩 {
    replace IMP_팥=IMP_팥+`var' if `var'!=.
}
preserve
    keep if HS10=="0713319000"   //! mung beans
    keep year month HS10 IMP_팥
    rename IMP_팥 IMP_녹두
    replace HS10="0713329000"   //! red beans
    save IMP_녹두, replace
restore
merge 1:1 year month HS10 using IMP_녹두, nogen
egen IMP_팥_녹두=rowtotal(IMP_팥 IMP_녹두)
replace IMP_팥_녹두=IMP_팥_녹두/1000
bysort HS10 year (month): gen IMP_팥_녹두_누적 = sum(IMP_팥_녹두) 
replace CUS_W1=CUS_W2 if IMP_팥_녹두_누적>24044&inlist(HS10,"0713329000")&year==2021
replace CUS_W1=CUS_W2 if IMP_팥_녹두_누적>23894&inlist(HS10,"0713329000")&year==2022
replace CUS_W1=CUS_W2 if IMP_팥_녹두_누적>23194&inlist(HS10,"0713329000")&year==2023
replace CUS_W1=CUS_W2 if IMP_팥_녹두_누적>23147&inlist(HS10,"0713329000")&year==2024
replace CUS_W1=CUS_W2 if IMP_팥_녹두_누적>23099&inlist(HS10,"0713329000")&year==2025
preserve
    keep if HS10=="0713329000"   //! red beans
    keep year month HS10 IMP_팥_녹두_누적
    rename IMP_팥_녹두_누적 IMP_녹두_팥_누적
    replace HS10="0713319000"   //! mung beans
    save IMP_녹두_팥_누적, replace
restore
merge 1:1 year month HS10 using IMP_녹두_팥_누적, nogen
replace CUS_W1=CUS_W2 if IMP_녹두_팥_누적>24044&inlist(HS10,"0713319000")&year==2021
replace CUS_W1=CUS_W2 if IMP_녹두_팥_누적>23894&inlist(HS10,"0713319000")&year==2022
replace CUS_W1=CUS_W2 if IMP_녹두_팥_누적>23194&inlist(HS10,"0713319000")&year==2023
replace CUS_W1=CUS_W2 if IMP_녹두_팥_누적>23147&inlist(HS10,"0713319000")&year==2024
replace CUS_W1=CUS_W2 if IMP_녹두_팥_누적>23099&inlist(HS10,"0713319000")&year==2025


//! Non-WTO case (red beans)
replace FIMP_영국=157.8 if HS10=="0713329000"&inrange(time,732,737)
replace FIMP_영국=131.5 if HS10=="0713329000"&inrange(time,738,749)
replace FIMP_영국=105.2 if HS10=="0713329000"&inrange(time,750,761)
replace FIMP_영국=78.9 if HS10=="0713329000"&inrange(time,762,773)
replace FIMP_영국=52.6 if HS10=="0713329000"&time>773

foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=157.8 if HS10=="0713329000"&inrange(time,732,737)
    replace FIMP_`name'=131.5 if HS10=="0713329000"&inrange(time,738,749)
    replace FIMP_`name'=105.2 if HS10=="0713329000"&inrange(time,750,761)
    replace FIMP_`name'=78.9 if HS10=="0713329000"&inrange(time,762,773)
    replace FIMP_`name'=52.6 if HS10=="0713329000"&time>773
}


// Sesame
gen IMP_참깨=0
foreach var of varlist IMP_중국 IMP_미국 IMP_캐나다 IMP_가나 IMP_가이아나 IMP_과들루프 IMP_과테말라 IMP_괌 IMP_그리스 IMP_기타국 IMP_나미비아 IMP_나이지리아 IMP_남수단공화국 IMP_남아프리카_공화국 IMP_네덜란드 IMP_네팔 IMP_노르웨이 IMP_뉴질랜드 IMP_뉴칼레도니아 IMP_니제르 IMP_니카라과 IMP_대만 IMP_덴마크 IMP_도미니카공화국 IMP_독일 IMP_동티모르 IMP_라오스 IMP_라트비아 IMP_러시아 IMP_레바논 IMP_레소토 IMP_루마니아 IMP_룩셈부르크 IMP_르완다 IMP_리투아니아 IMP_마다가스카르 IMP_마카오 IMP_마케도니아_공화국 IMP_말라위 IMP_말레이시아 IMP_말리 IMP_멕시코 IMP_모나코 IMP_모로코 IMP_모리셔스 IMP_모잠비크 IMP_몰도바 IMP_몰타 IMP_몽골 IMP_미국령_버진아일랜드 IMP_미얀마 IMP_바베이도스 IMP_방글라데시 IMP_베냉 IMP_베네수엘라 IMP_베트남 IMP_벨기에 IMP_벨라루스 IMP_벨리즈 IMP_볼리비아 IMP_부룬디 IMP_부르키나파소 IMP_북마리아나_제도 IMP_불가리아 IMP_브라질 IMP_사모아 IMP_사우디아라비아 IMP_산마리노 IMP_세르비아 IMP_수단 IMP_스리랑카 IMP_스웨덴 IMP_스위스 IMP_스페인 IMP_슬로바키아 IMP_슬로베니아 IMP_시리아 IMP_싱가포르 IMP_아랍에미리트 IMP_아르메니아 IMP_아르헨티나 IMP_아이슬란드 IMP_아이티 IMP_아일랜드 IMP_아제르바이잔 IMP_알바니아공화국 IMP_알제리 IMP_에스토니아 IMP_에콰도르 IMP_에티오피아 IMP_엘살바도르 IMP_영국 IMP_예멘 IMP_오스트리아 IMP_온두라스 IMP_요르단 IMP_우간다 IMP_우루과이 IMP_우즈베키스탄 IMP_우크라이나 IMP_이란 IMP_이스라엘 IMP_이집트 IMP_이탈리아 IMP_인도네시아 IMP_인도인디아 IMP_일본 IMP_자메이카 IMP_잠비아 IMP_조지아 IMP_짐바브웨 IMP_체코 IMP_칠레 IMP_카메룬 IMP_카자흐스탄 IMP_카타르 IMP_캄보디아 IMP_케냐 IMP_코모로 IMP_코스타리카 IMP_코트디부아르 IMP_콜롬비아 IMP_콩고 IMP_콩고민주공화국 IMP_쿠바 IMP_크로아티아 IMP_키르기스스탄 IMP_키프로스공화국 IMP_탄자니아 IMP_태국 IMP_토고 IMP_통가 IMP_튀니지 IMP_튀르키예 IMP_트리니다드_토바고 IMP_파나마 IMP_파라과이 IMP_파키스탄 IMP_파푸아뉴기니 IMP_팔레스타인 IMP_페루 IMP_포르투갈 IMP_폴란드 IMP_푸에르토리코 IMP_프랑스 IMP_프랑스령_폴리네시아 IMP_피지 IMP_핀란드 IMP_필리핀 IMP_헝가리 IMP_호주 IMP_홍콩 {
    replace IMP_참깨=IMP_참깨+`var' if `var'!=.
}
replace IMP_참깨=IMP_참깨/1000
bysort HS10 year (month): gen IMP_참깨_누적 = sum(IMP_참깨) 
replace CUS_W1=CUS_W2 if IMP_참깨_누적>64000&inlist(HS10,"1207400000")&year==2021
replace CUS_W1=CUS_W2 if IMP_참깨_누적>67000&inlist(HS10,"1207400000")&year==2022
replace CUS_W1=CUS_W2 if IMP_참깨_누적>71000&inlist(HS10,"1207400000")&year==2023
replace CUS_W1=CUS_W2 if IMP_참깨_누적>70000&inlist(HS10,"1207400000")&year==2024
replace CUS_W1=CUS_W2 if IMP_참깨_누적>70000&inlist(HS10,"1207400000")&year==2025


//water dropwort (minari)
replace FIMP_영국=2.4 if HS10=="0709999000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709999000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.4 if HS10=="0709999000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709999000"&time>=738
}

//squash (Korean zucchini)
replace FIMP_뉴질랜드=0 if HS10=="0709930000"&inlist(month,1,2,3,4,5,12)
replace FIMP_뉴질랜드=27 if HS10=="0709930000"&inlist(month,6,7,8,9,10,11)

//oyster mushroom
replace FIMP_영국=2.7 if HS10=="0709594090"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709594090"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0709594090"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709594090"&time>=738
}

//king oyster mushroom (large oyster mushroom)
replace FIMP_영국=2.7 if HS10=="0709594010"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709594010"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0709594010"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709594010"&time>=738
}

//radish
replace FIMP_영국=2.7 if HS10=="0706901000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0706901000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0706901000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0706901000"&time>=738
}

//lettuce
replace FIMP_영국=4 if HS10=="0705190000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0705190000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=4 if HS10=="0705190000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0705190000"&time>=738
}

//mango
replace FIMP_영국=2.7 if HS10=="0804502000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0804502000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0804502000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0804502000"&time>=738
}

//kiwifruit
replace FIMP_영국=16.8 if HS10=="0810500000"&inrange(time,732,737)
replace FIMP_영국=14.0 if HS10=="0810500000"&inrange(time,738,749)
replace FIMP_영국=11.2 if HS10=="0810500000"&inrange(time,750,761)
replace FIMP_영국=8.4 if HS10=="0810500000"&inrange(time,762,773)
replace FIMP_영국=5.6 if HS10=="0810500000"&time>773

foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=16.8 if HS10=="0810500000"&inrange(time,732,737)
    replace FIMP_`name'=14 if HS10=="0810500000"&inrange(time,738,749)
    replace FIMP_`name'=11.2 if HS10=="0810500000"&inrange(time,750,761)
    replace FIMP_`name'=8.4 if HS10=="0810500000"&inrange(time,762,773)
    replace FIMP_`name'=5.6 if HS10=="0810500000"&time>773
}

replace FIMP_호주=45 if HS10=="0810500000"&inrange(time,732,735)
replace FIMP_호주=21 if HS10=="0810500000"&inrange(time,736,741)
replace FIMP_호주=45 if HS10=="0810500000"&inrange(time,742,743)
replace FIMP_호주=45 if HS10=="0810500000"&inrange(time,744,747)
replace FIMP_호주=18 if HS10=="0810500000"&inrange(time,748,753)
replace FIMP_호주=45 if HS10=="0810500000"&inrange(time,754,759)
replace FIMP_호주=15 if HS10=="0810500000"&inrange(time,760,765)
replace FIMP_호주=45 if HS10=="0810500000"&inrange(time,766,771)
replace FIMP_호주=12 if HS10=="0810500000"&inrange(time,772,777)
replace FIMP_호주=45 if HS10=="0810500000"&time>=778


//grape
*------------------------------------------------------------------------------
* United Kingdom (FIMP_영국)
*------------------------------------------------------------------------------
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2021,1),ym(2021,4))
replace FIMP_영국=20   if HS10=="0806100000"&inrange(time,ym(2021,5),ym(2021,6))
replace FIMP_영국=17.5 if HS10=="0806100000"&inrange(time,ym(2021,7),ym(2021,10))
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2021,11),ym(2021,12))

replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2022,1),ym(2022,4))
replace FIMP_영국=17.5 if HS10=="0806100000"&inrange(time,ym(2022,5),ym(2022,6))
replace FIMP_영국=15   if HS10=="0806100000"&inrange(time,ym(2022,7),ym(2022,10))
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2022,11),ym(2022,12))

replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2023,1),ym(2023,4))
replace FIMP_영국=15   if HS10=="0806100000"&inrange(time,ym(2023,5),ym(2023,6))
replace FIMP_영국=12.5 if HS10=="0806100000"&inrange(time,ym(2023,7),ym(2023,10))
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2023,11),ym(2023,12))

replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2024,1),ym(2024,4))
replace FIMP_영국=12.5 if HS10=="0806100000"&inrange(time,ym(2024,5),ym(2024,6))
replace FIMP_영국=10   if HS10=="0806100000"&inrange(time,ym(2024,7),ym(2024,10))
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2024,11),ym(2024,12))

replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2025,1),ym(2025,4))
replace FIMP_영국=10   if HS10=="0806100000"&inrange(time,ym(2025,5),ym(2025,6))
replace FIMP_영국=7.5  if HS10=="0806100000"&inrange(time,ym(2025,7),ym(2025,10))
replace FIMP_영국=0    if HS10=="0806100000"&inrange(time,ym(2025,11),ym(2025,12))


*------------------------------------------------------------------------------
* EU-26 countries (FIMP_`name')
*------------------------------------------------------------------------------
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2021,1),ym(2021,4))
    replace FIMP_`name'=20   if HS10=="0806100000"&inrange(time,ym(2021,5),ym(2021,6))
    replace FIMP_`name'=17.5 if HS10=="0806100000"&inrange(time,ym(2021,7),ym(2021,10))
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2021,11),ym(2021,12))

    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2022,1),ym(2022,4))
    replace FIMP_`name'=17.5 if HS10=="0806100000"&inrange(time,ym(2022,5),ym(2022,6))
    replace FIMP_`name'=15   if HS10=="0806100000"&inrange(time,ym(2022,7),ym(2022,10))
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2022,11),ym(2022,12))

    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2023,1),ym(2023,4))
    replace FIMP_`name'=15   if HS10=="0806100000"&inrange(time,ym(2023,5),ym(2023,6))
    replace FIMP_`name'=12.5 if HS10=="0806100000"&inrange(time,ym(2023,7),ym(2023,10))
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2023,11),ym(2023,12))

    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2024,1),ym(2024,4))
    replace FIMP_`name'=12.5 if HS10=="0806100000"&inrange(time,ym(2024,5),ym(2024,6))
    replace FIMP_`name'=10   if HS10=="0806100000"&inrange(time,ym(2024,7),ym(2024,10))
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2024,11),ym(2024,12))

    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2025,1),ym(2025,4))
    replace FIMP_`name'=10   if HS10=="0806100000"&inrange(time,ym(2025,5),ym(2025,6))
    replace FIMP_`name'=7.5  if HS10=="0806100000"&inrange(time,ym(2025,7),ym(2025,10))
    replace FIMP_`name'=0    if HS10=="0806100000"&inrange(time,ym(2025,11),ym(2025,12))
}


*------------------------------------------------------------------------------
* Australia (FIMP_호주)   * "every year": month-based rule applied to all years
*   - every year 5/1 ~ 11/30 : 45     (May-Nov)
*   - every year 12/1 ~ 4/30 : 0      (Dec, Jan-Apr)
*------------------------------------------------------------------------------
replace FIMP_호주=45 if HS10=="0806100000"&inrange(month(dofm(time)),5,11)
replace FIMP_호주=0  if HS10=="0806100000"&(inrange(month(dofm(time)),1,4)|month(dofm(time))==12)


*------------------------------------------------------------------------------
* United States (FIMP_미국)
*------------------------------------------------------------------------------
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2021,1),ym(2021,4))
replace FIMP_미국=18.5 if HS10=="0806100000"&inrange(time,ym(2021,5),ym(2021,10))
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2021,11),ym(2021,12))

replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2022,1),ym(2022,4))
replace FIMP_미국=15.8 if HS10=="0806100000"&inrange(time,ym(2022,5),ym(2022,10))
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2022,11),ym(2022,12))

replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2023,1),ym(2023,4))
replace FIMP_미국=13.2 if HS10=="0806100000"&inrange(time,ym(2023,5),ym(2023,10))
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2023,11),ym(2023,12))

replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2024,1),ym(2024,4))
replace FIMP_미국=10.5 if HS10=="0806100000"&inrange(time,ym(2024,5),ym(2024,10))
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2024,11),ym(2024,12))

replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2025,1),ym(2025,4))
replace FIMP_미국=7.9  if HS10=="0806100000"&inrange(time,ym(2025,5),ym(2025,10))
replace FIMP_미국=0    if HS10=="0806100000"&inrange(time,ym(2025,11),ym(2025,12))


*------------------------------------------------------------------------------
* Colombia (FIMP_콜롬비아)
*------------------------------------------------------------------------------
replace FIMP_콜롬비아=28.1 if HS10=="0806100000"&inrange(time,ym(2021,1),ym(2021,4))
replace FIMP_콜롬비아=45   if HS10=="0806100000"&inrange(time,ym(2021,5),ym(2021,10))
replace FIMP_콜롬비아=28.1 if HS10=="0806100000"&inrange(time,ym(2021,11),ym(2021,12))

replace FIMP_콜롬비아=25.3 if HS10=="0806100000"&inrange(time,ym(2022,1),ym(2022,4))
replace FIMP_콜롬비아=45   if HS10=="0806100000"&inrange(time,ym(2022,5),ym(2022,10))
replace FIMP_콜롬비아=25.3 if HS10=="0806100000"&inrange(time,ym(2022,11),ym(2022,12))

replace FIMP_콜롬비아=22.5 if HS10=="0806100000"&inrange(time,ym(2023,1),ym(2023,4))
replace FIMP_콜롬비아=45   if HS10=="0806100000"&inrange(time,ym(2023,5),ym(2023,10))
replace FIMP_콜롬비아=22.5 if HS10=="0806100000"&inrange(time,ym(2023,11),ym(2023,12))

replace FIMP_콜롬비아=19.6 if HS10=="0806100000"&inrange(time,ym(2024,1),ym(2024,4))
replace FIMP_콜롬비아=45   if HS10=="0806100000"&inrange(time,ym(2024,5),ym(2024,10))
replace FIMP_콜롬비아=19.6 if HS10=="0806100000"&inrange(time,ym(2024,11),ym(2024,12))

replace FIMP_콜롬비아=16.8 if HS10=="0806100000"&inrange(time,ym(2025,1),ym(2025,4))
replace FIMP_콜롬비아=45   if HS10=="0806100000"&inrange(time,ym(2025,5),ym(2025,10))
replace FIMP_콜롬비아=16.8 if HS10=="0806100000"&inrange(time,ym(2025,11),ym(2025,12))


*------------------------------------------------------------------------------
* Peru (FIMP_페루)   * no year given: month-based rule applied to all years
*   - every year 1/1 ~ 4/30  : 0      (Jan-Apr)
*   - every year 5/1 ~ 10/31 : 45     (May-Oct)
*   - every year 11/1 ~ 12/31: 0      (Nov-Dec)
*------------------------------------------------------------------------------
replace FIMP_페루=0  if HS10=="0806100000"&inrange(month(dofm(time)),1,4)
replace FIMP_페루=45 if HS10=="0806100000"&inrange(month(dofm(time)),5,10)
replace FIMP_페루=0  if HS10=="0806100000"&inrange(month(dofm(time)),11,12)

*------------------------------------------------------------------------------
* Chile (FIMP_칠레)
*------------------------------------------------------------------------------

replace FIMP_칠레=45 if HS10=="0806100000"
replace FIMP_칠레=0 if HS10=="0806100000" & inlist(month(dofm(time)),1,2,3,4,11,12)



// melon
*------------------------------------------------------------------------------
* United Kingdom (FIMP_영국)
*------------------------------------------------------------------------------
replace FIMP_영국=10.3 if HS10=="0807190000"&inrange(time,ym(2021,1),ym(2021,6))
replace FIMP_영국=6.9  if HS10=="0807190000"&inrange(time,ym(2021,7),ym(2021,12))

replace FIMP_영국=6.9  if HS10=="0807190000"&inrange(time,ym(2022,1),ym(2022,6))
replace FIMP_영국=3.4  if HS10=="0807190000"&inrange(time,ym(2022,7),ym(2022,12))

replace FIMP_영국=3.4  if HS10=="0807190000"&inrange(time,ym(2023,1),ym(2023,6))
replace FIMP_영국=0    if HS10=="0807190000"&inrange(time,ym(2023,7),ym(2023,12))

replace FIMP_영국=0    if HS10=="0807190000"&inrange(time,ym(2024,1),ym(2024,6))
replace FIMP_영국=0    if HS10=="0807190000"&inrange(time,ym(2024,7),ym(2024,12))

replace FIMP_영국=0    if HS10=="0807190000"&inrange(time,ym(2025,1),ym(2025,6))
replace FIMP_영국=0    if HS10=="0807190000"&inrange(time,ym(2025,7),ym(2025,12))


*------------------------------------------------------------------------------
* EU-26 countries (FIMP_`name')
*------------------------------------------------------------------------------
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=10.3 if HS10=="0807190000"&inrange(time,ym(2021,1),ym(2021,6))
    replace FIMP_`name'=6.9  if HS10=="0807190000"&inrange(time,ym(2021,7),ym(2021,12))

    replace FIMP_`name'=6.9  if HS10=="0807190000"&inrange(time,ym(2022,1),ym(2022,6))
    replace FIMP_`name'=3.4  if HS10=="0807190000"&inrange(time,ym(2022,7),ym(2022,12))

    replace FIMP_`name'=3.4  if HS10=="0807190000"&inrange(time,ym(2023,1),ym(2023,6))
    replace FIMP_`name'=0    if HS10=="0807190000"&inrange(time,ym(2023,7),ym(2023,12))

    replace FIMP_`name'=0    if HS10=="0807190000"&inrange(time,ym(2024,1),ym(2024,6))
    replace FIMP_`name'=0    if HS10=="0807190000"&inrange(time,ym(2024,7),ym(2024,12))

    replace FIMP_`name'=0    if HS10=="0807190000"&inrange(time,ym(2025,1),ym(2025,6))
    replace FIMP_`name'=0    if HS10=="0807190000"&inrange(time,ym(2025,7),ym(2025,12))
}

// Mung beans
*------------------------------------------------------------------------------
* United Kingdom (FIMP_영국)
*------------------------------------------------------------------------------
replace FIMP_영국=227.8 if HS10=="0713319000"&inrange(time,ym(2021,1),ym(2021,6))
replace FIMP_영국=189.8 if HS10=="0713319000"&inrange(time,ym(2021,7),ym(2021,12))

replace FIMP_영국=189.8 if HS10=="0713319000"&inrange(time,ym(2022,1),ym(2022,6))
replace FIMP_영국=151.8 if HS10=="0713319000"&inrange(time,ym(2022,7),ym(2022,12))

replace FIMP_영국=151.8 if HS10=="0713319000"&inrange(time,ym(2023,1),ym(2023,6))
replace FIMP_영국=113.9 if HS10=="0713319000"&inrange(time,ym(2023,7),ym(2023,12))

replace FIMP_영국=113.9 if HS10=="0713319000"&inrange(time,ym(2024,1),ym(2024,6))
replace FIMP_영국=75.9  if HS10=="0713319000"&inrange(time,ym(2024,7),ym(2024,12))

replace FIMP_영국=75.9  if HS10=="0713319000"&inrange(time,ym(2025,1),ym(2025,6))
replace FIMP_영국=37.9  if HS10=="0713319000"&inrange(time,ym(2025,7),ym(2025,12))


*------------------------------------------------------------------------------
* EU-26 countries (FIMP_`name')
*------------------------------------------------------------------------------
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=227.8 if HS10=="0713319000"&inrange(time,ym(2021,1),ym(2021,6))
    replace FIMP_`name'=189.8 if HS10=="0713319000"&inrange(time,ym(2021,7),ym(2021,12))

    replace FIMP_`name'=189.8 if HS10=="0713319000"&inrange(time,ym(2022,1),ym(2022,6))
    replace FIMP_`name'=151.8 if HS10=="0713319000"&inrange(time,ym(2022,7),ym(2022,12))

    replace FIMP_`name'=151.8 if HS10=="0713319000"&inrange(time,ym(2023,1),ym(2023,6))
    replace FIMP_`name'=113.9 if HS10=="0713319000"&inrange(time,ym(2023,7),ym(2023,12))

    replace FIMP_`name'=113.9 if HS10=="0713319000"&inrange(time,ym(2024,1),ym(2024,6))
    replace FIMP_`name'=75.9  if HS10=="0713319000"&inrange(time,ym(2024,7),ym(2024,12))

    replace FIMP_`name'=75.9  if HS10=="0713319000"&inrange(time,ym(2025,1),ym(2025,6))
    replace FIMP_`name'=37.9  if HS10=="0713319000"&inrange(time,ym(2025,7),ym(2025,12))
}

*------------------------------------------------------------------------------
* United States (FIMP_미국)
*------------------------------------------------------------------------------
gen IMP_녹두2=0
foreach var of varlist IMP_미국 {
    replace IMP_녹두2=IMP_녹두2 +`var' if `var'!=.
}
replace IMP_녹두2=IMP_녹두2/1000
bysort HS10 year (month): gen IMP_녹두2_누적 = sum(IMP_녹두2)
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_녹두2_누적>595&inlist(HS10,"0713319000")&year==2021
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_녹두2_누적>619&inlist(HS10,"0713319000")&year==2022
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_녹두2_누적>643&inlist(HS10,"0713319000")&year==2023
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_녹두2_누적>666&inlist(HS10,"0713319000")&year==2024
replace CUS_FUS1_1=CUS_FUS8_1 if IMP_녹두2_누적>690&inlist(HS10,"0713319000")&year==2025





// Sesame
*------------------------------------------------------------------------------
* United Kingdom (FIMP_영국)
*------------------------------------------------------------------------------
replace FIMP_영국=298   if HS10=="1207400000"&inrange(time,ym(2021,1),ym(2021,6))
replace FIMP_영국=265.2 if HS10=="1207400000"&inrange(time,ym(2021,7),ym(2021,12))

replace FIMP_영국=265.2 if HS10=="1207400000"&inrange(time,ym(2022,1),ym(2022,6))
replace FIMP_영국=232.1 if HS10=="1207400000"&inrange(time,ym(2022,7),ym(2022,12))

replace FIMP_영국=232.1 if HS10=="1207400000"&inrange(time,ym(2023,1),ym(2023,6))
replace FIMP_영국=198.9 if HS10=="1207400000"&inrange(time,ym(2023,7),ym(2023,12))

replace FIMP_영국=198.9 if HS10=="1207400000"&inrange(time,ym(2024,1),ym(2024,6))
replace FIMP_영국=165.7 if HS10=="1207400000"&inrange(time,ym(2024,7),ym(2024,12))

replace FIMP_영국=165.7 if HS10=="1207400000"&inrange(time,ym(2025,1),ym(2025,6))
replace FIMP_영국=132.6 if HS10=="1207400000"&inrange(time,ym(2025,7),ym(2025,12))


*------------------------------------------------------------------------------
* EU-26 countries (FIMP_`name')
*------------------------------------------------------------------------------
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=298   if HS10=="1207400000"&inrange(time,ym(2021,1),ym(2021,6))
    replace FIMP_`name'=265.2 if HS10=="1207400000"&inrange(time,ym(2021,7),ym(2021,12))

    replace FIMP_`name'=265.2 if HS10=="1207400000"&inrange(time,ym(2022,1),ym(2022,6))
    replace FIMP_`name'=232.1 if HS10=="1207400000"&inrange(time,ym(2022,7),ym(2022,12))

    replace FIMP_`name'=232.1 if HS10=="1207400000"&inrange(time,ym(2023,1),ym(2023,6))
    replace FIMP_`name'=198.9 if HS10=="1207400000"&inrange(time,ym(2023,7),ym(2023,12))

    replace FIMP_`name'=198.9 if HS10=="1207400000"&inrange(time,ym(2024,1),ym(2024,6))
    replace FIMP_`name'=165.7 if HS10=="1207400000"&inrange(time,ym(2024,7),ym(2024,12))

    replace FIMP_`name'=165.7 if HS10=="1207400000"&inrange(time,ym(2025,1),ym(2025,6))
    replace FIMP_`name'=132.6 if HS10=="1207400000"&inrange(time,ym(2025,7),ym(2025,12))
}


save sp1, replace 




use sp1, clear 
rename CUS_F CUS_temp
foreach var of varlist CUS_F*{
    drop `var'
}
rename CUS_temp CUS_F

egen CUP7=rowmin(CUS_A CUS_A1)
egen CUP5=rowmin(CUS_R) 
egen CUP42=rowmin(CUS_P1 CUS_P2 CUS_P3)
egen CUP41=rowmin(CUS_L)
egen CUP33C=rowmin(CUS_E1 CUS_E1A1 CUS_E1A2 CUS_E1A3 CUS_E1A4 CUS_E1A5 CUS_E1A6 CUS_E1B1 CUS_E1B2 CUS_E1B3 CUS_E1B4 CUS_E1A7 CUS_E1A8 CUS_E1A9 CUS_E1A10)
egen CUP33B=rowmin(CUS_E2 CUS_E2A1 CUS_E2A2 CUS_E2A3)
egen CUP33L=rowmin(CUS_E3 CUS_E3A1 CUS_E3A2 CUS_E3A3)
egen CUP32=rowmin(CUS_W1 CUS_W2)
egen CUP31=rowmin(CUS_C CUS_C1 CUS_C2 CUS_CIT CUS_CIT1 CUS_CIT2 CUS_CIT3 CUS_CIT4 CUS_CIT5 CUS_CIT6 CUS_D CUS_F CUS_G1 CUS_G2 CUS_C3 CUS_C4 CUS_C2A1 CUS_C2A2 CUS_C2A3 CUS_C2A4 CUS_C2A5 CUS_C2A6 CUS_C2A7 CUS_C2A8 CUS_C5 CUS_C6 CUS_C2A9)

gen ORD=CUP7   // start from 7
  // no 6
 // replace ORD=CUP5 if CUP5!=.; 5 has priority over 6 and 7; skip case 5
// Generate ORD42 from ORD; start at 42 and always skip 42 because 42 itself indicates TRQ application
// replace ORD42=CUP42 if CUP42!=.; when 42 is lower than 5 give 42 priority; it also has priority over 6 and 7
gen ORD41=ORD   //start from 41
replace ORD41=CUP41 if CUP41!=.   // 41 takes precedence over 5, 6, 7
egen ORD4=rowmin(ORD41)
gen ORD33=ORD4   // start from 33   // skip 5

// If 33 is lower than 4 or 5, apply 33 first; E1, E2, and E3 are applied differentially by country
gen ORD33G=ORD33
gen ORD33C=ORD33
gen ORD33B=ORD33
gen ORD33L=ORD33
replace ORD33C=CUP33C if (CUP33C<ORD33) & CUP33C!=.   
replace ORD33B=CUP33B if (CUP33B<ORD33) & CUP33B!=.   
replace ORD33L=CUP33L if (CUP33L<ORD33) & CUP33L!=.   

gen ORD32=CUP7   // start from 32
replace ORD32=CUP32 if CUP32!=.
egen ORD31=rowmin(ORD4 CUP7)   // start from 31  // skip 5
replace ORD31=CUP31 if (CUP31<ORD31) & CUP31!=.
//egen ORD3=rowmin(ORD31 ORD32)

foreach loc of newlist 그리스 네덜란드 노르웨이 뉴질랜드 니카라과 덴마크 독일 라트비아 루마니아 리투아니아 말레이시아 모나코 몰타 미국 미얀마 베트남 벨기에 불가리아 브루나이 스웨덴 스위스 스페인 슬로바키아 슬로베니아 싱가포르 아이슬란드 아일랜드 에스토니아 엘살바도르 영국 오스트리아 온두라스 이스라엘 이탈리아 인도인디아 일본 체코 칠레 캄보디아 캐나다 코스타리카 콜롬비아 크로아티아 태국 튀르키예 파나마 페루 포르투갈 폴란드 프랑스 핀란드 필리핀 헝가리 호주 {
    egen ORD2_`loc'=rowmin(FIMP_`loc' ORD31 ORD32 ORD33G)
} 
foreach loc of newlist 중국 인도네시아 {
    egen ORD2_`loc'=rowmin(FIMP_`loc' ORD32)   // ORD33C removed
} 
foreach loc of newlist 방글라데시 {
    egen ORD2_`loc'=rowmin(ORD31 ORD32 ORD33C ORD33B)
} 
foreach loc of newlist 라오스 {
    egen ORD2_`loc'=rowmin(FIMP_`loc' ORD31 ORD32 ORD33C ORD33L)
} 
foreach loc of newlist 스리랑카 {
    egen ORD2_`loc'=rowmin(ORD31 ORD32 ORD33C)
} 
foreach loc of newlist 미국령_버진아일랜드 가나 가이아나 과들루프 과테말라 괌 나미비아 나이지리아 남수단공화국 남아프리카_공화국 네팔 니제르 대만 도미니카공화국 레소토 레바논 르완다 마다가스카르 말라위 말리 모로코 모리셔스 모잠비크 몽골 마케도니아_공화국 마카오 멕시코 부르키나파소 부룬디 북마리아나_제도 베냉 베네수엘라 볼리비아 사모아 사우디아라비아 산마리노 세르비아 수단 시리아 아르메니아 아르헨티나 알바니아공화국 알제리 에콰도르 에티오피아 요르단 우간다 우루과이 우즈베키스탄 우크라이나 이란 이집트 자메이카 잠비아 조지아 중앙아프리카_공화국 짐바브웨 카메룬 카자흐스탄 카타르 케냐 코모로 코트디부아르 콩고 콩고민주공화국 쿠바 탄자니아 토고 통가 트리니다드_토바고 튀니지 팔레스타인 파푸아뉴기니 푸에르토리코 프랑스령_폴리네시아 기타국 {
    egen ORD2_`loc'=rowmin(ORD31 ORD32 ORD33G)
}

egen ORD2_비국가=rowmin(ORD31 ORD32 ORD33) 

egen CUP1=rowmin(CUS_T1 CUS_T2)
foreach loc of newlist 비국가 그리스 네덜란드 노르웨이 뉴질랜드 니카라과 덴마크 독일 라트비아 루마니아 리투아니아 말레이시아 모나코 몰타 미국 미얀마 베트남 벨기에 불가리아 브루나이 스웨덴 스위스 스페인 슬로바키아 슬로베니아 싱가포르 아이슬란드 아일랜드 에스토니아 엘살바도르 영국 오스트리아 온두라스 이스라엘 이탈리아 인도인디아 일본 체코 칠레 캄보디아 캐나다 코스타리카 콜롬비아 크로아티아 태국 튀르키예 파나마 페루 포르투갈 폴란드 프랑스 핀란드 필리핀 헝가리 호주 ///
중국 인도네시아 ///
방글라데시 ///
라오스 ///
스리랑카 ///
미국령_버진아일랜드 가나 가이아나 과들루프 과테말라 괌 멕시코 나미비아 나이지리아 남수단공화국 남아프리카_공화국 네팔 니제르 대만 도미니카공화국 레소토 레바논 르완다 마다가스카르 말라위 말리 모로코 모리셔스 모잠비크 몽골 마케도니아_공화국 마카오 부르키나파소 부룬디 북마리아나_제도 베냉 베네수엘라 볼리비아 사모아 사우디아라비아 산마리노 세르비아 수단 시리아 아르메니아 아르헨티나 알바니아공화국 알제리 에콰도르 에티오피아 요르단 우간다 우루과이 우즈베키스탄 우크라이나 이란 이집트 자메이카 잠비아 조지아 중앙아프리카_공화국 짐바브웨 카메룬 카자흐스탄 카타르 케냐 코모로 코트디부아르 콩고 콩고민주공화국 쿠바 탄자니아 토고 통가 트리니다드_토바고 튀니지 팔레스타인 파푸아뉴기니 푸에르토리코 프랑스령_폴리네시아 기타국 {
    gen ORD1_`loc'=ORD2_`loc' 
    replace ORD1_`loc'=CUP1 if CUP1!=.
}   

egen check=rowtotal(IMP_포르투갈 IMP_멕시코 IMP_그리스 IMP_네덜란드 IMP_노르웨이 IMP_뉴질랜드 IMP_니카라과 IMP_덴마크 IMP_독일 IMP_라트비아 IMP_루마니아 IMP_리투아니아 IMP_말레이시아 IMP_모나코 IMP_몰타 IMP_미국 IMP_미얀마 IMP_베트남 IMP_벨기에 IMP_불가리아 IMP_스웨덴 IMP_스위스 IMP_스페인 IMP_슬로바키아 IMP_슬로베니아 IMP_싱가포르 IMP_아이슬란드 IMP_아일랜드 IMP_에스토니아 IMP_엘살바도르 IMP_영국 IMP_오스트리아 IMP_온두라스 IMP_이스라엘 IMP_이탈리아 IMP_인도인디아 IMP_일본 IMP_체코 IMP_칠레 IMP_캄보디아 IMP_캐나다 IMP_코스타리카 IMP_콜롬비아 IMP_크로아티아 IMP_태국 IMP_튀르키예 IMP_파나마 IMP_페루 IMP_폴란드 IMP_프랑스 IMP_핀란드 IMP_필리핀 IMP_헝가리 IMP_호주 IMP_중국 IMP_인도네시아 IMP_방글라데시 IMP_라오스 IMP_스리랑카 IMP_미국령_버진아일랜드 IMP_가나 IMP_가이아나 IMP_과들루프 IMP_과테말라 IMP_괌 IMP_나미비아 IMP_나이지리아 IMP_남수단공화국 IMP_남아프리카_공화국 IMP_네팔 IMP_니제르 IMP_대만 IMP_도미니카공화국 IMP_레소토 IMP_레바논 IMP_르완다 IMP_마다가스카르 IMP_말라위 IMP_말리 IMP_모로코 IMP_모리셔스 IMP_모잠비크 IMP_몽골 IMP_마케도니아_공화국 IMP_마카오 IMP_부르키나파소 IMP_부룬디 IMP_북마리아나_제도 IMP_베냉 IMP_베네수엘라 IMP_볼리비아 IMP_사모아 IMP_사우디아라비아 IMP_산마리노 IMP_세르비아 IMP_수단 IMP_시리아 IMP_아르메니아 IMP_아르헨티나 IMP_알바니아공화국 IMP_알제리 IMP_에콰도르 IMP_에티오피아 IMP_요르단 IMP_우간다 IMP_우루과이 IMP_우즈베키스탄 IMP_우크라이나 IMP_이란 IMP_이집트 IMP_자메이카 IMP_잠비아 IMP_조지아 IMP_짐바브웨 IMP_카메룬 IMP_카자흐스탄 IMP_카타르 IMP_케냐 IMP_코모로 IMP_코트디부아르 IMP_콩고 IMP_콩고민주공화국 IMP_쿠바 IMP_탄자니아 IMP_토고 IMP_통가 IMP_트리니다드_토바고 IMP_튀니지 IMP_팔레스타인 IMP_파푸아뉴기니 IMP_푸에르토리코 IMP_프랑스령_폴리네시아 IMP_기타국)
gen IMP_비국가=1 if check==.|check==0


foreach var of varlist CUS_* FIMP_* ORD2_* CUP7 CUP5 CUP42 CUP41 CUP32 CUP31 ORD ORD41 ORD4 ORD33 ORD32 ORD31 CUP1 CUP33C CUP33B CUP33L {
    drop `var'
}
order idn time HS10 품명한글
save sp2, replace 


use sp2, clear 

preserve
    keep idn time HS10 품명한글 IMP_*
    save sp2_init, replace 
restore
preserve
    keep idn time IMP_*
    save sp2_IMP, replace 
restore
preserve
    keep idn time ORD1_*
    save sp2_ORD1, replace 
restore

use sp2_init, clear 
keep idn time IMP_*
reshape long IMP_ , i(idn time) j(loc) string
save long_init, replace

use sp2_IMP, clear 
reshape long IMP_ , i(idn time) j(loc) string
save long_IMP, replace 

use sp2_ORD1, clear 
reshape long ORD1_ , i(idn time) j(loc) string
save long_ORD1, replace 

use long_init, clear 
merge 1:1 idn time loc using long_IMP, nogenerate
merge 1:1 idn time loc using long_ORD1, nogenerate
replace IMP_=0 if IMP_==.
preserve 
    drop if ORD1_ ==.
    save long_init_importprice, replace
restore  
collapse (mean) ORD1_ [pweight=IMP_], by(idn time)
rename ORD1_ BaseTax
save BaseTax, replace 

use sp0, clear 
set more off, perm
merge 1:1 idn using BaseTax
order idn time _merge
sort _merge
destring IMP_*, replace
keep time HS10 품명한글 BaseTax IMP_*
gen year = year(dofm(time))
gen HS2024=HS10
preserve 
    keep if HS10=="0709999000"&year==2021
    replace HS2024="0709993000"
    replace 품명한글="깻잎"
    save 깻잎2021, replace 
restore 
append using 깻잎2021
replace 품명한글="미나리" if 품명한글=="기타"&HS10=="0709999000"
preserve
    keep if HS10=="0702000000"&year==2021
    replace HS2024="0702001000"
    replace 품명한글="방울토마토"
    save 방울토마토2021, replace 
restore 
preserve
    keep if HS10=="0702000000"&year==2021
    replace HS2024="0702009000"
    replace 품명한글="토마토"
    save 토마토2021, replace 
restore 
drop if HS10=="0702000000"&year==2021
append using 방울토마토2021
append using 토마토2021
replace HS2024="0807199000" if year==2021&HS10=="0807190000"   // melon
replace HS2024="0703101090" if year==2021&HS10=="0703101000"   // onion
replace HS2024="0703902000" if year==2021&HS10=="0703909000"   // green onion
replace HS2024="0703903000" if year==2021&HS10=="0703102000"   // small green onion
sort HS2024 time 
order year time HS2024 HS10 품명한글 BaseTax IMP_미국 IMP_중국 IMP_뉴질랜드 IMP_베트남 IMP_칠레 IMP_에콰도르 IMP_페루 IMP_과테말라 IMP_호주 IMP_나이지리아 IMP_러시아 IMP_멕시코 IMP_대만 IMP_캐나다 IMP_일본 IMP_브라질 IMP_그리스 IMP_남아프리카_공화국 IMP_니제르 IMP_통가 IMP_스페인 IMP_말리 IMP_미얀마 IMP_인도네시아 IMP_뉴칼레도니아 IMP_우즈베키스탄 IMP_모잠비크 IMP_부르키나파소 IMP_아르헨티나 IMP_태국 IMP_캄보디아 IMP_이탈리아 IMP_필리핀 IMP_콜롬비아 IMP_네덜란드 IMP_벨기에 IMP_니카라과 IMP_에티오피아 IMP_인도 IMP_기타국 IMP_말레이시아 IMP_라오스 IMP_스리랑카 IMP_볼리비아 IMP_말라위 IMP_독일 IMP_튀르키예 IMP_네팔 IMP_프랑스 IMP_우간다 IMP_폴란드 IMP_르완다 IMP_싱가포르 IMP_스웨덴 IMP_가나 IMP_라트비아 IMP_홍콩 IMP_리투아니아 IMP_아랍에미리트 IMP_영국 IMP_괌 IMP_사우디아라비아 IMP_베냉 IMP_탄자니아 IMP_스위스 IMP_마다가스카르 IMP_몽골 IMP_부룬디 IMP_알제리 IMP_베네수엘라 IMP_모로코 IMP_방글라데시 IMP_이집트 IMP_우크라이나 IMP_수단 IMP_노르웨이 IMP_아일랜드 IMP_벨리즈 IMP_레소토 IMP_알바니아공화국 IMP_룩셈부르크 IMP_카메룬 IMP_키프로스공화국 IMP_벨라루스 IMP_코스타리카 IMP_온두라스 IMP_아제르바이잔 IMP_나미비아 IMP_산마리노 IMP_카타르 IMP_토고 IMP_헝가리 IMP_키르기스스탄 IMP_루마니아 IMP_아르메니아 IMP_마카오 IMP_아이티 IMP_가이아나 IMP_미국령_버진아일랜드 IMP_모나코 IMP_과들루프 IMP_남수단공화국 IMP_코모로 IMP_바베이도스 IMP_북마리아나_제도 IMP_세르비아 IMP_몰타 IMP_우루과이 IMP_레바논 IMP_트리니다드_토바고 IMP_사모아 IMP_시리아 IMP_프랑스령_폴리네시아 IMP_핀란드 IMP_짐바브웨 IMP_잠비아 IMP_튀니지 IMP_쿠바 IMP_아이슬란드 IMP_이란 IMP_슬로바키아 IMP_체코 IMP_슬로베니아 IMP_파키스탄 IMP_피지 IMP_도미니카공화국 IMP_에스토니아 IMP_크로아티아 IMP_몰도바 IMP_파나마 IMP_마케도니아_공화국 IMP_엘살바도르 IMP_예멘 IMP_파푸아뉴기니 IMP_덴마크 IMP_오스트리아 IMP_불가리아 IMP_콩고 IMP_동티모르 IMP_코트디부아르 IMP_파라과이 IMP_포르투갈 IMP_이스라엘 IMP_팔레스타인 IMP_자메이카 IMP_조지아 IMP_요르단 IMP_모리셔스 IMP_카자흐스탄 IMP_콩고민주공화국 IMP_푸에르토리코 IMP_케냐
egen total_import = rowtotal(IMP_*)
preserve 
    keep year time HS2024 total_import
    gen month = month(time)
    save total_import, replace 
restore
drop total_import
save BaseTaxFin, replace  


//! manual check of BaseTaxFin.dta
/*
use 품목명_전체길이_2025, clear
rename HSK HS2024
merge 1:m HS2024 using BaseTaxFin, keep(match using) nogen
order HS2024 품목명전체 year time BaseTax
preserve
    keep HS2024 품목명전체
    duplicates drop
    save BaseTaxFin_품목명전체, replace
restore
save BaseTaxFin_manualcheck, replace

use BaseTaxFin_품목명전체, clear

use "D:\JJ Dropbox\KCTDI_Research\할당관세 정책이 소비자 물가에 미치는 영향\GItPublish_3rd_submit\BaseTaxFin_품목명전체", clear 

use BaseTaxFin_manualcheck, clear
encode 품목명전체, gen(qcode)
xtset qcode time, monthly
keep HS2024 time BaseTax IMP*
order HS2024 time BaseTax IMP*
keep if HS2024=="0807199000"
twoway (tsline BaseTax)
*/

// #er 


// #sr NongNet price and sales quantity data

cd "${path}"

import delimited "${path}\소비트렌드.txt", delimiter(tab) varnames(1) encoding(UTF-8) clear 
save q1, replace 
import delimited "${path}\도매가격(전국도매시장).txt", delimiter(tab) varnames(1) encoding(UTF-8) clear 
save d1, replace 
import delimited "${path}\소매가격(KAMIS 조사가격).txt", delimiter(tab) varnames(1) encoding(UTF-8) clear 
save s1, replace 
import excel "${path}\스크래핑 대상 품목_농넷최종선정.xlsx", sheet("데이터 병합") firstrow allstring clear
keep s_item d_item q_item HS120222024
rename HS120222024 HS2024
drop if d_item=="0"
save possible, replace



import excel "${path}\농산물_소비자물가지수.xlsx", sheet("데이터") firstrow clear
gen year=substr(yearmonth,1,4)
gen month=substr(yearmonth,6,2)
destring year, replace 
destring month, replace 
gen monthly_date = ym(year, month)
format monthly_date %tm
keep year month monthly_date 농산물물가
rename 농산물물가 cpi
gen cpi_orig=cpi
sort monthly_date
scalar cpi_init=cpi[1]
replace cpi=cpi/cpi_init
tsset monthly_date
twoway(tsline cpi, lcolor(gs0) lwidth(thick))(tsline cpi_orig, lcolor(red) lpattern(dash) yaxis(2))
drop cpi_orig
save 농산물_소비자물가지수, replace 


clear all
// Step 1: generate date data
local start_date = mdy(1, 1, 2019)
local end_date = mdy(3, 31, 2025)
local total_days = `end_date' - `start_date' + 1
set obs `total_days'
gen double date = `start_date' + _n - 1
format date %tdCCYY-NN-DD
gen fulldate = 1
save fulldate, replace
// Step 2: load possible.dta and create panel data
use possible, clear
// Check the actual number of items
local n_items = _N
display "실제 품목 수: `n_items'"
// Create all item-by-date combinations via cross join
cross using fulldate
// Sort data by item and date
sort s_item date
// Drop unnecessary variables
drop fulldate
// Check the panel data structure
describe
display "총 관측치 수: " _N
display "예상 관측치 수: `n_items' × `total_days' = " `n_items' * `total_days'
// Save the results
save fullpanel, replace





//! ============================================
//! Sales quantity
use q1, clear 
gen Y = floor(연도주차/100)   
gen W = mod(연도주차,100)     
gen time = yw(Y,W)
order 연도주차 time
format time %tw
drop 연도주차 Y W 연월 
save q2, replace 

use q2, clear 
rename (매출액만원 평균가격원100g 추정판매량개100g )(sales price quant)   
/*
Accurate units should be checked on the NongNet website. Information such as "won per 100g" or "pieces per 100g" is incorrect; use unit_qy and unit_code_nm (same as on NongNet).
Exact units must be checked on the NongNet website; the 원100g / 개100g fields are unreliable. Use 단위량(unit_qy) and 단위명(unit_code_nm), as on NongNet.
sales: sales amount (10,000 KRW)
sales: revenue (10,000 KRW)
price: x KRW per quantity unit
price: KRW per unit
quant: x in quantity units
quant: quantity in units
*/
drop 단위량unit_qy 단위명unit_code_nm
save q3, replace 

use q3, clear
rename 품목 item
collapse (mean) quant price, by(item time)
encode item, gen(item2)
xtset item2 time, weekly
format time %tw
gen date = dofw(time)
format date %tdCCYY-NN-DD
keep item item2 time date quant price
order item date
export delimited using "${path}/q_all_weekly.csv", replace


//* Work done in R (R_quant)


import delimited using "${path}/q_all_weekly_STL_result.csv", clear varnames(1) encoding(CP949)

* Restore time variable from date
gen double daily_date = date(date,"YMD")
format daily_date %tdCCYY-NN-DD
gen int time = wofd(daily_date)
format time %tw

* If imported as string, convert to numeric (add q_price variables)
capture confirm numeric variable quant_sa_add
if _rc destring quant_sa_add quant_sa_mul price_sa_add price_sa_mul, replace ignore("NA")

* Convert q_price to numeric as well (if necessary)
capture confirm numeric variable price
if _rc destring price, replace ignore("NA")

keep item time quant_sa_add quant_sa_mul price price_sa_add price_sa_mul daily_date
tempfile adj
save "`adj'", replace

use q3, clear
rename 품목 item

* Before merging, resolve duplicates (take the mean when there are multiple rows per item-time)
duplicates report item time
bys item time: egen quant_mean = mean(quant)
bys item time: egen price_mean = mean(price)  
bys item time: keep if _n==1
replace quant = quant_mean
replace price = price_mean
drop quant_mean price_mean

merge 1:1 item time using "`adj'", keepusing(quant_sa_add quant_sa_mul price_sa_add price_sa_mul daily_date)
keep if _merge==3
drop _merge
drop quant_sa_add price_sa_add
rename price price2
rename (item 품목코드 quant_sa_mul quant price_sa_mul price2) ///
       (q_item q_code quant quant_orig price price_orig)
encode q_item, gen(q_item2)
xtset q_item2 time, weekly
save q4, replace

use q4, clear 
collapse (mean) q_code, by(q_item)
save q_item, replace
export excel using "q_item.xlsx", firstrow(variables) replace

use q4, clear
merge m:1 q_item using possible
keep if _merge==3
drop _merge
rename daily_date date   
merge 1:1 q_item date using fullpanel, nogen
drop q_item2
encode q_item, gen(q_item2)
xtset q_item2 date, daily
//tsfill, full
sort q_item2 date
by q_item2: ipolate price date, gen(price2) 
tsfilter hp price_hp = price2, trend(smooth_price) smooth(600)   // 600 works well here
by q_item2: ipolate quant date, gen(quant2) 
tsfilter hp quant_hp = quant2, trend(smooth_quant) smooth(600)   // 600 works well here
drop price quant
rename (price2 quant2)(price quant)
save q5, replace 
// #er 


// #sr Retail prices
use s1, clear
tostring 일자, replace 
gen double date = mdy(real(substr(일자,5,2)), real(substr(일자,7,2)), real(substr(일자,1,4)))
format date %tdCCYY-NN-DD
gen some = 품목 + "_" + 품종
* Normalize units (kg -> g) and compute price per gram
replace 단위량 = 단위량/1000 if 거래단위=="g"
replace 거래단위 = "kg"       if 거래단위=="g"
*** Convert to kg when the transaction unit is one piece ***   // surveyed from direct purchases in the market
replace 평균가격=평균가격/140*1000 if some=="레몬_레몬(전체)"
replace 평균가격=평균가격/362.5*1000 if some=="망고_망고(전체)"
replace 평균가격=평균가격/1650*1000 if some=="무_무(전체)"
replace 평균가격=평균가격/600*1000 if some=="배_신고"
replace 평균가격=평균가격/1800*1000 if some=="배추_배추(전체)"   // one head
replace 평균가격=평균가격/285.65*1000 if some=="브로콜리_브로콜리(전체)"
replace 평균가격=평균가격/294.118*1000 if some=="사과_후지"
replace 평균가격=평균가격/5250*1000 if some=="수박_수박(전체)"
replace 평균가격=평균가격/221.428*1000 if some=="아보카도_아보카도(전체)"
replace 평균가격=평균가격/1750*1000 if some=="양배추_양배추(전체)"   // one head
replace 평균가격=평균가격/235*1000 if some=="오이_다다기계통" 
replace 평균가격=평균가격/171.429*1000 if some=="참다래_참다래(전체)"
replace 평균가격=평균가격/1350*1000 if some=="파인애플_파인애플(전체)"
replace 평균가격=평균가격/307*1000 if some=="호박_애호박"
replace 평균가격=평균가격/1800*1000 if some=="멜론_멜론(전체)"
replace 평균가격=평균가격*2 if some=="콩나물_콩나물(전체)"   // one bag
replace 평균가격 = 평균가격/단위량
drop 단위량   // price now unified to KRW per 1kg
gen int year  = year(date)
gen int month = month(date)
merge m:1 year month using 농산물_소비자물가지수
replace 평균가격=평균가격/cpi
drop cpi
save s1_temp, replace 


use s1_temp, clear 
rename some s_item
keep s_item 거래단위
duplicates drop
duplicates tag s_item, gen(tag)
gsort -tag s_item 
drop tag 
save s1_temp2, replace 

use s1_temp, clear 
* Daily average price by (item code × some × date)
collapse (mean) 평균가격, by(품목코드 some date)
rename 평균가격 y
encode some, gen(some2)
order 품목코드 some date y
save s_daily, replace
export delimited using "${path}/q_all_daily.csv", replace


//* Work done in R (R_some)


import delimited using "${path}/q_all_daily_STL_result.csv", ///
    clear varnames(1) encoding(CP949)
capture confirm numeric variable y_sa_add
if _rc destring y y_sa_add y_sa_mul, replace ignore("NA")
gen double date_num = date(date,"YMD")
format date_num %tdCCYY-NN-DD
drop date
rename date_num date
keep 품목코드 some date y y_sa_add y_sa_mul
tempfile adj
save "`adj'", replace

use s_daily, clear   // (품목코드 some date y some2)
merge 1:1 some date using "`adj'", keepusing(y_sa_add y_sa_mul) nogen
drop y_sa_add
rename (some some2 품목코드 y_sa_mul y) ///
       (s_item s_item2 s_code s_price s_price_orig)
xtset s_item2 date, daily
merge m:1 s_item using s1_temp2, nogen
save s2, replace


use s2, clear 
keep s_item date s_price s_item2 s_price_orig
merge m:1 s_item using possible
keep if _merge==3
drop _merge 
merge 1:1 s_item date using fullpanel
drop _merge
drop s_item2
encode s_item, gen(s_item2)
xtset s_item2 date, daily 
//tsfill, full
sort s_item2 date
by s_item2: ipolate s_price date, gen(s_price2) 
by s_item2: ipolate s_price_orig date, gen(s_price_orig2)
drop if s_item==""
tsfilter hp s_price_hp = s_price2, trend(smooth_s_price2) smooth(600)   // 600 works well here
save s_mergeready, replace 


use s2, clear 
keep s_item 거래단위 
duplicates drop  
merge 1:1 s_item using possible
keep if _merge==3
drop _merge 
save g개, replace 
export excel using "${path}\g개.xlsx", firstrow(variables) replace


use s2, clear 
collapse (mean) s_code, by(s_item)
save s3, replace 
export excel using "s_item.xlsx", firstrow(variables) replace

// #er 


// #sr Wholesale prices
use d1, clear
tostring 일자, replace
gen double date = mdy(real(substr(일자,5,2)), real(substr(일자,7,2)), real(substr(일자,1,4)))
format date %tdCCYY-NN-DD
gen dome = 품목명 + "_" + 품종명
rename 평균가격kg원 y
gen int year  = year(date)
gen int month = month(date)
merge m:1 year month using 농산물_소비자물가지수
drop _merge 
replace y=y/cpi
drop cpi
gen d_item=dome
merge m:1 d_item using possible
keep if _merge==3
drop _merge 
* Make (item code × dome × date) unique
collapse (mean) y, by(품목코드 dome date)
encode dome, gen(dome2)
order 품목코드 dome date y
save d_daily, replace
export delimited using "${path}/q_all_daily_wholesale.csv", replace


//* Work done in R (R_dome)


import delimited using "${path}/q_all_daily_wholesale_STL_result.csv", ///
    clear varnames(1) encoding(CP949)
* Convert strings to numeric (if necessary)
capture confirm numeric variable y_sa_add
if _rc destring y y_sa_add y_sa_mul, replace ignore("NA")
* Convert date string to a Stata daily date
gen double date_num = date(date,"YMD")
format date_num %tdCCYY-NN-DD
drop date
rename date_num date
* Keep observations including the item code
keep 품목코드 dome date y y_sa_add y_sa_mul
order 품목코드 dome date
* Check uniqueness (adj)
duplicates report 품목코드 dome date
tempfile adj
save "`adj'", replace

* --- Merge with master dataset ---
use d_daily, clear   // (품목코드 dome date y dome2)
order 품목코드 dome date
* Check uniqueness (master)
duplicates report 품목코드 dome date
* Merge (key: item code, dome, date)
merge 1:1 품목코드 dome date using "`adj'", nogen
drop dome2 y_sa_add
rename (dome 품목코드 y_sa_mul y) ///
       (d_item d_code d_price d_price_orig)
save d2, replace

use d2, clear 
collapse (sum) d_price, by(d_code d_item)
drop if d_price==0
rename d_price exist
replace exist=1
save exist, replace 

use d2, clear 
merge m:1 d_code d_item using exist
keep if _merge==3
drop exist _merge
egen pcode = group(d_code d_item)
xtset pcode date, daily
gen spike=(d_price-L.d_price)/L.d_price
replace d_price=. if spike>2
save d3, replace



use d3, clear 
keep d_item date d_price pcode d_price_orig
merge m:1 d_item using possible
keep if _merge==3
drop _merge 
merge 1:1 d_item date using fullpanel
drop _merge
drop pcode
encode d_item, gen(pcode)
xtset pcode date, daily 
sort pcode date
by pcode: ipolate d_price date, gen(d_price2) 
by pcode: ipolate d_price_orig date, gen(d_price_orig2) 
tsfilter hp d_price_hp = d_price2, trend(smooth_d_price2) smooth(600)   // 600 works well here
drop if d_item==""
save d_mergeready, replace 

use d3, clear 
collapse (mean) d_code, by(d_item)
save d_item, replace
export excel using "d_item.xlsx", firstrow(variables) replace
// #er 


// #sr Integration (combine datasets)
import excel "원달러 환율.xlsx", sheet("Sheet0") firstrow clear 
tostring date, replace 
gen year=substr(date,1,4)
gen month=substr(date,5,6)
foreach name of varlist year month {
    destring `name', replace 
}
save 원달러환율, replace 


use BaseTaxFin, clear 
keep if inlist(HS2024,"0806100000","0713319000","1207400000","0807199000")   //! add grapes, mung beans, sesame, melon; soybean sprouts handled separately
//! Soybean sprouts share the exact same HS code as water dropwort, so the BaseTaxFin and KATI-scraped info is reused for them as-is.
gen q_item="포도" if HS2024=="0806100000"
replace q_item="녹두" if HS2024=="0713319000"
replace q_item="참깨" if HS2024=="1207400000"
replace q_item="멜론" if HS2024=="0807199000"
keep year HS10 q_item
duplicates drop
sort q_item year
export excel using "HSCODEq_item_add4.xlsx", firstrow(variables) replace

/*
** How kati_price_finished_add4items.xlsx is generated
Using HSCODEq_item_add4.xlsx as input, kati_scraper_price_add4items.py scrapes the import data provided by KATI to produce kati_price_finished_add4items.xlsx.
*/
import excel "kati_price_finished_add4items.xlsx", sheet("Sheet1") firstrow allstring clear
save kati_price_finished_add4items, replace

/*
** How kati_price_finished_40items.xlsx is generated
Using HSCODEq_item.xlsx as input, kati_scraper_price_40items.py scrapes the import data provided by KATI to produce kati_price_finished_40items.xlsx.
*/
import excel "kati_price_finished_40items.xlsx", sheet("Sheet1") firstrow allstring clear
append using kati_price_finished_add4items
drop if inlist(q_item,"체리","느타리버섯","새송이버섯")  
preserve
    //! Soybean sprouts: same HS code as water dropwort, so the KATI-scraped info is duplicated for them.
    keep if q_item=="미나리"
    replace q_item="콩나물"
    save kati_price_finished_콩나물, replace
restore
append using kati_price_finished_콩나물
set more off
foreach name of varlist year month 중량 금액 {
    destring `name', replace 
}
merge m:1 year month using 원달러환율, nogenerate
merge m:1 year month using 농산물_소비자물가지수, nogenerate
drop if q_item==""
gen price=금액/중량*환율/cpi
gen time = ym(year, month)
format time %tm
egen qcode=group(q_item)
xtset qcode time, monthly 

* 0. Convert the string date to %tm monthly format
drop date 
gen date_monthly = ym(year, month)
format date_monthly %tm
drop year month
rename date_monthly date

* 1. Compute the number of days in each month
gen days_in_month = dofm(date + 1) - dofm(date)

* 2. Expand rows by the number of days in each month
expand days_in_month

* 3. Generate a sequence number within each month
bysort date q_item: gen day_seq = _n

* 4. Generate daily dates
gen date_daily = dofm(date) + day_seq - 1
format date_daily %td

* 5. Clean up variables
drop days_in_month day_seq date
rename (date_daily price) (date import_price)
keep date q_item import_price qcode 
sort qcode date

gen import_price_orig = import_price
xtset qcode date, daily

* Drop missing values and zeros
drop if import_price==. | import_price==0

* Compute the median for each item (robust to outliers)
bysort qcode: egen import_price_median = median(import_price)

* Detect and remove outliers: set to missing if above 3 times the median or below one-third of the median
gen outlier = (import_price > 3 * import_price_median | import_price < import_price_median / 3)
replace import_price = . if outlier == 1

* Inspect outliers
list date q_item import_price_orig import_price_median if outlier == 1, sepby(q_item)
by qcode: egen outlier_count = total(outlier)
list q_item outlier_count import_price_median if outlier_count > 0, sepby(q_item) noobs

* Use tsfill to make the panel balanced
tsfill, full
drop if q_item==""
merge 1:1 date q_item using fullpanel
* After removing outliers, fill missing values with the median
replace import_price = import_price_median if import_price == .

drop outlier outlier_count import_price_median

save import_price_temp1, replace


use import_price_temp1, clear
set more off 
* Preserve the original import_price
rename import_price import_price_temp3
bysort qcode: ipolate import_price_temp3 date, gen(import_price) epolate
* Extract the day from the date
gen day = day(date)

* Mark the first and last observation for each item
bysort q_item (date): gen first_obs = (_n == 1)
bysort q_item (date): gen last_obs = (_n == _N)

* Keep only the 15th day of each month and set others to missing (but keep first/last observations)
gen import_price_interp = import_price
replace import_price_interp = . if day != 15 & first_obs == 0 & last_obs == 0

* Re-check the time-series panel structure
drop qcode
encode q_item, gen(qcode)
xtset qcode date, daily
tsfill, full
keep if inrange(date,22281,23831)   // 2021-01-01 ~ 2025-03-31

* Apply linear interpolation (within each panel)
bysort qcode: ipolate import_price_interp date, gen(import_price_filled)
drop first_obs last_obs day
order date q_item qcode import_price_orig import_price_filled

keep date q_item qcode import_price_orig import_price_filled
drop if q_item==""
save import_price_final, replace



*****************************
use fullpanel, clear 
keep q_item date 
gen TRQD=0
gen TRQ=.

//! 20260630_할당관세(12개 품목).xlsx  updated 2026-06-30
** Items subject to tariff-rate quota (TRQ)
// q_item, HS10, start date, end date
//! display %tdCCYY_NN_DD 22874
// Onion, 0703101090, 2022-08-17 to 2023-02-28
replace TRQD=1 if q_item=="양파" & inrange(date,22874,23069)  
replace TRQ=10 if q_item=="양파" & inrange(date,22874,23069)
// Cabbage, 0704901000, 2024-05-10 to 2025-04-30
replace TRQD=1 if q_item=="양배추" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="양배추" & inrange(date,23506,23831)
// Napa cabbage, 0704902000, 2024-05-10 to 2025-04-30
replace TRQD=1 if q_item=="배추" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="배추" & inrange(date,23506,23831)
// Carrot, 0706101000, 2024-05-10 to 2025-04-30
replace TRQD=1 if q_item=="당근" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="당근" & inrange(date,23506,23831)
// Radish, 0706901000
replace TRQD=1 if q_item=="무" & inrange(date,mdy(7,1,2024),mdy(4,30,2025))
replace TRQ=0 if q_item=="무" & inrange(date,mdy(7,1,2024),mdy(4,30,2025))
// Pineapple, 0804300000, 2024-01-19 to 2025-06-30
replace TRQD=1 if q_item=="파인애플" & inrange(date,mdy(1,19,2024),mdy(6,30,2025))
replace TRQ=0 if q_item=="파인애플" & inrange(date,mdy(1,19,2024),mdy(6,30,2025))
// Avocado, 0804400000, 2024-01-19 to 2025-06-30
replace TRQD=1 if q_item=="아보카도" & inrange(date,23394,23831)
replace TRQ=0 if q_item=="아보카도" & inrange(date,23394,23831)
// Mango, 0804502000, 2023-08-25 to 2025-06-30
replace TRQD=1 if q_item=="망고" & inrange(date,23247,23831)
replace TRQ=0 if q_item=="망고" & inrange(date,23247,23831)
// Kiwifruit, 0810500000, 2024-04-05 to 2024-12-31
replace TRQD=1 if q_item=="참다래" & inrange(date,23471,23741)
replace TRQ=5 if q_item=="참다래" & inrange(date,23471,23741)
// Banana, 0803900000, 2023-11-17 to 2025-06-30
replace TRQD=1 if q_item=="바나나" & inrange(date,23331,23831)
replace TRQ=0 if q_item=="바나나" & inrange(date,23331,23831)
// Grape, 0806100000
replace TRQD=1 if q_item=="포도" & inrange(date,mdy(5,10,2024),mdy(6,30,2024))
replace TRQ=5 if q_item=="포도" & inrange(date,mdy(5,10,2024),mdy(6,30,2024))
// Green onions, 0703902000
replace TRQD=1 if q_item=="대파" & inrange(date,mdy(11,17,2023),mdy(4,30,2024))
replace TRQ=0 if q_item=="대파" & inrange(date,mdy(11,17,2023),mdy(4,30,2024))
// Cherry, 0809290000, 2024-04-05 to 2024-12-31
//! Cherries are excluded from both treated and control groups: wholesale prices exist but the retail price data are unusable.
/*
// 체리 (cherry), 0809290000, 20240405	20241231
replace TRQD=1 if q_item=="체리" & inrange(date,23471,23741)
replace TRQ=0 if q_item=="체리" & inrange(date,23471,23741)
*/
save TRQ, replace 



use possible, clear 
duplicates tag HS2024, gen(tag)
gsort -tag HS2024
replace HS2024="0704902000_0" if HS2024=="0704902000"&q_item=="얼갈이배추"
replace HS2024="0704902000_1" if HS2024=="0704902000"&q_item=="배추"
replace HS2024="0709601000_0" if HS2024=="0709601000"&q_item=="파프리카"
replace HS2024="0709601000_1" if HS2024=="0709601000"&q_item=="피망"
replace HS2024="0709609000_0" if HS2024=="0709609000"&q_item=="붉은고추"
replace HS2024="0709609000_1" if HS2024=="0709609000"&q_item=="풋고추"
replace HS2024="0709999000_0" if HS2024=="0709999000"&q_item=="미나리"
replace HS2024="0709999000_1" if HS2024=="0709999000"&q_item=="콩나물"
save possible2, replace 

use BaseTaxFin, clear 
expand 2, gen(expand)
replace HS2024="0704902000_0" if HS2024=="0704902000"&expand==0
replace HS2024="0704902000_1" if HS2024=="0704902000"&expand==1
replace HS2024="0709601000_0" if HS2024=="0709601000"&expand==0
replace HS2024="0709601000_1" if HS2024=="0709601000"&expand==1
replace HS2024="0709609000_0" if HS2024=="0709609000"&expand==0
replace HS2024="0709609000_1" if HS2024=="0709609000"&expand==1
replace HS2024="0709999000_0" if HS2024=="0709999000"&expand==0
replace HS2024="0709999000_1" if HS2024=="0709999000"&expand==1
drop expand
duplicates drop  
save BaseTaxFin2, replace 


use total_import, clear 
expand 2, gen(expand)
replace HS2024="0704902000_0" if HS2024=="0704902000"&expand==0
replace HS2024="0704902000_1" if HS2024=="0704902000"&expand==1
replace HS2024="0709601000_0" if HS2024=="0709601000"&expand==0
replace HS2024="0709601000_1" if HS2024=="0709601000"&expand==1
replace HS2024="0709609000_0" if HS2024=="0709609000"&expand==0
replace HS2024="0709609000_1" if HS2024=="0709609000"&expand==1
replace HS2024="0709999000_0" if HS2024=="0709999000"&expand==0
replace HS2024="0709999000_1" if HS2024=="0709999000"&expand==1
drop expand
duplicates drop  
save total_import2, replace 


use oil_fx_cpi, clear 
gen date = dofc(Date)
format date %td
gen oil_price= WTI_Oil/ CPI_US*100/ USD_KRW
keep date oil_price
save oil_price, replace


use BaseTaxFin2, clear 
merge m:1 time HS2024 using total_import2
drop _merge month
merge m:1 HS2024 using possible2
keep if _merge==3 
drop _merge
gen month=month(dofm(time))
order time year month 
sort HS2024 time
save BaseTaxFin3, replace 

use BaseTaxFin3, clear 
egen IMP=rowtotal(IMP_*), missing
keep year month q_item IMP
save compareIMP_add4, replace

use d_mergeready, clear 
merge 1:1 date q_item using s_mergeready
drop _merge
merge m:1 q_item using AIDS_results
drop _merge
gen year=year(date)
gen month=month(date)
merge m:1 year month q_item using BaseTaxFin3
drop _merge
sort q_item date
merge 1:1 date q_item using TRQ 
drop _merge 
merge m:1 year month q_item using BaseTaxFin3
keep if _merge==3
drop _merge
order q_item date TRQ TRQD smooth_s_price2 smooth_d_price2 Eu_uncond BaseTax total_import
keep q_item date TRQ TRQD smooth_s_price2 smooth_d_price2 Eu_uncond BaseTax total_import s_price_orig s_price2 d_price_orig d_price_orig d_price2
rename (s_price2 d_price2) (s_price d_price)
rename (smooth_s_price2 smooth_d_price2 Eu_uncond)(s_price_smooth d_price_smooth elas)
encode q_item, gen(qcode)
sort qcode date 
xtset qcode date, daily
label variable s_price "소매가"
label variable d_price "도매가"
label variable elas "탄력성"
merge m:1 date using w1, nogenerate
merge m:1 date using oil_price, nogenerate
drop if q_item==""
merge 1:1 date q_item using import_price_final //, nogenerate
rename import_price_filled import_price_raw
xtset qcode date, daily
bysort qcode: egen imprice_median=median(import_price_raw)
bysort qcode: ipolate import_price_raw date, gen(import_price_filled) 
replace import_price_filled=imprice_median if import_price_filled==.
drop _merge
save m1_temp3, replace

use m1_temp3, clear
gen pricediff=(import_price_filled-d_price)/d_price
egen pricediff2=mean(pricediff)
di pricediff2
scalar pricediff2=pricediff2[1]
replace import_price_filled=pricediff2*d_price + d_price if q_item=="수박"
save m1_temp4, replace


use m1_temp4, clear
levelsof q_item, local(items)
gen i_price = .
foreach item of local items {
    display "`item'"
    quietly reg import_price_filled i.month if q_item=="`item'"
    quietly predict temp_resid if q_item=="`item'", residual
    quietly summarize import_price_filled if q_item=="`item'"
    quietly replace i_price = temp_resid + r(mean) if q_item=="`item'"
    drop temp_resid
}
* Restrict the sample period
replace i_price = . if !inrange(date, 22281, 23831)  // 2021-01-01 ~ 2025-03-31
xtset qcode date, daily
tsfilter hp i_price_hp = i_price, trend(i_price_smooth) smooth(60)
drop i_price
rename i_price_smooth i_price
save m1_temp5, replace
// #er


// #sr Create government release (stockpile) variables
* Source: 방출량.xlsx (processed by gen_s1_s2.py): monthly totals (tons) assigned to every day of that month.
* The xlsx item '고추' maps to q_item '건고추'. Items/months not listed = 0.
use m1_temp5, clear
gen release = 0
replace release = 776 if q_item=="건고추" & year==2021 & month==1
replace release = 119 if q_item=="건고추" & year==2021 & month==2
replace release = 126 if q_item=="건고추" & year==2021 & month==3
replace release = 126 if q_item=="건고추" & year==2021 & month==4
replace release = 96 if q_item=="건고추" & year==2021 & month==5
replace release = 300 if q_item=="마늘" & year==2021 & month==3
replace release = 1375 if q_item=="마늘" & year==2021 & month==4
replace release = 113 if q_item=="마늘" & year==2021 & month==5
replace release = 228 if q_item=="마늘" & year==2021 & month==6
replace release = 3742 if q_item=="마늘" & year==2021 & month==8
replace release = 1852 if q_item=="마늘" & year==2021 & month==9
replace release = 465 if q_item=="마늘" & year==2021 & month==10
replace release = 1277 if q_item=="마늘" & year==2021 & month==11
replace release = 355 if q_item=="마늘" & year==2021 & month==12
replace release = 590 if q_item=="양파" & year==2021 & month==2
replace release = 292 if q_item=="양파" & year==2021 & month==3
replace release = 222 if q_item=="배추" & year==2021 & month==2
replace release = 758 if q_item=="배추" & year==2021 & month==3
replace release = 470 if q_item=="배추" & year==2021 & month==4
replace release = 2664 if q_item=="배추" & year==2021 & month==11
replace release = 336 if q_item=="배추" & year==2021 & month==12
replace release = 30 if q_item=="무" & year==2021 & month==11
replace release = 21 if q_item=="콩" & year==2021 & month==1
replace release = 44 if q_item=="콩" & year==2021 & month==2
replace release = 29 if q_item=="콩" & year==2021 & month==3
replace release = 42 if q_item=="콩" & year==2021 & month==4
replace release = 18 if q_item=="콩" & year==2021 & month==5
replace release = 1045 if q_item=="콩" & year==2021 & month==6
replace release = 179 if q_item=="콩" & year==2021 & month==7
replace release = 1437 if q_item=="콩" & year==2021 & month==8
replace release = 1033 if q_item=="콩" & year==2021 & month==9
replace release = 823 if q_item=="콩" & year==2021 & month==10
replace release = 213 if q_item=="콩" & year==2021 & month==11
replace release = 13 if q_item=="콩" & year==2021 & month==12
replace release = 1437 if q_item=="건고추" & year==2022 & month==11
replace release = 1 if q_item=="건고추" & year==2022 & month==12
replace release = 219 if q_item=="마늘" & year==2022 & month==1
replace release = 1062 if q_item=="마늘" & year==2022 & month==2
replace release = 250 if q_item=="마늘" & year==2022 & month==3
replace release = 5 if q_item=="마늘" & year==2022 & month==7
replace release = 232 if q_item=="마늘" & year==2022 & month==8
replace release = 355 if q_item=="마늘" & year==2022 & month==9
replace release = 183 if q_item=="마늘" & year==2022 & month==10
replace release = 4516 if q_item=="마늘" & year==2022 & month==11
replace release = 328 if q_item=="마늘" & year==2022 & month==12
replace release = 240 if q_item=="양파" & year==2022 & month==6
replace release = 2662 if q_item=="양파" & year==2022 & month==7
replace release = 3527 if q_item=="양파" & year==2022 & month==8
replace release = 3320 if q_item=="양파" & year==2022 & month==9
replace release = 854 if q_item=="양파" & year==2022 & month==10
replace release = 1789 if q_item=="양파" & year==2022 & month==11
replace release = 1780 if q_item=="양파" & year==2022 & month==12
replace release = 1232 if q_item=="배추" & year==2022 & month==1
replace release = 697 if q_item=="배추" & year==2022 & month==2
replace release = 90 if q_item=="배추" & year==2022 & month==3
replace release = 1385 if q_item=="배추" & year==2022 & month==4
replace release = 215 if q_item=="배추" & year==2022 & month==5
replace release = 1598 if q_item=="배추" & year==2022 & month==7
replace release = 2604 if q_item=="배추" & year==2022 & month==8
replace release = 3444 if q_item=="배추" & year==2022 & month==9
replace release = 2660 if q_item=="배추" & year==2022 & month==10
replace release = 1031 if q_item=="배추" & year==2022 & month==11
replace release = 50 if q_item=="무" & year==2022 & month==5
replace release = 750 if q_item=="무" & year==2022 & month==7
replace release = 788 if q_item=="무" & year==2022 & month==8
replace release = 450 if q_item=="무" & year==2022 & month==9
replace release = 60 if q_item=="콩" & year==2022 & month==1
replace release = 19 if q_item=="콩" & year==2022 & month==3
replace release = 24 if q_item=="콩" & year==2022 & month==4
replace release = 24 if q_item=="콩" & year==2022 & month==5
replace release = 25 if q_item=="콩" & year==2022 & month==6
replace release = 998 if q_item=="콩" & year==2022 & month==7
replace release = 310 if q_item=="콩" & year==2022 & month==9
replace release = 720 if q_item=="콩" & year==2022 & month==10
replace release = 284 if q_item=="콩" & year==2022 & month==11
replace release = 1 if q_item=="팥" & year==2022 & month==5
replace release = 150 if q_item=="마늘" & year==2023 & month==1
replace release = 154 if q_item=="마늘" & year==2023 & month==2
replace release = 420 if q_item=="마늘" & year==2023 & month==3
replace release = 181 if q_item=="마늘" & year==2023 & month==4
replace release = 184 if q_item=="마늘" & year==2023 & month==5
replace release = 1053 if q_item=="마늘" & year==2023 & month==11
replace release = 71 if q_item=="마늘" & year==2023 & month==12
replace release = 1304 if q_item=="양파" & year==2023 & month==1
replace release = 1066 if q_item=="양파" & year==2023 & month==2
replace release = 684 if q_item=="양파" & year==2023 & month==3
replace release = 593 if q_item=="양파" & year==2023 & month==9
replace release = 55 if q_item=="양파" & year==2023 & month==10
replace release = 208 if q_item=="배추" & year==2023 & month==3
replace release = 87 if q_item=="배추" & year==2023 & month==4
replace release = 1092 if q_item=="배추" & year==2023 & month==5
replace release = 402 if q_item=="배추" & year==2023 & month==6
replace release = 820 if q_item=="배추" & year==2023 & month==7
replace release = 5211 if q_item=="배추" & year==2023 & month==8
replace release = 690 if q_item=="배추" & year==2023 & month==9
replace release = 651 if q_item=="배추" & year==2023 & month==10
replace release = 622 if q_item=="배추" & year==2023 & month==12
replace release = 1196 if q_item=="무" & year==2023 & month==4
replace release = 2952 if q_item=="무" & year==2023 & month==5
replace release = 483 if q_item=="무" & year==2023 & month==6
replace release = 52 if q_item=="무" & year==2023 & month==7
replace release = 4117 if q_item=="무" & year==2023 & month==8
replace release = 84 if q_item=="무" & year==2023 & month==9
replace release = 20 if q_item=="무" & year==2023 & month==11
replace release = 125 if q_item=="무" & year==2023 & month==12
replace release = 251 if q_item=="콩" & year==2023 & month==9
replace release = 1702 if q_item=="콩" & year==2023 & month==10
replace release = 1637 if q_item=="콩" & year==2023 & month==11
replace release = 383 if q_item=="콩" & year==2023 & month==12
replace release = 1 if q_item=="팥" & year==2023 & month==11
replace release = 697 if q_item=="마늘" & year==2024 & month==8
replace release = 443 if q_item=="마늘" & year==2024 & month==11
replace release = 337 if q_item=="양파" & year==2024 & month==1
replace release = 2965 if q_item=="양파" & year==2024 & month==2
replace release = 1022 if q_item=="양파" & year==2024 & month==3
replace release = 231 if q_item=="양파" & year==2024 & month==9
replace release = 731 if q_item=="양파" & year==2024 & month==11
replace release = 35 if q_item=="양파" & year==2024 & month==12
replace release = 1611 if q_item=="배추" & year==2024 & month==1
replace release = 1947 if q_item=="배추" & year==2024 & month==2
replace release = 1513 if q_item=="배추" & year==2024 & month==3
replace release = 2954 if q_item=="배추" & year==2024 & month==4
replace release = 955 if q_item=="배추" & year==2024 & month==5
replace release = 3343 if q_item=="배추" & year==2024 & month==7
replace release = 5214 if q_item=="배추" & year==2024 & month==8
replace release = 272 if q_item=="배추" & year==2024 & month==9
replace release = 695 if q_item=="배추" & year==2024 & month==10
replace release = 480 if q_item=="무" & year==2024 & month==1
replace release = 3258 if q_item=="무" & year==2024 & month==2
replace release = 1969 if q_item=="무" & year==2024 & month==3
replace release = 2022 if q_item=="무" & year==2024 & month==4
replace release = 1263 if q_item=="무" & year==2024 & month==5
replace release = 1959 if q_item=="무" & year==2024 & month==7
replace release = 2228 if q_item=="무" & year==2024 & month==8
replace release = 286 if q_item=="무" & year==2024 & month==9
replace release = 160 if q_item=="콩" & year==2024 & month==1
replace release = 63 if q_item=="콩" & year==2024 & month==2
replace release = 50 if q_item=="콩" & year==2024 & month==3
replace release = 684 if q_item=="콩" & year==2024 & month==8
replace release = 1994 if q_item=="콩" & year==2024 & month==9
replace release = 2710 if q_item=="콩" & year==2024 & month==10
replace release = 2632 if q_item=="콩" & year==2024 & month==11
replace release = 1120 if q_item=="콩" & year==2024 & month==12
replace release = 399 if q_item=="마늘" & year==2025 & month==1
replace release = 625 if q_item=="양파" & year==2025 & month==1
replace release = 1091 if q_item=="양파" & year==2025 & month==2
replace release = 717 if q_item=="양파" & year==2025 & month==3
replace release = 1025 if q_item=="배추" & year==2025 & month==1
replace release = 1577 if q_item=="배추" & year==2025 & month==3
replace release = 108 if q_item=="무" & year==2025 & month==2
replace release = 336 if q_item=="무" & year==2025 & month==3
replace release = 492 if q_item=="콩" & year==2025 & month==1
replace release = 13 if q_item=="콩" & year==2025 & month==2
save m1_temp6, replace

// #er 


// #sr Create WTO-TRQ variables
use m1_temp6, clear
keep q_item date
save m1_temp7, replace   //! The WTO-TRQ control variables are built from these rows; this is a full panel over q_item x date.

//! WTO_TRQ_gen.do creates WTO_TRQ.dta (constants transcribed from "WTO 시장접근물량 증량현황_(2026.7.7).xlsx"). It reads m1_temp5, so run it once after the save m1_temp5 step above; the package also ships WTO_TRQ.dta ready-made.
use m1_temp6, clear   
merge 1:1 q_item date using WTO_TRQ, keep(1 3) nogen   // keep master and matched rows only
//! Soybean sprouts could not be included when the WTO xlsx was surveyed, but all their WTO_TRQ variables are in fact 0.
replace WTO_TRQ      = 0 if q_item=="콩나물" & missing(WTO_TRQ)
replace WTO_increase = 0 if q_item=="콩나물" & missing(WTO_increase)
replace WTO_bite     = 0 if q_item=="콩나물" & missing(WTO_bite)

//! Drop grapes
drop if q_item=="포도"  
save m1, replace  

// #er 


// #sr Get applied tariff rate by country x monthlytime x HS
import excel "kati_import_price_finished_finaluse.xlsx", sheet("Sheet1") firstrow allstring clear
destring year month 중량 금액, replace   // 중량 (weight) = 1KG, 금액 (value) = 1USD
gen time = ym(year, month)
format time %tm
rename country loc
drop year month 
preserve 
    //! Soybean sprouts: same HS code as water dropwort, so the KATI-scraped info is duplicated for them.
    keep if q_item=="미나리"
    replace q_item="콩나물"
    save kati_import_price_finishedfinaluse_콩나물, replace
restore
append using kati_import_price_finishedfinaluse_콩나물
save kati_import_price_finished_finaluse_old, replace 

import excel "kati_import_price_add4_finished_finaluse.xlsx", sheet("Sheet1") firstrow allstring clear
destring year month 중량 금액, replace 
gen time = ym(year, month)
format time %tm
rename country loc
drop year month 
save kati_import_price_finished_finaluse_add4, replace 

use kati_import_price_finished_finaluse_old, clear
append using kati_import_price_finished_finaluse_add4
drop if inlist(q_item,"체리","느타리버섯","새송이버섯")
save kati_import_price_finished_finaluse, replace 

use sp0, clear 
keep idn time HS10 품명한글
merge 1:m idn using long_init_importprice, nogenerate
rename ORD1_ BaseTax_loc

gen year = year(dofm(time))
gen month = month(dofm(time))
gen HS2024=HS10
preserve 
    keep if HS10=="0709999000"&year==2021
    replace HS2024="0709993000"
    replace 품명한글="깻잎"
    save 깻잎2021, replace 
restore 
append using 깻잎2021
replace 품명한글="미나리" if 품명한글=="기타"&HS10=="0709999000"
preserve
    keep if HS10=="0702000000"&year==2021
    replace HS2024="0702001000"
    replace 품명한글="방울토마토"
    save 방울토마토2021, replace 
restore 
preserve
    keep if HS10=="0702000000"&year==2021
    replace HS2024="0702009000"
    replace 품명한글="토마토"
    save 토마토2021, replace 
restore 
drop if HS10=="0702000000"&year==2021
append using 방울토마토2021
append using 토마토2021
replace HS2024="0807199000" if year==2021&HS10=="0807190000"   // melon
replace HS2024="0703101090" if year==2021&HS10=="0703101000"   // onion
replace HS2024="0703902000" if year==2021&HS10=="0703909000"   // green onion
replace HS2024="0703903000" if year==2021&HS10=="0703102000"   // small green onion

expand 2, gen(expand)
replace HS2024="0704902000_0" if HS2024=="0704902000"&expand==0
replace HS2024="0704902000_1" if HS2024=="0704902000"&expand==1
replace HS2024="0709601000_0" if HS2024=="0709601000"&expand==0
replace HS2024="0709601000_1" if HS2024=="0709601000"&expand==1
replace HS2024="0709609000_0" if HS2024=="0709609000"&expand==0
replace HS2024="0709609000_1" if HS2024=="0709609000"&expand==1
replace HS2024="0709999000_0" if HS2024=="0709999000"&expand==0
replace HS2024="0709999000_1" if HS2024=="0709999000"&expand==1
drop expand
duplicates drop  

merge m:1 HS2024 using possible2
keep if _merge==3 
drop _merge 
keep time loc BaseTax_loc q_item
merge 1:m loc time q_item using kati_import_price_finished_finaluse
sort q_item loc time
rename (중량 금액) (volume totalvalue)
order q_item loc time BaseTax_loc volume totalvalue
drop if _merge==2 
drop _merge HS10

replace volume=0 if volume==.
replace totalvalue=. if totalvalue==0
gen importprice_loc=totalvalue/volume if totalvalue!=.&volume!=0
save Import_price, replace 

// #er 


// #sr Export Figure 1 of the paper (p.14): applied tariff rates for banana and onion
use m1, clear 
keep if inrange(date,mdy(1, 1, 2021),mdy(3, 31, 2025))
keep if inlist(q_item,"바나나","양파")
twoway (tsline BaseTax if q_item=="양파", lcolor(gs0) cmissing(n))(tsline BaseTax if q_item=="바나나", lcolor(red) cmissing(n) lpattern(dash)) ///
, legend(order(1 "양파" 2 "바나나")) ytitle("실질관세율 (%)") xtitle("")
graph export 실질관세율_바나나_양파.png, replace width(3000)

set scheme s1color
twoway (tsline BaseTax if q_item=="양파", lcolor(gs0) cmissing(n))(tsline BaseTax if q_item=="바나나", lcolor(red) cmissing(n) lpattern(dash)) ///
, legend(order(1 "Onion" 2 "Banana")) ytitle("Applied Tariff Rate (%)") xtitle("")
graph export 실질관세율_바나나_양파_eng.png, replace width(3000)  




// #er


// #sr Export Figure 2 of the paper (p.16): seasonally adjusted retail price (spinach)
use s2, clear 
keep s_item date s_price s_price_orig s_item2
merge m:1 s_item using possible
keep if _merge==3
drop _merge 
merge 1:1 s_item date using fullpanel
drop _merge
drop s_item2
encode s_item, gen(s_item2)
xtset s_item2 date, daily 
//tsfill, full
sort s_item2 date
by s_item2: ipolate s_price date, gen(s_price2) 
by s_item2: ipolate s_price_orig date, gen(s_price_orig2) 
keep if s_item=="시금치_시금치(전체)"
keep if inrange(date, 22281, 23831)  // 2021-01-01 ~ 2025-03-31
twoway (tsline s_price_orig2, lcolor(gs0) lwidth(thick)) ///
       (tsline s_price2, lcolor(red)), ///
       ytitle("단위: 원/kg") xtitle("") legend(label(1 "원자료") label(2 "계절조정"))
graph export 계절조정.png, replace width(3000)

set scheme s1color
twoway (tsline s_price_orig2, lcolor(gs0) lwidth(thick)) ///
       (tsline s_price2, lcolor(red)), ///
       ytitle("Unit: KRW/kg") xtitle("") legend(label(1 "Raw data") label(2 "Seasonally adjusted"))
graph export 계절조정_eng.png, replace width(3000)  

// #er 




// #sr After checking the TRQ quota thresholds, reset the end dates
* This block calls the custom command check_TRQquota (check_TRQquota.ado, shipped in this folder; found via the adopath line at the top).
check_TRQquota 망고
local range="inrange(mtime,ym(2022,11),ym(2022,12))"
local item="망고"
local max_quota=1200000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 망고
local range="inrange(mtime,ym(2023,9),ym(2023,12))"
local item="망고"
local max_quota=2300000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 망고
local range="inrange(mtime,ym(2024,1),ym(2024,6))"
local item="망고"
local max_quota=14000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 망고
local range="inrange(mtime,ym(2025,2),ym(2025,6))"
local item="망고"
local max_quota=25000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 바나나
local range="inrange(mtime,ym(2023,11),ym(2023,12))"
local item="바나나"
local max_quota=30000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 바나나
local range="inrange(mtime,ym(2024,1),ym(2024,6))"
local item="바나나"
local max_quota=150000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 바나나
local range="inrange(mtime,ym(2025,2),ym(2025,6))"
local item="바나나"
local max_quota=200000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 아보카도
local range="inrange(mtime,ym(2024,2),ym(2024,6))"
local item="아보카도"
local max_quota=1000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 아보카도
local range="inrange(mtime,ym(2025,2),ym(2025,6))"
local item="아보카도"
local max_quota=2000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 파인애플
local range="inrange(mtime,ym(2022,11),ym(2022,12))"
local item="파인애플"
local max_quota=8600000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday   

check_TRQquota 파인애플
local range="inrange(mtime,ym(2023,9),ym(2023,12))"
local item="파인애플"
local max_quota=5000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday   

check_TRQquota 파인애플
local range="inrange(mtime,ym(2024,2),ym(2024,6))"
local item="파인애플"
local max_quota=40000000   //! changed to unlimited on 2024-04-05
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 파인애플
local range="inrange(mtime,ym(2025,2),ym(2025,6))"
local item="파인애플"
local max_quota=46000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 배추
local range="inrange(mtime,ym(2025,2),ym(2025,4))"
local item="배추"
local max_quota=10000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday  


check_TRQquota 양배추
local range="inrange(mtime,ym(2024,5),ym(2024,6))"
local item="양배추"
local max_quota=6000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday  


check_TRQquota 양배추
local range="inrange(mtime,ym(2024,7),ym(2024,10))"
local item="양배추"
local max_quota=2500000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 양배추
local range="inrange(mtime,ym(2025,2),ym(2025,4))"
local item="양배추"
local max_quota=7500000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 무
local range="inrange(mtime,ym(2025,1),ym(2025,2))"
local item="무"
local max_quota=8000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 무
local range="inrange(mtime,ym(2025,3),ym(2025,4))"
local item="무"
local max_quota=12000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 당근
local range="inrange(mtime,ym(2024,5),ym(2024,9))"
local item="당근"
local max_quota=40000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 당근
local range="inrange(mtime,ym(2024,11),ym(2024,12))"
local item="당근"
local max_quota=18000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 당근
local range="inrange(mtime,ym(2025,1),ym(2025,2))"
local item="당근"
local max_quota=15000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*28/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 당근
local range="inrange(mtime,ym(2025,3),ym(2025,4))"
local item="당근"
local max_quota=20000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 양파
local range="inrange(mtime,ym(2022,8),ym(2022,12))"
local item="양파"
local max_quota=92000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 양파
local range="inrange(mtime,ym(2023,1),ym(2023,2))"
local item="양파"
local max_quota=20000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday


check_TRQquota 대파
local range="inrange(mtime,ym(2022,8),ym(2022,10))"
local item="대파"
local max_quota=448000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 대파
local range="inrange(mtime,ym(2023,5),ym(2023,6))"
local item="대파"
local max_quota=5000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 대파
local range="inrange(mtime,ym(2023,11),ym(2023,12))"
local item="대파"
local max_quota=2000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 대파
local range="inrange(mtime,ym(2024,2),ym(2024,3))"
local item="대파"
local max_quota=3000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday

check_TRQquota 대파
local range="inrange(mtime,ym(2024,4),ym(2024,4))"
local item="대파"
local max_quota=3000000
gen ti_cum = sum(ti) if `range'&q_item=="`item'"
gen flag=1 if ti_cum>=`max_quota' & `range'&q_item=="`item'"
format ti_cum %12.0g
gen row_num = _n if flag == 1
summarize row_num, meanonly
local first_row = r(min)  
local first_row_before = `first_row' - 1
tsset mtime
scalar endday=(`max_quota'-ti_cum[`first_row_before'])*30/(ti_cum[`first_row']-ti_cum[`first_row_before'])
di endday




** Manual adjustment of interruption or end periods
use m1, clear 
sort q_item date
drop TRQ
//! Please refer to "20260630_할당관세(12개 품목).xlsx" for the reasons and basis for manual decisions
replace TRQD=1 if q_item=="망고"&inrange(date,mdy(11,10,2022),mdy(12,31,2022)) 
replace TRQD=0 if q_item=="망고"&inrange(date,mdy(1,1,2024),mdy(1,18,2024))  
replace TRQD=0 if q_item=="망고"&inrange(date,mdy(1,1,2025),mdy(1,23,2025)) 

replace TRQD=1 if q_item=="바나나"&inrange(date,mdy(11,10,2022),mdy(12,31,2022)) 
replace TRQD=0 if q_item=="바나나"&inrange(date,mdy(1,1,2024),mdy(1,18,2024)) 
replace TRQD=0 if q_item=="바나나"&inrange(date,mdy(1,1,2025),mdy(1,23,2025)) 

replace TRQD=0 if q_item=="아보카도"&inrange(date,mdy(1,1,2025),mdy(1,23,2025)) 

replace TRQD=1 if q_item=="파인애플"&inrange(date,mdy(11,10,2022),mdy(12,31,2022))
replace TRQD=0 if q_item=="파인애플"&inrange(date,mdy(1,1,2025),mdy(1,23,2025))
replace TRQD=1 if q_item=="파인애플"&inrange(date,mdy(8,25,2023),mdy(12,31,2023))
replace TRQD=0 if q_item=="파인애플"&inrange(date,mdy(10,9,2023),mdy(12,31,2023))

replace TRQD=0 if q_item=="배추"&inrange(date,mdy(1,1,2025),mdy(1,23,2025))

replace TRQD=0 if q_item=="양배추"&inrange(date,mdy(11,1,2024),mdy(1,23,2025))
replace TRQD=0 if q_item=="양배추"&inrange(date,mdy(10,13,2024),mdy(10,31,2024))

replace TRQD=1 if q_item=="무"&inrange(date,mdy(5,1,2023),mdy(6,30,2023))

replace TRQD=0 if q_item=="당근"&inrange(date,mdy(10,1,2024),mdy(10,28,2024))
replace TRQD=0 if q_item=="당근"&inrange(date,mdy(9,7,2024),mdy(9,30,2024))
replace TRQD=0 if q_item=="당근"&inrange(date,mdy(12,19,2024),mdy(12,31,2024))

replace TRQD=0 if q_item=="양파"&inrange(date,mdy(2,10,2023),mdy(2,28,2023))

replace TRQD=1 if q_item=="대파"&inrange(date,mdy(7,20,2022),mdy(10,31,2022))
replace TRQD=1 if q_item=="대파"&inrange(date,mdy(5,1,2023),mdy(6,30,2023))
replace TRQD=0 if q_item=="대파"&inrange(date,mdy(1,1,2024),mdy(1,18,2024))
save m2, replace


use m2, clear
//! discarded
clear all
gen empty=1
save m3, replace 


use m2, clear
gen treated=0
replace treated=1 if inlist(q_item,"배추","양배추","무","당근","양파","대파")|inlist(q_item,"망고","참다래","바나나","아보카도","파인애플","포도")
gen TRQ=.
replace TRQ=0 if TRQD==1 & treated==1   //! items other than kiwifruit, grape, and onion carry a 0% rate under the quota tariff
replace TRQ=5 if TRQD==1 & q_item=="참다래"
//replace TRQ=5 if TRQD==1 & q_item=="포도"
replace TRQ=10 if TRQD==1 & q_item=="양파"
replace TRQ=. if treated==0
save m4, replace 


// #er


// #sr Export fragments for Paper Tables 5-7 (pp.53-56): summary statistics
//! ============================================================
//! Summary statistics block [BEGIN]
//! Builds the two appendix summary tables: regression-variable summary stats and annual import volume/value by item.
//! Do not delete this block — it produces the fragments behind Paper Tables 5-7 (pp.53-56).
//! Self-contained: starts with use and restores the in-memory state (m4) at the end.
//! Outputs (CWD): sumstat_T1_eng.tex sumstat_T1_kor.tex sumstat_T2vol_eng.tex sumstat_T2vol_kor.tex sumstat_T2val_eng.tex sumstat_T2val_kor.tex
//!               sumstat_T1_res.csv sumstat_T2_res.csv (raw-unit values for verification)
//! The import table is split into volume/value tables to fit the page width.
//! Note: LaTeX math is written as \( \) so that Stata does not expand $ globals.
//! ============================================================
capture which rangestat
if _rc ssc install rangestat, replace

* ---------- (0) Item classification and English-name mapping (cat 1=treated veg, 2=treated fruit, 3=never-treated veg/other, 4=never-treated fruit) ----------
preserve
clear
input str15 q_item str30 eng_name byte cat
"배추"       "napa cabbage"        1
"양배추"     "cabbage"             1
"무"         "radish"              1
"당근"       "carrot"              1
"양파"       "onion"               1
"대파"       "green onion"         1
"망고"       "mango"               2
"참다래"     "kiwifruit"           2
"바나나"     "banana"              2
"아보카도"   "avocado"             2
"파인애플"   "pineapple"           2
"건고추"     "dried red pepper"    3
"고구마"     "sweet potato"        3
"깻잎"       "perilla leaf"        3
"녹두"       "mung bean"           3
"땅콩"       "peanut"              3
"마늘"       "garlic"              3
"미나리"     "water dropwort"      3
"방울토마토" "cherry tomato"       3
"붉은고추"   "red pepper"          3
"상추"       "lettuce"             3
"생강"       "ginger"              3
"시금치"     "spinach"             3
"얼갈이배추" "young napa cabbage"  3
"열무"       "young summer radish" 3
"오이"       "cucumber"            3
"쪽파"       "scallion"            3
"참깨"       "sesame"              3
"콩"         "bean"                3
"콩나물"     "soybean sprout"      3
"토마토"     "tomato"              3
"파프리카"   "bell pepper"         3
"팥"         "adzuki bean"         3
"풋고추"     "green pepper"        3
"피망"       "sweet pepper"        3
"호박"       "squash"              3
"사과"       "apple"               4
"레몬"       "lemon"               4
"멜론"       "melon"               4
"배"         "pear"                4
"수박"       "watermelon"          4
end
isid q_item
assert eng_name!=""
count if cat==1
assert r(N)==6
count if cat==2
assert r(N)==5
count if cat==3
assert r(N)==25
count if cat==4
assert r(N)==5
* Shared-HSK pair markers (a~e; intentional data structure)
gen str2 pairmark = ""
replace pairmark = "a" if inlist(q_item,"미나리","콩나물")
replace pairmark = "b" if inlist(q_item,"방울토마토","토마토")
replace pairmark = "c" if inlist(q_item,"배추","얼갈이배추")
replace pairmark = "d" if inlist(q_item,"붉은고추","풋고추")
replace pairmark = "e" if inlist(q_item,"파프리카","피망")
tempfile itemmap
save `itemmap'
restore

* ---------- (1) T1: summary statistics of the regression variables (from m4) ----------
use m4, clear
* Defensive checks
assert _N==63591
quietly tab q_item
assert r(r)==41
count if q_item=="포도"
assert r(N)==0
quietly sum date
assert r(min)==22281 & r(max)==23831
count if !missing(s_price)
assert r(N)==63013
count if missing(s_price) & q_item=="아보카도"
assert r(N)==458
count if missing(s_price) & q_item!="아보카도"
assert r(N)==120
* Soybean-sprout TRQD missing -> 0 (same treatment as in the LP-DiD do files)
count if missing(TRQD) & q_item!="콩나물"
assert r(N)==0
replace TRQD = 0 if missing(TRQD)

* Panel A: daily panel variables (raw units; raw treatment path before bridging)
tempfile t1res
tempname P
postfile `P' byte panelno int ord str20 vkey str15 q_item double(N mean sd min max) using "`t1res'", replace
local ord = 0
foreach v in s_price TRQD BaseTax temp_avg humidity_avg precipitation_daily sunshine_hours oil_price WTO_TRQ WTO_increase WTO_bite {
    local ++ord
    quietly sum `v'
    * oil_price is shown x1000 for readability (raw value = real WTI / KRW-USD rate)
    if "`v'"=="oil_price" {
        post `P' (1) (`ord') ("`v'") ("") (r(N)) (r(mean)*1000) (r(sd)*1000) (r(min)*1000) (r(max)*1000)
    }
    else {
        post `P' (1) (`ord') ("`v'") ("") (r(N)) (r(mean)) (r(sd)) (r(min)) (r(max))
    }
}

* Panel B-1: treatment intensity G (11 ever-treated items) — same logic as _lp_common_prep in the LPseparate do files
gen byte d = inlist(q_item,"배추","양배추","무","당근","양파","대파") | inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
sort qcode date
* Bridge administrative gaps of 30 days or less (treatment-path definition)
by qcode: gen long _spell = sum(TRQD != TRQD[_n-1] | _n==1)
by qcode: egen long _maxsp = max(_spell)
bysort qcode _spell (date): gen long _slen = _N
sort qcode date
gen byte _bridge = (TRQD==0 & _slen<=30 & _spell>1 & _spell<_maxsp)
replace TRQD = 1 if _bridge
drop _spell _maxsp _slen _bridge
tsset qcode date, daily
gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
by qcode: egen TRQstart = mean(flag)
gen rtime = date - TRQstart
gen double TRQall_temp = TRQ if flag<. & d==1
by qcode: egen double TRQall = mean(TRQall_temp)
gen double intensity_temp = (BaseTax - TRQall) if d==1
replace intensity_temp = 0 if intensity_temp < 0
sort qcode rtime
rangestat (mean) intensity_temp, interval(rtime -365 0) by(qcode)
gen intensity_temp2 = intensity_temp_mean if flag<. & d==1
bysort qcode: egen double intensity = mean(intensity_temp2)
preserve
keep if d==1
collapse (first) intensity, by(q_item)
assert _N==11
assert intensity<. & intensity>0
quietly sum intensity
post `P' (2) (1) ("intensity") ("") (r(N)) (r(mean)) (r(sd)) (r(min)) (r(max))
restore

* Panel B-2: government releases (item x month; raw data = monthly totals repeated daily)
assert release<.
bysort q_item year month (release): gen byte _relchk = (release[1]==release[_N])
assert _relchk==1
drop _relchk
preserve
collapse (first) release, by(q_item year month)
assert _N==41*51
quietly sum release
post `P' (2) (2) ("release_m") ("") (r(N)) (r(mean)) (r(sd)) (r(min)) (r(max))
restore

* Panel C: retail prices by item (seasonally adjusted)
preserve
collapse (count) N=s_price (mean) mean=s_price (sd) sd=s_price (min) min=s_price (max) max=s_price, by(q_item)
merge 1:1 q_item using `itemmap'
assert _merge==3
drop _merge
forvalues i = 1/`=_N' {
    post `P' (3) (`i') ("item") ("`=q_item[`i']'") (`=N[`i']') (`=mean[`i']') (`=sd[`i']') (`=min[`i']') (`=max[`i']')
}
restore
postclose `P'

* T1 CSV (verification basis)
preserve
use "`t1res'", clear
export delimited using "sumstat_T1_res.csv", replace
restore

* ---------- (2) T1 LaTeX fragments (English/Korean) ----------
preserve
use "`t1res'", clear
merge m:1 q_item using `itemmap', keep(1 3) nogen
* Panel A/B labels (LaTeX math written as \( \) — never $)
gen str120 lab_eng = ""
gen str120 lab_kor = ""
replace lab_eng = "Retail price, seasonally adjusted (KRW/kg)" if vkey=="s_price"
replace lab_kor = "소매가격(계절조정, 원/kg)"                    if vkey=="s_price"
replace lab_eng = "Quota Tariff treatment status (0/1)"          if vkey=="TRQD"
replace lab_kor = "할당관세 처치상태 (0/1)"                       if vkey=="TRQD"
replace lab_eng = "Applied tariff rate (\%)"                     if vkey=="BaseTax"
replace lab_kor = "실행관세율 (\%)"                               if vkey=="BaseTax"
replace lab_eng = "Mean temperature (\(^{\circ}\)C)"             if vkey=="temp_avg"
replace lab_kor = "평균기온 (\(^{\circ}\)C)"                      if vkey=="temp_avg"
replace lab_eng = "Mean relative humidity (\%)"                  if vkey=="humidity_avg"
replace lab_kor = "평균상대습도 (\%)"                             if vkey=="humidity_avg"
* precipitation_daily: source w1.dta; not raw mm and the exact definition is unconfirmed -> labeled honestly as a precipitation index
replace lab_eng = "Precipitation index"                          if vkey=="precipitation_daily"
replace lab_kor = "강수지수"                                      if vkey=="precipitation_daily"
replace lab_eng = "Sunshine duration (hours)"                    if vkey=="sunshine_hours"
replace lab_kor = "일조시간 (시간)"                               if vkey=="sunshine_hours"
replace lab_eng = "Real crude oil price (\(\times\)1,000)"        if vkey=="oil_price"
replace lab_kor = "실질 국제유가 (\(\times\)1,000)"               if vkey=="oil_price"
replace lab_eng = "WTO market access quota, applicable (0/1)"    if vkey=="WTO_TRQ"
replace lab_kor = "WTO 시장접근물량 대상 (0/1)"                   if vkey=="WTO_TRQ"
replace lab_eng = "WTO quota expansion (ratio)"                  if vkey=="WTO_increase"
replace lab_kor = "WTO 시장접근물량 증량 배율"                    if vkey=="WTO_increase"
replace lab_eng = "WTO expansion intensity"                      if vkey=="WTO_bite"
replace lab_kor = "WTO 증량 실효강도"                             if vkey=="WTO_bite"
replace lab_eng = "Treatment intensity \(G\) (\%p; ever-treated items)" if vkey=="intensity"
replace lab_kor = "처치강도 \(G\) (\%p; ever-treated 품목)"             if vkey=="intensity"
replace lab_eng = "Government stock releases (tons/month; item\(\times\)month)" if vkey=="release_m"
replace lab_kor = "정부 방출량 (톤/월; 품목\(\times\)월)"                        if vkey=="release_m"
replace lab_kor = q_item   if panelno==3
replace lab_eng = eng_name if panelno==3
* Number formats: dummies/ratios 3 decimals / others 1 decimal / N integer with commas
gen byte fmt3 = inlist(vkey,"TRQD","WTO_TRQ","WTO_increase","WTO_bite")
gen str15 sN    = trim(string(N,   "%15.0fc"))
gen str15 smean = cond(fmt3, trim(string(mean,"%15.3fc")), trim(string(mean,"%15.1fc")))
gen str15 ssd   = cond(fmt3, trim(string(sd,  "%15.3fc")), trim(string(sd,  "%15.1fc")))
gen str15 smin  = cond(fmt3, trim(string(min, "%15.3fc")), trim(string(min, "%15.1fc")))
gen str15 smax  = cond(fmt3, trim(string(max, "%15.3fc")), trim(string(max, "%15.1fc")))
* Sort keys: Panels A/B by ord, Panel C by category + language-specific name order
gen eng_lower = lower(eng_name)
gen str80 skey = ""
forvalues L = 1/2 {
    local lang = cond(`L'==1, "eng", "kor")
    replace skey = "0_" + string(ord, "%03.0f") if panelno<3
    replace skey = string(cat) + "_" + cond(`L'==1, eng_lower, q_item) if panelno==3
    sort panelno skey
    file open FH using "sumstat_T1_`lang'.tex", write replace text
    local curpanel = 0
    local curcat = 0
    forvalues i = 1/`=_N' {
        local pn = panelno[`i']
        if `pn' != `curpanel' {
            local curpanel = `pn'
            local curcat = 0
            if `pn'==1 {
                if `L'==1 file write FH "\multicolumn{6}{l}{\textit{Panel A. Daily panel variables}} \\" _n
                else      file write FH "\multicolumn{6}{l}{\textit{Panel A. 일별 패널 변수}} \\" _n
            }
            if `pn'==2 {
                if `L'==1 file write FH "\addlinespace" _n "\multicolumn{6}{l}{\textit{Panel B. Treatment intensity and policy variables}} \\" _n
                else      file write FH "\addlinespace" _n "\multicolumn{6}{l}{\textit{Panel B. 처치강도 및 정책 변수}} \\" _n
            }
            if `pn'==3 {
                if `L'==1 file write FH "\addlinespace" _n "\multicolumn{6}{l}{\textit{Panel C. Seasonally adjusted retail price (KRW/kg), by product}} \\" _n
                else      file write FH "\addlinespace" _n "\multicolumn{6}{l}{\textit{Panel C. 품목별 소매가격(계절조정, 원/kg)}} \\" _n
            }
        }
        if `pn'==3 {
            local cc = cat[`i']
            if `cc' != `curcat' {
                local curcat = `cc'
                if `L'==1 {
                    if `cc'==1 file write FH "\multicolumn{6}{l}{Treated: leafy and root vegetables} \\" _n
                    if `cc'==2 file write FH "\multicolumn{6}{l}{Treated: fruits} \\" _n
                    if `cc'==3 file write FH "\multicolumn{6}{l}{Never-treated: vegetables and other crops} \\" _n
                    if `cc'==4 file write FH "\multicolumn{6}{l}{Never-treated: fruits} \\" _n
                }
                else {
                    if `cc'==1 file write FH "\multicolumn{6}{l}{처치: 엽채류·근채류} \\" _n
                    if `cc'==2 file write FH "\multicolumn{6}{l}{처치: 과일류} \\" _n
                    if `cc'==3 file write FH "\multicolumn{6}{l}{Never-treated: 채소 및 기타 작물} \\" _n
                    if `cc'==4 file write FH "\multicolumn{6}{l}{Never-treated: 과일류} \\" _n
                }
            }
        }
        local lab = cond(`L'==1, lab_eng[`i'], lab_kor[`i'])
        if `pn'==3 local lab "\quad `lab'"
        file write FH "`lab' & `=sN[`i']' & `=smean[`i']' & `=ssd[`i']' & `=smin[`i']' & `=smax[`i']' \\" _n
    }
    file close FH
}
restore

* ---------- (3) T2: annual import volume and value by item (from Import_price) ----------
preserve
use Import_price, clear
drop if q_item=="포도"
quietly tab q_item
assert r(r)==41
quietly sum time
assert r(min)==732 & r(max)==782
* Four-quadrant audit (for reporting — detects changes when the data are regenerated)
count if volume>0 & volume<. & missing(totalvalue)
di as txt "AUDIT quadrant: volume>0 & value missing = " r(N)
count if volume==0 & totalvalue<. & totalvalue>0
di as txt "AUDIT quadrant: volume==0 & value>0     = " r(N)
* Assert vector equality for the shared-HSK pairs (exactly 5 pairs; no other items share totals)
tempfile impraw
save `impraw'
foreach p in "미나리 콩나물" "방울토마토 토마토" "배추 얼갈이배추" "붉은고추 풋고추" "파프리카 피망" {
    local a : word 1 of `p'
    local b : word 2 of `p'
    use `impraw', clear
    keep if inlist(q_item, "`a'", "`b'")
    keep q_item loc time volume totalvalue
    gen byte isA = (q_item=="`a'")
    drop q_item
    reshape wide volume totalvalue, i(loc time) j(isA)
    count if volume1 != volume0
    assert r(N)==0
    count if totalvalue1 != totalvalue0 & !(missing(totalvalue1) & missing(totalvalue0))
    assert r(N)==0
}
use `impraw', clear
collapse (sum) volume totalvalue, by(q_item)
duplicates tag volume totalvalue, gen(_dupsig)
count if _dupsig>0
assert r(N)==10
* Annual aggregation (double precision; missing totalvalue = counted as 0)
use `impraw', clear
gen int year = year(dofm(time))
gen double vol_d = volume
gen double val_d = totalvalue
bysort q_item year: egen double volsum = total(vol_d)
bysort q_item year: egen double valsum = total(val_d)
bysort q_item year (time): keep if _n==1
keep q_item year volsum valsum
* Raw-unit CSV (kg, USD)
export delimited q_item year volsum valsum using "sumstat_T2_res.csv", replace
reshape wide volsum valsum, i(q_item) j(year)
merge 1:1 q_item using `itemmap'
assert _merge==3
drop _merge
gen eng_lower = lower(eng_name)
* Display: tons (1 decimal; exact 0="0", positive below 50kg="0.0") / thousand USD (integer; 0="0")
forvalues y = 2021/2025 {
    gen str15 sv`y' = cond(volsum`y'==0, "0", trim(string(volsum`y'/1000, "%15.1fc")))
    gen str15 sm`y' = cond(valsum`y'==0, "0", trim(string(valsum`y'/1000, "%15.0fc")))
}
gen str80 skey2 = ""
forvalues L = 1/2 {
    local lang = cond(`L'==1, "eng", "kor")
    replace skey2 = string(cat) + "_" + cond(`L'==1, eng_lower, q_item)
    sort skey2
    * Split into import volume (FV) and value (FM) tables — 6 columns each (item + 5 years). Category headers identical in both.
    file open FV using "sumstat_T2vol_`lang'.tex", write replace text
    file open FM using "sumstat_T2val_`lang'.tex", write replace text
    local curcat = 0
    forvalues i = 1/`=_N' {
        local cc = cat[`i']
        if `cc' != `curcat' {
            local curcat = `cc'
            if `L'==1 {
                if `cc'==1 local ch "Treated: leafy and root vegetables"
                if `cc'==2 local ch "Treated: fruits"
                if `cc'==3 local ch "Never-treated: vegetables and other crops"
                if `cc'==4 local ch "Never-treated: fruits"
            }
            else {
                if `cc'==1 local ch "처치: 엽채류·근채류"
                if `cc'==2 local ch "처치: 과일류"
                if `cc'==3 local ch "Never-treated: 채소 및 기타 작물"
                if `cc'==4 local ch "Never-treated: 과일류"
            }
            file write FV "\multicolumn{6}{l}{`ch'} \\" _n
            file write FM "\multicolumn{6}{l}{`ch'} \\" _n
        }
        local nm = cond(`L'==1, eng_name[`i'], q_item[`i'])
        local pm = pairmark[`i']
        if "`pm'" != "" local nm "`nm'\(^{`pm'}\)"
        file write FV "\quad `nm' & `=sv2021[`i']' & `=sv2022[`i']' & `=sv2023[`i']' & `=sv2024[`i']' & `=sv2025[`i']' \\" _n
        file write FM "\quad `nm' & `=sm2021[`i']' & `=sm2022[`i']' & `=sm2023[`i']' & `=sm2024[`i']' & `=sm2025[`i']' \\" _n
    }
    file close FV
    file close FM
}
restore

* ---------- (4) Restore state ----------
use m4, clear
di as res "SUMSTAT_DONE"
//! Summary statistics block [END]
// #er




// #sr Correlation between government releases and Quota Tariff status
* (A) Correlations of releases and WTO-TRQ with Quota Tariff status — the numbers cited in the paper's "Confounding Effects" section
* Requires rangestat. Output: corr_confounders_res.csv (pooled/within/within_rel3 correlation matrices + counts)
use m4, clear
* Grapes are dropped from the whole sample (41-item regime) — 11 treated items
keep if inlist(q_item,"배추","양배추","무","당근","양파","대파")|inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
quietly tab q_item
assert r(r)==11
assert !missing(TRQD, BaseTax, release, WTO_increase, WTO_bite)

* Quota Tariff side
gen byte   QT      = TRQD
gen double QTdepth = 0
replace    QTdepth = max(BaseTax - TRQ, 0) if TRQD==1

* Release side — same-month indicator
gen byte   rel_any_now = (release > 0)
gen double rel_ihs_now = asinh(release)

* Release side — regression form (mean over the completed-month window [t-130,-31]; same as the LP-DiD do files)
sort qcode date
rangestat (mean) release, interval(date -130 -31) by(qcode)
replace release_mean = 0 if missing(release_mean)
gen byte   rel_any = (release_mean > 0)
gen double rel_ihs = asinh(release_mean)
drop release_mean

* Pooled correlations
correlate QT QTdepth rel_any_now rel_ihs_now rel_any rel_ihs WTO_increase WTO_bite
matrix C_pooled = r(C)
local N_pooled = r(N)

* Within-product correlations (item demeaned)
foreach v in QT QTdepth rel_any_now rel_ihs_now rel_any rel_ihs WTO_increase WTO_bite {
    egen double m_`v' = mean(`v'), by(qcode)
    gen  double w_`v' = `v' - m_`v'
}
correlate w_QT w_QTdepth w_rel_any_now w_rel_ihs_now w_rel_any w_rel_ihs w_WTO_increase w_WTO_bite
matrix C_within = r(C)
local N_within = r(N)

* Extra: within correlations for the 3 stockpiled items only (removes dilution from the 9 zero-variance items)
correlate w_QT w_rel_any_now w_rel_ihs_now w_rel_any w_rel_ihs if inlist(q_item,"양파","배추","무")
matrix C_rel3 = r(C)
local N_rel3 = r(N)

* Note: significance output is for the log only — not cited in the text
pwcorr QT rel_any_now rel_ihs_now WTO_increase WTO_bite, sig

* Counts used in the text
count if QT==1
local n_QT1 = r(N)
count if QT==1 & rel_any_now==1
local n_QT1_rel = r(N)
count if QT==1 & WTO_increase>0
local n_QT1_wto = r(N)
count if QT==1 & inlist(q_item,"양파","배추","무")
local n_QT1_rel3grp = r(N)
tab q_item if WTO_TRQ==1
tab q_item QT

* Export CSV (pooled/within/within_rel3 correlation matrices + counts)
* svmat names within-matrix columns w_*, so rename w_* * to align the schema
* with pooled before appending (w_/w3_ prefixes remain only in the rowvar strings).
clear
svmat double C_pooled, names(col)
gen sample = "pooled"
gen rowvar = ""
local i = 0
foreach v in QT QTdepth rel_any_now rel_ihs_now rel_any rel_ihs WTO_increase WTO_bite {
    local ++i
    replace rowvar = "`v'" in `i'
}
tempfile pooled
save `pooled'
clear
svmat double C_within, names(col)
rename w_* *
gen sample = "within"
gen rowvar = ""
local i = 0
foreach v in QT QTdepth rel_any_now rel_ihs_now rel_any rel_ihs WTO_increase WTO_bite {
    local ++i
    replace rowvar = "w_`v'" in `i'
}
tempfile within
save `within'
clear
svmat double C_rel3, names(col)
rename w_* *
gen sample = "within_rel3"
gen rowvar = ""
local i = 0
foreach v in QT rel_any_now rel_ihs_now rel_any rel_ihs {
    local ++i
    replace rowvar = "w3_`v'" in `i'
}
append using `within'
append using `pooled'
assert _N==21
gen N_pooled = `N_pooled'
gen N_within = `N_within'
gen N_rel3 = `N_rel3'
gen n_QT1 = `n_QT1'
gen n_QT1_rel = `n_QT1_rel'
gen n_QT1_wto = `n_QT1_wto'
gen n_QT1_rel3grp = `n_QT1_rel3grp'
order sample rowvar
export delimited using "corr_confounders_res.csv", replace

// #er


// #sr Releases and WTO-TRQ increases at Quota Tariff onset months
* (B) Small table: release/WTO-increase status in each unique onset month of m1 — the onset figures cited in the paper
* Output: corr_onset_coincide.csv (release and WTO_increase status in the month of each of the 11 onsets)
use m1, clear
keep if inlist(q_item,"배추","양배추","무","당근","양파","대파")|inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
xtset qcode date
gen byte onset = (L.TRQD==0 & TRQD==1)
keep if onset==1
assert _N==11
gen byte rel_any_now = (release > 0)
gen byte wto_now = (WTO_increase > 0)
format date %tdCCYY-NN-DD
list q_item date release rel_any_now WTO_increase wto_now, noobs clean
count
count if rel_any_now==1
count if wto_now==1
export delimited q_item date release rel_any_now WTO_increase wto_now ///
    using "corr_onset_coincide.csv", replace

// #er


// #sr How to generate Paper Table 4 (p.41): LP-DiD estimates at selected horizons
* The 12 regressions in QuotaTariff_table_eng.tex are not run by main.do. They come from the four
* LP-DiD do files (LPseparate_{G,noG}m4_CV1(95)ct{,_impulse}.do) reduced to the selected horizons
* (base h=150 / impulse h=150 and 250) by make_variants.py. Run in a local build folder such as
* C:\build\tabh (not inside a cloud-synced folder):
*   1) copy m4.dta into C:\build\tabh
*   2) python make_variants.py       (writes var_Gbase / var_noGbase / var_Gimpulse / var_noGimpulse.do)
*   3) write a one-line Stata runner for each variant, e.g. run_Gbase.do containing:
*        capture noisily do "var_Gbase.do"
*      and run it in batch mode ("StataMP-64.exe" /e do run_Gbase.do) — batch mode logs to
*      run_Gbase.log automatically, so do not add a log using line. Each writes its tabh_*.csv.
*   4) python finalize.py            (combines tabh_*.csv -> table_regressions.csv + intensity_by_item.csv;
*                                     the copy shipped here accepts the GRAPE_OUT/GRAPE_SRC environment variables)
*   5) python generate_tables.py     (table_regressions.csv -> QuotaTariff_table_eng.tex)
* The intensity_by_item.csv from step 4 also underlies Paper Table 3 (p.29).
// #er


// #sr How to generate Paper Figures 3-4 (pp.33-34): pre-designation price dynamics
* These two figures come from the AshenfelterDip pipeline shipped with this package, not from
* main.do. Run inside the AshenfelterDip folder (all paths are relative):
*   1) copy m4.dta into that folder as AD_m4.dta
*   2) run runme_prep.do in Stata                     (AD_prep.do -> AD_g1.dta / AD_g2.dta)
*   3) run runme2_V2p_g1.do, runme2_V2p_g2.do, runme2_V3_g1.do, runme2_V3_g2.do
*      (AD_pre_core2.do -> the four AD_pre_V*_res.csv files the figures use)
*   4) python AD_stack.py                             (event-time stacked aggregation CSVs)
*   5) run runme_fig2.do and runme_stackfig2.do       (export the figure PNGs)
* Expect roughly 15-20 minutes in total; the V3 runs are the slowest.
// #er







// #sr Export input data (t3.dta) for Paper Table 1 (p.10): Quota Tariff Treatment Status
use m4, clear  
keep q_item date TRQD
keep if inlist(q_item,"배추","양배추","무","당근","양파","대파")|inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
save t1, replace 

use m4, clear 
keep if inlist(q_item,"배추","양배추","무","당근","양파","대파")|inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
//keep if date <= mdy(3,31,2025)
keep q_item date TRQD 
tempfile original
save `original'

* Create the full set of all item-date combinations
* 1. Item list
preserve
    keep q_item
    duplicates drop
    tempfile items_list
    save `items_list'
restore

* 2. Date list (2022-01-01 to 2025-08-31)
clear
local start_date = mdy(1,1,2022)
local end_date = mdy(8,31,2025)
local n_days = `end_date' - `start_date' + 1

set obs `n_days'
gen date = `start_date' + _n - 1
format date %td
tempfile dates_list
save `dates_list'

* 3. Cross join (all combinations)
use `items_list', clear
cross using `dates_list'

* 4. Merge with the original data
merge 1:1 q_item date using `original', nogen keep(1 3)

drop TRQD
merge 1:1 q_item date using t1
keep q_item date TRQD _merge
order q_item date TRQD _merge
sort q_item date
keep if inrange(date,mdy(1,1,2022),mdy(8,31,2025))
save t2, replace 


use t2, clear
replace TRQD=0 if TRQD==.
//! m1/m2/m4 only run through 2025-03-31 (the possible cutoff); the extension below is manual and used only for this table
replace TRQD=1 if q_item=="배추"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))
replace TRQD=1 if q_item=="양배추"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))
replace TRQD=1 if q_item=="무"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))
replace TRQD=1 if q_item=="당근"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))
replace TRQD=1 if q_item=="망고"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
replace TRQD=1 if q_item=="바나나"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
replace TRQD=1 if q_item=="아보카도"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
replace TRQD=1 if q_item=="파인애플"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
gen time = string(date, "%tdCCYY-NN-DD")
drop _merge date
save t3, replace 

* Final step (Python): place t3.dta next to create_tariff_table_largefont_eng.py (shipped in
* this package) and run it to render the Table 1 image (할당관세적용표_eng.png).
// #er 


// #sr How to generate Paper Figures 5-8 (pp.35-39): LP-DiD graphs
* Each figure is produced by one do file shipped with this package (set the global path first):
* (Each run takes ~12 hours. Comment out the four do lines below to skip them on a quick pass.)
*   Figure 5 (p.35): 
do "LPseparate_noGm4_CV1(95)ct"
*   Figure 6 (p.36): 
do "LPseparate_noGm4_CV1(95)ct_impulse"
*   Figure 7 (p.37): 
do "LPseparate_Gm4_CV1(95)ct"
*   Figure 8 (p.39): 
do "LPseparate_Gm4_CV1(95)ct_impulse"
* Each run takes roughly 12 hours and exports the PNG plus a *_res.csv holding the estimates
* for every horizon — these CSVs are the "underlying estimates retained in the replication files"
* mentioned in the paper, and they ship with this package.
// #er






















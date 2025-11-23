

cd "${path}"

//!================================================================
//! STATA 19
************************************************
** LP‑DiD: 두 그룹 분리 추정 + Intensity
************************************************
clear all
set more off
set matsize 11000, perm

* 필요시 설치
capture which rangestat
if _rc ssc install rangestat, replace

* 데이터 로드
use m4, clear
xtset qcode date, daily

* 공통 설정
local Hpre  = 500
local Hpost = 273

* 안전: 열려있는 post 핸들 정리
capture noisily postutil clear

* 원본 백업
tempfile base
save "`base'", replace

************************************************
** 공통 전처리 루틴: 강도·컨트롤 지표 생성
** 호출 전: d, TRQD, qcode, date, s_price 존재 가정
************************************************
capture program drop _lp_common_prep
program define _lp_common_prep
    args groupnum
    tsset qcode date, daily

    local group1 `" "배추","양배추","무","양파","당근" "'
    local group2 `" "체리","참다래","아보카도","망고","바나나","파인애플" "'

    gen byte d = 0
    if "`groupnum'"=="1" {
        * 처리그룹: 단일 그룹(d==1)
        replace d = 1 if inlist(q_item,`group1')
        drop if inlist(q_item,`group2')
        replace TRQD=0 if d==0
    }
    else if "`groupnum'"=="2" {
        * 처리그룹: 단일 그룹(d==1)
        replace d = 1 if inlist(q_item,`group2')
        drop if inlist(q_item,`group1')
        replace TRQD=0 if d==0
    }

    * 이벤트/상대시점(강도 계산 참고지표)
    gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
    by qcode: egen TRQstart = mean(flag)
    gen rtime = date - TRQstart

    * Import = total_import but constant if rtime>=0
    gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
    by qcode: egen double total_import100 = mean(total_import100_temp)
    replace total_import= total_import100 if d==1&rtime>=0
	by qcode: egen double total_import_mean = mean(total_import)
	gen import=total_import/total_import_mean

    * 로그 변환
    replace s_price = ln(s_price)
    replace d_price = ln(d_price)
    replace i_price = ln(i_price)

    * 기후변수 rangestat 
    foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
        rangestat (mean) `var', interval(date -100 0) by(qcode)
        drop `var'
        rename `var'_mean `var'
    }

    * 이벤트 시 강도(처리그룹만)
    gen double TRQall_temp = TRQ if flag<. & d==1
    by qcode: egen double TRQall = mean(TRQall_temp)
    gen double intensity_temp = (BaseTax - TRQall) if d==1
    replace intensity_temp = 0 if intensity_temp < 0
    sort qcode rtime
    rangestat (mean) intensity_temp, interval(rtime -365 0) by(qcode)
    gen intensity_temp2 = intensity_temp_mean if flag<. & d==1
    by qcode: egen double intensity = mean(intensity_temp2)
    drop intensity_temp intensity_temp2
    replace intensity = 0 if missing(intensity)

    ************************************************
    * Clean control 판별을 위한 보조지표 (전 기간 기준)
    ************************************************
    * ever treated (전 기간 중 TRQD==1이 있었는지)
    by qcode: egen byte ever_tr = max(TRQD)
    gen byte never_tr = (ever_tr==0)            // 전 기간 TRQD==0인 품목
    label var never_tr "Never treated across full sample"

    * t 이전 처리 이력 여부(비흡수/반복 처리를 안전하게 배제)
    bysort qcode (date): gen long cum_tr = sum(TRQD)
    gen byte prev_treated = (L.cum_tr > 0)      // t 이전에 한 번이라도 TRQD==1
    replace prev_treated = 0 if missing(prev_treated)
end

************************************************
** Group 1
************************************************
use "`base'", clear
quietly _lp_common_prep 1
tempfile g1base
save "`g1base'", replace

tempfile res1
tempname post1
postfile `post1' int h long N_all1 N_T1 N_ctrl1 ///
    double LP1 lb1 ub1 using "`res1'", replace

forvalues h = -`Hpre'/`Hpost' {
    di as txt "===== Group 1  //  h = `h' ====="
    use "`g1base'", clear
    tsset qcode date, daily

    tempvar ev dY dX dI tmax
    gen byte `ev' = (L.TRQD==0 & TRQD==1)

    * 좌변 Δ^h y := y_{t+h} - y_{t-1}
    if `h'==0 {
        gen double `dY' = s_price - L.s_price
        gen double `dX' = d_price - L.d_price

        * clean control (h=0): t 이전 미처리 & t 시점 미처리
        local ctrlcond "prev_treated==0 & TRQD==0"
    }
    else if `h'>0 {
        gen double `dY' = F`h'.s_price - L.s_price
        gen double `dX' = F`h'.d_price - L.d_price

        * [t+1, t+h] 구간에 처리 발생 여부 확인: rangestat으로 max(TRQD) 계산
        * (구간에 1이 있으면 max=1 → control에서 배제)
        quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
        rename TRQD_max `tmax'
        * clean control (h>0):
        *  1) t 이전 미처리(prev_treated==0)
        *  2) t 시점 미처리(TRQD==0)
        *  3) [t+1, t+h] 미처리(TRQD_max==0)
        * (TRQD_max는 rangestat이 생성하는 변수명)
        replace `tmax' = 0 if missing(`tmax')
        local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
    }
    else if `h' == -1 {
        * 필요하면 관측 수만 기록하고 계수는 0 또는 missing으로 두기
        count
        local Nall = r(N)
        count if `ev'==1 & d==1
        local NT = r(N)
        count if prev_treated==0 & TRQD==0
        local Nc = r(N)

        post `post1' (`h') (`Nall') (`NT') (`Nc') (0) (0) (0)
        continue
    }
    else {
        local k = -`h'
        gen double `dY' = L`k'.s_price - L.s_price
        gen double `dX' = L`k'.d_price - L.d_price

        * clean control (h<0, 요청사항 엄격 적용):
        * not‑yet‑treated, 즉 향후에 처리될 예정이든 말든 상관없음. never treated는 선택적(보다 엄격) 옵션일 뿐, 표준은 not‑yet입니다.
        //local ctrlcond "never_tr==1"
        local ctrlcond "prev_treated==0 & TRQD==0"
    }

    * 클린 컨트롤: 신규처리 vs (위에서 정의한) clean control
    keep if ((`ev'==1 & d==1) | (`ctrlcond'))
    drop if missing(`dY')
    drop if missing(`dX')

    count
    local Nall = r(N)
    count if `ev'==1 & d==1
    local NT = r(N)
    count if `ctrlcond'
    local Nc = r(N)

    if (`Nall'==0 | `NT'==0 | `Nc'==0) {
        post `post1' (`h') (`Nall') (`NT') (`Nc') (. ) (. ) (. )
    }
    else {
        gen double shock = intensity*`ev'*(d==1)
        quietly reg `dY' shock i.date BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours, vce(cluster qcode)   
        post `post1' (`h') (`Nall') (`NT') (`Nc') ///
            (_b[shock]) (_b[shock]-1.959964*_se[shock]) (_b[shock]+1.959964*_se[shock])
    }
}
postclose `post1'

************************************************
** Group 2
************************************************
use "`base'", clear
quietly _lp_common_prep 2
tempfile g2base
save "`g2base'", replace

tempfile res2
tempname post2
postfile `post2' int h long N_all2 N_T2 N_ctrl2 ///
    double LP2 lb2 ub2 using "`res2'", replace

forvalues h = -`Hpre'/`Hpost' {
    di as txt "===== Group 2  //  h = `h' ====="
    use "`g2base'", clear
    tsset qcode date, daily

    tempvar ev dY dX dI tmax
    gen byte `ev' = (L.TRQD==0 & TRQD==1)

    * 좌변 Δ^h y := y_{t+h} - y_{t-1}
    if `h'==0 {
        gen double `dY' = s_price - L.s_price
        gen double `dX' = d_price - L.d_price

        * clean control (h=0): t 이전 미처리 & t 시점 미처리
        local ctrlcond "prev_treated==0 & TRQD==0"
    }
    else if `h'>0 {
        gen double `dY' = F`h'.s_price - L.s_price
        gen double `dX' = F`h'.d_price - L.d_price

        * [t+1, t+h] 구간에 처리 발생 여부 확인: rangestat으로 max(TRQD) 계산
        * (구간에 1이 있으면 max=1 → control에서 배제)
        quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
        rename TRQD_max `tmax'
        * clean control (h>0):
        *  1) t 이전 미처리(prev_treated==0)
        *  2) t 시점 미처리(TRQD==0)
        *  3) [t+1, t+h] 미처리(TRQD_max==0)
        * (TRQD_max는 rangestat이 생성하는 변수명)
        replace `tmax' = 0 if missing(`tmax')
        local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
    }
    else if `h' == -1 {
        * 필요하면 관측 수만 기록하고 계수는 0 또는 missing으로 두기
        count
        local Nall = r(N)
        count if `ev'==1 & d==1
        local NT = r(N)
        count if prev_treated==0 & TRQD==0
        local Nc = r(N)

        post `post2' (`h') (`Nall') (`NT') (`Nc') (0) (0) (0)
        continue
    }
    else {
        local k = -`h'
        gen double `dY' = L`k'.s_price - L.s_price
        gen double `dX' = L`k'.d_price - L.d_price

        * clean control (h<0, 요청사항 엄격 적용):
        * not‑yet‑treated, 즉 향후에 처리될 예정이든 말든 상관없음. never treated는 선택적(보다 엄격) 옵션일 뿐, 표준은 not‑yet입니다.
        //local ctrlcond "never_tr==1"
        local ctrlcond "prev_treated==0 & TRQD==0"
    }

    * 클린 컨트롤: 신규처리 vs (위에서 정의한) clean control
    keep if ((`ev'==1 & d==1) | (`ctrlcond'))
    drop if missing(`dY')
    drop if missing(`dX')

    count
    local Nall = r(N)
    count if `ev'==1 & d==1
    local NT = r(N)
    count if `ctrlcond'
    local Nc = r(N)

    if (`Nall'==0 | `NT'==0 | `Nc'==0) {
        post `post2' (`h') (`Nall') (`NT') (`Nc') (. ) (. ) (. )
    }
    else {
        gen double shock = intensity*`ev'*(d==1)
        quietly reg `dY' shock i.date BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours, vce(cluster qcode)   
        post `post2' (`h') (`Nall') (`NT') (`Nc') ///
            (_b[shock]) (_b[shock]-1.959964*_se[shock]) (_b[shock]+1.959964*_se[shock])
    }
}
postclose `post2'

************************************************
** 두 그룹 결과 병합 및 단일 그래프
************************************************
use "`res1'", clear
sort h
merge 1:1 h using "`res2'", nogen

label var h   "h"
label var LP1 "β(h): 처리그룹1"
label var LP2 "β(h): 처리그룹2"

twoway ///
    (rarea ub1 lb1 h, color(navy%25)   lcolor(navy%60)) ///
    (rarea ub2 lb2 h, color(maroon%25) lcolor(maroon%60)) ///
    (line  LP1 h,   lwidth(medthick)    lcolor(navy)) ///
    (line  LP2 h,   lpattern(shortdash) lwidth(medthick) lcolor(maroon)), ///
    xlabel(-`Hpre'(50)`Hpost') xscale(range(-`Hpre' `Hpost')) ///
    xtitle("h (상대시점, 일)") ///
    ytitle("Log 소매가격 반응 (강도 1%p당)") ///
    legend(order(3 "처치그룹1" 4 "처치그룹2") pos(6) ring(0)) ///
    yline(0) xline(-1)
graph export LPseparateMAX파양_Gm4.png, replace width(3000)

twoway ///
    (rarea ub1 lb1 h, color(navy%25)   lcolor(navy%60)) ///
    (rarea ub2 lb2 h, color(maroon%25) lcolor(maroon%60)) ///
    (line  LP1 h,   lwidth(medthick)    lcolor(navy)) ///
    (line  LP2 h,   lpattern(shortdash) lwidth(medthick) lcolor(maroon)), ///
    xlabel(-`Hpre'(50)`Hpost') xscale(range(-`Hpre' `Hpost')) ///
    xtitle("h (Relative Days)") ///
    ytitle("Log Retail Price Response (per 1%p Intensity)") ///
    legend(order(3 "Treated Group 1" 4 "Treated Group 2") pos(6) ring(0)) ///
    yline(0) xline(-1)
graph export LPseparateMAX파양_Gm4_eng.png, replace width(3000)





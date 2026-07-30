

cd "C:/build/tabh"

************************************************
** LP-DiD: separate estimation for the two groups, without intensity
************************************************
clear all
set more off
set matsize 11000, perm

* Install if needed
capture which rangestat
if _rc ssc install rangestat, replace
capture which boottest
if _rc ssc install boottest, replace

* Default = CV1 (normal-approximation cluster CI). Set usewb=1 for wild bootstrap (unstable in the tails).
local usewb  = 0
local wbreps = 999
* The k=120 and PMD-120 parameters are set inside _lp_common_prep (locals cleank/pmdw).

* Load the data
use m4, clear
* Grapes are dropped from the whole sample (41 items: 6 treated vegetables, 5 treated fruits, 30 others) — counted as neither ever- nor never-treated.
assert q_item!="" & q_item!="포도"
preserve
keep q_item
duplicates drop
assert _N==41
quietly count if inlist(q_item,"배추","양배추","무","당근","양파","대파")
assert r(N)==6
quietly count if inlist(q_item,"망고","참다래","바나나","아보카도","파인애플")
assert r(N)==5
restore
xtset qcode date, daily

* Common settings
local Hpre  = 500
local Hpost = 273
* Graph cutoff = 150 (the plot shows horizons up to 150 days).
*   The spike starts at h=156 (the cabbage event exits, N_T 5->4); k=155 was the largest admissible cutoff, and 150 was adopted to be conservative.
local Hcut  = 150

* Safety: close any open post handles
capture noisily postutil clear

* Back up the data in memory
tempfile base
save "`base'", replace

************************************************
** Shared preprocessing routine: intensity and control indicators
************************************************
capture program drop _lp_common_prep
program define _lp_common_prep
    args groupnum
    * Parameters: the clean-treated window (cleank) and the PMD base window (pmdw), kept in sync.
    local cleank = 120
    local pmdw   = 120
    tsset qcode date, daily

    local group1 `" "배추","양배추","무","당근","양파","대파" "'
    local group2 `" "망고","참다래","바나나","아보카도","파인애플" "'

    gen byte d = 0
    if "`groupnum'"=="1" {
        replace d = 1 if inlist(q_item,`group1')
        drop if inlist(q_item,`group2')
        replace TRQD=0 if d==0
    }
    else if "`groupnum'"=="2" {
        replace d = 1 if inlist(q_item,`group2')
        drop if inlist(q_item,`group1')
        replace TRQD=0 if d==0
    }

    * Bridge treatment gaps of 30 days or less (administrative gaps from year-end decree carryover) — treatment-path definition step
    sort qcode date
    by qcode: gen long _spell = sum(TRQD != TRQD[_n-1] | _n==1)
    by qcode: egen long _maxsp = max(_spell)
    bysort qcode _spell (date): gen long _slen = _N
    sort qcode date
    gen byte _bridge = (TRQD==0 & _slen<=30 & _spell>1 & _spell<_maxsp)
    replace TRQD = 1 if _bridge
    drop _spell _maxsp _slen _bridge

    * Events and relative time (reference indicators for the intensity calculation)
    gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
    by qcode: egen TRQstart = mean(flag)
    gen rtime = date - TRQstart

    * Import = total_import but constant if rtime>=0
    gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
    by qcode: egen double total_import100 = mean(total_import100_temp)
    replace total_import= total_import100 if d==1&rtime>=0
	by qcode: egen double total_import_mean = mean(total_import)
	gen import=total_import/total_import_mean

    * Log transform
    replace s_price = ln(s_price)
    replace d_price = ln(d_price)
    replace i_price = ln(i_price)

    * PMD-120 baseline: moving average of ln s_price over [t-120, t-1] (lpdid pmd(120))
    sort qcode date
    rangestat (mean) s_price, interval(date -`pmdw' -1) by(qcode)
    rename s_price_mean ybase

    * Climate variables via rangestat (100-day trailing means)
    foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
        rangestat (mean) `var', interval(date -100 0) by(qcode)
        drop `var'
        rename `var'_mean `var'
    }

    * Release controls: mean over the completed previous-month window [t-130, t-31] -> asinh + occurrence dummy
    *   A window including the current month would look ahead up to 30 days (an endogenous policy variable, i.e. a bad control) -> use the completed previous-month window.
    *   The first 31 sample days have no window -> 0 (unlisted = 0 convention). For the current-month alternative [t-100,0], edit the two lines below.
    rangestat (mean) release, interval(date -130 -31) by(qcode)
    replace release_mean = 0 if missing(release_mean)
    gen byte  rel_any = (release_mean > 0)
    gen double rel_ihs = asinh(release_mean)
    drop release_mean

    * LX: compute the L365 climate interactions as static variables on the full panel, before any keep
    *   (prevents early events from silently dropping at deep horizons when lag anchors vanish; keeps the treated-cluster count intact and the CIs finite)
    tsset qcode date, daily
    sort qcode date
    foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
        gen double L365_`var' = L365.`var'
    }

    * Intensity at the event (treated group only)
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
    * Auxiliary indicators for clean-control status (full-sample basis)
    ************************************************
    by qcode: egen byte ever_tr = max(TRQD)
    gen byte never_tr = (ever_tr==0)
    label var never_tr "Never treated across full sample"

    bysort qcode (date): gen long cum_tr = sum(TRQD)
    gen byte prev_treated = (L.cum_tr > 0)
    replace prev_treated = 0 if missing(prev_treated)

    * Clean-event test: any treatment within the previous 120 days (lpdid nonabsorbing(120))
    sort qcode date
    rangestat (max) TRQD, interval(date -`cleank' -1) by(qcode)
    rename TRQD_max prevtr120
    replace prevtr120 = 0 if missing(prevtr120)
end

* L365 climate terms in the regression (static variables)
local lterm "i.qcode#c.L365_temp_avg i.qcode#c.L365_humidity_avg i.qcode#c.L365_precipitation_daily i.qcode#c.L365_sunshine_hours"
* [TABH] table-number output file
capture file close _tabh
file open _tabh using "tabh_noGbase.csv", write replace
file write _tabh "spec,group,h,b,se,N,r2,r2_a,df_r,N_clust" _n

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

foreach h in 150 {
    di as txt "===== Group 1  //  h = `h' ====="
    use "`g1base'", clear
    tsset qcode date, daily

    tempvar ev dY tmax tmin
    gen byte `ev' = (L.TRQD==0 & TRQD==1)

    if `h'==0 {
        gen double `dY' = s_price - ybase
        local ctrlcond "prev_treated==0 & TRQD==0"
        gen byte `tmin' = 1
    }
    else if `h'>0 {
        gen double `dY' = F`h'.s_price - ybase
        quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
        rename TRQD_max `tmax'
        replace `tmax' = 0 if missing(`tmax')
        local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
        * Stay-on: a treated event must keep TRQD==1 throughout t..t+h
        quietly rangestat (min) TRQD, interval(date 0 `h') by(qcode)
        rename TRQD_min `tmin'
        replace `tmin' = 0 if missing(`tmin')
    }
    else {
        local k = -`h'
        gen double `dY' = L`k'.s_price - ybase
        local ctrlcond "prev_treated==0 & TRQD==0"
        gen byte `tmin' = 1
    }

    * Clean controls: new treatment (clean event) vs clean control (prevtr120==0)
    keep if ((`ev'==1 & d==1 & prevtr120==0 & `tmin'==1) | (`ctrlcond'))
    drop if missing(`dY')

    count
    local Nall = r(N)
    count if `ev'==1 & d==1 & prevtr120==0 & `tmin'==1
    local NT = r(N)
    count if `ctrlcond'
    local Nc = r(N)

    if (`Nall'==0 | `NT'==0 | `Nc'==0) {
        post `post1' (`h') (`Nall') (`NT') (`Nc') (. ) (. ) (. )
    }
    else {
        gen double shock = `ev'*(d==1)*(prevtr120==0)*(`tmin'==1)
        quietly reg `dY' shock i.date BaseTax rel_ihs rel_any WTO_TRQ WTO_increase WTO_bite i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours `lterm', vce(cluster qcode)
        local bb  = _b[shock]
        local ss  = _se[shock]
        local lbv = `bb' - 1.959964*`ss'
        local ubv = `bb' + 1.959964*`ss'
        * Wild cluster bootstrap CI only when usewb=1 (unstable in the tails)
        if `usewb' {
            capture boottest shock, cluster(qcode) weighttype(webb) reps(`wbreps') level(95) nograph seed(20260703)
            if _rc==0 {
                matrix WCI = r(CI)
                local lbv = WCI[1,1]
                local ubv = WCI[1,2]
            }
        }
        file write _tabh "noGbase,1,`h',`bb',`ss',`=e(N)',`=e(r2)',`=e(r2_a)',`=e(df_r)',`=e(N_clust)'" _n
        post `post1' (`h') (`Nall') (`NT') (`Nc') (`bb') (`lbv') (`ubv')
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

foreach h in 150 {
    di as txt "===== Group 2  //  h = `h' ====="
    use "`g2base'", clear
    tsset qcode date, daily

    tempvar ev dY tmax tmin
    gen byte `ev' = (L.TRQD==0 & TRQD==1)

    if `h'==0 {
        gen double `dY' = s_price - ybase
        local ctrlcond "prev_treated==0 & TRQD==0"
        gen byte `tmin' = 1
    }
    else if `h'>0 {
        gen double `dY' = F`h'.s_price - ybase
        quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
        rename TRQD_max `tmax'
        replace `tmax' = 0 if missing(`tmax')
        local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
        * Stay-on: a treated event must keep TRQD==1 throughout t..t+h
        quietly rangestat (min) TRQD, interval(date 0 `h') by(qcode)
        rename TRQD_min `tmin'
        replace `tmin' = 0 if missing(`tmin')
    }
    else {
        local k = -`h'
        gen double `dY' = L`k'.s_price - ybase
        local ctrlcond "prev_treated==0 & TRQD==0"
        gen byte `tmin' = 1
    }

    keep if ((`ev'==1 & d==1 & prevtr120==0 & `tmin'==1) | (`ctrlcond'))
    drop if missing(`dY')

    count
    local Nall = r(N)
    count if `ev'==1 & d==1 & prevtr120==0 & `tmin'==1
    local NT = r(N)
    count if `ctrlcond'
    local Nc = r(N)

    if (`Nall'==0 | `NT'==0 | `Nc'==0) {
        post `post2' (`h') (`Nall') (`NT') (`Nc') (. ) (. ) (. )
    }
    else {
        gen double shock = `ev'*(d==1)*(prevtr120==0)*(`tmin'==1)
        * Fruit regressions: drop the climate interactions (4 current + 4 L365), keep oil x item
        quietly reg `dY' shock i.date BaseTax rel_ihs rel_any WTO_TRQ WTO_increase WTO_bite i.qcode#c.oil_price, vce(cluster qcode)
        local bb  = _b[shock]
        local ss  = _se[shock]
        local lbv = `bb' - 1.959964*`ss'
        local ubv = `bb' + 1.959964*`ss'
        if `usewb' {
            capture boottest shock, cluster(qcode) weighttype(webb) reps(`wbreps') level(95) nograph seed(20260703)
            if _rc==0 {
                matrix WCI = r(CI)
                local lbv = WCI[1,1]
                local ubv = WCI[1,2]
            }
        }
        file write _tabh "noGbase,2,`h',`bb',`ss',`=e(N)',`=e(r2)',`=e(r2_a)',`=e(df_r)',`=e(N_clust)'" _n
        post `post2' (`h') (`Nall') (`NT') (`Nc') (`bb') (`lbv') (`ubv')
    }
}
postclose `post2'
* [TABH] close table-number file
file close _tabh

************************************************
** Combine the two groups' results into a single graph
************************************************
use "`res1'", clear
sort h
merge 1:1 h using "`res2'", nogen

label var h   "h"
label var LP1 "β(h): 처리그룹1"
label var LP2 "β(h): 처리그룹2"

export delimited using "LPseparate_noGm4_CV1(95)ct_res_TABHVAR.csv", replace

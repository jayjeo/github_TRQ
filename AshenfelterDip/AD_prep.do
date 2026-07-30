* AD_prep.do - build per-group analysis bases for AshenfelterDip pre-coefficient runs
* Machinery source: LPseparate_noGm4_CV1(95)ct.do (production) - _lp_common_prep copied verbatim.
* Data: AD_m4.dta = byte-identical copy of master m4.dta (MD5 F251A9EF9E3710CE5370574CDD5A35E2).
*       Uses the 41-item version (grapes removed from the whole sample); the previous version's MD5 was 8944CB12FDA2B6CAC291D8C39E92D822.
* Output: AD_g1.dta (vegetables base), AD_g2.dta (fruits base). Originals never modified.

clear all
set more off
set matsize 11000, perm

capture which rangestat
if _rc ssc install rangestat, replace

capture program drop _lp_common_prep
program define _lp_common_prep
    args groupnum
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

    * [R1/CT] bridge admin gaps of <=30 days in treatment path
    sort qcode date
    by qcode: gen long _spell = sum(TRQD != TRQD[_n-1] | _n==1)
    by qcode: egen long _maxsp = max(_spell)
    bysort qcode _spell (date): gen long _slen = _N
    sort qcode date
    gen byte _bridge = (TRQD==0 & _slen<=30 & _spell>1 & _spell<_maxsp)
    replace TRQD = 1 if _bridge
    drop _spell _maxsp _slen _bridge

    * event / relative time
    gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
    by qcode: egen TRQstart = mean(flag)
    gen rtime = date - TRQstart

    * Import = total_import but constant if rtime>=0
    gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
    by qcode: egen double total_import100 = mean(total_import100_temp)
    replace total_import= total_import100 if d==1&rtime>=0
    by qcode: egen double total_import_mean = mean(total_import)
    gen import=total_import/total_import_mean

    * log transform
    replace s_price = ln(s_price)
    replace d_price = ln(d_price)
    replace i_price = ln(i_price)

    * PMD-120 baseline: trailing mean of ln s_price over [t-120, t-1]
    sort qcode date
    rangestat (mean) s_price, interval(date -`pmdw' -1) by(qcode)
    rename s_price_mean ybase

    * climate: 100-day trailing means
    foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
        rangestat (mean) `var', interval(date -100 0) by(qcode)
        drop `var'
        rename `var'_mean `var'
    }

    * release covariates: completed-prior-month window [t-130, t-31]
    rangestat (mean) release, interval(date -130 -31) by(qcode)
    replace release_mean = 0 if missing(release_mean)
    gen byte  rel_any = (release_mean > 0)
    gen double rel_ihs = asinh(release_mean)
    drop release_mean

    * [FIX-5] L365 climate as static variables computed on full panel
    tsset qcode date, daily
    sort qcode date
    foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
        gen double L365_`var' = L365.`var'
    }

    * event intensity (treated group only)
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

    * clean-control auxiliaries
    by qcode: egen byte ever_tr = max(TRQD)
    gen byte never_tr = (ever_tr==0)
    label var never_tr "Never treated across full sample"

    bysort qcode (date): gen long cum_tr = sum(TRQD)
    gen byte prev_treated = (L.cum_tr > 0)
    replace prev_treated = 0 if missing(prev_treated)

    * clean event: no treatment in preceding 120 days
    sort qcode date
    rangestat (max) TRQD, interval(date -`cleank' -1) by(qcode)
    rename TRQD_max prevtr120
    replace prevtr120 = 0 if missing(prevtr120)
end

di as txt "AD_prep start  $S_DATE $S_TIME"

use AD_m4, clear
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
quietly _lp_common_prep 1
save AD_g1, replace

use AD_m4, clear
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
quietly _lp_common_prep 2
save AD_g2, replace

di as txt "AD_prep done  $S_DATE $S_TIME"

* AD_pre_core2.do - pre-horizon (h<0) LP-DiD binary (noG) coefficients, covariate ladder.
* Fast version of AD_pre_core.do: i.date replaced by areg absorb(date).
* Equivalence verified (AD_aregtest.do / runme_aregtest.log): b and cluster SE agree with
* reg i.date to ~1e-10 relative, and reproduce production CSV at h=-100 exactly.
* usage:  do "AD_pre_core2.do" <variant> <group>
*   variant in {V0, V1, V2, V2p, V3};  group in {1, 2}
* Output CSV columns: production convention N (pre-regression counts) + eN/r2 = e(N)/e(r2).

args variant group

local Hpre = 150
local vt "`variant'"
local g  "`group'"

local rhs_base "BaseTax rel_ihs rel_any WTO_TRQ WTO_increase WTO_bite i.qcode#c.oil_price"
local clim "i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365_temp_avg i.qcode#c.L365_humidity_avg i.qcode#c.L365_precipitation_daily i.qcode#c.L365_sunshine_hours"

local useFE = 1
local restrictV2p = 0
if "`vt'"=="V0" {
    local rhs ""
    local useFE = 0
}
else if "`vt'"=="V1" {
    local rhs ""
}
else if "`vt'"=="V2" {
    local rhs "`rhs_base'"
}
else if "`vt'"=="V2p" {
    local rhs "`rhs_base'"
    local restrictV2p = 1
}
else if "`vt'"=="V3" {
    local rhs "`rhs_base' `clim'"
}
else {
    di as err "unknown variant `vt'"
    exit 198
}

tempname P
postfile `P' int h long N_all N_T N_ctrl double LP lb ub eN r2 using "AD_tmp2_`vt'_g`g'.dta", replace

forvalues h = -`Hpre'/-1 {
    di as txt "===== `vt' g`g' h = `h' ===== $S_TIME"
    use AD_g`g', clear
    tsset qcode date, daily

    tempvar ev dY
    gen byte `ev' = (L.TRQD==0 & TRQD==1)
    local k = -`h'
    gen double `dY' = L`k'.s_price - ybase
    local ctrlcond "prev_treated==0 & TRQD==0"

    keep if ((`ev'==1 & d==1 & prevtr120==0) | (`ctrlcond'))
    drop if missing(`dY')

    if `restrictV2p' {
        keep if !missing(temp_avg) & !missing(humidity_avg) & !missing(precipitation_daily) & !missing(sunshine_hours) & !missing(L365_temp_avg) & !missing(L365_humidity_avg) & !missing(L365_precipitation_daily) & !missing(L365_sunshine_hours)
    }

    count
    local Nall = r(N)
    count if `ev'==1 & d==1 & prevtr120==0
    local NT = r(N)
    count if `ctrlcond'
    local Nc = r(N)

    if (`Nall'==0 | `NT'==0 | `Nc'==0) {
        post `P' (`h') (`Nall') (`NT') (`Nc') (.) (.) (.) (.) (.)
    }
    else {
        gen double shock = `ev'*(d==1)*(prevtr120==0)
        if `useFE' {
            quietly areg `dY' shock `rhs', absorb(date) vce(cluster qcode)
        }
        else {
            quietly reg `dY' shock, vce(cluster qcode)
        }
        local bb  = _b[shock]
        local ss  = _se[shock]
        local lbv = `bb' - 1.959964*`ss'
        local ubv = `bb' + 1.959964*`ss'
        local eNv = e(N)
        local r2v = e(r2)
        post `P' (`h') (`Nall') (`NT') (`Nc') (`bb') (`lbv') (`ubv') (`eNv') (`r2v')
    }
}
postclose `P'

use "AD_tmp2_`vt'_g`g'.dta", clear
gen str3 variant = "`vt'"
gen byte grp = `g'
sort h
export delimited using "AD_pre_`vt'_g`g'_res.csv", replace

di as txt "DONE `vt' g`g'  $S_DATE $S_TIME"

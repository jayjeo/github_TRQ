* AD_stackfig2.do (x range -120..30) — derived from AD_stackfig.do - paper-style rendering of the stacked event-time trajectories (raw variant)
* Input: AD_stack_m4_g1_agg.csv, AD_stack_m4_g2_agg.csv (from AD_stack.py)
* Output: AD_stackfig_veg(.png/_eng.png), AD_stackfig_fruit(.png/_eng.png), AD_stackfig_eng.png (combined)

clear all
set more off

foreach g in 1 2 {
    import delimited using "AD_stack_m4_g`g'_agg.csv", clear case(preserve)
    keep if variant == "raw"
    keep if k >= -120
    destring k treated control diff, replace force
    sort k
    tempfile s`g'
    save "`s`g''", replace
}

local c1 navy
local c2 maroon

* ---------- vegetables ----------
use "`s1'", clear
twoway ///
    (line treated k, lwidth(medthick) lcolor(`c1')) ///
    (line control k, lwidth(medthick) lcolor(gs4)) ///
    (line diff    k, lwidth(medthick) lcolor(blue) lpattern(shortdash)), ///
    xlabel(-120(20)20) xscale(range(-120 30)) xline(0, lcolor(black) lpattern(dash)) yline(0, lcolor(gs8)) ///
    xtitle("개시 상대시점 (일)") ytitle("ln(가격) − 개시 전 평균") ///
    title("처치 그룹1 (채소)") ///
    legend(order(1 "처치 이벤트" 2 "깨끗한 대조군" 3 "차이") pos(6) ring(0) rows(1)) ///
    name(sv_kor, replace)
graph export "AD_stackfig_veg.png", replace width(3000)

twoway ///
    (line treated k, lwidth(medthick) lcolor(`c1')) ///
    (line control k, lwidth(medthick) lcolor(gs4)) ///
    (line diff    k, lwidth(medthick) lcolor(blue) lpattern(shortdash)), ///
    xlabel(-120(20)20) xscale(range(-120 30)) xline(0, lcolor(black) lpattern(dash)) yline(0, lcolor(gs8)) ///
    xtitle("Days relative to onset") ytitle("ln(price) − pre-onset mean") ///
    title("Treated Group 1 (Vegetables)") ///
    legend(order(1 "Treated events" 2 "Clean controls" 3 "Difference") pos(6) ring(0) rows(1)) ///
    name(sv_eng, replace)
graph export "AD_stackfig_veg_eng.png", replace width(3000)

* ---------- fruits ----------
use "`s2'", clear
twoway ///
    (line treated k, lwidth(medthick) lcolor(`c2')) ///
    (line control k, lwidth(medthick) lcolor(gs4)) ///
    (line diff    k, lwidth(medthick) lcolor(red) lpattern(shortdash)), ///
    xlabel(-120(20)20) xscale(range(-120 30)) xline(0, lcolor(black) lpattern(dash)) yline(0, lcolor(gs8)) ///
    xtitle("개시 상대시점 (일)") ytitle("ln(가격) − 개시 전 평균") ///
    title("처치 그룹2 (과일)") ///
    legend(order(1 "처치 이벤트" 2 "깨끗한 대조군" 3 "차이") pos(6) ring(0) rows(1)) ///
    name(sf_kor, replace)
graph export "AD_stackfig_fruit.png", replace width(3000)

twoway ///
    (line treated k, lwidth(medthick) lcolor(`c2')) ///
    (line control k, lwidth(medthick) lcolor(gs4)) ///
    (line diff    k, lwidth(medthick) lcolor(red) lpattern(shortdash)), ///
    xlabel(-120(20)20) xscale(range(-120 30)) xline(0, lcolor(black) lpattern(dash)) yline(0, lcolor(gs8)) ///
    xtitle("Days relative to onset") ytitle("ln(price) − pre-onset mean") ///
    title("Treated Group 2 (Fruits)") ///
    legend(order(1 "Treated events" 2 "Clean controls" 3 "Difference") pos(6) ring(0) rows(1)) ///
    name(sf_eng, replace)
graph export "AD_stackfig_fruit_eng.png", replace width(3000)

graph combine sv_eng sf_eng, cols(2) xsize(11) ysize(4.5) iscale(1.05)
graph export "AD_stackfig_eng.png", replace width(3600)

di as txt "AD_stackfig done  $S_DATE $S_TIME"

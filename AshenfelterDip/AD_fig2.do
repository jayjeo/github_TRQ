* AD_fig2.do (x range -120..0, corrected legends)  — derived from AD_fig.do - final pre-coefficient comparison figures (without vs with climate covariates)
* Panels: vegetables (V2p vs V3) and fruits (V2p vs V3), h in [-150,-1], 95% CI bands.
* V2p = no-climate RHS on the V3 estimation sample; V3 = production vegetable spec.
* Outputs: AD_precoef_veg(.png/_eng.png), AD_precoef_fruit(.png/_eng.png), AD_precoef_eng.png (combined)

clear all
set more off

* ---------- build merged data ----------
foreach g in 1 2 {
    import delimited using "AD_pre_V2p_g`g'_res.csv", clear case(preserve)
    keep h LP lb ub
    rename (LP lb ub) (LP_nc lb_nc ub_nc)
    tempfile nc`g'
    save "`nc`g''", replace

    import delimited using "AD_pre_V3_g`g'_res.csv", clear case(preserve)
    keep h LP lb ub
    rename (LP lb ub) (LP_c lb_c ub_c)
    merge 1:1 h using "`nc`g''", nogen
    keep if h >= -120
    sort h
    tempfile m`g'
    save "`m`g''", replace
}

* ---------- vegetables ----------
use "`m1'", clear
twoway ///
    (rarea ub_nc lb_nc h, color(gs10%40) lcolor(gs8%60)) ///
    (rarea ub_c  lb_c  h, color(navy%25) lcolor(navy%60)) ///
    (line  LP_nc h, lwidth(medthick) lcolor(gs4) lpattern(solid)) ///
    (line  LP_c  h, lwidth(medthick) lcolor(navy) lpattern(shortdash)), ///
    xlabel(-120(20)0) xscale(range(-120 0)) ///
    xtitle("h (상대시점, 일)") ytitle("Log 소매가격 반응 (할당관세적용시)") ///
    title("처치 그룹1 (채소)") ///
    legend(order(3 "기후 통제변수 없음" 4 "기후 통제변수 있음") pos(6) ring(0)) ///
    yline(0) name(veg_kor, replace)
graph export "AD_precoef_veg.png", replace width(3000)

twoway ///
    (rarea ub_nc lb_nc h, color(gs10%40) lcolor(gs8%60)) ///
    (rarea ub_c  lb_c  h, color(navy%25) lcolor(navy%60)) ///
    (line  LP_nc h, lwidth(medthick) lcolor(gs4) lpattern(solid)) ///
    (line  LP_c  h, lwidth(medthick) lcolor(navy) lpattern(shortdash)), ///
    xlabel(-120(20)0) xscale(range(-120 0)) ///
    xtitle("h (Relative Days)") ytitle("Log Retail Price Response (under Quota Tariff)") ///
    title("Treated Group 1 (Vegetables)") ///
    legend(order(3 "Without climate covariates" 4 "With climate covariates") pos(6) ring(0)) ///
    yline(0) name(veg_eng, replace)
graph export "AD_precoef_veg_eng.png", replace width(3000)

* ---------- fruits ----------
use "`m2'", clear
twoway ///
    (rarea ub_nc lb_nc h, color(gs10%40) lcolor(gs8%60)) ///
    (rarea ub_c  lb_c  h, color(maroon%25) lcolor(maroon%60)) ///
    (line  LP_nc h, lwidth(medthick) lcolor(gs4) lpattern(solid)) ///
    (line  LP_c  h, lwidth(medthick) lcolor(maroon) lpattern(shortdash)), ///
    xlabel(-120(20)0) xscale(range(-120 0)) ///
    xtitle("h (상대시점, 일)") ytitle("Log 소매가격 반응 (할당관세적용시)") ///
    title("처치 그룹2 (과일)") ///
    legend(order(3 "기후 통제변수 없음" 4 "기후 통제변수 있음") pos(6) ring(0)) ///
    yline(0) name(fruit_kor, replace)
graph export "AD_precoef_fruit.png", replace width(3000)

twoway ///
    (rarea ub_nc lb_nc h, color(gs10%40) lcolor(gs8%60)) ///
    (rarea ub_c  lb_c  h, color(maroon%25) lcolor(maroon%60)) ///
    (line  LP_nc h, lwidth(medthick) lcolor(gs4) lpattern(solid)) ///
    (line  LP_c  h, lwidth(medthick) lcolor(maroon) lpattern(shortdash)), ///
    xlabel(-120(20)0) xscale(range(-120 0)) ///
    xtitle("h (Relative Days)") ytitle("Log Retail Price Response (under Quota Tariff)") ///
    title("Treated Group 2 (Fruits)") ///
    legend(order(3 "Without climate covariates" 4 "With climate covariates") pos(6) ring(0)) ///
    yline(0) name(fruit_eng, replace)
graph export "AD_precoef_fruit_eng.png", replace width(3000)

* ---------- combined (English) ----------
graph combine veg_eng fruit_eng, cols(2) xsize(11) ysize(4.5) iscale(1.05)
graph export "AD_precoef_eng.png", replace width(3600)

di as txt "AD_fig done  $S_DATE $S_TIME"



***********************************************
***********************************************
** The Causal Effects of Tariff-Rate Quota Policies on Agricultural Product Retail Prices (STATA code)
** 할당관세 정책이 소비자 물가에 미치는 영향 (코드집)
** Youngmi Kim, Deokjae Jeong
** 김영미, 정덕재
** 2025
** Korea Customs and Trade Development Institute
** 관세무역개발원
***********************************************
***********************************************



global path="D:\JJ Dropbox\KCTDI_Research\할당관세 정책이 소비자 물가에 미치는 영향\GItPublish_test"
cd "${path}"
adopath + "${path}"




//! ============================================
*********************************
** Calculation of effective tariff rates
** 실질 관세율 계산
*********************************

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

/*
use sp0, clear 
foreach loc of newlist 가나 가봉 가이아나 감비아 과들루프 과테말라 괌 그린랜드 기네비소 기니 기타국 나미비아 나우루 나이지리아 남극대륙 남아프리카공화국 네덜란드열도 네팔 뉴칼레도니아 니제르 대만 도미니카 도미니카공화국 동티모르 라이베리아 러시아 레바논 룩셈부르크 르완다 리비아 마다가스카르 마셜제도 마카오 말리 멕시코 모로코 모리셔스 모리타니 모잠비크 몬테네그로 몰도바 몰디브 몽골 미령버진군도 미크로네시아 바누아투 바레인 바베이도스 바하마 버뮤다 베냉 베네수엘라 벨라루스 벨리즈 보츠와나 볼리비아 부르키나파소 부탄 북마리아나군도 북마케도니아 불령가이아나 불령리유니온코모도제도 불령폴리네시아 브라질 사모아 사우디아라비아 산마리노 세네갈 세르비아공화국 세이셸 세인트루시아 소말리아 솔로몬군도 수단 수리남 스와질랜드 시리아 시에라리온 아랍에미리트연합 아루바 아르메니아 아르헨티나 아메리칸사모아 아이티 아제르바이잔 아프가니스탄 안도라 알바니아 알제리 앙골라 앤티가바부다 앵귈라 에리트레아 에콰도르 에티오피아 영령버진아일랜드 예멘 오만 요르단 우간다 우루과이 우즈베키스탄 우크라이나 이라크 이란 이집트 자메이카 잠비아 적도기니 조지아 지부티 짐바브웨 차드 카메룬 카보베르데 카자흐스탄 카타르 케냐 코모로 코트디부아르 콩고 콩고민주공화국 쿠바 쿠웨이트 큐라소 키르기스스탄 키리바시 키프로스 타지키스탄 탄자니아 토고 통가 투르크메니스탄 투발루 튀니지 트리니다드토바고 파라과이 파로에군도 파키스탄 파푸아뉴기니 팔라우 팔레스타인해방기구 포르투갈 포클랜드군도 푸에르토리코 피지 홍콩 {
    drop IMP_`loc'
}

foreach var of varlist IMP_그리스 IMP_네덜란드 IMP_노르웨이 IMP_뉴질랜드 IMP_니카라과 IMP_덴마크 IMP_독일 IMP_라오스 IMP_라트비아 IMP_루마니아 IMP_리투아니아 IMP_말레이시아 IMP_모나코 IMP_몰타 IMP_미국 IMP_미얀마 IMP_방글라데시 IMP_베트남 IMP_벨기에 IMP_불가리아 IMP_브루나이 IMP_스리랑카 IMP_스웨덴 IMP_스위스 IMP_스페인 IMP_슬로바키아 IMP_슬로베니아 IMP_싱가포르 IMP_아이슬란드 IMP_아일랜드 IMP_에스토니아 IMP_엘살바도르 IMP_영국 IMP_오스트리아 IMP_온두라스 IMP_이스라엘 IMP_이탈리아 IMP_인도네시아 IMP_인도인디아 IMP_일본 IMP_중국 IMP_체코 IMP_칠레 IMP_캄보디아 IMP_캐나다 IMP_코스타리카 IMP_콜롬비아 IMP_크로아티아 IMP_태국 IMP_튀르키예 IMP_파나마 IMP_페루 IMP_폴란드 IMP_프랑스 IMP_핀란드 IMP_필리핀 IMP_헝가리 IMP_호주 {
    gen C`var'=.
}
*/

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
* 패턴 MY, BN, LA, TH에 매칭되는 CUS_F 접두사 변수는 발견되지 않았습니다.
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



** Reflecting seasonal tariffs or quota tariffs (Phase1)
** 계절관세 또는 쿼터관세를 반영 (Phase1)
sort HS10
//soybeans
//콩
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
//미국 콩은 계산 제외


//red beans (adzuki)
//팥
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
** 계절관세 또는 쿼터관세를 반영 (Phase2)
use sp1_temp, clear 
sort HS10
//pineapple
//파인애플
replace FIMP_영국=2.7 if HS10=="0804300000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0804300000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0804300000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0804300000"&time>=738
}
//onion
//양파  
gen IMP_양파=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_양파=IMP_양파+`var' if `var'!=.
}
replace IMP_양파=IMP_양파/1000
bysort HS10 year (month): gen IMP_양파_누적 = sum(IMP_양파)
replace CUS_W1=CUS_W2 if IMP_양파_누적>20645&inlist(HS10,"0703101090","0703101000")
//garlic
//마늘
gen IMP_마늘=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_마늘=IMP_마늘+`var' if `var'!=.
}
replace IMP_마늘=IMP_마늘/1000
bysort HS10 year (month): gen IMP_마늘_누적 = sum(IMP_마늘)
replace CUS_W1=CUS_W2 if IMP_마늘_누적>14467&inlist(HS10,"0703201000")
//peanuts
//땅콩
gen IMP_땅콩=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_우크라이나 IMP_인도인디아 IMP_필리핀 IMP_일본 IMP_칠레 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_스위스 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_아랍에미리트 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_에콰도르 IMP_탄자니아 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_르완다 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_땅콩=IMP_땅콩+`var' if `var'!=.
}
replace IMP_땅콩=IMP_땅콩/1000
bysort HS10 year (month): gen IMP_땅콩_누적 = sum(IMP_땅콩)
replace CUS_W1=CUS_W2 if IMP_땅콩_누적>4907.3&inlist(HS10,"2008119000")

replace FIMP_영국=5.8 if HS10=="0804300000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0804300000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=5.8 if HS10=="0804300000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0804300000"&time>=738
}
//soybeans
//콩
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
//파프리카
gen IMP_파프리카=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_파프리카=IMP_파프리카+`var' if `var'!=.
}
replace IMP_파프리카=IMP_파프리카/1000
bysort HS10 year (month): gen IMP_파프리카_누적 = sum(IMP_파프리카)
replace CUS_W1=CUS_W2 if IMP_파프리카_누적>7185&inlist(HS10,"0709601000")
//red chili pepper, green chili pepper
//붉은고추, 풋고추
gen IMP_고추류=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_고추류=IMP_고추류+`var' if `var'!=.
}
replace IMP_고추류=IMP_고추류/1000
bysort HS10 year (month): gen IMP_고추류_누적 = sum(IMP_고추류)
replace CUS_W1=CUS_W2 if IMP_고추류_누적>7185&inlist(HS10,"0709609000")
//dried red pepper
//건고추
gen IMP_건고추=0
foreach var of varlist IMP_중국 IMP_브라질 IMP_호주 IMP_아르헨티나 IMP_태국 IMP_베트남 IMP_인도네시아 IMP_말레이시아 IMP_독일 IMP_우크라이나 IMP_프랑스 IMP_인도인디아 IMP_필리핀 IMP_이탈리아 IMP_캐나다 IMP_일본 IMP_스페인 IMP_루마니아 IMP_영국 IMP_네덜란드 IMP_칠레 IMP_뉴질랜드 IMP_남아프리카_공화국 IMP_싱가포르 IMP_콜롬비아 IMP_페루 IMP_스위스 IMP_벨기에 IMP_덴마크 IMP_불가리아 IMP_대만 IMP_파라과이 IMP_튀르키예 IMP_에티오피아 IMP_러시아 IMP_멕시코 IMP_과테말라 IMP_폴란드 IMP_아랍에미리트 IMP_아일랜드 IMP_오스트리아 IMP_체코 IMP_홍콩 IMP_이집트 IMP_몰도바 IMP_엘살바도르 IMP_니카라과 IMP_코스타리카 IMP_파키스탄 IMP_이스라엘 IMP_그리스 IMP_나이지리아 IMP_말라위 IMP_미얀마 IMP_짐바브웨 IMP_헝가리 IMP_온두라스 IMP_세르비아 IMP_가나 IMP_케냐 IMP_포르투갈 IMP_스웨덴 IMP_에콰도르 IMP_탄자니아 IMP_리투아니아 IMP_핀란드 IMP_모잠비크 IMP_방글라데시 IMP_우간다 IMP_파푸아뉴기니 IMP_스리랑카 IMP_에스토니아 IMP_마케도니아_공화국 IMP_우즈베키스탄 IMP_잠비아 IMP_부르키나파소 IMP_마다가스카르 IMP_노르웨이 IMP_파나마 IMP_캄보디아 IMP_크로아티아 IMP_모로코 IMP_도미니카공화국 IMP_피지 IMP_몽골 IMP_슬로베니아 IMP_르완다 IMP_슬로바키아 IMP_이란 IMP_아이슬란드 IMP_쿠바 IMP_예멘 IMP_튀니지 IMP_베네수엘라 IMP_네팔 IMP_푸에르토리코 IMP_라트비아 IMP_콩고민주공화국 IMP_카자흐스탄 IMP_모리셔스 IMP_요르단 IMP_조지아 IMP_자메이카 IMP_팔레스타인 IMP_베냉 IMP_말리 IMP_볼리비아 IMP_코트디부아르 IMP_동티모르 IMP_콩고 IMP_라오스 IMP_뉴칼레도니아 IMP_통가 IMP_마카오 IMP_사우디아라비아 IMP_키르기스스탄 IMP_부룬디 IMP_토고 IMP_카타르 IMP_산마리노 IMP_나미비아 IMP_아제르바이잔 IMP_수단 IMP_벨리즈 IMP_벨라루스 IMP_키프로스공화국 IMP_카메룬 IMP_룩셈부르크 IMP_알바니아공화국 IMP_레소토 IMP_기타국 IMP_알제리 IMP_아르메니아 IMP_괌 IMP_프랑스령_폴리네시아 IMP_시리아 IMP_사모아 IMP_트리니다드_토바고 IMP_레바논 IMP_우루과이 IMP_몰타 IMP_북마리아나_제도 IMP_아이티 IMP_바베이도스 IMP_코모로 IMP_남수단공화국 IMP_과들루프 IMP_모나코 IMP_미국령_버진아일랜드 IMP_가이아나 IMP_니제르 {
    replace IMP_건고추=IMP_건고추+`var' if `var'!=.
}
replace IMP_건고추=IMP_건고추/1000
bysort HS10 year (month): gen IMP_건고추_누적 = sum(IMP_건고추)
replace CUS_W1=CUS_W2 if IMP_건고추_누적>7185&inlist(HS10,"0904210000")
//watermelon
//수박
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
//고구마는 수입량 자체가 극소량이라 skip

//red beans (adzuki)
//팥
gen IMP_팥=0
foreach var of varlist IMP_가나 IMP_가이아나 IMP_과들루프 IMP_과테말라 IMP_괌 IMP_그리스 IMP_기타국 IMP_나미비아 IMP_나이지리아 IMP_남수단공화국 IMP_남아프리카_공화국 IMP_네덜란드 IMP_네팔 IMP_노르웨이 IMP_뉴질랜드 IMP_뉴칼레도니아 IMP_니제르 IMP_니카라과 IMP_대만 IMP_덴마크 IMP_도미니카공화국 IMP_독일 IMP_동티모르 IMP_라오스 IMP_라트비아 IMP_러시아 IMP_레바논 IMP_레소토 IMP_루마니아 IMP_룩셈부르크 IMP_르완다 IMP_리투아니아 IMP_마다가스카르 IMP_마카오 IMP_마케도니아_공화국 IMP_말라위 IMP_말레이시아 IMP_말리 IMP_멕시코 IMP_모나코 IMP_모로코 IMP_모리셔스 IMP_모잠비크 IMP_몰도바 IMP_몰타 IMP_몽골 IMP_미국령_버진아일랜드 IMP_미얀마 IMP_바베이도스 IMP_방글라데시 IMP_베냉 IMP_베네수엘라 IMP_베트남 IMP_벨기에 IMP_벨라루스 IMP_벨리즈 IMP_볼리비아 IMP_부룬디 IMP_부르키나파소 IMP_북마리아나_제도 IMP_불가리아 IMP_브라질 IMP_사모아 IMP_사우디아라비아 IMP_산마리노 IMP_세르비아 IMP_수단 IMP_스리랑카 IMP_스웨덴 IMP_스위스 IMP_스페인 IMP_슬로바키아 IMP_슬로베니아 IMP_시리아 IMP_싱가포르 IMP_아랍에미리트 IMP_아르메니아 IMP_아르헨티나 IMP_아이슬란드 IMP_아이티 IMP_아일랜드 IMP_아제르바이잔 IMP_알바니아공화국 IMP_알제리 IMP_에스토니아 IMP_에콰도르 IMP_에티오피아 IMP_엘살바도르 IMP_영국 IMP_예멘 IMP_오스트리아 IMP_온두라스 IMP_요르단 IMP_우간다 IMP_우루과이 IMP_우즈베키스탄 IMP_우크라이나 IMP_이란 IMP_이스라엘 IMP_이집트 IMP_이탈리아 IMP_인도네시아 IMP_인도인디아 IMP_일본 IMP_자메이카 IMP_잠비아 IMP_조지아 IMP_짐바브웨 IMP_체코 IMP_칠레 IMP_카메룬 IMP_카자흐스탄 IMP_카타르 IMP_캄보디아 IMP_케냐 IMP_코모로 IMP_코스타리카 IMP_코트디부아르 IMP_콜롬비아 IMP_콩고 IMP_콩고민주공화국 IMP_쿠바 IMP_크로아티아 IMP_키르기스스탄 IMP_키프로스공화국 IMP_탄자니아 IMP_태국 IMP_토고 IMP_통가 IMP_튀니지 IMP_튀르키예 IMP_트리니다드_토바고 IMP_파나마 IMP_파라과이 IMP_파키스탄 IMP_파푸아뉴기니 IMP_팔레스타인 IMP_페루 IMP_포르투갈 IMP_폴란드 IMP_푸에르토리코 IMP_프랑스 IMP_프랑스령_폴리네시아 IMP_피지 IMP_핀란드 IMP_필리핀 IMP_헝가리 IMP_호주 IMP_홍콩 {
    replace IMP_팥=IMP_팥+`var' if `var'!=.
}
replace IMP_팥=IMP_팥/1000
bysort HS10 year (month): gen IMP_팥_누적 = sum(IMP_팥)
rename IMP_팥_누적 IMP_팥_누적_temp
egen IMP_팥_누적=rowtotal(IMP_팥_누적_temp IMP_팥_중국_누적 IMP_팥_미국_누적 IMP_팥_캐나다_누적)
replace CUS_W1=CUS_W2 if IMP_팥_누적>14694&inlist(HS10,"0713329000")&year==2021
replace CUS_W1=CUS_W2 if IMP_팥_누적>23894&inlist(HS10,"0713329000")&year==2022
replace CUS_W1=CUS_W2 if IMP_팥_누적>23894&inlist(HS10,"0713329000")&year==2023
replace CUS_W1=CUS_W2 if IMP_팥_누적>23147&inlist(HS10,"0713329000")&year==2024
replace CUS_W1=CUS_W2 if IMP_팥_누적>23894&inlist(HS10,"0713329000")&year==2025

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

//water dropwort (minari)
//미나리
replace FIMP_영국=2.4 if HS10=="0709999000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709999000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.4 if HS10=="0709999000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709999000"&time>=738
}

//squash (Korean zucchini)
//호박 (애호박)
replace FIMP_뉴질랜드=0 if HS10=="0709930000"&inlist(month,1,2,3,4,5,12)
replace FIMP_뉴질랜드=27 if HS10=="0709930000"&inlist(month,6,7,8,9,10,11)

//oyster mushroom
//느타리버섯
replace FIMP_영국=2.7 if HS10=="0709594090"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709594090"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0709594090"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709594090"&time>=738
}

//king oyster mushroom (large oyster mushroom)
//새송이버섯 (큰느타리버섯)
replace FIMP_영국=2.7 if HS10=="0709594010"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0709594010"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0709594010"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0709594010"&time>=738
}

//radish
//무
replace FIMP_영국=2.7 if HS10=="0706901000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0706901000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0706901000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0706901000"&time>=738
}

//lettuce
//상추
replace FIMP_영국=4 if HS10=="0705190000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0705190000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=4 if HS10=="0705190000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0705190000"&time>=738
}

//mango
//망고
replace FIMP_영국=2.7 if HS10=="0804502000"&inrange(time,732,737)
replace FIMP_영국=0 if HS10=="0804502000"&time>=738
foreach name of newlist 그리스 네덜란드 덴마크 독일 라트비아 루마니아 리투아니아 몰타 벨기에 불가리아 스웨덴 스페인 슬로바키아 슬로베니아 아일랜드 에스토니아 오스트리아 이탈리아 체코 포르투갈 폴란드 프랑스 핀란드 헝가리 모나코 크로아티아 {
    replace FIMP_`name'=2.7 if HS10=="0804502000"&inrange(time,732,737)
    replace FIMP_`name'=0 if HS10=="0804502000"&time>=738
}

//kiwifruit
//참다래
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

gen ORD=CUP7     // 7 시작
  // no 6
  // 6 없음
 // replace ORD=CUP5 if CUP5!=.; 5 has priority over 6 and 7; skip case 5
 // replace ORD=CUP5 if CUP5!=.   // 5= 6,7보다 우선적용   // 5번 스킵
// Generate ORD42 from ORD; start at 42 and always skip 42 because 42 itself indicates TRQ application
//gen ORD42=ORD                 // 42 시작  // 반드시 42 스킵해야됨. 42 자체가 할당관세 적용임
// replace ORD42=CUP42 if CUP42!=.; when 42 is lower than 5 give 42 priority; it also has priority over 6 and 7
//replace ORD42=CUP42 if CUP42!=.   // 42= 5보다 낮은 경우 우선적용  / 6,7보다 우선적용
gen ORD41=ORD                   //41 시작
replace ORD41=CUP41 if CUP41!=.    // 41= 5, 6, 7 보다 우선적용
egen ORD4=rowmin(ORD41)
gen ORD33=ORD4     // 33 시작   // 5번 스킵

// If 33 is lower than 4 or 5, apply 33 first; E1, E2, and E3 are applied differentially by country
// 33= 4, 5 보다 낮은 경우 우선 적용 // E1, E2, E3 국가별 차등적용
gen ORD33G=ORD33
gen ORD33C=ORD33
gen ORD33B=ORD33
gen ORD33L=ORD33
replace ORD33C=CUP33C if (CUP33C<ORD33) & CUP33C!=.   
replace ORD33B=CUP33B if (CUP33B<ORD33) & CUP33B!=.   
replace ORD33L=CUP33L if (CUP33L<ORD33) & CUP33L!=.   

gen ORD32=CUP7      // 32 시작
replace ORD32=CUP32 if CUP32!=.
egen ORD31=rowmin(ORD4 CUP7)  // 31 시작  // 5번 스킵
replace ORD31=CUP31 if (CUP31<ORD31) & CUP31!=.
//egen ORD3=rowmin(ORD31 ORD32)

foreach loc of newlist 그리스 네덜란드 노르웨이 뉴질랜드 니카라과 덴마크 독일 라트비아 루마니아 리투아니아 말레이시아 모나코 몰타 미국 미얀마 베트남 벨기에 불가리아 브루나이 스웨덴 스위스 스페인 슬로바키아 슬로베니아 싱가포르 아이슬란드 아일랜드 에스토니아 엘살바도르 영국 오스트리아 온두라스 이스라엘 이탈리아 인도인디아 일본 체코 칠레 캄보디아 캐나다 코스타리카 콜롬비아 크로아티아 태국 튀르키예 파나마 페루 포르투갈 폴란드 프랑스 핀란드 필리핀 헝가리 호주 {
    egen ORD2_`loc'=rowmin(FIMP_`loc' ORD31 ORD32 ORD33G)
} 
foreach loc of newlist 중국 인도네시아 {
    egen ORD2_`loc'=rowmin(FIMP_`loc' ORD32)  // ORD33C 삭제
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
replace HS2024="0807199000" if year==2021&HS10=="0807190000"  // 멜론
replace HS2024="0703101090" if year==2021&HS10=="0703101000"  // 양파
replace HS2024="0703902000" if year==2021&HS10=="0703909000"  // 대파
replace HS2024="0703903000" if year==2021&HS10=="0703102000"  // 쪽파
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


//! Export to Excel (Stata 19)
//! Stata 19   엑셀 내보내기
use BaseTaxFin, clear 
keep if inlist(HS10,"0703101090","0703101000")  //! 양파만 남김
sort time 
order time HS10 BaseTax
export excel using "${path}/BaseTaxFin양파.xlsx", firstrow(variables) replace








//! ============================================
*********************************
** NongNet price and sales quantity data
** 농넷 가격, 판매량 데이터
*********************************

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
// 1단계: 날짜 데이터 생성
local start_date = mdy(1, 1, 2019)
local end_date = mdy(3, 31, 2025)
local total_days = `end_date' - `start_date' + 1
set obs `total_days'
gen double date = `start_date' + _n - 1
format date %tdCCYY-NN-DD
gen fulldate = 1
save fulldate, replace
// Step 2: load possible.dta and create panel data
// 2단계: possible.dta 로드하고 패널데이터 생성
use possible, clear
// Check the actual number of items
// 실제 품목 수 확인
local n_items = _N
display "실제 품목 수: `n_items'"
// Create all item-by-date combinations via cross join
// Cross join으로 모든 품목 × 모든 날짜 조합 생성
cross using fulldate
// Sort data by item and date
// 정렬 (품목별로 날짜순)
sort s_item date
// Drop unnecessary variables
// 불필요한 변수 제거
drop fulldate
// Check the panel data structure
// 패널데이터 확인
describe
display "총 관측치 수: " _N
display "예상 관측치 수: `n_items' × `total_days' = " `n_items' * `total_days'
// Save the results
// 결과 저장
save fullpanel, replace





//! ============================================
//! Sales quantity
//! 판매량
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
정확한 단위는 농넷 웹사이트로 봐야함. 원100g, 개100g 등의 정보는 전혀 잘못됨. 단위량unit_qy 단위명unit_code_nm 로 봐야함. 농넷과 같음.
sales: sales amount (10,000 KRW)
sales: 매출액(만원)
price: x KRW per quantity unit
price: x원 / 단위량단위명
quant: x in quantity units
quant: x 단위량단위명
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
//* R 에서 작업 (R_quant)


import delimited using "${path}/q_all_weekly_STL_result.csv", clear varnames(1) encoding(CP949)

* Restore time variable from date
* date -> time 복원
gen double daily_date = date(date,"YMD")
format daily_date %tdCCYY-NN-DD
gen int time = wofd(daily_date)
format time %tw

* If imported as string, convert to numeric (add q_price variables)
* 만약 문자로 들어왔으면 숫자형으로 변환 (q_price 변수들 추가)
capture confirm numeric variable quant_sa_add
if _rc destring quant_sa_add quant_sa_mul price_sa_add price_sa_mul, replace ignore("NA")

* Convert q_price to numeric as well (if necessary)
* q_price도 숫자형으로 변환 (필요시)
capture confirm numeric variable price
if _rc destring price, replace ignore("NA")

keep item time quant_sa_add quant_sa_mul price price_sa_add price_sa_mul daily_date
tempfile adj
save "`adj'", replace

use q3, clear
rename 품목 item

* Before merging, resolve duplicates (take the mean when there are multiple rows per item-time)
* 병합 전 중복 정리(동일 item-time 여러 행이면 평균)
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
tsfilter hp price_hp = price2, trend(smooth_price) smooth(600)  // 600이 적당한듯
by q_item2: ipolate quant date, gen(quant2) 
tsfilter hp quant_hp = quant2, trend(smooth_quant) smooth(600)  // 600이 적당한듯
drop price quant
rename (price2 quant2)(price quant)
save q5, replace 







//! ============================================
//! Retail prices
//! 소매가격
use s1, clear
tostring 일자, replace 
gen double date = mdy(real(substr(일자,5,2)), real(substr(일자,7,2)), real(substr(일자,1,4)))
format date %tdCCYY-NN-DD
gen some = 품목 + "_" + 품종
* Normalize units (kg -> g) and compute price per gram
* 단위 정규화(kg -> g), g당 가격
replace 단위량 = 단위량/1000 if 거래단위=="g"
replace 거래단위 = "kg"       if 거래단위=="g"
*** Convert to kg when the transaction unit is one piece ***   // surveyed from direct purchases in the market
*** 거래단위가 1개 인 경우 kg으로 변환 ***   // 시장에서 직접 구매후 조사
replace 평균가격=평균가격/140*1000 if some=="레몬_레몬(전체)"
replace 평균가격=평균가격/362.5*1000 if some=="망고_망고(전체)"
replace 평균가격=평균가격/1650*1000 if some=="무_무(전체)"
replace 평균가격=평균가격/600*1000 if some=="배_신고"
replace 평균가격=평균가격/1800*1000 if some=="배추_배추(전체)"   // 1포기
replace 평균가격=평균가격/285.65*1000 if some=="브로콜리_브로콜리(전체)"
replace 평균가격=평균가격/294.118*1000 if some=="사과_후지"
replace 평균가격=평균가격/5250*1000 if some=="수박_수박(전체)"
replace 평균가격=평균가격/221.428*1000 if some=="아보카도_아보카도(전체)"
replace 평균가격=평균가격/1750*1000 if some=="양배추_양배추(전체)"   // 1포기
replace 평균가격=평균가격/235*1000 if some=="오이_다다기계통" 
replace 평균가격=평균가격/171.429*1000 if some=="참다래_참다래(전체)"
replace 평균가격=평균가격/1350*1000 if some=="파인애플_파인애플(전체)"
replace 평균가격=평균가격/307*1000 if some=="호박_애호박"
replace 평균가격 = 평균가격/단위량
drop 단위량   // 평균가격은 1kg 당 원 최종통일됨
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
* (품목코드 × some × date) 일별 평균가격
collapse (mean) 평균가격, by(품목코드 some date)
rename 평균가격 y
encode some, gen(some2)
order 품목코드 some date y
save s_daily, replace
export delimited using "${path}/q_all_daily.csv", replace


//* Work done in R (R_some)
//* R 에서 작업 (R_some)


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
keep s_item date s_price s_item2
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
drop if s_item==""
tsfilter hp s_price_hp = s_price2, trend(smooth_s_price2) smooth(600)  // 600이 적당한듯
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





//! ============================================
//! Wholesale prices
//! 도매가격 
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
* (품목코드 × dome × date)로 유일화
collapse (mean) y, by(품목코드 dome date)
encode dome, gen(dome2)
order 품목코드 dome date y
save d_daily, replace
export delimited using "${path}/q_all_daily_wholesale.csv", replace


//* Work done in R (R_dome)
//* R 에서 작업 (R_dome)


import delimited using "${path}/q_all_daily_wholesale_STL_result.csv", ///
    clear varnames(1) encoding(CP949)
* Convert strings to numeric (if necessary)
* 문자 → 숫자 보정 (필요 시)
capture confirm numeric variable y_sa_add
if _rc destring y y_sa_add y_sa_mul, replace ignore("NA")
* Convert date string to a Stata daily date
* date 문자열 → daily date
gen double date_num = date(date,"YMD")
format date_num %tdCCYY-NN-DD
drop date
rename date_num date
* Keep observations including the item code
* 품목코드 포함해 보존
keep 품목코드 dome date y y_sa_add y_sa_mul
order 품목코드 dome date
* Check uniqueness (adj)
* 유일성 확인 (adj)
duplicates report 품목코드 dome date
tempfile adj
save "`adj'", replace

* --- Merge with master dataset ---
* --- master와 병합 ---
use d_daily, clear   // (품목코드 dome date y dome2)
order 품목코드 dome date
* Check uniqueness (master)
* 유일성 확인 (master)
duplicates report 품목코드 dome date
* Merge (key: item code, dome, date)
* 병합 (키: 품목코드 dome date)
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
keep d_item date d_price pcode
merge m:1 d_item using possible
keep if _merge==3
drop _merge 
merge 1:1 d_item date using fullpanel
drop _merge
drop pcode
encode d_item, gen(pcode)
xtset pcode date, daily 
//tsfill, full
sort pcode date
by pcode: ipolate d_price date, gen(d_price2) 
tsfilter hp d_price_hp = d_price2, trend(smooth_d_price2) smooth(600)  // 600이 적당한듯
drop if d_item==""
save d_mergeready, replace 

use d3, clear 
collapse (mean) d_code, by(d_item)
save d_item, replace
export excel using "d_item.xlsx", firstrow(variables) replace








//! ============================================
//! ============================================
//! Integration (combine datasets)
//! 통합 
import excel "원달러 환율.xlsx", sheet("Sheet0") firstrow clear 
tostring date, replace 
gen year=substr(date,1,4)
gen month=substr(date,5,6)
foreach name of varlist year month {
    destring `name', replace 
}
save 원달러환율, replace 


import excel "kati_price_finished_40items.xlsx", sheet("Sheet1") firstrow allstring clear
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
* 0. 문자열 date를 %tm 형식으로 변환
drop date 
gen date_monthly = ym(year, month)
format date_monthly %tm
drop year month
rename date_monthly date

* 1. Compute the number of days in each month
* 1. 각 월의 일수 계산
gen days_in_month = dofm(date + 1) - dofm(date)

* 2. Expand rows by the number of days in each month
* 2. 일수만큼 행 복제
expand days_in_month

* 3. Generate a sequence number within each month
* 3. 각 월 내에서 일련번호 생성
bysort date q_item: gen day_seq = _n

* 4. Generate daily dates
* 4. 일별 날짜 생성
gen date_daily = dofm(date) + day_seq - 1
format date_daily %td

* 5. Clean up variables
* 5. 정리
drop days_in_month day_seq date
rename (date_daily price) (date import_price)
keep date q_item import_price qcode 
sort qcode date

gen import_price_orig = import_price
xtset qcode date, daily

* Drop missing values and zeros
* 결측값과 0 제거
drop if import_price==. | import_price==0

* Compute the median for each item (robust to outliers)
* 각 품목별 중앙값 계산 (이상치의 영향을 받지 않음)
bysort qcode: egen import_price_median = median(import_price)

* Detect and remove outliers: set to missing if above 3 times the median or below one-third of the median
* 이상치 탐지 및 제거: 중앙값의 3배 초과 또는 1/3 미만인 경우 결측 처리
gen outlier = (import_price > 3 * import_price_median | import_price < import_price_median / 3)
replace import_price = . if outlier == 1

* Inspect outliers
* 이상치 확인
list date q_item import_price_orig import_price_median if outlier == 1, sepby(q_item)
by qcode: egen outlier_count = total(outlier)
list q_item outlier_count import_price_median if outlier_count > 0, sepby(q_item) noobs

* Use tsfill to make the panel balanced
* tsfill로 패널 균형 맞추기
tsfill, full
drop if q_item==""
merge 1:1 date q_item using fullpanel
* After removing outliers, fill missing values with the median
* 결측값을 중앙값으로 채우기 (이상치 제거 후)
replace import_price = import_price_median if import_price == .

drop outlier outlier_count import_price_median

save import_price_temp1, replace


use import_price_temp1, clear
set more off 
* Preserve the original import_price
* 원본 import_price 보존
rename import_price import_price_temp3
bysort qcode: ipolate import_price_temp3 date, gen(import_price) epolate
* Extract the day from the date
* 날짜에서 일(day) 추출
gen day = day(date)

* Mark the first and last observation for each item
* 각 품목별 첫/마지막 관측치 표시
bysort q_item (date): gen first_obs = (_n == 1)
bysort q_item (date): gen last_obs = (_n == _N)

* Keep only the 15th day of each month and set others to missing (but keep first/last observations)
* 매달 15일만 남기고 나머지는 missing (단, 첫/마지막 관측치는 유지)
gen import_price_interp = import_price
replace import_price_interp = . if day != 15 & first_obs == 0 & last_obs == 0

* Re-check the time-series panel structure
* 시계열 패널 재확인
drop qcode
encode q_item, gen(qcode)
xtset qcode date, daily
tsfill, full
keep if inrange(date,22281,23831)   // 2021-01-01 ~ 2025-03-31

* Apply linear interpolation (within each panel)
* 선형 보간 (각 패널별로 자동 처리)
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
gen date2=date 
gen TRQ=.

** Items subject to tariff-rate quota (TRQ)
** 할당관세 적용품목
// q_item, HS10, start date, end date
// q_item, HS10, 시작일, 종료일
// Onion, 0703101090, 2022-08-17 to 2023-02-28
// 양파, 0703101090, 20220817	20230228
replace TRQD=1 if q_item=="양파" & inrange(date,22874,23069)  
replace TRQ=0 if q_item=="양파" & inrange(date,22874,23069)
// Cabbage, 0704901000, 2024-05-10 to 2025-04-30
// 양배추, 0704901000, 20240510	20250430
replace TRQD=1 if q_item=="양배추" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="양배추" & inrange(date,23506,23831)
// Napa cabbage, 0704902000, 2024-05-10 to 2025-04-30
// 배추, 0704902000, 20240510	20250430
replace TRQD=1 if q_item=="배추" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="배추" & inrange(date,23506,23831)
// Carrot, 0706101000, 2024-05-10 to 2025-04-30
// 당근, 0706101000, 20240510	20250430
replace TRQD=1 if q_item=="당근" & inrange(date,23506,23831)
replace TRQ=0 if q_item=="당근" & inrange(date,23506,23831)
// Radish, 0706901000, 2024-05-10 to 2025-04-30
// 무, 0706901000, 20240510	20250430
replace TRQD=1 if q_item=="무" & inrange(date,23558,23831)
replace TRQ=0 if q_item=="무" & inrange(date,23558,23831)
// Pineapple, 0804300000, 2023-08-25 to 2025-06-30
// 파인애플, 0804300000, 20230825	20250630
replace TRQD=1 if q_item=="파인애플" & inrange(date,23247,23831)
replace TRQ=0 if q_item=="파인애플" & inrange(date,23247,23831)
// Avocado, 0804400000, 2024-01-19 to 2025-06-30
// 아보카도, 0804400000, 20240119	20250630
replace TRQD=1 if q_item=="아보카도" & inrange(date,23394,23831)
replace TRQ=0 if q_item=="아보카도" & inrange(date,23394,23831)
// Mango, 0804502000, 2023-08-25 to 2025-06-30
// 망고, 0804502000, 20230825	20250630
replace TRQD=1 if q_item=="망고" & inrange(date,23247,23831)
replace TRQ=0 if q_item=="망고" & inrange(date,23247,23831)
// Kiwifruit, 0810500000, 2024-04-05 to 2024-12-31
// 참다래, 0810500000, 20240405	20241231
replace TRQD=1 if q_item=="참다래" & inrange(date,23471,23741)
replace TRQ=5 if q_item=="참다래" & inrange(date,23471,23741)
// Banana, 0803900000, 2023-11-17 to 2025-06-30
// 바나나, 0803900000, 20231117	20250630
replace TRQD=1 if q_item=="바나나" & inrange(date,23331,23831)
replace TRQ=0 if q_item=="바나나" & inrange(date,23331,23831)
// Cherry, 0809290000, 2024-04-05 to 2024-12-31
// 체리, 0809290000, 20240405	20241231
replace TRQD=1 if q_item=="체리" & inrange(date,23471,23741)
replace TRQ=0 if q_item=="체리" & inrange(date,23471,23741)


** Non-TRQ items (subset): match items with the highest Spearman correlation
** 할당관세 비적용품목 (일부) Spearman 상관계수가 가장 높은 품목끼리 매칭
replace TRQD=1 if q_item=="콩" & inrange(date,23331,23831)  // 바나나에 시점 일치
replace TRQD=1 if q_item=="마늘" & inrange(date,23558,23831)  // 무에 시점 일치
replace TRQD=1 if q_item=="새송이버섯" & inrange(date,22874,23831)  // 양파에 시점 일치
replace TRQD=1 if q_item=="레몬" & inrange(date,23394,23831)  // 아보카도에 시점 일치
replace TRQD=1 if q_item=="미나리" & inrange(date,23506,23831)  // 당근에 시점 일치
replace TRQD=1 if q_item=="수박" & inrange(date,23247,23831)  // 망고에 시점 일치
replace TRQD=1 if q_item=="생강" & inrange(date,23247,23831)  // 파인애플에 시점 일치
replace TRQD=1 if q_item=="시금치" & inrange(date,23471,23831)  // 체리에 시점 일치
replace TRQD=1 if q_item=="느타리버섯" & inrange(date,23506,23831)  // 배추에 시점 일치
replace TRQD=1 if q_item=="팥" & inrange(date,23506,23831)  // 양배추에 시점 일치
replace TRQD=1 if q_item=="땅콩" & inrange(date,23471,23831)  // 참다래에 시점 일치

egen never=total(TRQD), by(q_item)
replace TRQD=1 if never==0 & inrange(date,23506,23831)

drop date2 never
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
save possible2, replace 

use BaseTaxFin, clear 
expand 2, gen(expand)
replace HS2024="0704902000_0" if HS2024=="0704902000"&expand==0
replace HS2024="0704902000_1" if HS2024=="0704902000"&expand==1
replace HS2024="0709601000_0" if HS2024=="0709601000"&expand==0
replace HS2024="0709601000_1" if HS2024=="0709601000"&expand==1
replace HS2024="0709609000_0" if HS2024=="0709609000"&expand==0
replace HS2024="0709609000_1" if HS2024=="0709609000"&expand==1
drop expand
duplicates drop  
// Set BaseTax=45 when HS2024=="0808100000" (apples)
//replace BaseTax=45 if HS2024=="0808100000"  // 사과
// Set BaseTax=5.588108 when HS2024=="0810500000" & time==771 (kiwifruit, 2024m4)
//replace BaseTax=5.588108 if HS2024=="0810500000"&time==771  // 참다래 2024m4
save BaseTaxFin2, replace 


use total_import, clear 
expand 2, gen(expand)
replace HS2024="0704902000_0" if HS2024=="0704902000"&expand==0
replace HS2024="0704902000_1" if HS2024=="0704902000"&expand==1
replace HS2024="0709601000_0" if HS2024=="0709601000"&expand==0
replace HS2024="0709601000_1" if HS2024=="0709601000"&expand==1
replace HS2024="0709609000_0" if HS2024=="0709609000"&expand==0
replace HS2024="0709609000_1" if HS2024=="0709609000"&expand==1
drop expand
duplicates drop  
// Set BaseTax=45 when HS2024=="0808100000" (apples)
//replace BaseTax=45 if HS2024=="0808100000"  // 사과
// Set BaseTax=5.588108 when HS2024=="0810500000" & time==771 (kiwifruit, 2024m4)
//replace BaseTax=5.588108 if HS2024=="0810500000"&time==771  // 참다래 2024m4
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
order q_item date TRQ TRQD smooth_s_price2 smooth_d_price2 Eu_uncond BaseTax total_import
keep q_item date TRQ TRQD smooth_s_price2 smooth_d_price2 Eu_uncond BaseTax total_import
rename (smooth_s_price2 smooth_d_price2 Eu_uncond)(s_price d_price elas)
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
* 기간 제한
replace i_price = . if !inrange(date, 22281, 23831)  // 2021-01-01 ~ 2025-03-31
xtset qcode date, daily
tsfilter hp i_price_hp = i_price, trend(i_price_smooth) smooth(60)
drop i_price
rename i_price_smooth i_price
save m1, replace




//!==============================
//! 실질관세율_바나나_양파 그래프 생성
use m1, clear 
keep if inrange(date,mdy(1, 1, 2021),mdy(3, 31, 2025))
keep if inlist(q_item,"바나나","양파")
twoway (tsline BaseTax if q_item=="양파", lcolor(gs0) cmissing(n))(tsline BaseTax if q_item=="바나나", lcolor(red) cmissing(n) lpattern(dash)) ///
, legend(order(1 "양파" 2 "바나나")) ytitle("실질관세율 (%)")
graph export 실질관세율_바나나_양파.png, replace width(3000)



use m1, clear
keep if q_item=="망고"
twoway (tsline import_price_filled if inrange(date,22281,23831), cmissing(n) lcolor(gs0)) ///
(tsline import_price_orig if inrange(date,22281,23831), cmissing(n) lcolor(gs0)) ///
(tsline i_price if inrange(date,22281,23831), lcolor(red) cmissing(n)) ///
, legend(order(1 "import_price_filled" 2 "import_price_orig" 3 "i_price")) ///
ytitle("수입가격 (원/kg)") xtitle("날짜")



gen flag=date if L.TRQD==0&TRQD==1&F.TRQD==1
rename BaseTax BaseTax_new
keep q_item date BaseTax_new flag
merge 1:1 q_item date using beforechange
keep if flag!=.
order q_item date BaseTax BaseTax_new
keep if inlist(q_item,"당근","망고","무","바나나","배추","아보카도")|inlist(q_item,"양배추","양파","참다래","체리","파인애플")

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


use s_mergeready, clear 
keep if s_item=="배추_배추(전체)"
twoway (tsline s_price2, lcolor(gs0) lwidth(thick)) ///
       (tsline smooth_s_price2, lcolor(yellow)), ///
       ytitle("단위: 원/kg") xtitle("") legend(label(1 "계절조정") label(2 "hpfilter"))
graph export hpfilter.png, replace width(3000)


use m1, clear 
keep if q_item=="파인애플"
twoway (tsline s_price, lcolor(gs0) lwidth(thick)) ///
       (tsline d_price, lcolor(red)), ///
       yscale(range(0 .)) ylabel(0, add) ytitle("단위: 원/kg") xtitle("")
graph export 도매-소매.png, replace width(3000)


use m1, clear 
keep if q_item=="당근"|q_item=="무"
twoway (tsline s_price if q_item=="당근", lcolor(gs0) lwidth(thick)) ///
       (tsline s_price if q_item=="무", lcolor(red)), ///
       yscale(range(0 .)) ylabel(0, add) ytitle("단위: 원/kg") xtitle("") xline(23450) 











//!==========================================================
//! For exporting effective tariff rates by country to Excel
//! 실질관세율 국가별 엑셀 표 출력용
use BaseTaxFin3, clear
keep time HS10 BaseTax q_item IMP_*
order q_item time HS10 BaseTax IMP_*
sort q_item time
* 1. Get the list of IMP_* variables
* 1. IMP_* 변수 목록 가져오기
ds IMP_*
local imps `r(varlist)'
* 2. Create a temporary frame/dataset to compute the overall sums of the IMP_* variables
* 2. IMP_* 들의 전체 합계 계산용 임시 프레임/데이터셋 생성
preserve
    keep `imps'
    * Collapse to totals over the entire period and all q_item
    * 전체 기간/전체 q_item 합계로 collapse
    collapse (sum) `imps'
    * Transpose the single total row to a "variable name - total" structure
    * 1행(합계)을 세로로 바꿔서 "변수명-합계" 구조로 만들기
    xpose, clear varname
    rename _varname varname   // 원래 변수명
    rename v1       total     // 각 변수의 합계
    * Sort by total in descending order
    * 합계가 큰 순서대로 정렬
    gsort -total
    * Create a variable name list ordered by descending total
    * 합계가 큰 순서대로 변수명 리스트 만들기
    levelsof varname, local(ord_imps)
    * Remove the quotation marks added by levelsof
    * levelsof가 붙여놓은 " 따옴표 제거
    local ord_imps : subinstr local ord_imps `"""' "", all
restore
* 3. Return to the original dataset and reorder the IMP_* variables in descending order of their totals
* 3. 원래 데이터셋으로 돌아와서, 합계가 큰 순서대로 IMP_* 변수 순서를 재정렬
order q_item time HS10 BaseTax `ord_imps'
sort q_item time
export excel using "BaseTaxRealFinal_publish.xlsx", firstrow(variables) replace







//! ==============================================================
//! After checking the TRQ quota thresholds, reset the end dates
//! 할당관세 한계수량 검사 후 종료기간 재설정

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
di endday  // 80


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
local range="inrange(mtime,ym(2024,1),ym(2024,3))"
local item="파인애플"
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

check_TRQquota 양파
local range="inrange(mtime,ym(2022,8),ym(2022,12))"
local item="양파"
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

check_TRQquota 아보카도
local range="inrange(mtime,ym(2024,1),ym(2024,3))"
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

check_TRQquota 망고
local range="inrange(mtime,ym(2023,8),ym(2023,12))"
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
local range="inrange(mtime,ym(2024,1),ym(2024,3))"
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
local range="inrange(mtime,ym(2024,1),ym(2024,3))"
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


** Manual adjustment of interruption or end periods
** 중단 or 종료기간 수동 조정
use m1, clear 
sort q_item date
drop TRQ
replace TRQD=0 if q_item=="당근"&inrange(date,mdy(9,8,2024),mdy(10,28,2024))  
replace TRQD=0 if q_item=="당근"&inrange(date,mdy(12,20,2024),mdy(12,31,2024))  
replace TRQD=0 if q_item=="당근"&inrange(date,mdy(2,20,2025),mdy(2,28,2025))  
// For March, simply keep TRQD=1
// 3월은 그냥 TRQD=1 유지
// Keep TRQD=1 for napa cabbage over the entire period
// 배추 전체기간 TRQD=1 유지
replace TRQD=0 if q_item=="양배추"&inrange(date,mdy(6,1,2024),mdy(6,30,2024)) 
replace TRQD=0 if q_item=="양배추"&inrange(date,mdy(10,12,2024),mdy(10,31,2024)) 
replace TRQD=0 if q_item=="양배추"&inrange(date,mdy(3,4,2025),mdy(4,30,2025)) 
replace TRQD=0 if q_item=="파인애플"&inrange(date,mdy(10,10,2023),mdy(12,31,2023)) 
// Pineapple does not exceed the quota after this; keep TRQD=1
// 파인애플 이후는 초과 안함. TRQD=1 유지
// Keep TRQD=1 for napa cabbage over the entire period
// 배추 전체기간 TRQD=1 유지
replace TRQD=0 if q_item=="양파"&inrange(date,mdy(9,15,2022),mdy(12,31,2022)) 
replace TRQD=0 if q_item=="양파"&inrange(date,mdy(2,10,2023),mdy(2,28,2023)) 
// Keep TRQD=1 for cherries over the entire period (full imports)
// 체리 전체기간 TRQD=1 유지 (수입전량)
// Keep TRQD=1 for kiwifruit over the entire period (full imports)
// 참다래 전체기간 TRQD=1 유지 (수입전량)
replace TRQD=0 if q_item=="망고"&inrange(date,mdy(9,23,2023),mdy(12,31,2023)) 
replace TRQD=0 if q_item=="바나나"&inrange(date,mdy(12,5,2023),mdy(12,31,2023)) 


replace TRQD=1 if q_item=="무"&inrange(date,mdy(5,1,2023),mdy(6,30,2023))  
replace TRQD=1 if q_item=="무"&inrange(date,mdy(7,1,2024),mdy(10,31,2024))  
replace TRQD=1 if q_item=="바나나"&inrange(date,mdy(11,10,2022),mdy(12,31,2022))  
replace TRQD=1 if q_item=="파인애플"&inrange(date,mdy(11,10,2022),mdy(12,31,2022))  
replace TRQD=1 if q_item=="망고"&inrange(date,mdy(11,10,2022),mdy(12,31,2022))  
save m2, replace

use m2, clear
** 파인애플 전처리1 구간 미제거 (m3)
gen treated=0
replace treated=1 if inlist(q_item,"배추","양배추","당근","파인애플","무","양파")|inlist(q_item,"체리","참다래","아보카도","망고","바나나")
gen TRQ=.
replace TRQ=0 if TRQD==1&treated==1
replace TRQ=5 if TRQD==1&q_item=="참다래"
replace TRQ=. if TRQD==1&treated==0
save m3, replace 

use m2, clear
** 파인애플 전처리1 구간 제거 (m4)
replace TRQD=0 if q_item=="파인애플"&inrange(date,mdy(11,10,2022),mdy(12,31,2022))  
replace TRQD=0 if q_item=="파인애플"&inrange(date,mdy(8,25,2023),mdy(1,31,2024))  
gen treated=0
replace treated=1 if inlist(q_item,"배추","양배추","당근","파인애플","무","양파")|inlist(q_item,"체리","참다래","아보카도","망고","바나나")
gen TRQ=.
replace TRQ=0 if TRQD==1&treated==1
replace TRQ=5 if TRQD==1&q_item=="참다래"
replace TRQ=. if TRQD==1&treated==0
save m4, replace 




//!=====================================
//! 수입-도매-소매가.png figure generation
//! 수입-도매-소매가.png 그래프 생성
use m3, clear 
local f1 = mdy(1,1,2024)
local f2 = mdy(7,3,2023)
keep if q_item=="파인애플"
keep if inrange(date,22281,23831)   // 2021-01-01 ~ 2025-03-31
twoway (tsline s_price, lcolor(red) lwidth(thick)) ///
       (tsline d_price, lcolor(gs0) lwidth(thick) lpattern(dash)) ///
       (tsline i_price, lcolor(gs0)), ///
       yscale(range(0 .)) ylabel(0, add) ytitle("단위: 원/kg") xtitle("") /// 
       legend(order(1 "소매가" 2 "도매가" 3 "수입가")) // xline(`f1') xline(`f2')
graph export "수입-도매-소매가.png", replace width(3000)







//!==========================================
//! For generating the TRQ application table
//! 할당관세 적용표 생성용
use m2, clear
keep q_item date TRQD
keep if inlist(q_item,"배추","양배추","당근","파인애플","무","양파")|inlist(q_item,"체리","참다래","아보카도","망고","바나나")
save t1, replace 

use m2, clear
keep if inlist(q_item,"배추","양배추","당근","파인애플","무","양파")|inlist(q_item,"체리","참다래","아보카도","망고","바나나")
keep if date <= mdy(3,31,2025)
keep q_item date TRQD 
tempfile original
save `original'

* Create the full set of all item-date combinations
* 모든 품목과 날짜의 완전한 조합 생성
* 1. Item list
* 1. 품목 리스트
preserve
    keep q_item
    duplicates drop
    tempfile items_list
    save `items_list'
restore

* 2. Date list (2022-01-01 to 2025-08-31)
* 2. 날짜 리스트 (2022년 1월 1일 ~ 2025년 8월 31일)
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
* 3. Cross join (모든 조합)
use `items_list', clear
cross using `dates_list'

* 4. Merge with the original data
* 4. 원본 데이터와 merge
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
replace TRQD=1 if q_item=="배추"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))  
replace TRQD=1 if q_item=="당근"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))  
replace TRQD=1 if q_item=="무"&inrange(date,mdy(4,1,2025),mdy(4,30,2025))  
replace TRQD=1 if q_item=="바나나"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))  
replace TRQD=1 if q_item=="바나나"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))  
replace TRQD=1 if q_item=="파인애플"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
replace TRQD=1 if q_item=="아보카도"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
replace TRQD=1 if q_item=="망고"&inrange(date,mdy(4,1,2025),mdy(6,30,2025))
gen time = string(date, "%tdCCYY-NN-DD")
drop _merge date
save t3, replace 









**==========================================================
** LP‑DiD @ h=250 for all combinations of 5:6 splits of 11 items
**==========================================================
clear all
set more off
local expanatory_vars_twoshocks "shock1 shock2 i.date BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours, vce(cluster qcode)"

use m4, clear
tsset qcode date, daily
local h = 250  
* 11개 품목 목록(순서 고정)
local ITEMS "양배추 파인애플 무 당근 참다래 양파 망고 바나나 아보카도 배추 체리"

* 결과 저장 준비
tempfile allresults
tempname postresults
postfile `postresults' ///
    str200 group1 str200 group2 ///
    long case_num long N_all long N1 long N2 long N_ctrl ///
    double b1 lb1 ub1 b2 lb2 ub2 ///
    using "`allresults'", replace

local case_num = 0

* ------ 11C6 조합 생성 루프 ------
forvalues i1 = 1/11 {
forvalues i2 = `=`i1'+1'/11 {
forvalues i3 = `=`i2'+1'/11 {
forvalues i4 = `=`i3'+1'/11 {
forvalues i5 = `=`i4'+1'/11 {
forvalues i6 = `=`i5'+1'/11 {

    local n1 : word `i1' of `ITEMS'
    local n2 : word `i2' of `ITEMS'
    local n3 : word `i3' of `ITEMS'
    local n4 : word `i4' of `ITEMS'
    local n5 : word `i5' of `ITEMS'
    local n6 : word `i6' of `ITEMS'

    local group1_str "`n1', `n2', `n3', `n4', `n5', `n6'"

    * 나머지 5개를 그룹2로 구성
    local group2_str ""
    local first = 1
    forvalues k = 1/11 {
        if !inlist(`k', `i1', `i2', `i3', `i4', `i5', `i6') {
            local nk : word `k' of `ITEMS'
            if `first' {
                local group2_str "`nk'"
                local first = 0
            }
            else {
                local group2_str "`group2_str', `nk'"
            }
        }
    }

    local case_num = `case_num' + 1

    preserve
        *-----------------------------
        * 그룹 정의 및 TRQD 재설정
        *-----------------------------
        gen byte d = 0
        replace d = 1 if inlist(q_item,"`n1'","`n2'","`n3'","`n4'","`n5'","`n6'")
        forvalues k = 1/11 {
            if !inlist(`k', `i1', `i2', `i3', `i4', `i5', `i6') {
                local nk : word `k' of `ITEMS'
                replace d = 2 if q_item=="`nk'"
            }
        }
        replace TRQD = 0 if d==0

        *-----------------------------
        * 이벤트 기준 및 강도 재계산
        *-----------------------------
        tsset qcode date, daily
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
        gen double TRQall_temp = TRQ if flag<. & inlist(d,1,2)
        by qcode: egen double TRQall = mean(TRQall_temp)
        gen double intensity_temp = (BaseTax - TRQall) if inlist(d,1,2)
        replace intensity_temp = 0 if intensity_temp < 0
        sort qcode rtime
        rangestat (mean) intensity_temp, interval(rtime -365 0) by(qcode)
        gen double intensity_temp2 = intensity_temp_mean if flag<. & inlist(d,1,2)
        by qcode: egen double intensity = mean(intensity_temp2)
        drop intensity_temp intensity_temp2 TRQall_temp
        replace intensity = 0 if missing(intensity)

        ************************************************
        * Clean control 판별을 위한 보조지표 (전 기간 기준)
        ************************************************        
        * ever treated (전 기간 중 TRQD==1이 있었는지)
        by qcode: egen byte ever_tr = max(TRQD)
        gen byte never_tr = (ever_tr==0)         
        label var never_tr "Never treated across full sample"
        * t 이전 처리 이력 여부(비흡수/반복 처리를 안전하게 배제)
        bysort qcode (date): gen long cum_tr = sum(TRQD)
        gen byte prev_treated = (L.cum_tr > 0)
        replace prev_treated = 0 if missing(prev_treated)

        ************************************************
        * h=250: 좌변과 클린 컨트롤 생성
        ************************************************
        gen byte   event0 = (L.TRQD==0 & TRQD==1)
        gen double dY     = F`h'.s_price - L.s_price
        gen double dX = F`h'.d_price - L.d_price

        quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
        replace TRQD_max = 0 if missing(TRQD_max)

        local ctrlcond "prev_treated==0 & TRQD==0 & TRQD_max==0"

        keep if ((event0==1 & inlist(d,1,2)) | (`ctrlcond'))
        drop if missing(dY)
        drop if missing(dX)

        count
        local Nall = r(N)
        count if event0==1 & d==1
        local N1 = r(N)
        count if event0==1 & d==2
        local N2 = r(N)
        count if `ctrlcond'
        local Nc = r(N)

        if (`Nall'==0 | (`N1'+`N2')==0 | `Nc'==0) {
            post `postresults' ("`group1_str'") ("`group2_str'") (`case_num') ///
                (`Nall') (`N1') (`N2') (`Nc') ///
                (. ) (. ) (. ) (. ) (. ) (. )
        }
        else {
            * 그룹별 충격(강도×신규처리×그룹지시)
            gen double shock1 = intensity*event0*(d==1)
            gen double shock2 = intensity*event0*(d==2)

            quietly regress dY `expanatory_vars_twoshocks'

            post `postresults' ("`group1_str'") ("`group2_str'") (`case_num') ///
                (`Nall') (`N1') (`N2') (`Nc') ///
                (_b[shock1]) (_b[shock1]-1.959964*_se[shock1]) (_b[shock1]+1.959964*_se[shock1]) ///
                (_b[shock2]) (_b[shock2]-1.959964*_se[shock2]) (_b[shock2]+1.959964*_se[shock2])
        }
    restore

}
}
}
}
}
}  
postclose `postresults'

use "`allresults'", clear
order case_num group1 group2 N_all N1 N2 N_ctrl b1 lb1 ub1 b2 lb2 ub2
sort case_num
save "LPDID_h200_5v6_allcombos.dta", replace
export excel using "LPDID_h200_5v6_allcombos.xlsx", firstrow(variables) replace




//!================================
//! How we divded into two groups?
use LPDID_h200_5v6_allcombos, clear 
keep group1 b1
rename (group1 b1) (group beta) 
save group1, replace  

use LPDID_h200_5v6_allcombos, clear 
keep group2 b2
rename (group2 b2) (group beta) 
save group2, replace 

use group1, clear 
append using group2 
sort beta 
gen id = _n 
tsset id 
twoway(tsline beta, lwidth(thick) lcolor(gs0)), ///
    xline(8) xline(84) ///
    ytitle("추정 계수값") xtitle("조합 경우의 수") ///
    xlabel(0(100)1000)
graph export group_division.png, replace width(3000)






//!================================
//! LP-DID graphs (Baseline), use STATA19
** one treated group; no intensity
do LPoneMAX_noG파양m4
** two treated groups; no intensity
do LPseparateMAX_noG파양m4
** one treated group; intensity
do LPoneMAX_G파양m4
** two treated groups; intensity
do LPseparateMAX_G파양m4
//!================================



//!================================
//! LP-DID graphs (Robustness Check), use STATA19
** one treated group; no intensity
do LPoneMAX_noG파양m1
** two treated groups; no intensity
do LPseparateMAX_noG파양m1
** one treated group; intensity
do LPoneMAX_G파양m1
** two treated groups; intensity
do LPseparateMAX_G파양m1
//!================================






//!======================================
//!======================================
//! Table generation for LP-DiD results
//!======================================
** one treated group
clear all
set more off
set matsize 11000, perm

local source_data="m1"
local expanatory_vars "shock i.date BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours, vce(cluster qcode)"

use `source_data', clear
xtset qcode date, daily

gen byte d = 0
replace d = 1 if inlist(q_item,"배추","양배추","무","양파","당근") ///
    | inlist(q_item,"체리","참다래","아보카도","망고","바나나","파인애플")
replace TRQD=0 if d==0

gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
by qcode: egen TRQstart = mean(flag)
gen rtime = date - TRQstart

gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
by qcode: egen double total_import100 = mean(total_import100_temp)
replace total_import= total_import100 if d==1&rtime>=0
by qcode: egen double total_import_mean = mean(total_import)
gen import=total_import/total_import_mean

replace s_price = ln(s_price)
replace d_price = ln(d_price)
replace i_price = ln(i_price)

foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
    rangestat (mean) `var', interval(date -100 0) by(qcode)
    drop `var'
    rename `var'_mean `var'
}

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

by qcode: egen byte ever_tr = max(TRQD)
gen byte never_tr = (ever_tr==0)            // 전 기간 TRQD==0인 품목
label var never_tr "Never treated across full sample"
bysort qcode (date): gen long cum_tr = sum(TRQD)
gen byte prev_treated = (L.cum_tr > 0)      // t 이전에 한 번이라도 TRQD==1
replace prev_treated = 0 if missing(prev_treated)

local h = 250
tsset qcode date, daily
gen byte event0 = (L.TRQD==0 & TRQD==1)
gen double dY = F`h'.s_price - L.s_price
gen double dX = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
replace TRQD_max = 0 if missing(TRQD_max)
local ctrlcond "prev_treated==0 & TRQD==0 & TRQD_max==0"
keep if ((event0==1 & d==1) | (`ctrlcond'))
drop if missing(dY)
drop if missing(dX)

eststo clear 
gen double shock = event0*(d==1)
eststo one_noG: qui reg dY `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)

replace shock=.
replace shock = intensity*event0*(d==1)
eststo one_G: qui reg dY `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)


//!===============================
** two treated group
clear
set more off
set matsize 11000, perm

local expanatory_vars "shock i.date BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours, vce(cluster qcode)"

use `source_data', clear
xtset qcode date, daily

local h = 250
capture noisily postutil clear
tempfile base
save "`base'", replace

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
tsset qcode date, daily
tempvar ev dY dX dI tmax
gen byte `ev' = (L.TRQD==0 & TRQD==1)
gen double `dY' = F`h'.s_price - L.s_price
gen double `dX' = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
rename TRQD_max `tmax'
replace `tmax' = 0 if missing(`tmax')
local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
keep if ((`ev'==1 & d==1) | (`ctrlcond'))
drop if missing(`dY')
drop if missing(`dX')

gen double shock = `ev'*(d==1)
eststo two_noG_group1: qui reg `dY' `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)

replace shock=.
replace shock = intensity*`ev'*(d==1)
eststo two_G_group1: qui reg `dY' `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)



************************************************
** Group 2
************************************************
use "`base'", clear
quietly _lp_common_prep 2
tsset qcode date, daily
tempvar ev dY dX dI tmax
gen byte `ev' = (L.TRQD==0 & TRQD==1)
gen double `dY' = F`h'.s_price - L.s_price
gen double `dX' = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
rename TRQD_max `tmax'
replace `tmax' = 0 if missing(`tmax')
local ctrlcond "prev_treated==0 & TRQD==0 & `tmax'==0"
keep if ((`ev'==1 & d==1) | (`ctrlcond'))
drop if missing(`dY')
drop if missing(`dX')

gen double shock = `ev'*(d==1)
eststo two_noG_group2: qui reg `dY' `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)

replace shock=.
replace shock = intensity*`ev'*(d==1)
eststo two_G_group2: qui reg `dY' `expanatory_vars'
display "Adjusted R-squared: " e(r2_a)

esttab one_noG two_noG_group1 two_noG_group2 one_G two_G_group1 two_G_group2 using "TRQ_table_`source_data'.tex", ///
    title(\label{tab:TRQ_table}) ///
    b(%9.5f) se(%9.5f) ///
    lab se r2 pr2 noconstant replace ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mgroups("Without intensity" "With Intensity", pattern(1 0 0 1 0 0) ///
    prefix(\multicolumn{@span}{c}{) suffix(}) ///
    span erepeat(\cmidrule(lr){@span})) ///
    addnotes("Evaluated at h=250 days")








//!======================================
//!======================================
//! Checking within R2 using areg, use STATA19
//!======================================
** one treated group
clear all
set more off
set matsize 11000, perm

use m4, clear
xtset qcode date, daily

local expanatory_vars_date_removed "shock BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours"

gen byte d = 0
replace d = 1 if inlist(q_item,"배추","양배추","무","양파","당근") ///
    | inlist(q_item,"체리","참다래","아보카도","망고","바나나","파인애플")
replace TRQD=0 if d==0

gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
by qcode: egen TRQstart = mean(flag)
gen rtime = date - TRQstart

gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
by qcode: egen double total_import100 = mean(total_import100_temp)
replace total_import= total_import100 if d==1&rtime>=0
by qcode: egen double total_import_mean = mean(total_import)
gen import=total_import/total_import_mean

replace s_price = ln(s_price)
replace d_price = ln(d_price)
replace i_price = ln(i_price)

foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
    rangestat (mean) `var', interval(date -100 0) by(qcode)
    drop `var'
    rename `var'_mean `var'
}

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

by qcode: egen byte ever_tr = max(TRQD)
gen byte never_tr = (ever_tr==0)            // 전 기간 TRQD==0인 품목
label var never_tr "Never treated across full sample"
bysort qcode (date): gen long cum_tr = sum(TRQD)
gen byte prev_treated = (L.cum_tr > 0)      // t 이전에 한 번이라도 TRQD==1
replace prev_treated = 0 if missing(prev_treated)

local h = 250
tsset qcode date, daily
gen byte event0 = (L.TRQD==0 & TRQD==1)
gen double dY = F`h'.s_price - L.s_price
gen double dX = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
replace TRQD_max = 0 if missing(TRQD_max)
local ctrlcond "prev_treated==0 & TRQD==0 & TRQD_max==0"
keep if ((event0==1 & d==1) | (`ctrlcond'))
drop if missing(dY)
drop if missing(dX)

egen date_id = group(date)
xtset qcode date_id


gen double shock = event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date_id) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // One_noG


replace shock=.
replace shock = intensity*event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // One_G




** two treated group 1
clear all
set more off
set matsize 11000, perm

use m4, clear
xtset qcode date, daily

local expanatory_vars_date_removed "shock BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours"

gen byte d = 0
replace d = 1 if inlist(q_item,"배추","양배추","무","양파","당근") 
drop if inlist(q_item,"체리","참다래","아보카도","망고","바나나","파인애플")
replace TRQD=0 if d==0

gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
by qcode: egen TRQstart = mean(flag)
gen rtime = date - TRQstart

gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
by qcode: egen double total_import100 = mean(total_import100_temp)
replace total_import= total_import100 if d==1&rtime>=0
by qcode: egen double total_import_mean = mean(total_import)
gen import=total_import/total_import_mean

replace s_price = ln(s_price)
replace d_price = ln(d_price)
replace i_price = ln(i_price)

foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
    rangestat (mean) `var', interval(date -100 0) by(qcode)
    drop `var'
    rename `var'_mean `var'
}

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

by qcode: egen byte ever_tr = max(TRQD)
gen byte never_tr = (ever_tr==0)            // 전 기간 TRQD==0인 품목
label var never_tr "Never treated across full sample"
bysort qcode (date): gen long cum_tr = sum(TRQD)
gen byte prev_treated = (L.cum_tr > 0)      // t 이전에 한 번이라도 TRQD==1
replace prev_treated = 0 if missing(prev_treated)

local h = 250
tsset qcode date, daily
gen byte event0 = (L.TRQD==0 & TRQD==1)
gen double dY = F`h'.s_price - L.s_price
gen double dX = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
replace TRQD_max = 0 if missing(TRQD_max)
local ctrlcond "prev_treated==0 & TRQD==0 & TRQD_max==0"
keep if ((event0==1 & d==1) | (`ctrlcond'))
drop if missing(dY)
drop if missing(dX)

egen date_id = group(date)
xtset qcode date_id


gen double shock = event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date_id) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // two_noG 1


replace shock=.
replace shock = intensity*event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // two_G 1





** two treated group 1
clear all
set more off
set matsize 11000, perm

use m4, clear
xtset qcode date, daily

local expanatory_vars_date_removed "shock BaseTax i.qcode#c.oil_price i.qcode#c.temp_avg i.qcode#c.humidity_avg i.qcode#c.precipitation_daily i.qcode#c.sunshine_hours i.qcode#c.L365.temp_avg i.qcode#c.L365.humidity_avg i.qcode#c.L365.precipitation_daily i.qcode#c.L365.sunshine_hours"

gen byte d = 0
replace d = 1 if inlist(q_item,"체리","참다래","아보카도","망고","바나나","파인애플")
drop if inlist(q_item,"배추","양배추","무","양파","당근")
replace TRQD=0 if d==0

gen flag = date if L.TRQD==0 & TRQD==1 & F.TRQD==1
by qcode: egen TRQstart = mean(flag)
gen rtime = date - TRQstart

gen total_import100_temp = total_import if d==1&inrange(rtime,-500,0)
by qcode: egen double total_import100 = mean(total_import100_temp)
replace total_import= total_import100 if d==1&rtime>=0
by qcode: egen double total_import_mean = mean(total_import)
gen import=total_import/total_import_mean

replace s_price = ln(s_price)
replace d_price = ln(d_price)
replace i_price = ln(i_price)

foreach var of varlist temp_avg humidity_avg precipitation_daily sunshine_hours {
    rangestat (mean) `var', interval(date -100 0) by(qcode)
    drop `var'
    rename `var'_mean `var'
}

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

by qcode: egen byte ever_tr = max(TRQD)
gen byte never_tr = (ever_tr==0)            // 전 기간 TRQD==0인 품목
label var never_tr "Never treated across full sample"
bysort qcode (date): gen long cum_tr = sum(TRQD)
gen byte prev_treated = (L.cum_tr > 0)      // t 이전에 한 번이라도 TRQD==1
replace prev_treated = 0 if missing(prev_treated)

local h = 250
tsset qcode date, daily
gen byte event0 = (L.TRQD==0 & TRQD==1)
gen double dY = F`h'.s_price - L.s_price
gen double dX = F`h'.d_price - L.d_price
quietly rangestat (max) TRQD, interval(date 1 `h') by(qcode)
replace TRQD_max = 0 if missing(TRQD_max)
local ctrlcond "prev_treated==0 & TRQD==0 & TRQD_max==0"
keep if ((event0==1 & d==1) | (`ctrlcond'))
drop if missing(dY)
drop if missing(dX)

egen date_id = group(date)
xtset qcode date_id


gen double shock = event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date_id) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // two_noG 2


replace shock=.
replace shock = intensity*event0*(d==1)
areg dY `expanatory_vars_date_removed', absorb(date) vce(cluster qcode)
display "Within R-squared: " e(r2_w)   // two_G 2








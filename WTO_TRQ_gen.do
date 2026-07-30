* Builds WTO_TRQ.dta (constants transcribed from "WTO 시장접근물량 증량현황_(2026.7.7).xlsx").
* Reading rules: '-' = 0; C1/C2 extensions carry over; ginger exception ends 2023-09-30; allotments expire at year-end. The xlsx item kiwi = dta item 참다래.
clear all
cd "D:\JJ Dropbox\KCTDI_Research\할당관세 정책이 소비자 물가에 미치는 영향\GItPublish_3rd_submit"
use m1_temp5, clear
keep q_item date
gen byte WTO_TRQ = 0
replace WTO_TRQ = 1 if inlist(q_item, "양파", "고구마", "건고추", "땅콩", "마늘", "붉은고추", "생강") | inlist(q_item, "콩", "파프리카", "풋고추", "피망", "녹두", "팥", "참깨")
gen double WTO_increase = 0
replace WTO_increase = 4.359409057883265 if q_item=="양파" & inrange(date, mdy(7,21,2023), mdy(12,31,2023))
replace WTO_increase = 0.9358914270576487 if q_item=="땅콩" & inrange(date, mdy(1,1,2021), mdy(12,31,2021))
replace WTO_increase = 1.037780449534367 if q_item=="땅콩" & inrange(date, mdy(1,1,2022), mdy(4,18,2022))
replace WTO_increase = 1.1396694720110854 if q_item=="땅콩" & inrange(date, mdy(4,19,2022), mdy(12,31,2022))
replace WTO_increase = 1.2226071363071342 if q_item=="땅콩" & inrange(date, mdy(1,1,2023), mdy(12,31,2023))
replace WTO_increase = 1.2226682697206201 if q_item=="땅콩" & inrange(date, mdy(1,1,2025), mdy(12,31,2025))
replace WTO_increase = 0.6912283127116887 if q_item=="마늘" & inrange(date, mdy(9,1,2022), mdy(12,31,2022))
replace WTO_increase = 0.8064516129032258 if q_item=="생강" & inrange(date, mdy(6,1,2023), mdy(9,30,2023))
replace WTO_increase = 0.20633844133335486 if q_item=="콩" & inrange(date, mdy(1,1,2021), mdy(12,31,2021))
replace WTO_increase = 0.18818324209982398 if q_item=="콩" & inrange(date, mdy(1,1,2022), mdy(4,18,2022))
replace WTO_increase = 0.36580600364934035 if q_item=="콩" & inrange(date, mdy(4,19,2022), mdy(7,25,2022))
replace WTO_increase = 0.4196310829067696 if q_item=="콩" & inrange(date, mdy(7,26,2022), mdy(12,31,2022))
replace WTO_increase = 0.24221285665843142 if q_item=="콩" & inrange(date, mdy(1,1,2023), mdy(12,31,2023))
replace WTO_increase = 0.20561180276337956 if q_item=="콩" & inrange(date, mdy(1,1,2024), mdy(12,31,2024))
replace WTO_increase = 0.17743975628004113 if q_item=="콩" & inrange(date, mdy(1,1,2025), mdy(12,31,2025))
replace WTO_increase = 0.6363141418265958 if q_item=="녹두" & inrange(date, mdy(1,1,2021), mdy(12,31,2021))
replace WTO_increase = 0.6261058935619981 if q_item=="녹두" & inrange(date, mdy(1,1,2022), mdy(12,31,2022))
replace WTO_increase = 0.5784674016605417 if q_item=="녹두" & inrange(date, mdy(1,1,2023), mdy(12,31,2023))
replace WTO_increase = 0.5752688172043011 if q_item=="녹두" & inrange(date, mdy(1,1,2024), mdy(12,31,2024))
replace WTO_increase = 0.5720021777596298 if q_item=="녹두" & inrange(date, mdy(1,1,2025), mdy(12,31,2025))
replace WTO_increase = 8.508245431585204 if q_item=="참깨" & inrange(date, mdy(1,1,2021), mdy(12,31,2021))
replace WTO_increase = 8.508245431585204 if q_item=="참깨" & inrange(date, mdy(1,1,2022), mdy(7,25,2022))
replace WTO_increase = 8.95394443619076 if q_item=="참깨" & inrange(date, mdy(7,26,2022), mdy(12,31,2022))
replace WTO_increase = 9.548209775664834 if q_item=="참깨" & inrange(date, mdy(1,1,2023), mdy(12,31,2023))
replace WTO_increase = 9.399643440796316 if q_item=="참깨" & inrange(date, mdy(1,1,2024), mdy(12,31,2024))
replace WTO_increase = 9.399643440796316 if q_item=="참깨" & inrange(date, mdy(1,1,2025), mdy(12,31,2025))
gen double WTO_gap = 0
replace WTO_gap = 5.775 if q_item=="녹두"
replace WTO_gap = 0.239 if q_item=="땅콩"
replace WTO_gap = 3.1 if q_item=="마늘"
replace WTO_gap = 3.573 if q_item=="생강"
replace WTO_gap = 0.8500000000000001 if q_item=="양파"
replace WTO_gap = 5.8999999999999995 if q_item=="참깨"
replace WTO_gap = 4.82 if q_item=="콩"
gen double WTO_bite = WTO_increase * WTO_gap
drop WTO_gap
assert !missing(WTO_TRQ) & !missing(WTO_increase) & !missing(WTO_bite)
keep q_item date WTO_TRQ WTO_increase WTO_bite
compress
save WTO_TRQ, replace
di "WTO_TRQ.dta OK"

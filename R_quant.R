## ===== R: 패널용 계절/달력 성분 제거 + 안전한 CSV 저장 =====
## 경로
dir_path <- "D:/JJ Dropbox/KCTDI_Research/할당관세 정책이 소비자 물가에 미치는 영향/selected"
in_path  <- file.path(dir_path, "q_all_weekly.csv")
out_path <- file.path(dir_path, "q_all_weekly_STL_result.csv")
hol_path <- file.path(dir_path, "kr_holidays_2021_2025.csv")  # 'date' 열(YYYY-MM-DD) 기대

## 1) 입력 읽기 (인코딩 안전) - 수정: price 변수 추가 확인
encs <- c("CP949","EUC-KR","UTF-8","UTF-8-BOM","latin1","windows-1252")
df <- NULL; used_enc <- NA
for (enc in encs) {
  df <- tryCatch(read.csv(in_path, fileEncoding = enc, stringsAsFactors = FALSE),
                 error = function(e) NULL, warning = function(w) NULL)
  if (!is.null(df)) { used_enc <- enc; break }
}
stopifnot(!is.null(df))
stopifnot(all(c("item","item2","time","date","quant","price") %in% names(df)))  # quant, price로 변경
df$date <- as.Date(df$date)
df <- df[order(df$item2, df$date), ]

## 2) 보조함수 (휴일 더미 생성)
hol_dummy_for_weeks <- function(week_mondays){
  h <- integer(length(week_mondays))
  if (!file.exists(hol_path)) return(h)
  hol <- tryCatch(read.csv(hol_path, stringsAsFactors = FALSE), error=function(e) NULL)
  if (is.null(hol) || !("date" %in% names(hol))) return(h)
  hol$d <- as.Date(hol$date)
  hol$wk_start <- hol$d - as.integer(strftime(hol$d, "%u")) + 1  # ISO 주 시작일 (월요일)
  tab <- table(hol$wk_start)
  as.integer(as.Date(week_mondays) %in% as.Date(names(tab)))
}

## 3) 설정 (계절성 제거: 주차 더미 사용으로 Fourier 변수 불필요)
# include_month, K52, K13 등 설정은 제거 (주차 더미로 계절성 포착)

## 4) 품목별 계절/달력 성분 제거 (주차 더미 활용, 곱셈형/가법형) - 수정: price 추가
remove_season_calendar <- function(g){
  g <- g[order(g$date), ]
  iso_w <- as.integer(strftime(g$date, "%V"))
  g <- g[iso_w != 53, ]                     # ISO 53주차는 제거하여 52주 주기 맞춤
  if (nrow(g) < 120) {                      # 데이터 120주 미만이면 계절 조정 수행 안 함
    g$quant_sa_add <- NA_real_; g$quant_sa_mul <- NA_real_
    g$price_sa_add <- NA_real_; g$price_sa_mul <- NA_real_  # price 계절조정 변수 추가
    return(g[, c("item","item2","time","date","quant","quant_sa_add","quant_sa_mul","price","price_sa_add","price_sa_mul")])
  }
  n <- nrow(g)
  # 주차 요인변수 생성 (연간 주기 52주) 및 휴일더미
  week_factor <- factor(strftime(g$date, "%V"))
  contrasts(week_factor) <- contr.sum(length(levels(week_factor)))  # 계절 효과 합=0 제약
  H <- matrix(hol_dummy_for_weeks(g$date), ncol=1); colnames(H) <- "HOL"
  Z <- data.frame(week = week_factor, HOL = H[,1])  # 회귀용 데이터프레임
  
  # ---- quant 변수에 대한 곱셈형 조정 (로그 모델)
  quant_pos <- pmax(as.numeric(g$quant), .Machine$double.eps)
  quant_log <- log(quant_pos)
  fit_quant_m <- tryCatch(lm(quant_log ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_quant_m)) {
    g$quant_sa_mul <- NA_real_
  } else {
    pred_quant_log <- predict(fit_quant_m)
    intercept_quant_log <- coef(fit_quant_m)["(Intercept)"]; if (is.na(intercept_quant_log)) intercept_quant_log <- 0
    S_quant_m <- pred_quant_log - intercept_quant_log            # 추정된 계절+달력 성분 (로그척도)
    g$quant_sa_mul <- exp(quant_log - S_quant_m)                 # 원 데이터에서 계절 성분 제거 (곱셈형)
  }
  
  # ---- quant 변수에 대한 가법형 조정
  fit_quant_a <- tryCatch(lm(as.numeric(g$quant) ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_quant_a)) {
    g$quant_sa_add <- NA_real_
  } else {
    pred_quant <- predict(fit_quant_a)
    intercept_quant_a <- coef(fit_quant_a)["(Intercept)"]; if (is.na(intercept_quant_a)) intercept_quant_a <- 0
    S_quant_a <- pred_quant - intercept_quant_a                 # 추정된 계절+달력 성분 (원 척도)
    g$quant_sa_add <- as.numeric(g$quant) - S_quant_a           # 원 데이터에서 계절 성분 제거 (가법형)
  }
  
  # ---- price 변수에 대한 곱셈형 조정 (로그 모델) - 새로 추가
  price_pos <- pmax(as.numeric(g$price), .Machine$double.eps)
  price_log <- log(price_pos)
  fit_price_m <- tryCatch(lm(price_log ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_price_m)) {
    g$price_sa_mul <- NA_real_
  } else {
    pred_price_log <- predict(fit_price_m)
    intercept_price_log <- coef(fit_price_m)["(Intercept)"]; if (is.na(intercept_price_log)) intercept_price_log <- 0
    S_price_m <- pred_price_log - intercept_price_log            # 추정된 계절+달력 성분 (로그척도)
    g$price_sa_mul <- exp(price_log - S_price_m)                 # 원 데이터에서 계절 성분 제거 (곱셈형)
  }
  
  # ---- price 변수에 대한 가법형 조정 - 새로 추가
  fit_price_a <- tryCatch(lm(as.numeric(g$price) ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_price_a)) {
    g$price_sa_add <- NA_real_
  } else {
    pred_price <- predict(fit_price_a)
    intercept_price_a <- coef(fit_price_a)["(Intercept)"]; if (is.na(intercept_price_a)) intercept_price_a <- 0
    S_price_a <- pred_price - intercept_price_a                 # 추정된 계절+달력 성분 (원 척도)
    g$price_sa_add <- as.numeric(g$price) - S_price_a           # 원 데이터에서 계절 성분 제거 (가법형)
  }
  
  g[, c("item","item2","time","date","quant","quant_sa_add","quant_sa_mul","price","price_sa_add","price_sa_mul")]
}

## 5) 전체 적용 & 저장 (숫자형 변환 및 NA→공란 처리) - 수정: price 변수들 추가
res <- do.call(rbind, lapply(split(df, df$item2), remove_season_calendar))
res$quant           <- as.numeric(res$quant)
res$quant_sa_add    <- as.numeric(res$quant_sa_add)
res$quant_sa_mul    <- as.numeric(res$quant_sa_mul)
res$price           <- as.numeric(res$price)           # 새로 추가
res$price_sa_add    <- as.numeric(res$price_sa_add)    # 새로 추가
res$price_sa_mul    <- as.numeric(res$price_sa_mul)    # 새로 추가

write.csv(
  res[, c("item","item2","date","quant","quant_sa_add","quant_sa_mul","price","price_sa_add","price_sa_mul")],  # price 변수들 추가
  out_path,
  row.names = FALSE, fileEncoding = "CP949", na = ""
)
cat("완료. 사용 인코딩:", used_enc, "\n저장:", out_path, "\n")


## ===== (수정된) R: 패널용 계절/달력 성분 제거 + 안전한 CSV 저장 =====

## 경로
dir_path <- "D:/JJ Dropbox/KCTDI_Research/할당관세 정책이 소비자 물가에 미치는 영향/농넷 자료 요청/요청데이터(도매,소매, 소비트렌드)"
in_path  <- file.path(dir_path, "q_all_weekly.csv")
out_path <- file.path(dir_path, "q_all_weekly_STL_result.csv")
hol_path <- file.path(dir_path, "kr_holidays_2021_2025.csv")  # 'date' 열(YYYY-MM-DD) 기대

## 1) 입력 읽기 (인코딩 안전) - 기존과 동일
encs <- c("CP949","EUC-KR","UTF-8","UTF-8-BOM","latin1","windows-1252")
df <- NULL; used_enc <- NA
for (enc in encs) {
  df <- tryCatch(read.csv(in_path, fileEncoding = enc, stringsAsFactors = FALSE),
                 error = function(e) NULL, warning = function(w) NULL)
  if (!is.null(df)) { used_enc <- enc; break }
}
stopifnot(!is.null(df))
stopifnot(all(c("item","item2","time","date","y") %in% names(df)))
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

## 4) 품목별 계절/달력 성분 제거 (주차 더미 활용, 곱셈형/가법형)
remove_season_calendar <- function(g){
  g <- g[order(g$date), ]
  iso_w <- as.integer(strftime(g$date, "%V"))
  g <- g[iso_w != 53, ]                     # ISO 53주차는 제거하여 52주 주기 맞춤
  if (nrow(g) < 120) {                      # 데이터 120주 미만이면 계절 조정 수행 안 함
    g$y_sa_add <- NA_real_; g$y_sa_mul <- NA_real_
    return(g[, c("item","item2","time","date","y","y_sa_add","y_sa_mul")])
  }
  n <- nrow(g)
  # 주차 요인변수 생성 (연간 주기 52주) 및 휴일더미
  week_factor <- factor(strftime(g$date, "%V"))
  contrasts(week_factor) <- contr.sum(length(levels(week_factor)))  # 계절 효과 합=0 제약
  H <- matrix(hol_dummy_for_weeks(g$date), ncol=1); colnames(H) <- "HOL"
  Z <- data.frame(week = week_factor, HOL = H[,1])  # 회귀용 데이터프레임
  
  # ---- 곱셈형 조정 (로그 모델)
  y_pos <- pmax(as.numeric(g$y), .Machine$double.eps)
  y_log <- log(y_pos)
  fit_m <- tryCatch(lm(y_log ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_m)) {
    g$y_sa_mul <- NA_real_
  } else {
    pred_log <- predict(fit_m)
    intercept_log <- coef(fit_m)["(Intercept)"]; if (is.na(intercept_log)) intercept_log <- 0
    S_m <- pred_log - intercept_log            # 추정된 계절+달력 성분 (로그척도)
    g$y_sa_mul <- exp(y_log - S_m)             # 원 데이터에서 계절 성분 제거 (곱셈형)
  }
  # ---- 가법형 조정
  fit_a <- tryCatch(lm(as.numeric(g$y) ~ week + HOL, data = Z), error=function(e) NULL)
  if (is.null(fit_a)) {
    g$y_sa_add <- NA_real_
  } else {
    pred <- predict(fit_a)
    intercept_a <- coef(fit_a)["(Intercept)"]; if (is.na(intercept_a)) intercept_a <- 0
    S_a <- pred - intercept_a                 # 추정된 계절+달력 성분 (원 척도)
    g$y_sa_add <- as.numeric(g$y) - S_a       # 원 데이터에서 계절 성분 제거 (가법형)
  }
  
  g[, c("item","item2","time","date","y","y_sa_add","y_sa_mul")]
}

## 5) 전체 적용 & 저장 (숫자형 변환 및 NA→공란 처리)
res <- do.call(rbind, lapply(split(df, df$item2), remove_season_calendar))
res$y        <- as.numeric(res$y)
res$y_sa_add <- as.numeric(res$y_sa_add)
res$y_sa_mul <- as.numeric(res$y_sa_mul)

write.csv(
  res[, c("item","item2","date","y","y_sa_add","y_sa_mul")],
  out_path,
  row.names = FALSE, fileEncoding = "CP949", na = ""
)

cat("완료. 사용 인코딩:", used_enc, "\n저장:", out_path, "\n")

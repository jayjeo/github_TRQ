## ===== R: Daily price seasonality removal (panel, keep 품목코드) =====
dir_path <- "D:/JJ Dropbox/KCTDI_Research/할당관세 정책이 소비자 물가에 미치는 영향/selected"
in_path  <- file.path(dir_path, "q_all_daily.csv")
out_path <- file.path(dir_path, "q_all_daily_STL_result.csv")
hol_path <- file.path(dir_path, "kr_holidays_2021_2025.csv")  # date 열(YYYY-MM-DD)

encs <- c("CP949","EUC-KR","UTF-8","UTF-8-BOM","latin1","windows-1252")
df <- NULL; used_enc <- NA
for (enc in encs) {
  df <- tryCatch(read.csv(in_path, fileEncoding = enc, stringsAsFactors = FALSE),
                 error=function(e) NULL, warning=function(w) NULL)
  if (!is.null(df)) { used_enc <- enc; break }
}
stopifnot(!is.null(df))
stopifnot(all(c("품목코드","some","some2","date","y") %in% names(df)))
df$date <- as.Date(df$date); df$y <- suppressWarnings(as.numeric(df$y))
df <- df[order(df$some2, df$date), ]

hol_dates <- NULL
if (file.exists(hol_path)) {
  hol <- tryCatch(read.csv(hol_path, stringsAsFactors = FALSE), error=function(e) NULL)
  if (!is.null(hol) && ("date" %in% names(hol))) hol_dates <- as.Date(hol$date)
}

fourier_doy <- function(doy_num, K=12, year_len=365.25) {
  t <- as.numeric(doy_num); X <- matrix(0, length(t), 2*K); cn <- character(2*K); j <- 1
  for (k in 1:K) { X[,j] <- sin(2*pi*k*t/year_len); cn[j] <- paste0("S",k)
  X[,j+1] <- cos(2*pi*k*t/year_len); cn[j+1] <- paste0("C",k); j <- j+2 }
  colnames(X) <- cn; X
}

remove_daily_season <- function(g){
  g <- g[order(g$date), ]
  idx <- is.finite(g$y) & !is.na(g$date)
  if (!any(idx) || sum(idx) < 120) {
    g$y_sa_add <- NA_real_; g$y_sa_mul <- NA_real_
    return(g[, c("품목코드","some","some2","date","y","y_sa_add","y_sa_mul")])
  }
  g2 <- g[idx, , drop=FALSE]; n <- nrow(g2)
  
  dow <- factor(strftime(g2$date, "%u"), levels=c("1","2","3","4","5","6","7"))
  X_dow <- model.matrix(~ dow - 1)
  
  doy_num <- as.integer(strftime(g2$date, "%j"))
  K <- min(24, max(8, floor(length(unique(doy_num))/6)))
  X_four <- fourier_doy(doy_num, K=K)
  
  HOL <- if (is.null(hol_dates)) integer(n) else as.integer(g2$date %in% hol_dates)
  X <- cbind(Intercept=1, X_dow, X_four, HOL=HOL)
  
  y_pos <- pmax(g2$y, .Machine$double.eps)
  y_log <- log(y_pos)
  
  fitM <- suppressWarnings(tryCatch(stats::lm.fit(x=X, y=y_log), error=function(e) NULL))
  if (is.null(fitM)) { g$y_sa_mul <- NA_real_ } else {
    b <- fitM$coefficients; b[!is.finite(b)] <- 0
    fit_log <- as.numeric(X %*% b); seas_log <- fit_log - mean(fit_log)
    g$y_sa_mul <- NA_real_; g$y_sa_mul[idx] <- exp(y_log - seas_log)
  }
  
  fitA <- suppressWarnings(tryCatch(stats::lm.fit(x=X, y=g2$y), error=function(e) NULL))
  if (is.null(fitA)) { g$y_sa_add <- NA_real_ } else {
    bA <- fitA$coefficients; bA[!is.finite(bA)] <- 0
    fit_lin <- as.numeric(X %*% bA); seas_lin <- fit_lin - mean(fit_lin)
    g$y_sa_add <- NA_real_; g$y_sa_add[idx] <- g2$y - seas_lin
  }
  
  g[, c("품목코드","some","some2","date","y","y_sa_add","y_sa_mul")]
}

res <- do.call(rbind, lapply(split(df, df$some2), remove_daily_season))
res$y <- suppressWarnings(as.numeric(res$y))
res$y_sa_add <- suppressWarnings(as.numeric(res$y_sa_add))
res$y_sa_mul <- suppressWarnings(as.numeric(res$y_sa_mul))

write.csv(res, out_path, row.names=FALSE, fileEncoding="CP949", na="")
cat("완료. 인코딩:", used_enc, " / 저장:", out_path, "\n")

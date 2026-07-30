program define check_TRQquota
    args item
        use m1, clear
        gen ti=total_import
        keep q_item date ti
        keep if inrange(date,22281,23831)  // 2021-01-01 ~ 2025-03-31
        keep if q_item=="`item'"
        gen mtime = mofd(date)
        format mtime %tm
        drop date 
        duplicates drop 
        sort q_item mtime
end 


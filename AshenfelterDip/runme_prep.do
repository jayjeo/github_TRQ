clear all
set more off
set matsize 11000, perm
capture noisily do "AD_prep.do"
local core_rc = _rc
if `core_rc' != 0 di as error "CORE_FAILED rc=`core_rc'"
exit `core_rc'

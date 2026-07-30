clear all
set more off
set matsize 11000, perm
capture noisily do "AD_pre_core2.do" V2p 2
local core_rc = _rc
if `core_rc' != 0 di as error "CORE_FAILED rc=`core_rc'"
exit `core_rc'

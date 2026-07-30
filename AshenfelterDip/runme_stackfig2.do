clear all
set more off
capture noisily do "AD_stackfig2.do"
local core_rc = _rc
if `core_rc' != 0 di as error "CORE_FAILED rc=`core_rc'"
exit `core_rc'

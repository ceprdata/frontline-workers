/*
File:	cepr_acs_read_1418.do
Date:	May 30, 2020, CEPR ACS 2014-2018 Beta Version
Desc:	Reads and pre-processes raw ACS 5-year sample (2014-2018) data
*/

	/*Windows vs. GNU/Linux*/

global gnulin = 1 /* Set to 0 if you run Windows; 1 if GNU/Linux/Unix/Mac */
global version "beta"

if $gnulin==0 {

/* set directories */ 
global do "\ACS\do" /* do files extracts */
global raw_data "\ACS\raw_data" /* original Census files */
global working "\ACS\tmp" /* CEPR extracts in progress */
global dataout "\ACS\data" /* final CEPR extracts */

}


if $gnulin==1 {

/* set directories */
global do "/ACS/do" 
global raw_data "/ACS/raw_data"  
global working "/ACS/tmp"
global dataout "/ACS/data"

}


capture program drop rd1418

program define rd1418
version 9.0

/* read raw ACS person and household records
* syntax: macro 1 refers to a and b files
*/
/* read person records */

cd "$raw_data"
cd 1418
unzipfile csv_pus.zip
qui insheet using psam_pusa.csv, comma names clear
sort serialno
compress
cd "$working"
save "p_1418_temp_a.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_pusb.csv, comma names clear
sort serialno
compress
cd "$working"
save "p_1418_temp_b.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_pusc.csv, comma names clear
sort serialno
compress
cd "$working"
save "p_1418_temp_c.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_pusd.csv, comma names clear
sort serialno
compress
cd "$working"
save "p_1418_temp_d.dta", replace

cd "$raw_data"
cd 1418
zipfile *.csv, saving(csv_pus.zip, replace)
erase psam_pusa.csv
erase psam_pusb.csv
erase psam_pusc.csv
erase psam_pusd.csv

/* read household records */

cd "$raw_data"
cd 1418
unzipfile csv_hus.zip
qui insheet using psam_husa.csv, comma names clear
sort serialno
compress
cd "$working"
save "h_1418_temp_a.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_husb.csv, comma names clear
sort serialno
compress
cd "$working"
save "h_1418_temp_b.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_husc.csv, comma names clear
sort serialno
compress
cd "$working"
save "h_1418_temp_c.dta", replace

cd "$raw_data"
cd 1418
qui insheet using psam_husd.csv, comma names clear
sort serialno
compress
cd "$working"
save "h_1418_temp_d.dta", replace

cd "$raw_data"
cd 1418
zipfile *.csv, saving(csv_hus.zip, replace)
erase psam_husa.csv
erase psam_husb.csv
erase psam_husc.csv
erase psam_husd.csv
end



capture program drop com1418
program define com1418
version 9.0

/* append p files */

cd "$working"
use "p_1418_temp_a", clear
append using "p_1418_temp_b"
append using "p_1418_temp_c"
append using "p_1418_temp_d"
sort serialno sporder
save "p_1418_temp_abcd", replace
cd "$raw_data"
sort serialno sporder
label data "Raw 1418 ACS person level data, converted to Stata format"
save "acs_1418_P_raw", replace

/* append and merge p, h files

append h files */

cd "$working"
use "h_1418_temp_a", clear
append using "h_1418_temp_b"
append using "h_1418_temp_c"
append using "h_1418_temp_d"
sort serialno
save "h_1418_temp_abcd", replace
cd "$raw_data"
sort serialno
label data "Raw 1418 ACS household level data, converted to Stata format"
save "acs_1418_H_raw", replace

/* attach household variables to person records

merge p, h files */

cd "$working"
use "h_1418_temp_abcd", clear
merge serialno using "p_1418_temp_abcd"

drop rt /* drop record type, since the P and H are now combined */
assert _merge==1 /* vacant houses */ | _merge==3
	/* keep vacant housing units for subsequent analysis of vacancies */
drop _merge

sort serialno sporder
compress
cd "$working"
save "acs_1418_pre_all", replace

cd "$working"
!rm "p_1418_temp_a.dta"
!rm "p_1418_temp_b.dta"
!rm "p_1418_temp_c.dta"
!rm "p_1418_temp_d.dta"
!rm "p_1418_temp_abcd.dta"
!rm "h_1418_temp_a.dta"
!rm "h_1418_temp_b.dta"
!rm "h_1418_temp_c.dta"
!rm "h_1418_temp_d.dta"
!rm "h_1418_temp_abcd.dta"

end

/* program switches */

	/* read raw data */

clear
set mem 2g

rd1418

	/* combine all variables in all state files 
	   (if RAM is sufficiently large) */

clear
set mem 4g

com1418


cd "$dataout"
save cepr_acs_1418_beta, replace




/* 
Copyright 2020 CEPR, Hye Jin Rho Hayley Brown

Center for Economic and Policy Research
1611 Connecticut Avenue, NW Suite 400
Washington, DC 20009
Tel: (202) 293-5380
Fax: (202) 588-1356
http://www.cepr.net

This file and all related programs are free software. You can redistribute the
program or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA.
*/

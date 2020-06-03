
set more 1

/*
File: frontline_workers_tables.do
Date: April 1, 2020
Desc: industry / occupation of frontline workers
*/


	/*Windows vs. GNU/Linux*/

global gnulin = 1 /* Set to 0 if you run Windows; 1 if GNU/Linux/Unix/Mac */
global version "beta"

if $gnulin==0 {

/* set directories */ 
global do "\frontline-workers\do" 
global data "\frontline-workers\data" 
global log "\frontline-workers\log"

}


if $gnulin==1 {

/* set directories */
global do "/frontline-workers/do" 
global data "/frontline-workers/data"  
global log "/frontline-workers/log"

}


cd "$data"
use cepr_acs_1418_beta_frontline.dta, clear
	
cd "$log"
cap rm `"tables_all.xlsx"'


/* additional recoding */

gen nonw=0 if wbhao~=.
replace nonw=1 if wbhao~=1
lab var nonw "Non-white"


/* tables */

* US

tabout flind1 [fw=perwgt] if lfstat==1 ///
	using table_us.xls, c(freq col) f(0c 1) clab(_) font(bold) replace	
tabout lfstat [fw=perwgt] using table_0.xls, c(freq) f(0c) append	
tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
	hhoc_b hhsenior_b flind1 [fw=perwgt] if lfstat==1 ///
	using table_us.xls, c(col) f(1) clab(_) font(bold) append
tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
	hhoc_b hhsenior_b flind [fw=perwgt] if lfstat==1 ///
	using table_us.xls, c(col) f(1) clab(_) font(bold) append
foreach v in female nonw forborn pov200 {
	tabout flind_dd `v' [fw=perwgt] if lfstat==1 & flind==1 /// 
		using table_us.xls, c(row) f(1) clab(_) font(bold) append
}
tabout state flind1 ///
	[fw=perwgt] if lfstat==1 ///
	using table_us.xls, c(freq col) f(0c 1) clab(_) font(bold) append

	* occupation crosstab for each industry
log using indocc.log, replace
forval i = 1/6 {
	tab socp18 [fw=perwgt] if flind1==`i' & lfstat==1, sort
	tab socp18 female [fw=perwgt] if flind1==`i' & lfstat==1, row	
}
log close	
	
log using indocc2.log, replace
foreach v in female nonw forborn pov200 {
	forval i = 1/6 {
		tabsort socp18 `v' [fw=perwgt] if lfstat==1 & flind1==`i', row nofreq
	}
}
log close		


* by state
forval i = 1/56 {
if inlist(`i',3,7,14,43,52) continue
	tabout flind1 ///
		[fw=perwgt] if lfstat==1 & state==`i' /// 
		using table_`i'.xls, c(freq col) f(0c 1) clab(_) font(bold) replace
	tabout lfstat [fw=perwgt] if state==`i' using table_`i'.xls, c(freq) f(0c) append		
	tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
		hhoc_b hhsenior_b flind1 [fw=perwgt] if lfstat==1 & state==`i' /// 
		using table_`i'.xls, c(col) f(1) font(bold) append
	tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
		hhoc_b hhsenior_b flind [fw=perwgt] if lfstat==1 & state==`i' ///
		using table_`i'.xls, c(col) f(1) clab(_) font(bold) append
	tabout flind_dd [fw=perwgt] if lfstat==1 & flind==1 & state==`i' /// 
		using table_`i'.xls, c(freq col) f(0c 1) clab(_) font(bold) append	
}

	* append all state tables into one spreadsheet
forval i = 1/56 {
if inlist(`i',3,7,14,43,52) continue
preserve
	insheet using `"table_`i'.xls"', clear nonames
	export excel using `"tables_all.xlsx"', sheetreplace sheet("`i'")
	rm `"table_`i'.xls"'
restore
}


* NYC

gen ny=0 if state~=.
replace ny=1 if state==36
lab var ny "New York"
lab val ny ny

gen nyc=0 if state==36
replace nyc=1 if (puma>=3701 & puma<=4114) & state==36
lab var nyc "New York City"
lab val nyc nyc

gen li=0 if state==36
replace li=1 if (puma>=3201 & puma<=3313) & state==36
lab var li "Long Island"
lab val li li

gen hv=0 if state==36
replace hv=1 if ((puma>=2701 & puma<=2702) | (puma>=2901 & puma<=2903) | /*
*/(puma>=2801 & puma<=2802) | (puma>=3102 & puma<=3107) | (puma>=3001 & puma<=3003)) /*
*/ & state==36
lab var hv "Hudson Vally"
lab val hv hv

gen nyother=1 if state==36
replace nyother=0 if nyc==1 | li==1 | hv==1
lab var nyother "NY (without NYC, LI, HV)"
lab val nyother nyother

foreach i in ny nyc li hv nyother {
	tabout flind1 ///
		[fw=perwgt] if lfstat==1 & `i'==1 /// 
		using table_`i'.xls, c(freq col) f(0c 1) clab(_) font(bold) replace	
	tabout lfstat [fw=perwgt] if `i'==1 using table_`i'.xls, c(freq) f(0c) append		
	tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
		hhoc_b hhsenior_b flind1 [fw=perwgt] if lfstat==1 & `i'==1 /// 
		using table_`i'.xls, c(col) f(1) font(bold) append
	tabout female ftpt wbhao forborn educ age50 hmown pubtran poor pov200 hins ///
		hhoc_b hhsenior_b flind [fw=perwgt] if lfstat==1 & `i'==1 ///
		using table_`i'.xls, c(col) f(1) clab(_) font(bold) append
	tabout flind_dd [fw=perwgt] if lfstat==1 & flind==1 & `i'==1 /// 
		using table_`i'.xls, c(freq col) f(0c 1) clab(_) font(bold) append
}

	* append all NY tables into one spreadsheet
foreach i in ny nyc li hv nyother {
preserve
	insheet using `"table_`i'.xls"', clear nonames
	export excel using `"tables_ny.xlsx"', sheetreplace sheet("`i'")
	rm `"table_`i'.xls"'
restore
}


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


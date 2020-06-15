clear
set more 1

/*
File:	cepr_frontline-workers_bl.do
Date:	03 June 2020
Desc: 	Variable recodes and data tabulations for Black frontline industry workers figures,
		using CEPR frontline extract of 5-year ACS (2014-2018)
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


/* ADDITIONAL VARIABLE RECODES */

/* Frontline industry, NYC comptroller categories */
gen flind_og=.
replace flind_og=1 if ind3d_18==4470 | ind3d_18==4971 | ind3d_18==4972 | ind3d_18==5070 | ind3d_18==5391
replace flind_og=2 if ind3d_18==6080 | ind3d_18==6180 
replace flind_og=3 if ind3d_18==6170 | ind3d_18==6390 | ind3d_18==6370
replace flind_og=4 if ind3d_18==7690
replace flind_og=5 if ind3d_18==7970 | ind3d_18==8090 | ind3d_18==8170 | ind3d_18==8180 | ind3d_18==8191 ///
| ind3d_18==8192 | ind3d_18==8270 | ind3d_18==8290
replace flind_og=6 if ind3d_18==8370 | ind3d_18==8380 | ind3d_18==8470

# delimit ;
lab def flind_og
1 "Grocery, Convenience, and Drug Stores"
2 "Public Transit"
3 "Trucking, Warehouse, and Postal Service"
4 "Building Cleaning Services"
5 "Health Care"
6 "Childcare and Social Services"
;
#delimit cr
lab var flind_og "Frontline industry, NYC comptroller categories"
lab val flind_og flind_og

gen flind_og1=0 if flind~=.
replace flind_og1=1 if flind_og==1
lab var flind_og1 "Grocery, Convenience, and Drug Stores"
lab val flind_og1 noyes

gen flind_og2=0 if flind~=.
replace flind_og2=1 if flind_og==2
lab var flind_og2 "Public Transit"
lab val flind_og2 noyes

gen flind_og3=0 if flind~=.
replace flind_og3=1 if flind_og==3
lab var flind_og3 "Trucking, Warehouse, and Postal Service"
lab val flind_og3 noyes

gen flind_og4=0 if flind~=.
replace flind_og4=1 if flind_og==4
lab var flind_og4 "Building Cleaning Services"
lab val flind_og4 noyes

gen flind_og5=0 if flind~=.
replace flind_og5=1 if flind_og==5
lab var flind_og5 "Health Care"
lab val flind_og5 noyes

gen flind_og6=0 if flind~=.
replace flind_og6=1 if flind_og==6
lab var flind_og6 "Childcare and Social Services"
lab val flind_og6 noyes

/* Race */
gen white=0 if wbhao~=.
replace white=1 if wbhao==1
lab var white "White"
lab val white noyes

gen black=0 if wbhao~=.
replace black=1 if wbhao==2
lab var black "Black"
lab val black noyes

/* Education and race */
gen eduwc=0 if educ~=.
replace eduwc=1 if educ==1 | educ==2 | educ==3
lab var eduwc "Less than BA/BS"
lab val eduwc noyes

gen eduwcwh=0 if educ~=. & wbhao~=.
replace eduwcwh=1 if eduwc==1 & wbhao==1
lab var eduwcwh "White, less than BA/BS"
lab val eduwcwh noyes

gen eduwcbl=0 if educ~=. & wbhao~=.
replace eduwcbl=1 if eduwc==1 & wbhao==2
lab var eduwcbl "Black, less than BA/BS"
lab val eduwcbl noyes


/* TABLES */

cd "$log"
cap rm `"tables_all.xlsx"'

/* all US */
foreach i in lfstat white black eduwc eduwcwh eduwcbl {
tabout wbhao flind_og [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, ///
	 c(freq col) f(0c 1) clab(_) font(bold) replace
tabout wbhao flind [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, ///
	 c(freq col) f(0c 1) clab(_) font(bold) append
tabout wbhao eduwc pov200 flind_og [fw=perwgt] if lfstat==1 & `i'==1 using  ///
	 table_`i'.xls, c(col) f(1) clab(_) font(bold) append
tabout wbhao eduwc pov200 flind [fw=perwgt] if lfstat==1 & `i'==1 using  ///
	 table_`i'.xls, c(col) f(1) clab(_) font(bold) append
tabout flind_og1 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind_og2 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind_og3 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind_og4 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind_og5 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind_og6 [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) /// 
	f(1) clab(_) font(bold) append
tabout flind [fw=perwgt] if lfstat==1  & `i'==1 using table_`i'.xls, c(col) f(1) /// 
	clab(_) font(bold) append
}

* append all tables into one spreadsheet
foreach i in lfstat white black eduwc eduwcwh eduwcbl {
preserve
	insheet using `"table_`i'.xls"', clear nonames
	export excel using `"tables_frontline-workers_bl.xlsx"', sheetreplace sheet("`i'")
	rm `"table_`i'.xls"'
restore
}


/* 
Copyright 2020 CEPR, Hayley Brown, Hye Jin Rho
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

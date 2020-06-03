clear
set more 1

/*
File: cepr_frontline-workers_mothersday.do
Date: 06 May 2020
Desc: Variables and tables via frontline workers ACS extract for CEPR's Mother's Day report
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

										/* recoding */
/* Mother */
gen mother=0
replace mother=1 if hhoc_b==1 & female==1
lab var mother "Mother"
lab val mother noyes
										/* tables */

cd "$log"
cap rm `"tables_all.xlsx"'

/* all us */
tabout flind1 [fw=perwgt] if lfstat==1 ///
	using table_0.xls, c(freq col) f(0c 1) clab(_) font(bold) replace
tabout lfstat [fw=perwgt] using table_mom.xls, c(freq col) f(0c 1) ///
	clab(_) font(bold) append
tabout married ftpt wbhao nonw forborn lngi educ age50 hmown pubtran ///
	poor pov200 hins hhoc_b hhsenior_b flind1 [fw=perwgt] if lfstat==1 ///
	& mother==1 using table_mom.xls, c(col) f(1) clab(_) font(bold) append
tabout married ftpt wbhao nonw forborn lngi educ age50 hmown pubtran ///
	poor pov200 hins hhoc_b hhsenior_b flind [fw=perwgt] if lfstat==1 ///
	 & mother==1 using table_mom.xls, c(col) f(1) clab(_) font(bold) append
	 

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

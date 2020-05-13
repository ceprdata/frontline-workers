set more 1

/*
File: frontline-workers_acs-recode.do
Date: 01 April 2020
Desc: Variable recodes from 2014-2018 5-year ACS for frontline workers project
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
use cepr_acs_1418_beta.dta, clear


/* recode variables */

	/* ---- idvar ---- */
rename pwgtp perwgt
lab var perwgt "Person weight"
notes perwgt: Integer weight of person
notes perwgt: ACS: PWGTP

/* Determine survey year */
*local year=year in 1

	/* ---- Geography ---- */
cd "$do"
do frontline-workers_acs_geog.do

	/* Industry / Occupation */
cd "$do"
do frontline-workers_acs_ind3d_18.do
do frontline-workers_acs_socp18.do
do frontline-workers_acs_indocc.do

/* employment status last week */
gen byte lfstat=.
replace lfstat=1 if esr==1 | esr==2
replace lfstat=2 if esr==3
replace lfstat=3 if esr==6
replace lfstat=4 if esr==4 |esr==5
lab var lfstat "Labor-force status"
lab def lfstat	1 "Employed" ///
		2 "Unemployed" ///
		3 "NILF" ///
		4 "Armed Forces"
lab val lfstat lfstat
notes lfstat: ACS: ESR


/* Hours Worked per Week Last Year */
gen byte hrslyr=wkhp
replace hrslyr=. if hrslyr<1 | 99<hrslyr
lab var hrslyr "Usual Hours Worked per Week Past 12 Months"
notes hrslyr: Topcoded: 99
notes hrslyr: ACS: WKHP

/* Full/Part-time Status */
gen byte ftpt=. if hrslyr~=.
replace ftpt=1 if 35<=hrslyr 
replace ftpt=2 if hrslyr<35 
lab var ftpt "Full/part-time status"
lab def ftpt 1 "Full-time" ///
2 "Part-time"
lab val ftpt ftpt
notes ftpt: ACS: derived: WKHP

/* Weeks Worked During Past 12 Months */
gen byte wkslyr=.
replace wkslyr=1 if wkw==6
replace wkslyr=2 if wkw==5
replace wkslyr=3 if wkw==4
replace wkslyr=4 if wkw==3
replace wkslyr=5 if wkw==2
replace wkslyr=6 if wkw==1
lab def wkslyr 	1 "1-<14" /// 
		2 "14-26" ///
		3 "27-39" ///
		4 "40-47" ///
		5 "48-49" ///
		6 "50-52"
lab val wkslyr wkslyr
lab var wkslyr "Weeks Worked During Past 12 Months"
notes wkslyr: ACS: WKW

/* Full/Part-time Status over last year */
gen byte ftptlyr=. 
replace ftptlyr=1 if wkslyr==6 & (35<=hrslyr & hrslyr~=.) 
replace ftptlyr=2 if wkslyr==6 & (hrslyr<35 & hrslyr~=.) 
replace ftptlyr=3 if (1<=wkslyr & wkslyr<=5) & (35<=hrslyr & hrslyr~=.) 
replace ftptlyr=4 if (1<=wkslyr & wkslyr<=5) & (hrslyr<35 & hrslyr~=.) 
replace ftptlyr=5 if wkhp==0 | wkw==0
lab var ftptlyr "Full/part-time & year"
lab def ftptlyr	1 "Full-time, full year" ///
		2 "Part-time, full year" ///
		3 "Full-time, part year" ///
		4 "Part-time, part year" ///
		5 "Nonworker"
lab val ftptlyr ftptlyr
notes ftptlyr: ACS: derived: WKHP WKW
notes ftptlyr: Full-time: 35+ hrs/week; Full year: 50+ weeks last yr

/* Full-time, full year */
gen byte ftfy=0 if wkslyr~=. & hrslyr~=.
replace ftfy=1 if wkslyr==6 & (35<=hrslyr & hrslyr~=.)
lab var ftfy "Full-time, full year"
lab val ftfy noyes
notes ftfy: ACS: Dreived: WKHP WKW
notes ftfy: Full-time: 35+ hrs/wk; Full year: 50+ wks last yr


	/* ---- Gender ---- */
gen byte female=0 if sex==1 | sex==2
replace female=1 if sex==2
lab var female "Female"
lab val female noyes
notes female: ACS: derived: SEX


	/* ---- Age ---- */

/* actual age (number) */
replace agep=. if agep<0
replace agep=. if 99<agep
gen byte age=agep if agep~=.
lab var age "Age"
notes age: Topcoded: 99
notes age: ACS: AGEP

/* age groups */
gen agegrp=0 if (16<=age & age~=.)
replace agegrp=1 if (16<=age & age<=24)
replace agegrp=2 if (25<=age & age<=34)
replace agegrp=3 if (35<=age & age<=44)
replace agegrp=4 if (45<=age & age<=54)
replace agegrp=5 if (55<=age & age<=64)
replace agegrp=6 if (65<=age & age~=.)
lab var age "Age group"
lab def agegrp 1 "16-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65+"
lab val agegrp agegrp
notes agegrp: ACS: derived: AGEP

/* age 50+ */
gen age50=0 if (16<=age & age~=.)
replace age50=1 if 50<=age
lab var age50 "Age 50+"
lab val age50 noyes
notes age50: ACS: derived: AGEP

/* age 60+ */
gen age60=0 if (16<=age & age~=.)
replace age60=1 if 60<=age
lab var age60 "Age 60+"
lab val age60 noyes
notes age60: ACS: derived: AGEP

/* age 65+ */
gen age65=0 if (16<=age & age~=.)
replace age65=1 if 65<=age
lab var age65 "Age 65+"
lab val age65 noyes
notes age65: ACS: derived: AGEP

	/* ---- Race, ethnicity ---- */
	
/* White, Black, Hispanic, Asian, Other (WBHAO) */
gen byte wbhao=.
replace wbhao=1 if rac3p==1 /* white alone */
replace wbhao=2 if rac3p==2 /* black alone */
replace wbhao=2 if rac3p==16 /* W-B */ | (30<=rac3p & rac3p<=38) /*
*/ /* B-O */ | (60<=rac3p & rac3p<=62) /* 3 races incl B-W */ /*
*/ | rac3p==74 /* B-A */ | rac3p==75 /* B-PI */ | rac3p==78 /*
*/ /* W-B-A */ | (81<=rac3p & rac3p<=83) /* 4/5 races incl B-W */ /*
*/ | rac3p==90 /* 5 races incl B */ | rac3p==91 /* 4 races incl B */ /*
*/ | rac3p==100 /* 6 races incl B */ 	 	
replace wbhao=4 if (4<=rac3p & rac3p<=14) /* aapi alone */
replace wbhao=4 if (18<=rac3p & rac3p<=28) /* W-A */ | rac3p==39 /*
*/ | rac3p==40 /* AI-A */ | (42<=rac3p & rac3p<=59) /* A-A or A-O */ /*
*/ | rac3p==63 /* W-AI-A */ | (65<=rac3p & rac3p<=73) /*
*/ /* W-A-A or W-A-O */ | rac3p==76 | rac3p==77 /* A-A */ /*
*/ | rac3p==79 /* W-AI-A */ | rac3p==80 /* W-PI-O */ /*
*/ | (84<=rac3p & rac3p<=89) /* 4/5 races incl A-W */ /*	
*/ | (92<=rac3p & rac3p<=99) /* 4/5 races incl A */
replace wbhao=4 if rac1p==6 | rac1p==7 /* aa + pi alone */
replace wbhao=5 if rac3p==3 /* AI alone */ | rac3p==15 /*
*/ /* some other race alone */ | rac3p==17 /* W-AI */ | rac3p==29 /*
*/ /* W-O */ | rac3p==41 /* AI-O */ | rac3p==64 /* W-AI-O */
replace wbhao=5 if (3<=rac1p & rac1p<=5) /* native american only */
replace wbhao=3 if 2<=hisp & hisp<=24 /* hispanic */
lab var wbhao "Race/Ethnicity, incl. Asian"
#delimit ;
lab define wbhao
1 "White"
2 "Black"
3 "Hispanic"
4 "AAPI"
5 "Other"
;
#delimit cr
lab val wbhao wbhao
notes wbhao: Black includes all respondents listing black; asian includes /*
*/ all respondents listing asian excluding those also listing black; /*
*/ other includes all respondents listing non-white, non-black or /*
*/ non-asian races, excluding those also listing black or asian
notes wbhao: asians include hawaiian/pacific islanders
notes wbhao: Racial and ethnic categories are mutually exclusive
notes wbhao: ACS: derived RAC1P, RAC3P, HISP 


	/* ---- Nativity ---- */

/* Foreign-born status */
gen byte forborn=.
replace forborn=1 if nativity==2
replace forborn=0 if nativity==1
lab var forborn "Foreign born"
lab val forborn noyes
notes forborn: ACS: NATIVITY

/* US citizenship */
gen byte citizen=.
replace citizen=1 if 1<=cit & cit<=4
replace citizen=0 if cit==5
lab var citizen "US citizenship"
lab val citizen noyes
notes citizen: ACS: CIT

	
	/* ---- Education ---- */
gen byte educ=.
replace educ=1 if schl<=15
replace educ=2 if schl==16 | schl==17
replace educ=3 if 18<=schl & schl<=20 /*includes Associate's*/
replace educ=4 if schl==21
replace educ=5 if 22<=schl & schl~=.
lab var educ "Education level"
#delimit ;
lab define educ
1 "LTHS"
2 "HS"
3 "Some college"
4 "College"
5 "Advanced"
;
#delimit cr
lab val educ educ
notes educ: ACS: SCHL
notes educ: Those under 3 are set to missing


	/* ---- Housing ---- */

/* Housing tenure */
replace ten=. if ten<1 | 4<ten
lab var ten "Housing tenure"
lab def ten	1 "Owned with mortgage or loan" ///
	        2 "Owned free and clear" ///
	        3 "Rented" ///
	        4 "Occupied without payment of rent"
lab val ten ten
notes ten: ACS: TEN

/* Renter status */
gen byte renter=.
replace renter=1 if ten==3
replace renter=0 if ten==1 | ten==2 | ten==4
lab var renter "Renter status"
lab val renter noyes
notes renter: ACS: TEN

/* Home ownership */
gen byte hmown=0
replace hmown=1 if ten==1 | ten==2
lab var hmown "Home ownership"
lab val hmown noyes
notes hmown: ACS: Derived: TEN


	/* ---- Work commute ---- */

/* Means of Transportation to Work */
replace jwtr=. if jwtr<1 | jwtr>12
#delimit ;
lab def jwtr
1 "Car, truck, or van"
2 "Bus or trolley bus"
3 "Streetcar or trolley care (carro publico in PR)"
4 "Subway or elevated"
5 "Railroad"
6 "Ferryboat"
7 "Taxicab"
8 "Motorcycle"
9 "Bicycle"
10 "Walked"
11 "Worked at home"
12 "Other method"
;
#delimit cr
lab var jwtr "Means of transportation to work"
lab val jwtr jwtr
notes jwtr: ACS: JWTR

/* Uses public transit to commute to work */
gen byte pubtran=. if jwtr~=.
replace pubtran=1 if (2<=jwtr & jwtr<=6)
replace pubtran=0 if jwtr==1 | (7<=jwtr & jwtr<=12)
lab var pubtran "Uses public transit to commute to work"
lab val pubtran noyes
notes pubtran: ACS: Derived: JWTR


	/* ---- Poverty ---- */

/* Poverty status */
replace povpip=. if povpip<0
replace povpip=. if 501<povpip
lab var povpip "Percent of poverty status"
notes povpip: Topcode: 501
notes povpip: ACS: POVPIP

/* In poverty */
gen byte poor=0 if povpip~=.
replace poor=1 if 0<=povpip & povpip<100
lab var poor "In poverty"
lab val poor noyes
notes poor: ACS: Derived: POVPIP
notes poor: ACS defines poor as strictly less than 100% poverty line

gen byte pov200=0 if povpip~=.
replace pov200=1 if 0<=povpip & povpip<200
lab var pov200 "<200% Poverty"
lab val pov200 noyes

	/* ---- Health insurance ---- */

/* Health insurance (binary) */
gen byte hins=.
replace hins=1 if hicov==1 
replace hins=0 if hicov==2 
lab var hins "Health insurance (binary)"
lab val hins noyes
notes hins: ACS: HICOV

/* Health insurance provided by current/former employers or union */
gen byte hiep=.
replace hiep=1 if hins1==1
replace hiep=0 if hins1==2
lab var hiep "Health insurance, current or former employer/union"
lab val hiep noyes
notes hiep: ACS: HINS1


	/* ---- Family ---- */

/* HH presence and age of own children */
gen byte hhoc=hupaoc if hupaoc~=.
replace hhoc=. if hhoc<1
replace hhoc=. if 4<hhoc
lab def hhoc	1 "Presence of own children <6" ///
		2 "Presence of own children 6-17 only" ///
		3 "Presence of own children <6 and 6-17" ///
		4 "No own children present"
lab var hhoc "Presence and age of own (minor) children"
lab val hhoc hhoc
notes hhoc: ACS: HUPAOC 

/* HH presence of own children */
gen byte hhoc_b=0 if hhoc~=.
replace hhoc_b=1 if 1<=hhoc & hhoc<=3
lab var hhoc_b "Presence of a Child"
lab val hhoc_b noyes
notes hhoc: ACS: Derived from HUPAOC 

/* Presence of household members 60+ */
gen byte hh60=r60 if r60~=.
replace hh60=. if 2<r60
lab def hh60	0 "0" ///
		1 "1" ///
		2 "2+"
lab var hh60 "Presence of 60+ HH members"
lab val hh60 hh60
notes hh60: ACS: R60

/* Presence of household members 65+ */
gen byte hhsenior=r65 if r65~=.
replace hhsenior=. if 2<r65
lab def hhsenior	0 "0" ///
			1 "1" ///
			2 "2+"
lab var hhsenior "Presence of 65+ HH members"
lab val hhsenior hhsenior
notes hhsenior: ACS: R65

gen byte hhsenior_b=0 if hhsenior~=.
replace hhsenior_b=1 if hhsenior>0
lab var hhsenior_b "Presence of 65+ HH members"



order perwgt lfstat hrslyr ftpt wkslyr ftptlyr ftfy female agep agegrp ///
age50 age60 age65 wbhao forborn citizen educ ten renter hmown jwtr ///
pubtran povpip poor pov200 hins hiep hhoc hhoc_b hh60 hhsenior hhsenior_b ///
flind1 flind flind_d flind_dd ind3d_18 naicsp socp18 state puma10 powsp10

keep perwgt lfstat hrslyr ftpt wkslyr ftptlyr ftfy female agep agegrp ///
age50 age60 age65 wbhao forborn citizen educ ten renter hmown jwtr ///
pubtran povpip poor pov200 hins hiep hhoc hhoc_b hh60 hhsenior hhsenior_b ///
flind1 flind flind_d flind_dd ind3d_18 naicsp socp18 state puma10 powsp10


cd "$dataout"
save cepr_acs_1418_beta_frontline, replace



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


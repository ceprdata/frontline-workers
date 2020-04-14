set more 1

/*
File: frontline-workers_acs_geog.do
Date: 01 April 2020
Desc: Geographic variable recodes from 2014-2018 5-year ACS for frontline workers project
Note:	See copyright notice at end of program.
*/

/* Determine survey year */
*local year=year in 1

/* Place of residence */

/* State (residence) */
rename st state
replace state=. if state<1
replace state=. if 72<state
/*drop if state==72 /* excluding Puerto Rico from sample */ */
lab var state "State (residence)"
#delimit ;
lab def state
1 "Alabama"
2 "Alaska"
4 "Arizona"
5 "Arkansas"
6 "California"
8 "Colorado"
9 "Conneticut"
10 "Delaware"
11 "District of Columbia"
12 "Florida"
13 "Georgia"
15 "Hawaii"
16 "Idaho"
17 "Illinois"
18 "Indiana"
19 "Iowa"
20 "Kansas"
21 "Kentucky"
22 "Louisiana"
23 "Maine"
24 "Maryland"
25 "Massachusetts"
26 "Michigan"
27 "Minnesota"
28 "Mississippi"
29 "Missouri"
30 "Montana"
31 "Nebraska"
32 "Nevada"
33 "New Hampshire"
34 "New Jersey"
35 "New Mexico"
36 "New York"
37 "North Carolina"
38 "North Dakota"
39 "Ohio"
40 "Oklahoma"
41 "Oregon"
42 "Pennsylvania"
44 "Rhode Island"
45 "South Carolina"
46 "South Dakota"
47 "Tennessee"
48 "Texas"
49 "Utah"
50 "Vemont"
51 "Virginia"
53 "Washington"
54 "West Virginia"
55 "Wisconsin"
56 "Wyoming"
72 "Puerto Rico"
;
#delimit cr
lab val state state
notes state: ACS: ST

/* PUMA (residence) */
gen puma10=puma if puma~=.
lab var puma10 "PUMA (2010 census boundaries)"
notes puma10: Public use microdata area
notes puma10: Designates area of 100,000 or more population
notes puma10: Use with variable state for unique code	
notes puma10: Boundaries for 2012-2018 are based on 2010 Census delineations


/* Place of Work */

/* State (place of work) */ 
gen powsp10=powsp if powsp~=.
replace powsp10=. if powsp<1
replace powsp10=. if 555<powsp
#delimit;
lab def powsp10
1 "Alabama"
2 "Alaska"
4 "Arizona"
5 "Arkansas"
6 "California"
8 "Colorado"
9 "Conneticut"
10 "Delaware"
11 "District of Columbia"
12 "Florida"
13 "Georgia"
15 "Hawaii"
16 "Idaho"
17 "Illinois"
18 "Indiana"
19 "Iowa"
20 "Kansas"
21 "Kentucky"
22 "Louisiana"
23 "Maine"
24 "Maryland"
25 "Massachusetts"
26 "Michigan"
27 "Minnesota"
28 "Mississippi"
29 "Missouri"
30 "Montana"
31 "Nebraska"
32 "Nevada"
33 "New Hampshire"
34 "New Jersey"
35 "New Mexico"
36 "New York"
37 "North Carolina"
38 "North Dakota"
39 "Ohio"
40 "Oklahoma"
41 "Oregon"
42 "Pennsylvania"
44 "Rhode Island"
45 "South Carolina"
46 "South Dakota"
47 "Tennessee"
48 "Texas"
49 "Utah"
50 "Vemont"
51 "Virginia"
53 "Washington"
54 "West Virginia"
55 "Wisconsin"
56 "Wyoming"
72 "Puerto Rico"
166 "Europe"
251 "Eastern Asia"
254 "Other Asia, Not Specified"
301 "Canada"
303 "Mexico"
399 "Americas, Not Specified"
555 "Other US Island Areas Not Specified, Africa, Oceania, at Sea, or Abroad, Not Specified"
;
#delimit cr
lab var powsp10 "Place of Work (2010 Census boundaries)"
lab val powsp10 powsp10
notes powsp10: ACS: POWSP

/* PUMA (place of work) */
gen powpuma10=powpuma if powpuma~=.
replace powpuma10=. if powpuma<1
replace powpuma10=. if 70100<powpuma
lab var powpuma10 "Place of Work PUMA (2010 Census boundaries)"
lab val powpuma10 powpuma10
notes powpuma10: ACS: POWPUMA
notes powpuma10: Use with variable powsp10 for unique code
notes powpuma10: Boundaries for 2012-2018 are based on 2010 Census definition

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

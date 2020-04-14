set more 1

/*
File: frontline-workers_acs_indocc.do
Date: 01 April 2020
Desc: Industries and occupations of frontline workers from 2014-2018 5-year ACS 
Note:	See copyright notice at end of program.
*/

/* 
Industries for consideration

• Grocery, Convenience, and Drug Stores: 
      4470 .WHL-Grocery And Related Product Merchant Wholesalers
      4971 .RET-Supermarkets and Other Grocery (Except Convenience)
           .Stores
      4972 .RET-Convenience Stores
	  5070 .RET-Pharmacies And Drug Stores
      5391 .RET-General Merchandise Stores, Including Warehouse Clubs
           .and Supercenters
		   
• Public Transit: 
      6080 .TRN-Rail Transportation
	  6180 .TRN-Bus Service And Urban Transit
	  
• Trucking, Warehouse, and Postal Service:
      6170 .TRN-Truck Transportation 
	  6370 .TRN-Postal Service
	  6390 .TRN-Warehousing And Storage
	  
• Building Cleaning Services and Waste Management: 
      7690 .PRF-Services To Buildings And Dwellings (Except Cleaning
           .During Construction And Immediately After Construction)
      7790 .PRF-Waste Management And Remediation Services
	  
• Healthcare: 
      7970 .MED-Offices Of Physicians 
      8090 .MED-Outpatient Care Centers
      8170 .MED-Home Health Care Services
      8180 .MED-Other Health Care Services
	  8191 .MED-General Medical And Surgical Hospitals, And Specialty
           .(Except Psychiatric And Substance Abuse) Hospitals
	  8192 .MED-Psychiatric And Substance Abuse Hospitals
      8270 .MED-Nursing Care Facilities (Skilled Nursing Facilities)
      8290 .MED-Residential Care Facilities, Except Skilled Nursing
           .Facilities
      2190 .MFG-Pharmaceuticals And Medicines
	  4380 .WHL-Drugs, Sundries, And Chemical And Allied Products
           .Merchant Wholesalers

• Childcare, Homeless, Food, and Family Services: 
      8370 .SCA-Individual And Family Services
      8380 .SCA-Community Food And Housing, And Emergency Services
      8470 .SCA-Child Day Care Services
  
• Agriculture, forestry, and fishing: 
      0170 .AGR-Crop Production
      0180 .AGR-Animal Production And Aquaculture
      0190 .AGR-Forestry Except Logging
      0270 .AGR-Logging
      0280 .AGR-Fishing, Hunting And Trapping
      0290 .AGR-Support Activities For Agriculture And Forestry
	  2180 .MFG-Agricultural Chemicals
	  4480 .WHL-Farm Product Raw Material Merchant Wholesalers
	  4570 .WHL-Farm Supplies Merchant Wholesalers
	  
• Utilities:  
      0570 .UTL-Electric Power Generation, Transmission And
           .Distribution
      0580 .UTL-Natural Gas Distribution
      0590 .UTL-Electric And Gas, And Other Combinations
      0670 .UTL-Water, Steam, Air Conditioning, And Irrigation Systems
      0680 .UTL-Sewage Treatment Facilities
      0690 .UTL-Not Specified Utilities
	  
• Construction: 
      0770 .CON-Construction (The Cleaning Of Buildings And Dwellings
           .Is Incidental During Construction And Immediately After
           .Construction)
	  4090 .WHL-Lumber And Other Construction Materials Merchant
           .Wholesalers
*/

/* Frontline industry, NYC report */
gen flind1=.
replace flind1=1 if ind3d_18==4470 | ind3d_18==4971 | ind3d_18==4972 | ind3d_18==5070 | ind3d_18==5391
replace flind1=2 if ind3d_18==6080 | ind3d_18==6180 
replace flind1=3 if ind3d_18==6170 | ind3d_18==6390 | ind3d_18==6370
replace flind1=4 if ind3d_18==7690
replace flind1=5 if ind3d_18==7970 | ind3d_18==8090 | ind3d_18==8170 | ind3d_18==8180 | ind3d_18==8191 ///
| ind3d_18==8192 | ind3d_18==8270 | ind3d_18==8290 /* | ind3d_18==2190 | ind3d_18==4380  */
replace flind1=6 if ind3d_18==8370 | ind3d_18==8380 | ind3d_18==8470

# delimit ;
lab def flind1
1 "Grocery, Convenience, and Drug Stores"
2 "Public Transit"
3 "Trucking, Warehouse, and Postal Service"
4 "Building Cleaning Services"
5 "Healthcare"
6 "Childcare, Homeless, Food, and Family Services"
;
#delimit cr
lab var flind1 "Frontline industry, detailed"
lab val flind1 flind


/* Frontline industry  */
gen flind=0
replace flind=1 if flind1>=1 & flind1<=6
lab var flind "Frontline industry"
lab val flind noyes

/* Frontline industry, detailed */
gen flind_d=.
replace flind_d=1 if ind3d_18==4470 | ind3d_18==4971 | ind3d_18==4972 | ind3d_18==5070 | ind3d_18==5391
replace flind_d=2 if ind3d_18==6080 | ind3d_18==6180 
replace flind_d=3 if ind3d_18==6170 | ind3d_18==6390 | ind3d_18==6370
replace flind_d=4 if ind3d_18==7690 | ind3d_18==7790
replace flind_d=5 if ind3d_18==7970 | ind3d_18==8090 | ind3d_18==8170 | ind3d_18==8180 | ind3d_18==8191 ///
| ind3d_18==8192 | ind3d_18==8270 | ind3d_18==8290 /* | ind3d_18==2190 | ind3d_18==4380  */
replace flind_d=6 if ind3d_18==8370 | ind3d_18==8380 | ind3d_18==8470
replace flind_d=7 if ind3d_18==0170 | ind3d_18==0180 | ind3d_18==0190 | ind3d_18==0270 | ind3d_18==0280 | ind3d_18==0290 
replace flind_d=8 if ind3d_18==0570 | ind3d_18==0580 | ind3d_18==0590 | ind3d_18==0670 | ind3d_18==0680 | ind3d_18==0690
replace flind_d=9 if ind3d_18==0770 /* | ind3d_18==4090 */

# delimit ;
lab def flind_d
1 "Grocery, Convenience, and Drug Stores"
2 "Public Transit"
3 "Trucking, Warehouse, and Postal Service"
4 "Building Cleaning Services and Waste Management"
5 "Healthcare"
6 "Childcare, Homeless, Food, and Family Services"
7 "Agriculture, forestry, and fishing"
8 "Utilities"
9 "Construction"
;
#delimit cr
lab var flind_d "Frontline industry, detailed"
lab val flind_d flind_d



/* Frontline industry, extra detailed  */
gen flind_dd=.
replace flind_dd=4470 if ind3d_18==4470
replace flind_dd=4971 if ind3d_18==4971
replace flind_dd=4972 if ind3d_18==4972
replace flind_dd=5070 if ind3d_18==5070
replace flind_dd=5391 if ind3d_18==5391
replace flind_dd=6080 if ind3d_18==6080
replace flind_dd=6180 if ind3d_18==6180
replace flind_dd=6170 if ind3d_18==6170
replace flind_dd=6390 if ind3d_18==6390
replace flind_dd=6370 if ind3d_18==6370
replace flind_dd=7690 if ind3d_18==7690
replace flind_dd=7790 if ind3d_18==7790
replace flind_dd=7970 if ind3d_18==7970
replace flind_dd=8090 if ind3d_18==8090
replace flind_dd=8170 if ind3d_18==8170
replace flind_dd=8180 if ind3d_18==8180
replace flind_dd=8191 if ind3d_18==8191
replace flind_dd=8192 if ind3d_18==8192
replace flind_dd=8270 if ind3d_18==8270
replace flind_dd=8290 if ind3d_18==8290
replace flind_dd=8370 if ind3d_18==8370
replace flind_dd=8380 if ind3d_18==8380
replace flind_dd=8470 if ind3d_18==8470
replace flind_dd=0170 if ind3d_18==0170
replace flind_dd=0180 if ind3d_18==0180
replace flind_dd=0190 if ind3d_18==0190
replace flind_dd=0270 if ind3d_18==0270
replace flind_dd=0280 if ind3d_18==0280
replace flind_dd=0290 if ind3d_18==0290
replace flind_dd=0570 if ind3d_18==0570
replace flind_dd=0580 if ind3d_18==0580
replace flind_dd=0590 if ind3d_18==0590
replace flind_dd=0670 if ind3d_18==0670
replace flind_dd=0680 if ind3d_18==0680
replace flind_dd=0690 if ind3d_18==0690
replace flind_dd=0770 if ind3d_18==0770
# delimit ;
lab def flind_dd
4470 "WHL-Grocery And Related Product Merchant Wholesalers"
4971 "RET-Supermarkets and Other Grocery (Except Convenience) Stores"
4972 "RET-Convenience Stores"
5070 "RET-Pharmacies And Drug Stores"
5391 "RET-General Merchandise Stores, Including Warehouse Clubs and Supercenters"
6080 "TRN-Rail Transportation"
6180 "TRN-Bus Service And Urban Transit"
6170 "TRN-Truck Transportation "
6370 "TRN-Postal Service"
6390 "TRN-Warehousing And Storage"
7690 "PRF-Services To Buildings And Dwellings (Except Cleaning During Construction And Immediately After Construction)"
7790 "PRF-Waste Management And Remediation Services"
7970 "MED-Offices Of Physicians"
8090 "MED-Outpatient Care Centers"
8170 "MED-Home Health Care Services"
8180 "MED-Other Health Care Services"
8191 "MED-General Medical And Surgical Hospitals, And Specialty (Except Psychiatric And Substance Abuse) Hospitals"
8192 "MED-Psychiatric And Substance Abuse Hospitals"
8270 "MED-Nursing Care Facilities (Skilled Nursing Facilities)"
8290 "MED-Residential Care Facilities, Except Skilled Nursing Facilities"
8370 "SCA-Individual And Family Services"
8380 "SCA-Community Food And Housing, And Emergency Services"
8470 "SCA-Child Day Care Services"
0170 "AGR-Crop Production"
0180 "AGR-Animal Production And Aquaculture"
0190 "AGR-Forestry Except Logging"
0270 "AGR-Logging"
0280 "AGR-Fishing, Hunting And Trapping"
0290 "AGR-Support Activities For Agriculture And Forestry"
0570 "UTL-Electric Power Generation, Transmission And Distribution"
0580 "UTL-Natural Gas Distribution"
0590 "UTL-Electric And Gas, And Other Combinations"
0670 "UTL-Water, Steam, Air Conditioning, And Irrigation Systems"
0680 "UTL-Sewage Treatment Facilities"
0690 "UTL-Not Specified Utilities"
0770 "CON-Construction"
;
#delimit cr
lab var flind_dd "Frontline industry, extra detailed"
lab val flind_dd flind_dd


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

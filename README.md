# CEPRdata on Frontline Workers

## Authors

Hye Jin Rho and Hayley Brown

Center for Economic and Policy Research

1611 Connecticut Avenue, NW Suite 400

Washington, DC

## Usage

1. download cepr_acs_1418_beta_frontline.dta from 'data'
2. recode any variables: raw industry and occupation variables are in the dataset
see frontline-workers_acs_socp18.do and frontline-workers_acs.do ind3d_18
see also frontlie-workers_acs_ind3d_18 for cepr's coding of frontline industries
3. run frontline-workers_tables.do to replicate national/state numbers in cepr release
4. if you want variables that are not in this dataset, please contact us:
rho@cepr.net or brown@cepr.net.
5. to start from scratch and pull raw variables, do the following:

    (a) download all the other .do files

    (b) open cepr_acs_read_1418_beta.do, set directories, and create folders. 

    (c) go to the census bureau website:
https://www2.census.gov/programs-surveys/acs/data/pums/2018/5-Year/

    (d) download: "csv_pus.zip" and "csv_hus.zip" and store in "raw_data" folder

    (e) run cepr_acs_read_1418_beta.do

    (f) open frontline-workers_acs_recode.do

    (g) recode any raw variables you would like to use

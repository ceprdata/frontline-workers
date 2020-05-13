# CEPRdata on Frontline Workers

## Authors

Hye Jin Rho and Hayley Brown

Center for Economic and Policy Research

1611 Connecticut Avenue, NW Suite 400

Washington, DC

## Usage

1. Download cepr_acs_1418_beta_frontline.dta from 'data' (a zipped version of the data file can also be downloaded [here](http://ceprdata.org/wp-content/acs/data/cepr_acs_1418_beta_frontline.dta.zip))
2. Recode any variables: raw industry and occupation variables are in the dataset
see frontline-workers_acs_socp18.do and frontline-workers_acs.do ind3d_18
see also frontlie-workers_acs_ind3d_18 for cepr's coding of frontline industries
3. Run frontline-workers_tables.do to replicate national/state numbers in cepr release
4. If you want variables that are not in this dataset, please contact us:
rho@cepr.net or brown@cepr.net.
5. To start from scratch and pull raw variables, do the following:

    (a) download all the other .do files

    (b) open cepr_acs_read_1418_beta.do, set directories, and create folders. 

    (c) go to the [Census Bureau](https://www2.census.gov/programs-surveys/acs/data/pums/2018/5-Year/) to retrieve the raw data

    (d) download: "csv_pus.zip" and "csv_hus.zip" and store in "raw_data" folder

    (e) run cepr_acs_read_1418_beta.do

    (f) open frontline-workers_acs_recode.do

    (g) recode any raw variables you would like to use

## Publications
The contents of this repository form the basis for CEPR's 
[report](https://cepr.net/a-basic-demographic-profile-of-workers-in-frontline-industries/) on workers on the frontlines of the COVID-19 pandemic in the United States. 
CEPR has used this data to produce related reports on [meatpacking workers](https://cepr.net/meatpacking-workers-are-a-diverse-group-who-need-better-protections/), [frontline mothers](https://cepr.net/mothers-in-frontline-industries-deserve-better/), and frontline workers in [Chicago and Illinois](https://cepr.net/frontline-workers-chicago-and-illinois/). 

The National Partnership for Women & Families has also [cited](https://www.nationalpartnership.org/our-work/economic-justice/frontline-workers/) our data. Finally, our state specific data has been used in subsequent reports by other organizations, including:

Florida Policy Institute (Florida): [Florida’s 2 Million Essential Workers: 5 Stark Realities and 5 Policy Solutions](https://www.floridapolicy.org/posts/floridas-2-million-essential-workers-5-stark-realities-and-5-policy-solutions)

Kentucky Center for Economic Policy (Kentucky): [Who Are Kentucky’s Essential Workers on the Frontlines of the COVID-19 Pandemic?](https://kypolicy.org/who-are-kentuckys-essential-workers-on-the-frontlines-of-the-covid-19-pandemic/)

Maine Center for Economic Policy (Maine): [Maine’s most essential workers are more often women, people of color](https://mainebeacon.com/maines-most-essential-workers-are-more-often-women-people-of-color/)

Boston Indicators (Massachusetts): [A Profile of Frontline Workers in Massachusetts](https://www.bostonindicators.org/article-pages/2020/april/frontline_workers)

Montana Budget & Policy Center (Montana): [Montana’s Frontline Workers Are Mostly Women and People of Color](https://montanabudget.org/post/montanas-frontline-workers-are-mostly-women-and-people-of-color)
        
Fiscal Policy Institute (New York): [Appreciating New York’s Essential Workers at a Time of Pandemic](http://fiscalpolicy.org/wp-content/uploads/2020/04/Essential-Workers-Brief-Final.pdf)
        
North Carolina Justice Center (North Carolina): [1 in 5 workers in N.C. are in industries on the frontlines of COVID-19 response](https://www.ncjustice.org/publications/1-in-5-workers-in-n-c-are-in-industries-on-the-frontlines-of-covid-19-response/)
        
Public Assets Institute (Vermont): [Women filled most of the frontline jobs](https://publicassets.org/blog/women-filled-most-of-the-frontline-jobs/)
 


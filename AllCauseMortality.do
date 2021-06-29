clear 
cd "D:\OneDrive\AllCauseMortality_Resources\Data"

*-------------------------------------------------------------------------------
* All cause mortality - Clean up
* ------------------------------------------------------------------------------

use Cleaned_AAMortalityRates.dta
rename statecode id
keep if race== "Total" 
*"Black or African American"
save Cleaned_AAMortalityRates1, replace

*-------------------------------------------------------------------------------
* Loading population data and merging it
* ------------------------------------------------------------------------------

clear 
insheet using "PopulationStates.csv"
reshape long pop, i(year) j(id)

* Saving Population data
save PopulationStates, replace

merge 1:m id year using Cleaned_AAMortalityRates1.dta
drop if _merge==1
drop _merge 
save AllCauseMortality1, replace

*-------------------------------------------------------------------------------
* Merging Con data with cleaned Expenditure
* ------------------------------------------------------------------------------

clear 
insheet using "CON_Data.csv"
rename yearofrepeal repeal_y
reshape long con, i(id) j(year)

merge 1:m year id using AllCauseMortality1.dta

* Droping Louisiana because it did not have CON laws until 1991 and then implemented it, so it does not work with our model
drop _merge 
save CON_ACMortality, replace

*-------------------------------------------------------------------------------
* Initial Diff in Diff Analysis 
* ------------------------------------------------------------------------------
/*
keep if alwayscon==1 | repeal_y=="1989"
* By changing repeal_y, we can look at diffferent diff-in-diffs
gen treat=.
replace treat=0 if alwayscon==1
replace treat=1 if alwayscon==0

gen period = .
replace period = 1 if year>=1984
replace period = 0 if period==.
gen treat_period = treat*period

reg spending treat period treat_period pop */

*-------------------------------------------------------------------------------
* Merging with Income per Capita Data
* ------------------------------------------------------------------------------

clear 
insheet using "income_pcp.csv"

*clean up
keep if linecode==3
gen id=geofips/1000
drop geofips
drop geoname
drop linecode
drop description 

*Reshaping and saving income per capita data
reshape long i, i(id) j(year)
rename i income_pcp
save income_pct, replace

* Loading CPI and adjusting income per capita for inflation (2015 prices)
clear 
insheet using "CPI_2015Prices.csv"

* Merging data with Exp. per capita data
merge 1:m year using income_pct.dta
drop if _merge==2
       
* Creating  income per capita adjusted for inflation (2015 prices)
gen income_pcp_adj = .
replace income_pcp_adj = income_pcp/cpi*100

* Clean Up
drop income_pcp
drop _merge 
sort year id

merge 1:m year id using CON_ACMortality.dta
drop if _merge==1
drop _merge
save CON_ACMortality, replace

* ------------------------------------------------------------------------------
* Merging with Gini Coefficients Data
* ------------------------------------------------------------------------------
clear 
insheet using "Gini.csv"

* Creating Fips id
{
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

* Clean Up 
drop if id==.
rename Year year
keep year id gini

* Merging with current data
merge 1:m year id using CON_ACMortality.dta
drop if _merge==1
drop _merge

save CON_ACMortality.dta, replace

* ------------------------------------------------------------------------------
* Merging with Income Shares Data
* ------------------------------------------------------------------------------

clear 
insheet using "IncomeShares.csv"

* Creating Fips id
{
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

* Clean Up 
drop if id==.
rename Year year
drop number state

* Merging with current data
merge 1:m year id using CON_ACMortality.dta
drop if _merge==1
drop _merge

save CON_ACMortality.dta, replace

* ------------------------------------------------------------------------------
* Merging with Unemployment Rate data
* ------------------------------------------------------------------------------

clear 
insheet using "Unemployment_states.csv"

* Clean up and Reshape
replace id = id/1000
drop area
reshape long u, i(id) j(year)
rename u unemp_rate
drop if id==0

* Merging with current data
merge 1:m year id using CON_ACMortality.dta
drop if _merge==1
drop _merge

save CON_ACMortality.dta, replace

* ------------------------------------------------------------------------------
* Merging with Population Density
* ------------------------------------------------------------------------------

clear 
insheet using "Area_States.csv"

* Creating Fips id

{
	rename State state
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

keep id landarea
merge 1:m id using CON_ACMortality.dta
drop _merge

gen pop_density = pop/landarea

save CON_ACMortality.dta, replace


* ------------------------------------------------------------------------------
* Merging with Demographic Controls - ASEC
* ------------------------------------------------------------------------------

drop state
rename id state
merge m:1 state year using ASEC_1980-2014_State.dta
drop if _merge==1
drop _merge

rename state id
save CON_ACMortality.dta, replace


* ------------------------------------------------------------------------------
* Initial Synthetic Control Estimates
* ------------------------------------------------------------------------------

* Setting Globals
global controls "income_pcp_adj pop_density unemp_rate top1_adj gini prop_age_25to45_bsy prop_age_45to65_bsy prop_age_over65_bsy prop_bach_degree_bsy prop_male_bsy prop_married_bsy prop_white_bsy"

* Installing Synth Command
*ssc install synth, replace all

* Nebraska Synthetic Control Analysis
clear 
use CON_ACMortality.dta

tsset id year

keep if alwayscon==1 | id==31

*spending_pcp_adj(1999) spending_pcp_adj(1998) spending_pcp_adj(1997) spending_pcp_adj(1996) spending_pcp_adj(1995) spending_pcp_adj(1995) spending_pcp_adj(1994) spending_pcp_adj(1993) spending_pcp_adj(1992) spending_pcp_adj(1991)

synth ageadjustedrate $controls spending_pcp_adj(1988) spending_pcp_adj(1987) spending_pcp_adj(1986) spending_pcp_adj(1985) spending_pcp_adj(1984) spending_pcp_adj(1983) spending_pcp_adj(1982) spending_pcp_adj(1981) spending_pcp_adj(1980), trunit(31) trperiod(1997) nested fig

synth spending_pcp_adj income_pcp_adj pop_density unemp_rate top1_adj gini spending_pcp_adj(1996) spending_pcp_adj(1991) spending_pcp_adj(1985), trunit(31) trperiod(1997) nested fig


* Ohio Synthetic Control Analysis
clear 
use CON_ACMortality.dta

tsset id year
drop if id==2

keep if alwaysconpa==1 | id==39

synth ageadjustedrate $controls ageadjustedrate(1996) ageadjustedrate(1995) ageadjustedrate(1994) ageadjustedrate(1993) ageadjustedrate(1992) ageadjustedrate(1991) ageadjustedrate(1990) ageadjustedrate(1989) ageadjustedrate(1988) ageadjustedrate(1987) ageadjustedrate(1986) ageadjustedrate(1985), trunit(39) trperiod(1997) nested fig

* ------------------------------------------------------------------------------
* Pennsylvania Synthetic Control Analysis
* ------------------------------------------------------------------------------

clear 
use CON_ACMortality.dta

tsset id year
keep if alwaysconpa==1 | repeal_y=="1996"
drop if id==2

*   ---Total Expenditure Analysis---

*synth total_exp $controls total_exp(1995) total_exp(1990) total_exp(1984), trunit(42) trperiod(1996) nested fig
synth ageadjustedrate $controls ageadjustedrate(1989) ageadjustedrate(1988) ageadjustedrate(1987) ageadjustedrate(1986) ageadjustedrate(1985) ageadjustedrate(1984) ageadjustedrate(1983) ageadjustedrate(1982) ageadjustedrate(1981) ageadjustedrate(1980), trunit(42) trperiod(1995) nested fig







































* Wisconsin Synthetic Control Analysis
clear 
use CON_ACMortality6.dta

tsset id year

keep if alwayscon==1 | repeal_y=="2000"

synth ageadjustedrate income_pcp_adj pop_density unemp_rate top1_adj gini ageadjustedrate(1999) ageadjustedrate(1998) ageadjustedrate(1997) ageadjustedrate(1996) ageadjustedrate(1995) ageadjustedrate(1994) ageadjustedrate(1993) ageadjustedrate(1992) ageadjustedrate(1991) ageadjustedrate(1990) ageadjustedrate(1989) ageadjustedrate(1988) ageadjustedrate(1987) ageadjustedrate(1986) ageadjustedrate(1985) ageadjustedrate(1984) ageadjustedrate(1983) ageadjustedrate(1982) ageadjustedrate(1981) ageadjustedrate(1980), trunit(55) trperiod(2000) nested fig

* Indiana Synthetic Control Analysis
clear 
use CON_ACMortality6.dta

tsset id year

keep if alwayscon==1 | repeal_y=="1999"

synth ageadjustedrate  income_pcp_adj pop_density unemp_rate top1_adj gini ageadjustedrate(1998) ageadjustedrate(1997) ageadjustedrate(1996) ageadjustedrate(1995) ageadjustedrate(1994) ageadjustedrate(1993) ageadjustedrate(1992) ageadjustedrate(1991) ageadjustedrate(1990) ageadjustedrate(1989) ageadjustedrate(1988) ageadjustedrate(1987) ageadjustedrate(1986) ageadjustedrate(1985) ageadjustedrate(1984) ageadjustedrate(1983) ageadjustedrate(1982) ageadjustedrate(1981) ageadjustedrate(1980), trunit(18) trperiod(1999) nested fig

* Pennsylvania Synthetic Control Analysis
clear 
use CON_ACMortality6.dta

tsset id year

keep if alwayscon==1 | repeal_y=="1996"

synth ageadjustedrate income_pcp_adj pop_density unemp_rate top1_adj gini ageadjustedrate(1995) ageadjustedrate(1990) ageadjustedrate(1985), trunit(42) trperiod(1996) nested fig

* North Dakota Synthetic Control Analysis
clear 
use CON_ACMortality6.dta

tsset id year

keep if alwayscon==1 | repeal_y=="1995"

synth ageadjustedrate income_pcp_adj pop_density unemp_rate top1_adj gini ageadjustedrate(1994) ageadjustedrate(1993) ageadjustedrate(1992) ageadjustedrate(1991) ageadjustedrate(1990) ageadjustedrate(1989) ageadjustedrate(1988) ageadjustedrate(1987) ageadjustedrate(1986) ageadjustedrate(1985) ageadjustedrate(1984) ageadjustedrate(1983) ageadjustedrate(1982) ageadjustedrate(1981) ageadjustedrate(1980), trunit(38) trperiod(1995) nested fig

*******synth_runner spending_pcp_adj income_pcp_adj pop_density unemp_rate top1_adj gini spending_pcp_adj(1994) spending_pcp_adj(1989) spending_pcp_adj(1983), trunit(38) trperiod(1995) nested

*Wyoming Synthetic Control Analysis
clear 
use CON_ACMortality6.dta

tsset id year

keep if alwayscon==1 | repeal_y=="1989"

synth ageadjustedrate income_pcp_adj pop_density unemp_rate top1_adj gini ageadjustedrate(1988) ageadjustedrate(1985) ageadjustedrate(1982), trunit(56) trperiod(1989) nested fig

****** 
net install synth_runner, from(https://raw.github.com/bquistorff/synth_runner/master/) replace
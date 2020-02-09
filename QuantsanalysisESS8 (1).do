*The path where the dataset is downloaded
cd "d:\18202322\Downloads\ESS7e02_2_allcountries.stata"
*Tells the present directory
dir	
*The data used for this analysis
use ESS7e02_2.dta, clear
*Turn off an scroll feature of Stata permanently
set more off, perm

* first, describe the contents of the dataset.
des

* The variables required for this analysis
*Dependent variables
des trstlgl imwbcnt
*Independent variables
des imueclt qfimedu imtcjob imwbcrm  gvrfgap

* List of all the countries participating in this survey
tab cntry

*Selecting a subset n the basis of particular country Ireland IE 
*required for this data analysis
*Note: It deletes all the other data 
keep if cntry == "IE"  
des cntry
tab cntry

*Checking on missing values
mdesc cntbrthc
*The number of countries and the frequency for each country
tab cntbrthc

*To check either immigrants or not by rplaces values with a binay format Yes/No or 1/0
gen nonimmigrant_temp=cntbrthc
	replace nonimmigrant_temp="1" if cntbrthc=="66"
	replace nonimmigrant_temp="." if cntbrthc=="99"
	replace nonimmigrant_temp="." if cntbrthc=="77"
	replace nonimmigrant_temp="0" if cntbrthc!="66" & cntbrthc!="77" & cntbrthc!="99"
des nonimmigrant_temp
tab nonimmigrant_temp
destring nonimmigrant_temp, generate(citizen_IE)
des nonimmigrant_temp citizen_IE
label define citizen_IElbl 1 "1 Non-immigrant" 0 "0 Immigrant"

*To get a better picture of same number of immigrants and non immigrants in a new variable called citizen_IE
tab citizen_IE
label values citizen_IE citizen_IElbl
tab citizen_IE
des citizen_IE
label var citizen_IE "citizen_IE"


* Determining the number of immigrants and non immigrants for understanding of survey
graph bar,over(citizen_IE)
graph export citizen_IE1.tif
*To get summary stats of the variables using tab
tab citizen_IE 
* The average mean tell us the number of observation are mostly anti-immigrants.
su citizen_IE

mdesc trstlgl imwbcnt
mdesc imueclt qfimedu imtcjob imwbcrm  gvrfgap


tab trstlgl 
label list trstlgl 
tab imwbcnt
label list imwbcnt 
su trstlgl imwbcnt
tabstat trstlgl imwbcnt , s(min max range mean sem  sd p25 p50 p75 iqr n)


histogram trstlgl , percent discrete addlabel xlabel(0(1)10, valuelabel angle(45)) scheme(s1color) fcolor(red) fintensity(inten60) lcolor(black)   /*
*/ gap(15)title(Trust in legal system 2014)  by(citizen_IE) 
graph export trstlgl1.tif
kdensity trstlgl, bwidth(1) 
graph export trstlgl2.tif
graph twoway || kdensity trstlgl if citizen_IE==0 || kdensity trstlgl if citizen_IE==1
graph export trstlgl3.tif
histogram imwbcnt, percent discrete addlabel xlabel(0(1)10, valuelabel angle(45)) scheme(s1color) fcolor(red) fintensity(inten60) lcolor(black) /*
*/ gap(15) by(citizen_IE)
graph export imwbcnt4.tif
graph twoway || kdensity imwbcnt if citizen_IE==0 || kdensity imwbcnt if citizen_IE==1
graph export imwbcnt5.tif
graph box trstlgl imwbcnt
graph export imwbcnt6.tif


label list trstlgl 
tab imueclt 
label list qfimedu
tab qfimedu 
label list imtcjob 
tab imtcjob 
label list imwbcrm 
tab imwbcrm  
label list gvrfgap
tab gvrfgap
su imueclt qfimedu imtcjob imwbcrm  gvrfgap
tabstat imueclt qfimedu imtcjob imwbcrm  gvrfgap , s(min max range mean sem  sd p25 p50 p75 iqr n)
graph box imueclt qfimedu imtcjob imwbcrm gvrfgap
graph export image7.tif

*lets run th regress
regress trstlgl imueclt
regress trstlgl qfimedu
regress trstlgl imtcjob
regress trstlgl imwbcrm

regress imwbcnt imueclt
regress imwbcnt qfimedu
regress imwbcnt imtcjob
regress imwbcnt imwbcrm


scatter trstlgl imueclt || mband trstlgl imueclt, /*
*/ bands(5) clp(solid)


*this is a post-estimation command, so it will only return fitted values for the preceding regress command.
rvfplot, yline(0)
gen sizehat = _b[_cons]+_b[imueclt]*imueclt
scatter trstlgl imueclt, msymbol(oh) || line sizehat imueclt, sort

*Lets run the scatter plot
graph twoway (scatter trstlgl imueclt)(lfit trstlgl imueclt),xscale(range(0 15)) ///
yscale(range(0 15)) xtitle("Culture Enriched by Immigrants") ytitle("Trust in legal system") ///
title(Trust in legal system and Culture Enriched) ///
subtitle(2014 ESS)
graph export trstlgl_imueclt8.tif

graph twoway (scatter trstlgl qfimedu)(lfit trstlgl qfimedu),xscale(range(0 15)) ///
yscale(range(0 15)) xtitle("Culture Enriched by Immigrants") ytitle("Trust in legal system") ///
title(Trust in legal system and Culture Enriched) ///
subtitle(2014 ESS)
graph export trstlgl_qfimedu9.tif

graph twoway (scatter trstlgl imtcjob)(lfit trstlgl imtcjob),xscale(range(0 15)) ///
yscale(range(0 15)) xtitle("Culture Enriched by Immigrants") ytitle("Trust in legal system") ///
title(Trust in legal system and Culture Enriched) ///
subtitle(2014 ESS)
graph export trstlgl_imtcjob10.tif

graph twoway (scatter trstlgl imwbcrm)(lfit trstlgl imwbcrm),xscale(range(0 15)) ///
yscale(range(0 15)) xtitle("Culture Enriched by Immigrants") ytitle("Trust in legal system") ///
title(Trust in legal system and Culture Enriched) ///
subtitle(2014 ESS)
graph export trstlgl_imwbcrm11.tif



graph twoway (scatter imwbcnt imueclt)(lfit imwbcnt imueclt)
graph twoway (scatter imwbcnt qfimedu)(lfit imwbcnt qfimedu)
graph twoway (scatter imwbcnt imtcjob)(lfit imwbcnt imtcjob)
graph twoway (scatter imwbcnt imwbcrm)(lfit imwbcnt imwbcrm)
graph twoway (scatter imwbcnt gvrfgap)(lfit imwbcnt gvrfgap)

*Lets run the ttest
ttest trstlgl , by(citizen_IE)


*CONFIDENCE LEVEL 95%
ci means trstlgl

* You can also request p-values, and ask Stata to place a * next to significant correlations:
pwcorr trstlgl imueclt qfimedu imtcjob imwbcrm  gvrfgap, sig star(.05)
pwcorr trstlgl imueclt qfimedu imtcjob imwbcrm  gvrfgap, sig star(.05)

* The very helpful scatterplot matrix lets us inspect basic correlations very quickly
graph matrix trstlgl imueclt qfimedu imtcjob imwbcrm  gvrfgap,half
graph matrix imwbcnt imueclt qfimedu imtcjob imwbcrm  gvrfgap,half

*Multi-variate regression
bysort citizen_IE:reg trstlgl imueclt qfimedu imtcjob imwbcrm  gvrfgap, b
rvfplot, yline(0) 
hettest 




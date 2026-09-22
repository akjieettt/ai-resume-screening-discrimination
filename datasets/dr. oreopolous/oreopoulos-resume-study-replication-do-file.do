version 19.0
clear all
set more off

use "/Users/macos/Downloads/114770-V1/oreopoulos-resume-study-replication-data-file.dta", clear

* outreg2 is community-contributed and is required for the original table exports
capture which outreg2
if _rc {
    display as error "outreg2 is required; install it once with: ssc install outreg2"
    exit 199
}


*********************************************
* statistics and descriptive sample sizes
*********************************************

* modern table syntax: former by() variables are nested as row dimensions
table (name_ethnicity female name) (type), nototals
table (name_ethnicity female name) (type), statistic(sum callback) nototals

generate byte canada = name_ethnicity == "Canada"

table (type) (var), ///
    statistic(mean female ba_quality extracurricular_skills language_skills ma)

table (type) (var), ///
    statistic(mean same_exp exp_highquality reference legal accreditation)

generate byte greek = name_ethnicity == "Greek"
generate byte chinese_english = name_ethnicity == "Chn-Cdn"

table (type) (var), ///
    statistic(mean canada chinese pakistani indian british)


**********************
* table 4
**********************
drop if accreditation == 1 | reference == 1 | legal == 1

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Indian", "Canada"), vce(robust)
outreg2 using "tables", replace keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Pakistani", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Chinese", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Chn-Cdn", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "British", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Greek", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if inlist(name_ethnicity, "Indian", "Chinese", "Pakistani", "Canada"), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se) seeout


*******************************************************************************************
* drop british sample, sample with canadian-chinese, and greek names for rest of analysis
*******************************************************************************************
drop if inlist(name_ethnicity, "British", "Chn-Cdn", "Greek")


************************
* table 5
************************
replace same_exp = 0 if missing(same_exp)
replace reference = 0 if missing(reference)
replace accreditation = 0 if missing(accreditation)
replace legal = 0 if missing(legal)
replace extracurricular_skills = 0 if missing(extracurricular_skills)

regress callback i.type i.fall_data, vce(robust)
outreg2 using "tables", replace keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

areg callback i.type, absorb(firmid) vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal i.fall_data, vce(robust)
outreg2 using "tables", append ///
    keep(1.type 2.type 3.type 4.type female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se)

areg callback i.type female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal, ///
    absorb(firmid) vce(robust)
outreg2 using "tables", append ///
    keep(1.type 2.type 3.type 4.type female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se) seeout

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality i.fall_data, vce(robust)
outreg2 using "tables", replace ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp exp_highquality) ///
    bdec(3) aster(se) excel bracket(se)

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality i.fall_data if type == 0, vce(robust)
outreg2 using "tables", append ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp exp_highquality) ///
    bdec(3) aster(se) excel bracket(se)

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal i.fall_data ///
    if type == 1, vce(robust)
outreg2 using "tables", append ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se)

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal i.fall_data ///
    if type == 2, vce(robust)
outreg2 using "tables", append ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se)

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal i.fall_data ///
    if type == 3, vce(robust)
outreg2 using "tables", append ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se)

regress callback female ba_quality extracurricular_skills language_skills ///
    ma same_exp exp_highquality reference accreditation legal i.fall_data ///
    if type == 4, vce(robust)
outreg2 using "tables", append ///
    keep(female ba_quality extracurricular_skills language_skills ma same_exp ///
         exp_highquality reference accreditation legal) ///
    bdec(3) aster(se) excel bracket(se) seeout


**************************
* table 6
**************************
replace skillspeaking = skillspeaking / 100
replace skillsocialper = skillsocialper / 100
replace skillwriting = skillwriting / 100

replace skillspeaking = skillspeaking + skillsocialper + skillwriting

egen p10 = pctile(skillspeaking), p(10)
egen p20 = pctile(skillspeaking), p(20)
egen p30 = pctile(skillspeaking), p(30)
egen p40 = pctile(skillspeaking), p(40)
egen p50 = pctile(skillspeaking), p(50)
egen p60 = pctile(skillspeaking), p(60)
egen p70 = pctile(skillspeaking), p(70)
egen p80 = pctile(skillspeaking), p(80)
egen p90 = pctile(skillspeaking), p(90)

regress callback i.type i.fall_data ///
    if skillspeaking <= p10 & !missing(skillspeaking), vce(robust)
outreg2 using "tables", replace keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p10 & skillspeaking <= p20, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p20 & skillspeaking <= p30, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p30 & skillspeaking <= p40, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p40 & skillspeaking <= p50, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p50 & skillspeaking <= p60, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p60 & skillspeaking <= p70, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p70 & skillspeaking <= p80, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p80 & skillspeaking <= p90, vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se)

regress callback i.type i.fall_data ///
    if skillspeaking >= p90 & !missing(skillspeaking), vce(robust)
outreg2 using "tables", append keep(1.type 2.type 3.type 4.type) bdec(3) aster(se) excel bracket(se) seeout

**************************EPAD resilience code 06.2023*********************

*this code was developed with the help of Dr Gemma Hammerton and Dr Jon Heron. If you have any questions or comments regarding the code, please get in touch: egle.padaigaite@gmail.com



***************************Missing data patterns*****************************

*nr of missing values in each variable in those that had data at W4 (N=188)

mvpatterns pageatbirth psex W1_parent_degree W1_parent_education W1_parent_employment W1_parent_unemployed W123_singl_parent W123_income_less_20 Child_IQ Fcage W4_living_with_parent W4_degree_stud W4_employed W4_unemployed W4_married_or_partner W4_children_at_home ageonset antenatal postnatal fhdep anysevere comorbid_b parentremission3w warmth_child warm cparent csibwarmth mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot clubmonthly exercise csex cage W1_parent_degree Res_recov_pmh FcMDDtot FcODDCDtot FcGADtot if YP_P_participation_W4==1

*nr and % of people that has data on all variables

misstable patterns pageatbirth psex W1_parent_degree W1_parent_education W1_parent_employment W1_parent_unemployed W123_singl_parent W123_income_less_20 Child_IQ Fcage W4_living_with_parent W4_degree_stud W4_employed W4_unemployed W4_married_or_partner W4_children_at_home ageonset antenatal postnatal fhdep  anysevere comorbid_b parentremission3w warmth_child warm cparent csibwarmth mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot clubmonthly exercise csex cage W1_parent_degree Res_recov_pmh FcMDDtot FcODDCDtot FcGADtot  if YP_P_participation_W4==1, frequency 

*distribution of continuous variables

histogram ageonset, frequency normal
histogram fhdep, frequency normal
histogram warmth_child, frequency normal
histogram warm, frequency normal
histogram cparent, frequency normal
histogram csibwarmth, frequency normal
histogram mpeerr, frequency normal
histogram cpeerr, frequency normal
histogram cfrietotal, frequency normal
histogram Scoping, frequency normal
histogram W3_inhibitory_control, frequency normal
histogram W3_risk_adjustement, frequency normal
histogram W3_dys_attitudes_tot, frequency normal
histogram cage, frequency normal

*predictors of missingness (baseline demographics, risk exposures and MH variables)

format %8.2f ageonset fhdep pageatbirth Child_IQ cage

*continuous variables

foreach var of varlist ageonset fhdep pageatbirth Child_IQ cage {
oneway `var' participation_all_waves, tabulate
}

*binary/ categorical variables 

foreach var of varlist antenatal postnatal anysevere comorbid psex W1_parent_degree W1_parent_employment W1_single_parent W1_income csex DSMdisorder dep cdodd suicide W1_MD {
tab participation_all_waves `var', chi2 exact column row
}

*****************CATEGORICAL MH OUTCOME - MI and analyses********************

*keeping only relevant variables 

keep ID YP_P_participation_W4 ///
pageatbirth psex W1_parent_employment W1_single_parent W1_income ///
Child_IQ W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner ///
ageonset antenatal postnatal fhdep anysevere comorbid ///
parentremission3w warmth_child W1_positive_EE cparent csibwarmth mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot clubmonthly exercise ///
W1_parent_degree csex cage ///
DSMdisorder dep cdodd suicide W1_MD SDSMdisorder Sdep Scdodd Ssuicide W2_MD TDSMdisorder Tdep Tcdodd Tsuicide W3_MD FcDSMdisorder FcMDDtot_b FcODDCDtot_b Fcsuicide_w4 ///
Tcsibwarmth Twarmth_child Tpeewarr1 Tcoping Tcparent3 TcPeer TmPeer Tcfrietotal AGNTotalcommissions RA DAStotal Tmhhb7 Texercise Tmdem7 epi4plus durmean cwsspr Tmdem81 TcTotal_Difficulties ///
Fpee1e W4_socsup_mum_only Fm_sdq_peerR Fc_sdq_peerR W4_social_activities W4_exercise ///
Fc_sdq_emot Fc_sdq_cond Fc_sdq_hyper Fc_sdq_peer Fc_sdq_prosoc Fc_sdq_toti Fc_sdq_tot ///
Res_recov_pmh Resilient_not_all

*restricting analyses to those that had data at W4 (N=188)

keep if YP_P_participation_W4 ==1


********************************Multiple imputation*****************************

*specifying variables for MI + adding auxiliary variables

mi set flong
mi register regular pageatbirth fhdep csex cage W1_DSM_MDR
mi register imputed W1_parent_degree W1_parent_employment W1_single_parent W1_income ///
Child_IQ W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner ///
ageonset antenatal postnatal anysevere comorbid ///
parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot clubmonthly exercise ///
depR cdoddR suicideR W2_DSM_MDR SdepR ScdoddR SsuicideR W3_DSM_MDR TdepR TcdoddR TsuicideR FcDSMdisorderR FcMDDtot_bR FcODDCDtot_bR Fcsuicide_w4R ///
Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal Tmhhb7 Texercise Tmdem7 epi4plus durmean cwsspr Tmdem81 TcTotal_Difficulties

*dryrun using variables included in the analyses only. Local terms reduce number of lines/ variables in the MI code, but had  to be selected together with the MI code to work

*first creating categorical MH outcome variable that will be passively imputed (we imputed individual variables used to derive categorical MH outcome rather than variable itself) and included in all MI code lines to avoid bias. 

*creating MH categorical outcome. Values: 0 - poor MH, 1 - adult-onset MH problems, 2 - recovery, 3 - sustained good MH.

*resilient across W1-3

local term1 "(W1_DSM_MDR*depR*cdoddR*suicideR*W2_DSM_MDR*SdepR*ScdoddR*SsuicideR*W3_DSM_MDR*TdepR*TcdoddR*TsuicideR)"

*resilient at W4

local term2 "(FcDSMdisorderR*FcMDDtot_bR*FcODDCDtot_bR*Fcsuicide_w4R)"
local W1234_MH_outcomes "(`term1'+ (`term2'*2))"

*then, we created 3 dummy variables to use in include command (equivilient to using i.W1234_MH_outcomes). It means that MH1 (adult-onset MH problems) is >0 and < 2 (=1), otherwise 0 (ref).We used these dummy variables because include command didn't like MH == 1

local W1234_MH1 "((`W1234_MH_outcomes'>0)*(`W1234_MH_outcomes'<2))"
local W1234_MH2 "((`W1234_MH_outcomes'>1)*(`W1234_MH_outcomes'<3))"
local W1234_MH3 "((`W1234_MH_outcomes'>2)*(`W1234_MH_outcomes'<4))"

local MH_binary_vars "W1_DSM_MDR i.depR i.cdoddR i.suicideR i.W2_DSM_MDR i.SdepR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R"

*dryrun without auxiliary variables. Dryrun allows do the imputations without saving imputed files

mi impute chained ///
	(regress, include(`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`MH_binary_vars')) Child_IQ Scoping ///
	(logit, include(`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`MH_binary_vars')) W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_degree_stud W4_living_with_parent W4_married_or_partner antenatal postnatal anysevere comorbid parentremission3w clubmonthly exercise ///
	(logit, omit (i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR)) depR SdepR TdepR FcMDDtot_bR ///
	(logit, omit (i.depR i.suicideR i.W2_DSM_MDR i.SdepR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.Fcsuicide_w4R W1_DSM_MDR)) cdoddR ScdoddR TcdoddR ///
	(logit, omit (i.depR i.suicideR i.W2_DSM_MDR i.SdepR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.Fcsuicide_w4R W1_DSM_MDR)) FcODDCDtot_bR ///
	(logit, omit (i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR)) suicideR SsuicideR TsuicideR Fcsuicide_w4R ///
	(logit, omit (i.depR i.cdoddR i.suicideR i.SdepR i.ScdoddR i.SsuicideR i.TdepR i.TcdoddR i.TsuicideR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R)) W2_DSM_MDR W3_DSM_MDR FcDSMdisorderR ///
	(pmm, knn(10) include(`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`MH_binary_vars')) ageonset csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot ///
	= pageatbirth fhdep csex cage W1_DSM_MDR, dryrun


*********************MI code with auxiliary variables*********************

*we had perfect prediction problems with several variables, so used augment function for exercise, anysevere, single parent, W4 degree or studying, antenatal (perfect prediction with adult-onset), and remission (perfect prediction with SGMH)

*we used additional local terms for other variables too, such as risk, protective factors, demographics etc.

*select all code below in order to work

*caregorical MH outcome variable

local term1 "(W1_DSM_MDR*depR*cdoddR*suicideR*W2_DSM_MDR*SdepR*ScdoddR*SsuicideR*W3_DSM_MDR*TdepR*TcdoddR*TsuicideR)"
local term2 "(FcDSMdisorderR*FcMDDtot_bR*FcODDCDtot_bR*Fcsuicide_w4R)"
local W1234_MH_outcomes "(`term1'+ (`term2'*2))"

*dummy variables for categorical MH variable

local W1234_MH1 "((`W1234_MH_outcomes'>0)*(`W1234_MH_outcomes'<2))"
local W1234_MH2 "((`W1234_MH_outcomes'>1)*(`W1234_MH_outcomes'<3))"
local W1234_MH3 "((`W1234_MH_outcomes'>2)*(`W1234_MH_outcomes'<4))"

local protective "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_erem "csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_ecog "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping i.clubmonthly i.exercise"

local protective_aux "Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise"

*W1_degree, sex and age missing (since has to be included in all models)
local demographics "Child_IQ i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_eiq "i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_aux "cwsspr i.Tmdem81 i.Tmdem7 TcTotal_Difficulties"

*age onset, anysever and fhdep missing (since risk exposures) 
local parentdep "i.antenatal i.postnatal i.comorbid i.parentremission3w"

*excludes remission
local parentdep_erem "i.antenatal i.postnatal i.comorbid"

*excludes DSMdisorder since used in MH_binary_vars
local parentdep_aux "durmean i.epi4plus"

local MH_binary_vars "W1_DSM_MDR i.depR i.cdoddR i.suicideR i.W2_DSM_MDR i.SdepR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R"

*****************************complete MI code**********************************

mi impute chained ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `demographics_aux' `MH_binary_vars')) ageonset ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `demographics_aux' `MH_binary_vars') augment) anysevere ///
    (logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `parentdep_aux' `MH_binary_vars')) W1_parent_degree ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) warmth_child Twarmth_child W1_positive_EE Tpeewarr1 cparent Tcparent3 ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) csibwarmth Tcsibwarmth ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) mpeerr cpeerr cfrietotal TcPeer TmPeer Tcfrietotal ///	
	(regress, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) Scoping Tcoping  ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics_eiq' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping RA i.Tmhhb7 i.Texercise)) W3_inhibitory_control AGNTotalcommissions W3_dys_attitudes_tot DAStotal  ///	
	(regress, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics_eiq' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions DAStotal i.Tmhhb7 i.Texercise)) W3_risk_adjustement RA ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) clubmonthly Texercise ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal) augment) exercise ///
	(ologit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) Tmhhb7 ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `demographics_aux' `protective_aux' `MH_binary_vars') augment) parentremission3w ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars')) postnatal comorbid epi4plus ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars') augment) antenatal ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars')) durmean ///
	(regress,  include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_ecog' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) Child_IQ cwsspr  ///
	(ologit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) Tmdem7 ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) TcTotal_Difficulties ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) W1_parent_employment W4_living_with_parent W4_married_or_partner Tmdem81 ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars') augment) W4_degree_stud ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars' i.Tmdem7)) W1_income W4_employed ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars' i.Tmdem7) augment) W1_single_parent ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.TdepR i.FcMDDtot_bR)) depR SdepR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.depR i.FcMDDtot_bR)) TdepR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.SdepR i.TdepR)) FcMDDtot_bR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.suicideR i.W2_DSM_MDR i.SdepR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.Fcsuicide_w4R W1_DSM_MDR)) cdoddR ScdoddR TcdoddR FcODDCDtot_bR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.SsuicideR i.Fcsuicide_w4R)) suicideR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.suicideR i.Fcsuicide_w4R)) SsuicideR TsuicideR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.suicideR i.SsuicideR)) Fcsuicide_w4R ///	
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.suicideR i.SdepR i.ScdoddR i.SsuicideR i.TdepR i.TcdoddR i.TsuicideR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R)) W2_DSM_MDR W3_DSM_MDR FcDSMdisorderR ///
	= pageatbirth fhdep csex cage W1_DSM_MDR, add(100) rseed(1234) noisily


*saving and using imputed files

save "EPAD_cat_MI", replace
use "EPAD_cat_MI", clear


**********************diagnostics of MI model********************************

*convergence plots to see if more iterations needed. Doing another MI model using preserve and savetrace functions.

*categorical MH outcome variable
local term1 "(W1_DSM_MDR*depR*cdoddR*suicideR*W2_DSM_MDR*SdepR*ScdoddR*SsuicideR*W3_DSM_MDR*TdepR*TcdoddR*TsuicideR)"
local term2 "(FcDSMdisorderR*FcMDDtot_bR*FcODDCDtot_bR*Fcsuicide_w4R)"
local W1234_MH_outcomes "(`term1'+ (`term2'*2))"

*dummy variables

local W1234_MH1 "((`W1234_MH_outcomes'>0)*(`W1234_MH_outcomes'<2))"
local W1234_MH2 "((`W1234_MH_outcomes'>1)*(`W1234_MH_outcomes'<3))"
local W1234_MH3 "((`W1234_MH_outcomes'>2)*(`W1234_MH_outcomes'<4))"

*other local terms
local protective "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_erem "csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_ecog "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping i.clubmonthly i.exercise"

local protective_aux "Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise"

local demographics "Child_IQ i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_eiq "i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_aux "cwsspr i.Tmdem81 i.Tmdem7 TcTotal_Difficulties"

local parentdep "i.antenatal i.postnatal i.comorbid i.parentremission3w"

local parentdep_erem "i.antenatal i.postnatal i.comorbid"

local parentdep_aux "durmean i.epi4plus"

local MH_binary_vars "W1_DSM_MDR i.depR i.cdoddR i.suicideR i.W2_DSM_MDR i.SdepR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R"

*model 

preserve
mi impute chained ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `demographics_aux' `MH_binary_vars')) ageonset ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `demographics_aux' `MH_binary_vars') augment) anysevere ///
    (logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_aux' `parentdep_aux' `MH_binary_vars')) W1_parent_degree ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) warmth_child Twarmth_child W1_positive_EE Tpeewarr1 cparent Tcparent3 ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) csibwarmth Tcsibwarmth ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) mpeerr cpeerr cfrietotal TcPeer TmPeer Tcfrietotal ///	
	(regress, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) Scoping Tcoping  ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics_eiq' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping RA i.Tmhhb7 i.Texercise)) W3_inhibitory_control AGNTotalcommissions W3_dys_attitudes_tot DAStotal  ///	
	(regress, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics_eiq' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions DAStotal i.Tmhhb7 i.Texercise)) W3_risk_adjustement RA ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) clubmonthly Texercise ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal) augment) exercise ///
	(ologit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`parentdep_erem' `demographics' `demographics_aux' `parentdep_aux' `MH_binary_vars' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) Tmhhb7 ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `demographics_aux' `protective_aux' `MH_binary_vars') augment) parentremission3w ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars')) postnatal comorbid epi4plus ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars') augment) antenatal ///	
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`demographics' `protective_erem' `demographics_aux' `protective_aux' `MH_binary_vars')) durmean ///
	(regress,  include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective_ecog' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) Child_IQ cwsspr  ///
	(ologit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) Tmdem7 ///
	(pmm, knn(10) include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) TcTotal_Difficulties ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars')) W1_parent_employment W4_living_with_parent W4_married_or_partner Tmdem81 ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars') augment) W4_degree_stud ///	
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars' i.Tmdem7)) W1_income W4_employed ///
	(logit, include (`W1234_MH1'`W1234_MH2'`W1234_MH3') omit (`protective' `parentdep' `protective_aux' `parentdep_aux' `MH_binary_vars' i.Tmdem7) augment) W1_single_parent ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.TdepR i.FcMDDtot_bR)) depR SdepR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.depR i.FcMDDtot_bR)) TdepR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.cdoddR i.suicideR i.W2_DSM_MDR i.ScdoddR i.SsuicideR i.W3_DSM_MDR i.TcdoddR i.TsuicideR i.FcDSMdisorderR i.FcODDCDtot_bR i.Fcsuicide_w4R W1_DSM_MDR i.SdepR i.TdepR)) FcMDDtot_bR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.suicideR i.W2_DSM_MDR i.SdepR i.SsuicideR i.W3_DSM_MDR i.TdepR i.TsuicideR i.FcDSMdisorderR i.FcMDDtot_bR i.Fcsuicide_w4R W1_DSM_MDR)) cdoddR ScdoddR TcdoddR FcODDCDtot_bR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.SsuicideR i.Fcsuicide_w4R)) suicideR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.suicideR i.Fcsuicide_w4R)) SsuicideR TsuicideR ///
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.W2_DSM_MDR i.SdepR i.ScdoddR i.W3_DSM_MDR i.TdepR i.TcdoddR i.FcDSMdisorderR i.FcMDDtot_bR i.FcODDCDtot_bR W1_DSM_MDR i.suicideR i.SsuicideR)) Fcsuicide_w4R ///	
	(logit, omit (`protective_aux' `demographics_aux' `parentdep_aux' i.depR i.cdoddR i.suicideR i.SdepR i.ScdoddR i.SsuicideR i.TdepR i.TcdoddR i.TsuicideR i.FcMDDtot_bR i.FcODDCDtot_bR i.Fcsuicide_w4R)) W2_DSM_MDR W3_DSM_MDR FcDSMdisorderR ///
	= pageatbirth fhdep csex cage W1_DSM_MDR, add(5) rseed(1234) savetrace(extrace_cat, replace) burnin(100) noisily

*convergence plots 

use extrace_cat, replace
reshape wide *mean *sd, i(iter) j(m)
tsset iter
tsline ageonset_mean*, legend(off)
graph export ageonset_mean.png, replace
tsline ageonset_sd*, legend(off)
graph export ageonset_sd.png, replace
tsline Child_IQ_mean*, legend(off)
graph export Child_IQ_mean.png, replace
tsline Child_IQ_sd*, legend(off)
graph export Child_IQ_sd.png, replace
tsline cparent_mean*, legend(off)
graph export cparent_mean.png, replace
tsline cparent_sd*, legend(off)
graph export cparent_sd.png, replace
tsline W1_positive_EE_mean*, legend(off)
graph export W1_positive_EE_mean.png, replace
tsline W1_positive_EE_sd*, legend(off)
graph export W1_positive_EE_sd.png, replace
restore

*************comparing % and M (SD) in imputed vs complete data***************

use "EPAD_cat_MI", clear

local term1"(W1_DSM_MDR*depR*cdoddR*suicideR*W2_DSM_MDR*SdepR*ScdoddR*SsuicideR*W3_DSM_MDR*TdepR*TcdoddR*TsuicideR)"

local term2 "(FcDSMdisorderR*FcMDDtot_bR*FcODDCDtot_bR*Fcsuicide_w4R)"

gen W1234_MH_outcomes = `term1'+(`term2'*2)

gen W1234_SGMH = W1234_MH_outcomes
recode W1234_SGMH (3=1) (0 1 2=0)

* The imputations are indexed by three new variables - _mi_id is the participant ID number; _mi_m is the imputation number (1 through 10, where 0 is the original, non-imputed, data); _mi_miss indicates which IDs had complete data for all the variables in the imputation model

sum _mi_id _mi_miss _mi_m

*formating for 2 decimals

format %8.2f ageonset cparent cfrietotal Child_IQ W3_inhibitory_control W1_single_parent W1_income W4_degree_stud parentremission3w

*mean and summary statistics for the imputed vs complete data

sum W1234_SGMH if _mi_m == 0
tab _mi_m, sum(W1234_SGMH)

sum ageonset if _mi_m == 0
tab _mi_m, sum(ageonset)


**********************Monte Carlo error/ rules********************

*it should be m>=100×FMI in each analysis

*p-value is about 0.01 for significant variables (value below coefficient p value) 

*The Monte Carlo error of B is approximately 10 per cent of its standard error (so one value below coefficient vs SE of the coefficient) 

mi estimate, mcerror: logistic W1234_SGMH ageonset
mi estimate, mcerror: logistic W1234_SGMH W1_positive_EE


**********************Analyses with imputed data******************

*for overall proportions

mi estimate: proportion W1234_MH_outcomes

*for non-problematic variables (without perfect prediction). Note: esampvaryok allows sample sizes vary between the datasets; otherwise would show error

foreach var of varlist postnatal comorbid parentremission3w {
mi estimate, esampvaryok: mean `var', over (W1234_MH_outcomes)
}

*for problematic variables (with perfect prediction in adult-onset (1) group)

foreach var of varlist antenatal anysevere {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==0
}

foreach var of varlist antenatal anysevere {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==2
}

foreach var of varlist antenatal anysevere {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==3
}

*to see direction of perfect prediction in adult-onset group 

mi xeq 1/100: proportion antenatal if W1234_MH_outcomes==1

*for total estimates

foreach var of varlist ageonset fhdep {
mi estimate: mean `var'
}

foreach var of varlist antenatal postnatal anysevere comorbid parentremission3w {
mi estimate: proportion `var'
}

*Sustained good MH vs not comparisons

*standardising variables

foreach var of varlist ageonset fhdep pageatbirth Child_IQ cpeerr mpeerr cfrietotal cparent csibwarmth warmth_child W1_positive_EE Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot {
{
sum `var' if _mi_m == 1
gen z`var'_mi = (`var' - r(mean))/r(sd) if _mi_m == 1
}
 
forvalues impdata = 2/100 {
sum `var' if _mi_m ==`impdata'
replace z`var'_mi = (`var' - r(mean))/r(sd) if _mi_m==`impdata'
}
}

*for risk exposure associations with sustained good MH

foreach var of varlist zageonset_mi zfhdep_mi antenatal postnatal anysevere comorbid {
mi estimate, or: logistic W1234_SGMH `var'
}

*estimates in each MH outcome group

*chronic poor MH

foreach var of varlist W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==0
}

*adult-onset excluding single parent + W4_degree_stud perfect prediction - almost everyone has a degree and almost no one is single parent

foreach var of varlist W1_parent_degree W1_parent_employment  W1_income W4_living_with_parent  W4_employed W4_married_or_partner {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==1
}

*recovery 

foreach var of varlist W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==2
}

*SGMH 

foreach var of varlist W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner {
mi estimate, esampvaryok: proportion `var' if W1234_MH_outcomes==3
}

*for total 

foreach var of varlist pageatbirth Child_IQ {
mi estimate: mean `var'
}

foreach var of varlist W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner {
mi estimate: proportion `var'
}

*Sustained good MH vs not comparisons

*unadjusted

foreach var of varlist zwarmth_child_mi zW1_positive_EE_mi zcparent_mi zmpeerr_mi zcpeerr_mi zcfrietotal_mi zScoping_mi zW3_inhibition_mi zW3_risk_adjustement_mi zW3_dys_attitudes_tot_mi clubmonthly exercise {
mi estimate, or: logistic W1234_SGMH `var'
}

*adjusted

foreach var of varlist zwarmth_child_mi zW1_positive_EE_mi zcparent_mi zmpeerr_mi zcpeerr_mi zcfrietotal_mi zScoping_mi zW3_inhibition_mi zW3_risk_adjustement_mi zW3_dys_attitudes_tot_mi clubmonthly exercise {
mi estimate, or: logistic W1234_SGMH `var' W1_parent_degree csex cage
}





****************************RESIDUAL OUTCOME - MI code and analyses************

*restricting to those that participated at W4

keep if YP_P_participation_W4 ==1

*specifying variables + adding auxiliary variables

mi set flong
mi register regular pageatbirth fhdep csex cage DSMdisorder 
mi register imputed W1_parent_degree W1_parent_employment W1_single_parent W1_income ///
Child_IQ W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner ///
ageonset antenatal postnatal anysevere comorbid ///
parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot clubmonthly exercise ///
FcMDDtot FcODDCDtot FcGADtot ///
Tpcdeptot Tpcoddtot TcanxGAD Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal Tmhhb7 Texercise Tmdem7 epi4plus durmean cwsspr Tmdem81 TcTotal_Difficulties

*dryrun

mi impute chained ///
 (regress) Child_IQ Scoping ///
	(logit) W1_parent_degree W1_parent_employment W1_single_parent W1_income W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner antenatal postnatal anysevere comorbid parentremission3w clubmonthly exercise  ///
	(pmm, knn(10)) ageonset csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot FcMDDtot FcODDCDtot FcGADtot ///
	= pageatbirth fhdep csex cage DSMdisorder, dryrun
	

*****************************MI with auxiliary variables***********************

*using local terms to simplify the code (select all code to work)

local outcomes_aux "Tpcdeptot Tpcoddtot TcanxGAD" 

local protective "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_erem "csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot i.clubmonthly i.exercise"

local protective_ecog "i.parentremission3w csibwarmth warmth_child W1_positive_EE cparent mpeerr cpeerr cfrietotal Scoping i.clubmonthly i.exercise"

local protective_aux "Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise"

local demographics "Child_IQ i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_eiq "i.W1_parent_employment i.W1_single_parent i.W1_income i.W4_living_with_parent i.W4_degree_stud i.W4_employed i.W4_married_or_partner pageatbirth"

local demographics_aux "cwsspr i.Tmdem81 i.Tmdem7 TcTotal_Difficulties"

local parentdep "i.antenatal i.postnatal i.comorbid i.parentremission3w"

local parentdep_erem "i.antenatal i.postnatal i.comorbid"

local parentdep_aux "durmean DSMdisorder i.epi4plus"


***************************complete MI code********************************

mi impute chained ///
	(pmm, knn(10) omit (`outcomes_aux' `protective_aux' `demographics_aux')) ageonset ///
	(logit, omit (`outcomes_aux' `protective_aux' `demographics_aux')) anysevere ///
    (logit, omit (`outcomes_aux' `protective_aux' `parentdep_aux')) W1_parent_degree ///
	(pmm, knn(10) omit(`protective_aux' `demographics_aux' `parentdep_aux')) FcMDDtot FcODDCDtot FcGADtot Tpcdeptot Tpcoddtot TcanxGAD ///
	(pmm, knn(10) omit(`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) warmth_child Twarmth_child W1_positive_EE Tpeewarr1 cparent Tcparent3 ///
	(pmm, knn(10) omit (`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) csibwarmth Tcsibwarmth ///	
	(pmm, knn(10) omit(`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 Tcoping AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) mpeerr cpeerr cfrietotal TcPeer TmPeer Tcfrietotal ///	
	(regress, omit (`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal AGNTotalcommissions RA DAStotal i.Tmhhb7 i.Texercise)) Scoping Tcoping  ///	
	(pmm, knn(10) omit(`parentdep_erem' `demographics_eiq' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping RA i.Tmhhb7 i.Texercise)) W3_inhibitory_control AGNTotalcommissions W3_dys_attitudes_tot DAStotal  ///	
	(regress, omit (`parentdep_erem' `demographics_eiq' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions DAStotal i.Tmhhb7 i.Texercise)) W3_risk_adjustement RA ///	
	(logit, omit (`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) clubmonthly exercise Texercise ///	
	(ologit, omit (`parentdep_erem' `demographics' `outcomes_aux' `demographics_aux' `parentdep_aux' Tcsibwarmth Twarmth_child Tpeewarr1 Tcparent3 TmPeer TcPeer Tcfrietotal Tcoping AGNTotalcommissions RA DAStotal)) Tmhhb7 ///
	(logit, omit (`demographics' `outcomes_aux' `demographics_aux' `protective_aux')) parentremission3w ///
	(logit, omit (`demographics' `protective_erem' `demographics_aux' `outcomes_aux' `protective_aux')) antenatal postnatal comorbid epi4plus ///	
	(pmm, knn(10) omit (`demographics' `protective_erem' `demographics_aux' `outcomes_aux' `protective_aux')) durmean ///
	(regress, omit (`protective_ecog' `parentdep' `outcomes_aux' `protective_aux' `parentdep_aux')) Child_IQ cwsspr  ///
	(ologit, omit (`protective' `parentdep' `outcomes_aux' `protective_aux' `parentdep_aux')) Tmdem7 ///
	(pmm, knn(10) omit (`protective' `parentdep' `outcomes_aux' `protective_aux' `parentdep_aux')) TcTotal_Difficulties ///
	(logit, omit (`protective' `parentdep' `outcomes_aux' `protective_aux' `parentdep_aux')) W1_parent_employment W4_living_with_parent W4_degree_stud W4_married_or_partner Tmdem81 ///
	(logit, omit (`protective' `parentdep' `outcomes_aux' `protective_aux' `parentdep_aux' i.Tmdem7)) W1_single_parent W1_income W4_employed ///
		= pageatbirth fhdep csex cage DSMdisorder, add(100) rseed(1234) noisily

*saving and using the file

save "EPAD_res_MI", replace	
use "EPAD_res_MI", clear

*******note: used same steps for diagnostics as in categorical MI model*********

*creating residual scores in imputed data 

foreach var of varlist FcMDDtot FcODDCDtot FcGADtot {
forvalues impdata = 1/100 { 
regress `var' ageonset anysevere fhdep if _mi_m==`impdata'
predict `var'_res_mi_`impdata' if _mi_m==`impdata', r
}
}

*this created multiple variables (in each imputed dataset). Merging them into total (tot) variables and droping individual variables

egen MDD_res_mi_tot = rowtotal(FcMDDtot_res_mi_*) if _mi_m>0
egen ODDCD_res_mi_tot = rowtotal(FcODDCDtot_res_mi_*) if _mi_m>0
egen GAD_res_mi_tot = rowtotal(FcGADtot_res_mi_*) if _mi_m>0

drop FcMDDtot_res_mi_* FcODDCDtot_res_mi_* FcGADtot_res_mi_*

*standardising variables

foreach var of varlist MDD_res_mi_tot ODDCD_res_mi_tot GAD_res_mi_tot cpeerr mpeerr cfrietotal cparent csibwarmth warmth_child W1_positive_EE Scoping W3_inhibitory_control W3_risk_adjustement W3_dys_attitudes_tot pageatbirth Child_IQ ageonset fhdep {
{
sum `var' if _mi_m == 1
gen z`var'_mi = (`var' - r(mean))/r(sd) if _mi_m == 1
}
 
forvalues impdata = 2/100 {
sum `var' if _mi_m ==`impdata'
replace z`var'_mi = (`var' - r(mean))/r(sd) if _mi_m==`impdata'
}
}


******************************analyse with imputed data***********************

*risk exposures

foreach var of varlist antenatal postnatal comorbid zpageatbirth_mi W1_parent_degree W1_parent_employment W1_single_parent W1_income zChild_IQ_mi W4_living_with_parent W4_degree_stud W4_employed W4_married_or_partner {
mi estimate:regress zMDD_res_mi_tot_mi `var'
}

*protective factors

*models for MDD - unadjusted

foreach var of varlist parentremission3w zwarmth_child_mi zW1_positive_EE_mi zcparent_mi zmpeerr_mi zcpeerr_mi zcfrietotal_mi zScoping_mi zW3_inhibitory_control_mi zW3_risk_adjustement_mi zW3_dys_attitudes_tot_mi clubmonthly exercise {
mi estimate:regress zMDD_res_mi_tot_mi `var'
}

*models for MDD - adjusted

foreach var of varlist parentremission3w zwarmth_child_mi zW1_positive_EE_mi zcparent_mi  zmpeerr_mi zcpeerr_mi zcfrietotal_mi zScoping_mi zW3_inhibitory_control_mi  zW3_risk_adjustement_mi zW3_dys_attitudes_tot_mi clubmonthly exercise {
mi estimate:regress zMDD_res_mi_tot_mi  `var' W1_parent_degree csex cage
}


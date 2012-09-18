source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\PairsExplore.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\read.dat.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\chk.libs.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\read.dat.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\my.panel.smooth.binary.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\Predictor.inspection.r")

infil="C:\\temp\\TestDataSets\\CanadaThistleNewFormat.csv"
predictor="bio_13"

## Nonspatial data should work through SAHM
i="C:\\temp\\SAHM_workspace\\NonSpatialData.csv"
predictor="PrecipitatoinRast"

## Used available should work as well
i="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\ElithPsdoAbs.csv"
o="C:\\temp\\SAHMDebugJunk\\BRTOut1" 
predictor="Temperature"  
   Predictor.inspection(predictor,
        input.file=i,
    		output.dir=o,
    		response.col=rc,
    		pres=TRUE,
    		absn=TRUE,
    		bgd=FALSE)
    		
infil="J:\\Projects\\Climate_RS_Comparison\\Cheatgrass_VisTrails\\ModelEvaluation_Split_2.csv"
predictor="bio_08_2000_2009_2km"
infil="I:\\VisTrails\\WorkingFiles\\secondseason\\secondseason_workfile_2012_02_28b\\ModelEvaluation_Split_10.csv"
predictor="PRISM_bio_06_1971_2000_800m"
output.dir="C:\\temp\\SAHMDebugJunk\\BRTOut1"
response.col="responseBinary"
pres=TRUE
absn=TRUE
bgd=TRUE
infil="C:\\VisTrails\\mtalbert_20110504T132851\\readMaTests\\Split.csv"
predictor="bio_13_wgs84"

infil="I:\\VisTrails\\WorkingFiles\\secondseason\\secondseason_workfile_2012_02_28b\\ModelEvaluation_Split_9.csv"
predictor="bio_17_2009_2km"
predictor="bio_14_2009_2km"
infil="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\modelSelection_split_8.csv" 
output.dir="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode"
predictor="EVI_baselevels2_2001" 
i="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\modelSelection_split_20.csv" 
o="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\PredictorInspections" 
rc="responseBinary" 
predictor="romoveg_rc_categorical"    
    Predictor.inspection(predictor,
        input.file=i,
    		output.dir=o,
    		response.col=rc,
    		pres=TRUE,
    		absn=TRUE,
    		bgd=FALSE)
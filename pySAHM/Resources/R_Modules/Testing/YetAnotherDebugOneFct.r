#debug branch
setwd("I:\\VisTrails\\VisTrails_SAHM_x64_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules")
ScriptPath="I:\\VisTrails\\VisTrails_SAHM_x64_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules"
dir.path<-"I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode2\\TestSuite\\AcrossModelPerformance\\Debug10.25"

#master branch
#setwd("I:\\VisTrails\\VisTrails_SAHM_x32\\VisTrails\\vistrails\\packages\\sahm\\pySAHM\\Resources\\R_Modules")
#ScriptPath="I:\\VisTrails\\VisTrails_SAHM_x32\\VisTrails\\vistrails\\packages\\sahm\\pySAHM\\Resources\\R_Modules"
#dir.path<-"C:\\temp\\AcrossModelPerformanceDetailsForTesting\\MasterBranch7.12"
#For Model tests
source("LoadRequiredCode.r")
source("MARS.helper.fcts.r")
source("GLM.helper.fcts.r")
source("BRT.helper.fcts.r")
source("RF.helper.fcts.r")

#For Apply Model Tests
source("EvaluateNewData.r")

#For PairsExplore and parameter inspection
source("PairsExplore.r")
source("Predictor.inspection.r")
source("my.panel.smooth.binary.r")

#For Data Splitting
source("TestTrainSplit.r")
source("CrossValidationSplit.r")



rc=c(rep("responseBinary",times=14),rep("responseCount",times=2))
input.file<-vector()
input.file=c(#used/available
      "C:\\temp\\SAHM_workspace\\Species1PresOnlyCV.csv",
      "I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\UsedAvailableSp1NoCV.csv",
      ## new file for checking pseudoabs
      "I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\ElithPsdoAbs.csv",
      ##elith synthetic surface presence absence
      "C:\\temp\\SAHM_workspace\\modelSelection_split_20.csv",
      ## Nonspatial data should work through SAHM
      "C:\\temp\\SAHM_workspace\\NonSpatialData.csv",      
      
        #pres/abs
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/BadPath.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/Split.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitBadFactor.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitFactor.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/Factor.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitFactor2.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitWeights.csv",  
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/NoSplit.csv",
      "C:\\temp\\SAHM_workspace\\PresAbsCrossVal.csv",
       #count
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/Count.csv",
      "C:/VisTrails/mtalbert_20110504T132851/readMaTests/CountSplit.csv")

#I'm cutting these out of the standard test suite because they take a long time to run
#and only test whether we run well on large datasets or big tiffs
#"C:/VisTrails/mtalbert_20110504T132851/readMaTests/CanadaThistleNewFormat.csv"
#"C:/VisTrails/mtalbert_20110504T132851/readMaTests/LargeSplit.csv"
#add a missing data csv and maybe a couple with pseudo absence
output.dir<-vector()
output.dir[1]<-paste(dir.path,"\\rf",sep="")
output.dir[2]<-paste(dir.path,"\\brt",sep="")
output.dir[3]<-paste(dir.path,"\\mars",sep="")
output.dir[4]<-paste(dir.path,"\\glm",sep="")
output.dir[5]<-paste(dir.path,"\\maxlike",sep="")


########   Model Fit Test  ###########
        ##BRT
         for(i in 1:length(input.file)){
              try(FitModels(ma.name=input.file[i],
                        tif.dir=NULL,output.dir=output.dir[2],
                        response.col=rc[i],make.p.tif=T,make.binary.tif=F,n.folds=3,simp.method="cross-validation",tc=NULL,alpha=1,
                    family = "bernoulli",max.trees = 10000,tolerance.method = "auto",
                tolerance = 0.001,seed=1,opt.methods=2,
                        simp.method="cross-validation",debug.mode=T,responseCurveForm="pdf",script.name="brt",
                        learning.rate =NULL, bag.fraction = 0.5,prev.stratify = TRUE, max.trees = NULL,opt.methods=2,save.model=TRUE,MESS=F))
                      }
              
              
              ##MARS
              for(i in 1:length(input.file)){
                  try(FitModels(ma.name=input.file[i],
                          tif.dir=NULL,output.dir=output.dir[3],
                          response.col=rc[i],make.p.tif=T,make.binary.tif=T,
                          mars.degree=1,mars.penalty=2,debug.mode=T,responseCurveForm="pdf",script.name="mars",opt.methods=2,MESS=TRUE))
                      }
                
              
              ##GLM
              for(i in 1:length(input.file)){
                  try(FitModels(ma.name=input.file[i],
                        tif.dir=NULL,
                        output.dir=output.dir[4],
                        response.col=rc[i],make.p.tif=T,make.binary.tif=F,
                        simp.method="AIC",debug.mode=T,responseCurveForm="pdf",script.name="glm",MESS=FALSE,opt.methods=2,squared.terms=TRUE))
                        }
              
              ### Random Forest
              for(i in 1:length(input.file)){
              proximity=NULL
              try(FitModels(ma.name=input.file[i],
                    tif.dir=NULL,
                    output.dir=output.dir[1],
                    response.col=rc[i],make.p.tif=T,make.binary.tif=F,
                        debug.mode=T,opt.methods=2,script.name="rf",
              responseCurveForm="pdf",xtest=NULL,ytest=NULL,n.trees=1000,mtry=NULL,
              samp.replace=FALSE,sampsize=NULL,nodesize=NULL,maxnodes=NULL,importance=FALSE,
              localImp=FALSE,nPerm=1,proximity=NULL,oob.prox=proximity,norm.votes=TRUE,
              do.trace=FALSE,keep.forest=NULL,keep.inbag=FALSE,save.model=TRUE,MESS=F,seed=1))
                 }
 
              ### Maxlike
              Formula="~bio_06_2000_2km + bio_14_2000_4km + NDVI_annualMaximumValue_2009 + NDVI_greenuprates1_2003 + NDVI_peakdates1_2003"
            
               for(i in 1:2){
                try(FitModels(ma.name=input.file[i],
                		tif.dir=NULL,
                		output.dir=output.dir[5],
                		response.col=rc[i],
                		make.p.tif=T,make.binary.tif=T,
                		debug.mode=T,responseCurveForm="pdf",script.name="maxlike",
                		opt.methods=2,MESS=T,Formula=Formula,UseTiffs=FALSE))
              }
              		
### Pairs Explore Tests  #####
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\PairsExplore.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\read.dat.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\chk.libs.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\read.dat.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\my.panel.smooth.binary.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\Predictor.inspection.r")
source("I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\sahm_MarianDev\\pySAHM\\Resources\\R_Modules\\Predictor.inspection.r")
dir.path<-"C:\\temp\\AcrossModelPerformanceDetailsForTesting\\OneFunction6.6"
input.file<-vector()

input.file[1]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/Split.csv"
input.file[2]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitFactor.csv"
input.file[3]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitWeights.csv"
input.file[4]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/CanadaThistleMissingDat.csv"
input.file[5]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/SplitCrossVal.csv"
input.file[6]="C:/temp/TestDataSets/CanadaThistlePseudoAbsenceWeights.csv"
input.file[7]="C:/VisTrails/mtalbert_20110504T132851/readMaTests/Count.csv"
##pseudoabs
input.file[8]="I:\\VisTrails\\VisTrails_SAHM_x32_debug\\VisTrails\\vistrails\\packages\\TestingRCode\\ElithPsdoAbs.csv"
      ## Nonspatial data should work through SAHM
input.file[9]="C:\\temp\\SAHM_workspace\\NonSpatialData.csv"   
predictor<-c("bio_13_wgs84","bio_15_wgs84_categorical","bio_7_wgs84","asp_2k_alb","bio_16_wgs84","bio_8","dem","Temperature","Noise2Rast")
responseCol<-c(rep("responseBinary",times=6),rep("responseCount",times=1))

for(i in 1:length(input.file)){
   if(i==1) { 
       try(Pairs.Explore(num.plots=5,
                min.cor=.5,
                input.file=input.file[i],
            		output.file=paste(dir.path,"\\PairsExploreTest2\\",i,"Par1",".jpg",sep=""),
            		response.col=responseCol[i],
            		pres=TRUE,
            		absn=TRUE,
            		bgd=TRUE))
        try(Pairs.Explore(num.plots=10,
                min.cor=.5,
                input.file=input.file[i],
            		output.file=paste(dir.path,"\\PairsExploreTest2\\",i,"Par2",".jpg",sep=""),
            		response.col=responseCol[i],
            		pres=TRUE,
            		absn=FALSE,
            		bgd=FALSE,
                cors.w.highest=TRUE))
       try(Predictor.inspection(predictor[i],
                input.file=input.file[i],
            		output.dir=paste(dir.path,"\\PairsExploreTest2",sep=""),
            		response.col=responseCol[i],
            		pres=TRUE,
            		absn=TRUE,
            		bgd=TRUE))              				
    }		
 try(Pairs.Explore(num.plots=15,
    min.cor=min.cor,
    input.file=input.file[i],
		output.file=paste(dir.path,"\\PairsExploreTest2\\",i,".jpg",sep=""),
		response.col=responseCol[i],
		pres=TRUE,
		absn=TRUE,
		bgd=TRUE))
		
	try(Predictor.inspection(predictor[i],
    input.file[i],
		output.dir=paste(dir.path,"\\PairsExploreTest2",sep=""),
		response.col=responseCol[i],
		pres=TRUE,
		absn=TRUE,
		bgd=TRUE))
		}

input.file<-"C:\\VisTrails\\mtalbert_20110504T132851\\readMaTests\\CanadaThistleNewFormat.csv"
input.file<-"C:\\VisTrails\\mtalbert_20110504T132851\\readMaTests\\CanadaThistleMissingDat.csv"
for (i in 5:25){ 
 try(Pairs.Explore(num.plots=i,
                min.cor=.5,
                input.file=input.file,
            		output.file=paste(dir.path,"\\PairsExploreTest2\\",i,"NumPlotsTest",".jpg",sep=""),
            		response.col=responseCol[1],
            		pres=TRUE,
            		absn=TRUE,
            		bgd=TRUE
                ))
            		}
### Apply Model Test

input.workspace=list(

for(i in 1:length(input.workspace){
EvaluateNewData(workspace=paste(output.dir,"modelWorkspace",sep="\\"),out.dir=output.dir,b.tif=TRUE,p.tif=TRUE,mess=TRUE,new.tifs="I:\\VisTrails\\WorkingFiles\\workspace\\_applyModel\\Error\\MergedDataset_10.csv",produce.metrics=TRUE)
}
### Data Splitting Tests
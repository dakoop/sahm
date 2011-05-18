 TestTrainSplit<-function(input.file,output.file,response.col="ResponseBinary",trainProp=.7,RatioPresAbs=NULL){

#Description:
#this code takes as input an mds file with the first line being the predictor or
#response name, the second line an indicator of predictors to include and the
#third line being paths where tif files can be found.   An output file and a
#response column must also be specified.  Given a training proportion, a new
#column is created indicating whether each observation should be assigned to the
#test or training split with the correct proportion.
#trainProp=#obs to be assigned to training split/total sample size
#his will be balanced with respect to the response in that the training
#proportion will be matched as close as possible for each level of the response.
#An optional parameter, RatioPresAbs, can be used to specify if there is a certain
#ratio of presence to absence points that should be used this ensures the given
#ratio for all data used in both the test and train split.  For categorical data,
#all responses greater than or equal to 1 will be used to meet this ratio.
#This option reduces the sample size as some data must be thrown away to meet
#the constraint of having the desired proportion.  Background points are ignored
#by this module (they are read in, written out, but not assigned to either the
#test or training split).  Output is written to a csv that can be used by the
#SAHM R modules.

#Written by Marian Talbert 3/23/2011
#Modified 5/10/2011 to handle count data



     if(trainProp<=0 | trainProp>1) stop("Train Proportion (trainProp) must be a number between 0 and 1 excluding 0")
    if(!is.null(RatioPresAbs)) {
    if(RatioPresAbs<=0) stop("The ratio of presence to absence (RatioPresAbs) must be a \ngreater than 0")}

   #Read input data and remove any columns to be excluded
          dat.in<-read.csv(input.file,header=FALSE,as.is=TRUE)
          dat<-as.data.frame(dat.in[4:dim(dat.in)[1],])
          names(dat)<-dat.in[1,]

        response<-dat[,match(tolower(response.col),tolower(names(dat)))]

          if(sum(as.numeric(response)==0)==0 && !is.null(RatioPresAbs)) stop("The ratio of presence to absence cannot be set with only presence data")
          
      #Ignoring background data that might be present in the mds

          bg.dat<-dat[response==-9999,]

          if(dim(bg.dat)[1]!=0){
            dat<-dat[-c(which(response==-9999,arr.ind=TRUE)),]
            dat.in<-dat.in[-c(which(response==-9999,arr.ind=TRUE)+3),]
            response<-response[-c(which(response==-9999,arr.ind=TRUE))]
            bg.dat$TrainSplit=""
            }

         temp<-if(!is.null(RatioPresAbs))(sum(response>=1)/sum(response==0)==RatioPresAbs)
         if(is.null(temp)) temp<-FALSE
       if(is.null(RatioPresAbs)| temp){
        #Randomly sample presesce absence or counts as close to the size of the training proportion as possible

          #iterate through each unique response and randomly assign the trainProp to be in the training split
          TrainSplit<-numeric()
          for(i in sort(as.numeric(unique(response)))){
           TrainSplit<-c(TrainSplit,sample(which(response==i,arr.ind=TRUE),size=round(sum(response==i)*trainProp)))
            }


        #Take everything not in the training set for the test set
          TestSplit=which(!(seq(1:length(response)))%in%TrainSplit,arr.ind=TRUE)

          dat$TrainSplit[seq(1:length(response))%in%TrainSplit]<-"train"
          dat$TrainSplit[seq(1:length(response))%in%TestSplit]<-"test"

         #inserting data must be done in 3 steps because dat.in isn't a proper dataframe in that
         #not all elements in a column are of the same type
          dat.in<-dat.in[c(1:3,rownames(dat)),] #removing rows that weren't selected for the test train split
          dat.in[4:(dim(dat.in)[1]),(dim(dat.in)[2]+1)]<-dat$TrainSplit
          dat.in[c(1,3),(dim(dat.in)[2])]<-c("Split","")
          dat.in[2,(dim(dat.in)[2])]<-1


          } else {  #now considering if there is a desired ratio of presence to absence points
                if(sum(response>=1)/sum(response==0)>=RatioPresAbs){
                     browser()
                      TrainSplit<-numeric()
                        for(i in sort(as.numeric(unique(response)))){
                        TrainSplit<-c(TrainSplit,sample(which(response==i,arr.ind=TRUE),size=round((RatioPresAbs)*sum(response==i)*trainProp)))
                        }

                      TrainSplit<-c(sample(which(response>=1,arr.ind=TRUE),size=round((RatioPresAbs)*sum(response==0)*trainProp)),
                      sample(which(response==0,arr.ind=TRUE),size=round(sum(response==0)*trainProp)))

                      #Take everything not in the training set for the test set
                      TestSplit=which(!(seq(1:length(response)))%in%TrainSplit,arr.ind=TRUE)

                      #now sample some points to remove so we have the correct proportion
                      for(i in sort(as.numeric(unique(response[response!=0]))))
                      temp<-sample(which(TestSplit%in%which(response==i,arr.ind=TRUE),arr.ind=TRUE),
                        size=round(sum(TestSplit%in%which(response==i,arr.ind=TRUE))-(1-trainProp)*sum(response==0)*(RatioPresAbs)))
                      TestSplit<-TestSplit[-c(temp)]

                     dat$TrainSplit[seq(1:length(response))%in%TrainSplit]<-"train"
                     dat$TrainSplit[seq(1:length(response))%in%TestSplit]<-"test"


               }

               if(sum(response>=1)/sum(response==0)<RatioPresAbs){
                  browser()
               #first ballance all responses greater than 1
               TrainSplit<-numeric()
                for(i in sort(as.numeric(unique(response[response!=0])))){
                  TrainSplit<-c(TrainSplit,sample(which(response==i,arr.ind=TRUE),size=round(sum(response==i)*trainProp)))
                  }
                  #now sampling the right number of absence points for the train split
                  TrainSplit<-c(TrainSplit,sample(which(response==0,arr.ind=TRUE),size=round(sum(response>=1)*(1/RatioPresAbs)*trainProp)))

                      #Take everything not in the training set for the test set
                      TestSplit=which(!(seq(1:length(response)))%in%TrainSplit,arr.ind=TRUE)

                      #now sample some points to remove so we have the correct proportion
                      temp<-sample(which(TestSplit%in%which(response==0,arr.ind=TRUE),arr.ind=TRUE),
                        size=round(sum(TestSplit%in%which(response==0,arr.ind=TRUE))-(1-trainProp)*sum(response>=1)*(1/RatioPresAbs)))
                      TestSplit<-TestSplit[-c(temp)]

                     dat$TrainSplit[seq(1:length(response))%in%TrainSplit]<-"train"
                     dat$TrainSplit[seq(1:length(response))%in%TestSplit]<-"test"

               }

               dat<-dat[c(TrainSplit,TestSplit),]
               
               dat.in<-dat.in[c(1:3,rownames(dat)),] #removing rows that weren't selected for the test train split
               dat.in[4:(dim(dat.in)[1]),(dim(dat.in)[2]+1)]<-dat$TrainSplit
               dat.in[c(1,3),(dim(dat.in)[2])]<-c("Split","")
               dat.in[2,(dim(dat.in)[2])]<-1


              }

              if(dim(bg.dat)[1]!=0) {
                names(bg.dat)<-names(dat.in)
                dat.in<-rbind(dat.in,bg.dat)}

              #write output files for R modules
             write.table(dat.in,file=output.file,row.names=FALSE,col.names=FALSE,sep=",",quote=FALSE)


    }


 #Reading in command line arguments
 Args <- commandArgs(T)
    print(Args)
    #assign default values
    
    responseCol <- "responseBinary"
    trainProp=.7
    RatioPresAbs=NULL
    #replace the defaults with passed values
    for (arg in Args) {
    	argSplit <- strsplit(arg, "=")
    	argSplit[[1]][1]
    	argSplit[[1]][2]
    	if(argSplit[[1]][1]=="p") trainProp <- argSplit[[1]][2]
    	if(argSplit[[1]][1]=="m") RatioPresAbs <- argSplit[[1]][2]
    	if(argSplit[[1]][1]=="o") output.file <- argSplit[[1]][2]
    	if(argSplit[[1]][1]=="i") infil <- argSplit[[1]][2]
    	if(argSplit[[1]][1]=="rc") responseCol <- argSplit[[1]][2]
    }

	#Run the Test training split with these parameters
	TestTrainSplit(input.file=infil,output.file=output.file,response.col=responseCol,
  trainProp=trainProp,RatioPresAbs=RatioPresAbs)

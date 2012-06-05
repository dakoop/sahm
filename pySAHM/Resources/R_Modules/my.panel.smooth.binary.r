my.panel.smooth<-function (x, y, col = par("col"), bg = NA, pch = par("pch"),
    cex = 1, col.smooth = "red", span = 2/3, iter = 3, weights=rep(1,times=length(y)),cex.mult,Ylab,...)
{
#This function fits a gam to show the relationship between a binary response and the specified predictor
#similar to a lowess smooth but appropraite for binary response.  Occasionally gam fails or doesn't converge
#this is indicated by the null deviance being less than the fit deviance.  When this occurs I instead fit a glm
#Weights have to be set here so that the relationship is clear unfortunately the intercept isn't correct hopefully
#this won't be needed once weights are accepted
#Written by Marian Talbert 5/22/2012

    o<-order(x)
    x<-x[o]
    y<-y[o]
    col<-col[o]
    bg<-bg[o]
      if(sum(y==0)/sum(y==1)>1.2) wgt<-c(sum(y==1)/sum(y==0),1)[factor(y,levels=c(0,1))]
      else wgt<-rep(1,times=length(y))
    options(warn=2)
    g<-try(gam(y~s(x,2),weights=wgt,family=binomial),silent=TRUE)
    options(warn=-1)
    if("try-error"%in%class(g) | try((1-g$dev/g$null.deviance)<0,silent=TRUE)){gam.failed=TRUE
        g<-glm(y~x+x^2,weights=wgt,family=binomial)
        y.fit<-predict(g,type="response")
    }  else {
        y.fit<-predict.gam(g,type="response")
        gam.failed=FALSE
    }
    points(x, y, pch = pch,bg=c("blue","red")[factor(y,levels=c(0,1))],col=c("blue4","red4")[factor(y,levels=c(0,1))],cex = cex*cex.mult)
        segments(x0=x[1:(length(x)-1)],y0=y.fit[1:(length(x)-1)],x1=x[2:length(x)],y1=y.fit[2:length(x)],col="red",cex=3*cex.mult,lwd=cex.mult)
  if(missing(Ylab)) title(ylab =paste("% dev exp ",round(100*(1-g$dev/g$null.deviance),digits=1),sep=""),...)
    return(gam.failed)
}

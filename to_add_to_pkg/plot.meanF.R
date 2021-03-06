#########################################################
#Boxplots Mean F (weighted by numbers and by biomass) over time 
#Ana Parma-Sept 2009
#plot.outliers  T/F whether to plot outliers or not
#a1 and a2: min and max age included in average 
##################################################################
plot.meanF <- function(data.objects,lev.file="MpowerLL3sel.lev",a1=2,a2=15,plot.outliers=T,...) 
{
  # data.objects is a list of the _lab.rep files from all grid cells
  # produced with Trevor's get.all.data.r
  # the lev.file has the scenarios of 2000 sampled grid cells

 #  require(sfsmisc)
   xx <- data.objects[[1]]
   years=min(xx$Fs[,2]):max(xx$Fs[,2])
   nyears = length(years)
   nobjects <- length(data.objects)
   allyears = xx$years[1]:xx$years[2]
  
   meanF2.15 = matrix(NA,nobjects,nyears)  
   weighted.meanF2.15 = matrix(NA,nobjects,nyears)  
    
    scenario = vector(length=nobjects)
   for (i in 1:nobjects)
   {
      xx <- data.objects[[i]]
      fishery = xx$Fs[,1]
      scenario[i] = xx$scenario_number
   # sum over fisheries to get total harvest rate by season
      H1 = xx$Fs[fishery ==3,4:33]+xx$Fs[fishery==4,4:33]+xx$Fs[fishery==5,4:33]+xx$Fs[fishery==6,4:33]
      H2 = xx$Fs[fishery ==1,4:33]+xx$Fs[fishery==2,4:33]
      Surv = (1-H1)*(1-H2)
      F = -log(Surv)
      id = allyears %in% years
     
      Bio = xx$Ns[id,-1]*xx$weights.age[id,-1]
      Bio = Bio[,a1:a2]
      NN = xx$Ns[id,-1]
      NN = NN[,a1:a2]
      F = F[,a1:a2]

      weighted.meanF2.15[i,] = rowSums(F*Bio)/rowSums(Bio) 
      meanF2.15[i,] = rowSums(F*NN)/rowSums(NN)
       
   }
   
   
    lev <- read.table(file=lev.file,colClasses="numeric",sep=" ")
    nlevs = nrow(lev)
    lev.scens <- vector(length=nobjects)
  for (i in 1:nlevs) 
  {
     lev.scens[i] <- as.numeric(paste(lev[i,1],lev[i,2],lev[i,3],lev[i,4],lev[i,5],lev[i,6],sep=""))
  }
  resamps <- match(lev.scens,scenario)

  par(mfrow=c(2,1),mar=c(3,3,1,0),oma=c(2,2,1,1))
  if (plot.outliers==T) 
  {
      outpch <- 1
  }
  else 
  {
      outpch <- NA_integer_
  }
  result= list("aveF2.15"= meanF2.15[resamps,],"weighted.aveF2.15"=weighted.meanF2.15[resamps,])
  boxplot(data.frame(result$weighted.aveF2.15),names=years,cex=0.4,col=3,las=1,yaxs="i",outpch=outpch,...)
  par(new=T, usr=c(0, 1, 0, 1))
  text(0.04,0.9,"weighted by biomass",cex=1.15,adj=0)
  boxplot(data.frame(result$aveF2.15),names=years,cex=0.4,col=3,las=1,yaxs="i",outpch=outpch,...)
  par(new=T, usr=c(0, 1, 0, 1))
  text(0.04,0.9,"weighted by numbers",cex=1.15,adj=0)

  mtext(side=2,line=0,"Average F (ages 2-15)",outer=T,cex=1.5)
  mtext(side=1,line=0,"Year",outer=T,cex=1.5)
  invisible(result)
}

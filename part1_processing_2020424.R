rm(list=ls())

#load necessary libraries
library(ggplot2)
library(ggpubr)
library(readr)
library(plotly)

setwd('C:/Users/wilso/Documents/Pubs/In prep/Wheelchair pub/output/current output')

#load data
agent.scenario1 <- read.csv(file='scenario1_20200424.csv',skip=6)
agent.scenario2 <- read.csv(file='scenario2_20200424.csv',skip=6)
agent.scenario3 <- read.csv(file='scenario3_20200424.csv',skip=6)
agent.scenario4 <- read.csv(file='scenario4_20200424.csv',skip=6)


#correcting a way concentrations were stored in NetLogo runs (starting conc stored as different variable than changing conc for rest of simulation)
agent.scenario1$mean.finalcontamcdiff..of.patients[agent.scenario1$X.step.==0]<-agent.scenario1$mean..contamCdiff..of.patients[agent.scenario1$X.step.==0]
agent.scenario1$mean.finalcontammrsa..of.patients[agent.scenario1$X.step.==0]<-agent.scenario1$mean..contamMRSA..of.patients[agent.scenario1$X.step.==0]

agent.scenario2$mean.finalcontamcdiff..of.patients[agent.scenario2$X.step.==0]<-agent.scenario2$mean..contamCdiff..of.patients[agent.scenario2$X.step.==0]
agent.scenario2$mean.finalcontammrsa..of.patients[agent.scenario2$X.step.==0]<-agent.scenario2$mean..contamMRSA..of.patients[agent.scenario2$X.step.==0]

agent.scenario3$mean.finalcontamcdiff..of.patients[agent.scenario3$X.step.==0]<-agent.scenario3$mean..contamCdiff..of.patients[agent.scenario3$X.step.==0]
agent.scenario3$mean.finalcontammrsa..of.patients[agent.scenario3$X.step.==0]<-agent.scenario3$mean..contamMRSA..of.patients[agent.scenario3$X.step.==0]

agent.scenario4$mean.finalcontamcdiff..of.patients[agent.scenario4$X.step.==0]<-agent.scenario4$mean..contamCdiff..of.patients[agent.scenario4$X.step.==0]
agent.scenario4$mean.finalcontammrsa..of.patients[agent.scenario4$X.step.==0]<-agent.scenario4$mean..contamMRSA..of.patients[agent.scenario4$X.step.==0]


#---------------------------HEATMAPS-----------------------------------------------------

#initialize matrices
ltc<-matrix(nrow=4,ncol=3)
opc<-matrix(nrow=4,ncol=3)
acute<-matrix(nrow=4,ncol=3)
rad<-matrix(nrow=4,ncol=3)
scs<-matrix(nrow=4,ncol=3)
dom<-matrix(nrow=4,ncol=3)
com<-matrix(nrow=4,ncol=3)

#three levels for number of wheelchair trips
levels<-c(10,25,50)

#retrieve information to inform heatmap
for (j in 1:3){
  
  step<-levels[j]
  
  for (i in 1:4){
    
    if (i==1){
      agent<-agent.scenario1
    }else if (i==2){
      agent<-agent.scenario2
    }else if (i==3){
      agent<-agent.scenario3
    }else{
      agent<-agent.scenario4
    }
    
    ltc[i,j]<-mean(agent$count.patches.with..zone....Long.Term.Care..and.contamMRSA3...0.[agent$X.step.==step & agent$efficacy==0])

    opc[i,j]<-mean(agent$count.patches.with..zone....Out.Patient.Clinics..and.contamMRSA3...0.[agent$X.step.==step & agent$efficacy==0])

    acute[i,j]<-mean(agent$count.patches.with..Zone....Acute..and.contamMRSA3...0.[agent$X.step.==step& agent$efficacy==0])

    rad[i,j]<-mean(agent$count.patches.with..zone....Radiology..and.contamMRSA3...0.[agent$X.step.==step& agent$efficacy==0])

    scs[i,j]<-mean(agent$count.patches.with..zone....Specialty.Care.Services..and.contamMRSA3...0.[agent$X.step.==step & agent$efficacy==0])

    dom[i,j]<-mean(agent$count.patches.with..zone....Domicilliary..and.contamMRSA3...0.[agent$X.step.==step& agent$efficacy==0])
    
    com[i,j]<-mean(agent$count.patches.with..zone....Common.Spaces..and.contamMRSA3...0.[agent$X.step.==step & agent$efficacy==0])
  }
}

#initialize list for several heatmaps
heatmaps<-list()

for (i in 1:4){
  
m<-matrix(nrow=7,ncol=3)
m[1,]<-c(ltc[i,1],ltc[i,2],ltc[i,3])
m[2,]<-c(opc[i,1],opc[i,2],opc[i,3])
m[3,]<-c(acute[i,1],acute[i,2],acute[i,3])
m[4,]<-c(rad[i,1],rad[i,2],rad[i,3])
m[5,]<-c(scs[i,1],scs[i,2],scs[i,3])
m[6,]<-c(dom[i,1],dom[i,2],dom[i,3])
m[7,]<-c(com[i,1],com[i,2],com[i,3])

heatmaps[[i]]<-plot_ly(x=c("10 trips","25 trips","50 trips"),y=c("Long Term Care","Out Patient Clinics","Acute","Radiology","Specialty Care Services","Domicilliary","Common Spaces"),z=m,type="heatmap")

}

#View heatmaps
heatmaps[[1]] #scenario 1
heatmaps[[2]] #scenario 2
heatmaps[[3]] #scenario 3
heatmaps[[4]] #scenario 4

#-------------------- Calculating Means and SDs for ribbon plots -----------------------------------------------------------

#initialize lists
eff.MRSA.mean<-list()
eff.MRSA.sd<-list()

eff.cdiff.mean<-list()
eff.cdiff.sd<-list()

#setting efficacy levels for loop
efficacy<-c(0,50,70,90)


for (k in 1:4){
  efftemp<-efficacy[k]
    
  eff.MRSA.mean.mat<-matrix(nrow=4,ncol=50)
  eff.MRSA.sd.mat<-matrix(nrow=4,ncol=50)
    
  eff.cdiff.mean.mat<-matrix(nrow=4,ncol=50)
  eff.cdiff.sd.mat<-matrix(nrow=4,ncol=50)

    
  for (i in 1:50){
  
   for (j in 1:4){
      
        if (j==1){
         agent<-agent.scenario1
        }else if (j==2){
          agent<-agent.scenario2
        }else if (j==3){
          agent<-agent.scenario3
        }else{
          agent<-agent.scenario4
        }
    
        eff.MRSA.mean.mat[j,i]<-mean(agent$mean.finalcontammrsa..of.patients[agent$X.step.==i & agent$efficacy==efftemp])
        eff.MRSA.sd.mat[j,i]<-sd(agent$mean.finalcontammrsa..of.patients[agent$X.step.==i & agent$efficacy==efftemp])
       
        eff.cdiff.mean.mat[j,i]<-mean(agent$mean.finalcontamcdiff..of.patients[agent$X.step.==i & agent$efficacy==efftemp])
        eff.cdiff.sd.mat[j,i]<-sd(agent$mean.finalcontamcdiff..of.patients[agent$X.step.==i & agent$efficacy==efftemp])
    }
  }
  eff.MRSA.mean[[k]]<-eff.MRSA.mean.mat
  eff.MRSA.sd[[k]]<-eff.MRSA.sd.mat
  
  eff.cdiff.mean[[k]]<-eff.cdiff.mean.mat
  eff.cdiff.sd[[k]]<-eff.cdiff.sd.mat
}
  
mean<-c(
  eff.cdiff.mean[[1]][1,],eff.cdiff.mean[[2]][1,],eff.cdiff.mean[[3]][1,],eff.cdiff.mean[[4]][1,],
  eff.cdiff.mean[[1]][2,],eff.cdiff.mean[[2]][2,],eff.cdiff.mean[[3]][2,],eff.cdiff.mean[[4]][2,],
  eff.cdiff.mean[[1]][3,],eff.cdiff.mean[[2]][3,],eff.cdiff.mean[[3]][3,],eff.cdiff.mean[[4]][3,],
  eff.cdiff.mean[[1]][4,],eff.cdiff.mean[[2]][4,],eff.cdiff.mean[[3]][4,],eff.cdiff.mean[[4]][4,],
  
  eff.MRSA.mean[[1]][1,],eff.MRSA.mean[[2]][1,],eff.MRSA.mean[[3]][1,],eff.MRSA.mean[[4]][1,],
  eff.MRSA.mean[[1]][2,],eff.MRSA.mean[[2]][2,],eff.MRSA.mean[[3]][2,],eff.MRSA.mean[[4]][2,],
  eff.MRSA.mean[[1]][3,],eff.MRSA.mean[[2]][3,],eff.MRSA.mean[[3]][3,],eff.MRSA.mean[[4]][3,],
  eff.MRSA.mean[[1]][4,],eff.MRSA.mean[[2]][4,],eff.MRSA.mean[[3]][4,],eff.MRSA.mean[[4]][4,])

sd<-c(
  eff.cdiff.sd[[1]][1,],eff.cdiff.sd[[2]][1,],eff.cdiff.sd[[3]][1,],eff.cdiff.sd[[4]][1,],
  eff.cdiff.sd[[1]][2,],eff.cdiff.sd[[2]][2,],eff.cdiff.sd[[3]][2,],eff.cdiff.sd[[4]][2,],
  eff.cdiff.sd[[1]][3,],eff.cdiff.sd[[2]][3,],eff.cdiff.sd[[3]][3,],eff.cdiff.sd[[4]][3,],
  eff.cdiff.sd[[1]][4,],eff.cdiff.sd[[2]][4,],eff.cdiff.sd[[3]][4,],eff.cdiff.sd[[4]][4,],
  
  eff.MRSA.sd[[1]][1,],eff.MRSA.sd[[2]][1,],eff.MRSA.sd[[3]][1,],eff.MRSA.sd[[4]][1,],
  eff.MRSA.sd[[1]][2,],eff.MRSA.sd[[2]][2,],eff.MRSA.sd[[3]][2,],eff.MRSA.sd[[4]][2,],
  eff.MRSA.sd[[1]][3,],eff.MRSA.sd[[2]][3,],eff.MRSA.sd[[3]][3,],eff.MRSA.sd[[4]][3,],
  eff.MRSA.sd[[1]][4,],eff.MRSA.sd[[2]][4,],eff.MRSA.sd[[3]][4,],eff.MRSA.sd[[4]][4,])

#create data.frame for plotting
organism<-c(rep("C. difficile",800),rep("MRSA",800))
efficacy<-rep(c(rep("Baseline",50),rep("50%",50),rep("70%",50),rep("90%",50)),8)
wheelchairtrips<-c(rep(c(1:50),32))
modeltype=c(rep(c(rep("Scenario 1",200),rep("Scenario 2",200),rep("Scenario 3",200),rep("Scenario 4",200)),2))
ribbondata<-data.frame(mean=mean,sd=sd,organism=organism,efficacy=efficacy,wheelchairtrips=wheelchairtrips,modeltype=modeltype)

ribbondata.small<-ribbondata[ribbondata$wheelchairtrips<=4,]

#plotting

windows()
#---------------------------------------- FIGURE 2 -----------------------------------------------------------------------------
# Scenario 1, first 9 trips, MRSA
A<-ggplot(data=ribbondata[ribbondata$wheelchairtrips<10  & ribbondata$organism=="MRSA" & ribbondata$modeltype=="Scenario 1",])+
  geom_ribbon(aes(x=wheelchairtrips,ymin=mean-(1.960*sd/sqrt(1000)),ymax=mean+(1.960*sd/sqrt(1000)),group=efficacy),alpha=0.5)+
  geom_line(aes(x=wheelchairtrips,y=mean,group=efficacy,colour=efficacy),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('Contamination on Hands (CFU/cm '^2*')'))+
  xlab("Number of Wheelchair Trips")+ggtitle("Scenario 1")+
  theme(plot.title=element_text(hjust=0.5))+
  scale_colour_discrete(name="Efficacy")+theme_pubr()

#Scenario 2, first 9 trips, MRSA
B<-ggplot(data=ribbondata[ribbondata$wheelchairtrips<10 & ribbondata$modeltype=="Scenario 2" & ribbondata$organism=="MRSA",])+
  geom_ribbon(aes(x=wheelchairtrips,ymin=mean-(1.960*sd/sqrt(1000)),ymax=mean+(1.960*sd/sqrt(1000)),group=efficacy),alpha=0.5)+
  geom_line(aes(x=wheelchairtrips,y=mean,group=efficacy,colour=efficacy),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('Contamination on Patient Hands (CFU/cm '^2*')'))+
  xlab("Number of Wheelchair Trips")+ggtitle("Scenario 2")+
  theme(plot.title=element_text(hjust=0.5))+
  scale_colour_discrete(name="Efficacy")+theme_pubr()

#Scenario 3, first 9 trips, MRSA
C<-ggplot(data=ribbondata[ribbondata$wheelchairtrips<10 & ribbondata$modeltype=="Scenario 3" & ribbondata$organism=="MRSA",])+
  geom_ribbon(aes(x=wheelchairtrips,ymin=mean-(1.960*sd/sqrt(1000)),ymax=mean+(1.960*sd/sqrt(1000)),group=efficacy),alpha=0.5)+
  geom_line(aes(x=wheelchairtrips,y=mean,group=efficacy,colour=efficacy),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('Contamination on Hands (CFU/cm '^2*')'))+
  xlab("Number of Wheelchair Trips")+ggtitle("Scenario 3")+
  theme(plot.title=element_text(hjust=0.5))+
  scale_colour_discrete(name="Efficacy")+theme_pubr()

#Scenario 4, first 9 trips, MRSA
D<-ggplot(data=ribbondata[ribbondata$wheelchairtrips<10 & ribbondata$modeltype=="Scenario 4" & ribbondata$organism=="MRSA",])+
  geom_ribbon(aes(x=wheelchairtrips,ymin=mean-(1.960*sd/sqrt(1000)),ymax=mean+(1.960*sd/sqrt(1000)),group=efficacy),alpha=0.5)+
  geom_line(aes(x=wheelchairtrips,y=mean,group=efficacy,colour=efficacy),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('Contamination on Hands (CFU/cm '^2*')'))+
  xlab("Number of Wheelchair Trips")+ggtitle("Scenario 4")+
  theme(plot.title=element_text(hjust=0.5))+
  scale_colour_discrete(name="Efficacy")+theme_pubr()

#Plot all scenarios together
library(ggpubr)
windows()
plot.1<-ggarrange(A,B,C,D,nrow=2,ncol=2,common.legend = TRUE)
plot.1<-annotate_figure(plot.1,top=text_grob("A",face="bold",size=14))

plot.2<-ggplot(data=ribbondata[ribbondata$wheelchairtrips<20 & ribbondata$organism=="MRSA" ,])+
  geom_line(aes(x=wheelchairtrips,y=mean,group=interaction(modeltype,efficacy),linetype=efficacy,colour=modeltype),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('Contamination on Hands (CFU/cm '^2*')'))+
  xlab("Number of Wheelchair Trips")+
  scale_colour_discrete(name="Scenario")+
  scale_linetype_discrete(name="Efficacy")+theme_pubr()+theme(legend.position="right")
plot.2<-annotate_figure(plot.2,top=text_grob("B",face="bold",size=14))

ggarrange(plot.1,plot.2)

#-------------------------------- summary statistics ---------------------------------------------------
simpatient<-c(2,3,4,10,25,50)
cleaning<-c(0,50,70,90)

scenario.1.mrsa.mean<-matrix(nrow=6,ncol=4)
scenario.1.mrsa.sd<-matrix(nrow=6,ncol=4)
scenario.1.cdiff.mean<-matrix(nrow=6,ncol=4)
scenario.1.cdiff.sd<-matrix(nrow=6,ncol=4)

scenario.2.mrsa.mean<-matrix(nrow=6,ncol=4)
scenario.2.mrsa.sd<-matrix(nrow=6,ncol=4)
scenario.2.cdiff.mean<-matrix(nrow=6,ncol=4)
scenario.2.cdiff.sd<-matrix(nrow=6,ncol=4)

scenario.3.mrsa.mean<-matrix(nrow=6,ncol=4)
scenario.3.mrsa.sd<-matrix(nrow=6,ncol=4)
scenario.3.cdiff.mean<-matrix(nrow=6,ncol=4)
scenario.3.cdiff.sd<-matrix(nrow=6,ncol=4)

scenario.4.mrsa.mean<-matrix(nrow=6,ncol=4)
scenario.4.mrsa.sd<-matrix(nrow=6,ncol=4)
scenario.4.cdiff.mean<-matrix(nrow=6,ncol=4)
scenario.4.cdiff.sd<-matrix(nrow=6,ncol=4)

for (i in 1:6){
  for (j in 1:4){
    #scenario 1
    scenario.1.mrsa.mean[i,j]<-mean(agent.scenario1$mean.finalcontammrsa..of.patients[agent.scenario1$X.step.==simpatient[i] & agent.scenario1$efficacy==cleaning[j]])
    scenario.1.mrsa.sd[i,j]<-sd(agent.scenario1$mean.finalcontammrsa..of.patients[agent.scenario1$X.step.==simpatient[i] & agent.scenario1$efficacy==cleaning[j]])
    scenario.1.cdiff.mean[i,j]<-mean(agent.scenario1$mean.finalcontamcdiff..of.patients[agent.scenario1$X.step.==simpatient[i] & agent.scenario1$efficacy==cleaning[j]])
    scenario.1.cdiff.sd[i,j]<-sd(agent.scenario1$mean.finalcontamcdiff..of.patients[agent.scenario1$X.step.==simpatient[i] & agent.scenario1$efficacy==cleaning[j]])
    
    #scenario 2
    scenario.2.mrsa.mean[i,j]<-mean(agent.scenario2$mean.finalcontammrsa..of.patients[agent.scenario2$X.step.==simpatient[i] & agent.scenario2$efficacy==cleaning[j]])
    scenario.2.mrsa.sd[i,j]<-sd(agent.scenario2$mean.finalcontammrsa..of.patients[agent.scenario2$X.step.==simpatient[i] & agent.scenario2$efficacy==cleaning[j]])
    scenario.2.cdiff.mean[i,j]<-mean(agent.scenario2$mean.finalcontamcdiff..of.patients[agent.scenario2$X.step.==simpatient[i] & agent.scenario2$efficacy==cleaning[j]])
    scenario.2.cdiff.sd[i,j]<-sd(agent.scenario2$mean.finalcontamcdiff..of.patients[agent.scenario2$X.step.==simpatient[i] & agent.scenario2$efficacy==cleaning[j]])
    
    
    #scenario 3
    scenario.3.mrsa.mean[i,j]<-mean(agent.scenario3$mean.finalcontammrsa..of.patients[agent.scenario3$X.step.==simpatient[i] & agent.scenario3$efficacy==cleaning[j]])
    scenario.3.mrsa.sd[i,j]<-sd(agent.scenario3$mean.finalcontammrsa..of.patients[agent.scenario3$X.step.==simpatient[i] & agent.scenario3$efficacy==cleaning[j]])
    scenario.3.cdiff.mean[i,j]<-mean(agent.scenario3$mean.finalcontamcdiff..of.patients[agent.scenario3$X.step.==simpatient[i] & agent.scenario3$efficacy==cleaning[j]])
    scenario.3.cdiff.sd[i,j]<-sd(agent.scenario3$mean.finalcontamcdiff..of.patients[agent.scenario3$X.step.==simpatient[i] & agent.scenario3$efficacy==cleaning[j]])
    
    
    #scenario 4
    scenario.4.mrsa.mean[i,j]<-mean(agent.scenario4$mean.finalcontammrsa..of.patients[agent.scenario4$X.step.==simpatient[i] & agent.scenario4$efficacy==cleaning[j]])
    scenario.4.mrsa.sd[i,j]<-sd(agent.scenario4$mean.finalcontammrsa..of.patients[agent.scenario4$X.step.==simpatient[i] & agent.scenario4$efficacy==cleaning[j]])
    scenario.4.cdiff.mean[i,j]<-mean(agent.scenario4$mean.finalcontamcdiff..of.patients[agent.scenario4$X.step.==simpatient[i] & agent.scenario4$efficacy==cleaning[j]])
    scenario.4.cdiff.sd[i,j]<-sd(agent.scenario4$mean.finalcontamcdiff..of.patients[agent.scenario4$X.step.==simpatient[i] & agent.scenario4$efficacy==cleaning[j]])
  }
}

#----------------------------- Sensitivity Analysis ----------------------------------------------------------------


#sensitivity analysis models

agent.baseline <- read.csv(file="scenario1_20200424.csv",skip=6)

agent.sensitivity <- read.csv(file="sensitivity2_20200425.csv",skip=6)

agent.sensitivity.part2 <- read.csv(file="sensitivity1_20200424.csv",skip=6)

agent.2.baseline<-agent.baseline
agent.2.sensitivity<-agent.sensitivity
agent.2.sensitivity.part2<-agent.sensitivity.part2

agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==0]<-agent.2.baseline$mean..contamCdiff..of.patients[agent.2.baseline$X.step.==0]
agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==0]<-agent.2.baseline$mean..contamMRSA..of.patients[agent.2.baseline$X.step.==0]

agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==0]<-agent.2.sensitivity$mean..contamCdiff..of.patients[agent.2.sensitivity$X.step.==0]
agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==0]<-agent.2.sensitivity$mean..contamMRSA..of.patients[agent.2.sensitivity$X.step.==0]

agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==0]<-agent.2.sensitivity.part2$mean..contamCdiff..of.patients[agent.2.sensitivity.part2$X.step.==0]
agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==0]<-agent.2.sensitivity.part2$mean..contamMRSA..of.patients[agent.2.sensitivity.part2$X.step.==0]

# ----------------- initialize vectors -------------------------------------------

length<-50

#baseline
eff.0.MRSA<-rep(0,length)
sd.eff.0.MRSA<-rep(0,length)
eff.50.MRSA<-rep(0,length)
sd.eff.50.MRSA<-rep(0,length)
eff.70.MRSA<-rep(0,length)
sd.eff.70.MRSA<-rep(0,length)
eff.90.MRSA<-rep(0,length)
sd.eff.90.MRSA<-rep(0,length)
eff.0.cdiff<-rep(0,length)
sd.eff.0.cdiff<-rep(0,length)
eff.50.cdiff<-rep(0,length)
sd.eff.50.cdiff<-rep(0,length)
eff.70.cdiff<-rep(0,length)
sd.eff.70.cdiff<-rep(0,length)
eff.90.cdiff<-rep(0,length)
sd.eff.90.cdiff<-rep(0,length)

#sensitivity
eff.0.MRSA.sen<-rep(0,length)
sd.eff.0.MRSA.sen<-rep(0,length)
eff.50.MRSA.sen<-rep(0,length)
sd.eff.50.MRSA.sen<-rep(0,length)
eff.70.MRSA.sen<-rep(0,length)
sd.eff.70.MRSA.sen<-rep(0,length)
eff.90.MRSA.sen<-rep(0,length)
sd.eff.90.MRSA.sen<-rep(0,length)
eff.0.cdiff.sen<-rep(0,length)
sd.eff.0.cdiff.sen<-rep(0,length)
eff.50.cdiff.sen<-rep(0,length)
sd.eff.50.cdiff.sen<-rep(0,length)
eff.70.cdiff.sen<-rep(0,length)
sd.eff.70.cdiff.sen<-rep(0,length)
eff.90.cdiff.sen<-rep(0,length)
sd.eff.90.cdiff.sen<-rep(0,length)


eff.0.MRSA.sen.1<-rep(0,length)
sd.eff.0.MRSA.sen.1<-rep(0,length)
eff.50.MRSA.sen.1<-rep(0,length)
sd.eff.50.MRSA.sen.1<-rep(0,length)
eff.70.MRSA.sen.1<-rep(0,length)
sd.eff.70.MRSA.sen.1<-rep(0,length)
eff.90.MRSA.sen.1<-rep(0,length)
sd.eff.90.MRSA.sen.1<-rep(0,length)
eff.0.cdiff.sen.1<-rep(0,length)
sd.eff.0.cdiff.sen.1<-rep(0,length)
eff.50.cdiff.sen.1<-rep(0,length)
sd.eff.50.cdiff.sen.1<-rep(0,length)
eff.70.cdiff.sen.1<-rep(0,length)
sd.eff.70.cdiff.sen.1<-rep(0,length)
eff.90.cdiff.sen.1<-rep(0,length)
sd.eff.90.cdiff.sen.1<-rep(0,length)

eff.0.MRSA.sen.10<-rep(0,length)
sd.eff.0.MRSA.sen.10<-rep(0,length)
eff.50.MRSA.sen.10<-rep(0,length)
sd.eff.50.MRSA.sen.10<-rep(0,length)
eff.70.MRSA.sen.10<-rep(0,length)
sd.eff.70.MRSA.sen.10<-rep(0,length)
eff.90.MRSA.sen.10<-rep(0,length)
sd.eff.90.MRSA.sen.10<-rep(0,length)
eff.0.cdiff.sen.10<-rep(0,length)
sd.eff.0.cdiff.sen.10<-rep(0,length)
eff.50.cdiff.sen.10<-rep(0,length)
sd.eff.50.cdiff.sen.10<-rep(0,length)
eff.70.cdiff.sen.10<-rep(0,length)
sd.eff.70.cdiff.sen.10<-rep(0,length)
eff.90.cdiff.sen.10<-rep(0,length)
sd.eff.90.cdiff.sen.10<-rep(0,length)

eff.0.MRSA.sen.100<-rep(0,length)
sd.eff.0.MRSA.sen.100<-rep(0,length)
eff.50.MRSA.sen.100<-rep(0,length)
sd.eff.50.MRSA.sen.100<-rep(0,length)
eff.70.MRSA.sen.100<-rep(0,length)
sd.eff.70.MRSA.sen.100<-rep(0,length)
eff.90.MRSA.sen.100<-rep(0,length)
sd.eff.90.MRSA.sen.100<-rep(0,length)
eff.0.cdiff.sen.100<-rep(0,length)
sd.eff.0.cdiff.sen.100<-rep(0,length)
eff.50.cdiff.sen.100<-rep(0,length)
sd.eff.50.cdiff.sen.100<-rep(0,length)
eff.70.cdiff.sen.100<-rep(0,length)
sd.eff.70.cdiff.sen.100<-rep(0,length)
eff.90.cdiff.sen.100<-rep(0,length)
sd.eff.90.cdiff.sen.100<-rep(0,length)

#retrieve summary statistics for ribbon plots

for (i in 1:50){
  
  #-------------------- mrsa
  #baseline
  eff.0.MRSA[i]<-mean(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==0])
  sd.eff.0.MRSA[i]<-sd(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==0])
  
  eff.50.MRSA[i]<-mean(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==50])
  sd.eff.50.MRSA[i]<-sd(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==50])
  
  eff.70.MRSA[i]<-mean(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==70])
  sd.eff.70.MRSA[i]<-sd(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==70])
  
  eff.90.MRSA[i]<-mean(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==90])
  sd.eff.90.MRSA[i]<-sd(agent.2.baseline$mean.finalcontammrsa..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==90])
  
  #sensitivity model 1
  eff.0.MRSA.sen[i]<-mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==0])
  sd.eff.0.MRSA.sen[i]<-sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==0])
  
  eff.50.MRSA.sen[i]<-mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==50])
  sd.eff.50.MRSA.sen[i]<-sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==50])
  
  eff.70.MRSA.sen[i]<-mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==70])
  sd.eff.70.MRSA.sen[i]<-sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==70])
  
  eff.90.MRSA.sen[i]<-mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==90])
  sd.eff.90.MRSA.sen[i]<-sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==90])
  
  
  #sensitivity model 2
  eff.0.MRSA.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.0.MRSA.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.50.MRSA.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.50.MRSA.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.70.MRSA.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.70.MRSA.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.90.MRSA.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.90.MRSA.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==1])
  
  #sensitivity model 3
  eff.0.MRSA.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.0.MRSA.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.50.MRSA.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.50.MRSA.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.70.MRSA.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.70.MRSA.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.90.MRSA.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.90.MRSA.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==10])
  
  #sensitivity model 4
  eff.0.MRSA.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.0.MRSA.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.50.MRSA.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.50.MRSA.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.70.MRSA.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.70.MRSA.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.90.MRSA.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.90.MRSA.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==100])
  
  
  #----------------------- c diff 
  
  eff.0.cdiff[i]<-mean(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==0])
  sd.eff.0.cdiff[i]<-sd(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==0])
  
  eff.50.cdiff[i]<-mean(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==50])
  sd.eff.50.cdiff[i]<-sd(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==50])
  
  eff.70.cdiff[i]<-mean(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==70])
  sd.eff.70.cdiff[i]<-sd(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==70])
  
  eff.90.cdiff[i]<-mean(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==90])
  sd.eff.90.cdiff[i]<-sd(agent.2.baseline$mean.finalcontamcdiff..of.patients[agent.2.baseline$X.step.==i & agent.2.baseline$efficacy==90])
  
  #sensitivity model 1
  eff.0.cdiff.sen[i]<-mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==0])
  sd.eff.0.cdiff.sen[i]<-sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==0])
  
  eff.50.cdiff.sen[i]<-mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==50])
  sd.eff.50.cdiff.sen[i]<-sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==50])
  
  eff.70.cdiff.sen[i]<-mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==70])
  sd.eff.70.cdiff.sen[i]<-sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==70])
  
  eff.90.cdiff.sen[i]<-mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==90])
  sd.eff.90.cdiff.sen[i]<-sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$X.step.==i & agent.2.sensitivity$efficacy==90])
  
  #sensitivity model 2
  eff.0.cdiff.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.0.cdiff.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.50.cdiff.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.50.cdiff.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.70.cdiff.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.70.cdiff.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==1])
  
  eff.90.cdiff.sen.1[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==1])
  sd.eff.90.cdiff.sen.1[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==1])
  
  #sensitivity model 3
  eff.0.cdiff.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.0.cdiff.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.50.cdiff.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.50.cdiff.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.70.cdiff.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.70.cdiff.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10])
  
  eff.90.cdiff.sen.10[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==10])
  sd.eff.90.cdiff.sen.10[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==10])
  
  #sensitivity model 4
  eff.0.cdiff.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.0.cdiff.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.50.cdiff.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.50.cdiff.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==50 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.70.cdiff.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.70.cdiff.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100])
  
  eff.90.cdiff.sen.100[i]<-mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==100])
  sd.eff.90.cdiff.sen.100[i]<-sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$X.step.==i & agent.2.sensitivity.part2$efficacy==90 & agent.2.sensitivity.part2$contamconc==100])
}


mean<-c(eff.0.MRSA,eff.50.MRSA,eff.70.MRSA,eff.90.MRSA,eff.0.cdiff,eff.50.cdiff,eff.70.cdiff,eff.90.cdiff,
        eff.0.MRSA.sen,eff.50.MRSA.sen,eff.70.MRSA.sen,eff.90.MRSA.sen,eff.0.cdiff.sen,eff.50.cdiff.sen,eff.70.cdiff.sen,eff.90.cdiff.sen,
        eff.0.MRSA.sen.1,eff.50.MRSA.sen.1,eff.70.MRSA.sen.1,eff.90.MRSA.sen.1,eff.0.cdiff.sen.1,eff.50.cdiff.sen.1,eff.70.cdiff.sen.1,eff.90.cdiff.sen.1,
        eff.0.MRSA.sen.10,eff.50.MRSA.sen.10,eff.70.MRSA.sen.10,eff.90.MRSA.sen.10,eff.0.cdiff.sen.10,eff.50.cdiff.sen.10,eff.70.cdiff.sen.10,eff.90.cdiff.sen.10,
        eff.0.MRSA.sen.100,eff.50.MRSA.sen.100,eff.70.MRSA.sen.100,eff.90.MRSA.sen.100,eff.0.cdiff.sen.100,eff.50.cdiff.sen.100,eff.70.cdiff.sen.100,eff.90.cdiff.sen.100)

sd<-c(sd.eff.0.MRSA,sd.eff.50.MRSA,sd.eff.70.MRSA,sd.eff.90.MRSA,sd.eff.0.cdiff,sd.eff.50.cdiff,sd.eff.70.cdiff,sd.eff.90.cdiff,
      sd.eff.0.MRSA.sen,sd.eff.50.MRSA.sen,sd.eff.70.MRSA.sen,sd.eff.90.MRSA.sen,sd.eff.0.cdiff.sen,sd.eff.50.cdiff.sen,sd.eff.70.cdiff.sen,sd.eff.90.cdiff.sen,
      sd.eff.0.MRSA.sen.1,sd.eff.50.MRSA.sen.1,sd.eff.70.MRSA.sen.1,sd.eff.90.MRSA.sen.1,sd.eff.0.cdiff.sen.1,sd.eff.50.cdiff.sen.1,sd.eff.70.cdiff.sen.1,sd.eff.90.cdiff.sen.1,
      sd.eff.0.MRSA.sen.10,sd.eff.50.MRSA.sen.10,sd.eff.70.MRSA.sen.10,sd.eff.90.MRSA.sen.10,sd.eff.0.cdiff.sen.10,sd.eff.50.cdiff.sen.10,sd.eff.70.cdiff.sen.10,sd.eff.90.cdiff.sen.10,
      sd.eff.0.MRSA.sen.100,sd.eff.50.MRSA.sen.100,sd.eff.70.MRSA.sen.100,sd.eff.90.MRSA.sen.100,sd.eff.0.cdiff.sen.100,sd.eff.50.cdiff.sen.100,sd.eff.70.cdiff.sen.100,sd.eff.90.cdiff.sen.100)

organism<-rep(c(rep('MRSA',200),rep("italic('C. difficile')",200)),5)
efficacy<-rep(c(rep(c(rep("Baseline",50),rep("50%",50),rep("70%",50),rep("90%",50)),2)),5)
wheelchairtrips<-rep(c(rep(c(1:50),8)),5)
modeltype=c(rep("Scenario 1 Primary Model",400),rep("Sensitivity Model 1",400),rep("Sensitivity Model 2",400),rep("Sensitivity Model 3",400),rep("Sensitivity Model 4",400))
ribbondata<-data.frame(mean=mean,sd=sd,organism=organism,efficacy=efficacy,wheelchairtrips=wheelchairtrips,modeltype=modeltype)

#-------------------------------Figure 3------------------------------------------------------------------- 

windows()
A<-ggplot(data=ribbondata[(ribbondata$modeltype=="Sensitivity Model 1" | ribbondata$modeltype=="Scenario 1 Primary Model") & ribbondata$wheelchairtrips<9 ,])+
  geom_line(aes(x=wheelchairtrips,y=mean,group=interaction(organism,efficacy),linetype=efficacy,colour=organism),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote(italic('  C. difficile')~ 'or MRSA Contamination on Patient Hands (CFU/cm '^2~')'))+
  scale_linetype_discrete(name="Efficacy")+
  scale_colour_discrete(name="Organism",labels=c(bquote(italic('C. difficile')),'MRSA'))+
  xlab("Number of Wheelchair Trips")+facet_wrap(~modeltype)+theme_pubr()+ggtitle("A")+theme(legend.position="right")

ribbondata.small<-ribbondata[ribbondata$wheelchairtrips<9 & ribbondata$modeltype!="Sensitivity Model 1",]
B<-ggplot(data=ribbondata.small)+
  #geom_ribbon(aes(x=wheelchairtrips,ymin=mean-(1.96*sd/sqrt(1000)),ymax=mean+(1.96*sd/sqrt(1000)),group=interaction(efficacy,modeltype)),alpha=0.7)+
  geom_line(aes(x=wheelchairtrips,y=mean,group=interaction(modeltype,efficacy),linetype=efficacy,colour=modeltype),size=1)+
  scale_y_continuous(trans="log10")+
  ylab(bquote('CFU or spore/cm'^2))+
  scale_linetype_discrete(name="Efficacy")+
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8))+theme(plot.title=element_text(hjust=0.5))+theme(legend.position="right")+
  xlab("Number of Wheelchair Trips")+facet_wrap(~organism ,labeller=label_parsed)+
  scale_colour_discrete(name="Model Type")+theme_pubr()+ggtitle("B")+theme(legend.position="right")

windows()
ggarrange(A,B,common.legend=FALSE)

#--------------------- SUMMARY STATISTICS FOR TABLE ----------------------------------------------------------------------

#SENSITIVITY MODEL 1

#patient 2 - mrsa

mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==2])
sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==2])

mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==2])
sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==2])

#patient 50 - mrsa

mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==50])
sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==50])

mean(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==50])
sd(agent.2.sensitivity$mean.finalcontammrsa..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==50])


#patient 2 - c diff
mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==2])
sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==2])

mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==2])
sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==2])

#patient 50 - cdiff

mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==50])
sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==0 & agent.2.sensitivity$X.step.==50])

mean(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==50])
sd(agent.2.sensitivity$mean.finalcontamcdiff..of.patients[agent.2.sensitivity$efficacy==70 & agent.2.sensitivity$X.step.==50])


#SENSITIVITY MODEL 2

#sensitivity model 2 - patient 2 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 2 - patient 50 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])


#sensitivity model 2 - patient 2 - c diff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 2 - patient 50 - cdiff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70  & agent.2.sensitivity.part2$contamconc==1 & agent.2.sensitivity.part2$X.step.==50])


#SENSITIVITY MODEL 3 


#sensitivity model 3 - patient 2 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 3 - patient 50 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])


#sensitivity model 3 - patient 2 - cdiff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 3 - patient 50 - cdiff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==10 & agent.2.sensitivity.part2$X.step.==50])


#SENSITIVITY MODEL 4


#sensitivity model 4 - patient 2 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 4 - patient 50 - mrsa
mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontammrsa..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])


#sensitivity model 4 - patient 2 - cdiff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==2])

#sensitivity model 4 - patient 50 - cdiff
mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==0 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])

mean(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])
sd(agent.2.sensitivity.part2$mean.finalcontamcdiff..of.patients[agent.2.sensitivity.part2$efficacy==70 & agent.2.sensitivity.part2$contamconc==100 & agent.2.sensitivity.part2$X.step.==50])



#--------------------- SUPPLEMENTAL TABLE PIECE-----------------------------------------------------------------------------

sum.table<-function(patient){
  
  summariesmrsa<-list()
  summariescdiff<-list()
  
  mat.sum.mrsa<-matrix(nrow=2,ncol=4)
  mat.sum.cdiff<-matrix(nrow=2,ncol=4)
  colnames(mat.sum.mrsa)<-c("0","50","70","90")
  rownames(mat.sum.mrsa)<-c("mean","sd")
  colnames(mat.sum.cdiff)<-c("0","50","70","90")
  rownames(mat.sum.cdiff)<-c("mean","sd")
  
  #patient<-c(2,3,4,10,25,50)
  efficacy<-c(0,50,70,90)
  
  for (i in 1:length(patient)){
    for (j in 1:length(efficacy)){
      mat.sum.mrsa[1,j]<-mean(agent$mean.finalcontammrsa..of.patients[agent$X.step.==patient[i] &  agent$efficacy==efficacy[j]])
      mat.sum.mrsa[2,j]<-sd(agent$mean.finalcontammrsa..of.patients[agent$X.step.==patient[i] & agent$efficacy==efficacy[j]])
      
      mat.sum.cdiff[1,j]<-mean(agent$mean.finalcontamcdiff..of.patients[agent$X.step.==patient[i] &  agent$efficacy==efficacy[j]])
      mat.sum.cdiff[2,j]<-sd(agent$mean.finalcontamcdiff..of.patients[agent$X.step.==patient[i] & agent$efficacy==efficacy[j]])
    }
    summariesmrsa[[i]]<-mat.sum.mrsa
    summariescdiff[[i]]<-mat.sum.cdiff
  }
  summariesmrsa<<-summariesmrsa
  summariescdiff<<-summariescdiff
}

agent<-agent.scenario1
sum.table(patient=c(2,3,4,10,25,50))
summariesmrsa[[1]]
summariesmrsa[[2]]
summariesmrsa[[3]]
summariesmrsa[[4]]
summariesmrsa[[5]]
summariesmrsa[[6]]

summariescdiff[[1]]
summariescdiff[[2]]
summariescdiff[[3]]
summariescdiff[[4]]
summariescdiff[[5]]
summariescdiff[[6]]

agent<-agent.scenario2
sum.table(patient=c(2,3,4,10,25,50))
summariesmrsa[[1]]
summariesmrsa[[2]]
summariesmrsa[[3]]
summariesmrsa[[4]]
summariesmrsa[[5]]
summariesmrsa[[6]]

summariescdiff[[1]]
summariescdiff[[2]]
summariescdiff[[3]]
summariescdiff[[4]]
summariescdiff[[5]]
summariescdiff[[6]]


agent<-agent.scenario3
sum.table(patient=c(2,3,4,10,25,50))
summariesmrsa[[1]]
summariesmrsa[[2]]
summariesmrsa[[3]]
summariesmrsa[[4]]
summariesmrsa[[5]]
summariesmrsa[[6]]

summariescdiff[[1]]
summariescdiff[[2]]
summariescdiff[[3]]
summariescdiff[[4]]
summariescdiff[[5]]
summariescdiff[[6]]

agent<-agent.scenario4
sum.table(patient=c(2,3,4,10,25,50))
summariesmrsa[[1]]
summariesmrsa[[2]]
summariesmrsa[[3]]
summariesmrsa[[4]]
summariesmrsa[[5]]
summariesmrsa[[6]]

summariescdiff[[1]]
summariescdiff[[2]]
summariescdiff[[3]]
summariescdiff[[4]]
summariescdiff[[5]]
summariescdiff[[6]]







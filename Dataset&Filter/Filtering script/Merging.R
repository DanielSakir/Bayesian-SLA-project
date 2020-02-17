############ MERGE DI TUTTI I FILE eccetto laboratori - rivisto ############ 
# Merge di tutti i dataaset (eccetto laboratori e fam history)
# NON è FINITO DI RIVEDERE

setwd("~/Desktop/PROGETTO BAYESIANA/als_data/Modified_Data/Filtered_NEW")

dem <- read.csv("Filtered_Demographic.csv", header = T)
als <- read.csv("Filtered_Alsfrs.csv", header = T)
fvc <- read.csv("Filtered_FVC.csv", header = T)
vit <- read.csv("Filtered_Vitals.csv", header = T)
wh <- read.csv("Filtered_WeightHeight.csv", header = T)
dea <- read.csv("Filtered_Death.csv", header = T)
site <- read.csv("Filtered_ALSHistory_Site.csv", header = T)
sym <- read.csv("Filtered_ALSHistory_Subject_symptoms.csv", header = TRUE)
names(sym)[1] <- "subject_id"

############### ALSFRS ############### 

## Tolgo righe con Delta > 7 x ALSFRS
#als <- als[als$ALSFRS_Delta<=7 & !is.na(als$ALSFRS_Delta),]

## Tolgo righe con Delta NA x ALSFRS
als <- als[!is.na(als$ALSFRS_Delta),]

## Verifico se ci sono più righe per paziente
#n_occur <- data.frame(table(als$subject_id))
#n_occur[n_occur$Freq > 1,]
## ci sono molte persone con più righe, le tolgo
#als <- als[!duplicated(als$subject_id),]
## Verifico se tutto a posto
#n_occur <- data.frame(table(als$subject_id))
#n_occur[n_occur$Freq > 1,]
# Tolgo colonna Delta
#als$ALSFRS_Delta <- NULL

############### FVC ############### 

## Tolgo righe con Delta NA
fvc <- fvc[!is.na(fvc$Forced_Vital_Capacity_Delta),]

## Verifico se ci sono più righe per paziente
n_occur <- data.frame(table(fvc$subject_id))
n_occur[n_occur$Freq > 1,]
## ci sono molte persone con più righe, le tolgo
fvc <- fvc[!duplicated(fvc$subject_id),]
## Verifico se tutto a posto
n_occur <- data.frame(table(fvc$subject_id))
n_occur[n_occur$Freq > 1,]
# Tolgo colla Delta
fvc$Forced_Vital_Capacity_Delta <- NULL

############### VITAL ############### 

## Tolgo righe con Delta NA
vit <- vit[!is.na(vit$Vital_Signs_Delta),]

## Verifico se ci sono più righe per paziente
n_occur <- data.frame(table(vit$subject_id))
n_occur[n_occur$Freq > 1,]
## ci sono molte persone con più righe, le tolgo
vit <- vit[!duplicated(vit$subject_id),]
## Verifico se tutto a posto
n_occur <- data.frame(table(vit$subject_id))
n_occur[n_occur$Freq > 1,]
# Tolgo colla Delta
vit$Vital_Signs_Delta <- NULL

############### WEIGHTHEIGHT ############### 

## Tolgo righe con Delta NA
wh <- wh[!is.na(wh$Vital_Signs_Delta),]

## Verifico se ci sono più righe per paziente
n_occur <- data.frame(table(wh$subject_id))
n_occur[n_occur$Freq > 1,]
## ci sono molte persone con più righe, le tolgo
wh <- wh[!duplicated(wh$subject_id),]
## Verifico se tutto a posto
n_occur <- data.frame(table(wh$subject_id))
n_occur[n_occur$Freq > 1,]
# Tolgo colla Delta
wh$Vital_Signs_Delta <- NULL

############################## 

#load("MAXDELTA.RData")

x <- merge(dea, dem,by = "subject_id", all = TRUE)
x <- merge(x, als,by = "subject_id", all = TRUE)
x <- merge(x, fvc,by = "subject_id", all = TRUE)
x <- merge(x, vit,by = "subject_id", all = TRUE)
x <- merge(x, wh,by = "subject_id", all = TRUE)
x <- merge(x, site, by = "subject_id", all = TRUE)
x <- merge(x, sym, by = "subject_id", all = TRUE)

x <- merge(x, MAXDELTA, by = "subject_id", all = TRUE)

write.csv(x, "MERGED.csv", row.names = FALSE)

save(x,file = "MERGED.RData")

#####
#####
#####
#####

# load("MERGED.RData")

## Remove Rows with more than 40% NA
y <- x[-which(rowMeans(is.na(x)) > 0.4), ]

na_count <-sapply(y, function(X) sum(length(which(is.na(X)))))
na_count <- data.frame(na_count)
tmp <- y
tmp$Final_Weight[y$Weight_Pounds < 40 & !is.na(y$Weight_Pounds)] <- y$Weight_Kilo[y$Weight_Pounds < 40 & !is.na(y$Weight_Pounds)]

tmp$Weight_Pounds <- NULL
tmp$Weight_Kilo <- NULL

tmp$BMI[is.na(tmp$BMI) & !is.na(tmp$Final_Weight)] <- tmp$Final_Weight[is.na(tmp$BMI) & !is.na(tmp$Final_Weight)] /
                                                      (tmp$Final_Height[is.na(tmp$BMI) & !is.na(tmp$Final_Weight)]/100)^2

tmp$BMI_Pounds <- NULL
tmp$BMI_Kilo <- NULL

tmp <- tmp[!is.na(tmp$Final_Weight),] # TOLTI 277
tmp <- tmp[!is.na(tmp$Final_Height),] # TOLTI 3
tmp <- tmp[!is.na(tmp$Age),] # TOLI 6
tmp <- tmp[!is.na(tmp$Onset_Delta),] # TOLTI 7
tmp <- tmp[!is.na(tmp$Subject_Normal),] # TOLTI 3
tmp <- tmp[!is.na(tmp$Q1_Speech),] # TOLTI 130
tmp <- tmp[!is.na(tmp$Respiratory_Rate),] # TOLTI 26

dummy <- c("Sympt_ATROPHY","Sympt_CRAMPS","Sympt_FASCICULATIONS","Sympt_GAIT_CHANGES","Sympt_OTHER",
           "Sympt_SENSORY_CHANGES","Sympt_SPEECH","Sympt_STIFFNESS","Sympt_SWALLOWING","Sympt_WEAKNESS",
           "Sympt_CLUMSINESS","Sympt_DECR.COORDINATION","Sympt_FATIGUE")
tmp[,dummy] <- NULL

tmp <- tmp[!is.na(tmp$Blood_Pressure_Diastolic),] # TOLTI 4
tmp <- tmp[!is.na(tmp$Pulse),] # TOLTI 3

na_count_tmp <-sapply(tmp, function(X) sum(length(which(is.na(X)))))
na_count_tmp <- data.frame(na_count_tmp)

data <- tmp
N=dim(data)[1]
for(i in 1 : N ) {
  if ( data$Subject_Normal[i]== 0 && !is.na(data$Age[i])==TRUE && !is.na(data$Sex[i])==TRUE && !is.na(data$Final_Height[i])==TRUE){
    if (data$Sex[i]==0) { 
      if(data$Age[i]<65) { data$Subject_Normal[i]=0.0454*data$Final_Height[i] -0.0211*data$Age[i] - 2.8253 }
      if(data$Age[i]>=65) { 
        bsa=data$Final_Height[i] * data$Final_Weight[i]/7200
        data$Subject_Normal[i]=0.0003171*data$Final_Height[i]^2 - 0.0351*data$Age[i] - 6.368*bsa + 0.05925*data$Final_Weight[i] + 3.960}
    }
    if(data$Sex[i]==1) {
      if(data$Age[i]<65) {data$Subject_Normal[i]=0.0678*data$Final_Height[i] - 0.0147*data$Age[i] - 6.0548}
      if(data$Age[i]>=65) {data$Subject_Normal[i]=0.0001572*data$Final_Height[i]^2-0.00000268*data$Age[i]^3+ 0.223}
    }
    
  }
}

data$meanPct <- data$Subject_Liters_Trial_1/data$Subject_Normal
data$Subject_Liters_Trial_1 <- NULL
data$pct_of_Normal_Trial_1 <- NULL
data$Subject_Normal <- NULL

na_count_data <-sapply(data, function(X) sum(length(which(is.na(X)))))
na_count_data <- data.frame(na_count_data)

write.csv(data, "Tab_Filtered.csv", row.names = FALSE)
rm(list=ls())

# R & STAN are friends!
library(rstan)
library(rjags)
library(coda)

# for plots
library(ggplot2)
library(tidyr)
library(dplyr)
library(purrr)
library(ggsci)
require(gplots)
require(ggpubr)

setwd("~/Desktop/als_data/SLA_Project/Filtered")

reach <- read.csv("Tab_Filtered.csv", header=T)
names(reach)
head(reach)

dat <- reach[, c("Onset_Delta", "Age", "Sex")]
t <- reach$Death_Days
cens <- reach$maxDelta

tmax <- round(max(t[!is.na(t)])) + 1
cens[!is.na(t)] <- tmax

dat <- list(cens = cens, t = t, Onset_Delta = dat$Onset_Delta, Age = dat$Age, Sex = dat$Sex)

inits = function() {
  list( beta = c(0,0,0,0), alpha = 1)
}

modelAFT <- jags.model("Prova2", data = dat, n.chains = 3)
update(modelAFT, 10000)

variable.names = c("beta","alpha")

n.iter = 20000
thin = 10

outputAFT <- coda.samples(model = modelAFT, variable.names = variable.names, n.iter = n.iter, thin = thin)

save(outputAFT,file='AFT_output.Rdata')

library(coda)

data.out <- as.matrix(outputAFT)
data.out <- data.frame(data.out)
attach(data.out)
n.chain <- dim(data.out)[1]
n.chain

summary(data.out)

# summary(data.out[,18:23])

par(mfrow=c(2,3))
acf(data.out[,'beta.1.'],lwd=3,col="red3",main="autocorrelation of beta1")
acf(data.out[,'beta.2.'],lwd=3,col="red3",main="autocorrelation of beta2")
acf(data.out[,'beta.3.'],lwd=3,col="red3",main="autocorrelation of beta3")
acf(data.out[,'beta.4.'],lwd=3,col="red3",main="autocorrelation of beta4")

plot(ts(data.out[,'beta.1.']),xlab="t",ylab="beta1")
plot(ts(data.out[,'beta.2.']),xlab="t",ylab="beta2")
plot(ts(data.out[,'beta.3.']),xlab="t",ylab="beta3")
plot(ts(data.out[,'beta.4.']),xlab="t",ylab="beta4")


par(mfrow=c(2,3))
plot(density(data.out[,'beta.1.'],adj=2),  xlab=expression(beta[1]),main="")
abline(v=quantile(data.out[,'beta.1.'],prob=c(.025,.975)),lwd=2,col="red")
plot(density(data.out[,'beta.2.'],adj=2),  xlab=expression(beta[2]),main="")
abline(v=quantile(data.out[,'beta.2.'],prob=c(.025,.975)),lwd=2,col="red")
plot(density(data.out[,'beta.3.'],adj=2),  xlab=expression(beta[3]),main="")
abline(v=quantile(data.out[,'beta.3.'],prob=c(.025,.975)),lwd=2,col="red")
plot(density(data.out[,'beta.4.'],adj=2),  xlab=expression(beta[4]),main="")
abline(v=quantile(data.out[,'beta.4.'],prob=c(.025,.975)),lwd=2,col="red")

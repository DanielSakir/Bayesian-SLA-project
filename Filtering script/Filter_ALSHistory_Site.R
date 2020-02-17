############ PULIZIA ALSHistory_RP_Site rivista ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

als <- read.csv("ALSHistory_RP_Site.csv", header=T)
al <- als
al[,"Subject_ALS_History_Delta"] <- NULL

al<- al[!al$Onset_Site=="",]
al <- droplevels(al)
library(fastDummies)
al <- dummy_cols(al,select_columns = "Onset_Site")
al$Onset_Site <- NULL

rm("als")

## controllo dimensione finale 
head(al)
dim(al)

## Scrivo il dataset
write.csv(al, "Filtered_NEW/Filtered_ALSHistory_Site.csv", row.names = FALSE)


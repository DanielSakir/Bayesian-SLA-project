
# COMPUTER GILDA
setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

alb <- read.csv("Filtered_Albumin.csv", header = T)
als <- read.csv("Filtered_Alsfrs.csv", header = T)
site <- read.csv("Filtered_ALSHistory_Site.csv", header = T)
dea <- read.csv("Filtered_Death.csv", header = T)
dem <- read.csv("Filtered_Demographic.csv", header = T)
fvc <- read.csv("Filtered_FVC.csv", header = T)
sym <- read.csv("Filtered_R_ALSHistory_Subject_symptoms.csv", header = T)
vit <- read.csv("Filtered_Vitals.csv", header = T)
wh <- read.csv("Filtered_WeightHeight.csv", header = T)
cen <- read.csv("Censored_Data.csv", header = T)

# MERGE DEI FILE

x <- merge(fvc, als,by = c("subject_id","t"), all = TRUE)
x <- merge(x, vit,by = c("subject_id","t"), all = TRUE)
x <- merge(x, wh,by = c("subject_id","t"), all = TRUE)
x <- merge(x, alb,by = c("subject_id","t"), all = TRUE)
x <- merge(x, dea,by = "subject_id", all = TRUE)
x <- merge(x, site, by = "subject_id", all = TRUE)
x <- merge(x, dem,by = "subject_id", all = TRUE)
x <- merge(x, sym,by = "subject_id", all = TRUE)
x <- merge(x, cen,by = "subject_id", all = TRUE)

x <- x[!is.na(x$t),]
x <- x[x$t>=0,]

# Tengo solo i pazienti con più di N osservazioni
N <- 3
library(dplyr)
x <- x %>% group_by(subject_id) %>% filter(n()>=N)

# t1 <- x[!is.na(x$meanSLT),]
# t <- x[!is.na(x$meanPCT),]

# Ordino i pazienti per Subject_ID e t
x <- x[with(x,order(subject_id,t)),]

write.csv(x, "MERGED.csv", row.names = FALSE)

rm(dea,dem,alb,als,fvc,site,sym,vit,wh,cen)
rm(x)


na_count <- data.frame(sapply(x, function(y) sum(is.na(y))))




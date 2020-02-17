
# Cerco max delta per ogni paziente
setwd("~/Politecnico di Milano/Gilda Matteucci - Filtered_NEW")

# COMPUTER GILDA
# setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

als <- read.csv("Filtered_Alsfrs.csv", header = T)
fvc <- read.csv("Filtered_FVC.csv", header = T)
vit <- read.csv("Filtered_Vitals.csv", header = T)
wh <- read.csv("Filtered_WeightHeight.csv", header = T)
labc <- read.csv("Filtered_LabsCategorical.csv", header = T)
labn <- read.csv("Filtered_LabsNumerical.csv", header = T)

labc <- labc[,2:3]
labn <- labn[,2:3]

names(labc) <- c("subject_id", "t")
names(labn) <- c("subject_id", "t")

als <- als[, c("subject_id", "t")]
fvc <- fvc[, c("subject_id", "t")]
vit <- vit[, c("subject_id", "t")]
wh <- wh[, c("subject_id", "t")]
labc <- labc[, c("subject_id", "t")]
labn <- labn[, c("subject_id", "t")]

x <- merge(als, fvc,by = c("subject_id","t"), all = TRUE)
x <- merge(x, vit,by = c("subject_id","t"), all = TRUE)
x <- merge(x, wh,by = c("subject_id","t"), all = TRUE)
x <- merge(x, labc,by = c("subject_id","t"), all = TRUE)
x <- merge(x, labn,by = c("subject_id","t"), all = TRUE)

library(dplyr)

rm(als,fvc,vit,wh,labc,labn)

x <- unique(x)

x <- x %>% group_by(subject_id) %>% top_n(1)

rm(als,fvc,vit,wh,labc,labn)

names(x) <- c("subject_id","Censored")


## Scrivo il dataset
write.csv(x, "Censored_Data.csv", row.names = FALSE)




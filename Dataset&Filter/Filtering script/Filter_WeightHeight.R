############ PULIZIA WeightHeight_RP rivisto ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico altezza e peso e tolgo colonne inutili
weightHeight <- read.csv("WeightHeight_RP.csv", header = T)
wh <- weightHeight

dummy <- c("Check_Height","Nr_Values_Height","Mode_Height","Count_Mode_Height",
           "Freq_Mode_Height","Mean_height","Min_Height","Max_Height",
           "Weight","Weight_Units","Height","Height_Units")
wh[,dummy] <- NULL

## in wh il subject_id ha la maiuscola nel nome
colnames(wh)[1] <- "subject_id"

rm("weightHeight")
rm("dummy")

names(wh)[2] <- "t"

#tolgo t = NA
wh <- wh[!is.na(wh$t),]

## Scrivo il dataset
write.csv(wh, "Filtered_NEW/Filtered_WeightHeight.csv", row.names = FALSE)

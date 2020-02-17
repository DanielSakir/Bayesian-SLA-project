############ PULIZIA LabsNumerical_RP rivisto ############ 

# COMPUTER GILDA
setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico labs numerical e tolgo colonne su modifiche, duplicati, "Categorical", commenti su modifiche
labsn <- read.csv("LabsNumerical_RP.csv", header = T)
lab <- labsn

dummy <- c("NotesOnChange","Further_Comments","RevisedTest_Std","RevisedTest_Min",
           "RevisedTest_P1","RevisedTest_P25","RevisedTest_P50","RevisedTest_Mean",
           "RevisedTest_P75","RevisedTest_P99","RevisedTest_Max","Main_Unit",          
           "Main_Category","OriginalTest_unit","Test_Category","Duplicated_Date",
           "IndCat_Severity")
lab[,dummy] <- NULL

rm("dummy")
rm("labsn")

names(lab)[2] <- "subject_id"
names(lab)[3] <- "t"

## Scrivo il dataset
write.csv(lab, "Filtered_NEW/Filtered_LabsNumerical.csv", row.names = FALSE)

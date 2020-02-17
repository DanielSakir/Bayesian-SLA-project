############ PULIZIA LabsCategorical_RP rivisto ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico labs numerical e tolgo colonne su modifiche, duplicati, "Categorical", commenti su modifiche
labsc <- read.csv("LabsCategorical_RP.csv", header = T)
lab <- labsc

dummy <- c("Main_Category", "Test_Category","Duplicated_Date",
           "NotesOnChange","Further_Comments","Main_Unit",
           "OriginalTest_result","OriginalTest_unit")
lab[,dummy] <- NULL

rm("dummy")
rm("labsc")

names(lab)[2] <- "subject_id"
names(lab)[3] <- "t"

## Scrivo il dataset
write.csv(lab, "Filtered_NEW/Filtered_LabsCategorical.csv", row.names = FALSE)

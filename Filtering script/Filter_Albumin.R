##### LAB NUM 2 - albumina e creatininchinasi

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

LabNum <- read.csv("Filtered_LabsNumerical.csv", header = T)
Lab <- LabNum

#levels(LabNum$Test_name)

LabNum <- LabNum[LabNum$Test_name=="ALBUMIN" & !LabNum$RevisedTest_Unit=="%",]
LabNum <- droplevels(LabNum)
names(LabNum)[3] <- "t"

LabNum$RevisedTest_OnlyCat <- NULL
LabNum$IndNum_Severity <- NULL
LabNum$Value_Severity <- NULL
LabNum$TestRes_Cat <- NULL
LabNum$OriginalTest_result <- NULL
LabNum$RevisedTest_Unit <- NULL
LabNum$Test_name <- NULL

names(LabNum)[3] <- "Albumin g/L"
names(LabNum)[1] <- "subject_id"

write.csv(LabNum, "Filtered_Albumin.csv", row.names = FALSE)


########## CREAZIONE DEI DATASET PER I SOTTOMODELLI ##########

# COMPUTER TONI
setwd("~/Politecnico di Milano/Gilda Matteucci - PROGETTO BAYESIANA/Modified_Data/Filtered_NEW/LongitudinalSurvival_Model")

# COMPUTER GILDA
#setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

data <- read.csv("Dataset_Rielaborato.csv", header = TRUE)

# Creo i dataset per il Longitudinal Model
SelectedVar_Lon <- c("subject_id", "t", "Age", "Sex", "BMI",
                     "Q1_Speech", "Q2_Salivation", "Q3_Swallowing", "Q10_Respiratory", 
                     "Respiratory_Rate", "Onset_Site_Bulbar", "Onset_Site_Limb",
                     "Onset_Site_Limb.Bulbar", "Onset_Site_Other",
                     "Race_Americ_Indian_Alaska_Native", "Race_Asian", 
                     "Race_Black_African_American", "Race_Caucasian", 
                     "Race_Hispanic", "Race_Other", 
                     "meanPCT")
dataLon <- data[,SelectedVar_Lon]
write.csv(dataLon, "Longitudinal_Data.csv", row.names = FALSE)



data_fvc <- data
data_fvc$meanPCT <- NULL
data_fvc$subject_id <- NULL
data_fvc$t <- NULL

fit = lm(Death_Days ~ ., data = data_fvc)
summary(fit)



# Creo i dataset per la Survival 
SelectedVar_Sur <- c("subject_id", "t", "Censored", "Age", "Sex", "BMI", "Diagnosis_Delta", 
                     "Onset_Delta", "Onset_Site_Bulbar", "Onset_Site_Limb", 
                     "Onset_Site_Limb.Bulbar", "Onset_Site_Other", "Q3_Swallowing", 
                     "Q5a_Cutting_without_Gastrostomy", "Q5b_Cutting_with_Gastrostomy", 
                     "Albumin.g.L", "Race_Americ_Indian_Alaska_Native", "Race_Asian", 
                     "Race_Black_African_American", "Race_Caucasian", 
                     "Race_Hispanic", "Race_Other", 
                     "Death_Days")
dataSur <- data[,SelectedVar_Sur]
write.csv(dataSur, "Survival_Data.csv", row.names = FALSE)











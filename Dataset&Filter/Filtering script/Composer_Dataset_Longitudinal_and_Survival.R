########## CREAZIONE DEI DATASET PER I SOTTOMODELLI ##########

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

data <- read.csv("MERGED.csv", header = TRUE)

# Creo i dataset per il Longitudinal Model
SelectedVar_Lon <- c("subject_id", "t", "Age", "Sex", "BMI", "Diagnosis_Delta", 
                 "Onset_Delta", "Onset_Site_Bulbar", "Onset_Site_Limb", 
                 "Onset_Site_Limb.Bulbar", "Onset_Site_Other", "Q1_Speech", "Q2_Salivation", 
                 "Q3_Swallowing", "Q10_Respiratory", "Blood_Pressure_Diastolic", 
                 "Blood_Pressure_Systolic", "Pulse", "Respiratory_Rate", 
                 "Race_Americ_Indian_Alaska_Native", "Race_Asian", "Race_Black_African_American", 
                 "Race_Caucasian", "Race_Hispanic", "Race_Other","meanPCT")
dataLon <- data[,SelectedVar_Lon]

write.csv(dataLon, "LongitudinalSurvival_Model/Longitudinal_Data.csv", row.names = FALSE)

# Creo i dataset per la Survival 
SelectedVar_Sur <- c("subject_id", "t", "Censored", "Age", "Sex", "BMI", "Diagnosis_Delta", 
                     "Onset_Delta", "Onset_Site_Bulbar", "Onset_Site_Limb", 
                     "Onset_Site_Limb.Bulbar", "Onset_Site_Other", "Q1_Speech", "Q2_Salivation", "Q3_Swallowing", 
                     "Q4_Handwriting", "Q5a_Cutting_without_Gastrostomy", "Q5b_Cutting_with_Gastrostomy", 
                     "Q6_Dressing_and_Hygiene", "Q7_Turning_in_Bed", "Q8_Walking", "Q9_Climbing_Stairs",
                     "Q10_Respiratory", "Albumin.g.L", "Race_Americ_Indian_Alaska_Native", "Race_Asian", 
                     "Race_Black_African_American", "Race_Caucasian", "Race_Hispanic", "Race_Other", "Death_Days")

dataSur <- data[,SelectedVar_Sur]
write.csv(dataSur, "LongitudinalSurvival_Model/Survival_Data.csv", row.names = FALSE)



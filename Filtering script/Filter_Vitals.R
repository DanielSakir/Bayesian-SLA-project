############ PULIZIA Vitals_RP rivisto ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico e tolgo colonne inutili
vitals <- read.csv("Vitals_RP.csv", header = T)
vit <- vitals

# tolgo colonne di udm e che non ci servono
dummy <- c("Blood_Pressure_Diastolic_Units","Blood_Pressure_Systolic_Units",
           "Pulse_Units","Respiratory_Rate_Units","Temperature_Units",
           "NotesChanges","Rep_SubjDate")
vit[,dummy] <- NULL
dummy <- c("Standing_BP_Diastolic","Baseline_Standing_BP_Diastolic",
           "Endpoint_Standing_BP_Diastolic","Standing_BP_Systolic",
           "Baseline_Standing_BP_Systolic","Endpoint_Standing_BP_Systolic",
           "Supine_Pulse","Baseline_Supine_Pulse","Endpoint_Supine_Pulse",       
           "Standing_Pulse","Baseline_Standing_Pulse","Endpoint_Standing_Pulse",
           "Supine_BP_Diastolic","Baseline_Supine_BP_Diastolic",
           "Endpoint_Supine_BP_Diastolic","Supine_BP_Systolic",
           "Baseline_Supine_BP_Systolic","Endpoint_Supine_BP_Systolic"  )
vit[,dummy] <- NULL

rm("vitals")
rm("dummy")

names(vit)[2] <- "t"
vit <- vit[!is.na(vit$t),]

write.csv(vit, "Filtered_NEW/Filtered_Vitals.csv", row.names = FALSE)

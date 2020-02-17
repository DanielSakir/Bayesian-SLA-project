##### FILTRO DEL MERGED AL T = 0 #####

# ho in input il file merged grosso, se cambi qualcosa li devi ricaricarlo nella cartella!

# COMPUTER GILDA
setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/SECONDA PRESENTAZIONE")

# COMPUTER TONI

merged <- read.csv("MERGED.csv", header = T)

merged <- merged[merged$t <= 7,]

# verifico se ci sono piu righe per paziente
n_occur <- data.frame(table(merged$subject_id))
n_occur[n_occur$Freq > 1,]

# tolgo le ripetizioni
merged <- merged[!duplicated(merged$subject_id),]

merged$t <- NULL

temp <- c("subject_id", "Death_Days", "Censored")
dea <- merged[,temp]

merged$Death_Days <- NULL
merged$Censored <- NULL

merged$Weight_Kilo <- NULL
merged$Weight_Pounds <- NULL
merged$BMI_Kilo <- NULL
merged$BMI_Pounds <- NULL
merged$Temperature <- NULL
merged$Subject_Normal <- NULL
merged$meanSLT <- NULL

merged$Diagnosis_Delta <- NULL
merged$meanPCT <- NULL

m <- merged

m <- m[!is.na(m$Symp_ATROPHY...ARMS),]

na_count <- data.frame(sapply(m,function(y) sum(is.na(y))))

m <- na.omit(m)

m <- merge(m,dea, by = "subject_id", all = T)
m <- m[!is.na(m$Age),]

m$Race_NA <- NULL #non ce ne sono!

write.csv(m, "Filtered0_Merged.csv", row.names = F)

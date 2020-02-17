############ PULIZIA  FamilyHistory_RP.CSV rivisto ############ 
# è uguale al vecchio 

setwd("~/Desktop/PROGETTO BAYESIANA/als_data/Modified_Data")

## Carico family e tolgo colonne inutili
family <- read.csv("FamilyHistory_RP.csv", header = T)
fam <- family[,-(2:3)] # Delta tutti 0, no parenti con mutazione SLA
fam <- fam[,-(3:4)] # non-revised malattie
fam <- fam[,-5] # via colonna cambiamenti

## Sommo per parenti
## Sostituisco prima tutti NA in parenti con 0
## Uso variabile temporanea
aiuto <- fam[,7:27]
aiuto[is.na(aiuto)] <- 0

# Nonno
aiuto[,1] <- aiuto[,1]+aiuto[,2]+aiuto[,3]
aiuto <- aiuto[,-(2:3)]

# Nonna
aiuto[,2] <- aiuto[,2]+aiuto[,3]+aiuto[,4]
aiuto <- aiuto[,-(3:4)]

# Zia
aiuto[,3] <- aiuto[,3]+aiuto[,4]+aiuto[,5]
aiuto <- aiuto[,-(4:5)]

# Zio
aiuto[,4] <- aiuto[,4]+aiuto[,5]+aiuto[,6]
aiuto <- aiuto[,-(5:6)]

# Figli (maschi e femmine)
aiuto[,10] <- aiuto[,10]+aiuto[,11]
aiuto <- aiuto[,-11]
colnames(aiuto)[10] <- "Child"

# Nipoti (maschi e femmine)
aiuto[,11] <- aiuto[,11]+aiuto[,12]
aiuto <- aiuto[,-12]
colnames(aiuto)[11] <- "Grandchild"

## Tolgo colonne parenti da fam
fam <- fam[,-(7:27)]

## Aggiungo a fam aiuto
fam <- cbind(fam,aiuto)

## in wh il subject_id ha la maiuscola nel nome
colnames(fam)[1] <- "subject_id"

## tolgo variabile di supporto e dataset iniziale
rm("aiuto")
rm("family")

## controllo dimensione finale 
head(fam)
dim(fam)

## Scrivo il dataset
write.csv(fam, "Filtered_NEW/Filtered_FamilyHistory.csv", row.names = FALSE)

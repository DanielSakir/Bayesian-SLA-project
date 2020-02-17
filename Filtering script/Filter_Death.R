############ PULIZIA Death rivisto ############ 

setwd("~/Desktop/PROGETTO BAYESIANA/als_data/Modified_Data")

## Carico morte e tolgo colonne inutili
morte <- read.csv("Death_RP.csv", header = T)
mor <- morte

## Tolgo morto e risorto, poi tolgo colonna su soggetti ripetuti
mor <- mor[-2056,] # 442984
mor$Death_Days[mor$subject_id == "442984"] <- NA 

#Tolgo colonne inutili
mor[,c("Rep_subject","Warning","Subject_Died")] <- NULL

## Ci sono persone morte che non hanno data di morte
## elimino queste righe, per comodità prima metto questi NA a -2
# mor$Death_Days[mor$Subject_Died==1 & is.na(mor$Death_Days)] <- -2
## elimino le righe con DeathDays = -2
# mor <- mor[!(mor$Death_Days == -2),]

## e quelli in cui non sono morti, metto il NA a -1
# mor$Death_Days[mor$Subject_Died==0 & is.na(mor$Death_Days)] <- -1


## tolgo dataset iniziale
rm("morte")

## !!!!! ATTENZIONE !!!!!
## Per R, i non-morti avranno NA
## perciò gli NA dei non-morti ora hanno un valore predefinito pari a -1

## controllo dimensione finale 
head(mor)
dim(mor)

## Scrivo il dataset
write.csv(mor, "Filtered_NEW/Filtered_Death.csv", row.names = FALSE)

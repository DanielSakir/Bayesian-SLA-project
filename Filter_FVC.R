############ PULIZIA FVC_RP rivisto ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico FVC e tolgo colonne inutili
fvc <- read.csv("FVC_RP.csv", header = T)
f <- fvc

f$Repeated_Record = NULL

# tengo la media dei subject liters trial, la metto come nuova colonna e cancello quindi le 3 colonne dei subject liters trial
SLT <- f[,c("Subject_Liters_Trial_1","Subject_Liters_Trial_2","Subject_Liters_Trial_3")]
meanSLT <- apply(SLT, 1, "mean", na.rm = TRUE)
f <- cbind(f,meanSLT)
f[,c("Subject_Liters_Trial_1","Subject_Liters_Trial_2","Subject_Liters_Trial_3")] <- NULL

# tengo la media dei new pct, la metto come nuova colonna e cancello quindi le 3 colonne dei new pct
PCT <- f[,c("NewPct_1","NewPct_2","NewPct_3")]
meanPCT <- apply(PCT, 1, "mean", na.rm = TRUE)
f <- cbind(f,meanPCT)
f[,c("NewPct_1","NewPct_2","NewPct_3")] <- NULL

tmp <- f[,c("Subject_Normal","Subject_Normal_New1")]
Subject_Normal <- apply(tmp,1,"sum", na.rm = TRUE)
f[,"Subject_Normal"] <- Subject_Normal
f$Subject_Normal_New1 = NULL

f$pct_of_Normal_Trial_1 = NULL
f$pct_of_Normal_Trial_2 = NULL
f$pct_of_Normal_Trial_3 = NULL

f$Subject_Normal[f$Subject_Normal==0] <- NA

rm("fvc")
rm("meanPCT")
rm("meanSLT")
rm("tmp")
rm("SLT")
rm("PCT")

names(f)[2] <- "t"
# tengo quelli con t definito e non NA
f <- f[!is.na(f$t),]

## Scrivo il dataset
write.csv(f, "Filtered_NEW/Filtered_FVC.csv", row.names = FALSE)


############ PULIZIA ALSFRS_RP rivista ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

## Carico punteggio ALSFRS, id paziente e Delta
## Diviso in due il caricamento per mantenere le colonne
q <- read.csv("Alsfrs_RP.csv", header=T)
q[,c("Repeated_Record")] <- NULL

## Metto la media dei R1 R2 R3 (se non NA) in Q10 (se NA)
media <- (q$R_1_Dyspnea + q$R_2_Orthopnea + q$R_3_Respiratory_Insufficiency)/3
q$Q10_Respiratory[is.na(q$Q10_Respiratory)] <- media[is.na(q$Q10_Respiratory)]

## Tolgo colonne su ALSFRS_R
colR <- c("ALSFRS_R_Total","R_1_Dyspnea","R_2_Orthopnea","R_3_Respiratory_Insufficiency")
q[,colR] <- NULL

## Shifto il punteggio
col <- c("Q1_Speech","Q2_Salivation","Q3_Swallowing","Q4_Handwriting",
         "Q5a_Cutting_without_Gastrostomy","Q5b_Cutting_with_Gastrostomy",
         "Q6_Dressing_and_Hygiene","Q7_Turning_in_Bed","Q8_Walking",                     
         "Q9_Climbing_Stairs","Q10_Respiratory")
q[,col] <- q[,col] + 1

# Dove NA da w/o Gastrostomy metto 0
q$Q5a_Cutting_without_Gastrostomy[is.na(q$Q5a_Cutting_without_Gastrostomy)] <- 0
q$Q5b_Cutting_with_Gastrostomy[is.na(q$Q5b_Cutting_with_Gastrostomy)] <- 0

## Ricalcolo il punteggio finale
## Devo mettere in ALSFRS_total la somma di tutte le Q10 domande dove ALSFRS è NA e dove le domande non sono NA
q$ALSFRS_Total <- apply(q[,col],1,"sum", na.rm = TRUE)

# rinomino colonna delta in t
names(q)[13] <- "t"

#tolgo t = NA
q <- q[!is.na(q$t),]

head(q)
dim(q)

## Scrivo il dataset
write.csv(q, "Filtered_NEW/Filtered_Alsfrs.csv", row.names = FALSE)



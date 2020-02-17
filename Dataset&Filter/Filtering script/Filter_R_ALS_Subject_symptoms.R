########## FINAL SYMPTOM 2 ##########

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW")

symp <- read.csv("Filtered_ALSHistory_Subject_symptoms.csv", header = T)
sy <- symp

library(plyr) 

# specifico il sintomo che c'è in other
levels(sy$FINAL_SYMPTOM) <- c(levels(sy$FINAL_SYMPTOM), levels(sy$FINAL_SYMPTOM_OTHER))
sy$FINAL_SYMPTOM[sy$FINAL_SYMPTOM=="OTHER" & sy$FINAL_SYMPTOM_OTHER!=""]<-sy$FINAL_SYMPTOM_OTHER[sy$FINAL_SYMPTOM=="OTHER" & sy$FINAL_SYMPTOM_OTHER!=""]
sy[,"FINAL_SYMPTOM_OTHER"]<- NULL

#
levels(sy$LOCATION2) <- c(levels(sy$LOCATION2),"")
levels(sy$LOCATION3) <- c(levels(sy$LOCATION3),"")
levels(sy$LOCATION4) <- c(levels(sy$LOCATION4),"")
levels(sy$LOCATION1) <- c(levels(sy$LOCATION1), levels(sy$LOCATION2), levels(sy$LOCATION3), levels(sy$LOCATION4))

N <- dim(sy)[1]

for (i in 1:N) {
  if (sy$LOCATION2[i]!="") {
    temp <- data.frame(sy$Subject_id[i], sy$FINAL_SYMPTOM[i], sy$LOCATION2[i],"","","")
    colnames(temp) = names(sy)
    sy <- rbind(sy,temp)
    
    if (sy$LOCATION3[i]!="") {
      temp <- data.frame(sy$Subject_id[i], sy$FINAL_SYMPTOM[i], sy$LOCATION3[i],"","","")
      colnames(temp) = names(sy)
      sy <- rbind(sy,temp)

      if (sy$LOCATION4[i]!="") {
        temp <- data.frame(sy$Subject_id[i], sy$FINAL_SYMPTOM[i], sy$LOCATION4[i],"","","")
        colnames(temp) = names(sy)
        sy <- rbind(sy,temp)

      }

    }

  }

}

sy <-sy[order(sy$Subject_id),]

sy[,"LOCATION2"]<- NULL
sy[,"LOCATION3"]<- NULL
sy[,"LOCATION4"]<- NULL

# Metto UNKNOWN dove c'è NA su location
levels(sy$LOCATION1) <- c(levels(sy$LOCATION1), "UNKNOWN")
sy$LOCATION1[is.na(sy$LOCATION1)]<-"UNKNOWN"

N <- dim(sy)[1]
newCol <- rep(NA,N)
for (i in 1:N) {
  newCol[i] <- paste(sy$FINAL_SYMPTOM[i],"-",sy$LOCATION1[i])
}

newCol <- data.frame(sy$Subject_id,newCol)
colnames(newCol)[2] = "Symp"

library(fastDummies)
ciccio <- dummy_cols(newCol,select_columns = "Symp")
ciccio <- aggregate(.~ sy.Subject_id, ciccio, sum)
colnames(ciccio)[1] = "subject_id"
ciccio[,"Symp"]<- NULL

symp <- ciccio

write.csv(symp, "Filtered_R_ALSHistory_Subject_symptoms.csv", row.names = FALSE)

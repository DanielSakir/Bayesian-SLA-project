############ PULIZIA Demographics rivista ############ 

setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

demog <- read.csv("Demographics_RP.csv", header=T)
dem <- demog

##### razza #####
# Dove razza vuota metto 0
dem$Race[dem$Race == ''] <- NA
levels(dem$Race) <- c(levels(dem$Race), 0)
dem$Race[is.na(dem$Race)] <- 0

# Dove razza "UNKNOWN" metto 0
dem$Race[dem$Race=="Unknown"] <- 0

## Metto NA su Ethnicity dove c'è stringa vuota
dem$Ethnicity[dem$Ethnicity == ''] <- NA
dem$Ethnicity[dem$Ethnicity == "Unknown"] <- NA

## Metto NA su Race_Other_Specify dove c'è stringa vuota
dem$Race_Other_Specify[dem$Race_Other_Specify == ''] <- NA

## Elimino colonne dummy
dummy <- c("Ethnicity","Race_Americ_Indian_Alaska_Native","Race_Asian",
           "Race_Black_African_American","Race_Hawaiian_Pacific_Islander",
           "Race_Unknown","Race_Caucasian","Race_Other")
dem[,dummy] <- NULL
rm("dummy")

##### sesso #####
## Metto NA su Sex dove c'è stringa vuota
dem$Sex[dem$Sex == ''] <- NA

## Sostituzione Male = 1, Female = 0
dem$Sex <- revalue(dem$Sex, c("Male"=1))
dem$Sex <- revalue(dem$Sex, c("Female"=0))
# Remove all unused level factor
dem$Sex <- droplevels(dem$Sex)

##### età #####

## Trasformo in Age gli NA in 0
dem$Age[is.na(dem$Age)] <- 0

## Trasformo in DoB gli NA in 0
dem$Date_of_Birth[is.na(dem$Date_of_Birth)] <- 0

## Trasformo DoB in Age
dem$Date_of_Birth <- round(-1*dem$Date_of_Birth/365, digits = 1)

## Controllo se ci sono casi in cui ho sia DoB che Age
# dem[dem$Age>0 & dem$Date_of_Birth>0,]
## Ok, non ci sono

## Sommo Age e DoB e il risultato lo salvo in colonna Age
dem$Age <- dem$Age+dem$Date_of_Birth

## Colonna DoB ora è inutile
dem[,"Date_of_Birth"] <- NULL

## Controllo se DemDelta ha valori NA
# dem$Demographics_Delta[ is.na(dem$Demographics_Delta)]
## Ci sono, li sostituisco a 0
dem$Demographics_Delta[is.na(dem$Demographics_Delta)] <- 0

## Trasformo DemDelta in anni
dem$Demographics_Delta <- round(dem$Demographics_Delta/365, digits = 1)

## Aggiungo il DemDelta alla Age
dem$Age <- dem$Age + dem$Demographics_Delta

## Elimino la colonna DemDelta
dem[,"Demographics_Delta"] <- NULL
dem$Age[dem$Age== "0"] <- NA

## Hawaiian_Pacific_Islander finisce in other
levels(dem$Race_Other_Specify) <- c(levels(dem$Race_Other_Specify), "Hawaiian_Pacific_Islander")
dem$Race_Other_Specify[dem$Race=="Hawaiian_Pacific_Islander"] <- "Hawaiian_Pacific_Islander"
dem$Race[dem$Race=="Hawaiian_Pacific_Islander"] <-"Other"

library(plyr) # for rename category HISPANIC
dem$Race_Other_Specify <- revalue(dem$Race_Other_Specify, c("HISPANIC"="Hispanic"))

# Sposto Hispanic su Race invece di Race_Other_Specify
levels(dem$Race) <- c(levels(dem$Race), "Hispanic")
dem$Race[dem$Race_Other_Specify == "Hispanic"] <- "Hispanic"

# Rimuovo colonna Race_Other_Specify
dem[,"Race_Other_Specify"] <- NULL

## Rimetto NA su Race
dem$Race[dem$Race==0] <- NA
dem$Race <- droplevels(dem$Race)

library(fastDummies)
dem <- dummy_cols(dem,select_columns = "Race")
dem$Race <- NULL
dem$Race_NA <- NULL

m <- matrix(c(c("Male", "Female"),c(1,0)), 2, 2, byrow = FALSE)
legend_Sex <- data.frame(m)
rm("m")
colnames(legend_Sex) <- c("Sex", "id")

## tolgo variabile di supporto e dataset iniziale
rm("demog")

## controllo dimensione finale 
head(dem)
dim(dem)

## Scrivo il dataset
write.csv(dem, "Filtered_NEW/Filtered_Demographic.csv", row.names = FALSE)

#Creo file con legende per categorie
save(legend_Sex, file = "Filtered_NEW/Legende/Demographic_Legend.RData")
# load("Legende/CATEGORIES_LEGEND.RData")


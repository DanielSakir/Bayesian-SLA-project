setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data")

AdvEv <- read.csv("AdverseEvents.csv", header = T)
dea <- read.csv("Filtered_NEW/Filtered_Death.csv", header = T)

adv <- AdvEv

adv$Outcome[adv$Outcome=="DIED"] <- "Death"
adv$Outcome[adv$Outcome=="DEATH"] <- "Death"
adv <- adv[adv$Outcome== "Death"|adv$Outcome == "Fatal",]

adv$Lowest_Level_Term <- NULL
adv$Preferred_Term <- NULL
adv$High_Level_Term <- NULL
adv$High_Level_Group_Term <- NULL
adv$System_Organ_Class <- NULL
adv$SOC_Abbreviation <- NULL
adv$SOC_Code <- NULL
adv$Severity <- NULL

adv <- unique(adv)

names(adv)[4] <- "time"


check <- merge(adv, dea, by = "subject_id", all = TRUE)

pippo <- check[check$time != check$Death_Days | (!is.na(check$time) & is.na(check$Death_Days)),]



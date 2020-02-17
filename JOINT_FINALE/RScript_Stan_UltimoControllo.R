 
# R & STAN are friends!
library(rstan)
library(coda)

# for plots
library(ggplot2)
library(tidyr)
library(dplyr)
library(purrr)
library(ggsci)

# for longsurv
library(rstanarm)

# COMPUTER GILDA
setwd("/Users/gildamatteucci/OneDrive - Politecnico di Milano/PROGETTO BAYESIANA/Modified_Data/Filtered_NEW/LongitudinalSurvival_Model")

# COMPUTER TONI
setwd("/Users/antoniocassia/Politecnico di Milano/Gilda Matteucci - PROGETTO BAYESIANA/Modified_Data/Filtered_NEW/LongitudinalSurvival_Model/JOINT_FINALE")

# COMPUTER ALE 
setwd("C:/Users/Acer/Desktop/GILDA/LongitudinalSurvival_Model1")

lon <- read.csv("Longitudinal_Data.csv", header = T)
sur <- read.csv("Survival_Data.csv", header = T)

# ordino le righe per subject e t
lon <- lon[with(lon, order(subject_id, t)), ]
sur <- sur[with(sur, order(subject_id, t)), ]

# seleziono 300 random subjects
set.seed(500)
sub <- unique(lon$subject_id)
selected_sub <- sort( sample(sub, 300) )

N_tot = dim(lon)[1]

X_L = lon
X_S = sur

# estraggo le corrispondenti covariate per ogni tempo
selected_long <- X_L[which(X_L$subject_id %in% selected_sub ),]
selected_surv <- X_S[which(X_S$subject_id %in% selected_sub ),]

# divido tutti i tempi per 365
selected_long$t <- selected_long$t / 365
selected_surv$t <- selected_surv$t / 365
selected_surv$Diagnosis_Delta <- selected_surv$Diagnosis_Delta / 365
selected_surv$Onset_Delta <- selected_surv$Onset_Delta / 365
selected_surv$Death_Days <- selected_surv$Death_Days / 365
selected_surv$Censored <- selected_surv$Censored / 365

# salvo in variabili a parte i responsi dei due modelli
y <- selected_long$meanPCT
T_life <- selected_surv$Death_Days

selected_long$meanPCT <- NULL

# salvo lens e tolgo lens e death days
cens <- selected_surv$Censored
selected_surv$Death_Days <- NULL
selected_surv$Censored <- NULL

# calcolo numero di osservazioni, osservazioni censurate e non
N <- dim(selected_long)[1]

# salvo numero di soggetti e numerosità di ogni gruppo
I = length(selected_sub)
J = (selected_long %>% group_by(subject_id) %>% summarise(t_count = sum( !is.na(t) ) ) )$t_count

# salvo indici di ogni paziente
n = 0
Subjects = rep(NA, N)
for (i in 1:I) {
  for (j in 1:J[i]) {
    Subjects[n+j] <- i
  }
  n <- n + J[i]
}

# sistemo cens
delta <- ifelse(is.na(T_life), 0, 1 )
T_life[which(delta == 0)] <- cens[which(delta == 0)]

# aggiungo intercetta
selected_long = cbind(intercept = rep(1, dim(selected_long)[1]), selected_long)
selected_surv = cbind(intercept = rep(1, dim(selected_surv)[1]), selected_surv)

# elimino colonne subject
selected_long$subject_id <- NULL
selected_surv$subject_id <- NULL

# salvo le dimensioni di queste matrici
K_plus = dim(selected_long)[2]
P_plus = dim(selected_surv)[2]

# salvo i tempi
timepoints <- selected_long$t

# matrice di covarianza iniziale per D e vettore medie
#Sigma <- matrix(c(1,0,0,1), 2,2, byrow = T)
mu_D <- c(0,0)



###### STAN

stan_data <- list(N = N, 
                  K = K_plus,
                  P = P_plus,
                  I = I,
                  J = J,
                  Subjects = Subjects,
                  FVC = y,
                  Timepoint = timepoints,
                  X_Lon = selected_long,
                  X_Sur = selected_surv,
                  T_life = T_life,
                  cens = delta,
                  mu_mean_D = mu_D
)


# init_s = function(){
#   list(
#     T_life_mis = rep(1,mis_N)
#   )
# }

timer <- proc.time()
fit1 <- stan(file = "Stan_Model_UltimoControllo.stan", 
             data = stan_data,
             warmup = 75,
             iter = 1000, 
             chains = 1, 
             thin = 10,
             cores = 1,
             # init = init_s,
             verbose = TRUE,
             seed = 42
             #control = list(adapt_delta = 0.80)
)
time.taken <- proc.time() - timer

save(fit1, file = "Stan_Fit_UltimoControllo.RData")

# dat = load(file = "Stan_Fit_UltimoControllo.RData") 


print(fit1, 
      probs = c(0.025, 0.5, 0.975), 
      par = c('rho', 'lambda_surv'))

print(fit1, 
      probs = c(0.025, 0.5, 0.975), 
      par = c('beta_longitud'))
names(selected_long)
# [1] "intercept"                        "t"                                "Age"                             
# [4] "Sex"                              "BMI"                              "Q1_Speech"                       
# [7] "Q2_Salivation"                    "Q3_Swallowing"                    "Q10_Respiratory"                 
# [10] "Respiratory_Rate"                 "Onset_Site_Bulbar"                "Onset_Site_Limb"                 
# [13] "Onset_Site_Limb.Bulbar"           "Onset_Site_Other"                 "Race_Americ_Indian_Alaska_Native"
# [16] "Race_Asian"                       "Race_Black_African_American"      "Race_Caucasian"                  
# [19] "Race_Hispanic"                    "Race_Other" 
rstan::extract(fit1, par = c('beta_longitud'))

print(fit1, 
      probs = c(0.025, 0.5, 0.975), 
      par = c('sigma','gamma1','gamma2'))


rho = 6.92
lamd = 1.8
lamd*gamma(1+1/rho) * 365
x = seq(0,1, by = 0.01)
Y = dweibull(x, shape = r, scale = w2)
plot(x,Y, type = 'l')



beta_l_post = extract(fit1, pars = c('beta_longitud'), permuted = T)$beta_longitud
beta_s_post = extract(fit1, pars = c('beta_survival'), permuted = T)$beta_survival
rho_post = extract(fit1, pars = c('rho'), permuted = T)$rho
gamma1_post = extract(fit1, pars = c('gamma1'), permuted = T)$gamma1
gamma2_post = extract(fit1, pars = c('gamma2'), permuted = T)$gamma2
sigma_post = extract(fit1, pars = c('sigma'), permuted = T)$sigma
Lcorr_post = extract(fit1, pars = c('Lcorr'), permuted = T)$Lcorr
sigmaD_post = extract(fit1, pars = c('sigmaD'), permuted = T)$sigmaD




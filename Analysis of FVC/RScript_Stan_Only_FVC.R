

# COMPUTER TONY
setwd("~/Politecnico di Milano/Gilda Matteucci - PROGETTO BAYESIANA/Modified_Data/Filtered_NEW/LongitudinalSurvival_Model/ULTIMA SPERANZA")

library(rstan)
library(dplyr)
library(brms)
library(tidyverse)

dat = read.csv("Dataset_Rielaborato.csv", header = T)

# tempi in anni
dat$t = dat$t / 365
dat$Onset_Delta = dat$Onset_Delta / 365
dat$Diagnosis_Delta = dat$Diagnosis_Delta / 365

less_9_months = (dat %>% group_by(subject_id) %>% summarise(t_max = max(t)) %>% filter(t_max <= 0.75))$subject_id
dat = dat[dat$subject_id %in% less_9_months,]

# death e cens inutili
dat$Death_Days = NULL
dat$Censored = NULL

# tolgo colonne con solo nulli
dat$Onset_Site_Other = NULL
dat$Race_Americ_Indian_Alaska_Native = NULL
dat$Race_Hispanic = NULL

# FVC in 0-1 anzichè percentuale
dat$meanPCT = dat$meanPCT / 100

# peso in quintali
dat$Final_Weight = dat$Final_Weight / 100

# altezza in m
dat$Final_Height = dat$Final_Height / 100

# ordino le righe per subject e t
dat <- dat[with(dat, order(subject_id, t)), ]


# seleziono 300 random subjects
set.seed(500)
sub <- unique(dat$subject_id)
selected_sub <- sort( sample(sub, 300) )

# dati per predizione
not_selected <- setdiff(sub, selected_sub)
not_dat = dat[which(dat$subject_id %in% not_selected ),]

# estraggo le corrispondenti covariate per ogni tempo
dat <- dat[which(dat$subject_id %in% selected_sub ),]


# loo(fit3)
# kfold(fit3, K = 10)
# prov = sample(not_selected, 1)
# new_d = not_dat[which(not_dat$subject_id %in% prov ),]
# d = brms::predictive_interval(fit3, new_d) 

##########################################
######### INSERISCI QUI I VALORI #########
##########################################

nchain = 3
ncore = 3
warmup = 1000
iter = 2000
refresh = 100
thin = 1

timer <- proc.time()
fit4 = brm(data = dat,
           family = gaussian,
           formula = meanPCT ~ 1 + t + (1 + t || subject_id) + BMI + Age + Sex + Respiratory_Rate +
             Q10_Respiratory + Onset_Delta + Q1_Speech + Q2_Salivation + Q3_Swallowing + Albumin.g.L +
             Onset_Site_Bulbar + Onset_Site_Limb + Onset_Site_Limb.Bulbar,
           prior = c(prior(normal(0, 10), class = Intercept),
                     prior(normal(0, 10), class = b),
                     prior(cauchy(0, 1), class = sd),
                     prior(cauchy(0, 1), class = sigma)),
           iter = iter, warmup = warmup, chains = nchain, cores = ncore, refresh = refresh, thin = thin,
           control = list(adapt_delta = .975, max_treedepth = 10),
           seed = 312053)
time.taken <- proc.time() - timer

save(fit4, time.taken, file = "Only_FVC.RData")

# load(time.taken, file = "Only_FVC.RData")

print(fit4)
plot(fit4)

subj_fitted = sample(dat$subject_id, 6)
dat %>%
  bind_cols(as_tibble(fitted(fit4))) %>%
  group_by(subject_id) %>%
  nest() %>%
  filter(subject_id %in% subj_fitted) %>%
  unnest() %>%
  ggplot() +
  geom_point(aes(x = t, y = meanPCT), size = 4, alpha = .75, color = "dodgerblue2") +
  geom_point(aes(x = t, y = Estimate), shape = 1, size = 4, stroke = 1.5) +
  labs(x = "t",
       y = "FVC %",
       title = "Model 1: Two Random Effects, 13 Covariates + times",
       subtitle = "Blue points are observed values. Black circles are fitted values.") +
  scale_x_continuous(expand = c(.075, 0.075), breaks = seq(0,0.8, by = 0.2), 
                     labels=c("0","1 M.", "2 M.", "3 M.", "4 M.")) +
  scale_y_continuous(expand = c(.075, 0.075), breaks = seq(0,1.3, by = 0.2)) + 
  facet_wrap(~ subject_id, nrow = 1) +
  theme_bw(base_size = 14) +
  theme(plot.title = element_text(hjust = .5))



dat %>%
  bind_cols(as_tibble(fitted(fit4))) %>%
  ggplot() +
  geom_line(aes(x = t, y = Estimate, group = subject_id), size = .75, alpha = .30) +
  geom_line(aes(x = t, y = meanPCT, group = subject_id), size = .75, alpha = .15, color = "dodgerblue2") +
  labs(x = "t",
       y = "FVC %",
       title = "Model 1: Two Random Effects, 13 Covariates + times",
       subtitle = "Blue lines are observed values. Black lines are fitted.") +
  theme_minimal(base_size = 16) +
  theme(plot.title = element_text(hjust = .5))


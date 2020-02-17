data {
  int<lower=1> N;  //number of total observations
  
  int<lower=1> K; // number of covariates in longitudinal (with intercept!)
  int<lower=1> P; // number of covariates in survival (with intercept!)
  
  int<lower=1> I; //number of subjects
  int<lower=1> J[I]; // numerosity in each subject
  int<lower=1> Subjects[N]; // index of subject
  
  vector[N] FVC; //FVC for each patient at each time
  
  vector[N] Timepoint; // vettore di tempi
  
  matrix[N,K] X_Lon; // matrice covariate longitudinal model
  
  matrix[N,P] X_Sur; // matrice covariate survival model
  
  vector[N] cens; // vettore con 1 o 0 a seconda che il paziente sia morto o no
  
  real<lower = 0, upper = 36500> T_life[N];
  
  vector[2] mu_mean_D; // media (nulla) per multivariata su random effect
  
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  
  vector[K] beta_longitud; // vector of beta for longitudinal regression
  vector[P] beta_survival; // vector of beta for survival regression
  
  // parametri per LKJ
  cholesky_factor_corr[2] Lcorr;
  vector<lower=0>[2] sigmaD; 
  
  real<lower=0> sigma; // variance of epsilon
  
  real<lower=0, upper = 7> rho; // parametro della Weibull
  
  real<lower=0> gamma1; // coeff di U1
  real<lower=0> gamma2; // coeff di U2
  
  // multivariata random effect
  matrix[I,2] U;
  
  // survival time for missing subjects
  // real<lower=0, upper = 36500> T_life_mis[mis_N]; 
}

transformed parameters{
  
  vector[N] mu_longitud;
  vector[N] mu_surv;
  vector[N] W1;
  vector[N] W2;
  real<lower=0> lambda_surv[N];
  
  mu_longitud = X_Lon * beta_longitud;
  mu_surv = X_Sur * beta_survival;
  
  for(n in 1:N){
    W1[n] = U[Subjects[n],1] + U[Subjects[n],2] * Timepoint[n];
    W2[n] = gamma1 * U[Subjects[n],1] + gamma2 * U[Subjects[n],2]* Timepoint[n];  
    lambda_surv[n] = exp( -(mu_surv[n] + W2[n] ) / rho );
  }
  
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  
  // prior per errore
  sigma ~ cauchy(0, 5);
  
  // prior beta longitudinal
  for(k in 1:K){
    beta_longitud[k] ~ normal(0, 50);
  }
  
  // prior beta survival
  for(p in 1:P){
    beta_survival[p] ~ normal(0, 50);
  }
  
  // prior sui gamma
  //gamma1 ~ normal(0,20);
  //gamma2 ~ normal(0,20);
  gamma1 ~ gamma(4,3);
  gamma2 ~ gamma(4,3);
  
  // prior su rho
  rho ~ cauchy(0, 5);
  
  // prior su D
  sigmaD ~ cauchy(0, 5);
  Lcorr ~ lkj_corr_cholesky(1);
  
  for(i in 1:I){
    // distribuzione delle U1 e U2
    U[i,] ~ multi_normal_cholesky(mu_mean_D, diag_pre_multiply(sigmaD, Lcorr));
  }
  
  // FVC 
  FVC ~ normal(mu_longitud + W1, sigma);
  
  for(i in 1:N){
    
    if(cens[i] == 0){
      T_life[i] ~ weibull(rho, lambda_surv[i] );
    } else {
      target += weibull_lccdf(T_life[i] | rho, lambda_surv[i]); 
    }
    
  }
  
}

generated quantities {
  matrix[2,2] Omega;
  matrix[2,2] Sigma;
  Omega = multiply_lower_tri_self_transpose(Lcorr);
  Sigma = quad_form_diag(Omega, sigmaD); 
}

data {
  int<lower=1> N;  //number of total observations
  
  int<lower=1> K; // number of covariates in longitudinal (with intercept!)
  
  int<lower=1> I; //number of subjects
  int<lower=1> Subjects[N]; // index of subject
  
  vector[N] FVC; //FVC for each patient at each time
  
  vector[N] Timepoint; // vettore di tempi
  
  matrix[N,K] X; // matrice covariate longitudinal model
  
  vector[2] mu_mean_D; // media (nulla) per multivariata su random effect
  
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  
  vector[K] beta; // vector of beta for longitudinal regression
  
  // parametri per LKJ
  cholesky_factor_corr[2] Lcorr;
  vector<lower=0>[2] sigmaD; 
  
  real<lower=0> sigma; // variance of epsilon
  
  // multivariata random effect
  matrix[I,2] U;
  
}

transformed parameters{
  
  vector[N] mu;
  vector[N] W1;
  
  mu = X * beta;
  
  for(n in 1:N){
    W1[n] = U[Subjects[n],1] + U[Subjects[n],2] * Timepoint[n];
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
    beta[k] ~ normal(0, 50);
  }
  
  // prior su D
  //D ~ inv_wishart(4., S);
  sigmaD ~ cauchy(0, 5);
  Lcorr ~ lkj_corr_cholesky(1);
  
  for(i in 1:I){
    // distribuzione delle U1 e U2
    U[i,] ~ multi_normal_cholesky(mu_mean_D, diag_pre_multiply(sigmaD, Lcorr));
  }
  
  // FVC 
  FVC ~ normal(mu + W1, sigma);
  
}


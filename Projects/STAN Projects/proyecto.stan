data {
  int<lower=1> T;            // Numero de observaciones
  real y[T];                 // Datos
}
parameters {
  real mu;                   // Media
  real phi;                  // Coeficiente de autoregresion
  real theta;                // Coeficiente movil
  real<lower=0> sigma;       // Ruido
}
model {
  vector[T] nu;              // prediccion al tiempo t
  vector[T] err;             // Error al tiempo t
  nu[1] = mu + phi * mu;     // Asumimos err[0] == 0
  err[1] = y[1] - nu[1];
  for (t in 2:T) {
    nu[t] = mu + phi * y[t-1] + theta * err[t-1];
    err[t] = y[t] - nu[t];
  }
  mu ~ normal(0, 1);        // Distribuciones a priori
  phi ~ normal(0, 1);
  theta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  err ~ normal(0, sigma);
}

?cars
head(cars)

plot(cars)

reg.1 <- lm(formula = dist ~ speed, data = cars)
reg.1

plot(cars)
abline(reg.1, col = "red")

# Coeficientes
reg.1$coefficients
coef(reg.1)

# Valores ajustados o estimados de Y
fitted(reg.1)

# Residuales ^Y - Y
residuals(reg.1)


# Sacar estadísticos para evaluar mi modelo
sum.reg.1 <- summary(reg.1)
sum.reg.1

# MSE
MSE <- mean(residuals(reg.1) ^ 2)
RSE <- (sum(residuals(reg.1) ^ 2) / 48) ^ .5 # n - p - 1
RSE

# R2
TSS <- mean( (cars$dist - mean(cars$dist)) ^ 2)
R2 <- (TSS - MSE) / TSS # El mejor de los casos R2 --> 1, y en el peor --> 0

# R2 ajustada
sum.reg.1$adj.r.squared

# R2 predictivo
# Cross-validation (bootstraping)
# LOOCV - Leave one out cross validation
# 5-k fold
# 10-k fold
library(tidyverse)
loocv <- 1:nrow(cars) %>%
  map(~ lm(dist ~ speed, data = cars, subset = -.x)) %>%
  imap_dbl(~ predict(.x, data.frame(speed = cars$speed[.y]))) %>%
  imap_dbl(~ (.x - cars$speed[.y])^2)
loocv

plot(cars$speed, loocv)

loocv <- 1:nrow(cars) %>%
  map(~ lm(dist ~ speed, data = cars, subset = -.x)) %>%
  map(summary) %>%
  map_dbl("adj.r.squared")

plot(density(loocv))

k5fold.fun <- function() {
  
  # Dividan en 5 grupos los datos
  cars2 <- cars %>%
    as_tibble() %>%
    mutate(
      grupo = rep(1:5, each = nrow(cars) / 5),
      grupo = sample(grupo, n())
    )
  
  res <- 1:5 %>%
    map(~ lm(dist ~ speed, cars2, subset = !(cars2$grupo == .x))) %>%
    imap_dbl(~{
      # Agarro grupo excluido
      conj.prueba <- filter(cars2, grupo == .y)
      
      # Hago predicciones sobre grupo excluido
      pred <- predict(.x, conj.prueba)
      
      # Claculo R2
      TSS <- mean((conj.prueba$dist - mean(conj.prueba$dist)) ^ 2)
      MSE <- mean((pred - conj.prueba$dist) ^ 2)
      R2 <- (TSS - MSE) / TSS # Coeficiente de validación
      
      return(R2)
    })
  
  return(res)
  
}

mean(k5fold)

x <- filter(cars2, grupo == 2)
points(x = x$speed, y = x$dist, col = "blue", cex = 1.5)

# boostraping
k5fold.fun()
res <- map(1:1000, ~ k5fold.fun())

res2 <- res %>%
  map_dbl(mean)


plot(density(res2))



##### Analisis residual
library(moments)

plot(residuals(reg.1))
plot(cars)

# Sesgo
skewness(residuals(reg.1))

# Curtosis
# b > 3 leptocúrtica más apuntada y con colas más gruesas que la normal.
# b = 3 mesocúrtica cuando tiene una distribución normal.
# b < 3 platicúrticamenos apuntada y con colas menos gruesas que la normal.
kurtosis(residuals(reg.1))

residuals(reg.1) %>%
  density() %>%
  plot()

# Prueba de normalidad
shapiro.test(residuals(reg.1))

# Independencia de nuestro error
plot(co2)
acf(co2)

acf(residuals(reg.1))

plot(reg.1)

### Extender nuestra suposición de relación lineal
# dist = b + m * speed
# dist = b + m * log(speed)
plot(cars)
plot(cars, log = "x")
plot(cars, log = "xy")

reg.2 <- lm(log(dist) ~ log(speed), cars)
reg.2
summary(reg.1)
summary(reg.2)

fit.lin <- fitted(reg.1)
fit.log <- exp(1) ^ fitted(reg.2)

plot(cars)
lines(x = cars$speed, y = fit.lin, col = "orange")
lines(x = cars$speed, y = fit.log, col = "blue")

# reg.log
MSE.2 <- mean((fit.log - cars$dist) ^ 2) 
R2.log <- (TSS - MSE.2) / TSS
R2
R2.log

# Polinomial
reg.3 <- lm(dist ~ poly(speed, 2), cars)
summary(reg.3)
coef(reg.3)
# 42.98 + 145.55 * x + 22.99 * x^2 + x^3
fit.poly <- fitted(reg.3)
lines(x = cars$speed, y = fit.poly, col = "green")

### Análisis de normalidad de residuales
residuals(reg.2) %>%
  density() %>%
  plot()

skewness(residuals(reg.2))
kurtosis(residuals(reg.2))

shapiro.test(residuals(reg.2))

install.packages(C('ISLR', 'MASS', 'car', 'moments', 'class'))

?cars
head(cars)

plot(cars)

reg.1 <- lm(formula = dist ~ speed, data = cars)
reg.1

plot(cars)
abline(reg.1, col = "red")

# Coeficientes
reg.1$coefficients
coef(reg.1)

# Valores ajustados o estimados de Y
fitted(reg.1)

# Residuales ^Y - Y
residuals(reg.1)


# Sacar estadísticos para evaluar mi modelo
sum.reg.1 <- summary(reg.1)
sum.reg.1

# MSE
MSE <- mean(residuals(reg.1) ^ 2)
RSE <- (sum(residuals(reg.1) ^ 2) / 48) ^ .5 # n - p - 1
RSE

# R2
TSS <- mean( (cars$dist - mean(cars$dist)) ^ 2)
R2 <- (TSS - MSE) / TSS # El mejor de los casos R2 --> 1, y en el peor --> 0

# R2 ajustada
sum.reg.1$adj.r.squared

# R2 predictivo
# Cross-validation (bootstraping)
# LOOCV - Leave one out cross validation
# 5-k fold
# 10-k fold
library(tidyverse)
loocv <- 1:nrow(cars) %>%
  map(~ lm(dist ~ speed, data = cars, subset = -.x)) %>%
  imap_dbl(~ predict(.x, data.frame(speed = cars$speed[.y]))) %>%
  imap_dbl(~ (.x - cars$speed[.y])^2)
loocv

plot(cars$speed, loocv)

loocv <- 1:nrow(cars) %>%
  map(~ lm(dist ~ speed, data = cars, subset = -.x)) %>%
  map(summary) %>%
  map_dbl("adj.r.squared")

plot(density(loocv))



k5fold.fun <- function() {
  
  # Dividan en 5 grupos los datos
  cars2 <- cars %>%
    as_tibble() %>%
    mutate(
      grupo = rep(1:5, each = nrow(cars) / 5),
      grupo = sample(grupo, n())
    )
  
  res <- 1:5 %>%
    map(~ lm(dist ~ speed, cars2, subset = !(cars2$grupo == .x))) %>%
    imap_dbl(~{
      # Agarro grupo excluido
      conj.prueba <- filter(cars2, grupo == .y)
      
      # Hago predicciones sobre grupo excluido
      pred <- predict(.x, conj.prueba)
      
      # Claculo R2
      TSS <- mean((conj.prueba$dist - mean(conj.prueba$dist)) ^ 2)
      MSE <- mean((pred - conj.prueba$dist) ^ 2)
      R2 <- (TSS - MSE) / TSS # Coeficiente de validación
      
      return(R2)
    })
  
  return(res)
  
}

mean(k5fold)

x <- filter(cars2, grupo == 2)
points(x = x$speed, y = x$dist, col = "blue", cex = 1.5)

# boostraping
k5fold.fun()
res <- map(1:1000, ~ k5fold.fun())

res2 <- res %>%
  map_dbl(mean)


plot(density(res2))



##### Analisis residual
library(moments)

plot(residuals(reg.1))
plot(cars)

# Sesgo
skewness(residuals(reg.1))

# Curtosis
# b > 3 leptocúrtica más apuntada y con colas más gruesas que la normal.
# b = 3 mesocúrtica cuando tiene una distribución normal.
# b < 3 platicúrticamenos apuntada y con colas menos gruesas que la normal.
kurtosis(residuals(reg.1))

residuals(reg.1) %>%
  density() %>%
  plot()

# Prueba de normalidad
shapiro.test(residuals(reg.1))

# Independencia de nuestro error
plot(co2)
acf(co2)

acf(residuals(reg.1))

plot(reg.1)

### Extender nuestra suposición de relación lineal
# dist = b + m * speed
# dist = b + m * log(speed)
plot(cars)
plot(cars, log = "x")
plot(cars, log = "xy")

reg.2 <- lm(log(dist) ~ log(speed), cars)
reg.2
summary(reg.1)
summary(reg.2)

fit.lin <- fitted(reg.1)
fit.log <- exp(1) ^ fitted(reg.2)

plot(cars)
lines(x = cars$speed, y = fit.lin, col = "orange")
lines(x = cars$speed, y = fit.log, col = "blue")

# reg.log
MSE.2 <- mean((fit.log - cars$dist) ^ 2) 
R2.log <- (TSS - MSE.2) / TSS
R2
R2.log

# Polinomial
reg.3 <- lm(dist ~ poly(speed, 2), cars)
summary(reg.3)
coef(reg.3)
# 42.98 + 145.55 * x + 22.99 * x^2 + x^3
fit.poly <- fitted(reg.3)
lines(x = cars$speed, y = fit.poly, col = "green")


residuals(reg.3) %>%
  density() %>%
  plot()

skewness(residuals(reg.3))
kurtosis(residuals(reg.3))

shapiro.test(residuals(reg.3))

# Intervalo de confianza
int.m <- confint(reg.2, level = .99)[2,]
m <- coef(reg.2)[2]
# log(dist) = m * log(speed)



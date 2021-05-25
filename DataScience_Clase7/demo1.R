library(class)
library(ggplot2)

#Creacion de datos sinteticos
set.seed(2020)
x <- runif(50, min = 0, max = 10)
set.seed(2021)
y <- runif(50, min = 0, max = 10)

demo <- data.frame(x = x, y = y, class = 0)

for(i in 1:nrow(demo)){
  if(demo[i,2] > -1*demo[i,1]+10){
    demo[i,3] <- 1
  }
}

demo$class <- as.factor(demo$class)

ggplot(demo, aes(x, y, color = class)) +
  geom_point() +
  geom_abline(slope = -1, intercept = 10)

# Prediciendo observaciones
n_observacion <- data.frame(x = 6, y = 5)
pred <- knn(demo[,-3], n_observacion, demo[,3])

ggplot(demo, aes(x, y, color = class)) +
  geom_point() +
  geom_point(aes(x = n_observacion$x, y = n_observacion$y, color = pred))

#Probando diferentes valores de k
predicciones <- data.frame(k = seq(1,10), pred = 0, prob = 0)
predicciones$pred <- factor(predicciones$pred, levels = c(0,1))

for(i in 1:nrow(predicciones)){
  predicciones[i,2] <- knn(demo[,-3], n_observacion, demo[,3], k = i, prob = T)
  predicciones[i,3] <- attr(knn(demo[,-3], n_observacion, demo[,3], k = i, prob = T), "prob")
}

ggplot(predicciones, aes(x = k, y = prob, color = pred)) +
  geom_point()

set.seed(1996)
x2 <- runif(10, min = 0, max = 10)
set.seed(1997)
y2 <- runif(10, min = 0, max = 10)

conj_prueba <- data.frame(x = x2, y = y2, class = 0)

for(i in 1:nrow(conj_prueba)){
  if(conj_prueba[i,2] > -1*conj_prueba[i,1]+10){
    conj_prueba[i,3] <- 1
  }
}

conj_prueba$class <- as.factor(conj_prueba$class)

ggplot() +
  geom_point(aes(x = demo$x, y = demo$y, color = demo$class)) +
  geom_point(aes(x = conj_prueba$x, y = conj_prueba$y), color = "blue")

pred_comp <- knn(demo[,-3], conj_prueba[,-3], demo[,3])
matriz_conf <- table(conj_prueba[,3], pred_comp)

1 - (length(which(as.numeric(conj_prueba[,3])-as.numeric(pred_comp) != 0))/nrow(conj_prueba))

pred_comp <- matrix(ncol = nrow(conj_prueba), nrow = 20)
error <- rep(0,nrow(pred_comp))

for(i in 1:nrow(pred_comp)){
  pred_comp[i,] <- knn(demo[,-3], conj_prueba[,-3], demo[,3], k = i)
  error[i] <- 1 - (length(which(as.numeric(conj_prueba[,3])-as.numeric(pred_comp[i,]) != 0))/nrow(conj_prueba))
}

ggplot() +
  geom_point(aes(x = seq(1,nrow(pred_comp)), y = error))

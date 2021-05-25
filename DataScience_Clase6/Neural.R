library(ISLR)
library(neuralnet)

datos <- College
View(datos)
str(datos)

max_datos <- apply(datos[,2:18],2,max)
min_datos <- apply(datos[,2:18],2,min) # 1: filas; 2:columnas

datos_escalados <- scale(datos[,2:18], center = min_datos, scale = max_datos - min_datos)
datos_escalados

datos$Private

privada <- as.numeric(datos$Private)
universidad  <- cbind(privada, datos_escalados)
str(universidad)

indice <- sample(1:nrow(datos), round(0.8, nrow(datos)))
train <- as.data.frame(universidad[indice,])
test <- as.data.frame(universidad[-indice,])
length(test$privada)


deep_net1 <- neuralnet(privada~., data = train, hidden = c(5,3))
plot(deep_net1, rep = "best")

prediccion <- compute(deep_net1, test[,2:18])
print(head(prediccion$net.result))

prediccion$net.result <- sapply(prediccion$net.result, round, digits = 0)
error <- table(test$privada, prediccion$net.result)
precision <- sum(error[1,1], error[2,2]) / sum(error[1,1],sum(error[1,2],sum(error[2,1],sum(error[2,2])
                                                                             
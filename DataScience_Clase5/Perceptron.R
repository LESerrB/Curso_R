# Crear un conjunto de datos
N <- 50 # Num  de observaciones
gap <- 0.5

x <- runif(N,0.1)
y <- runif(N,0.1)

x2 <- runif(N,0+gap,1+gap)
y2 <- runif(N,0+gap,1+gap)

eje_x <- c(x,x2)
eje_y <- c(y,y2)
plot(eje_x, eje_y, type = "n", xlab = "X", ylab = "Y")
points(x,y,col = "blue")
points(x2,y2,col = "red")

w0 <- 0.1
w1 <- 0.2
w2 <- 0.3

M <- 15
lr <- 0.005
umbral <- 0.9
pred_j <- 0
comp <- c(rep(-1,N),rep(1,N))

for (i in seq.int(M)) {
  indice <- seq.int(2*N) # Creamos un índice para lopear todos los conjuntos
  indice <- sample(indice)
  
  for (j in indice) {
    y_j <- w0 + w1 * eje_x[j] + w2*eje_y[j]
    pred_j <- if (y_j < 0) -1 else 1
    
    # Backpropagation
    w1 <- w1 + (comp[j] - pred_j)*eje_x[j]*lr
    w2 <- w2 + (comp[j] - pred_j)*eje_y[j]*lr
    w0 <- w0 + lr * (comp[j] - pred_j)
    
  }
  
  valor_y <- w0 + w1 * eje_x + w2 * eje_y
  y_pred <- ifelse(valor_y < 0, -1, 1)
  acc <- sum(y_pred == comp) / length(comp) # Error medio
  
  print(paste("Número:", i, "precision", acc))
  
  if (acc >= umbral) break
  
}

w0
w1
w2

plot(eje_x, eje_y, type = "n", xlab = "X", ylab = "Y")
points(x,y,col = "blue")
points(x2,y2,col = "red")
abline(a=-w0/w2,b=-w1/w2,col="black",lwd=3,lty=2)

# Punto de prueba
x1 <- runif(1,0,1+gap)
y1 <- runif(1,0,1+gap)
prueba <- w0 + w1 * x1 + w3 * x2
points(x1,y1,col="green")

if(prueba == 1){
  print("Es manzana")
}else{
  print("Es naranja")
}


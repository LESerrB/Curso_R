# **5- Introducción a redes neuronales artificiales**

## **Perceptrón**
```r
### Diseñar un perceptrón:
# Vamos a tener 2 conjuntos de datos en x y y
# El objetivo es construir un perceptrón que
# nos clasifique a que conjunto pertenecen (Problema de Clasificación)

# 1- Conjunto de datos
N <- 50 # Nº de observaciones
gap <- .5

x <- runif(N, 0, 1)
y <- runif(N, 0, 1)

x2 <- runif(N, gap, 1 + gap)
y2 <- runif(N, gap, 1 + gap)

eje_x <- c(x, x2)
eje_y <- c(y, y2)

plot(y~x, pch = 20, col = "red", xlim = c(0, 1+gap), ylim = c(0,1+gap))
points(y2~x2, pch = 20, col = "blue")

# 2- Definir parámetros iniciales:

# bias/sesgo
w0 <- .1

# pesos
w1 <- .2
w2 <- .3

# Epoch, número de repeticiones
M <- 100

# Tasa de aprendizaje. Qué tan rápido tiene que converger el algoritmo
lr <- .005 # .005 a 1

# Precisión del umbral
umbral <- .9

# Variable de salida
pred_j <- 0

# Los verdaderos valores. Es el objetivo
comp <- c(rep(-1,N),rep(1,N))

# Función de activación
# Utilizaremos una función hardlim
# x < 0 --> -1
# x >= 0 --> 1

# 3- Modelo
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

# Graficar los resultados
plot(comp~seq.int(2*N), pch = 20, type = "h")
points(y_pred~seq.int(2*N), pch = 20, col = "blue")

plot(eje_x, eje_y, type = "n", xlab = "X", ylab = "Y")
points(x,y,col="blue")
points(x2,y2,col="red")
abline(a=-w0/w2,b=-w1/w2,col="black",lwd=3,lty=2)

# Prueba
x1 <- runif(1, 0, 1+gap)
y1 <- runif(1, 0, 1+gap)

prueba <- if (w0 + w1 * x1 + w2 * y1 < 0) -1 else 1
points(x1, y1, col = "green")
if(prueba == 1) print("Manzana") else print("Naranja")
```

## **Redes Neuronal Artificial**
```r
# Diseñar una red neuronal
# Obj: Predecir el número de resistencia residual de unas
#   pruebas de yates. Buscamos definir si su desempeño
#   es apropiado para pruebas posteriores.
library(tidyverse) # Manipular datos
library(neuralnet)
library(GGally)

url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00243/yacht_hydrodynamics.data"

yate <- read_table(url, col_names = c(
  "Flotabilidad",
  "Coe_pris",
  "Long_desp",
  "viga_tiro",
  "long_vira",
  "Num_froude",
  "res_resid"
)) %>%
  na.omit()

View(yate)

# Matriz de dispersión de las características de las variables
ggpairs(yate, title = "Matriz de dispersi´n de las características de las variables")

# Escalar los datos para que no sesguen
escala <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

yate <- yate %>%
  mutate_all(escala)

# Separar en conjuntos de entrenamiento y prueba
# Utilizaremos el enfoque de validación 80-20
set.seed(123)

yate_entrena <- sample_frac(yate, .8) # 80% muestra de yate
yate_prueba <- setdiff(yate, yate_entrena) # o anti_join(yate, yate_entrena)

# Modelo 1
NH1 <- neuralnet(
  res_resid ~ .,
  data = yate_entrena
)

NH1$net.result # Prediciones
NH1$weights # Pesos
plot(NH1, rep = "best")
NH1_SSE <- sum( (NH1$net.result - yate_entrena[,7]) ^ 2 ) / 2

# Vamos a probarlo
NH1_prueba <- compute(NH1, yate_prueba[,1:6])$net.result
NH1_SSE <- sum( (NH1_prueba - yate_entrena[,7]) ^ 2 ) / 2

# Desescalarlos
salida_real <- (NH1_prueba * max(yate_prueba[,7]) - min(yate_prueba[,7]))+min(min(yate_prueba[,7]))
data.frame(NH1_prueba, salida_real)

# Modelo con capas ocultas
NN2 <- neuralnet(
  res_resid~., yate_entrena,
  hidden = c(4,1),
  act.fct = "tanh" # Cambiamos de la sigmoid a la tangente hiperbólica como función de activación
)
plot(NN2, res = "best")
```

## **Bibliografía y referencias**

## **Libros**

### **Deep Learning with R**

Escrito por el creador de Keras y el creador de Keras en R, es el libro perfecto para introducirse a conceptos de deep learning y usar ejemplos en R.

[](https://www.amazon.com/Deep-Learning-R-Francois-Chollet/dp/161729554X)

### **Deep Learning in R**

[Deep Learning with R | Abhijit Ghatak | Springer](https://www.springer.com/gp/book/9789811358494)

### **The Deep Learning Books**

Este libro es la biblia del deep learning. Es una lectura mucho mas formal, extensa y agnóstico de lenguajes. Si quieren de verdad aprender esta ciencia, deben leer esto:

[Deep Learning](https://www.deeplearningbook.org/)

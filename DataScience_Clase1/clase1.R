#### Vectores ####
a <- c(4, 3.5, 7.8, 10.1, 16.7)
a

assign("b", c(3, 4, 5, 6))
b
get("b") == b # Comparacion

x <- c(a, b, 12.3, 14)

#### Operaciones ####
2*x
1/x
x^2
x^.5
sqrt(x)
2e5
2e-6

length(x)
length(a)
a + x
c(1, 2) + c(1, 2, 3, 4)

rep(c(12,16,17,73,86), 5) * c(12, 10, 32, 10, 5) # "rep" repite las veces indicadas el vector
y <- 2*c(1, 2, 3, 4) + c(3, 4, 5, 6)

#### Operadores Logicos ####
5 < 4
6 >= 6
2^2 == 4
3 != 6
!(5 > 4)

edad <- 18
nombre <- "Luis"
(edad < 18) & (nombre == "Luis")

nombres <- c("Jaime", "Pablo", "Chris")
nombres %in% c("Chris", "Pablo")

edades <- c(18,13,34,56,11)
mayores <- edades > 25
edades[mayores]

#### Reciclaje ####
c(1,2) * c(1,2,3,4)
c(1,2) + c(1,2,3,4,5)
c(TRUE, FALSE) | c(TRUE, TRUE, FALSE, FALSE)

paste(c("Hola"), c("Mundo"))
x <- c(1,2,3,4,5,6,7)
paste0(c("x","y"), x)

#########################################################################

#### Funciones en R ####
# Jerarquia de variables
# Logical < Numeric < Caracter
x <- c(1,2,3,4,5)
y <- c(TRUE, FALSE, TRUE, FALSE)
length(x)      # Numero de elementos en un vector
mode(x)        # Tipo de vector
mode(y)
is.numeric(x)  # Verifica si el vector es del tipo especificado
is.numeric(y)

#### Funciones estadisticas ####
mediaX <- mean(x)
sumaX <- sum(x)
medaMiax <- sum(x) / length(x) # Promedio propio
varX <- var(x) # Variancia
# E((x - E(x))^2) --> Variancia poblacional
# sum(x - E(x)) / length(x) - 1 --> Variancia muestral
varMiaX <- mean((x - mean(x))^2)
sd(x) # Desviacion estandar
var(x) ^ .5
#///// ? + funcion abre ayuda de la funcion /////#
cor(x, c(2,4,7,1,10)) # Correlacion
cor(x, c(2,4,7,1,10), method = "kendall") # Correlacion usando metodo Kendall
cov(x, c(2,4,7,1,10)) # Covarianza
range(x) # Rango
median(x) # Mediana
min(x)
max(x)
#### Funciones utiles ####
rev(x) # Ordena a la inversa
sort(x) # Ordena el vector
sort(x, decreasing = TRUE)
order(x) # Devuelve los indices ordenados

#### Funciones Trigonometricas ####
sin(2*pi)
cos(0)
cos(pi)

#### Valores especiales ####
NA # No hay dato
NA | TRUE
is.na(NA)
x <- c(23,73,199,NA,342,NaN,43)
x + 2
mean(x)
mean(x, na.rm = TRUE)

NaN # No es un numero
is.na(x)
is.nan(x)
mean(x, na.rm = TRUE)

NULL

Inf * -1

Inf - Inf

#### Generacion de vecores con funciones ####
1:10
-9:100
100:-9
seq(from = 1, to = 10, by = .1)
seq(length = 50, from = 1, to = 100)
seq_along(x)
1:length(x)

rep(1,10)
rep(1:3, times = 3, each = 4)

#### Aleatorio ####
# r(distribucion)
runif(25) # Distribucion uniforme
runif(1, min=10, max=50)
round(runif(1) * 40 + 10) # Enteros

ceiling(12.00001)
floor(12.00001)

x <- rnorm(300, mean = 0, sd = 1)
plot(density(x))
y <- cut(x, breaks = 7)
table(y)
plot(cut(x, breaks = 7))

#########################################################################
##################
# Funcion        #
# 2x^2 - 5*x + 3 #
##################
x <- seq(1, 20, by = 0.000001)
y <- 2*x^2 - 5*x + 3
#plot(x = x, y = y, pch = 20)
# (x1-x0)*y0 + ((y1-y0)*(x1-x0))/2
x_0 <- x[1:(length(x)-1)]
x_1 <- x[2:length(x)]
y_0 <- y[1:(length(x)-1)]
y_1 <- y[2:length(x)]
AreaCuad <- sum(((x_1 - x_0) * y_0) + ((y_1 - y_0) * (x_1 - x_0) / 2))
AreaCuad

#########################################################################

#### Filtros de datos ####

# Hay 2 tipos de vectores
# > Atómicos
#   - Numéricos
#   - Booleanos
#   - Caracteres
# > Listas
#   - Varios tipos en el mismo vector
#   - Dataframes: todos los elementos tienen la misma longitud

# 1)Filtro por booleano
x <- runif(5,10,30)
filtro <- x > 20
x[filtro] # Solo devuelve aquellos que sean "TRUE"
x[x > 20]

# 2)Filtro por índice
x[4]
x[4] <- 6
x[1:3]
x[c(2,4)]

# 3)Filtro por nombre
precios <- c("piña" = 25, "toronja" = 15, "manzana" = 10)
precios["toronja"]
precios["manzana"]
names(precios)
precios[c("manzana", "toronja")]
FiltroMzn <- names(precios) == "manzana"
names(precios)[FiltroMzn] <- "naranja"
precios

# 4) Filtro por negacion
x <- runif(5,10,30)
x[!(x > 20)] # Negacion booleana
x[-3] # Negacion de indices
x[-(1:3)]

#########################################################################

#### Listas ####
lista1 <- list(
  a = 1:10,
  b = rep(c(TRUE,FALSE), 4),
  c = letters[1:20]
)
lista1
names(lista1)
str(lista1)
head(lista1)
lista1[c(TRUE,FALSE,TRUE)]
lista1[1]
lista1["c"]
lista1[-1]
# Acceder a datos de una lista
lista1[[1]]
is.numeric(lista1[[1]])
lista1[["c"]]
lista1$a
lista1$a == lista1[[1]]
lista1$b

lista2 <- list(
  a = 1:10,
  b= lista1
)

#### Dataframe ####
mi_tabla <- data.frame(
  edad = round(runif(3,15,40), 0),
  nombre = c("Crrs", "daneil", "fes"),
  son.unam = TRUE
  )
mi_tabla
View(mi_tabla)
colnames(mi_tabla)
rownames(mi_tabla)

# Importar *.csv
patient <- read.csv("patient.csv")
View(patient)
str(patient)

patient[patient == ""] <- NA # Substituir "" por NA
datosgenero <- patient$sex[!(is.na(patient$sex))] # Extrae la columna de Sexo
datosgenero <- as.factor(datosgenero)
datosest <- patient$state[!(is.na(patient$sex)) & !(is.na(patient$state))] # Extrae la columna de Sexo

table(datosest, datosgenero)
 
plot(datosgenero)
barplot(
  table(datosest, datosgenero),
  col = c("red", "blue", "green"),
  legend = rownames(table(datosest, datosgenero))
)

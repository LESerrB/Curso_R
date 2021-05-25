# Control Flow
saludar <- function(nombre, cumpleaños){
  if(cumpleaños & nombre == "Pablo")
    paste0("¡¡¡Felicidades ", nombre, '!!!')
  else if(cumpleaños)
    paste0("¡¡¡Felicidades ", nombre, '!!!')
  else
    paste0("Hola ", nombre)
}

saludar("Pablo", TRUE)
saludar("Pablo", FALSE)

# Vectorizar if
edades <- round(runif(5, min = 16, max = 65), 0)
res <- ifelse(edades > 35, "Mayor a 35 años", "Menor o igual a 35 años")
res
# switch
item <- "atun"
pago <- 0
pago <- switch (
  item,
  manzana = 15,
  papel = 30,
  atun = 100
)

items <- c("atun", "manzana", "naranjas", "pizza")
dplyr::case_when(
  items == "atun" ~ 100,
  items == "manzana" ~ 15,
  items == "papel" ~ 30
)

compra <- data.frame(items = c("atun", "manzana", "naranjas", "pizza"))
compra$precio <- dplyr::case_when(
  compra$items == "atun" ~ 100,
  compra$items == "manzana" ~ 15,
  compra$items == "papel" ~ 30
)

compra
sum(compra$precio, na.rm = TRUE)

# while
i <- 0
while (i < 100) {
  print(i)
  i <- i + 1 # Lo mas importante
}

# next fuerza a la siguiente iteración
# break parar la ejecución
i <- -1
while (i < 100) {
  i <- i + 1
  
  if (i %% 2 == 0) { # Es par
    print(i)
    next
  }
  
  if (i > 50) {
    break
  }
  
}

# factorial
i <- 0
f <- 100 # 5!
res <- 1
repeat {
  
  if (f < 0) {
    res <- NaN
    warning("No uses números negativos")
    break
  }
  
  if (f == i) break
  
  i <- i  + 1
  res <- res * i
}
res

# Ejecuta una función por cada elemento del vector que le pase
# Valor del vector
for (i in 1:20) {
  print(i)
}
for (i in letters) {
  print(i)
}

# índice
compra <- c("Naranjas", "Manzanas", "Atun")
for (i in seq_along(compra)) {
  print(paste(i, compra[i], sep = " - "))
}

# nombres
compra <- c(Naranjas = 15, Manzanas = 10, Atun = 100)
for (i in names(compra)) {
  print(paste0("El precio de ", i , " es: ", compra[i]))
}

# Matrices
x1 <- 1:25
dim(x1) <- c(5,5)
x1
# Filtrar matrices
x1[x1 > 10]
x1[1,] # [filas, columnas]
x1[2:3, 3:4]
x1[2:3, 3:4] <- NA
x1

nrow(x1) # num filas
ncol(x1) # num columnas
dim(x1) # Vector de dimensiones
colnames(x1) <- month.abb[1:5]
rownames(x1) <- c("2000", "2001", "2002", "2003", "2004")
x1
# Iterar usandofamilia de Apply

# Iteración con la familia de purrr

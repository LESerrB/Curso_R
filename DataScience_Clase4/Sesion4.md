# **Más ciencia de datos**

## Bases de datos SQL y operaciones Joins
```r
# * Como utilizar bases datos relaciones dentro de R
#   - joins
#   - querys
# * Control flow en R
#   - Decidir que código se ejecuta y cual no
#   - Iterar
# * Series de tiempo
#   - Modelos y algunos pronósticos
# Sección especial: gráficas interactivas
library(nycflights13)
flights

# RDBMS Relational Database Management Systems como:
# MySQL y MariaDB --> Driver: RMariaDB
# SQLite <- RSQLite
# PostreSQL --> RPostres
# ODBC --> odbc
# Muchos mas... googlear un poco
library(tidyverse)
library(dbplyr)
library(DBI) # R manejar conexiones DB
library(RPostgres)

# usuario con permisos de lectura
db <- dbConnect(
  Postgres(), # Driver
  user = 'alumno',
  password = 'drlh6m4jrvwlo4bh',
  dbname = 'nycflights',
  host = 'db-512-r-prueba-do-user-7269609-0.a.db.ondigitalocean.com', # o google.com
  port = 25060, # 5432
  sslmode = 'require' # VPN
)

dbListTables(db)
dbExistsTable(db, "airports") # Existe esa tabla en la DB
dbListFields(db, "flights") # Ver las variables o columnas

query <- 'select * from flights limit 10'
res <- dbSendQuery(db, query) # Prepara la query
resReal <- dbFetch(res) # Obtiene los datos
dbClearResult(res) # Limpia la conexión

# Queries en R
tbl(db, "flights") %>%
  group_by(carrier, tailnum) %>%
  summarise(avg_delay = mean(arr_delay)) %>% # Devuelve un solo dato
  show_query()

tbl(db, "flights") %>%
  group_by(carrier, tailnum) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  explain()

res <- tbl(db, "flights") %>%
  group_by(carrier, tailnum) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  collect()

ggplot(res) +
  geom_density(aes(avg_delay, fill = carrier)) +
  facet_wrap(~carrier) +
  xlim(c(-50, 50))

# Joins - Interactuar con varias tablas
# Mutate - 4
# Filter - 2
# Tabla - 3

# left_join siempre mantiene los datos de la izquierda
res <- tbl(db, "flights") %>%
  left_join(tbl(db, "planes"), by = c("tailnum" = "tailnum")) %>%
  collect()

# right_join siempre mantiene los datos de la derecha

# full_join
res <- tbl(db, "flights") %>%
  full_join(tbl(db, "airlines"), "carrier") %>%
  select(month, carrier) %>%
  group_by(month, carrier) %>%
  summarise(count = n()) %>%
  arrange(month, desc(count)) %>% # Ordenar
  collect()

# inner_join
set.seed(1)
a <- tibble(
  carrier = c("E9", "BO", "EC", "FF", "AA"),
  dato = runif(5)
)

b <- tibble(
  carrier = c("E9", "BO", "EC", "AA", "CC", "E9"), # Si hay mas datos, se crean cuantas filas
  dato = runif(6)
)

left_join(a, b, "carrier")
right_join(a, b, "carrier")
inner_join(a, b, "carrier")
full_join(a, b, "carrier")

# Busca los vuelos de 4 aerolíneas
# sample_n(4) También pueden indicar replace = 
res <- tbl(db, "airlines") %>%
  filter(carrier %in% c("9E", "B6", "MQ", "AA")) %>% # También pueden indicar replace = 
  inner_join(tbl(db, "flights"), "carrier") %>%
  group_by(carrier) %>%
  summarise(count = n()) %>%
  collect()

# Joins con varias llaves
tbl(db, "flights") %>%
  left_join(tbl(db, "weather"), by = c("year" = "year", "month", "day", "origin"))
  
# Filter - semi_join y anti_join
semi_join(a, b, "carrier") # Datos en a que existan en b
anti_join(a, b, "carrier") # Datos en a que no existan en b

tbl(db, "flights") %>%
  semi_join(tbl(db, "airlines"), "carrier") %>%
  summarise(count = n()) %>%
  collect()

# Por tablas iguales - Se llaman set joins
A <- tibble(
  a = c(1, 3, 4, 5, 8, 9),
  b = c(2, 4, 2, 4, 5, 1)
)
B <- tibble(
  a = c(1, 3, 4, 5, 8, 9),
  b = c(2, 2, 2, 4, 8, 2)
)

intersect(A, B) # Existan tanto en A como en B
rbind(A, B) # Unimos filas
union(A, B) # Unimos filas únicas

setdiff(A, B) # Existe en A pero no en B
setdiff(B, A) # Existe en B pero no en A

dbDisconnect(db)

# API con JSON
# API Application Programing Interface - Servicio HTTP
# Puedes:
# - Pedir información GET - Analizando datos
# - Crear usarios POST
# - Borrar DELETE
# - Actualizar con PATCH

# HTTP/S
# Yo en mi casa pueda comunicarme de una manera estandarizada con servidores
# en cualquier parte del mundo.
# Host: dirección de donde está el servidor  <- 192.134.132.123
# Request:
# GET google.com/
# ...
# ...
# Respuesta
# OK 200
# documento HTML
# imágenes

# Datos --> XML y los JSON
library(xml2) # xml
# JSON
library(jsonlite)

# https://reqres.in/api/users?page=2
library(httr)
library(jsonlite)

# Request
# - URL:
# host: google.com o regreq.in
# path: /api/users
# verbo: GET
# query: ?page=2
# https://reqres.in/api/users?page=2

library(httr) # Comandos de HTTP
library(jsonlite) # JSON

res <- GET(
  "https://reqres.in/",
  path = "/api/users",
  query = list(page = 2)
)

miDato <- content(res, as = "text")
usuarios <- fromJSON(miDato)
```

## Control flow

```r
# ctrl + shift + f10 limpiar todo
# ctrl + l limpiar consola

# Control flow: regula el flujo de la ejecución de las funciones o scripts

# Siempre hay que usar vectores lógicos de un elemento
if (TRUE) print("Es verdadero")
if (FALSE) print("Es verdadero") else print("Es falso")

y <- if (9 == 9) TRUE else FALSE
y <- if (9 != 9) TRUE else FALSE

saludar <- function (nombre, cumpleaños) {
  if (cumpleaños & nombre == "Pablo") {
    paste0("¡¡¡Felicidades ", nombre, '!!!')
  } else if (cumpleaños) {
    paste0("Felicidad ", nombre)
  } else {
    paste0('Hola ', nombre)
  }
}

saludar("Pablo", TRUE)
saludar("Pablo", FALSE)
saludar("Jaime", TRUE)

# Vectorizar if
edades <- round(runif(5, min = 16, max = 65), 0)
res <- ifelse(edades > 35, "Mayor a 35 años", "Menor o igual a 35 años")
res

# paquetería::funcion
dplyr::if_else
dplyr::case_when()

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

# FUnciones normales
nrow(x1) # num filas
ncol(x1) # num columnas
dim(x1) # Vector de dimensiones
colnames(x1) <- month.abb[1:5] # Nombres de columnas
rownames(x1) <- c("2000", "2001", "2002", "2003", "2004") # Nombres de filas
x1

# Funciones específicas a matrices
t(x1) # transpuestas

x2 <- matrix((1:25)*2, nrow = 5, ncol = 5)
x2

x1 * x2
x1 %*% x2 # Producto matricial o cruz
sum(x1[1,] * x2[,1]) # Comprobación

# Ecuaciones lineales A * x = B
A <- matrix(c(3,1,2,1), nrow = 2)
B <- c(x = 8, y = 2)
A
solve(A, B)
A %*% solve(A) # Inversa
diag(A %*% solve(A)) # Diagonal

det(A)
eigen(A)

# Iterar usando familia de Apply
# Cuando queremos vectorar for? Las operaciones son independientes
# apply - data.frames y matrices
x1
promFilas <- apply(x1, 1, mean, na.rm = TRUE)
varPColumnas <- apply(x1, 2, function(x) mean( (x - mean(x))^2 ) ) # Función anónima
varP <- function(x) mean( (x - mean(x))^2 )
varPColumnas <- apply(x1, 2, varP ) # Función escrita en otra parte

# lapply devuelve una lista
mtcars
a <- summary(mtcars$mpg)
resumen <- lapply(mtcars, summary)

# sapply devuelve un vector
iqr <- sapply(resumen, function(x) x[5] - x[2])
iqr

# mapply
res2 <- mapply(rep, 1:4, 4) # rep(1, 4) rep(2, 4) rep(3, 4) rep(4, 4)
res2

# tapply
region <- factor(c("Sonora", "EDO", "EDO", "CDMX", "CDMX", "CDMX"))
levels(region) # Categorías
precio <- c(300, 400, 200, 700, 600, 1000)

tapply(precio, region, mean)
tapply(precio, region, min)

# Iteración con la familia de purrr
library(tidyverse)
library(purrr)

res <- map(mtcars, mean)
res <- map_dbl(mtcars, mean)
# _chr, _lgl, _int, _dbl, _raw, _df, dfc, dfr

# Variantes de map
# modify es como map_{el vector inicial}
# walk - Para crear side-effects
# imap - map con índices
# map2 y pmap, walk2 o pwalk - varias entradas
walk(mtcars, function(x, y) print(mean(x, y)), na.rm = TRUE)
walk(mtcars, ~ print(mean(.x, na.rm = .y)), na.rm = TRUE)

imap_chr(colnames(mtcars), ~ paste(.y, .x, sep = ". "))

# map2 y pmap
map2(letters[1:10], letters[11:20], paste)
map2_chr(letters[1:10], letters[11:20], paste)
pmap(list(x = 1:2, y = 1:2, z = 1:2), paste)
pmap_chr(list(x = 1:2, y = 1:2, z = 1:2), paste)

# Caso práctico
formulas <- list(
  mpg ~ disp,
  mpg ~ disp + wt,
  mpg ~ I(1 / disp),
  mpg ~ I(1 / disp) + wt
)

res <- formulas %>%
  map(lm, data = mtcars) %>%
  map(summary) %>%
  map_dbl("adj.r.squared")

res
```

## **Bibliografía y referencias**
### **Libros**
### Interactive web-based data visualization with R, plotly, and shiny
Uno de los libros de referencia para la creación de visualizaciones interactivas webs.

[Interactive web-based data visualization with R, plotly, and shiny](https://plotly-r.com/)

**Geocomputation with R**

R tiene un potencial muy grande en el tratamiento de información geográfica, desde su manipulación, cálculo hasta su visualización. Este libro es un buen lugar por donde empezar.

[Geocomputation with R](https://geocompr.robinlovelace.net/index.html)

**Advanced R**

Todo el libro es muy bueno para entender realmente como funciona R. No recomiendo que intenten leerlo de primeras, sino que mejor familiarícense mucho con la interfaz de R y luego consulten este libro. Pero en el contexto de esta sesión el capítulo 9 de mucho contexto de `purrr`.

[Advanced R](https://adv-r.hadley.nz/)

**Distributions for Modelling Location, Scale and Shape: Using GAMLSS in R**

Si alguna vez buscan ajustar una muestra a la mejor distribución de probabilidad que lo describa, esta paquetería tiene todas las distribuciones y una sola función llamada `fitDist` que lo hace todo por ti. Además hay un libro entero de como usarlo:

[](https://www.gamlss.com/wp-content/uploads/2018/01/DistributionsForModellingLocationScaleandShape.pdf)

### Forecasting: Principles and Practice

Gran libro para utilizar R en el campo del pronóstico, especialmente en ambientes de negocio.

[Forecasting: Principles and Practice](https://otexts.com/fpp3/index.html)

## **Referencias onlines**

### **La galería más extensa de gráficos en R**

[The R Graph Gallery - Help and inspiration for R charts](https://www.r-graph-gallery.com/)

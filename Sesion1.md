# **1. Introducción a R**
## **1.1 Asignación de Vectores**
`R` es un lenguaje de programación `vectorizado`, es decir, todos los objetos que almacenan información son un conjunto de múltiples datos.

```r
# Se crean vectores con c()
c(1,2,3,4,5) # Vector numérico de 5 elementos
c("Hola", "Mundo", "Esto es una frase") # Vector de carácter de 3 elementos
c(TRUE, FALSE, FALSE, TRUE) # Vector booleano de 4 elementos

# Se pueden crear vectores de un solo elemento sin necesidad de usar c()
1 # Sigue siendo un vector numérico con un solo elemento
"Hola"
TRUE

# Se asignan a una variable con <-
a <- c(4, 3.5, 7.8, 10.1, 16.7)
assign("a", c(4, 3.5, 7.8, 10.1, 16.7)) # Otra forma de asignación

# Ahora a contiene el vector numérico de c(4, 3.5, 7.8, 10.1, 16.7)
# Puedes imprimirlo escribiéndolo y ejecutándolo
a # Debería imprimir [1]  4.0  3.5  7.8 10.1 16.7
get("a") # Otra forma de imprimir o conseguir el vector de a

# Puedes crear vectores más grandes usando otros vectores ya creados
b <- c(a, 10.3, 7.8, a)
d <- c(a, b, a)
```

`R` es sensitivo a las mayúsculas —> x y X son diferentes nombres.

## **1.2 Operadores aritméticos, boleanos y reciclaje**

### **Operadores numéricos**

```r
# e exponencial en base 10
2e5 # Lo mismo que 2 * 10 ^ 5

# + - Suma y resta
1 + 2 - 3

# * / %% Multiplicación, división y residuo
5 * 4
3 / 2
3 %% 2

# ^ exponencial
2 ^ 5
4 ^ .5 # Raíz cuadrada usando exponentes
4 ^ -.5

# () paréntesis
(1 + 2) * 3

# Todos los operadores anteriores están ordenados jerárquicamente
# El paréntesis siempre tiene mas precedencia, después la exponencial y demás
```

### **Operadores booleanos**

```r
# ! negación
!TRUE # [1] FALSE

# | operador "or"
FALSE | TRUE
TRUE | TRUE
FALSE | FALSE

# & operador "and"
TRUE & TRUE
FALSE & FALSE
TRUE & FALSE | TRUE & TRUE # El operador "and" tiene mayor precedencia

# < <= > >== == != comparaciones
5 > 4
6 == 5 | 5 != 4

# Todos los operadores anteriores están ordenados jerárquicamente

# Los siguientes son funciones, no tienen mayor precedencia entre ellos
# pero se pueden pensar como operadores:
# A %in% B el elemento A está contenido dentro de B?
c(1, 2, 3, 4) %in% c(2, 4, 6) # [1] FALSE  TRUE FALSE  TRUE
c("Hola", "mundo") %in% c("Adios", "Palabras", " ", "mundo") # [1] FALSE  TRUE

# xor(a, b) exclusive or
xor(TRUE, TRUE) # [1] FALSE
xor(TRUE, FALSE) # [1] TRUE
xor(FALSE, TRUE) # [1] TRUE
xor(FALSE, FALSE) # [1] FALSE

# all() todos los elementos del vector deben ser verdaderos
all(TRUE) # [1] TRUE
all(FALSE) # [1] FALSE
all(c(TRUE, TRUE, TRUE, TRUE)) # [1] TRUE
all(c(TRUE, FALSE, TRUE, TRUE)) # [1] FALSE
all(c(TRUE, TRUE, TRUE, TRUE), c(TRUE, FAlSE)) # [1] FALSE
all(c(TRUE, TRUE, TRUE, TRUE), c(TRUE, TRUE)) # [1] TRUE

# any() alguno de los elementos es TRUE?
any(c(FALSE, FALSE)) # [1] FALSE
any(c(FALSE, TRUE, FALSE, FALSE), c(FALSE, FALSE)) # [1] TRUE
```

El operador `booleano` de igualdad son dos símbolos de igual `==`. Un único símbolo `=` es una asignación. Esto es una causa común de error.

### **Reciclaje**

La naturaleza vectorizada de R causa que cualquier operación se realice sobre todos los elementos de los vectores.

```r
2 * c(1, 2, 3) # [1] 2 4 6
# Se recicla el elemento 2 y se multiplica por todos los elementos del segundo vector

c(1, 2) + c(1, 2, 3, 4) # [1] 2 4 4 6
# Primero se suma 1 + 1 y 2 + 2. Cuando el primer vector se acaba, se recicla
# y se suma 1 + 3 y 2 + 4

a <- c(4, 3.5, 7.8, 10.1, 16.7)
b <- c(a, 1, a)
2 * b + a + 1 # [1] 13.0 11.5 24.4 31.3 51.1  7.0 12.5 15.8 26.7 37.9 38.4
# Operación desglosada:
# 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 *
# 4, 3.5, 7.8, 10.1, 16.7, 1, 4, 3.5, 7.8, 10.1, 16.7 +
# 4, 3.5, 7.8, 10.1, 16.7, 4, 3.5, 7.8, 10.1, 16.7, 4 +
# 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

# También ocurre lo mismo con boleanos y caracteres
c(1, 2, 3, 4, 5) >= 4 # [1] FALSE FALSE FALSE  TRUE  TRUE
c(1, 2) != c(1, 2, 1, 1, 3, 2, 2) # [1] FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE
c("Hola", "AB", " ", "") == "" # [1] FALSE FALSE FALSE  TRUE
c("Hola", "ab", "") == c("Hola", "AB", "") # [1]  TRUE FALSE  TRUE
```
## **1.3 Funciones comúnes y propias**
Una función tiene:

- `Argumentos`: son una o varias entradas de datos. En R puedes ingresar los argumentos en orden o usando el nombre, y para la mayoría de los argumentos ya existe un valor por default.
- `Transformación`
- `Retorno`: devuelve un resultado o se genera un cambio en el ambiente

La mayoría de las funciones tienen dos naturalezas:

- Usan todos los datos de un vector y devuelven un solo resultado (ej: mean)
- Realizan una transformación en todos los elementos y devuelven un vector (ej: paste)

Puedes encontrar la documentación de cualquier función usando:

`?nombre_de_función`, ej: `?mean`

```r
# Las siguientes son funciones comúnes de R
length(c(1, 2, 3) # Devuelve el número de elementos que posee un vector [1] 3
mode(c("Hola", "Mundo")) # Tipo de vector [1] "character"

max(c(1, 2, 3)) # Devuelve el número mas alto
min(c(1, 2, 3)) # Devuelve el número mas bajo
asb() # Valor absoluto
sum(c(1, 2, 3)) # Suma todos los elementos del vector
prod(c(1, 2, 3)) # Multiplican todos los elementos del vector
sqrt(4) # Raíz cuadrada
log(16, 2) # Logarítmo de 16 en base 2
log2() # Logarítmo base 2
log10() # Logarítmo base 10
exp() # número de euler elevado a cualquier número exp(1) == número de Euler

round(1457.445454543534, 3) # Redondea hasta el tercer decimal
signif(1457.445454543534, 3) # Redondea hasta la tercera cifra significativa
trunc(1457.445454543534, 3) # Trunca hasta la tercera decimal
ceiling(17.1) # Redondeo para arriba
floor(17.1) # Redondeo para abajo

# Números aleatorios (algunos ejemplos)
runif(10, min = 0, max = 1) # Dame 10 números aleatorios que sigan la distribución
# uniforme con parámetro mínimo = 0 y máximo = 1
rnorm(10, mean = 0, sd = 1) # Dame 10 números aleatorios que sigan la distribución
# normal con parámetro media = 0 y desviación estándar = 1

rev(c(1,2,3)) # Pone al revés el vector [1] 3 2 1
sort(runif(10)) # Ordena el vector de manera ascendente
sort(runif(10), decreasing = TRUE) # Ordena el vector de manera descendiente
order(runif(10)) # Lo mismo que sort pero devuelve los índices ordenados

# Funciones trigonométricas (existen todas, solo voy a escribir unos ejemplos)
sin(2*pi)
cos(0)
cos(pi)
tan()
sinh()

mean(c(1, 2, 3)) # Promedio
median()
range(c(1, 2, 3, 4, 5)) # Rango de datos
var() # Varianza muestral
sd() # Desviación estándar muestral
quantile(c(1, 2, 3, 4, 5)) # Quartiles 0% 25% 50% 75% 100%
summary(c(1, 2, 3, 4, 5)) # Retorna un resúmen de algunos datos estadísticos descriptivos
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#       1       2       3       3       4       5
# No existe la función de moda, aunque hay varias paqueterías que las implementan

cor() # Correlación. Se puede escoger el método con
# method = c("pearson", "kendall", "spearman"). Por default es "pearson"
cor(c(1, 2, 3), c(2, 3, 4), method = "pearson")
cor(c(1, 2, 3), c(2, 3, 4), method = "kendall")
cov(c(1, 2, 3), c(2, 3, 4), method = "pearson") # Covariancia muestral
cov(c(1, 2, 3), c(2, 3, 4), method = "kendall")

nchar(c("Hola", "ab")) # Cuenta el número de caracteres [1] 4 2
paste(c("x", "y"), c(1,2,3,4,5), sep = " ") # Une los caracteres usando un separador,
# por default se usa un espacio y se reciclan [1] "x 1" "y 2" "x 3" "y 4" "x 5"
paste0() # Lo mismo que paste pero sin separadores
toupper("a") # Se pone en mayúscula
tolower("AAa") # Minúscula
strsplit("Hola este es un texto con espacios", " ") # Separa cada elemento usando
# el segundo argumento, en este caso un espacio.
# [1] "Hola"     "este"     "es"       "un"       "texto"    "con"      "espacios"
sub("a","s", "Substituye las as por ss") # En este caso solo se hace una vez
gsub("a","s", "Substituye las as por ss") # Se buscan todas las "a"s

# Familia de funciones is
is.numeric(1) # [1] TRUE
is.logical(TRUE) # [1] TRUE
is.character("A") # [1] TRUE
# Existen muchas mas funciones de este tipo que pueden explorar

# Otras funciones que vale la pena que investiguen:
Reduce
integrate
optim
uniroot
polyroot
```

### **Funciones para crear otros vectores**

```r
1:5 # Equivalente a c(1,2,3,4,5)
-1:5 # c(-1,0,1,2,3,4,5)
100:90 # c(100, 99, 98, 96, 95, 94, 93, 92, 91, 90)

seq(from = 0, to = 1, by = .1) # Crea una secuencia desde 0
# a 1 usando un paso de 0.1 [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0
seq(-5, -100, .01) # No hace falta poner los nombres si se usan en orden

seq_along(100:105) # Es equivalente a 1:length(100:105) [1] 1 2 3 4 5 6
# Es mejor usar seq_along ya que si el vector tiene 0 elementos
# devuelve 0. En cambio 1:1:length(c()) devuelve [1] 1 0

rep("Hola", times = 5) # [1] "Hola" "Hola" "Hola" "Hola" "Hola"
rep("Hola", 5) # No hace falta usar nombres si se ponen en orden
rep(c(1,2,3), times = 5, each = 2) # Se repite cada elemento 2 veces,
# y el resultado se repite 5 veces
# [1] 1 1 2 2 3 3 1 1 2 2 3 3 1 1 2 2 3 3 1 1 2 2 3 3 1 1 2 2 3 3
```

### **Funciones propias**

En R puedes crear tus propias funciones.

```r
# Variancia poblacional
varPob <- function(x) mean( (x - mean(x))^2 ) # La función devolverá el valor de esta operación
varPob(x = 1:10) # [1] 8.25
varPob(1:10) # [1] 8.25 Como usamos el argumento en orden no hace falta poner el nombre

# Si tu función necesita hacer varios pasos puedes envolverlo en {}
saludar <- function(nombre, edad) {
	nombre <- toupper(nombre)
	edad <- round(edad, 0)
	
	paste0("Hola ", nombre, ". Veo que tienes ", edad, " años.") # Devolverá la última expresión
}
saludar("Jaime", 12) # [1] "Hola JAIME. Veo que tienes 12 años."

# Puedes crear funciones que acepten muchos argumentos que no conozcas
propiaFun <- function(a, b, ...) {
	# ... es una lista de los argumentos adicionales
	paste(..1, ..2) # ..1 y ..2 se refieren al primer y segundo elemento adicional.
	# Puedes usar esto para todos los elementos adicionales.
}
propiaFun(NULL, NULL, "Hola", "mundo") # [1] "Hola mundo"
```

## **1.4 Valores especiales**
R utiliza un conjunto de valores especiales que representan un concepto de programación.

### **NA**
`NA` representa un dato que no tenemos, no es un error sino indicación.

```r
# Pueden ser usados en cualquier parte porque son un valor válido
x <- c(1, 2, 3, NA, 5)
c(TRUE, NA, NA, TRUE)
c("Hola", "A", NA, "B", NA)

# Si siguen la filosofía de que representan un dato que no conocen
# es muy fácil entender las operaciones. Por ejemplo:
1 + NA # El resultado es NA porque 1 + algo que no conozco
# da como resultado algo que no conozco
TRUE | NA # Da TRUE porque da igual lo que sea NA siempre resulta
# en TRUE la anterior expresión
FALSE & NA # Siempre da FALSE por lo mismo

mean(x) # NA porque x contiene un NA, pero podemos filtrarlo con
mean(x, na.rm = TRUE) # [1] 2.75
# na.rm se puede utilizar en casi cualquier función

NA == NA # Da como resultado NA porque no sabes si son iguales
is.na(x) # Devuelve TRUE en los elementos que sean NA
# [1] FALSE FALSE FALSE  TRUE FALSE
```

### **NaN**
`NaN` **Not a Number** representa un NA especial que resulta de operaciones matemáticas indeterminadas.

```r
0 / 0 # NaN no se sabe que resulta en esta operación

# Siguen siendo un tipo de NA
x <- c(1, 2, NA, NaN)
is.na(x) # [1] FALSE FALSE  TRUE  TRUE
# Esto es útil porque se filtran cuando usamos na.rm
# Para filtrar solo los NaN hay que usar:
is.nan(x) # [1] FALSE FALSE FALSE  TRUE
```

### **NULL**

`NULL` es un valor que representa 0 elementos o 0 argumentos. Es muy común que el valor por default de un argumento sea NULL, es equivalente a que el usuario no lo haya usado.

```r
# Al intentar usar NULL desaparece porque realmente es 0 elementos 
x <- c(NULL, 1, 2) # [1] 1 2

is.null(NULL) # [1] TRUE
is.na(NULL) # Es falso porque NA si representa un dato, solo no lo conocemos
```

### **Inf**

`Inf` representa infinito y sigue la lógica matemática.

```r
c(1, 2, Inf)
is.infinite(c(1, 2, Inf)) # [1] FALSE FALSE  TRUE

# Se pueden hacer operaciones con Inf
1 + Inf # Inf
-1 * Inf # -Inf
Inf ^ 0 # 1
Inf * 0 # NaN
1 / 0 # Inf
0 / 0 # NaN
Inf - Inf # No se sabe que infinito es mayor así que se usa NaN
```

## **1.5 Tipos de Vectores**
En R todos los datos están contenidos en vectores. Los dos tipo de vectores principales son: `vectores atómicos` y `listas`.

### **Vectores atómicos**
Todos los elementos de un vector atómico deben de ser del mismo tipo. Hay 6 tipos ordenados jerárquicamente:

1) Raw o Hexadecimales:

```r
c(0xF, 0xAAE) # Se convierten directamente a numéricos
# Solo son útiles en el contexto de manejo de memoria
```

2) Complex o Números Complejos

```r
c(2+5i, 3-2i)
sqrt(-4) # No funciona, pero usando i ya si
sqrt(-4+0i)
is.complex(c(2+5i, 3-2i))
is.numeric(1i) # R no considera los complejos como valores numéricos
```

3) Logical o Boleanos

```r
c(TRUE, FALSE)
is.logical()
```

4) Integer o Enteros (Numérico)

```r
c(1L, 3L, 5L) # La L solo representa un entero
is.integer()
```

5) Double o Punto Flotante (Numérico)

```r
c(10, 34.43, 32.747384)
is.double()
is.numeric() # TRUE tanto si es double o integer
```

6) Character o Caracteres

```r
c("A", "", " ", "\n", '"a"', "'a'") # \n representa un salto de párrafo
# Se puede usar "" o ''
# \ es un operador de escape
# \n salto de párrafo
# \" Lo puedes usar en "\"" para que solo se imprima "
# \' '\'' solo se imprime '
# \\ se imprime \
# \t tab
# \r retorno de carro
```

### **Mezcla de vectores atómicos**
No se pueden mezclar tipos de vectores atómicos, todo se convertirá al tipo más dominante.

```r
c(TRUE, FALSE, FALSE, 0) # Se convierte a [1] 1 0 0 0 porque aunque solo haya un número
# el tipo numérico es mas dominante. Numéricamente TRUE representa 1 y FALSE 0

c(TRUE, FALSE, FALSE, 0, 1, 3L, "A") # Todo se convierte a caracteres porque es mas dominante

as.numeric(c(TRUE, FALSE, FALSE)) # Convierte a este vector boleano a numérico
as.integer()
as.double()
as.character()
```

### **Listas**

Es un tipo de vector en el cual cada uno de sus elementos pueden ser de cualquier tipo. Básicamente es un conjunto que puede contener vectores atómicos, otras listas, funciones y/o referencias a si mismo.

```r
# Un vector atómico se construye con c(), una lista se construye con list()
a <- list(
	1:10,
	c("Hola", "Mundo"),
	list(runif(10), rep(TRUE, 10)) # Una lista puede tener otras listas contenidas
)

# Cada elemento puede tener un nombre
a <- list(
	a = 1:10,
	b = c("Hola", "Mundo"),
	c = list(
		numeros = runif(10),
		boleanos = rep(TRUE, 10))
)

# De hecho cada elemento de un vector atómico también puede tener nombres
# pero es mucho menos común usarlos ahí
precios <- c(manzana = 45, naranjas = 23, peras = 34)
```

### **Atributos**

Todo en R es un objeto, tanto los vectores como las funciones y otros. Esto significa que todo contiene una serie de atributos.

```r
attributes(1) # Devuelve una lista con todos los atributos de un objeto
# En este caso solo es un vector numérico sin ningún atributo, pero podemos crearle alguno:

goles <- c(4, 3, 5, 23, 2)
attr(goles, "temporada") <- "2019-2020" # Asignar el valor "2019-2020" al atributo temporada
# para el vector goles
attr(goles, "temporada") # Devuelve el atributo temporada

# Los atributos generalmente se pierden al hacer operaciones, pero hay algunos
# que no se pierden y son los mas importantes
# Nombres
edad <- c(Jose = 41, Maria = 33, Jesus = 53, Olivera = 23)
attributes(edad) # Ver todos los atributos, en este caso solo estará el de nombres
attr(edad, "names") # Tambien podemos obtenerlo específicamente con este comando
# Resultado c("Jose", "Maria", "Jesus", "Olivera")
names(edad) # De hecho names es tan importante que tiene una función propia
names(edad) <- c("Jose", "Roberto", "Diego", "Jaime") # Modificar los nombres

# Otro atributo es la clase. Define las estructuras agregadas
class()

# Las dimensiones definen la estructura de una matriz
dim()

# Tanto class como dim los veremos mas adelante en la sección de estructuras de datos agregados
```

## **1.6 Filtro de vectores atómicos y listas**
### **Vectores atómicos**

Hay 6 maneras básicas de filtrar un vector:

**1- Índice positivo**
```r
a <- c(4, 3.5, 7.8, 10.1, 16.7)
a[1] # Devuelve el primer elemento 4
a[3] # Devuelve el tercer elemento 7.8
a[length(a)] # Devuelve el último elemento 16.7
a[1:3] # Equivalente a a[c(1,2,3)] Devuelve el primer, segundo y tercer elemento
a[c(1,4)] # Devuelve el primero y cuarto elemento

b <- c(3,4)
a[b] # Devuelve el tercer y cuarto elemento de a
```

Es muy común equivocarse al filtrar varios elementos no consecutivos al poner una coma en vez de un vector.

```r
a[1,4] # No funciona
a[c(1,4)] # Si funciona
```

**2- Índice negativo**
```r
# Es lo mismo que índices negativos pero en ved de devolverlos, los excluye
(1:10)[-2] # Devuelve todo menos el segundo elemento
(1:10)[-c(1,7)] # Devuelve todo menos el primer y séptimo elemento
```

**3- Nombre**
```r
# Solo funciona si el vector tiene nombres
edad <- c(Jose = 41, Maria = 33, Jesus = 53, Olivera = 23)
edad["Jose"] # Devuelve el elemento llamado Jose 41
edad[c("Maria", "Jesus")] # Devuelve los elementos llamados Maria y Jesus
```

**4- Boleano**
```r
# Se introduce un vector lógico y solo se devuelve elementos en el cual el vector
# lógico es TRUE. Este método requiere que el vector lógico tenga la misma longitud
# que el vector de interes, si no lo fuera si utilizara reciclaje
a <- c(4, 3.5, 7.8, 10.1, 16.7)
a[TRUE] # Se recicla TRUE en todo el vector y se devuelven todos los elementos
a[rep(TRUE, 5)] # Equivalente al anterior

a[c(TRUE, FALSE, FALSE, TRUE, FALSE)] # Se devuelve el primer y cuarto elemento
# que corresponde con los TRUE

# Por si solo no es muy útil, mas bien se utilizan condiciones para obtener los vectores
# lógicos. Un ejemplo es conseguir todos los números mayores a 8.
condicion <- a > 8 # [1] FALSE FALSE FALSE  TRUE  TRUE
a[condicion] # [1] 10.1 16.7
a[a > 8] # Es equivalente a lo anterior

# Mayor a 5 y menor o igual a 13
a[a > 5 & a <= 13] # [1]  7.8 10.1
```

**5- Nada**
```r
a[] # Devuelve todos los elementos
# No es muy útil para vectores atómicos pero si para estructuras mas complejas como
# data.frames
```

**6- 0**
```r
a[0] # Siempre devuelve NULL, es útil para algunas pruebas pero casi siempre
# es irrelevante
```

### **Asignación mediante filtros**
A veces solo queremos asignarle nuevos valores a aquellos valores que filtramos, y eso se puede hacer sin ningún problema con todos los métodos de filtro.

```r
# Cambiar los valores mayores a 5 y menores o iguales a 13
a <- c(4, 3.5, 7.8, 10.1, 16.7)
a[a > 5 & a <= 13] <- c(8, 10)
a # [1] 4 3.5 8 10 16.7
```

### **Listas**

Las listas utilizan los mismo tipos de filtros pero tienen una peculiaridad:

- Pueden devolver una lista más pequeña con algunos elementos que hayamos escogido (Mismas técnicas que con vectores atómicos)
- Pueden devolver solo el elemento escogido (Hay que utilizar nuevos operadores)

### **Filtrar una lista más pequeña - []**

```r
# Listas más pequeñas, aunque solo tengan un elemento
a <- list(
	a = 1:10,
	b = rep(c(TRUE, FALSE), times = 5, each = 3),
	c = letters[1:10] # letters contiene los 24 caracteres del alfabeto ingles, estoy agarrando los primeros 10
)

a[1] # Devuelve una lista que contiene al primer elemento de la lista original
# equivalente a list(a = 1:10)
a[1:3] # list(a = 1:10, c = letters[1:10])
a["a"] # equivalente a a[1]
a[-2] # equivalente a a[c(1,3)]
```

### **Filtrar un solo elemento - [[]] y $**

```r
# Si no queremos una lista sino que nos devuelva uno de los elementos,
# tenemos dos operadores para ello
# [[]] Se puede usar el índice positivo o un nombre
a[["a"]] # Tiene que estar en comillas el nombre. Devuelve 1:10, sin estar en una lista
a[[2]] # Equivalente a a[["b"]]
# No se puede usar los demás métodos con este operador
# Este operador también se puede usar con vectores atómicos, pero no tiene
# mucha utilidad porque de por si siempre devuelve otro vector atómico

# Operador $, solo funciona con nombres
a$a # Es mas corto y conveniente que [[]] cuando conoces el nombre
a$b # No hace falta usar "", pero si se puede usar `` para nombres extraños
a$`c` # En este caso no es extraño pero en el futuro es probable que lo vean
# No se puede usar con vectores atómicos
```

### **Práctica de navegación en una lista con filtros**
```r
info <- list(
	nombre = c("Oliver", "Natalia", "Jorge", "Ivan", NA),
	apellido = c("Guevara", "Jimenez", "Sanchez", "Duarte", "Dominguez"),
	edad = c(34, NA, 17, 16, 40),
	gustos = list(
		comidaFav = c("Hamburguesas", "Papas", "Quesadillas", "Chilaquiles", "Papas"),
		bebidaFav = c("Agua", "Coca-cola", "Coca-cola", "Lipton", "Bud Light")
	)
)

# 1) Promedio de edad de aquellos que no consideran el agua su bebida favorita
condicion <- info$gustos$bebida != "Agua" # Si la condición es larga vale la pena usar una variable intermedia
# [1] FALSE  TRUE  TRUE  TRUE  TRUE
mean(info$edad[condicion], na.rm = TRUE) # [1] 24.33333

# 2) Nombres completos de aquellos cuya bebida favorita es la coca-cola
condicion <- info$gustos$bebida == "Coca-cola"
paste(sep = ", ", info$apellido[condicion], info$nombre[condicion]) # [1] "Jimenez, Natalia" "Sanchez, Jorge"

# 3) Comida favorita de aquellos que sean mayores de edad
condicion <- info$edad >= 18 & !is.na(info$edad) # Mayor de edad y no es NA
info$gustos$comidaFav[condicion]
```

## **1.7 Estructuras de datos agregados**
Los vectores atómicos y las listas son los bloques de construcción de otras estructuras de datos más complejos. Algunos ejemplos son:

### **Fechas**

Existen 3 tipos de vectores fecha y tienen las siguientes características:

- **Tipo:** Vectores dobles
- **Clases**: "Date", "POSIXct", "POSIXlt"
- **Formato estándar**: "YYYY-MM-DD", "YYYY-MM-DD HH:MM:SS"

**Date**
El primer tipo de fecha es aquel que describe el año, mes y día.

```r
fecha <- Sys.Date() 
typeof(fecha) #Imprimirá el tipo del vector "fecha" que es: "double"
class(fecha) #Imprimirá la clase del vector "fecha": "Date"

#Se comprueban las características de los *vectores fecha*
```

**Sys.Date**
```r
day1 <- Sys.Date() #Vector con la fecha del sistema donde se está ejecutando la función.
# Fecha desglosada 
# "YYYY-MM-DD"

**## Si se desea la fecha y hora del sistema** 

day1 <- Sys.time() #Devuelve un valor absoluto de fecha y hora que se puede convertir a varias zonas horarias. Este formato es idéntico a "as.POSIXct" que se estudiará más adelante
# Fecha, hora y zona horario desglosado: 
# "YYYY-MM-DD 00:00 UTC"
```

El **valor** del tipo del vector (double) representa el número de ***días*** desde 1970-01-01, y este se puede obtener con la función `unclass()`.

**as.Date**

Función para convertir caracteres y objetos de la clase "Fecha" que representan fechas de calendario.

```r
day2 <- as.Date("1970-01-28")
unclass(day2) #Se obtendrán la cantidad de días desde 1970-01-01

# > *27*
```

Si el vector carácter no maneja el formato de fecha estándar para R (`%Y-%m-%d`), se tendrá que especificar. La siguiente tabla describe algunas opciones de formato de fechas.

[Símbolos de fechas](https://www.notion.so/f2fc9231cd1e405888f15952717133cf)

```r
fechas <- c("17/02/2019", "23/8/2020", "1/12/2021")
fechas <- as.Date(fechas, format = "%d/%m/%Y")
fechas
# [1] "2019-02-17" "2020-08-23" "2021-12-01"

fechas <- c("Monday 23 of March 2020")
fechas <- as.Date(fechas, format = "%A %d of %B %Y")
fechas
# [1] "2020-03-23"
```

**date.time**

Los date.time describen el año, mes, día, hora, minuto y segundo de una fecha. R usa el formato POSIX (Portable Operating System Interface) para describir esta estructura.

Hay 2 formas de almacenar información de fecha y hora:

- `POSIXct` (ct: "calendar time")
- `POSIXlt` (lt: "local time")

`POSIXct` es el más simple y apropiado en el uso de ***data frames***. 

```r
fechahora_ct <- as.POSIXct("2020-03-27 19:00" , tz = "UTC") #Vector con la fecha y hora en la zona horaria deseada

#Veremos las características del vector:

typeof(fechahora_ct) #Imprimirá el tipo del vector "fechahora_ct" que es: "double"
attributes(fechahora_ct) #Imprimirá la clase del vector "fechahora_ct": 
						#"as.POSIXct" (por la fecha)
						#"as.POSIXt" (por la hora)
						#"tzone" (por la zona horario)
```

El **valor** del tipo del vector (double) representa el número de ***segundos*** desde 1970-01-01.

Los time zones `tz` disponibles se pueden checar en este [link](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Podemos observar la hora deseada en diferentes husos horarios con el atributo `tzone` (si al momento de la conversión da como resultado las 00:00, con formato 24 hrs, ésta se omitirá).

```r
day1 <- as.POSIXct("2020-03-25 20:12" , tz = "UTC")
structure(day1, tz = "Europe/Paris") #Se observará la fecha y hora del vector "day1" en Paris.
# Fecha desglosada: 
# "2020-03-25 21:12:00 CET"

****structure(day1, tz = "Asia/Tokyo") #Se observará la fecha y hora del vector "day1" en Tokyo.
# Fecha desglosada:
# "2020-03-26 05:12:00 JST"

structure(day1, tz = "America/New_York") #Se observará la fecha y hora del vector "day1" en Nueva York.
# Fecha desglosada:
# "2020-03-25 16:12:00 EDT"
```

### **Duración**
Es la representación de la cantidad de tiempo entre pares de fechas o fechas-horas. El método para observar esto se le llama "diferencia de tiempos" (*"time differences"*) y la función que se utiliza es `as.difftime` .

```r
day1 <- as.POSIXct("2020-03-27 23:15") - 3600 #Imprimirá la fecha, hora y zona horario - 3600 segundos (1 hr)
# Fecha desglosada: 
# "2020-03-27 22:15:00 CST"

as.POSIXct("2020-03-27 23:15") - day1 #Se observará la diferencia de tiempos, es decir, el vector "day1" menos 3600 segundos (1 hr)
# Time difference of 1.000058 hours

##**Para no hacer esta operación doble y obtener la diferencia de tiempos, la función as.difftime es ideal**

as.difftime(c("0:03:25","11:23:15"), units = "min") #Se generó un vector con 2 elementos, cada uno de ellos con una hora específica y serán comparados con la hora 00:00:00 y el resultado están en las unidades solicitadas, en este caso "min".
# Time difference in mins
#> [1] *3.333333* [2] *683.250000
**##Las unidades pueden ser: "auto", "secs", "mins", "hours", "days", "weeks"***

day2 <- as.difftime(c(0,30,60), units= "mins") #Imprimirá un vector con 3 elementos que representa las diferencias de tiempos 
# Time difference in mins
#> [1] 0 [2] *30* [3] *60
**##Podemos cambiar las unidades de la siguiente manera:***
as.numeric(day2, units= "secs") #Imprimirá un vector de la misma longitud en segundos.
#> [1] 0 [2] 1800 **[3] 3600
as.numeric(day2, units= "hours") #Imprimirá un vector de la misma longitud en horas.
#> [1] 0 [2] 0.5 **[3] 1.0
```

### **Factores**

Son variables categóricas en que toman un número limitado de valores diferentes.

Uno de los usos más importantes de los factores es el modelado estadístico; dado que las variables categóricas entran en modelos estadísticos de manera diferente a las variables continuas, el almacenamiento de datos como factores asegura que las funciones de modelado tratarán dichos datos correctamente.

Los `factores` son realmente vectores de enteros, pero cada entero está asociado con una categoría, estas categorías se llaman `niveles`:

- **Niveles *(levels)*:** Son las categorías de factor (ej. "Hombre" y "Mujer"). Siempre serán valores de caracteres. Puedes las categorías o su orden a través del argumento `levels`.

```r
data <- c(1,3,5,5,6,8,1,3,3,3,8,5,9) #Se genera un vector numérico
# Vector desglosado: 
[1] 1 3 5 5 6 8 1 3 3 3 8 5 9

fdata <- factor(data) #Imprimirá el vector "data" como un factor y sus niveles
# Facto♣r desglosado:
[1] 1 3 5 5 6 8 1 3 3 3 8 5 9
Levels: 1 3 5 6 8 9

levels(fdata) <- c("A","B","C","D","E","F") #Para convertir el factor predeterminado "fdata" en letras, utilizamos la forma de asignación de la función de niveles
fdata
# Factor con la nueva asignación desglosado: 
[1] A B C C D E A B B B E C F
Levels: A B C D E F

# Alternativamente pudimos indicar los niveles desde la creación del factor
data2 <- c(1,2,2,3,1,2,3,3,1,2,3,3,1) #Se genera un vector numérico
data3 <- factor(data2, labels = c("I","II","III")) #Imprimirá el vector "data2" como un factor y la nueva asignación de las etiquetas, en este caso, como números romanos
data3
# Factor desglosado: 
[1] I   II  II  III I   II  III III I   II  III III I  
Levels: I II III

# Podemos crear factores directamente a través de vectores de caracter
fdata <- factor(c("A", "B", "C", "C", "D", "E", "A", "B", "B", "B", "E", "C", "F"))
fdata
# [1] A B C C D E A B B B E C F
# Levels: A B C D E F
```

Como los factores son vectores numéricos, es muy eficiente realizar cálculos, graficarlos o realizar tablas de frecuencia.

```r
table(fdata) # Podemos crear una tabla de frecuencias
# fdata
# A B C D E F 
# 2 4 3 1 2 1

table(fdata, data3) # Puedes crear tablas de frecuencias multivariados con dos factores
# data3
# fdata I II III
#     A 1  0   1
#     B 1  2   1
#     C 0  1   2
#     D 1  0   0
#     E 0  1   1
#     F 1  0   0
```

### **Matrices y arrays**

Lo único que diferencia a un vector con una matriz o array (en términos de R) es que los primeros no tienen el atributo de `dim`. Con ese atributo de dimensión se puede generar una **matriz o array.**

**Matrices**

Las matrices son estructuras con dos dimensiones y podemos crearlas como sigue:

```r
# Matrices
x1 <- 1:25
dim(x1) <- c(5,5)
x1
#      [,1] [,2] [,3] [,4] [,5]
# [1,]    1    6   11   16   21
# [2,]    2    7   12   17   22
# [3,]    3    8   13   18   23
# [4,]    4    9   14   19   24
# [5,]    5   10   15   20   25

# Podemos crear una matriz directamente con este comando
x2 <- matrix(1:16, nrow = 4, ncol = 4) # Podemos omitir ncol o nrow
x2
#      [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14
# [3,]    3    7   11   15
# [4,]    4    8   12   16
```

Noten que primero se rellenan la primera columna, después la segunda y hasta formar la matriz completa

La función `matrix` tiene la siguiente sintaxis:

- matrix**(**data, nrow, ncol, byrow, dimnames**)**
    - `data` (Es el vector que se convierte en los elementos de datos de la matriz)
    - `nrow` (Número de filas que se crearán)
    - `ncol` (Número de columnas que se crearán)
    - `byrow` (Por default byrow= FALSE, indica que la matriz se rellenará por columnas; byrow=TRUE equivale a la transpuesta de esa matriz, es decir, se rellenará por filas)
    - `dimnames`
        
        

**Arrays**

Los `arrays` pueden tener más de 2 dimensiones y se crean como sigue.

```r
x3 <- 1:64 
dim(x3) <- 1:64 # Array de 3 dimensiones
# Resultado
, , 1

     [,1] [,2] [,3] [,4]
[1,]    1    5    9   13
[2,]    2    6   10   14
[3,]    3    7   11   15
[4,]    4    8   12   16

, , 2

     [,1] [,2] [,3] [,4]
[1,]   17   21   25   29
[2,]   18   22   26   30
[3,]   19   23   27   31
[4,]   20   24   28   32

, , 3

     [,1] [,2] [,3] [,4]
[1,]   33   37   41   45
[2,]   34   38   42   46
[3,]   35   39   43   47
[4,]   36   40   44   48

, , 4

     [,1] [,2] [,3] [,4]
[1,]   49   53   57   61
[2,]   50   54   58   62
[3,]   51   55   59   63
[4,]   52   56   60   64

# También se puede crear con el comando:
x3 <- array(1:64, dim = c(4,4,4))
```

```r
# Pueden crear arrays especiales a partir de listas 
lista1 <- list(3, "a", TRUE, 0)
dim (lista1) <- c(2,2)# Automáticamente los elementos de "lista1" se alojan en un diseño rectangular bidimensional
lista1
# Lista1 desglosada como matriz: 
#      [,1] [,2]
# [1,] 3    TRUE
# [2,] "a"  0
```

**Funciones comúnes**

```r
# Funciones normales para matrices y arrays
nrow(x1) # num filas
ncol(x1) # num columnas
dim(x1) # Vector de dimensiones. Igualmente pueden modificarlo con asignación
colnames(x1) <- month.abb[1:5] # Nombres de columnas. Las asigno a los 5 primeros meses
rownames(x1) <- c("2000", "2001", "2002", "2003", "2004") # Nombres de filas

# Solo para arrays
colnames(x3) <- letters[1:4]
dimnames(x3) # Si quieres poner todos los nombres, tienen que usar una lista por dimensión
# [[1]]
# NULL
# [[2]]
# [1] "a" "b" "c" "d"
# [[3]]
# NULL

t(x1) # transpuestas

x1 * x2 # Note que solo multiplica por elemento
x1 %*% x2 # Producto matricial o cruz
sum(x1[1,] * x2[,1]) # Comprobación de producto cruz

# Resolver ecuaciones lineales del tipo A * x = B
A <- matrix(c(3,1,2,1), nrow = 2)
B <- c(x = 8, y = 2)
solve(A, B) # Resolver y obtener vector x
A %*% solve(A) # Si solo tiene un argumento está sacando la inversa
diag(A %*% solve(A)) # Diagonal como vector numérico

det(A) # Determinante
eigen(A) # Valores y vectores de Eigen

# Hay muchas mas funciones que pueden investigar...
```

**Filtrar matrices y arrays**

```r
# Filtrar matrices. Puedes usar los métodos de filtro de vectores atómicos
x1[x1 > 10]
x1[1,] # También usando una coma puedes hacer los mismo por [filas, columnas]
x1[2:3, 3:4]
x1[2:3, 3:4] <- NA # Puedes asignar
x1

# Para arrays solo hay que usar mas comas. 
x3[,,1] # Devuelve la primer cara del cubo
x3[1:3,3,c(1,3)] # Devuelve las tres primeras filas de la tercer fila de la primera y tercera cara
```

### **Data Frames**
Los `data.frames` son listas en las que cada elemento tiene la misma longitud. Si recordamos, las listas son vectores en los que cada elemento puede ser de cualquier tipo, los `data.frames` son iguales pero exigen que cada uno de esos elementos tenga un valor de longitud igual. Esta propiedad es lo que los hace ser representados como **tablas**.

```r
options(stringsAsFactors = FALSE)

# Inicializar un data.frame
df1 <- data.frame(
	id = 1:3,
	nombre = c("Carlos", "Ximena", "Alberto"),
	apellido = c("González", "Quevedo", "Lopez")
)
# id  nombre apellido
# 1  1  Carlos González
# 2  2  Ximena  Quevedo
# 3  3 Alberto    Lopez

# Número de filas
nrow(df1) # 3
# Número de columnas
ncol(df1) == length(df1) # 3. Como es una lista, length se refiere a los elementos que tiene
# nombres
names(df1) == colnames(df1)
rownames(df1) # Igualmente puede asignarle nombres usando estas funciones

# Data.frames avanzados
# Es una lista, por lo que una columna podría ser una lista, pero debe tener la misma longitud
df2 <- data.frame(df1, list("a", "b", "c", "d", "e"))

# Igualmente puedes usar matrices que tengan el mismo número de filas
df3 <- data.frame(id = 1:3, dato = matrix(1:9, nrow = 3))
#   id dato.1 dato.2 dato.3
# 1  1      1      4      7
# 2  2      2      5      8
# 3  3      3      6      9
```

**Filtrar data.frames**

Podemos usar los mismos operadores de las listas y de las matrices.

```r
# [] crea un data.frame mas pequeño, cada elemento es una columna
df1[1]
# id
# 1  1
# 2  2
# 3  3
df1[c("id", "apellido")]
# id apellido
# 1  1 González
# 2  2  Quevedo
# 3  3    Lopez

# [[]] y $ extraen un único elemento tal como es:
df1$id
df1[[1]]
df1[["id"]]
# Todos resultan en: [1] 1 2 3

# [fila, columna] Si solo se escoge una columna devolverá ese vector o lista, si se
# escogen mas de uno devolverá un data.frame
df1[df1$id > 1, "apellido"]
# [1] Quevedo Lopez  
# Levels: González Lopez Quevedo
```

Quizás se fijaron en que el último ejemplo devolvió un factor. Los data.frames transforman `vectores de caracteres` directamente a `factores`. Si quieren evitar este comportamiento pueden ejecutar al principio del programa `options(stringsAsFactors = FALSE)`

Igualmente, se puede usar `as.data.frame` para convertir muchas estructuras de datos.

## **1.8 Control flow e iteraciones**
Controlamos el flujo del programa cuando utilizamos condiciones para correr ciertas partes del código. `R` como la mayoría de lenguajes de programación implementan las herramientas comunes de `control flow`.

### **If**
Utilizamos este comando para decidir que código se ejecuta dependiendo de una condición.

Siempre hay que usar vectores lógicos de un solo elemento. Si ingresan vectores con más elementos, solo se usara el primer elemento. 

```r
if (TRUE) print("Es verdadero")
# "Es verdadero"

# Podemos especificar que hacer si no se cumple la condición
if (FALSE) print("Es verdadero") else print("Es falso")
# "Es falso"
```

```r
# Usemos vectores lógicos implícitamente
y <- if (9 == 9) TRUE else FALSE
y <- if (9 != 9) TRUE else FALSE
# if devuelve el último valor que ejecutó
```

### **Else if**
Podemos especificar una cadena de condicionales, y aquella que cumpla se ejecutará ese código, en caso contrario correrá el bloque de código dentro de `else`.

```r
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
```

### **ifelse vectorizado**
Ahora mismo estamos ejecutando una sola condición, pero quizás queramos resultados distintos según el valor de cada elemento de un vector. `R` permite vectorizar el comando `if` usando `ifelse`.

```r
edades <- round(runif(5, min = 16, max = 65), 0)
res <- ifelse(edades > 35, "Mayor a 35 años", "Menor o igual a 35 años")
res
# [1] "Menor o igual a 35 años" "Menor o igual a 35 años"
# [3] "Mayor a 35 años"         "Mayor a 35 años"        
# [5] "Mayor a 35 años"
```

### **Switch**
A veces queremos usar muchas condiciones `else if`, pero estas pueden crecer al punto de ser difíciles de leer y modificar. Para eso `switch` nos puede ayudar.

```r
item <- "atun"
pago <- 0
# En ved de escribir
if (item == "manzana") {
	pago <- 15
} else if (item == "papel") {
	pago <- 30
} else if (item == "atun") {
	pago <- 100
}

# Podemos expresarlo como
pago <- switch (
  item,
  manzana = 15,
  papel = 30,
  atun = 100
)
```

Se puede vectorizar `switch` utilizando la función `case_when` de la paquetería `dplyr`

### **While y Repeat**
Estos dos comandos nos ayudan a repetir la ejecución de un bloque de código de maneras diferentes.

### **While**

Utiliza una condición para evaluar si se debe ejecutar un bloque de código, al acabar de ejecutarlo, lo vuelve a evaluar, y solo cuando es `FALSO` termina el `loop`.

```r
# Imprimirá i hasta que sea mayor a 99
i <- 0
while (i < 100) {
  print(i)
  i <- i + 1 # Lo mas importante, si no incrementamos i correrá por siempre
}

# Los comandos especiales next y break:
# next fuerza a la siguiente iteración
# break para la ejecución
i <- -1
while (i < 100) {
  i <- i + 1
  
  if (i %% 2 == 0) { # Es par y por tanto se imprimirá
    print(i)
    next
  }
  
  if (i > 50) {
    break # Parará el loop antes de lo previsto
  }
  
}
```

### **Repeat**
Es muy parecido a `while` pero no existe ninguna condicional, sino que siempre se repite. la única manera de pararlo es usando el comando `break`.

```r
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
```

### **For**

Es muy parecido a `while` y `repeat` pero realmente entra en otra categoría. Mientras que los primeros ejecutan hasta que una evaluación sea falsa o se fuerze su compleción, `for` solo itera las mismas veces que la longitud de un vector (podemos reducir las interaciones o pararlo con `next` y `break`).

```r
# Ejecuta una función por cada elemento del vector que le pase
for (i in 1:20) { # i contiene el valor en cada iteración
  print(i) # Iterara 20 veces, pues es la longitud del vector
}
for (i in letters) {
  print(i)
}
```

Noten como no tenemos que incrementar ninguna variable o forzar la salida.

```r
# Podemos iterar de 3 maneras

# Por valor. i representa el valor del vector runif(10)
# Solo es útil si no queremos aprovechar el índice
for (i in runif(10)) {
  print(i)
}

# Por índice. Si queremos usar la posición en varios vectores, vale la pena
# agarrar directamente el índice
compra <- c("Naranjas", "Manzanas", "Atun")
for (i in seq_along(compra)) { # seq_along() es equivalente a 1:length()
  print(paste(i, compra[i], sep = " - ")) # Utilizamos el índice para extraer los valores que nos interesan
}

# Por nombres. Es parecido a usar índices, solo que los nombres solo funcionaran
# para otros vectores que compartan nombres
compra <- c(Naranjas = 15, Manzanas = 10, Atun = 100)
for (i in names(compra)) {
  print(paste0("El precio de ", i , " es: ", compra[i]))
}
```

### **Familia iteradores apply**

`For` existe en una categoría distinta porque la idea central de iterar sobre un número finitos de elementos existentes es muy usado en todo tipo de problemas. Para facilitar aún más la sintaxis de `for`, se creó la familia de funciones `apply` (que son realmente `for` vectorizados). La idea central aquí es iterar cada uno de los elementos de un vector, lista o matriz dentro de una función para devolver otro vector, o matrices o listas o valores únicos.

👀 Queremos vectorizar for solo cuando cada uno de las iteraciones no depende de los demás.

```r
# Estructura básica de familia apply
# resultado <- apply(elemento, funcion)
```

Existen varias funciones dentro de esta familia que veremos a continuación:

### **Apply**
Se usa para `matrices` o `data.frames`. El objetivo es realizar una función por cada fila o columna.

```r
x1 <- matrix(1:25, nrow = 5)

# Promedio por filas
promFilas <- apply(x1, margin = 1, mean, na.rm = TRUE)

# - El primer argumento es la matriz o data.frame
# - El segundo argumento es el margen:
	# 1 - Filas
	# 2 - Columnas
# - El tercer argumento es una función. Lo que va a pasar es que
# cada elemento del primer argumento (llamémoslo x_i) será
# el primer argumento de mi función. Podemos verlo en un for:
# for (i in filas) {
#   res[i] <- miFuncion(i)
# }
# - Los demás argumentos serán pasados a mi función, en este caso:
# for (i in filas) {
#   res[i] <- mean(i, na.rm = TRUE)
# }

# En resumen, calculamos el promedio de cada uno de las filas y
# obtuvimos un vector numérico

# Variancia poblacional por columnas
# Vamos a usar una función anónima esta vez
varPColumnas <- apply(x1, 2, function(x) mean( (x - mean(x))^2 ) )

# Igualmente pudimos crear la función antes e introducirlo al apply
varP <- function(x) mean( (x - mean(x))^2 )
varPColumnas <- apply(x1, 2, varP ) # Función escrita en otra parte
```

### **lapply**

Vamos a forzar que el resultado sea una lista. En este caso no se usa márgenes.

```r
mtcars # Vamos a usar la base de datos mtcars cargado en R
summary(mtcars$mpg) # Así obtenemos el resumen de una columna
resumen <- lapply(mtcars, summary) # Así obtenemos una lista de resúmenes por columna
```

### **sapply**

Intenta forzar el resultado a que sea un vector atómico o una matriz. Si falla lo regresa como una lista.

```r
# Obteniendo el rango IQR por cada columna
iqr <- sapply(resumen, function(x) x[5] - x[2])
iqr # El resultado es un vector

sapply(1:5, rep, 4)
#      [,1] [,2] [,3] [,4] [,5]
# [1,]    1    2    3    4    5
# [2,]    1    2    3    4    5
# [3,]    1    2    3    4    5
# [4,]    1    2    3    4    5

# Se crea una lista porque no puede forzar el resultado
# en una matriz o vector.
sapply(1:5, runif)
```

### **mapply**
Es lo mismo que apply pero usando varios vectores a la vez.

```r
# mapply
res2 <- mapply(rep, 1:4, c(1, 3, 6, 3))
# Lo mismo que ejecutar
# rep(1, 1) rep(2, 3) rep(3, 6) rep(4, 3)
# Respuesta:
# [[1]]
# [1] 1
# [[2]]
# [1] 2 2 2
# [[3]]
# [1] 3 3 3 3 3 3
# [[4]]
# [1] 4 4 4
```

Nota que ahora la función es nuestro primer argumento

Para agregar mas argumentos individuales a la función (como na.rm = TRUE), reúnalos en una `lista` y use el argumento `MoreArgs`

### **tapply**
Se utiliza con factores y sirve para iterar agrupando por cada uno de las categorías.

```r
# Promedio y mínimo honorario por hora de contadores
# de diferentes estados
region <- factor(c("Sonora", "EDO", "EDO", "CDMX", "CDMX", "CDMX"))
levels(region) # Categorías
precio <- c(300, 400, 200, 700, 600, 1000)

tapply(precio, region, mean)
tapply(precio, region, min)
```

### **Otras funciones apply**

Aunque no los toquemos aquí, sería interesante que el lector investigara estas versiones de apply:

- `vapply`
- `eapply` (Tendrá que estudiar que es un ambiente o environment)
- `rapply`

**Reduce**
Es parecido a la familia de funciones `apply`, aplica recursivamente una función para al final obtener un solo valor. Es mas fácil de visualizar con un ejemplo:

```r
# Restar recursivamente todos los elementos de un vector
Reduce(`-`, c(10, 5, 2, 1)) # Podemos usar `` para envolver un operador como + * u otro
# Es lo mismo que ((10 - 5) - 2) - 1
# [1] 2

# Formalmente, lo definiríamos como:
# Reduce(f(), datos) --> f(f(f(f(datos[1], datos[2]), datos[3]), datos[4]), ... hasta que acabe
```
## **1.9 Importación de datos a R**
**R** contiene un conjunto de funciones que pueden ser utilizadas para la carga de datos dentro de la memoria, de la misma manera se pueden importar datos a la memoria utilizando la interfaz de **RStudio.**

`R` puede importar datos en muchos formatos diferentes. Dos de los más comunes son: 

- **CSV Files** (CSV: *Comma Separate Values*) Los valores están separados por comas.

- **Text Files** Es un formato muy similar al anterior, pero en lugar de estar separado por comas se utilizan otros caracteres, por ejemplo, tabulador.

### **R Studio**

1. En la parte superior derecha con el botón "Import Dataset"

2. En el menú principal: Tools > Import Dataset 

### **Formato de Datos**

Después de haber seleccionado la ubicación del archivo a importar, aparecerá un cuadro de diálogo como el que se muestra a continuación, este le permitirá previsualizar y especificar diferentes configuraciones acerca del formato de los datos:

Cuando haya finalizado la configuración que desea, haga click en el botón "Import".

Al finalizar la carga de los datos en la parte superior derecha aparecerá una nueva variable referida a los datos importados, de la misma manera podrá ejecutar varias funciones de R, como calcular la media de una columna en específico.

### **R**
R tiene 3 funciones muy utilizadas para importar datos:

### **read.table ( )**
Tiene 3 parámetros:

1. El **nombre** del archivo a cargar.
2. Indica si el archivo contiene una línea de encabezado.
    - ***header***= TRUE (significa que la primera linea es un encabezado)
    - ***header***= FALSE (la primera linea NO es un encabezado)
    
    Por "*encabezado*" se entiende si la primera línea contiene los nombres de columna.
    
3. El carácter separador utilizado dentro del archivo para separar los valores de cada fila.

```r
read.table ("data.csv", header=TRUE, sep=";")
```

### **read.csv ( )**
Tiene 3 parámetros:

1. La **dirección** del archivo a cargar.
2. Indica si el archivo contiene una línea de encabezado.
3. El carácter separador utilizado dentro del archivo para separar los valores de cada fila.

```r
read.csv ("D:\\data\\data.csv", header=TRUE, sep=";")
```

Este ejemplo carga el archivo CSV localizado en ***D:\\data\\data.csv ;*** la primera fila es un encabezado que contiene el nombre las columnas en el archivo CSV ; el carácter separador usando dentro del archivo CSV es **;** (punto y coma)

### **read.delim ( )**
Tiene la misma estructura que ***read.csv ( )*** 

Tiene 3 parámetros:

1. La **dirección** del archivo a cargar.
2. Indica si el archivo contiene una línea de encabezado.
3. El carácter separador utilizado dentro del archivo para separar los valores de cada fila.

```r
data = read.delim("D:\\data\\data.csv", header=TRUE, sep=";")
```

Podemos importar texto tal como está usando las funciones `read.file` o `readLines`

## **1.10 50% - Gráficas básicas en R**
# Introducción a plots

`plot` se utiliza en dos situaciones:

- Queremos hacer una gráfica Y-X con valores que disponemos
- Otra paquetería implementa un método de plot para el tipo de dato que manejamos, y por tanto lo grafica de una manera especial (ej: series de tiempo)

Vamos a usar plot para el primer caso, y luego veremos un ejemplo donde usamos objetos especiales para sacar sus gráficas específicas.

```r
x <- 1:10
y <- 4 + .5 * x
plot(x = x, y = y)
```

Tenemos a nuestra disposición muchos argumentos para modificar esta gráfica:

### **Etiquetas**

Podemos añadir información contextual en forma de texto usando:

- `main` es el título
- `sub` es un subtítulo que se coloca debajo de la gráfica
- `xlab` es la leyenda del eje x
- `ylab` es la leyenda del eje y

```r
plot(
  df1,
  main = "Tensión vs Enlongación",
  sub = "Experimento realizado en laboratorios de la Facultad de Ingeniería UNAM",
  xlab = "Enlongación [mm]",
  ylab = "Tensión [N]"
)
```

### **type**
Modifica como representa los puntos en el plano. Valores posibles son:

- `"p"` for **p**oints
- `"l"` for **l**ines
- `"b"` for **b**oth
- `"c"` for the lines part alone of `"b"`
- `"o"` for both ‘**o**verplotted’
- `"h"` for ‘**h**istogram’ like (or ‘high-density’) vertical lines
- `"s"` for stair **s**teps
- `"n"` for no plotting.

```r
# Igualmente podemos agregar x y y en un data.frame o lista para que sea menos código
df1 <- data.frame(x = x, y = y)

plot(df1, type = "l", main = "type l") # Automáticamente detecta x y y
plot(df1, type = "b", main = "type b")
plot(df1, type = "c", main = "type c")
plot(df1, type = "o", main = "type o")
plot(df1, type = "h", main = "type h")
plot(df1, type = "s", main = "type s")
plot(df1, type = "n", main = "type n")
```

### **Coordenadas**

Pueden hacer zoom en las coordenadas que deseen usando:

- `xlim` vector numérico de tipo (x_limite_inferior, x_limite_superior)
- `ylim` lo mismo pero en y

```r
plot(df1, type = "s", xlim = c(3, 5), ylim = c(5, 7))
```

Pueden cambiar la escala de los ejes con `log`

- `"x"` solo x con escala logarítmica
- `"y"` solo y con escala logarítmica
- `"xy"` ambos con escala logarítmica

```r
x <- 1:10
y1 <- exp(1) ^ x
y2 <- log(x)
l1 <- list(x = x, y1 = y1, y2 = y2)

# par nos permite pasar información extra al motor de renderizado
# en este caso mfrow indica el layout, en este caso habrá 4 gráficos
# porque es habrá 2 filas y 2 columnas
par(mfrow = c(2, 2))
plot(l1$x, l1$y1, type = "l", main = "exp(1) ^ x")
plot(l1$x, l1$y1, type = "l", log = "y", main = "exp(1) ^ x usando y logarítmica")
plot(l1$x, l1$y2, type = "l", main = "log(x)")
plot(l1$x, l1$y2, type = "l", log = "x", main = "log(x) usando x logarítmica")
```

### **Colours**
Puedes definir el color de los trazos que definas, casi universalmente esto se realiza usando el argumento `col`. Este argumenta acepta estos valores de colores:

- Colores por `nombre` (ej: `col` = "red").
```r
plot(runif(10), 1:10, col = "darkblue", pch = 20) # pch cambia el tipo de punto
```

- Colores por `número:`
    - 1 es negro
    - 2 es rojo
    - 3 es verde
    - 4 es azul

```r
plot(runif(10), 1:10, col = 2)
```

- Colores por código `hexadecimal`. Todos los colores (sin transparencia) se pueden representar en función de 3 dimensiones que son la cantidad de rojo, verde y azul. Hay múltiples formas de representarlo como:
    - RGB (Red Green Blue), se representa cada color desde el 0 al 255, siendo 0 el negro y 255 la completa saturación, es decir rgb(255, 255, 255) es el color blanco porque es la máxima saturación.
    - HSL (Hue Saturation Luminosity), representa cada color por otros tres dimensiones que resultan en los mismos colores.
    - Hexadecimal `RRGGBB`. Se toma el mismo ejemplo que RGB pero en ved de ser un número entre 0 a 255, se representa con dos códigos hexadecimales, siendo FF el equivalente a 255. Este es el código que utiliza `R`. Para usarlo hay que poner # delante y crear un vector de caracteres. Ej. `col = "#20AB10"`
    
    Pueden usar recursos onlines como este para generar colores —> [link](https://htmlcolorcodes.com/es/)
    
- En R hay funciones que generan colores `hexadecimales` dentro de una temática:

```r
# Hay funciones donde introducimos la cantidad de colores
# que queremos para una escala, y nos devuelve los colores
# del menos intenso al mas intenso
heat.colors(10) # Escala de rojo a amarillo, y a blanco
topo.colors(10) # Escala de azul a verde, y a blanco

# Podemos generar una escala propia
pal1 <- colorRampPalette(c("red", "yellow"))
pal1(10)

# Hay otras funciones donde le indicamos el grado del color
# que queremos desde un rango
gray(c(0, .4, 1)) # Escala de grises. El 0 es negro total, el 1 es blanco
# y los colores entre medias son grises mas o menos intenso

# podemos generar nuestra propia paleta. Por ejemplo quiero una
# escala desde el azul hasta el rojo
pal <- colorRamp(c("blue", "red"))
pal(c(0, .4, 1)) # Ahora puedo decirle que rango quiero
#      [,1] [,2] [,3]
# [1,]    0    0  255
# [2,]  102    0  153
# [3,]  255    0    0
# Nos devuelve los colores como una matriz
# cada fila es un color y las columnas son rojo, verde y azul
# Debemos convertir cada fila en un color hexadecimal
# Realmente la matriz se comporta como un código RGB y R puede tratarlo
rgb(0, 0, 234, maxColorValue = 255) # Un número
rgb(pal(c(0, .4, 1)), maxColorValue = 255)
# [1] "#0000FF" "#660099" "#FF0000"
```

## **Elementos adicionales a plots existentes**
El arte de crear gráficas suele ser iterativo, primero construimos un primer boceto y le vamos añadiendo elementos. R refleja esta filosofía tanto en los gráficos bases como en las de otras paqueterías, y ahora vamos a ver como hacerlo.

👀 Plot genera los ejes. Si generamos mas datos no se modifica implícitamente estos.

### **points**
Podemos añadir nuevos puntos usando `points`. La sintaxis es igual que el de plot.

```r
plot(rnorm(10), 1:10, col = "red", pch = 20)
points(rnorm(10), 1:10, col = "blue", pch = 20)
# Noten como falta un punto azul, esto es porque los ejes
# se crean con plot, y si añadimos un punto que se sale de los ejes
# originales, no aparecerá
```

### **lines**
Es lo mismo que `points` pero por `default` crea una línea entre los puntos.

```r
plot(1:10, 1:10*.3 + 4)
lines(1:10, 1:10*.3 + 3, col = "red")
```

### **abline**
Si quieres generar líneas rectas sin tener que generar los vectores, podemos usar `abline`, quien acepta 3 modos:

- Vertical, debemos indicarle una x con el argumento `v`.
- Horizontal, debemos indicarle una y con el argumento `h`.
- Recta con origen y pendiente, debemos usar `a` para la ordenada y `b` para la pendiente.

```r
plot(runif(20), 0:19, pch = 20)
abline(a = .5, b = .4, col = "red") # Recta con ordenada y pendiente
abline(v = .6, col = "blue") # Recta vertical
abline(h = 5, col = "green") # Recta horizontal
```

### **segments**
Podemos definir segmentos con un inicio y final.

```r
# segments(x0, y0, x0, y0) x0 y y0 son los puntos iniciales

# Usemos un ejemplo, vamos a generar un modelo lineal y simular
# observaciones con ruido. Después generarmos segmentos desde la
# obseración hasta el modelo lineal
x <- 1:20
y <- 5 + .5 * x
y_real <- y + rnorm(length(x))

plot(x, y_real, pch = 20)
lines(x, y, col = "blue")
segments(x, y, x, y_real, col = "orange")
```

### **text**
Podemos incluir texto en puntos del texto donde nos interese. En este caso vamos a escribir el porcentaje de desviación de cada residual.

```r
x <- 1:20
y <- 5 + .5 * x
y_real <- y + rnorm(length(x))
por_des <- as.character(round((y_real - y) / y * 100))

plot(x, y_real, pch = 20)
lines(x, y, col = "blue")
segments(x, y, x, y_real, col = "orange")
text(x, y + (y_real - y)/2, labels = por_des, adj = c(-.5, .5))
```

## **Métodos de plot con estructuras de datos existentes**
### **density**

En estadística es muy común modelar la distribución de probabilidades continuas usando funciones de densidad de probabilidad (probability density functions `PDF`). Tienen 3 propiedades interesantes estas funciones:

1. El área debajo de la curva es la probabilidad de que ocurra un evento que resulte en valores entre los dos intervalos del área, es decir 

$$
P(a \leq x \leq b) = \int_a^b{pdf(x)dx}
$$

2. Derivado de la propiedad anterior, el área total de la función debe sumar la unidad, es decir, la probabilidad de que ocurra un evento dentro del dominio de PDF es 1:

$$
P(lim~inf \leq x \leq lim~sup) = \int_{lim~inf}^{lim~sup}{pdf(x)dx} = 1
$$

3. La función `PDF` no devuelve probabilidades, sino que devuelve la densidad de probabilidad en cada punto. Esto hace sentido por dos razones:

3.1. La probabilidad de que ocurra un evento específico es infinitesimalmente pequeño. 

3.2. Para que se cumpla la primera propiedad se tiene que dar que la unidad de la función es `probabilidad entre unidad de x`, que al multiplicarlo por un `rango de x` resulta en `probabilidad`.

Dato interesante: La integral del PDF desde el límite inferior a un punto x es la función de probabilidad acumulada (cumulative probability function `CDF`) y se expresa como:

$$
CDF(x) = \int_{lim~inf}^x{pdf(x)dx}
$$

Muchas veces no conocemos el `PDF` de un set de datos, pero tenemos herramientas para aproximarlo. Una de estas herramientas es el `Estimador de Densidad Kernel`, un método `no paramétrico` de estimar el `PDF` usando como **hiperparámetro** el factor de suavizado `h`.

Puedes leer sobre `KDE` aquí (incluso incluye código en R para replicarlo):

[Kernel density estimation](https://en.wikipedia.org/wiki/Kernel_density_estimation)

En `R` podríamos replicarlo pero es más rápido utilizar la función de `density` para hacer `KDE`.

```r
x <- rnorm(25)

# Devuelve una lista
est.pdf <- density(x)
est.pdf$x # Son los datos originales
est.pdf$y # Es la densidad de probabilida estimada para una x
est.pdf$bw # Factor de suavizado h, se calcula solo pero pueden especificarlo
# dentro del argumento de density como density(bw = .05)

# Como la lista tiene x y y, podemos ingresarla directamente a plot
plot(est.pdf) # También va a desplegar el Bandwith de este modo
plot(x = est.pdf$x, y = est.pdf$y, type = "l") # Equivalente básico
```

```r
# Obviamente cuantos mas datos tenga mejor será la estimación del pdf
x1 <- rnorm(1e3) # N = 1,000
x2 <- rnorm(1e5) # N = 100,000
x3 <- rnorm(1e7) # N = 10,000,000
par(mfrow = c(3, 1), cex = 0.7, mar = c(3, 4, 3, 2))
plot(density(x1), main = "N = 1,000")
plot(density(x2), main = "N = 100,000")
plot(density(x3), main = "N = 10,000,000")
```

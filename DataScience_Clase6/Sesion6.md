# **6. Introducción a Deep learning**

## **Ejercicio con keras - Natural Processing Language**
### **Contexto**

En este ejemplo haremos un análisis de sentimientos de un data set de películas. Entrenaremos una red de aprendizaje profundo para clasificar comentarios en buenos o malos.

El análisis de sentimientos tiene como objetivo determinar la actitud o el sentimiento. Por ejemplo, un orador o escritor con respecto a un documento, interacción o evento. Es un problema de procesamiento del lenguaje natural en el que el texto debe entenderse para predecir la intención subyacente.

El sentimiento se clasifica principalmente en categorías positivas, negativas y neutrales. A través del análisis de sentimientos, es posible que queramos predecir, por ejemplo, la opinión y actitud de un cliente sobre un producto en función de una revisión que escribieron. Esta técnica se aplica ampliamente a cosas como revisiones, encuestas, documentos y mucho más.

### **Metodología**

`Keras` tiene cargado el data set de IMDB, que consiste en 50,000 reviews etiquetados como positivos (1) o negativos (0). Los reviews ya vienen procesados como vectores numéricos de índices, cada índice representa una jerarquía de palabras, por ejemplo, el 3 representa la tercera palabra más utilizada (podría ser "de" o "la"...). Esto nos va a facilitar filtrar pronombres, artículos y otras estructuras del lenguaje que no añaden significado.

**1) Conocimiento y limpieza de datos**

Keras trae el dataset de IMDB divido en 2, uno de entrenamiento y otro de prueba con 25,000 registros respectivamente. El primer paso será unirlos y dividirlos en 2 sets de entrenamientos con una proporción más acorde, como 80%-20%.

```r
library(tidyverse)
library(keras)

# Si no han instalado keras antes, ejecuten este comando
install_keras()

# No quiero mas de 10,000 palabas por review (Muchas veces ya conoces el sentimiento
# en las primeras frases. Mas palabras añaden ruido y pueden empeaorar
# la clasificación)
imdb <- dataset_imdb(num_words = 10000)

# Keras siempre trae en sus datasets un objeto con 2 elementos:
# train y test. Cada uno a su vez tiene dos elementos, x y y.
c(c(train_x, train_y), c(test_x, test_y)) %<-% imdb

# Comprobar que las palabras no rebasan el 10,000 de límite
max(sapply(train_x, max))

# Vamos a decodificar uno de los comentarios para ver lo que tiene escrito.
# Cada comentario es una colección de índices que corresponden al orden de frecuencia
# observado. Así el índice 3 significa la tercera palabra mas encontrada.
# Para saber a que palabra corresponde podemos descargar estas con:
lista.palabras <- dataset_imdb_word_index()
# Creamos un data.frame en el cual cada fila es una palabra y su índice
palabras <- tibble(
  palabra = names(lista.palabras),
  indice = unlist(lista.palabras)
) %>%
  mutate(indice = indice + 3) %>% # Hay que añadir 4 caracteres especiales al principio
  add_row(palabra = "<PAD>", indice = 0) %>%
  add_row(palabra = "<START>", indice = 1) %>%
  add_row(palabra = "<UNK>", indice = 2) %>%
  add_row(palabra = "<UNUSED>", indice = 3) %>%
  arrange(indice)

# Podemos ver que las primeras palabras son artículos y pronombres como
# and, the, I...
palabras

# Ahora extraemos las filas que correspondan con los índices
review <- imdb$train$x[[1]] %>%
  map_chr(~pull(filter(palabras, indice == .x), palabra))
paste(review, collapse = " ") # Finalmente lo unimos para ver el texto

# Ahora tratemos los datos para poder incluirlas en la red neuronal.
# 1) Unimos los segmentos para después separarlo en una proporción que prefiramos
data_x <- c(train_x, test_x) # Unir listas crea una lista mas grande
data_y <- c(train_y, test_y)

# 2) Primero filtraremos las 20 palabras mas utilizadas, como han visto
# son palabras que no añaden significado al texto
data_x <- map(data_x, ~.x[.x > 20])

# 3) Dejaremos los 256 palabras restantes, porque generalmente las primeras frases
# nos dicen que piensa la persona que escribio el comentario. Mas palabras añaden ruido
data_x <- map(data_x, ~.x[1:256])

# 4) Volvemos a separar en sets de entrenamiento y prueba con una proporción 80-20
indice <- sample(1:length(data_x), .8 * length(data_x))

train_x <- data_x[indice]
test_x <- data_x[-indice]
train_y <- data_y[indice]
test_y <- data_y[-indice]
```

Quizás has notado que para este problema no hizo falta escalado, ya que las palabras no son dimensiones en sí, sino índices únicos.

**2) Modelo**

Recapitulando, queremos que nuestra red neuronal nos arroje un valor de probabilidad entre comentario bueno y comentario malo. Para eso le alimentamos con las 256 primeras palabras de un comentario crítico (después de filtrar las 20 palabras más usadas). Ahora bien, cada comentario puede tener palabras contenidas en una lista de 10,000 - 20 palabras, realmente lo estamos alimentando de esa combinación más el orden en el que aparecen las palabras. Tenemos 2 posibilidades de red de entrada:

**1- Red densa**

La entrada es un vector numérico de 10,000 elementos, cada uno se refiere a una palabra y están ordenados en la manera que se escribieron. Solo tenemos que construir una red como las que conocemos con varias capas ocultas.

Pero hay un pequeño problema, tendríamos que generar una matriz de 40,000 filas x 10,000 columnas, que multiplicadas por 8 bits resulta en un objeto de 3.2 GB, y lo más probable es que la computadora de la mayoría no aguantaría tanta memoria. Por eso utilizaremos la segunda técnica:

**2- Red de embedding**

Aunque lo anterior funcionaría igual de bien que esta opción, consume mucha más memoria y poder de procesamiento, y como es un problema común se diseñó una capa capaz de tratar con problemas de vocabulario. La red embedida acepta un valor de diccionario (en nuestro caso nuestro universo consiste en 10,000 palabras), y luego podemos añadir vectores de comentarios con solo las observaciones que tiene. Para mas documentación pueden checar:

[Embedding Layers - Keras Documentation](https://keras.io/layers/embeddings/)

```r
# 5) Creamos matrices de n observaciones * 256 columnas
train_x <- train_x %>%
  sapply(function(x) x) %>%
  t()
test_x <- test_x %>%
  sapply(function(x) x) %>%
  t()

# 6) Sustituimos NAs por 0
train_x[is.na(train_x)] <- 0
test_x[is.na(test_x)] <- 0

# 7) Construir modelo
modelo <- keras_model_sequential() %>%
  layer_embedding(input_dim = 10000, output_dim = 16) %>%
  layer_global_average_pooling_1d() %>% # Necesario después de usar embedding
  layer_dense(units = 16, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid") # Queremos una probabilidad binaria

# 8) Compilamos
modelo %>% compile(
  loss = "binary_crossentropy",
  optimizer = "adam",
  metrics = "accuracy"
)

# 9) Ejecutamos el entrenamiento
historia <- modelo %>% fit(
  train_x,
  train_y,
  epochs = 10,
  batch_size = 128,
  validation_split = .3
)
```

Vayamos paso a paso explorando las decisiones que se tomaron para construir el modelo.

### Red neuronal profunda

Tenemos 4 capas en nuestra red. La primera normalizara la información de índices en un tensor 3D y la segunda hará el promedio de la última dimensión para tener un tensor de dos dimensiones. Las siguientes capas ya las conocemos, son capas densas. La primera capa densa tendrá 16 nodos y se activará con la función `relu`, ya que es muy bueno para filtrar resultados y asignar importancia a los que sobreviven. La última capa se encarga de generar un probabilidad entre 0 a 1, cuanto más se acerque a 0, más probable es que sea un comentario negativo, y cuanto más se acerque a 1 más probable que sea un buen comentario. La función sigmoid normaliza toda la entrada en el rango de 0 a 1 así que es perfecto para el trabajo.

### **Compilador**

Es un problema de clasificación binaria, por tanto queremos utilizar un compilador y una función de pérdida que se beneficien. Para clasificaciones binarias la mejor función de pérdida es `binary_crossentropy`, el cual maneja probabilidades mejor que otros métodos como `mean_squared_error`.

Un buen optimizador para situaciones de clasificación es el optimizador `Adam`. Para problemas de regresión quizás el `descenso de gradiente estocástico` es una mejor opción.

### **Entrenamiento**

El entrenamiento suele tardar varios intentos (`epocas`) para converger, lo mejor para empezar es usar un valor pequeño para ver la evolución. Si no mejora nada quizás hay que cambiar la red o el compilador, pero si mejora y parece que puede converger más podemos incrementar las épocas. 20 épocas suele ser suficiente para la mayoría de casos.

El tamaño de `batch` es la cantidad de observaciones que se van a usar para mejorar el algoritmo en una época, y generalmente va desde 32 a 512. Para problemas de clasificación binarias no suele hacer falta tantas observaciones, con lo cual 128 es un buen número.

Es bueno utilizar un set de validación para probar los resultados en cada época. Podemos separarlo manualmente e introducirlo en el argumento `validation_data` como una lista de dos elementos, o podemos dejar que lo haga por nosotros fijando la proporción de datos de validación con el argumento `validation_split`. El 30% suele ser una buena proporción de entrenamiento.

## **Evaluación de modelo**

Podemos graficar la evolución de nuestro modelo a través de las épocas:

```r
plot(historia)
```

La línea que nos interesa es la de validación, después de todo no usamos esa información para entrenar el modelo, así que la precisión que se observa ahí es la evaluación de información que el algoritmo nunca ha visto. Aquí observamos como empieza a hacer `overfitting` el modelo, porque cada vez es más preciso el modelo sobre el set de entrenamiento pero cada vez menos sobre el set de validación, está empezando a memorizar los comentarios en ved de evaluarlos. Por eso siempre es importante dejar un número de épocas reducidas y comparar el modelo con un set de prueba, que justo vamos a hacer ahora:

```r
# 10) Evaluamos el modelo en nuestro conjunto de prueba
prueba <- modelo %>% evaluate(test_x, test_y)
prueba
```

Parece que nuestro modelo tiene una precisión del 90%, es decir, 90 de cada 100 comentarios serán clasificados correctamente.

Podemos hacer la prueba con un solo comentario:

```r
review <- imdb$test$x[[100]] %>%
  map_chr(~pull(filter(palabras, indice == .x), palabra))
paste(review, collapse = " ")
```

> <START> troma <UNK> lloyd kaufman is the in this anthology film made up of two films that were such celluloid <UNK> that tried to salvage them by combining the two into one anthology film and throwing in <UNK> amounts of nudity whenever possible does it work nope it's still crap that i'd have to <UNK> off my boots if i stepped in it will anyone like this mess sure young teen aged <UNK> with the combined <UNK> of a vienna <UNK> have to laugh at something i guess for those who have brains that are even semi <UNK> steer clear though and watch something less insulting to your intelligence even dude where's my car would do br br my grade f
> 

Claramente es un comentario negativo, que además podemos comprobar con:

```r
imdb$test$y[[100]]
# [1] 0
```

Veamos si el algoritmo puede predecirlo adecuadamente.

```r
# Primero transformamos x para que tenga la misma forma
# que los sets de entrenamiento
x <- imdb$test$x[[100]] %>%
  .[. > 20] %>%
  .[1:256] %>%
  `[<-`(is.na(.), 0) %>%
  matrix(nrow = 1)

prediccion <- modelo %>% predict(x)
round(prediccion) # La predicción es una probabilidad, así que vamos a redondearlo
# [1] 0

# Alternativamente, podemos usar directamente
modelo %>% predict_classes(x)
#      [,1]
# [1,]    0
```

Perfecto, tuvimos suerte de que en una prueba si pudiera clasificarlo bien. Podemos probar un par de más solo para estar seguros:

```r
x <- imdb$test$x[101:111] %>%
  map(~.x[.x > 20]) %>%
  map(~.x[1:256]) %>%
  map(~{.x[is.na(.x)] <- 0; .x}) %>%
  sapply(function(x) x) %>%
  t()

prediccion <- modelo %>% predict_classes(x)
cbind(prediccion, imdb$test$y[101:111])
#        [,1] [,2]
# [1,]      0    1
# [2,]      0    1
# [3,]      0    0
# [4,]      0    0
# [5,]      0    0
# [6,]      0    0
# [7,]      0    0
# [8,]      0    0
# [9,]      1    1
# [10,]     1    1
# [11,]     1    1
```

### **Documentación de Keras**

[Home - Keras Documentation](https://keras.io/)

### **Ejercicios que pueden hacer**

[Tutorial: Basic Classification](https://keras.rstudio.com/articles/tutorial_basic_classification.html)

[Tutorial: Basic Regression](https://keras.rstudio.com/articles/tutorial_basic_regression.html)

[mnist_cnn](https://keras.rstudio.com/articles/examples/mnist_cnn.html)

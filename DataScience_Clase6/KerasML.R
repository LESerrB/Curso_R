install.packages("keras")
library(keras)
install_keras()

imdb <- dataset_imdb(num_words = 10000)

#train_datos <- imdb$train$x
#train_label <- imdb$train$y
#test_datos <- imdb$test$x
#test_label <- imdb$test$y
c(c(train_data, train_labels), c(test_data, test_labels))%<-%imdb
str(train_data[[250]])
str(train_labels[[250]])
length(train_data)

#max(sapply(train_data, max))

palabra <- dataset_imdb_word_index()
reverse <- names(palabra)

decoded <- function(index){
  word <- if(index >= 3){
    reverse[[index - 3]]
  }
  
  if(!is.null(word)){
    word
  }else
    "?"
}

decoded_review <- sapply(train_data[[4]], decoded)

str(train_data)

vectorizar <- function(secuencia, dimension = 10000){
  resultado <- matrix(0, nrow = length(secuencia), ncol = dimension)
  
  for (i in 1:length(secuencia)) {
    resultado[1, secuencia[[i]]] <- 1
  }
  
  resultado
}

x_train <- vectorizar(train_data)
x_test <- vectorizar(test_data)

str(x_train[1,])

y_train <- as.numeric(train_labels)
y_test <- as.numeric(test_labels)

modelo <- keras_model_sequential()%>%
  layer_dense(units = 16, activation = "relu", input_shape = c(10000))%>%
  layer_dense(units = 16, activation = "relu")%>%
  layer_dense(units = 1, activation = "sigmoid")

modelo%>%compile(
  optimizer = optimizer_rmsprop(lr = 0.001),
  loss = loss_binary_crossentropy,
  metrics = metric_binary_accuracy
)  

val_indice <- 1:10000
x_val <- x_train[val_indice,]
y_val <- y_train[val_indice]

x_parcial <- x_train[-val_indice,]
y_parcial <- y_train[-val_indice]

historia <- modelo%>%fit(
  x_parcial,
  y_parcial,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

plot(historia)

resultado <- modelo%>%evaluate(x_test, y_test)
resultado$binary_accuracy

modelo%>%predict(x_test[2,])
y_test[1]
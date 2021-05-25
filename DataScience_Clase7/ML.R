library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

#Importacion de la base de datos
entrenamiento <- read_csv("adult.data", col_names = F)
prueba <- read_csv("adult.test", col_names = F, skip = 1)

nombres <- c("age", "workclass", "fnlwgt", "education", "education_num", "marital_status", "occupation", "relationship", "race", "sex", "capital_gain", "capital_loss", "hours_per_week", "native_country", "class")
colnames(entrenamiento) <- nombres
colnames(prueba) <- nombres

#Inspeccion del estado inicial de la base
glimpse(entrenamiento)
glimpse(prueba)

summary(entrenamiento)
summary(prueba)

col_char <- which(sapply(entrenamiento, class) == "character")

for (i in col_char){
  print(unique(entrenamiento[,i]))
}

#Limpieza de la base de datos
entrenamiento <- entrenamiento %>%
  select(-c(fnlwgt, education, relationship)) %>%
  filter(workclass != "?" & occupation != "?" & native_country != "?")

prueba <- prueba %>%
  select(-c(fnlwgt, education, relationship)) %>%
  filter(workclass != "?" & occupation != "?" & native_country != "?")

col_char <- which(sapply(entrenamiento, class) == "character")
##Conversion en factores
for(i in 1:ncol(entrenamiento)){
  if(i %in% col_char){
    entrenamiento[,i] <- as.factor(entrenamiento[[i]])
  }
}

col_char <- which(sapply(prueba, class) == "character")
##Conversion en factores
for(i in 1:ncol(prueba)){
  if(i %in% col_char){
    prueba[,i] <- as.factor(prueba[[i]])
  }
}

##Visualizacion de variables numericas entrenamiento
edad1 <- ggplot(entrenamiento, aes(x = age)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
edad2 <- ggplot(entrenamiento, aes(y = age)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

edu1 <- ggplot(entrenamiento, aes(x = education_num)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
edu2 <- ggplot(entrenamiento, aes(y = education_num)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

capg1 <- ggplot(entrenamiento, aes(x = capital_gain)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
capg2 <- ggplot(entrenamiento, aes(y = capital_gain)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

capl1 <- ggplot(entrenamiento, aes(x = capital_loss)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
capl2 <- ggplot(entrenamiento, aes(y = capital_loss)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

horas1 <- ggplot(entrenamiento, aes(x = hours_per_week)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
horas2 <- ggplot(entrenamiento, aes(y = hours_per_week)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

grid.arrange(edad1, edad2, edu1, edu2, horas1, horas2, ncol = 2, nrow = 3)
grid.arrange(capg1, capg2, capl1, capl2, ncol = 2, nrow = 2)

entrenamiento <- entrenamiento %>%
  filter(capital_gain <= 50000)

##Visualizacion de variables numericas prueba
edad3 <- ggplot(prueba, aes(x = age)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
edad4 <- ggplot(prueba, aes(y = age)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

edu3 <- ggplot(prueba, aes(x = education_num)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
edu4 <- ggplot(prueba, aes(y = education_num)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

capg3 <- ggplot(prueba, aes(x = capital_gain)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
capg4 <- ggplot(prueba, aes(y = capital_gain)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

capl3 <- ggplot(prueba, aes(x = capital_loss)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
capl4 <- ggplot(prueba, aes(y = capital_loss)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

horas3 <- ggplot(prueba, aes(x = hours_per_week)) +
  geom_density(color = "darkgreen", fill = "green", alpha = 0.4)
horas4 <- ggplot(prueba, aes(y = hours_per_week)) +
  geom_boxplot(color = "darkblue", fill = "blue", alpha = 0.4)

grid.arrange(edad3, edad4, edu3, edu4, horas3, horas4, ncol = 2, nrow = 3)
grid.arrange(capg3, capg4, capl3, capl4, ncol = 2, nrow = 2)

prueba <- prueba %>%
  filter(capital_gain <= 50000)

##Analisis de variables categoricas
entrenamiento %>%
  select(workclass, class) %>%
  group_by(workclass, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = workclass, fill = class)) +
  geom_bar(position = "dodge")

entrenamiento %>%
  select(marital_status, class) %>%
  group_by(marital_status, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = marital_status, fill = class)) +
  geom_bar(position = "dodge")

entrenamiento %>%
  select(occupation, class) %>%
  group_by(occupation, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = occupation, fill = class)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

entrenamiento %>%
  select(race, class) %>%
  group_by(race, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = race, fill = class)) +
  geom_bar(position = "dodge")

entrenamiento %>%
  select(sex, class) %>%
  group_by(sex, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = sex, fill = class)) +
  geom_bar(position = "dodge")

entrenamiento %>%
  select(native_country, class) %>%
  group_by(native_country, class) %>%
  summarize(total = n())
ggplot(entrenamiento, aes(x = native_country, fill = class)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#Guardar archivo csv
write.csv(entrenamiento, "EntrenamientoCenso.csv")

prueba_cat <- prueba$class
prueba <- prueba[,-12]

write.csv(prueba, "PruebaCenso.csv")
write.csv(prueba_cat, "CategoriasPruebaCenso.csv")

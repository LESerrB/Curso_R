library(class)
library(fastDummies)
library(tibble)

glimpse(entrenamiento)

#Normalizacion
normalizacion<- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

for(i in 1:ncol(entrenamiento)){
  if(!(i %in% col_char)){
    entrenamiento[,i] <- normalizacion(entrenamiento[,i])
  }
}

summary(entrenamiento)

for(i in 1:ncol(prueba)){
  if(!(i %in% col_char)){
    prueba[,i] <- normalizacion(prueba[,i])
  }
}

e_dummy <- entrenamiento %>%
  select(-class) %>%
  dummy_cols() %>%
  select(-col_char)
p_dummy <- prueba %>%
  dummy_cols() %>%
  select(-col_char)

which(names(e_dummy) %in% names(p_dummy) == F)
names(e_dummy)
p_dummy <- add_column(p_dummy, "native_country_Holand-Netherlands" = rep(0, nrow(p_dummy)), .after = 53)

#Aplicacion de kNN
sqrt(nrow(e_dummy))

censo_pred <- knn(e_dummy, p_dummy, entrenamiento$class, k = 173)
mconf_1 <- table(prueba_cat, censo_pred)
1 - ((mconf_1[1,2] + mconf_1[2,1])/sum(mconf_1))

censo_pred2 <- knn(e_dummy[,-c(6:11, 19:37, 40:80)], p_dummy[,-c(6:11, 19:37, 40:80)], entrenamiento$class, k = 173)
mconf_2 <- table(prueba_cat, censo_pred2)
1 - ((mconf_2[1,2] + mconf_2[2,1])/sum(mconf_2))

censo_pred3 <- knn(e_dummy[,-c(6:11, 19:37, 40:80)], p_dummy[,-c(6:11, 19:37, 40:80)], entrenamiento$class, k = 499)
mconf_3 <- table(prueba_cat, censo_pred3)
1 - ((mconf_3[1,2] + mconf_3[2,1])/sum(mconf_3))

censo_pred4 <- knn(e_dummy[,-c(6:11, 19:37, 40:80)], p_dummy[,-c(6:11, 19:37, 40:80)], entrenamiento$class, k = 50)
mconf_4 <- table(prueba_cat, censo_pred4)
1 - ((mconf_4[1,2] + mconf_4[2,1])/sum(mconf_4))

aciertos <- c(rep(0,28))

for (i in seq(40,175, by = 5)) {
  censo_pred5 <- knn(e_dummy[,-c(6:11, 19:37, 40:80)], p_dummy[,-c(6:11, 19:37, 40:80)], entrenamiento$class, k = i)
  mconf_5 <- table(prueba_cat, censo_pred5)
  aciertos[(i-35)/5] <- 1 - ((mconf_5[1,2] + mconf_5[2,1])/sum(mconf_5))
}

resultados <- data.frame(k = seq(40,175, by = 5), aciertos = aciertos)
ggplot(resultados, aes(x = k, y = aciertos)) +
  geom_point(color = "darkgreen", fill = "green", alpha = 0.4) +
  ylim(0.83, 0.84)

which.max(resultados$aciertos)
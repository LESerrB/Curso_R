library(tidyverse)
library(neuralnet)
library(GGally)
url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00243/yacht_hydrodynamics.data"
yate<-read_table(file = url, col_names = c("Flotabilidad","Coe_pris","Long_desp","viga_tiro","long_vira","Num_froude","res_resid")) %>%
  na.omit()
ggpairs(yate,title = "Matriz de dispersion de las caracteristicas de las variables")

escala <- function(x){
  (x-min(x))/(max(x)-min(x))
}

yate <- yate%>%
  mutate_all(escala)

set.seed(123)
yate_entrena <- sample_frac(tbl = yate, replace = F, size = 0.8)
yate_prueba <- anti_join(yate, yate_entrena)
str(yate_prueba)

NN1 <- neuralnet(res_resid~Flotabilidad+Coe_pris+Long_desp+viga_tiro+long_vira+Num_froude, data = yate_entrena)

NN1$weights
plot(NN1,rep = "best")
NN1_SSE <- sum((NN1$net.result-yate_entrena[,7])^2)/2

NN1_prueba <- compute(NN1,yate_prueba[,1:6])$net.result
NN1_SSE2 <- sum((NN1_prueba - yate_prueba[,7])^2)/2

salida_real <- NN1_prueba*(max(yate_prueba[,7])) + min(yate_prueba[,7])
data.frame(NN1_prueba, salida_real)
data.frame(NN1_SSE, NN1_SSE2)

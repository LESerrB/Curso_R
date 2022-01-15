# **10. Introducción a Clustering**
## **Código**
### **Clustering K-means**
```r
library(readr)
library(ggplot2)
library(plotly)

#Importacion de datos
clientes <- read_csv("C:/Users/Abraham Alvarado/Documents/Censo UCI/Customers_Spend.csv")

#k-Means
set.seed(2020)
modelo_1 <- kmeans(clientes, centers = 2, nstart = 20)
modelo_1
modelo_1$tot.withinss
modelo_1$betweenss
modelo_1$totss == modelo_1$tot.withinss + modelo_1$betweenss

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_1$cluster, colorscale= "Portland",
                      showscale=TRUE, colorbar=list(title='Cluster')))

#Busqueda de k
k <- c(2:10)
ratio <- c(rep(0,length(k)))

for(i in min(k):max(k)){
  set.seed(2020)
  model <- kmeans(clientes, centers = i, nstart = 20)
  ratio[i-1] <- model$tot.withinss / model$totss
}

resultados <- data.frame(k = k, ratio = ratio)

ggplot(resultados, aes(x = k, y = ratio)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_hline(yintercept = 0.1, linetype = "dashed")

#Visualizacion del clustering
set.seed(2020)
modelo_2 <- kmeans(clientes, centers = 6, nstart = 20)

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_2$cluster, colorscale= "Portland",
                      showscale=TRUE, colorbar=list(title='Cluster')))

set.seed(2020)
modelo_3 <- kmeans(clientes, centers = 4, nstart = 20)

plot_1 <- plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_3$cluster, colorscale= "Portland",
                      showscale = TRUE, colorbar = list(title='Cluster'))) %>%
  layout(
    title = "Clustering de compras en supermercado",
    scene = list(
      xaxis = list(title = "Gasto en Leche"),
      yaxis = list(title = "Gasto en Abarrotes"),
      zaxis = list(title = "Gasto en Comida Congelada")
    ))

add_trace(plot_1, data = as.data.frame(modelo_3$centers),
          x = ~Milk, y = ~Grocery, z = ~Frozen,
          showlegend = FALSE, mode= 'markers',
          marker = list(color = "purple"))
```

### **Clustering jerárquico**
```r
library(ggplot2)
library(plotly)

distancias <- dist(clientes, method = "euclidean")

#Metodo enlace simple
modelo_simple <- hclust(distancias, method = "single")
plot(modelo_simple)
rect.hclust(modelo_simple, k = 4, border = 2:6)

modelo_simple_cort <- cutree(modelo_simple, k = 4)

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_simple_cort, colorscale= "Portland",
                      showscale = TRUE, colorbar = list(title='Cluster'))) %>%
  layout(
    title = "Clustering de compras en supermercado",
    scene = list(
      xaxis = list(title = "Gasto en Leche"),
      yaxis = list(title = "Gasto en Abarrotes"),
      zaxis = list(title = "Gasto en Comida Congelada")
    ))

#Metodo enlace completo
modelo_completo <- hclust(distancias, method = "complete")
plot(modelo_completo)
rect.hclust(modelo_completo, h = 15000, border = 2:6)

modelo_completo_cort <- cutree(modelo_completo, h = 15000)

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_completo_cort, colorscale= "Portland",
                      showscale = TRUE, colorbar = list(title='Cluster'))) %>%
  layout(
    title = "Clustering de compras en supermercado",
    scene = list(
      xaxis = list(title = "Gasto en Leche"),
      yaxis = list(title = "Gasto en Abarrotes"),
      zaxis = list(title = "Gasto en Comida Congelada")
    ))

#Metodo enlace promedio
modelo_promedio <- hclust(distancias, method = "average")
plot(modelo_promedio)
rect.hclust(modelo_promedio, k = 3, border = 2:6)

modelo_promedio_cort <- cutree(modelo_promedio, k = 3)

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_promedio_cort, colorscale= "Portland",
                      showscale = TRUE, colorbar = list(title='Cluster'))) %>%
  layout(
    title = "Clustering de compras en supermercado",
    scene = list(
      xaxis = list(title = "Gasto en Leche"),
      yaxis = list(title = "Gasto en Abarrotes"),
      zaxis = list(title = "Gasto en Comida Congelada")
    ))

#Metodo enlace centroide
modelo_centroide <- hclust(distancias, method = "average")
plot(modelo_centroide)
rect.hclust(modelo_centroide, k = 3, border = 2:6)

modelo_centroide_cort <- cutree(modelo_centroide, k = 3)

plot_ly(clientes, x = ~Milk, y = ~Grocery, z = ~Frozen,
        type= 'scatter3d', mode= 'markers', opacity = 0.7,
        marker = list(color = modelo_centroide_cort, colorscale= "Portland",
                      showscale = TRUE, colorbar = list(title='Cluster'))) %>%
  layout(
    title = "Clustering de compras en supermercado",
    scene = list(
      xaxis = list(title = "Gasto en Leche"),
      yaxis = list(title = "Gasto en Abarrotes"),
      zaxis = list(title = "Gasto en Comida Congelada")
    ))
```

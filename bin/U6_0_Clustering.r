###### Unidad 6 ######
#### Sesión 6.0 EXTRA
## Lunes 23 de junio de 2025
## Nelly Jazmín Pacheco Cruz
## Análisis de agrupamiento (Clustering)
# Fuente: https://remiller1450.github.io/s230f19/clustering.html

#### Ejemplo sencillo
# Cargar librería magrittr
library(magrittr)

# Cargar el conjunto de datos iris
data(iris)

# Seleccionar solo las variables numéricas
datos <- iris[, 1:4]

# Realizar análisis de agrupamiento utilizando el algoritmo de k-means
set.seed(123) # Fijar semilla para reproducibilidad
clusters <- kmeans(datos, centers = 3) # ¿Por qué usamos una k = 3 ?

# Mostrar los resultados
print(clusters)


# Visualizar los grupos
datos %>%
  plot(col = clusters$cluster, pch = 20, main = "Clustering de flores iris")


## Empecemos con los métodos más usados para análisis de agrupamiento


library(cluster)     ## Funciones para el análisis de agrupamiento
library(factoextra)  ## Funciones para la visualización de los agrupamientos
library(tidyr)       ## Manipulación de datos
library(dplyr)       ## Manipulación de datos

# k-Means Clustering


#Utilizaremos al base de datos de arrestos en EUA
# Describir la base de datos y realizar k-means 
USArrests %>%
  print() %>%
  kmeans(centers = 3, nstart = 20) -> k2 #Ejecutamos el análisis de k-means considerado k = 2


# Visualización del agrupamiento
### repel, para que las etiquetas de los nombres no se sobrelapen
fviz_cluster(k2, data = USArrests, repel = TRUE)

#K = 3 y K = 4

### Estandarización
Std_USArrests <- scale(USArrests)

#Análisis de agrupamiento k-means
ks <- kmeans(Std_USArrests, centers = 2, nstart = 20)

#Visualización del agrupamiento
fviz_cluster(ks, data = Std_USArrests, repel = TRUE)

# Descripción o resumen de cada cluster
ks$centers
#¿Notas diferencias entre el cluster 1 y el 2 (filas)?
ks$cluster

## Elección de K 

#### El método Elbow (codo)

fviz_nbclust(Std_USArrests, kmeans, method = "wss", k.max = 8)

head(USArrests)


#### El método Silhouette

fviz_nbclust(Std_USArrests, kmeans, method = "silhouette", k.max = 8)

k2 <- kmeans(USArrests, centers = 2, nstart = 25)
sil <- silhouette(k2$cluster, dist(USArrests), ordered = FALSE)
row.names(sil) <- row.names(USArrests) # Needed to use label option
fviz_silhouette(sil, label = TRUE)
k2$cluster
#### El método Gap

#### ¿Qué son las barras en los puntos?
fviz_nbclust(Std_USArrests, kmeans, method = "gap", k.max = 8)


#### PAM Clustering

pam_std <- pam(Std_USArrests, k = 2)
pam_std$medoids  ## Imprime los medoids
fviz_cluster(pam_std) ## Grafica los clusters
class(pam_std)
################## Intermedio para que prueben k= 2 y k=4



#### Agrupación jerárquica (hierarchical clustering)

d <- get_dist(scale(USArrests))  ## Hierarchical Clustering requires a distance matrix
ag <- agnes(d)  ## AGNES
fviz_dend(ag, cex = 0.4, k = 2)


di <- diana(d)  ## DIANA
fviz_dend(di, cex = 0.4, k = 2)

################## Intermedio para que prueben k= 2 y k=5

#### Variables categóricas y distancia de Gower
#Descargar la base de datos IowaCityHomeSales
homes <- read.csv("https://remiller1450.github.io/data/IowaCityHomeSales.csv")
#Seleccionamos un conjunto de variables numéricas y con caracteres
homes2 <- select(homes, style, built, bedrooms, bsmt, ac, area.living, area.lot)

### Paso extra para convertir las columnas con datos de caracteres a factores
homes2$style <- as.factor(homes2$style)
homes2$bsmt <- as.factor(homes2$bsmt)
homes2$ac <- as.factor(homes2$ac)
#
## Usa daisy para calcular la matriz de distancias
D <- daisy(homes2, metric = "gower") 
D
## Podemos ver la matriz de distancias
fviz_dist(D, show_labels = FALSE)  

# Para observar los medoides
pam_homes <- pam(D, k = 3)
homes2[pam_homes$medoids, ]  ## Muestra los medoides


# Comprobar si el número de cluster (k) es el óptimo

### Anchura media de Silhouette
avg_sil = numeric(9) ## Configurar el objeto para almacenar el ancho medio de la silueta para cada posible k
for(k in 2:10){
  pam_homes <- pam(D, k = k)
  avg_sil[k-1] <- pam_homes$silinfo$avg.width
}
plot(x = 2:10, y = avg_sil, type = "b", xlab = "k", ylab = "Avg Silhouette")

### Método Elbow 
elbow = numeric(9)
for(k in 2:10){
  pam_homes <- pam(D, k = k)
  elbow[k-1] <- pam_homes$objective[1]
}
plot(x = 2:10, y = elbow, type = "b", xlab = "k", ylab = "Objective")



### Ejercicio: con la base datos de Iris que revisamos al inicio de la sesión ejecuta el método del codo para elegir el K óptimo.

fviz_nbclust(datos, kmeans, method = "wss", k.max = 8)

# Prueba con otros métodos para determinar el número óptimo de K

irisK <- kmeans(datos, centers = 2, nstart = 20)

# Visualización del agrupamiento

fviz_cluster(irisK, data = datos)

# Para que las etiquetas no se sobrelapen
fviz_cluster(irisK, data = datos, repel = TRUE)

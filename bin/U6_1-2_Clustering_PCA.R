###### Sesión de la Unidad 6 ######
## Lunes 24 de junio de 2024
## Nelly Jazmín Pacheco Cruz
## Análisis de agrupamiento (Clustering)
# Fuente: https://remiller1450.github.io/s230f19/clustering.html

#### Ejemplo sencillo

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
plot(datos, col = clusters$cluster, pch = 20, main = "Clustering de flores iris")


## Empecemos con los métodos más usados para análisis de agrupamiento


library(cluster)     ## Funciones para el análisis de agrupamiento
library(factoextra)  ## Funciones para la visualización de los agrupamientos
library(tidyr)       ## Manipulación de datos
library(dplyr)       ## Manipulación de datos

# k-Means Clustering


#Utilizaremos al base de datos de arrestos en EUA
#Describir la base de datos:
head(USArrests)
#dim(USArrests)
class(USArrests)

# Ejecutamos el análisis de k-means considerado k = 2 y que empezamos 
k2 <- kmeans(USArrests, centers = 2, nstart = 20)

# Visualización del agrupamiento

fviz_cluster(k2, data = USArrests)

### Para que las etiquetas de los nombres no se sobrelapen
fviz_cluster(k2, data = USArrests, repel = TRUE)

# Intermedio para que prueben K = 3 y K = 4.

### Estandarización
Std_USArrests <- scale(USArrests)

#Análisis de agrupamiento k-means
ks <- kmeans(Std_USArrests, centers = 2)

#Visualización del agrupamiento
fviz_cluster(ks, data = Std_USArrests)

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

#### El método Gap

#### ¿Qué son las barras en los puntos?
fviz_nbclust(Std_USArrests, kmeans, method = "gap", k.max = 8)


#### PAM Clustering

pam_std <- pam(Std_USArrests, k = 4)
pam_std$medoids  ## Imprime los medoids
fviz_cluster(pam_std) ## Grafica los clusters
class(pam_std)
################## Intermedio para que prueben k= 2 y k=4



#### Agrupación jerárquica (hierarchical clustering)

d <- get_dist(scale(USArrests))  ## Hierarchical Clustering requires a distance matrix
ag <- agnes(d)  ## AGNES
fviz_dend(ag, cex = 0.4, k = 4)


di <- diana(d)  ## DIANA
fviz_dend(di, cex = 0.4, k = 4)

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

#########################################################################
#########################################################################
#########################################################################

## Análisis de Agrupamiento y de Componentes Principales (PCA)
## Nelly Jazmín Pacheco Cruz
## Fuentes de referencia: https://rstudio-pubs-static.s3.amazonaws.com/841127_fd111ed9c6a040e1a90e92686f90e3f8.html
## https://bookdown.org/jsalinas/tecnicas_multivariadas/acp.html


# Empecemos un ejemplo sencillo de un PCA con la base de datos de iris

# Cargar bibliotecas
library(ggplot2)
library(dplyr)

# Cargar el conjunto de datos iris
data(iris)

# Seleccionar solo las variables numéricas
datos <- iris[, 1:4]

# Realizar el PCA con la función prcomp del paquete Stats

pca_resultado <- prcomp(datos, scale. = TRUE)

# Obtener las coordenadas de los componentes principales
coordenadas_pca <- as.data.frame(pca_resultado$x)

# Añadir la especie como variable para el color
coordenadas_pca$especie <- iris$Species

# Crear un gráfico de dispersión de los componentes principales
ggplot(coordenadas_pca, aes(x = PC1, y = PC2, color = especie)) +
  geom_point() +
  labs(x = "PC1", y = "PC2", title = "PCA de conjunto de datos iris")



#### Exploración de un PCA con FactoMineR
# Vamos a utilizar los conjuntos de datos de demostración `decathlon2` del paquete `factoextra`. 

#Carga las bibliotecas:
library(FactoMineR) # Análisis de PCA
library(factoextra) # Base de datos
library(ggplot2) # Para graficar resultados

# Carga la base de datos decathlon2
data(decathlon2)

#Explora la base de datos; recuerda otras funciones además de head()?
head(decathlon2)

#Subconjunto que consiste en las primeras 23 filas y las primeras 10 columnas del conjunto de datos decathlon2
decathlon2.active <- decathlon2[1:23, 1:10]
#Para ver las primeras 4 filas y las primeras 6 columnas 
head(decathlon2.active[, 1:6], 4)

# PCA con FactoMineR
res.pca <- PCA(decathlon2.active, graph = FALSE) 
#¿Qué pasa si cambias el parámetro graph de False a True?

















# Los valores propios y la proporción de varianza (es decir, la información) retenida por los componentes principales PC pueden extraerse utilizando la función get_eigenvalue()

eig.val <- get_eigenvalue(res.pca)
eig.val

# Visualización con factoextra de los eigenvalues

fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))

# Graficar las variables

var <- get_pca_var(res.pca)
var

head(var$coord)

# Cos2: calidad en el mapa de factores
head(var$cos2)

# Contribuciones a los componentes principales
head(var$contrib)

# Círculo de correlación
head(var$coord, 4)
fviz_pca_var(res.pca, col.var = "pink")

# Colores para valores de cos2
fviz_pca_var(res.pca, col.var = "cos2",
             
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE )

# Contribuciones de variables a PCs


# Las variables mas importantes son subrayadas en correlacion con la siguiente funcion.
fviz_pca_var(res.pca, col.var = "contrib",
             
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))


# Gráfico de individuos
ind <- get_pca_ind(res.pca)
ind

# Graficos: Calidad y contribucion
fviz_pca_ind(res.pca)


# Agregamos colores y puntos
fviz_pca_ind(res.pca, col.ind = "cos2", pointsize = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE )


####################
### Vamos a hacer un PCA con los datos del curso U3_2.csv

# Primero hay que cargar los datos csv en R
data_expresion <- read.csv("../data/U3_2.csv", header = T, sep = ",")

#Verifica que los datos esten bien
data_expresion
# Para ver las primeras filas
head(data_expresion)

# Realiza un PCA con el paquete FactoMineR

expresion.pca <- PCA(data_expresion[,-5], graph=T)

# se utilizara el argumento ’col.ind´ para especificar el factor variable para colorear los datos individuales por grupos. 
# Para añadir una elipse de concentración alrededor de cada grupo, especifique el argumento ’addEllipses=TRUE´

fviz_pca_ind(expresion.pca, geom.ind = "point", # show points only (but not "text")
             col.ind = data_expresion$Etapas, # color by groups
             palette = c("#FF6666", "#3399FF", "#99FF99"),
             addEllipses = F, # Concentration ellipses
             legend.title = "Groups")
head(data_expresion)


# Añadir elipses de confianza
fviz_pca_ind(expresion.pca, geom.ind = "point", 
             col.ind = data_expresion$Etapas,
             palette = c("#6666FF", "#CC0099", "#00CCCC"),
             addEllipses = TRUE, ellipse.type = "confidence",
             legend.title = "Groups")


fviz_pca_ind(expresion.pca,label = "all", # hide individual labels
             col.ind = data_expresion$Etapas, # color by groups
             addEllipses = TRUE, # Concentration ellipses
             palette = "jco")

fviz_pca_ind(expresion.pca, geom.ind = "point",
             
             col.ind = data_expresion$Etapas, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, ellipse.type = "confidence",
             legend.title = "Groups"
)


fviz_pca_ind(expresion.pca, geom.ind = "point",
             
             col.ind = data_expresion$Etapas, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, ellipse.type = "convex",
             legend.title = "Groups"
)


fviz_pca_var(expresion.pca, axes.linetype = "blank")

#Revisar:
#fviz_pca_biplot(expresion.pca, repel = TRUE,col.var = "#FF0000",col.ind = "#696969" )


#hacer una biplot de individuos y variables
#cambiar el color de los individuos por grupos: col.ind = iris $ Species
#mostrar solo las etiquetas de las variables: label = “var” o usar geom.ind = “point”

fviz_pca_biplot(expresion.pca,col.ind = data_expresion$Etapas, palette = "jco",
                addEllipses = TRUE, label = "var",
                col.var = "black", repel = TRUE,
                legend.title = "Species")


head(data_expresion)
fviz_pca_biplot(expresion.pca, 
                geom.ind = "point", # relleno indivual por grupos
                pointshape = 21,
                pointsize = 2.5,
                fill.ind = data_expresion$Etapas,
                col.ind = "black",
                # Color de las variables por grupo.
                col.var = factor(c("TAR", "ARF", "CO", "GA")),
                legend.title = list(fill = "Etapas", color = "Genes"),
                repel = TRUE) + # Evite el trazado excesivo de etiquetas
ggpubr::fill_palette("jco") + # Color individual de relleno
ggpubr::color_palette("npg")


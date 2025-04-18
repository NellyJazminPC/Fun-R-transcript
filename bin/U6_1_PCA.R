###### Unidad 6 ######
#### Sesión 6.1
## Lunes 23 de junio de 2025

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

#Obten los eigenvalores que resultaron del análisis PCA
eig.val <- get_eigenvalue(res.pca)

eig.val 

# Visualización de los eigenvalues - Scree plot

fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))

# Para extraer información sobre las variables
var <- get_pca_var(res.pca)

#Explora el objeto recien creado
var

# Coordenadas de las variables
var$coord

# Cos2: calidad en el mapa de factores
var$cos2

# Contribuciones a los componentes principales
var$contrib

# Círculo de correlación
head(var$coord, 4) # volvemos a ver las coordenadas de las variables
fviz_pca_var(res.pca, col.var = "blue") #generamos el gráfico 

# Colores para valores de cos2
fviz_pca_var(res.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE ) +
  ggtitle("Variables en el primer plano factorial")

#¿Puedes cambiar el gradiente de colores?

# Contribuciones de variables a los PCs

# Las variables mas importantes son subrayadas en correlacion con la siguiente funcion.
fviz_pca_var(res.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))


# PCA con individuos (muestras/filas)
ind <- get_pca_ind(res.pca)
ind

# Graficos: Calidad y contribucion
fviz_pca_ind(res.pca)

# ¿Recuerdas como era la base de datos con la que se hizo el PCA?
head(decathlon2.active)
dim(decathlon2)

# Agregamos colores y puntos
fviz_pca_ind(res.pca, col.ind = "cos2", pointsize = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE )

####################
### Vamos a hacer un PCA con los datos del curso U3_2.csv

# Primero hay que cargar los datos csv en R
data_expresion <- read.csv("../data/U3_2.csv", 
                           header = T, sep = ",")

#Verifica que los datos esten bien
data_expresion
# Para ver las primeras filas
head(data_expresion)

# Realiza un PCA con el paquete FactoMineR

expresion.pca <- PCA(data_expresion[,-5], graph = T)

# se utilizara el argumento ’col.ind´ para especificar el factor variable para colorear los datos individuales por grupos. 
# Para añadir una elipse de concentración alrededor de cada grupo, especifique el argumento ’addEllipses=TRUE´

fviz_pca_ind(expresion.pca, geom.ind = "point", # muestra solo los puntos (pero sin "texto")
             col.ind = data_expresion$Etapas, # colorea por grupos
             palette = c("#FF6666", "#3399FF", "#99FF99"),
             addEllipses = T, # Elipses de concentración
             legend.title = "Groups")

# Añadir elipses de confianza
fviz_pca_ind(expresion.pca, geom.ind = "point", 
             col.ind = data_expresion$Etapas,
             palette = c("#6666FF", "#CC0099", "#00CCCC"),
             addEllipses = TRUE, ellipse.type = "confidence",
             legend.title = "Groups")
# ¿Qué pasa si cambias el argumento para el tipo de elipse?
# ellipse.type = "t"

# Cambiar la paleta de colores y agrega las etiquetas de los individuos
fviz_pca_ind(expresion.pca,label = "all", # muestra todas las etiquetas individuales
             col.ind = data_expresion$Etapas, # colorea por grupo
             addEllipses = TRUE, 
             palette = "jco")


# Agregar una elipse convexa
fviz_pca_ind(expresion.pca, geom.ind = "point",
             
             col.ind = data_expresion$Etapas, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, ellipse.type = "convex",
             legend.title = "Groups")


##### Vamos a incorporar las variables y los individuos/muestras/observaciones
# Variables
 fviz_pca_var(expresion.pca, axes.linetype = "blank")

# Biplot de las variables y las muestras/observaciones/individuos
fviz_pca_biplot(expresion.pca, repel = TRUE,col.var = "#FF0000",col.ind = "#696969" )

#Cambia el color de los individuos por grupos: col.ind = iris $ Species
#mostrar solo las etiquetas de las variables: label = “var” o usar geom.ind = “point”

fviz_pca_biplot(expresion.pca,col.ind = data_expresion$Etapas, palette = "jco",
                addEllipses = TRUE, label = "var",
                col.var = "black", repel = TRUE,
                legend.title = "Etapas")


head(data_expresion)

# Agrega más argumentos para personalizar tu gráfico
fviz_pca_biplot(expresion.pca, 
                geom.ind = "point", # colorea los puntos por grupos
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
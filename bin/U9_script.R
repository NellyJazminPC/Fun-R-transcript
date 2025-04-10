######################################################
## Tema: Unidad 9: Visualización de resultados      ##
## Autor: Olga Andrea Hernandez Miranda, Miranda H  ##
## Fecha: 29/01/2024                                ##
## Nota: Representación grafica de genes con        ##
## expresion diferencial                            ##
#####################################################
## Paginas de referencia: https://bioconductor.org/packages/release/bioc/vignettes/EnhancedVolcano/inst/doc/EnhancedVolcano.html#introduction
##https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html
##https://www.cienciadedatos.net/documentos/37_clustering_y_heatmaps
##

#Establecemos un directorio
#directorio <- "C:/Users/andii/Documents/Fun-R-transcript-main/data"
#setwd(directorio)


#-------------------Volcano plot---------------------
#Los datos de expresión diferencial se pueden 
# visualizar a traves de una grafica de volcano plot
# donde en el eje de las x se grafica el fold change 
# y en el eje de las y el p-value.
#
#--------------------Librerias-----------------------
BiocManager::install('EnhancedVolcano', force = TRUE)
#install.packages('BiocManager')
library(BiocManager)
library(EnhancedVolcano)
library("RColorBrewer")
install.packages("proj4")

#Abrimos el archivo con datos de expresión diferencial para graficarlos
resED <- read.table("../data/U9_tabla_ed_crudos_v2.csv", sep = ",", header = T)
head(resED)

#V1
EnhancedVolcano(resED,
  lab = rownames(resED),  # Etiquetas de los puntos en el gráfico
  x = 'log2FoldChange',  # Columna para el eje x, que representa el cambio en el logaritmo base 2
  y = 'pvalue',  # Columna para el eje y, que representa el valor de p
  title = 'SAM vs MI',  # Título del gráfico
  xlab = bquote(~Log[2]~ 'fold change'),  # Etiqueta del eje x, utilizando notación matemática para el cambio en log base 2
  pCutoff = 0.05,  # Umbral de valor de p para significancia
  FCcutoff = 2.0,  # Umbral de cambio fold (log base 2) para considerar como significativo
  pointSize = 2.0,  # Tamaño de los puntos en el gráfico
  labSize = 3.0,  # Tamaño de las etiquetas en el gráfico
  col = c('black', '#009c8c', '#FDE725', '#440154'),  # Vector de colores para diferentes grupos o niveles de significancia
  colAlpha = 1,  # Transparencia de los colores (1 para opaco)
  legendPosition = 'right',  # Posición de la leyenda en el gráfico (a la derecha)
  legendLabSize = 8,  # Tamaño de las etiquetas en la leyenda
  legendIconSize = 4.0,  # Tamaño de los íconos en la leyenda
  drawConnectors = TRUE,  # Si dibujar o no conectores para puntos resaltados
  widthConnectors = 0.5  # Ancho de los conectores
)


#V2

EnhancedVolcano(resED,
                lab = rownames(resED),
                x = 'log2FoldChange',
                y = 'pvalue',
                title = 'SAM vs MI',
                xlab = bquote(~Log[2]~ 'fold change'),
                pCutoff = 10e-5,
                FCcutoff = 2.0,
                pointSize = 2.0,
                labSize = 3.0,
                col = c('black', 'pink', 'purple', 'red3'),
                colAlpha = 1,
                legendPosition = 'right',
                legendLabSize = 8,
                legendIconSize = 4.0,
                drawConnectors = T,
                widthConnectors = 0.5)

#V3
EnhancedVolcano(resED,
                lab = rownames(resED),
                x = 'log2FoldChange',
                y = 'pvalue',
                title = 'SAM vs MI',
                xlab = bquote(~Log[2]~ 'fold change'),
                pCutoff = 10e-5,
                FCcutoff = 2.0,
                pointSize = 2.0,
                labSize = 3.0,
                colAlpha = 1,
                colGradient = c('#009c8c','#440154'), # Gradiente de color
                legendPosition = 'right',
                legendLabSize = 8,
                legendIconSize = 4.0,
                drawConnectors = T,
                widthConnectors = 0.5)

#-------------------Diagrama de Venn--------------------------
# Listas de genes con expresión diferencial para ver las
# coincidencias y diferencias.

#--------------------Librerias-----------------------
#install.packages("VennDiagram")

library(VennDiagram)

# Genes inducidos
SAM_vs_MI <- read.csv("../data/U9_SAM_vs_MI_up.csv", sep = ",", header = TRUE)
head(SAM_vs_MI)

MI_vs_MF <- read.csv("../data/U9_MI_vs_MF_up.csv", sep = ",", header = TRUE)
head(MI_vs_MF)

# Obtener los conjuntos de genes
genes_SAM_vs_MI <- SAM_vs_MI$gene_id
genes_MI_vs_MF <- MI_vs_MF$gene_id

# Graficar diagrama de Venn
venn.plot <- venn.diagram(
  x = list(SAM_vs_MI = genes_SAM_vs_MI, MI_vs_MF = genes_MI_vs_MF), # se especifican los conjuntos que se van a comparar 
  category.names = c("SAM vs MI", "MI vs MF"), # nombres de las categorias
  filename = NULL,  # no se va a guardar el diagrama como un archivo de imagen 
  output = T, # Indica que se debe generar el diagrama y almacenarlo en la variable 
  col = "transparent",  # Color transparente
  fill = c("red", "blue"),  # Colores de de los círculos
  alpha = 0.5,  # Transparencia
  lwd = 2,  # Ancho de los contornos
  cex = 2  # Tamaño del texto
)

# Mostrar diagrama de Venn 
grid.draw(venn.plot)

#--------------------- Genes reprimidos--------------------------------

# Leer los archivos CSV
SAM_vs_MI <- read.csv("../data/U9_SAM_vs_MI_down.csv", sep = ",", header = TRUE)
head(SAM_vs_MI)

MI_vs_MF <- read.csv("../data/U9_MI_vs_MF_down.csv", sep = ",", header = TRUE)
head(MI_vs_MF)

# Obtener los conjuntos de genes
genes_SAM_vs_MI <- SAM_vs_MI$gene_id
genes_MI_vs_MF <- MI_vs_MF$gene_id

# Graficar diagrama de Venn

venn.plot <- venn.diagram(
  x = list(SAM_vs_MI = genes_SAM_vs_MI, MI_vs_MF = genes_MI_vs_MF),
  category.names = c("SAM vs MI", "MI vs MF"),
  filename = NULL,
  output = TRUE,
  col = "transparent",  # Establecer el color transparente
  fill = c("red", "blue"),  # Colores de los círculos
  alpha = 0.5,  # Transparencia
  lwd = 2,  # Ancho de los contornos
  cex = 2  # Tamaño del texto
)

# Mostrar diagrama de Venn 
grid.draw(venn.plot)

#-------------------Grafica de barras ---------------
# Datos de genes inducidos o reprimidos
#
#--------------------Librerias-----------------------
library(ggplot2)

Datos <- read.table("../data/U9_Genes_up_down.csv", sep = ",", header = T)

Datos

colores2 <- c("#00FFC3", "#7A00FF") 

ggplot(Datos, aes(x = Condicion, y = No_de_genes, fill = Condicion)) +
  geom_bar(stat = 'identity', alpha = 0.7, width = 0.4) +
  theme_classic() +
  scale_fill_manual(values = colores2) +
  labs(x = "Condición", y = "Número de genes")


#-------------------Heat map--------------------------
# En el heatmap se reperesentan datos de expresion en TPM
# Se genera un aálisis de conglomerados para identificar
# perfiles de expresion
#
#--------------------Librerias------------------------
library("gplots")
library("RColorBrewer")
library("viridis")
library(lattice)
library(dendextend)

#Crear matriz y normalizar valores
alpha <- 0.01
data <- read.table("../data/U9_HM.csv", sep = ",", header = T)
row.names(data) <- data[,1]
mat_data <- data.matrix(data[,1:ncol(data)]) 
mat_data2 <- mat_data[,-1]
mat_data2

# Sacamos el log2 de la matriz mat_data2
countTable.kept <- log2(mat_data2) #Se obtiene el log2 para reducir diferencias

datos <- countTable.kept

datos <- scale(datos)

#Iniciamos con el Heatmap

#Creamos paletas de colores para heatmap

colores <- viridis(256)

colores2 <- magma(256)

#Version 1
heatmap.2(
  as.matrix(datos),  # Convierte 'datos' a una matriz
  cexCol = 0.3,  # Tamaño de letra para las etiquetas de las columnas
  cexRow = 1,    # Tamaño de letra para las etiquetas de las filas
  labCol = as.expression(lapply(colnames(datos), function(a) bquote(italic(.(a))))),  # Etiquetas de columnas
  trace = "none",  # No mostrar líneas de contorno
  hline = NA,     # No dibujar líneas horizontales adicionales
  margins = c(7, 7),  # Márgenes alrededor
  denscol = "grey",   # Color de fondo para las celdas
  key.title = NA,     # No mostrar título en la leyenda
  col = colores       # paleta de colores
)


#Version 2
heatmap.2(as.matrix (datos),
          cexCol = 0.5,
          cexRow= 1,
          trace="none", hline = NA,         
          margins =c(7,11),
          denscol = "grey",
          key.title=NA,
          col = colores2
)

#clusters para el heatmap
dend_r <- datos %>%  # Toma el dataframe 'datos'
  dist(method = "euclidean") %>%  # Calcula la distancia euclidiana entre las filas de 'datos'
  hclust(method = "average") %>%  # Realiza un agrupamiento jerárquico utilizando el método de enlace promedio
  as.dendrogram %>%  # Convierte el resultado a un objeto dendrograma
  ladderize %>%  # Ordena los nodos del dendrograma para que las ramas más largas estén en la parte inferior
  color_branches(k = 2)  # Colorea las ramas del dendrograma en 2 grupos distintos


dend_c <- t(datos) %>% dist(method = "euclidean") %>%
  hclust(method = "average") %>% 
  as.dendrogram %>% ladderize %>%
  color_branches(k=2)


#Version 2 con clusters
heatmap.2(as.matrix (datos),
          cexCol = 0.1,
          cexRow= 1,
          Rowv = dend_r, # Dendrograma para las filas (dend_r)
          Colv = dend_c, # Dendrograma para las columnas (dend_c)
          trace="none", hline = NA,         
          margins =c(7,11),
          denscol = "grey",
          key.title=NA,
          col = colores
)

# Heatmap con paleta de colores propia

# Define una paleta de colores personalizada
my_palette2<- colorRampPalette(c("blue", "white", "red"))(n = 299)

#Defini los intervalos de expresi?n que queria resaltar, como los datos m?s bajos
#tendian a 0 estan en azul y los m?s altos llegaban hasta 6 por eso est?n en rojo
mycol_breaks2 = c(seq(-1,0.2,length=100),  #azul
                  seq(0.21,0.96,length=100), #blanco   
                  seq(0.97,6,length=100))   #rojo

heatmap.2(datos,
          Rowv = dend_r, # Dendrograma para las filas (dend_r)
          Colv = dend_c, # Dendrograma para las columnas (dend_c)
          notecol = "black",
          scale = "row",
          key = TRUE,
          keysize = c(1.5),
          density.info = "none",
          trace = "none",
          margins = c(12,9),
          col=my_palette2)


#¿Como sabemos cual es el numero correcto de clusters?

library(cluster)     ## Funciones para el análisis de agrupamiento
library(factoextra)  ## Funciones para la visualización de los agrupamientos


#### El método Elbow (codo)

# Determine el numero optimo de custers
n_rows <- nrow(datos) #Determinar el Número de Filas del archivo

# Ensure k.max is within the acceptable range
max_k <- min(8, n_rows - 1)#Establecer el Valor Máximo para k
if (max_k > 1) { #Condición para Asegurar un Número Suficiente de Filas
  fviz_nbclust(datos, kmeans, method = "wss", k.max = max_k) #Visualización del Número Óptimo de Clusters
} else {
  print("No hay suficientes filas.")
}

#### El método Silhouette

# Verificar número de filas
n_rows <- nrow(datos)

# Asegurar que k.max esté dentro del rango aceptable
max_k <- min(8, n_rows - 1)
if (max_k > 1) {
  # Determinación del número óptimo de clusters usando el método silhouette
  fviz_nbclust(Std_USArrests, kmeans, method = "silhouette", k.max = max_k)
} else {
  print("No hay suficientes filas.")
}

# Ta ocmprobamos que si tenemos dos clusters en el Heatmap

#------------Enriquecimiento funcional----------------
# Identificar grupos de genes o rutas metabolicas significativamente 
# enriquecidas, se compara estadisticamente entre el experimento y una base de datos
# En este ejercicio solo se van a graficar los datos obtenidos de 
# las bases de datos.
#--------------------Librerias------------------------
library(ggplot2)
library(forcats)
library(tidyverse) 
library(dplyr)
library(viridis)
library(ggthemes)

mydat <- read.table("../data/U9_BP_bubble.csv", sep = ",", header = T)

head(mydat)

mydat <- mydat[order(mydat$Value, decreasing = TRUE), ]

top10 <- head(mydat, 10)

head(top10)

# Reordenar el eje y basado en Log10Pvalue
top10$GO_term <- reorder(top10$GO_term, -top10$Value)

# Poner el orden al reves
top10$GO_term <- factor(top10$GO_term, levels = rev(levels(top10$GO_term)))

# Grafica de burbija con paleta de colores viridis
ggplot(top10, aes(x = LogSize, y = GO_term)) +
  geom_point(aes(color = Value, size = LogSize)) +
  scale_color_viridis(option = "viridis") +
  theme_bw() +
  theme(axis.text.y = element_text(size = 10))


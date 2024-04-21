# Fundamentos de programación en R

## Unidad 6

---

## 6.1 Análisis de Agrupamiento

---

### ¿Qué es un análisis de agrupamiento?

El análisis de agrupamiento, también conocido como **clustering**, es una técnica de [aprendizaje no supervisado](https://www.linkedin.com/pulse/aprendizaje-supervizado-somosdicsys/) que se utiliza para **identificar grupos** naturales o **patrones** intrínsecos en un conjunto de datos.

El objetivo es **agrupar objetos similares** entre sí en clusters o grupos, mientras que objetos diferentes se asignan a diferentes clusters. Esto se hace **sin tener información previa** sobre las **etiquetas de clase** de los datos, es decir, el algoritmo de agrupamiento busca estructuras subyacentes en los datos sin la necesidad de tener ejemplos previamente etiquetados.

Por ejemplo, en un conjunto de datos de expresión génica de células, el análisis de agrupamiento se puede utilizar para identificar subpoblaciones de células que tienen perfiles de expresión génica similares. Esto puede ayudar a comprender mejor la heterogeneidad celular y a identificar células con funciones similares o estados celulares específicos.

**Ejemplo:**
Vamos a usar el conjunto de datos "iris", que contiene mediciones de diferentes especies de flores iris

```R
# Cargar el conjunto de datos iris
data(iris)

# Seleccionar solo las variables numéricas
datos <- iris[, 1:4]

# Realizar análisis de agrupamiento utilizando el algoritmo de k-means
set.seed(123) # Fijar semilla para reproducibilidad
clusters <- kmeans(datos, centers = 3)

# Mostrar los resultados
print(clusters)

# Visualizar los grupos
plot(datos, col = clusters$cluster, pch = 20, main = "Clustering de flores iris")

```

### K-means

En el ejemplo anterior, como habrás notado usamos la función `kmeans`, ¿qué es el método k-Means?

El k-Means Clustering es una técnica de agrupamiento que divide un conjunto de datos en k clusters, donde cada cluster contiene objetos similares entre sí y diferentes de los objetos en otros clusters.


![alt text](k-means-clusters.gif)


A continuación vamos a profundizar en este método en R

```R
#Cargamos las siguientes bibliotecas
library(cluster)     ## Funciones para el análisis de agrupamiento
library(factoextra)  ## Funciones para la visualización de los agrupamientos
library(tidyr)       ## Manipulación de datos
library(dplyr)       ## Manipulación de datos
```



Con esta función podemos agrupar los estados de los datos de USArrests en dos clusters. 

```R
 k2 <- kmeans(USArrests, centers = 2, nstart = 25)
 ```

 
El argumento `centers` describe el número de grupos (clusters) que queremos (es decir, k), mientras que `nstart` describe un punto de partida para el algoritmo. 

Podemos visualizar estos clusters usando `fviz_cluster`, que muestra los clusters utilizando un gráfico de dispersión donde las dos primeras puntuaciones de componentes principales definen las coordenadas X-Y de cada observación. 

```R
fviz_cluster(k2, data = USArrests)
 ```

Nota que la función `fviz_cluster` etiqueta cada punto. Esa etiqueta viene definida por default como el nombres de las filas (rownames) pero puedes cambiarlas con la función `rownames`. Además, si no quieres que las etiquetas de los nombres se sobrelapen en el gráfico puedes usar `repel = TRUE`.

```R
fviz_cluster(k2, data = USArrests, repel = TRUE)
```

Por otro lado, ya que las variables de la base de datos USArrests están en escalas diferentes, se recomienda la [estandarización de los datos](https://nicolasurrego.medium.com/transformando-datos-en-oro-c%C3%B3mo-la-estandarizaci%C3%B3n-y-normalizaci%C3%B3n-mejoran-tus-resultados-fbe0840d2b94#:~:text=Al%20estandarizar%20los%20datos%2C%20se,2022.) y esto lo puedes hacer con la función `scale` antes de la agrupación.

```R
# Estandarización
Std_USArrests <- scale(USArrests)
#Análisis de agrupamiento k-means
ks <- kmeans(Std_USArrests, centers = 2)
#Visualización del agrupamiento
fviz_cluster(ks, data = Std_USArrests)
```

La estandarización ayuda a que cada variable tenga la misma importancia a la hora de determinar los grupos. En muchos casos, estandarizar los datos es lo más recomendado, pero hay algunas situaciones en las que es mejor agrupar en clusters datos no estandarizados, más adelante veremos un ejemplo. 

Después del análisis de agrupamiento podemos revisar cada uno de los grupos generados mediante una breve descripción o un resumen de ellos, para esto podemos usar los centros de los clusters, que en este caso son los valores medios de cada miembro del cluster para cada variable.

```R
# Descripción o resumen de cada cluster
ks$centers
```

Después de ejecutar este código podrás ver que el primer _cluster_ contiene estados con bajos índices de delincuencia y menor urbanización, mientras que el segundo _cluster_ contiene estados con mayores índices de delincuencia y mayor urbanización.

Para interpretar los centros de los _clusters_ es importante considerar si los datos fueron estandarizados antes del análisis de agrupación. Para el ejemplo que acabamos de hacer incluimos la estandarización de los datos, por lo que los centros están en unidades estandarizadas y hay que describirlas e interpretarlas considerando esto.

### ¿Cuántos grupos (clusters) hay que elegir?

¿Pará necesitamos saber el número de grupos? Como vimos anteriormente con el análisis _k-means_ se requiere especificar el número de grupos posibles (_k_) para poder ejecutar el análisis, sin embargo, si recién estamos explorando nuestros datos resultará complicado elegir el número óptimo de grupos (_k_). 

De manera general, se recomienda de _k_ sea lo suficientemente grande como para generar _clusters_ relativamente homogéneos, pero lo suficientemente pequeño como para limitar la complejidad innecesaria. Para resolver esta complicación se han empleado varias técnicas:

- El método Elbow (codo)
- El método Silhoutte
- El estadístico Gap

> **Extra:** Este problema de elegir el _k_ óptimo no es exclusivo del análisis k-means, y lo podemos encontrar en otros análisis de agrupamiento. Por ejemplo, para análisis de estructura genética los programas como [fastStructure](https://rajanil.github.io/fastStructure/) y [ADMIXTURE](https://dalexander.github.io/admixture/) necesitan que ingreses el número de grupos que crees que hay en tus datos (k).

#### El método Elbow (codo)

El algoritmo de _k-means_ minimiza el "Total withiness" (_wss_) y siempre va a disminuir conforme _k_ aumenta, pero llegará un punto en que la dismunición se estabilice aunque sigamos aumentando el valor de _k_.

Podemos visualizar esto con la función `fviz_nbclust`.

```R
fviz_nbclust(Std_USArrests, kmeans, method = "wss", k.max = 8)
```

El método Elbow sugiere que el número óptimo de _clusters_ debe elegirse en función del "codo" de este gráfico, es decir, el punto en el que la línea parece curvarse formando un codo.

En el ejemplo de USArrests, el método Elbow sugiere que 2 ó 3 grupos serían razonables, ya que más grupos no contribuyen mucho a reducir la wss.

#### El método Silhouette

Este método mide cuantitativamente la adecuación de cada punto del set de datos al cluster asignado en comparación con los clusters vecinos. Proporciona una "puntuación de silueta" (silhouette score) para cada punto del set de datos, que oscila entre -1 y 1, y representa la calidad de la solución de agrupación. Una puntuación más alta indica que ese punto de los datos se ajusta bien a su clúster, mientras que una puntuación más baja sugiere que podría pertenecer a un clúster diferente. El análisis de siluetas nos permite evaluar la estructura de agrupación y seleccionar el valor de _k_ que maximiza la puntuación media.

```R
fviz_nbclust(Std_USArrests, kmeans, method = "silhouette", k.max = 8)
```

Para los datos de USArrest, este método sugiere que _K = 2_ es óptima.
El método Silhouettes también se utiliza para comprender mejor la "pertenencia a un cluster" (cluster membership) de las observaciones individuales.

```R
k2 <- kmeans(USArrests, centers = 2, nstart = 25)
sil <- silhouette(k2$cluster, dist(USArrests), ordered = FALSE)
row.names(sil) <- row.names(USArrests) # Needed to use label option
fviz_silhouette(sil, label = TRUE)
```

En este ejemplo vemos que hay varios estados que no encajan muy bien en los grupos que se les han asignado, por lo que deberíamos tener precaución para evitar hacer demasiado hincapié en la pertenencia a grupos de estos estados a la hora de informar sobre las tendencias de los datos.

#### El método Gap

El estadístico de Gap compara el _wss_ que se consigue con una determinada elección de _k_ con lo que se esperaría para ese K si no hubiera relaciones reales entre las observaciones. El código siguiente calcula el estadístico de _Gap_ para K de 1 a 8:

```R
fviz_nbclust(Std_USArrests, kmeans, method = "gap", k.max = 8)
```

En los ejemplos que hemos visto con la base de USArrests cada método sugiere un número ligeramente diferente de _clusters_, esto es algo habitual, y el valor exacto suele depender de una decisión tomada por el analista. Se recomienda considerar el método de Elbow, Silhoutte, y Gap como herramientas para guiar su elección de k.


### PAM Clustering

Partitioning Around Medoids (PAM) es un enfoque alternativo de agrupación que busca puntos de datos llamados medoides, que sirven como centros de cluster. Los demás puntos de datos se asignan al cluster definido por el medoide más cercano.

```R
pam_std <- pam(Std_USArrests, k = 3)
pam_std$medoids  ## Imprime los medoids
fviz_cluster(pam_std) ## Grafica los clusters
```

PAM resuelve muchos de los inconvenientes de k-means. Es más robusto a los valores atípicos (outliers), sus centros de cluster son los mismos puntos del conjunto de datos, haciendo los resultados más interpretables, además  PAM puede usarse para clusterizar datos con variables categóricas.
Estas ventajas no vienen sin debilidades, la mayor de ellas es la eficiencia computacional, PAM no se ejecuta bien con grandes conjuntos de datos. Además, PAM puede ser sensible a los medoides de partida, es decir, las configuraciones iniciales.

### Agrupación jerárquica (hierarchical clustering)

Tanto _k-means_ como PAM son algoritmos de partición que requieren un número predeterminado de _clusters_. En cambio, el clustering jerárquico agrega (o divide) los datos en una representación en forma de árbol conocida como dendrograma, que puede cortarse para definir el número deseado de clusters.
Existen dos categorías de enfoques para la agrupación jerárquica:

1. Los métodos aglomerativos o "ascendentes", que comienzan con cada punto de datos como su propio conglomerado, y luego proceden a agregar conglomerados hasta agrupar todas las observaciones.
2. Métodos divisivos o "de arriba abajo", que comienzan con todos los puntos de datos en un único conglomerado y, a continuación, proceden a dividir los conglomerados hasta que todas las observaciones constituyen su propio conglomerado.

Existen muchas implementaciones y algoritmos diferentes que se engloban en estos dos esquemas generales. El ejemplo siguiente ilustra la anidación aglomerativa (AGNES), un algoritmo aglomerativo, y el análisis divisivo (DIANA), un algoritmo divisivo.

```R
d <- get_dist(scale(USArrests))  ## Hierarchical Clustering requires a distance matrix
ag <- agnes(d)  ## AGNES
fviz_dend(ag, cex = 0.4, k = 4)
```


```R
di <- diana(d)  ## DIANA
fviz_dend(di, cex = 0.4, k = 4)
```


### Variables categóricas y distancia de Gower


```R
homes <- read.csv("https://remiller1450.github.io/data/IowaCityHomeSales.csv")
homes2 <- select(homes, style, built, bedrooms, bsmt, ac, area.living, area.lot)

D <- daisy(homes2, metric = "gower") ## Use daisy to calculate distance matrix
fviz_dist(D, show_labels = FALSE)  ## We could view the distance matrix
```



### Fuentes de información

- [Introduction to Clustering](https://remiller1450.github.io/s230f19/clustering.html)

- [K-means Clustering: Choosing Optimal K, Process, and Evaluation Methods](https://medium.com/@nirmalsankalana/k-means-clustering-choosing-optimal-k-process-and-evaluation-methods-2c69377a7ee4#:~:text=Elbow%20Method,like%20shape%20in%20the%20plot.)

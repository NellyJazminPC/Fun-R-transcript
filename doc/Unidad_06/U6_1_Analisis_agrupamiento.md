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


### Fuentes de información

- [Introduction to Clustering](https://remiller1450.github.io/s230f19/clustering.html)



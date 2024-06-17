###### Sesión de la Unidad 2 ######
## Martes 18 de junio de 2024
## Nelly Jazmín Pacheco Cruz
## Manipulación de datos en R

##################### ASPECTOS BASICOS #####################

# Funciones Básicas de Manipulación de Datos

#### Ejemplo de `t()`

# Crea una matriz de ejemplo
matrix_example <- matrix(1:9, nrow = 3, ncol = 3)
matrix_example

# Vamos a transponer la matriz
transposed_matrix <- t(matrix_example)
transposed_matrix


#### Ejemplo de `lapply()`

# Crea una lista de vectores numéricos
list_example <- list(a = 1:5, b = 6:10)
list_example

# Aplica la función sum() a cada elemento de la lista
lapply_result <- lapply(list_example, sum)
# Observa los resultados
lapply_result

#### Ejemplo de `sapply()`

# Aplica la función sum() a cada elemento de la lista y simplificar el resultado
sapply_result <- sapply(list_example, sum)
#Observa los resultados con sapply
sapply_result


#### Ejemplo de `do.call()`

# Crea una lista de argumentos
args_list <- list(1:5, 6:10)

# Usa do.call() para aplicar rbind() - otra función - a la lista de argumentos

do_call_result <- do.call(rbind, args_list)
#¿Qué obtuviste?
do_call_result


#### Ejemplo de operadores lógicos

# Crea vectores de ejemplo
x <- 1:10
y <- 5:14

# Operadores lógicos
x > 5
x == y
x != y
x & (y < 10)
x | (y < 10)

#### Ejemplo de `is.na()`

# Crea un vector con valores NA
vector_with_na <- c(1, 2, NA, 4, NA, 6)

# Identifica valores NA
is.na(vector_with_na)

#### Ejemplo de `subset()`

# Crea un data frame de ejemplo
df_example <- data.frame(
  id = 1:10,
  age = c(23, 25, 30, 22, 28, 32, 35, 40, 45, 50),
  gender = c("M", "F", "M", "F", "M", "F", "M", "F", "M", "F")
)

# Separa un subconjunto de filas donde la edad es mayor a 30
subset_result <- subset(df_example, age > 30)
subset_result

#### Ejemplo de `aggregate()`

# Crea un data frame de ejemplo
df_example2 <- data.frame(
  group = c("A", "A", "B", "B", "B"),
  value = c(10, 15, 20, 25, 30)
)

# Calcula la media de 'value' para cada grupo
aggregate_result <- aggregate(value ~ group, data = df_example2, FUN = mean)
print(aggregate_result)


##################### Reshape2 #####################
### Ejemplo con dcast() y melt()

# Cargar la base de datos ChickWeight
data("ChickWeight")
#Explora la base de datos con head o completa
head(ChickWeight)
dim(ChickWeight)
# Carga el paquete reshape2 
#Si no lo tienes instalado, usa la siguiente línea:
#install.packages("reshape2")
library(reshape2)

# Crea un data frame de ejemplo en formato wide (ancho)
#Vamos a usar dcast()
wide_chick <- dcast(ChickWeight, Diet + Chick ~ Time, value.var = "weight")
#Revisa si cambio el formato
head(wide_chick)
dim(wide_chick)
#wide_chick[wide_chick$Chick == 1, ]
# Usa melt() para convertirlo a formato long (largo)
long_chick <- melt(wide_chick, id.vars = c("Diet", "Chick"), variable.name = "Time", value.name = "Weight")
#Revisa si cambio el formato
head(long_chick)
dim(long_chick)
#Verifica si hay datos faltantes
#sum(is.na(long_chick$Weight))
#sum(is.na(ChickWeight))
#Imprime las filas con NA
#long_chick[is.na(long_chick$Weight), ]


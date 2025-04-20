###### Sesión de la Unidad 2 ######
## Martes 18 de junio de 2024
## Nelly Jazmín Pacheco Cruz
## Manipulación de datos en R

##################### ASPECTOS BASICOS #####################

# Funciones Básicas de Manipulación de Datos
# Operadores lógicos
#Crea dos variable y asignales el valor de 5 y 15 
x <- 5
y <- 15
#Usa los operadores lógicos:
x > 5 
x == y # Compara si dos valores son exactamente iguales
x != y # Compara si dos valores son diferentes
x & (y < 10) # Evalúa si ambas condiciones son verdaderas

x | (y < 10) # Evalúa si al menos una condición es verdadera


#### Ejemplo NA ####
# Crea un vector con valores NA
vector_with_na <- c(1, 2, NA, 4, NA, 6)

# Identifica valores NA
is.na(vector_with_na)

##################### tidyr #####################
### Ejemplo con gather() y spread()

# Carga la base de datos iris
data("iris")
head(iris)
dim(iris)

#Carga tidyr
library(tidyr)

#Si no tienes instalado el paquete usa:
#install.packages("tidyr")

# Añadir un identificador único a las filas de iris
iris$ID <- 1:nrow(iris)

# Convertir a formato long usando gather
iris_long <- gather(iris, key = "Measurement", value = "Value", -Species, -ID)

# Ver el data frame en formato long
head(iris_long)

# Convertir de vuelta a formato wide usando spread
iris_wide_again <- spread(iris_long, key = "Measurement", value = "Value")

# Ver el data frame en formato wide
head(iris_wide_again)

### EXTRA: pivot_longer() y pivot_wider()

# Usar pivot_longer() para convertir de wide a long
iris_long_pivot <- pivot_longer(
  iris, 
  cols = c(starts_with("Sepal"), starts_with("Petal")), 
  names_to = "Measurement", 
  values_to = "Value"
)
#Revisa el data.frame:
class(iris_long_pivot)
print(iris_long_pivot)

# Usar pivot_wider() para convertir de long a wide
iris_wide_pivot <- pivot_wider(
  iris_long_pivot, 
  names_from = "Measurement", 
  values_from = "Value")
#Revisa el data frame
head(iris_wide_pivot)
dim(iris_wide_pivot)


### Ejemplo con unite() y separate()

# Crea una nueva columna combinada
iris_combined <- unite(iris, col = "Species_SepalLength", Species, Sepal.Length, sep = "_")
head(iris_combined)
dim(iris_combined)

# Usa separate() para dividir la columna combinada
iris_separated <- separate(iris_combined, col = "Species_SepalLength", into = c("Species", "Sepal.Length"), sep = "_")
head(iris_separated)
dim(iris_separated)


##################### dplyr   y   magrittr #####################
### Ejemplo con magrittr()

#Carga el paquete de magrittr
library(magrittr)

#Si no lo tienes instalado:
#install.package("magrittr")

# Ejemplo simple usando %>%
#Crea un vector que contenga valores de 1 a 10, suma todo y obtén el cuadrado de esa suma total

result <- 1:10 %>% 
  sum() %>% 
  sqrt()

print(result)

# Output: 7.416198


### Ejemplo con mutate() con y sin %>%

# Carga la base de datos iris y los paquetes dplyr y magrittr si aún no lo has hecho
#data("iris")
#Carga el paquete dplyr
#Si no lo tienes instalado usa install.package()
library(dplyr)
#Revisa nuevamente la base iris
head(iris)

# Crea nuevas columnas que son el doble de Sepal.Length y la relación Sepal.Length/Sepal.Width

mutated_iris <- mutate(iris,
  double_sepal_length = Sepal.Length * 2,
  sepal_ratio = Sepal.Length/Sepal.Width)

#Revisa el nuevo df con las nuevas columnas
head(mutated_iris)

### Con %>%
head(iris)
# Crea nuevas columnas que son el doble de Sepal.Length y la relación Sepal.Length/Sepal.Width

mutated_iris_pipe <- iris %>%
  mutate(
    double_sepal_length = Sepal.Length * 2,
    sepal_ratio = Sepal.Length / Sepal.Width)

#Revisa el nuevo df con las nuevas columnas
head(mutated_iris_pipe)
str(mutated_iris_pipe)

### Ejemplo con filter()

# Filtra filas donde Sepal.Length es mayor a 5 y Species es "setosa"

filtered_iris <- filter(iris, Sepal.Length > 5, Species == "setosa")
#Revisa el nuevo df
filtered_iris

#### Con %>%
# Filtra filas donde Sepal.Length es mayor a 5 y Species es "setosa"

filtered_iris_pipe <- iris %>%
  filter(Sepal.Length > 5, Species == "setosa")
#Revisa el nuevo df
filtered_iris_pipe

### Ejemplo con group_by()

# Agrupa por Species
iris_grouped <- group_by(iris, Species)

# Muestra los datos agrupados
iris_grouped

#### Con %>%
# Agrupa por Species usando %>%
iris_grouped_pipe <- iris %>% 
  group_by(Species)

# Muestra los datos agrupados
iris_grouped_pipe

### Ejemplo con summarize()

# Calcula la media y desviación estándar de Sepal.Length por especie

summar_iris <- summarize(
  group_by(iris, Species),
  mean_sepal_length = mean(Sepal.Length),
  sd_sepal_length = sd(Sepal.Length))
#Revisa los resultados:
summar_iris

#### Con %>%
# Calcula la media y desviación estándar de Sepal.Length por especie

summar_iris_pipe <- iris %>%
  group_by(Species) %>%
  summarize(
    mean_sepal_length = mean(Sepal.Length),
    sd_sepal_length = sd(Sepal.Length))
#Revisa los resultados:
summar_iris_pipe

### Ejemplo con las cuatro funciones de dplyr con y sin %>%

# Manipulación de datos en una sola línea sin usar %>%
summary_iris <- summarize(group_by(filter(mutate(iris, double_sepal_length = Sepal.Length * 2), Sepal.Length > 5), Species), mean_sepal_length = mean(Sepal.Length), sd_sepal_length = sd(Sepal.Length), mean_double_sepal_length = mean(double_sepal_length), sd_double_sepal_length = sd(double_sepal_length))

# Imprimir el resumen
summary_iris

###

# Manipulación de datos en un solo chunk usando %>%
summary_iris_pipe <- iris %>%
  # Crear una nueva columna que es el doble de Sepal.Length
  mutate(double_sepal_length = Sepal.Length * 2) %>%
  # Filtrar filas donde Sepal.Length es mayor a 5
  filter(Sepal.Length > 5) %>%
  # Agrupar por Species
  group_by(Species) %>%
  # Calcular la media y la desviación estándar de Sepal.Length y double_sepal_length
  summarize(
    mean_sepal_length = mean(Sepal.Length),
    sd_sepal_length = sd(Sepal.Length),
    mean_double_sepal_length = mean(double_sepal_length),
    sd_double_sepal_length = sd(double_sepal_length)
  )

# Imprimir el resumen
print(summary_iris)


# ============================================================
# Unidad 2 - Para seguir explorando
# Curso: Fundamentos de Programación en R para análisis transcriptómicos
# 16 de Junio de 2026. NJ PC
# ============================================================

# Este script contiene ejemplos complementarios para practicar después de la sesión.
# No forma parte del núcleo principal de la Unidad 2.

# Contenido:
# 1. Reciclaje de vectores
# 2. Valores faltantes (NA)
# 3. Matrices
# 4. Factores
# 5. Listas
# 6. Arrays
# 7. Funciones base para manipulación de datos
# 8. Formatos ancho y largo con tidyr
# 9. separate() y unite()

# ============================================================
# 0. Preparar ambiente
# ============================================================

# Cargar paquetes necesarios para las secciones de tidyr/dplyr
# Si no los tienes instalados, ejecuta primero:
# install.packages(c("tidyverse", "readxl"))

library(dplyr)
library(tidyr)

# Recuperamos el data frame de práctica usado en la Unidad 2
metadata <- data.frame(
  sample_id = c("S01", "S02", "S03", "S04", "S05", "S06"),
  condition = c("control", "control", "stress", "stress", "control", "stress"),
  tissue = c("leaf", "leaf", "leaf", "root", "root", "root"),
  reads_million = c(18.5, 21.2, 19.8, 25.1, 20.4, 17.9)
)

metadata

# ============================================================
# 1. Reciclaje de vectores
# ============================================================

# R puede hacer operaciones con vectores de distinta longitud.
# Cuando un vector es más corto, R puede repetir sus valores.
# A esto se le llama reciclaje.

x_long <- c(4, 6, 5, 7, 10, 9, 4, 15)
y_short <- c(0, 10, 1, 8)

x_long
y_short

# Suma de vectores con distinta longitud
x_long + y_short

# Revisa las longitudes
length(x_long)
length(y_short)

# Precaución: el reciclaje puede ser útil, pero también puede causar errores
# difíciles de detectar si no revisamos bien la longitud de los vectores.

# Ejemplo donde la longitud no es múltiplo exacto
x_long <- c(4, 6, 5, 7, 10, 9, 4, 15)
y_muy_short <- c(1, 2, 3)

# Este ejemplo genera una advertencia, pero R aún intenta hacer la operación.
x_long + y_muy_short

# R recicla el vector más corto para completar la operación.
# Como 8 no es múltiplo de 3, muestra una advertencia.
# Esto no detiene el código, pero sí indica que debemos revisar la operación.

# ============================================================
# 2. Valores faltantes en vectores
# ============================================================

# En R, NA representa un dato faltante.

x_na <- c(4, 6, NA, 7, 10, 9, 4, 15)

x_na

# Identificar valores faltantes
is.na(x_na)

# Algunas funciones devuelven NA si hay datos faltantes
mean(x_na)

# Para ignorar los NA en el cálculo, usamos na.rm = TRUE
mean(x_na, na.rm = TRUE)
sum(x_na, na.rm = TRUE)

# Contar cuántos valores faltantes hay
sum(is.na(x_na))

# ============================================================
# 3. Matrices
# ============================================================

# Una matriz organiza datos en filas y columnas,
# pero todos sus elementos deben ser del mismo tipo.

# Crear una matriz con valores del 1 al 12
matriz_filas <- matrix(1:12, ncol = 3, byrow = TRUE)

matriz_filas

# Revisar dimensiones
# El resultado corresponde a: número de filas y número de columnas.
dim(matriz_filas)

# Acceder a elementos usando [fila, columna]
matriz_filas[1, 3]
matriz_filas[2, 2]

# Seleccionar una columna completa
matriz_filas[, 3]

# Seleccionar una fila completa
matriz_filas[4, ]

# Asignar nombres a columnas y filas
colnames(matriz_filas) <- c("col1", "col2", "col3")
rownames(matriz_filas) <- c("fila1", "fila2", "fila3", "fila4")

matriz_filas

# Algunas funciones útiles para matrices
rowSums(matriz_filas)
rowMeans(matriz_filas)
colSums(matriz_filas)
colMeans(matriz_filas)

# En transcriptómica, una matriz de conteos suele tener:
# filas = genes
# columnas = muestras
# valores = conteos de lecturas

conteos <- matrix(
  c(120, 135, 400, 380,
    20, 18, 25, 30,
    0, 2, 15, 13),
  nrow = 3,
  byrow = TRUE
)

rownames(conteos) <- c("gene001", "gene002", "gene003")
colnames(conteos) <- c("S01", "S02", "S03", "S04")

conteos

# ============================================================
# 4. Factores
# ============================================================

# Los factores representan datos categóricos.
# Pueden ser útiles para tratamientos, grupos, especies o condiciones.

condiciones <- c("control", "stress", "control", "stress")

condiciones_factor <- factor(condiciones)

condiciones_factor

# Ver niveles del factor
levels(condiciones_factor)

# Tabla de frecuencias
table(condiciones_factor)

# Ejemplo con niveles ordenados
respuesta <- c("bajo", "alto", "medio", "alto", "bajo", "medio")

respuesta_factor <- factor(
  respuesta,
  levels = c("bajo", "medio", "alto"),
  ordered = TRUE
)

respuesta_factor
levels(respuesta_factor)
table(respuesta_factor)

# ============================================================
# 5. Listas
# ============================================================

# Las listas pueden guardar objetos de distintos tipos y tamaños.
# Por ejemplo: texto, números, vectores, data frames o matrices.

mi_lista <- list(
  muestra = "S01",
  lecturas = 15000,
  metadata = metadata,
  conteos = conteos
)

mi_lista

# Revisar estructura
str(mi_lista)

# Acceder a elementos de una lista con $
mi_lista$muestra
mi_lista$lecturas

# Acceder a elementos con [[ ]]
mi_lista[[1]]
mi_lista[[2]]

# Agregar un nuevo elemento
mi_lista$notas <- "Ejemplo de lista con objetos usados en la Unidad 2"

str(mi_lista)

# ============================================================
# 6. Arrays
# ============================================================

# Los arrays son estructuras multidimensionales.
# Pueden pensarse como matrices con más de dos dimensiones.

array_3d <- array(1:27, dim = c(3, 3, 3))

array_3d

# Revisar dimensiones
dim(array_3d)

# Acceder a una posición específica
# [fila, columna, capa]
array_3d[1, 1, 1]
array_3d[2, 3, 1]

# ============================================================
# 7. Algunas funciones base para manipulación de datos
# ============================================================

# Aunque en la Unidad 2 nos enfocamos en dplyr,
# R base también tiene funciones útiles para manipular datos.

# ------------------------------------------------------------
# 7.1 subset()
# ------------------------------------------------------------

# Extraer filas que cumplen una condición
metadata_control_base <- subset(metadata, condition == "control")

metadata_control_base

# Extraer filas y seleccionar columnas
metadata_control_columnas <- subset(
  metadata,
  condition == "control",
  select = c(sample_id, tissue, reads_million)
)

metadata_control_columnas

# ------------------------------------------------------------
# 7.2 aggregate()
# ------------------------------------------------------------

# Calcular promedio de lecturas por condición
aggregate(
  reads_million ~ condition,
  data = metadata,
  FUN = mean
)

# Calcular promedio de lecturas por condición y tejido
aggregate(
  reads_million ~ condition + tissue,
  data = metadata,
  FUN = mean
)

# ------------------------------------------------------------
# 7.3 t()
# ------------------------------------------------------------

# t() transpone una matriz o data frame: cambia filas por columnas.

conteos

t(conteos)

# ------------------------------------------------------------
# 7.4 lapply() y sapply()
# ------------------------------------------------------------

# lapply() aplica una función a cada elemento de una lista y devuelve una lista.
# sapply() intenta simplificar el resultado.

lista_numerica <- list(
  muestra_1 = c(10, 20, 30),
  muestra_2 = c(5, 15, 25),
  muestra_3 = c(2, 4, 6)
)

lista_numerica

# Suma de cada elemento de la lista
lapply(lista_numerica, sum)

# Resultado simplificado
sapply(lista_numerica, sum)

# Promedio de cada elemento
sapply(lista_numerica, mean)

# ============================================================
# 8. Datos en formato ancho y largo con tidyr
# ============================================================

# En análisis de datos es común encontrar tablas en formato ancho o largo.
# - Formato ancho: una variable se distribuye en varias columnas.
# - Formato largo: las observaciones se organizan en filas adicionales.

# Ejemplo de datos en formato ancho
conteos_wide <- data.frame(
  gene_id = c("gene001", "gene002", "gene003"),
  S01 = c(120, 20, 0),
  S02 = c(135, 18, 2),
  S03 = c(400, 25, 15),
  S04 = c(380, 30, 13)
)

conteos_wide

# ------------------------------------------------------------
# 8.1 pivot_longer(): ancho a largo
# ------------------------------------------------------------

conteos_long <- conteos_wide %>%
  pivot_longer(
    cols = starts_with("S"),
    names_to = "sample_id",
    values_to = "counts"
  )

conteos_long

# En formato largo cada fila representa una combinación gen-muestra.

# ------------------------------------------------------------
# 8.2 pivot_wider(): largo a ancho
# ------------------------------------------------------------

conteos_wide_otra_vez <- conteos_long %>%
  pivot_wider(
    names_from = sample_id,
    values_from = counts
  )

conteos_wide_otra_vez

# ============================================================
# 9. separate() y unite()
# ============================================================

# separate() divide una columna en varias columnas.
# unite() une varias columnas en una sola.

# Crear una tabla con etiquetas combinadas
metadata_etiquetas <- metadata %>%
  mutate(sample_label = paste(condition, tissue, sample_id, sep = "_"))

metadata_etiquetas

# ------------------------------------------------------------
# 9.1 separate()
# ------------------------------------------------------------

metadata_separada <- metadata_etiquetas %>%
  select(sample_label, reads_million) %>%
  separate(
    col = sample_label,
    into = c("condition", "tissue", "sample_id"),
    sep = "_"
  )

metadata_separada

# ------------------------------------------------------------
# 9.2 unite()
# ------------------------------------------------------------

metadata_unida <- metadata_separada %>%
  unite(
    col = "sample_label",
    condition,
    tissue,
    sample_id,
    sep = "_"
  )

metadata_unida

# ============================================================
# Fin del script
# ============================================================

# Recuerda: este script es complementario.
# No necesitas dominar todo esto en la Unidad 2.
# Puedes regresar a estos ejemplos cuando vuelvas a encontrar estos temas.

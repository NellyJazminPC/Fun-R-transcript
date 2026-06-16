# ============================================================
# Unidad 2. Variables, funciones y estructuras de datos
# Curso: Fundamentos de Programación en R para análisis transcriptómicos
#
# Script de práctica general
#
# Instrucciones:
# Ejecuta el código por bloques, siguiendo las indicaciones de la instructora.
# No es necesario ejecutar todo el script de una sola vez.
# 16 de Junio de 2026. NJ PC
# ============================================================


# ============================================================
# 2.1 Introducción a variables y funciones
# ============================================================

# ------------------------------------------------------------
# ¿Qué es una variable?
# ------------------------------------------------------------

# Guardar el valor 5 en una variable llamada caja1
caja1 <- 5

# Revisar qué contiene caja1
caja1


# ------------------------------------------------------------
# Asignar valores con <-
# ------------------------------------------------------------

# Guardar el valor 5 en una variable llamada x
x <- 5

# Revisar qué contiene x
x


# También es posible asignar de derecha a izquierda
10 -> x

# Revisar qué contiene x
x


# La siguiente línea está comentada porque genera un error.
# Intenta ejecutarla directamente en la consola para observar qué ocurre.
10 <- x

# ------------------------------------------------------------
# Ejecutar una operación no siempre guarda el resultado
# ------------------------------------------------------------

# Reiniciar x con el valor 5
x <- 5

# Imprimir lo que contiene x
x

# Sumar 1 a x
x + 1

# Revisar si se guardó el valor de 6 en x
x


# Para guardar el resultado, debemos usar <-

# Opción 1. Sobrescribir la variable
x <- x + 1
x

# Opción 2. Guardar el resultado en una nueva variable
y <- x * 2

# Verificar qué valores tienen x y y
x
y


# ------------------------------------------------------------
# Funciones básicas
# ------------------------------------------------------------

# Usar funciones que ya existen en R
sqrt(25)
mean(c(10, 15, 20))


# Crear una función sencilla
duplicar <- function(x) {
  x * 2
}

# Ejecutar la función con distintos valores
duplicar(5)
duplicar(10)
duplicar(25)


# ------------------------------------------------------------
# Pedir ayuda sobre una función
# ------------------------------------------------------------

# Estas líneas abren la documentación de R.
# Ejecútalas si quieres consultar la ayuda de cada función.

# help(mean)
# ?mean
# help(plot)
# ?plot


# ------------------------------------------------------------
# Ejercicio integrador breve
# ------------------------------------------------------------

# Crear variables
muestra <- "S01"
tratamiento <- "control"
lecturas <- 15000

# Revisar su contenido
muestra
tratamiento
lecturas

# Contar cuántos caracteres tiene el nombre de la muestra
nchar(muestra)

# Realizar una operación
lecturas / 1000

# Guardar el resultado en una nueva variable
lecturas_miles <- lecturas / 1000

# Revisar el resultado guardado
lecturas_miles



# ============================================================
# 2.2 Estructuras de datos: vectores y data frames
# ============================================================

# ------------------------------------------------------------
# Vectores
# ------------------------------------------------------------

# Crear un vector numérico
mi_vector <- c(5, 10, 15, 20)

# Revisar qué contiene mi_vector
mi_vector

# Operaciones con vectores numéricos
mi_vector + 1
mi_vector * 2


# Crear un vector de texto
letras <- c("a", "b", "c", "d")

# Revisar qué contiene letras
letras


# Acceder a elementos de un vector

# Primer elemento
letras[1]

# Elementos del 1 al 3
letras[1:3]

# Elementos 1 y 4
letras[c(1, 4)]


# ------------------------------------------------------------
# Operaciones básicas con vectores
# ------------------------------------------------------------

# Crear dos vectores numéricos
x <- c(4, 6, 5, 7, 10, 9, 4, 15)
y <- c(0, 10, 1, 8, 2, 3, 4, 1)

# Sumar los dos vectores
x + y

# Revisar si los valores de x son mayores a 7
x > 7

# Calcular el promedio de x
mean(x)

# Obtener el valor máximo de y
max(y)

# Averiguar cuántos elementos tiene cada vector
length(x)
length(y)


# ------------------------------------------------------------
# Data frames
# ------------------------------------------------------------

# Caso de estudio hipotético:
# Tenemos metadatos de seis muestras de tejido vegetal para un análisis
# transcriptómico sencillo. Para cada muestra conocemos su identificador,
# condición experimental, tejido y número aproximado de lecturas.

metadata <- data.frame(
  sample_id = c("S01", "S02", "S03", "S04", "S05", "S06"),
  condition = c("control", "control", "stress", "stress", "control", "stress"),
  tissue = c("leaf", "leaf", "leaf", "root", "root", "root"),
  reads_million = c(18.5, 21.2, 19.8, 25.1, 20.4, 17.9)
)

# Revisar el data frame
metadata


# ------------------------------------------------------------
# Explorar un data frame
# ------------------------------------------------------------

# Ver las primeras filas
head(metadata)

# Ver dimensiones: número de filas y columnas
dim(metadata)

# Ver nombres de las columnas
names(metadata)

# Ver estructura del data frame
str(metadata)

# Obtener resumen general
summary(metadata)


# ------------------------------------------------------------
# Acceder a columnas y elementos de un data frame
# ------------------------------------------------------------

# Acceder a columnas usando $
metadata$condition
metadata$reads_million

# Seleccionar una columna como data frame
metadata["condition"]

# Seleccionar una columna como vector
metadata[["condition"]]

# Acceder a elementos específicos
metadata[1, 1]
metadata[3, 2]

# Toda la fila 1
metadata[1, ]

# Toda la columna 2
metadata[, 2]


# ------------------------------------------------------------
# Cápsula breve: matrices
# ------------------------------------------------------------

# Crear una matriz sencilla
conteos <- matrix(1:12, nrow = 4)

# Revisar la matriz
conteos

# Revisar dimensiones
dim(conteos)

# Elemento de la fila 1, columna 2
conteos[1, 2]


# ------------------------------------------------------------
# Ejercicio integrador breve
# ------------------------------------------------------------

# ¿Cuántas filas y columnas tiene metadata?
dim(metadata)

# ¿Cómo se llaman sus columnas?
names(metadata)

# ¿Qué tipo de datos contiene cada columna?
str(metadata)

# ¿Cuál es el promedio de lecturas en millones?
mean(metadata$reads_million)

# ¿Qué muestras pertenecen a la condición control?
metadata[metadata$condition == "control", ]

# ¿Qué muestras pertenecen al tejido root?
metadata[metadata$tissue == "root", ]



# ============================================================
# 2.3 Manipulación de datos con dplyr
# ============================================================

# ------------------------------------------------------------
# Cargar dplyr
# ------------------------------------------------------------

# dplyr forma parte de tidyverse.
# Si ya cargaste tidyverse, no es necesario cargar dplyr por separado.
library(dplyr)


# ------------------------------------------------------------
# Preparar el data frame de trabajo
# ------------------------------------------------------------

# Si perdiste el objeto metadata, vuelve a crearlo con este bloque:

metadata <- data.frame(
  sample_id = c("S01", "S02", "S03", "S04", "S05", "S06"),
  condition = c("control", "control", "stress", "stress", "control", "stress"),
  tissue = c("leaf", "leaf", "leaf", "root", "root", "root"),
  reads_million = c(18.5, 21.2, 19.8, 25.1, 20.4, 17.9)
)

# Revisar nuevamente la estructura
head(metadata)
dim(metadata)
str(metadata)
summary(metadata)


# ------------------------------------------------------------
# Operadores lógicos
# ------------------------------------------------------------

# Crear dos variables
x <- 5
y <- 15

# Comparaciones
x > 5
x == y
x != y
x < y

# Combinar condiciones
x < 10 & y < 20
x > 10 | y < 20


# ------------------------------------------------------------
# Valores faltantes: NA
# ------------------------------------------------------------

# Crear un vector con valores faltantes
vector_with_na <- c(1, 2, NA, 4, NA, 6)

# Revisar el vector
vector_with_na

# Identificar valores faltantes
is.na(vector_with_na)

# Calcular el promedio sin indicar qué hacer con NA
mean(vector_with_na)

# Calcular el promedio ignorando valores faltantes
mean(vector_with_na, na.rm = TRUE)


# ------------------------------------------------------------
# select(): seleccionar columnas
# ------------------------------------------------------------

# Seleccionar columnas específicas
metadata_select <- select(metadata, sample_id, condition, reads_million)

metadata_select

# Excluir una columna
metadata_sin_tissue <- select(metadata, -tissue)

metadata_sin_tissue


# ------------------------------------------------------------
# filter(): filtrar filas
# ------------------------------------------------------------

# Filtrar muestras de la condición control
metadata_control <- filter(metadata, condition == "control")

metadata_control

# Filtrar muestras del tejido root
metadata_root <- filter(metadata, tissue == "root")

metadata_root

# Combinar condiciones
metadata_control_leaf <- filter(metadata, condition == "control", tissue == "leaf")

metadata_control_leaf


# ------------------------------------------------------------
# mutate(): crear o modificar columnas
# ------------------------------------------------------------

# Crear una nueva columna con lecturas totales
metadata_reads <- mutate(
  metadata,
  reads = reads_million * 1e6
)

metadata_reads

# Crear una etiqueta combinando condición, tejido y muestra
metadata_label <- mutate(
  metadata,
  sample_label = paste(condition, tissue, sample_id, sep = "_")
)

metadata_label


# ------------------------------------------------------------
# arrange(): ordenar filas
# ------------------------------------------------------------

# Ordenar de menor a mayor número de lecturas
metadata_ordenado <- arrange(metadata, reads_million)

metadata_ordenado

# Ordenar de mayor a menor número de lecturas
metadata_ordenado_desc <- arrange(metadata, desc(reads_million))

metadata_ordenado_desc

# Ordenar por condición y tejido
metadata_ordenado_grupos <- arrange(metadata, condition, tissue)

metadata_ordenado_grupos


# ------------------------------------------------------------
# group_by() y summarise(): resumir por grupos
# ------------------------------------------------------------

# Contar muestras por condición
metadata_por_condicion <- metadata %>%
  group_by(condition) %>%
  summarise(
    n_muestras = n()
  )

metadata_por_condicion


# Calcular promedio de lecturas por condición
metadata_promedio <- metadata %>%
  group_by(condition) %>%
  summarise(
    promedio_lecturas_millones = mean(reads_million)
  )

metadata_promedio


# Agrupar por condición y tejido
metadata_resumen_grupos <- metadata %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen_grupos


# ------------------------------------------------------------
# Pipe: comparación de estilos
# ------------------------------------------------------------

# Ejemplo sin usar pipe
metadata_resumen_sin_pipe <- summarise(
  group_by(
    mutate(
      filter(metadata, !is.na(condition)),
      reads = reads_million * 1e6
    ),
    condition,
    tissue
  ),
  n_muestras = n(),
  promedio_lecturas_millones = mean(reads_million),
  .groups = "drop"
)

metadata_resumen_sin_pipe


# Ejemplo con %>%
metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen


# Ejemplo con |>
metadata_resumen_base_pipe <- metadata |>
  filter(!is.na(condition)) |>
  mutate(reads = reads_million * 1e6) |>
  group_by(condition, tissue) |>
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen_base_pipe


# ------------------------------------------------------------
# Ejercicio integrador
# ------------------------------------------------------------

# Crear un resumen de las muestras:
# 1. Filtrar muestras sin valores faltantes en condition.
# 2. Crear una columna reads con lecturas totales.
# 3. Agrupar por condition y tissue.
# 4. Calcular número de muestras y promedio de lecturas en millones.
# 5. Guardar el resultado en metadata_resumen.

metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen


# ------------------------------------------------------------
# Desafío extra: exportar el resultado
# ------------------------------------------------------------

# Crear carpeta results si no existe
dir.create("results", showWarnings = FALSE)

# Exportar resultado
write.csv(metadata_resumen, "results/metadata_resumen.csv", row.names = FALSE)

# Revisar que el archivo se haya creado
list.files("results")


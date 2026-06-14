# ============================================================
# Unidad 1 - Práctica general
# Fundamentos de programación en R
# 15 de junio de 2026 - NJ PC
# ============================================================

# Este script acompaña la Unidad 1 del curso.
# Contiene ejemplos y ejercicios de:
# 1. Uso básico de RStudio
# 2. Operaciones básicas en R
# 3. Comentarios en scripts
# 4. Directorio de trabajo y organización del proyecto
# 5. Lectura y guardado de archivos
#
# IMPORTANTE:
# Ejecuta el código línea por línea.
# No es necesario ejecutar todo el script de una sola vez.

# ============================================================
# 1.2 Uso de RStudio
# Primeras líneas de código
# ============================================================

# En esta sección practicaremos:
# - escribir código en el editor
# - ejecutar líneas con Run o con atajos de teclado
# - observar resultados en la consola
# - agregar comentarios

5 + 5
10 * 8 + 3 * (6 - 2/4)^10
10 - 5
8 * 8
8 / 8

# Ahora agregamos comentarios:

5 + 5    # Suma
10 - 5   # Resta
8 * 8    # Multiplicación
8 / 8    # División

# ============================================================
# Ejercicios extra: operaciones básicas
# ============================================================

3 + 5    # Suma
8 - 3    # Resta
7 * 5    # Multiplicación
1 / 2    # División
4 ^ 4    # Exponente
4 ** 4   # Exponente
5 %% 3   # Módulo
5 %/% 3  # División entera

# Otros operadores que existen en R, pero no es necesario dominarlos ahora:
# %*%  Multiplicación matricial
# %o%  Producto exterior
# %x%  Producto Kronecker

# ============================================================
# Notación científica
# ============================================================

2 / 10000

# R muestra el resultado como 2e-04.
# Esto significa 2 * 10^(-4).

5e3
5e-3

# Pregunta:
# ¿Qué cambia al escribir 5e3 y 5e-3?

# ============================================================
# 1.3 Gestión de proyectos
# Directorio de trabajo y archivos
# ============================================================

# ¿Cuál es el directorio de trabajo actual?
getwd()

# ¿Qué archivos y carpetas hay en el directorio actual?
dir()

# Nota:
# La función setwd() permite cambiar manualmente el directorio de trabajo.
# Sin embargo, en este curso recomendamos abrir el proyecto desde el archivo .Rproj
# para trabajar siempre desde la carpeta raíz del repositorio.

# Ejemplo comentado:
# setwd("ruta/a/tu/carpeta")

# Para consultar ayuda sobre setwd():
?setwd

# ============================================================
# Ayuda en R
# ============================================================

# Puedes consultar la ayuda de una función usando ?nombre_funcion.
# Por ejemplo:

?getwd
?dir
?read.csv

# ============================================================
# Paquetes en R
# ============================================================

# Más adelante usaremos paquetes para ampliar las capacidades de R.
# Para consultar la ayuda de la función install.packages:

?install.packages

# Ejemplo comentado de instalación de un paquete:
# install.packages("ggplot2")

# Nota:
# No ejecutes instalaciones si no es necesario o si el paquete ya está instalado.

# ============================================================
# 1.4 Leer y guardar archivos
# ============================================================

# En esta sección leeremos un archivo CSV guardado en la carpeta data.
# Después filtraremos una parte de la tabla y guardaremos el resultado
# en la carpeta results.

# Primero revisa que estés trabajando desde la raíz del proyecto:
getwd()

# Revisa que existan las carpetas principales:
dir()

# IMPORTANTE:
# Si descargaste el repositorio desde GitHub, es posible que la carpeta results/
# no exista todavía. En esta unidad la crearemos para guardar ahí los archivos
# generados durante la práctica.
#
# dir.exists("results") revisa si la carpeta results/ existe y devuelve TRUE o FALSE.
# El bloque if no imprime TRUE o FALSE por sí mismo: solo ejecuta la instrucción indicada
# cuando la condición se cumple. En este caso, crea results/ solo si no existe.
# Si results/ ya existe, no borra ni modifica los archivos que contiene.

if (!dir.exists("results")) {
  dir.create("results")
  message("Se creó la carpeta results/.")
} else {
  message("La carpeta results/ ya existe.")
}

# Leer archivo CSV
# Este archivo debe estar en:
# data/U1_datos_expresion.csv

# Antes de leerlo, podemos verificar si el archivo existe:
file.exists("data/U1_datos_expresion.csv")

data_expresion <- read.csv(
  "data/U1_datos_expresion.csv",
  header = TRUE,
  sep = ","
)

# Explorar el objeto creado
data_expresion

# Revisar las primeras filas
head(data_expresion)

# Revisar nombres de columnas
names(data_expresion)

# Revisar la estructura del objeto
str(data_expresion)

# Filtrar solo los datos de Etapa1
filtered_data_etapa1 <- subset(data_expresion, Etapas == "Etapa1")

# Explorar el objeto filtrado
filtered_data_etapa1

# Revisar las primeras filas del objeto filtrado
head(filtered_data_etapa1)

# Guardar el archivo filtrado en formato .txt
# El archivo se guardará en la carpeta results.

write.table(
  filtered_data_etapa1,
  "results/U1_datos_Etapa1.txt",
  sep = "\t",
  row.names = FALSE
)

# También podríamos guardarlo como CSV:
# write.csv(
#   filtered_data_etapa1,
#   "results/U1_datos_Etapa1.csv",
#   row.names = FALSE
# )

# ============================================================
# Para explorar más: revisar objetos del ambiente
# ============================================================

# ls() muestra los objetos creados en la sesión actual.
ls()

# Para listar también objetos ocultos:
ls(all.names = TRUE)

# Cuidado:
# rm(list = ls()) borra todos los objetos del ambiente.
# No lo ejecutes durante la práctica a menos que se indique.
# rm(list = ls())

# ============================================================
# Fin de la práctica
# ============================================================

# Si llegaste hasta aquí, ya practicaste:
# - escribir código en RStudio
# - ejecutar líneas desde el editor
# - usar comentarios
# - revisar el directorio de trabajo
# - leer un archivo CSV
# - filtrar datos
# - guardar un resultado en la carpeta results
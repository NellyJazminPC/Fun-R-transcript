# ============================================================
# Unidad 1 - Para explorar más
# Leer y guardar archivos de Excel
# Fundamentos de programación en R
# 15 de junio de 2026 - NJ PC
# ============================================================

# Este script es material complementario de la Unidad 1.
# No es una actividad obligatoria de la sesión.
#
# Objetivo:
# Practicar cómo leer y guardar archivos de Excel usando los paquetes:
# - readxl: para leer archivos .xls y .xlsx
# - writexl: para guardar archivos .xlsx
#
# IMPORTANTE:
# Ejecuta el código línea por línea.
# Antes de iniciar, asegúrate de estar trabajando desde la carpeta raíz
# del proyecto.

# ============================================================
# 1. Revisar el directorio de trabajo
# ============================================================

# ¿Dónde está trabajando R?
getwd()

# ¿Qué archivos y carpetas hay en la carpeta actual?
dir()

# Si abriste el proyecto desde el archivo .Rproj,
# deberías ver carpetas como:
# doc, bin, data y results.

# ============================================================
# 2. Verificar o crear la carpeta results/
# ============================================================

# IMPORTANTE:
# Si descargaste el repositorio desde GitHub, es posible que la carpeta results/
# no exista todavía. En esta carpeta guardaremos los archivos generados.

# dir.exists("results") revisa si la carpeta results/ existe y devuelve TRUE o FALSE.
# El bloque if no imprime TRUE o FALSE por sí mismo: solo ejecuta la instrucción indicada
# cuando la condición se cumple.
#
# Si results/ no existe, se crea.
# Si results/ ya existe, no se borra ni se modifica su contenido.

if (!dir.exists("results")) {
  dir.create("results")
  message("Se creó la carpeta results/.")
} else {
  message("La carpeta results/ ya existe.")
}

# ============================================================
# 3. Instalar paquetes, solo si es necesario
# ============================================================

# Para trabajar con archivos de Excel usaremos dos paquetes:
# readxl  -> permite leer archivos .xls y .xlsx
# writexl -> permite guardar archivos .xlsx

# Si no tienes instalados estos paquetes, quita el símbolo # de las siguientes líneas
# y ejecútalas una sola vez.

# install.packages("readxl")
# install.packages("writexl")

# ============================================================
# 4. Cargar paquetes
# ============================================================

# Una vez instalados, los paquetes deben cargarse en la sesión de R.

library(readxl)
library(writexl)

# ============================================================
# 5. Leer archivo de Excel
# ============================================================

# El archivo debe estar en:
# data/U1_datos_expresion.xlsx

# Verificamos si el archivo existe:
file.exists("data/U1_datos_expresion.xlsx")

# Leemos el archivo de Excel:
datos_excel <- read_excel("data/U1_datos_expresion.xlsx")

# ============================================================
# 6. Explorar el objeto importado
# ============================================================

# Ver el objeto completo
datos_excel

# Ver las primeras filas
head(datos_excel)

# Revisar nombres de columnas
names(datos_excel)

# Revisar estructura general
str(datos_excel)

# ============================================================
# 7. Filtrar datos
# ============================================================

# Filtramos solo las filas correspondientes a Etapa1.

filtered_data_excel <- subset(datos_excel, Etapas == "Etapa1")

# Revisamos el objeto filtrado
filtered_data_excel

# Revisamos las primeras filas
head(filtered_data_excel)

# ============================================================
# 8. Guardar resultado como archivo de Excel
# ============================================================

# Guardaremos el archivo generado en la carpeta results/.

write_xlsx(
  filtered_data_excel,
  "results/U1_datos_Etapa1.xlsx"
)

# Después de ejecutar esta línea, revisa la carpeta results/.
# Debería aparecer el archivo:
# U1_datos_Etapa1.xlsx

# ============================================================
# 9. Opcional: guardar también como CSV
# ============================================================

# Aunque este script se enfoca en Excel, también podrías guardar
# el resultado como archivo .csv usando R base.

# write.csv(
#   filtered_data_excel,
#   "results/U1_datos_Etapa1_desde_excel.csv",
#   row.names = FALSE
# )

# ============================================================
# Fin del script
# ============================================================

# En este script practicaste:
# - cargar paquetes con library()
# - leer un archivo .xlsx
# - explorar una tabla importada
# - filtrar datos
# - guardar un archivo .xlsx en results/


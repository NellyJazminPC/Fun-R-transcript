### Script para la Sesión 2.4 - Leer y guardar archivos en R
### Martes 18 de junio de 2024
## Ejemplo y ejercicio de como leer/importar datos y como guardar/exportar los datos generados en R.

#¿En dónde estás?
getwd()


# Ejercicio. Con los datos U3_2.csv dentro de la carpeta data.
# Conserva los encabezados de las columnas 
# Este archivo esta delimitado por ","

data_expresion <- read.csv("../data/U3_2.csv", header = T, sep = ",") 


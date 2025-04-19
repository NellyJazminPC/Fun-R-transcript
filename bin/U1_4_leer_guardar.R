### Script para la Sesión 2.4 - Leer y guardar archivos en R
### Martes 18 de junio de 2024
## Ejemplo y ejercicio de como leer/importar datos y como guardar/exportar los datos generados en R.

#¿En dónde estás?
getwd()


# Ejercicio. Con los datos U3_2.csv dentro de la carpeta data.
# Conserva los encabezados de las columnas 
# Este archivo esta delimitado por ","

data_expresion <- read.csv("../data/U3_2.csv", header = T, sep = ",") 

# Realizar una operación simple (por ejemplo, filtrar solo los datos de Etapa1)
filtered_data_etapa1 <- subset(data_expresion, Etapas == "Etapa1")


#Guardar el archivo en formato .txt
#Usando la función base de R
write.table(filtered_data_etapa1, "../data/filtered_data_Etapa1.txt", sep = "\t", row.names = T)

# Guardar el archivo CSV resultante
#write.csv(filtered_data, "ruta/al/nuevo_archivo.csv", row.names = FALSE)


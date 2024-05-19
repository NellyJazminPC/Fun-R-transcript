### Script para la Sesión 1 - Introducción a R y RStudio
### Lunes 17 de junio de 2024
#
#####  Operaciones básicas
#¿Qué obtienes al ejecutar cada línea de código?
#Recuerda que puedes usar `Run` o las teclas `Ctrl` + `Enter`
3 + 5   #   Suma
8 - 3   #   Resta
7 * 5   #   Multiplicación
1/2     #   División
4 ^ 4   #   Exponencial
4 ** 4  #   Exponencial
5 %% 3  #   Módulo
5 %/% 3 #   División entera

# %*%	Multiplicación matricial
# %o%	Producto exterior
# %x%	Producto Kronecker


#Los números pequeños o grandes tienen una notación científica:

2/10000 

# Resultado: 2e-04

# es la abreviatura de “multiplicado por 10 ^ XX” 
# Entonces 2e-4 es la abreviatura de 2 * 10^(-4)
# También puedes escribir números en notación científica:
5e3  # nota la falta del signo menos aquí, ¿cuál fue el resultado?
5e-3 # ¿Qué obuviste al agregar el signo - ?


# Carpetas y directorios

# ¿Cuál es el directorio de trabajo en el que estas?
getwd() 

# ¿Para que funciona setwd()?
?setwd() 
#Este comando cumple la misma función que Session > Set working directory 

# ¿Qué nos muestra el comando dir() ?
dir() 
# muestra los archivos que están en la carpeta donde te encuentras


#Desde el editor en RStudio puedes averiguar más acerca de la función install.packages
?install.packages()

#Después de revisar su sintaxis encontrarás que debemos poner el nombre del paquete que quieras instalar dentro de los paréntesis:

install.packages(ggplot2)

# Cuidado: si te aparece un error puede ser por la versión de R, en algunas versiones previas necesitas poner entre comillas el nombre del paquete: install.packages("ggplot2") 




#ls() mostrara una lista de todas las variables y funciones almacenadas en el entorno global, es decir, en tu sesión de trabajo en R:

ls() #Prueba este comando y ve que obtienes.

#Para listar todos los objetos, escribe 
ls(all.names = TRUE)

#Puedes usar rm para eliminar objetos que ya no necesitas:

rm(x)

# Si tienes muchas cosas en tu entorno y deseas borrarlas todas, puedes pasar los resultados de ls y mandarlos a la función rm:

rm(list = ls())




# Línea para probar source()
print("Haz entrado a la M A T R I X")
print("ACEPTAS?")

###### Sesión de la Unidad 2 ######
## Martes 18 de junio de 2024
## Nelly Jazmín Pacheco Cruz
## Estructuras de datos en R

## Vectores:

# Se construye con la función c(), combinar valores en un vector o lista
# Construye un vector con los valores 5,10,15 y 20:
mi_vector <- c(5,10,15,20) 
#Revisa que elementos contiene "mi_vector"
mi_vector

# ¿Puedes hacer operaciones con este vector?
mi_vector + 1

mi_vector + mi_vector

#Crea un nuevo vector y guarda elementos de tipo caracter, es decir, letras
letras <- c("a","b","c","d") 

# Los elementos en el vector se referencian con corchetes
#Veamos el primer elemento del vector "letras"
letras[1]

#Veamos los elementos 1, 2 y 3
letras[1:3]

#Veamos los elementos 1 y 4
letras[c(1,4)]


###### Unidad 2 ######
#### Sesión 2.1
## Martes 17 de junio de 2025
## Introducción a las variables y funciones
## Nelly Jazmín Pacheco Cruz

# Recordando el ejemplo de la caja, la caja en donde guardaras el valor 5 se llamará x
x <- 5
# Ahora revisa lo que tiene tu variable x
x


# La caja, es decir la variable se llama x y el valor u objeto que estamos asignado es 10
10 -> x
#Imprime x
x
# ¿Qué pasa en este caso?
10 <- x

#### Ejercicio:  ####
### reescribir el valor de una variable o asignarlo a una nueva

# Agregar un valor a la variable (objeto)
x <- 5
x #Imprime lo que contiene el variable X
x + 1 #Suma 1 a x

# ¿Se guardó el valor de 6?
x

#Para guardar este valor hay dos opciones:
# 1) podemos reescribir la variable
# A x le sumamos 1:
x <- x + 1
x

# 2) podemos asignar este nuevo valor a otra variable
# y es el valor de x multiplicado por dos
y <- x * 2 

# Verifica que valores tiene "x" y "y"
x
y

#### Ejemplo de función ####
#Ejecuta la siguiente línea así como está
plot.default
# ¿Qué obtuviste?

#### Ejercicio de función ####
install.packages("ggplot2")

# Quieres saber más de una función, utiliza help() 
help("install.packages")

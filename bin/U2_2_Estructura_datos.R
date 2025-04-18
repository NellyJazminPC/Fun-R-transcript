###### Unidad 2 ######
#### Sesión 2.2
## Martes 17 de junio de 2025
## Estructuras de datos en R
## Nelly Jazmín Pacheco Cruz


############# VECTORES ############################################

#### Ejemplo de vectores ####
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

#### Ejercicio de vectores ####
#Considera los vectores x y y:
x <- c(4,6,5,7,10,9,4,15) 
y <- c(0,10,1,8,2,3,4,1)

# Realiza algunas operaciones con estos vectores. Por ejemplo:

#Suma los dos vectores
x+y

# ¿Puedes saber si el vector x es mayor a 7?
x >7

# Averigua cuántos elementos contienen los vectores creados
length(x)
length(y)


##### Extra:  
# ¿Qué pasa si uno de los vectores tiene datos faltantes? NA
# Vectores con valores NA
x_na <- c(4, 6, NA, 7, 10, 9, 4, 15)
y_na <- c(0, 10, 1, 8, NA, 3, 4, 1)

# Suma de vectores con NA
x_na + y_na

# Dónde hay un NA el resultado también es NA


############### MATRICES #########################################

### Matrices:
#Puedes acceder a la Ddocumentación de la función para crear matrices
?matrix

#### Ejemplo de matrices ####

# Creación de una matriz donde los valores se llenan por columnas
# 1:12 indica que habrá valores desde el número 1 hasta el 12
# ncol indica que la matriz tendrá 3 columnas
matriz_columnas <- matrix(1:12, ncol = 3)
matriz_columnas

# Creación de una matriz donde los valores se llenan por filas
# byrow indica que los valores del 1:12 se distribuirán por filas 
matriz_filas <- matrix(1:12, ncol = 3, byrow = TRUE)
matriz_filas

# Para ver un elemento específico de la matriz, accedemos con [,]
# [f,c] el primer elemento indica la fila, y el segundo la columna
# [1,3] representa el elemento de la fila 1 y columna 3
matriz_filas[1, 3]

# Intenta la siguiente línea:
matriz_filas[3, 4] 
# ¿Qué pasó? 
# La matriz_fila solo tiene 3 columnas (ncol = 3),
# por lo que no hay una cuarta columna.

# Para ver todos los elementos de una columna 
# se deja vacío el primer elemento que indica las filas
# Todos los elementos de la columna 3
matriz_filas[, 3] 
# Todos los elementos de la fila 4
matriz_filas[4, ] 

# Podemos hacer operaciones aritméticas sencillas 
# Suma 1 a cada elemento:
matriz_filas + 1 
# Suma a cada elemento su valor correspondiente
matriz_filas + matriz_filas

# Operaciones estadísticas
# Suma de todos los elementos en la matriz
sum(matriz_filas)  
# Media de todos los elementos en la matriz
mean(matriz_filas)  
# Desviación estándar de todos los elementos en la matriz
sd(matriz_filas)  

# Extra:

# Revisa la matriz original:
matriz_filas
# Revisa las dimensiones de las matrices:
dim(matriz_filas)
# Muestra toda la matriz con la función print() - imprimir en la consola/terminal
print(matriz_filas)


####  Ejercicio final de Matrices: ####
# Crea un vector con 12 enteros y conviértelo en una matriz de 4*3
m <- matrix(1:12, nrow = 4)
m

# Cambia los nombres de las columnas y filas
colnames(m) <- c("x", "y", "z")
rownames(m) <- c("a", "b", "c", "d")
m

# Obtiene una matriz de 3*3
m_submatriz <- m[1:3, 1:3]
m_submatriz

# Dimensiones de m
dim(m)

#Extra : Podrías generar una matriz de 4x4 a partir de la matriz de 4x3?
# Agrega una nueva columna adicional a la matriz m para obtener una matriz de 4x4
m_4x4 <- cbind(m, c(13, 14, 15, 16))
m_4x4


############# DATA FRAMES - MARCOS DE DATOS ############################################
# necesitas la función data.frame()
# Primero vamos a crear un data frame con dos columnas, "distance" y "condition"

data_frame_dist_cond <- data.frame(distance=c(4,4,4,7,8,5), condition=c("a","a","a","b","b","b"))

#Visualiza el data frame
data_frame_dist_cond

#Para seleccionar la primera columna
data_frame_dist_cond[1]

#Otra forma de seleccionar una columna es por el nombre de la misma:

data_frame_dist_cond["distance"]

#Si queremos el primer elemento de la columna "distance" usando los [ ]
#Primero selecciona la columna como un vector y accesa al primer elemento
data_frame_dist_cond[["distance"]][1]


# Otra forma de seleccionar una columna es con el operador compacto $

data_frame_dist_cond$condition
data_frame_dist_cond$condition[1]

#Puedes explorar la primera y última parte del data frame con head() y tail()
head(data_frame_dist_cond, 3)
tail(data_frame_dist_cond, 3)


#### Ejercicio para crear un data.frame a partir de vectores: ####
#Crea los vectores: edad, nombres y genero
edad <- c(22, 25, 18, 15, 20)
edad
nombres <- c("Jaime", "Mateo", "Olivia", "Javier","Sandra") 
nombres
genero <- c("M", "M", "F", "M", "F")
genero

# Para ordenar los valores por edad se usa la función order()
# Solución:
# Puedes asignarle otro nombre a las columnas que aparecerán en tu df
# Renombra las columnas
df_age_name_gen <- data.frame(edades=edad,names_df=nombres,genero=genero)

df_age_name_gen

# ordernar por edades
df_age_name_gen[order(df_age_name_gen$edades),]

#Extra: ordernar por nombres, en forma descendente
df_age_name_gen[order(df_age_name_gen$names_df, decreasing = T),]
#Extra: ordenar múltiples columnas
df_age_name_gen[order(df_age_name_gen$names_df, df_age_name_gen$edades, decreasing = T), ]

#### Extra de data.frames ####
# Ver la estructura del data frame
str(df)

# Resumen estadístico del data frame
summary(df)

# Cambiar los nombres de las columnas
names(df) <- c("Edad", "Nombre", "Género")

# Cambiar el nombre de una sola columna con la función names()
names(df)[names(df) == "Edad"] <- "age"

# Añadir una nueva columna
df$height <- c(180, 165, 170, 175)

# Eliminar una columna
df$height <- NULL



###### Sesión de la Unidad 2 ######
## Martes 18 de junio de 2024
## Nelly Jazmín Pacheco Cruz
## Estructuras de datos en R

############# VECTORES Y FACTORES ############################################
### Vectores:

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


# Ejercicio. Crea dos nuevos vectores:

x <- c(4,6,5,7,10,9,4,15) 
y <- c(0,10,1,8,2,3,4,1)

#Suma los dos vectores
x+y

# ¿Puedes saber si el vector x es mayor a 7?
x >7

#¿Puedes unir ambos vectores en uno solo?

c(x,y)

# Crea un nuevo vector que guarde los valores de ambos vectores, "x" y "y"

z <- c(x,y)
z
# Averigua cuántos elementos contienen los vectores creados

length(x)
length(y)
length(z)

##### Extra: ¿Qué pasa si los vectores tienen tamaños diferentes?
# Crea dos vectores con un número distinto de elementos
x_long <- c(4, 6, 5, 7, 10, 9, 4, 15)
y_short <- c(0, 10, 1, 8)
#Suma los dos vectores,¿qué paso?
x_long + y_short
# el vector "y_short" se recicló para que tuviera la misma longitud que "x_long"


# ¿Qué pasa si uno de los vectores tiene datos faltantes? NA
# Vectores con valores NA
x_na <- c(4, 6, NA, 7, 10, 9, 4, 15)
y_na <- c(0, 10, 1, 8, NA, 3, 4, 1)

# Suma de vectores con NA
x_na + y_na

# Dónde hay un NA el resultado también es NA


### Factores:
#Crea un vector con elementos de tipo caracter
#Puedes separar la lista dando Enter después de una "," 
meses_mix <- c("Enero","Febrero","Marzo","Marzo",
               "Abril","Enero","Abril","Mayo",
               "Junio","Agosto","Julio","Julio",
               "Noviembre","Febrero","May","Agosto", 
               "Julio","Diciembre","Enero","Agosto",
               "Septiembre","Noviembre","Febrero",
               "Abril")
#Revisa el vector creado:
meses_mix

#Convierte un vector de datos categóricos o de texto en un factor
fmeses_mix <- factor(meses_mix) 

#Revisa el factor creado:
fmeses_mix
# Puedes notar que la parte inferior indica el número de niveles y cuáles son.

#Otra forma de visualizar este factor y ver cuantos elementos hay en cada nivel
#es con una tabla de frecuencias, con la función table()
table(fmeses_mix)

## Usos:

# Generar 100 valores de peso simulados con media 50 y desviación estándar 10
pesos <- rnorm(n = 100, mean = 50, sd = 10) 

# Dividir los datos en grupos (categorías) utilizando la función cut()
# En este caso, los datos se dividen en 4 grupos basados en los cuartiles
# También se asignan etiquetas personalizadas a cada grupo ("1stQ", "2ndQ", "3rdQ", "4thQ")
fpesos <- cut(round(pesos), breaks = quantile(pesos, probs = seq(0, 1, 0.25)), 
              labels = c("1stQ", "2ndQ", "3rdQ", "4thQ"))

# Mostrar la frecuencia de observaciones en cada grupo utilizando la función table()
# Esto mostrará cuántas observaciones caen en cada uno de los grupos definidos por los cuartiles
table(fpesos)

## Diferencias entre factor() y cut()
#factor() - datos categóricos como cadenas de texto
colores <- c("rojo", "azul", "verde", "rojo")
colores_factor <- factor(colores)
colores_factor
#cut() - datos numéricos
edades <- c(5, 15, 25, 35, 45)
grupos_edad <- cut(edades, breaks = c(0, 18, 30, 50), labels = c("Niños", "Adolescentes", "Adultos"))
grupos_edad


# Ejercicio:
# Vector inicial
niveles <- c("bajo", "alto", "medio", "alto", "alto", "bajo", "medio")
# Respuestas:
# Convertir a factor
niveles_factor <- factor(niveles)
niveles_factor
# Obtener la frecuencia de cada valor antes del cambio
table(niveles_factor)

# Cambiar los niveles del factor
levels(niveles_factor) <- c("no satisfactorio", "alto", "medio")

# Extra: hay otra forma. Por ejemplo, cambia alto por "muy alto"
levels(niveles_factor) # Revisa que elemento es el que quieres cambiar
levels(niveles_factor)[2] # corroboralo
# Asigna el nuevo nombre
levels(niveles_factor)[2] <- "muy alto"
#Comprueba el cambio
levels(niveles_factor)

# Obtener la frecuencia de cada valor después del cambio
table(niveles_factor)

############### MATRICES Y ARRAYS #########################################

### Matrices:
#Documentación de la función para crear matrices
?matrix

#Ejemplo:

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

# Revisa la matriz original:
matriz_filas


# Extra:

# Revisa las dimensiones de las matrices:
dim(matriz_filas)
matriz_filas

# Obtén el número total de elementos en la matriz
length(matriz_filas)  

# Selecciona elementos mayores que 5 en la matriz
matriz_filas[matriz_filas > 5]  

# Asigna nombres a las filas
rownames(matriz_filas) <- c("fila1", "fila2", "fila3", "fila4") 
matriz_filas
# Asigna nombres a las columnas
colnames(matriz_filas) <- c("col1", "col2", "col3")  
matriz_filas

# Calcula la suma y promedio de las filas de la matriz
rowSums(matriz_filas) 
rowMeans(matriz_filas)
# Calcula la suma y promedio de las columnas de la matriz
colSums(matriz_filas)
colMeans(matriz_filas) 

## Ejercicio:
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

## Arrays
# Creamos un array tridimensional de 3x3x3
array_3d <- array(1:27, dim = c(3, 3, 3))

# Mostramos el array
array_3d



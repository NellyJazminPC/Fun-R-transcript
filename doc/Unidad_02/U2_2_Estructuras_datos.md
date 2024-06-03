# Fundamentos de programación en R

## Unidad 2

---

## 2.2 Estructuras de datos

---

### Aspectos básicos

![alt text](image_2.2_01.png)

Las estructuras de datos en R son fundamentalmente formas de organizar, almacenar y manipular datos. 

Cada tipo de estructura de datos tiene sus propias características y se utiliza en diferentes contextos según las necesidades de análisis y procesamiento de datos.

- **Los Vectores** son estructuras de datos **unidimensionales** que pueden contener elementos del **mismo tipo**, como números, caracteres o valores lógicos. Los vectores pueden ser simples (de longitud uno) o múltiples (de longitud mayor a uno)

    - **Los Factores** son **vectores** que representan datos categóricos, donde cada elemento tiene un nivel específico. Aunque internamente se almacenan como enteros, los factores tienen un **atributo de nivel** que especifica las etiquetas de categoría asociadas.

- **Las Matrices** son arreglos **bidimensionales** que contienen elementos del **mismo tipo**. Tienen **filas y columnas**, lo que significa que son útiles para organizar datos en una tabla de dos dimensiones.

    - **Los _Arrays_** son estructuras de datos **multidimensionales** que pueden contener elementos del mismo tipo. A diferencia de las matrices, los arrays pueden tener **más de dos dimensiones**, lo que los hace útiles para almacenar y manipular datos con múltiples índices.

- **Los _Data frames_** son estructuras de datos **bidimensionales** similares a las matrices, pero cada **columna** puede contener un **tipo diferente** de datos. Se utilizan para representar conjuntos de datos tabulares, donde las **filas** representan **observaciones** y las **columnas** representan **variables**.

- **Las Listas** son **colecciones** ordenadas de **objetos** que pueden ser de **diferentes tipos**. Las listas pueden ser unidimensionales, pero **cada elemento** de la lista puede contener **cualquier estructura de datos**, lo que proporciona flexibilidad en la organización de datos complejos.

A continuación vamos a explorar estas estructuras de datos en R. Aquí algunos tips que usaremos más adelante:

```R
# Información de estructuras y conversión

# Para convertir una estructura de un tipo a otro, usamos la función as.*().

?as.vector

?as.matrix

# Para saber las dimensiones y que clase de objeto (variable) es:

?dim

?class

```

---

## 2.2.1 Vectores y Factores

### Vectores

Son la estructura más sencilla de R, contiene una fila de valores del mismo tipo (numérico o cadena de texto)

Se construye con la función `c()`, que va a combinar valores en un vector o lista.

```R
# Construye un vector con los valores 5,10,15 y 20:
mi_vector <- c(5,10,15,20) 
#Revisa que elementos contiene "mi_vector"
mi_vector

# ¿Puedes hacer operaciones con este vector?
mi_vector + 1

mi_vector + mi_vector

#Crea un nuevo vector y guarda elementos de tipo caracter, es decir, letras
letras <- c("a","b","c","d") 

```

Los elementos en el vector se referencian con corchetes `[i]`

```R
#Veamos el primer elemento del vector "letras"
letras[1]

#Veamos los elementos 1, 2 y 3
letras[1:3]

#Veamos los elementos 1 y 4
letras[c(1,4)]
```

#### Usos

Los vectores numéricos son útiles para cálculos sencillos:

- `mean()`: Calcula el valor medio (promedio) de un vector numérico.
- `sd()`: Calcula la desviación estándar de un vector numérico, que indica la dispersión de los datos con respecto a la media.
- `max()`: Devuelve el valor máximo de un vector numérico.
- `min()`: Devuelve el valor mínimo de un vector numérico.
- `length()`: Devuelve la longitud (cantidad de elementos) de un vector o lista en R.

#### Ejercicio

Considera los vectores x y y:

```R
x <- c(4,6,5,7,10,9,4,15) 
y <- c(0,10,1,8,2,3,4,1)
```

Realiza algunas operaciones con estos vectores. Por ejemplo:

```R
#Suma los dos vectores
x+y

# ¿Puedes saber si el vector x es mayor a 7?
x >7

#¿Puedes unir ambos vectores en uno solo?

c(x,y)

# Crea un nuevo vector que guarde los valores de ambos vectores, "x" y "y"

z <- c(x,y)

# Averigua cuántos elementos contienen los vectores creados

length(x)
length(y)
length(z)
```

#### Extra:

```R
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
```

---

### Factores

- Son vectores cuyos valores están organizados en categorías.

- Las categorías se llaman **levels** y son valores de texto.

- Esta nueva capa de información es útil para calcular estadísticos descriptivos.

#### Ejemplo

```R
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
```

#### Usos

```R
pesos <- rnorm(n=100,mean=50,sd=10) 
fpesos <- cut(pesos,breaks=3)
table(fpesos)
fpesos <- cut(round(pesos), breaks=quantile(pesos, probs = seq(0, 1, 0.25)), labels=c("1stQ","2ndQ","3rdQ","4thQ"))
# advertencia: produce valores NA para los outliers 
table(fpesos)

```

#### Ejercicio

Considera el factor:

```R
x <- factor(c("bajo", "alto", "medio", "alto", "alto" , "bajo", "medio"))

```

**Ejercicio**

Obtén la frecuencia de cada valor

Agrega un valor "muy alto" y haz que aparezca como nivel (tip: append(); de que tipo es levels()?)

Cambia los valores de "bajo" por "no satisfactorio" (tip: levels())

Nota extra: Evitemos los espacios en blanco en los nombres de las variables. Podemos usar guiones bajos "muy_alto" o separar usando mayúsculas "muyAlto". Evitemos usar acentos y caracteres especiales y la ñ.

<https://platzi.com/blog/buena-practica-codigo-nombrar-elementos/>

**Soluciones**

Agrega un valor "muy alto":

```{r}
#levels(x)
append(x=levels(x),values="muy_alto",after=length(x))
#x
```

Cambia los valores de "bajo" por "no satisfactorio":

```{r}
levels(x)[2] <- "no_satisfactorio"
levels(x)
#x
```



### 2.2.1 Fuentes de información

---


## 2.2.2 Matrices y Arrys (arreglos)

### 2.2.2 Fuentes de información

---


## 2.2.3 Data.frames (marcos de datos)

### 2.2.3 Fuentes de información

---


## 2.2.4 Listas

### 2.2.4 Fuentes de información

### Fuentes de información

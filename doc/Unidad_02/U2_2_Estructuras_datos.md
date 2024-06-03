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

### Definición

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

### Usos

Los vectores numéricos son útiles para cálculos sencillos:

`mean ()` `sd()` `max()` `min()` `length ()`



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

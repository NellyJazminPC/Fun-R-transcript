# Fundamentos de programación en R

## Unidad 2

---

#### [Versión extendida](../Unidad_02/U2_3_Manipulacion_dato_version_ext.md)

---

## 2.3 Manipulación de datos con `dplyr`

* [Presentación](https://docs.google.com/presentation/d/e/2PACX-1vQw4Yy6iZP5lUw238gcODPyiUBbpRDzETNL1PAGfx9LvtF3ad_WR3fm68RBUeUuHA/pub?start=false&loop=false&delayms=60000)

## Objetivo

Aplicar funciones básicas de `dplyr` para seleccionar columnas, filtrar filas, crear variables, ordenar datos y resumir información en un data frame.

## Material de apoyo

Durante esta unidad trabajaremos con un script general de práctica:

* [Script de práctica general Unidad 2](../../bin/U2_practica_general.R)

Durante la sesión iremos ejecutando solo los bloques indicados por la instructora.

---

## 1. ¿Qué significa manipular datos?

Manipular datos significa realizar operaciones para **seleccionar, filtrar, modificar, ordenar o resumir** la información contenida en una tabla.

En R, una de las herramientas más utilizadas para manipular datos tabulares es el paquete `dplyr`, que forma parte de `tidyverse`.

Algunas preguntas que podemos responder al manipular un data frame son:

* ¿Qué columnas necesito conservar?
* ¿Qué filas cumplen una condición?
* ¿Puedo crear una nueva columna a partir de otra?
* ¿Puedo ordenar mis datos?
* ¿Puedo resumir la información por grupo?

---

## 2. Preparar el data frame de trabajo

En el tema anterior creamos un data frame llamado `metadata`, con información hipotética de muestras para un análisis transcriptómico.

Si no lo tienes en tu sesión de R, puedes volver a crearlo:

```r
metadata <- data.frame(
  sample_id = c("S01", "S02", "S03", "S04", "S05", "S06"),
  condition = c("control", "control", "stress", "stress", "control", "stress"),
  tissue = c("leaf", "leaf", "leaf", "root", "root", "root"),
  reads_million = c(18.5, 21.2, 19.8, 25.1, 20.4, 17.9)
)

metadata
```

Revisemos nuevamente su estructura:

```r
head(metadata)
dim(metadata)
str(metadata)
summary(metadata)
```

Este data frame será nuestra tabla de práctica para aplicar funciones básicas de manipulación de datos.

---

## 3. Cargar `dplyr`

Para usar las funciones de `dplyr`, primero necesitamos cargar el paquete.

```r
library(dplyr)
```

Si ya cargaste `tidyverse`, entonces `dplyr` ya está disponible, porque forma parte de esa colección de paquetes.

---

## 4. Operadores lógicos

Antes de filtrar datos, necesitamos recordar algunos **operadores lógicos**.

Los operadores lógicos permiten hacer comparaciones y obtener resultados de tipo `TRUE` o `FALSE`.

```r
# Crea dos variables
x <- 5
y <- 15

# Comparaciones
x > 5
x == y
x != y
x < y
```

También podemos combinar condiciones:

```r
# Evalúa si ambas condiciones son verdaderas
x < 10 & y < 20

# Evalúa si al menos una condición es verdadera
x > 10 | y < 20
```

Algunos operadores frecuentes son:

| Operador | Significado                           |
| -------- | ------------------------------------- |
| `>`      | mayor que                             |
| `<`      | menor que                             |
| `>=`     | mayor o igual que                     |
| `<=`     | menor o igual que                     |
| `==`     | exactamente igual a                   |
| `!=`     | diferente de                          |
| `&`      | ambas condiciones deben cumplirse     |
| `\|`     | al menos una condición debe cumplirse |

Estos operadores serán útiles para filtrar filas dentro de un data frame.

---

## 5. Valores faltantes: `NA`

En R, `NA` representa un **valor faltante**.

```r
vector_with_na <- c(1, 2, NA, 4, NA, 6)

vector_with_na
```

Para identificar valores faltantes usamos `is.na()`:

```r
is.na(vector_with_na)
```

Muchas funciones devuelven `NA` si los datos contienen valores faltantes:

```r
mean(vector_with_na)
```

Para ignorar los valores faltantes al calcular el promedio, podemos usar `na.rm = TRUE`:

```r
mean(vector_with_na, na.rm = TRUE)
```

En datos reales, es importante revisar si hay valores faltantes antes de continuar con el análisis.

---

## 6. Seleccionar columnas con `select()`

La función `select()` permite elegir columnas de un data frame.

Por ejemplo, podemos seleccionar solo las columnas `sample_id`, `condition` y `reads_million`:

```r
metadata_select <- select(metadata, sample_id, condition, reads_million)

metadata_select
```

También podemos hacerlo indicando que queremos excluir una columna:

```r
metadata_sin_tissue <- select(metadata, -tissue)

metadata_sin_tissue
```

`select()` responde a la pregunta:

> ¿Qué columnas quiero conservar?

---

## 7. Filtrar filas con `filter()`

La función `filter()` permite conservar solo las filas que cumplen una o más condiciones.

Por ejemplo, podemos filtrar las muestras de la condición `control`:

```r
metadata_control <- filter(metadata, condition == "control")

metadata_control
```

También podemos filtrar las muestras del tejido `root`:

```r
metadata_root <- filter(metadata, tissue == "root")

metadata_root
```

Y podemos combinar condiciones:

```r
metadata_control_leaf <- filter(metadata, condition == "control", tissue == "leaf")

metadata_control_leaf
```

`filter()` responde a la pregunta:

> ¿Qué filas cumplen la condición que necesito?

---

## 8. Crear o modificar columnas con `mutate()`

La función `mutate()` permite crear nuevas columnas o modificar columnas existentes.

Por ejemplo, podemos crear una nueva columna con el número aproximado de lecturas, ya no en millones sino en unidades:

```r
metadata_reads <- mutate(
  metadata,
  reads = reads_million * 1e6
)

metadata_reads
```

También podemos crear una etiqueta combinando información de dos columnas:

```r
metadata_label <- mutate(
  metadata,
  sample_label = paste(condition, tissue, sample_id, sep = "_")
)

metadata_label
```

`mutate()` responde a la pregunta:

> ¿Qué nueva variable puedo crear a partir de la información que ya tengo?

---

## 9. Ordenar filas con `arrange()`

La función `arrange()` permite ordenar las filas de un data frame.

Por ejemplo, podemos ordenar las muestras de menor a mayor número de lecturas:

```r
metadata_ordenado <- arrange(metadata, reads_million)

metadata_ordenado
```

Para ordenar de mayor a menor, usamos `desc()`:

```r
metadata_ordenado_desc <- arrange(metadata, desc(reads_million))

metadata_ordenado_desc
```

También podemos ordenar por más de una columna:

```r
metadata_ordenado_grupos <- arrange(metadata, condition, tissue)

metadata_ordenado_grupos
```

`arrange()` responde a la pregunta:

> ¿En qué orden quiero ver mis datos?

---

## 10. Resumir información por grupos con `group_by()` y `summarise()`

La función `group_by()` permite agrupar datos según una o más columnas.

La función `summarise()` permite calcular resúmenes por grupo.

Por ejemplo, podemos calcular cuántas muestras hay por condición:

```r
metadata_por_condicion <- metadata %>%
  group_by(condition) %>%
  summarise(
    n_muestras = n()
  )

metadata_por_condicion
```

También podemos calcular el promedio de lecturas por condición:

```r
metadata_promedio <- metadata %>%
  group_by(condition) %>%
  summarise(
    promedio_lecturas_millones = mean(reads_million)
  )

metadata_promedio
```

Y podemos agrupar por más de una columna:

```r
metadata_resumen_grupos <- metadata %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen_grupos
```

`group_by()` y `summarise()` responden a preguntas como:

> ¿Cuántas muestras tengo por grupo?
> ¿Cuál es el promedio de lecturas por condición o tejido?

---

## 11. Pipe: encadenar pasos de análisis

El **pipe** permite encadenar varias operaciones de forma más legible.

La idea general es:

> toma este objeto, pásalo a la siguiente función y después a la siguiente.

En muchos scripts de R encontrarás el pipe de `magrittr`:

```r
%>%
```

En versiones recientes de R también existe el pipe base:

```r
|>
```

Ambos permiten leer el código de izquierda a derecha o de arriba hacia abajo. Durante esta sesión revisaremos ambos para reconocerlos, pero nos enfocaremos en una versión para practicar.

### Ejemplo sin usar pipe

```r
metadata_resumen_sin_pipe <- summarise(
  group_by(
    mutate(
      filter(metadata, !is.na(condition)),
      reads = reads_million * 1e6
    ),
    condition,
    tissue
  ),
  n_muestras = n(),
  promedio_lecturas_millones = mean(reads_million),
  .groups = "drop"
)

metadata_resumen_sin_pipe
```

Este código funciona, pero puede ser difícil de leer porque las funciones quedan anidadas unas dentro de otras.

### Ejemplo con `%>%`

```r
metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen
```

### Ejemplo con `|>`

```r
metadata_resumen_base_pipe <- metadata |>
  filter(!is.na(condition)) |>
  mutate(reads = reads_million * 1e6) |>
  group_by(condition, tissue) |>
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen_base_pipe
```

La lógica es la misma: partimos de `metadata`, filtramos filas, creamos una nueva columna, agrupamos y generamos un resumen.

---

## 12. Ejercicio integrador

Usa el data frame `metadata` para crear un resumen de las muestras.

### Instrucciones

1. Filtra las muestras que no tengan valores faltantes en `condition`.
2. Crea una nueva columna llamada `reads`, convirtiendo `reads_million` a lecturas totales.
3. Agrupa por `condition` y `tissue`.
4. Calcula:

   * el número de muestras por grupo;
   * el promedio de lecturas en millones.
5. Guarda el resultado en un objeto llamado `metadata_resumen`.

Puedes usar como guía el siguiente flujo:

```r
metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

metadata_resumen
```

### Preguntas

* ¿Qué función permitió filtrar filas?
* ¿Qué función permitió crear una nueva columna?
* ¿Qué función permitió agrupar los datos?
* ¿Qué función permitió generar el resumen?
* ¿Por qué puede ser útil guardar el resultado en un nuevo objeto?

---

## 13. Desafío extra: exportar el resultado

Una vez que generamos un data frame nuevo, podemos guardarlo como archivo para conservar el resultado de nuestro análisis.

Intenta exportar el objeto `metadata_resumen` dentro de la carpeta `results/`.

> La respuesta completa está disponible en el script de práctica general de la Unidad 2.

---

## Mini prompt de IA: explicar, detectar y verificar

En este cierre usaremos IA de forma acotada. El objetivo no es que la IA resuelva el análisis ni escriba el código por nosotros, sino que nos ayude a **explicar un bloque de código**, **anticipar errores comunes** y **verificar la respuesta en R**.

La idea es usar la IA como una lupa: nos ayuda a observar el código con más detalle, pero la interpretación final debe verificarse con el script, los datos y la documentación.

### 1. Antes de usar IA: revisa tu objeto en R

Antes de pegar el prompt, revisa qué tipo de objeto tienes, qué columnas contiene y si hay valores faltantes.

```r
class(metadata)
names(metadata)
colSums(is.na(metadata))
```

Estas tres líneas nos ayudan a responder preguntas básicas:

¿metadata es un data frame?
¿Qué columnas tiene?
¿Hay valores faltantes (NA) en alguna columna?

### 2. Código que vamos a revisar

Usaremos este fragmento del flujo de trabajo con dplyr:

```r
metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )

```

### 3. Mini prompt

Copia y pega el siguiente prompt en la herramienta de IA:

```
Estoy aprendiendo R con dplyr.

Tengo un data frame llamado metadata con estas columnas:

sample_id, condition, tissue, reads_million

Explica línea por línea este código. Después identifica dos errores comunes:
1. que una columna no exista;
2. que haya valores NA.

No propongas código nuevo todavía. Primero explica la lógica y dime cómo podría verificarla en R.

Código:

metadata_resumen <- metadata %>%
  filter(!is.na(condition)) %>%
  mutate(reads = reads_million * 1e6) %>%
  group_by(condition, tissue) %>%
  summarise(
    n_muestras = n(),
    promedio_lecturas_millones = mean(reads_million),
    .groups = "drop"
  )
```

### 4. ¿Qué respuesta esperamos?

La IA debería explicar, de forma general, que:

* `metadata` es el data frame de entrada.
* `filter(!is.na(condition))` conserva solo las filas donde `condition` no es `NA`.
* `mutate(reads = reads_million * 1e6)` crea una nueva columna llamada `reads`.
* `group_by(condition, tissue)` agrupa los datos por condición y tejido.
* `summarise()` genera una tabla resumen por grupo.
* `n_muestras = n()` cuenta cuántas muestras hay en cada grupo.
* `promedio_lecturas_millones = mean(reads_million)` calcula el promedio de lecturas en millones.
* `.groups = "drop"` elimina la agrupación al finalizar el resumen.

También debería advertir que:

* Si una columna no existe, por ejemplo si escribimos `read_million` en lugar de `reads_million`, `dplyr` devolverá un error.
* Si `reads_million` contiene valores `NA`, el promedio puede devolver `NA` si no indicamos cómo manejar los valores faltantes.
* Si `condition` contiene `NA`, `filter(!is.na(condition))` elimina esas filas antes del resumen.

### 5. Verifica la respuesta en R

Después de leer la respuesta de la IA, vuelve a R y verifica lo que dice.

```r
metadata_resumen
class(metadata)
names(metadata)
colSums(is.na(metadata))
```

Preguntas de cierre:

1. ¿La IA explicó correctamente qué hace cada paso?
2. ¿Detectó errores posibles relacionados con columnas inexistentes o valores `NA`?
3. ¿Qué parte pudiste verificar directamente en R?
4. ¿Qué parte convendría revisar en la documentación de `dplyr`?

> Recuerda: la IA puede ayudar a explicar y revisar código, pero la respuesta debe comprobarse con el código, los datos y la documentación.

---

## Para seguir explorando

Los siguientes ejemplos no forman parte del núcleo principal de la sesión, pero pueden ayudarte a practicar o profundizar después.

El código complementario está dividido en dos scripts:

* `bin/U2_para_seguir_explorando.R`: incluye ejemplos adicionales sobre funciones base de manipulación, datos en formato ancho y largo, `tidyr`, `pivot_longer()`, `pivot_wider()`, `separate()` y `unite()`.
* `bin/U2_extra_starwars.R`: incluye un ejercicio adicional con la base `starwars` para practicar funciones de manipulación de datos en un contexto más ligero.

### Datos en formato ancho y largo

En análisis de datos es común encontrar tablas en formato **ancho** o **largo**.

En el formato **ancho**, una variable puede extenderse en varias columnas.

En el formato **largo**, las observaciones se registran en filas adicionales.

Reconocer estos formatos es importante porque algunas funciones y visualizaciones requieren que los datos estén organizados de una forma específica.

### `tidyr`

El paquete `tidyr`, que forma parte de `tidyverse`, permite reorganizar datos tabulares.

Algunas funciones útiles son:

* `pivot_longer()`: convierte datos de formato ancho a largo.
* `pivot_wider()`: convierte datos de formato largo a ancho.
* `separate()`: divide una columna en varias columnas.
* `unite()`: une varias columnas en una sola.

Estas funciones se retomarán cuando sea necesario reorganizar datos para análisis o visualización.

### Ejercicio extra con `starwars`

La base `starwars`, incluida en `dplyr`, puede usarse para practicar funciones de manipulación de datos en un contexto más ligero.

El ejercicio estará disponible en:

* `bin/U2_extra_starwars.R`

En ese script podrás practicar funciones como:

* `select()`
* `filter()`
* `mutate()`
* `arrange()`
* `group_by()`
* `summarise()`

### Algunas funciones base de R

Además de `dplyr`, R base incluye funciones para manipular datos, por ejemplo:

* `subset()`: extrae subconjuntos de un data frame.
* `aggregate()`: calcula resúmenes por grupo.
* `t()`: transpone matrices o data frames.
* `lapply()` y `sapply()`: aplican funciones a listas o vectores.

Estas funciones pueden ser útiles, pero en esta unidad nos enfocaremos principalmente en `dplyr`.

---

## Fuentes de información

* [Data transformations - Cheat Sheets](https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf)
* [dplyr - tidyverse](https://dplyr.tidyverse.org/)
* [Pipe - magrittr](https://magrittr.tidyverse.org/reference/pipe.html)
* [Introducción a tidyr: Datos ordenados en R](https://rpubs.com/jaortega/151936)

---

### Siguiente tema: [3.1 Gráficos en R](../Unidad_03/)

# Fundamentos de programación en R

## Unidad 2

---

## 2.4 Leer y guardar archivos

---

### Aspectos básicos

Saber cómo leer y guardar archivos en RStudio es una habilidad esencial que te permite:

- Acceder y preparar datos para análisis.
- Asegurar la reproducibilidad y documentación de tus proyectos.
- Facilitar la colaboración y el intercambio de datos.
- Integrar datos de múltiples fuentes y trabajar con diferentes formatos (.txt, .csv, .xls, etc).

---

En RStudio, puedes leer y guardar archivos utilizando varias funciones. Aquí hay algunos ejemplos comunes para leer/importar y guardar/exportar archivos en diversos formatos como **CSV**, **Excel**, y **archivos de texto** (.txt).

A continuación, observa el siguiente **Cuadro comparativo** que resume las funciones, sus paquetes, el tipo de archivo que manejan y si es para importar/leer o exportar/guardar archivos en RStudio.

| Para ... | Paquete   | Función           | Tipo de archivos que maneja (extensión) |
|------------------------------|-----------|-------------------|-----------------------------------------|
| Leer archivos                | base      | `read.csv()`      | .csv                                    |
| Leer archivos                | **readr**     | `read_csv()`      | .csv                                    |
| Leer archivos                | `readxl`    | `read_excel()`    | .xls, .xlsx                             |
| Leer archivos                | base      | `read.table()`    | .txt, .tsv, .dat                        |
| Leer archivos                | **readr**     | `read_tsv()`      | .tsv, .txt                              |
| Guardar archivos             | base      | `write.csv()`     | .csv                                    |
| Guardar archivos             | **readr**     | `write_csv()`     | .csv                                    |
| Guardar archivos             | _writexl_   | `write_xlsx()`    | .xlsx                                   |
| Guardar archivos             | base      | `write.table()`   | .txt, .tsv, .dat                        |
| Guardar archivos             | **readr**     | `write_tsv()`     | .tsv, .txt                              |

### Leer archivos en R

#### Leer archivos CSV

Para leer archivos CSV, puedes usar la función `read.csv()`  del paquete `readr`:



```r
# Usando la función base de R
data <- read.csv("ruta/al/archivo.csv")

# Usando el paquete readr
library(readr)
data <- read_csv("ruta/al/archivo.csv")
```

#### Leer archivos Excel

Para leer archivos Excel, puedes usar el paquete `readxl`:

```r
library(readxl)
data <- read_excel("ruta/al/archivo.xlsx", sheet = "nombre_hoja")
```

#### Leer archivos de texto

Para leer archivos de texto, puedes usar la función `read.table()` o `readr::read_tsv()` para archivos delimitados por tabulaciones:

```r
# Usando la función base de R
data <- read.table("ruta/al/archivo.txt", header = TRUE, sep = "\t")

# Usando el paquete readr
library(readr)
data <- read_tsv("ruta/al/archivo.txt")
```

### Guardar archivos en R

#### Guardar archivos CSV
Para guardar archivos en formato CSV, puedes usar la función `write.csv()` del paquete `readr`:

```r
# Usando la función base de R
write.csv(data, "ruta/al/archivo.csv", row.names = FALSE)

# Usando el paquete readr
library(readr)
write_csv(data, "ruta/al/archivo.csv")
```

#### Guardar archivos Excel

Para guardar archivos Excel, puedes usar el paquete `writexl`:

```r
library(writexl)
write_xlsx(data, "ruta/al/archivo.xlsx")
```

#### Guardar archivos de texto

Para guardar archivos de texto, puedes usar la función `write.table()` del paquete `readr`:

```r
# Usando la función base de R
write.table(data, "ruta/al/archivo.txt", sep = "\t", row.names = FALSE)

# Usando el paquete readr
library(readr)
write_tsv(data, "ruta/al/archivo.txt")
```

### Ejemplo Completo

Aquí tienes un ejemplo completo que lee un archivo CSV, realiza una operación simple y guarda el resultado en un nuevo archivo CSV:

```r
# Leer el archivo CSV
data <- read.csv("ruta/al/archivo.csv")

# Realizar una operación simple (por ejemplo, filtrar filas)
filtered_data <- subset(data, columna > valor)

# Guardar el archivo CSV resultante
write.csv(filtered_data, "ruta/al/nuevo_archivo.csv", row.names = FALSE)
```

Este flujo básico te permitirá manejar archivos en RStudio de manera efectiva.



### Fuentes de información
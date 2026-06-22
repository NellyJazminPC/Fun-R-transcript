# ============================================================
# Fundamentos de programación en R para análisis transcriptómicos
# Unidad 3. Visualización de datos con R y ggplot2
# Script de práctica general
# 17 de junio de 2026 - NJ PC
# ============================================================
#
# Objetivo:
# Construir, interpretar y exportar figuras reproducibles en R
# usando gráficos base y ggplot2.
#
# Estructura sugerida del repositorio:
#
# data/
# ├── U3_1.csv
# └── U3_2.csv
#
# bin/
# └── U3_practica_general.R
#
# results/
# └── ya creada durante la primera sesión o creada en este script
#
# Nota:
# Este script evita usar setwd(). Trabajaremos con rutas relativas
# para que el código funcione dentro del proyecto de RStudio.
#
# Convención de nombres:
# En este script usaremos nombres descriptivos y snake_case para
# los objetos creados en R, por ejemplo:
#
# datos_genes_manual
# datos_genes_archivo
# datos_expresion
# resumen_tar_etapas
#
# ============================================================


# ------------------------------------------------------------
# 0. Preparar ambiente de trabajo
# ------------------------------------------------------------

# Si no tienes instalado tidyverse, ejecuta esta línea una sola vez:
# install.packages("tidyverse")

# Cargamos tidyverse.
# tidyverse incluye varios paquetes que usaremos en esta práctica:
# - readr: para leer archivos .csv con read_csv()
# - dplyr: para revisar, agrupar y resumir datos
# - ggplot2: para construir gráficas por capas
library(tidyverse)

# Crear la carpeta results si no existe.
# En esta carpeta guardaremos las figuras exportadas.
if (!dir.exists("results")) {
  dir.create("results")
}


# ------------------------------------------------------------
# 1. Crear un data frame pequeño
# ------------------------------------------------------------
# Un data frame organiza información en filas y columnas.
# En este ejemplo:
# - cada fila representa un gen;
# - la columna gen contiene el nombre del gen;
# - la columna expresion contiene un valor numérico de expresión.
#
# Usamos un nombre descriptivo:
# datos_genes_manual = datos de genes creados manualmente.

datos_genes_manual <- data.frame(
  gen = c("ARF", "CO", "PIN", "IAA"),
  expresion = c(2, 10, 10, 15)
)

dim(datos_genes_manual)

# Mostrar el data frame en la consola.
datos_genes_manual


# ------------------------------------------------------------
# 2. Primer gráfico con R base: plot()
# ------------------------------------------------------------
# plot() es una función gráfica de R base.
# Si le damos un vector numérico, dibuja los valores en el orden
# en que aparecen.

plot(datos_genes_manual$expresion)

# Agregamos título y etiquetas de los ejes.
#
# main: título principal
# xlab: etiqueta del eje x
# ylab: etiqueta del eje y

plot(
  datos_genes_manual$expresion,
  main = "Etapa 1",
  xlab = "Gen",
  ylab = "Expresión"
)

# Pregunta:
# ¿Este gráfico permite identificar fácilmente qué valor pertenece
# a cada gen?
#
# Aunque el gráfico muestra los valores, no vemos los nombres de
# los genes directamente en el eje x. Por eso, para este ejemplo,
# una gráfica de barras puede ser más clara.


# ------------------------------------------------------------
# 3. Gráfico de barras con R base: barplot()
# ------------------------------------------------------------
# barplot() sirve para construir gráficas de barras.
# Es útil cuando ya tenemos valores numéricos asociados a categorías.
#
# En este ejemplo:
# - las categorías son los genes;
# - la altura de las barras representa la expresión.

barplot(
  datos_genes_manual$expresion,
  names.arg = datos_genes_manual$gen,
  main = "Etapa 1",
  xlab = "Gen",
  ylab = "Expresión",
  ylim = c(0, max(datos_genes_manual$expresion) + 2)
)

# Agregamos color y borde.
#
# col: color de relleno de las barras
# border: color del borde
# ylim: límites del eje y
# max(datos_genes_manual$expresion) + 2 deja espacio arriba
# para que las barras no queden pegadas al borde del gráfico.

barplot(
  datos_genes_manual$expresion,
  names.arg = datos_genes_manual$gen,
  main = "Etapa 1",
  xlab = "Gen",
  ylab = "Expresión",
  col = "red",
  border = "yellow",
  ylim = c(0, max(datos_genes_manual$expresion) + 2)
)


# ------------------------------------------------------------
# 4. Leer datos desde un archivo .csv
# ------------------------------------------------------------
# En scripts anteriores usamos read.csv(), que pertenece a R base.
#
# En esta unidad usaremos read_csv(), del paquete readr, que forma
# parte de tidyverse.
#
# Diferencia general:
# - read.csv() viene con R base y devuelve un data.frame.
# - read_csv() viene de readr/tidyverse y devuelve un tibble.
#
# Un tibble se comporta como una tabla, pero se imprime de forma
# más limpia en consola y se integra bien con dplyr y ggplot2.
#
# show_col_types = FALSE evita que read_csv() imprima el mensaje
# sobre los tipos de columnas detectados. Si quieres verlo, puedes
# quitar ese argumento.

datos_genes_archivo <- read_csv(
  "data/U3_1.csv",
  show_col_types = FALSE
)

# Mostrar el objeto.
datos_genes_archivo

# glimpse() permite revisar rápidamente la estructura de una tabla.
# Es parecido a str(), pero con una salida más ordenada.
#
# Nos muestra:
# - número de filas;
# - número de columnas;
# - nombres de columnas;
# - tipo de dato de cada columna;
# - algunos valores de ejemplo.
glimpse(datos_genes_archivo)


# ------------------------------------------------------------
# 5. Gráfico de barras con datos importados
# ------------------------------------------------------------
# En el archivo U3_1.csv:
# - Gen es una variable categórica;
# - ED es una variable numérica.
#
# Para R base, accedemos a las columnas usando $:
# datos_genes_archivo$ED
# datos_genes_archivo$Gen

barplot(
  datos_genes_archivo$ED,
  names.arg = datos_genes_archivo$Gen,
  main = "Etapa 2",
  xlab = "Gen",
  ylab = "Expresión",
  col = "purple",
  border = "black",
  ylim = c(0, max(datos_genes_archivo$ED) + 2)
)

# Preguntas:
# ¿Qué gen tiene mayor expresión?
# ¿Qué gen tiene menor expresión?
# ¿Qué representa la altura de cada barra?


# ------------------------------------------------------------
# 6. Leer la base principal de expresión
# ------------------------------------------------------------
# Este archivo contiene varias variables numéricas y una variable
# categórica llamada Etapas.
#
# Usamos un nombre descriptivo:
# datos_expresion = tabla principal con datos de expresión.

datos_expresion <- read_csv(
  "data/U3_2.csv",
  show_col_types = FALSE
)

# head() muestra las primeras filas de la tabla.
# Sirve para revisar rápidamente cómo se ven los datos.
head(datos_expresion)

# glimpse() sirve para revisar rápidamente la estructura de una tabla,
# parecido a str(), pero con una salida más limpia.
glimpse(datos_expresion)

# summary() muestra un resumen general:
# - mínimos y máximos en variables numéricas;
# - cuartiles;
# - conteos o resumen en variables categóricas.
summary(datos_expresion)

# names() muestra los nombres exactos de las columnas.
# Esto es útil antes de escribir código con ggplot2, porque R distingue
# mayúsculas, minúsculas y plural/singular.
names(datos_expresion)

# table() cuenta cuántas observaciones hay por categoría.
# Aquí revisamos cuántas observaciones hay en cada etapa.
table(datos_expresion$Etapas)


# ------------------------------------------------------------
# 7. Histograma con R base
# ------------------------------------------------------------
# Un histograma permite explorar la distribución de una variable numérica.
#
# En este caso usamos ARF:
# - eje x: valores de ARF;
# - eje y: frecuencia, es decir, cuántas observaciones caen
#   en cada intervalo.

hist(
  datos_expresion$ARF,
  main = "Histograma de expresión de ARF",
  xlab = "Expresión de ARF",
  ylab = "Frecuencia",
  col = "yellow"
)

# Preguntas:
# ¿Dónde se concentran la mayoría de los valores?
# ¿Hay valores extremos?
# ¿La distribución parece simétrica?


# ------------------------------------------------------------
# 8. Boxplot con R base
# ------------------------------------------------------------
# Un boxplot resume la distribución de una variable numérica.
#
# Primero usaremos un vector pequeño para observar la forma general
# del diagrama de caja y bigote.

tar_ejemplo <- c(
  8, 5, 14, -9, 19, 12, 3, 9, 7, 4,
  4, 6, 8, 12, -8, 2, 0, -1, 5, 3
)

boxplot(
  tar_ejemplo,
  horizontal = TRUE,
  main = "Boxplot de TAR",
  xlab = "Expresión"
)

# Ahora construiremos un boxplot por grupos usando una fórmula:
#
# variable_numérica ~ variable_categórica
#
# Esto significa:
# graficar TAR agrupado por Etapas.

boxplot(datos_expresion$TAR ~ datos_expresion$Etapas)

boxplot(
  datos_expresion$TAR ~ datos_expresion$Etapas,
  main = "Expresión de TAR por etapa",
  xlab = "Etapa",
  ylab = "Expresión de TAR",
  col = c("red", "#1F5FAF", "#606D96")
)

# Preguntas:
# ¿Qué etapa parece tener valores más altos?
# ¿Qué etapa parece tener mayor variabilidad?
# ¿El boxplot muestra todos los datos individuales?


# ------------------------------------------------------------
# 9. Introducción a ggplot2
# ------------------------------------------------------------
# ggplot2 construye gráficas por capas.
#
# La estructura mínima es:
#
# ggplot(data = datos, aes(x = variable_x, y = variable_y)) +
#   geom_tipo()
#
# data: tabla que contiene los datos.
# aes(): estética; indica qué variables se asignan a ejes,
#        colores, rellenos, formas, etc.
# geom_*(): geometría; indica qué tipo de gráfico se dibuja.


# ------------------------------------------------------------
# 10. Barras con ggplot2
# ------------------------------------------------------------
# Usamos geom_col() cuando la altura de la barra ya está en
# una columna numérica.
#
# En este caso:
# - eje x: Gen;
# - eje y: ED;
# - cada barra representa el valor de expresión de un gen.

ggplot(datos_genes_archivo, aes(x = Gen, y = ED)) +
  geom_col()


# Agregamos color fijo y un tema.
#
# fill = "purple3" dentro de geom_col() aplica el mismo color
# a todas las barras.
# theme_classic() cambia el estilo visual de la gráfica.

ggplot(datos_genes_archivo, aes(x = Gen, y = ED)) +
  geom_col(fill = "purple3", alpha = 0.4) +
  theme_minimal()

# Colores manuales.
#
# Aquí creamos un vector de colores y después lo usamos con
# scale_fill_manual().
#
# fill = Gen dentro de aes() significa:
# usar la variable Gen para asignar colores de relleno.

colores_genes <- c("#1699B5", "#1F5FAF", "#E8B84A", "#7B63C9")

ggplot(datos_genes_archivo, aes(x = Gen, y = ED, fill = Gen)) +
  geom_col(alpha = 0.7, width = 0.5) +
  scale_fill_manual(values = colores_genes) +
  theme_classic()

# Barras horizontales.
#
# Cambiamos la asignación de variables:
# - eje x: ED;
# - eje y: Gen.
#
# Esto puede ser útil cuando las etiquetas de las categorías son largas.

ggplot(datos_genes_archivo, aes(x = ED, y = Gen, fill = Gen)) +
  geom_col(alpha = 0.7, width = 0.4) +
  scale_fill_manual(values = colores_genes) +
  theme_classic()


# ------------------------------------------------------------
# 11. Histograma con ggplot2
# ------------------------------------------------------------
# geom_histogram() permite construir histogramas.
#
# En este caso:
# - eje x: TAR;
# - eje y: frecuencia calculada automáticamente por ggplot2.

ggplot(datos_expresion, aes(x = TAR)) +
  geom_histogram(fill = "#1699B5", bins = 20, alpha = 0.7) +
  labs(
    x = "TAR",
    y = "Frecuencia"
  ) +
  theme_minimal()

# Histograma con relleno por etapa.
#
# fill = Etapas dentro de aes() indica que las barras se colorean
# según la etapa.

ggplot(datos_expresion, aes(x = TAR, fill = Etapas)) +
  geom_histogram(bins = 20, alpha = 0.7) +
  labs(
    x = "TAR",
    y = "Frecuencia",
    fill = "Etapa"
  ) +
  theme_minimal()

# Pregunta:
# ¿El uso de color facilita la comparación o hace que la gráfica
# se vea demasiado encimada?


# ------------------------------------------------------------
# 12. Facetas
# ------------------------------------------------------------
# Las facetas separan una misma gráfica en paneles.
#
# facet_wrap(~ Etapas) significa:
# construir un panel por cada valor de la variable Etapas.

ggplot(datos_expresion, aes(x = TAR, fill = Etapas)) +
  geom_histogram(bins = 15, alpha = 0.7) +
  facet_wrap(~ Etapas) +
  scale_fill_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "TAR",
    y = "Frecuencia",
    fill = "Etapa"
  ) +
  theme_light()

# Preguntas:
# ¿Qué cambia entre los paneles?
# ¿La separación por facetas facilita la interpretación?


# ------------------------------------------------------------
# 13. Boxplot con ggplot2
# ------------------------------------------------------------
# geom_boxplot() construye diagramas de caja y bigote.
#
# En este caso:
# - eje x: Etapas;
# - eje y: TAR;
# - fill: Etapas.

ggplot(datos_expresion, aes(x = Etapas, y = TAR, fill = Etapas)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_minimal()


# ------------------------------------------------------------
# 14. Boxplot + puntos individuales
# ------------------------------------------------------------
# Esta combinación permite ver:
# - el resumen de la distribución con boxplot;
# - los datos individuales con puntos.
#
# outlier.shape = NA evita dibujar dos veces los valores extremos,
# porque geom_jitter() ya mostrará los puntos individuales.
#
# width en geom_jitter() controla cuánto se dispersan horizontalmente
# los puntos para evitar que se encimen demasiado.

ggplot(datos_expresion, aes(x = Etapas, y = TAR, fill = Etapas)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.6, alpha = 0.9) +
  scale_fill_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_minimal()


# ------------------------------------------------------------
# 15. Relación entre variables: dispersión
# ------------------------------------------------------------
# Una gráfica de dispersión permite explorar la relación entre
# dos variables numéricas.
#
# En este caso:
# - eje x: CO;
# - eje y: GA;
# - color: Etapas.
#
# color = Etapas está dentro de aes(), porque el color depende
# de una variable de la tabla.

ggplot(datos_expresion, aes(x = CO, y = GA)) +
  geom_point(aes(color = Etapas), alpha = 0.8, size=7) +
  scale_color_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_classic()

# Preguntas:
# ¿Parece haber relación entre CO y GA?
# ¿Las etapas se mezclan o se separan?
# ¿Hay puntos alejados del resto?


# ------------------------------------------------------------
# 16. Línea de tendencia
# ------------------------------------------------------------
# geom_smooth(method = "lm") agrega una línea de tendencia basada
# en un modelo lineal.
#
# En esta unidad usamos la línea como apoyo visual.
# La interpretación estadística formal se retomará en la Unidad 4.

ggplot(datos_expresion, aes(x = CO, y = GA)) +
  geom_point(aes(color = Etapas), alpha = 0.8, size=7) +
  geom_smooth(method = "lm") +
  scale_color_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_classic()

# Separar por etapas con facetas.
#
# En esta versión se ajusta una tendencia visual dentro de cada
# panel. La interpretación debe hacerse con cuidado.

ggplot(datos_expresion, aes(x = CO, y = GA)) +
  geom_point(aes(color = Etapas), alpha = 0.8) +
  geom_smooth(method = "lm") +
  facet_wrap(~ Etapas) +
  scale_color_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_bw()


# ------------------------------------------------------------
# 17. Resumir antes de graficar
# ------------------------------------------------------------
# Algunas figuras usan datos crudos. Otras requieren resumir datos
# antes de graficar.
#
# Aquí calculamos:
# - promedio de TAR por etapa;
# - desviación estándar de TAR por etapa;
# - número de observaciones por etapa.
#
# group_by(Etapas): agrupa los datos por etapa.
# summarise(): calcula un resumen por cada grupo.
# na.rm = TRUE: ignora valores faltantes si los hubiera.
# .groups = "drop": elimina la agrupación al terminar.

resumen_tar_etapas <- datos_expresion %>%
  group_by(Etapas) %>%
  summarise(
    expresion_promedio = mean(TAR, na.rm = TRUE),
    desviacion_estandar = sd(TAR, na.rm = TRUE),
    n_observaciones = n(),
    .groups = "drop"
  )

resumen_tar_etapas


# ------------------------------------------------------------
# 18. Barras con desviación estándar
# ------------------------------------------------------------
# Esta gráfica usa datos resumidos, no datos crudos.
#
# geom_col(): dibuja las barras usando expresion_promedio.
# geom_errorbar(): agrega barras de error.
#
# ymin y ymax indican desde dónde hasta dónde va cada barra de error.

ggplot(
  resumen_tar_etapas,
  aes(x = Etapas, y = expresion_promedio, fill = Etapas)
) +
  geom_col(alpha = 0.7, width = 0.5) +
  geom_errorbar(
    aes(
      ymin = expresion_promedio - desviacion_estandar,
      ymax = expresion_promedio + desviacion_estandar
    ),
    width = 0.1,
    color = "black",
    linewidth = 0.5
  ) +
  scale_fill_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    x = "Etapa",
    y = "Expresión promedio de TAR",
    fill = "Etapa"
  ) +
  theme_classic()

# Nota:
# Las barras de error muestran variabilidad, pero no sustituyen
# un análisis estadístico.


# ------------------------------------------------------------
# 19. Figura final reproducible
# ------------------------------------------------------------
# En este bloque construiremos una figura más cercana a una figura
# de reporte o artículo.
#
# La idea es:
# 1. definir un tema visual;
# 2. guardar la gráfica como objeto;
# 3. exportarla con ggsave().
#
# Guardar una figura como objeto permite:
# - imprimirla de nuevo;
# - modificarla después;
# - exportarla en distintos formatos.

tema_articulo <- theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )

figura_final <- ggplot(
  datos_expresion,
  aes(x = Etapas, y = GA, fill = Etapas)
) +
  geom_boxplot(
    alpha = 0.7,
    width = 0.55,
    outlier.shape = NA
  ) +
  geom_jitter(
    width = 0.12,
    alpha = 0.45,
    size = 1.8
  ) +
  scale_fill_manual(values = c("#1699B5", "#1F5FAF", "#E8B84A")) +
  labs(
    title = "Expresión de GA por etapa",
    subtitle = "Distribución de valores individuales por grupo",
    x = "Etapa",
    y = "Expresión relativa de GA",
    fill = "Etapa"
  ) +
  tema_articulo

figura_final


# ------------------------------------------------------------
# 20. Exportar figura con ggsave()
# ------------------------------------------------------------
# ggsave() guarda la figura en un archivo.
#
# filename: ruta y nombre del archivo de salida.
# plot: objeto de la figura que queremos guardar.
# width y height: tamaño de la figura.
# units: unidades del tamaño, por ejemplo "in", "cm" o "mm".
# dpi: resolución. 300 dpi es común para impresión.

ggsave(
  filename = "results/figura_final_GA.tiff",
  plot = figura_final
)

# También podemos exportar en PDF.
# El PDF es un formato vectorial útil para edición posterior o
# para figuras que deben conservar buena calidad al escalarse.

ggsave(
  filename = "results/figura_final_TAR_etapas.pdf",
  plot = figura_final,
  width = 7,
  height = 5,
  units = "in"
)


# ------------------------------------------------------------
# 21. Verificación final
# ------------------------------------------------------------
# Después de ejecutar el script, revisa:
#
# 1. ¿Se creó la carpeta results?
# 2. ¿Se guardaron los archivos .png y .pdf?
# 3. ¿La figura final responde una pregunta clara?
# 4. ¿Los nombres de variables son descriptivos?
# 5. ¿El script puede ejecutarse de nuevo desde el inicio?

list.files("results")

# Fin de la práctica general.

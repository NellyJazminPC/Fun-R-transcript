# ============================================================
# Fundamentos de programación en R para análisis transcriptómicos
# Unidad 3. Actividad final
# Guía contestada: de una pregunta a una figura con apoyo de IA
# 17 de junio de 2026 - NJ PC
# ============================================================
#
# IMPORTANTE:
# Este script está pensado como una guía contestada.
# Sugerencia: NO liberarlo al inicio de la actividad.
#
# Puede compartirse después de que los participantes hayan explorado:
# - qué pregunta quieren responder;
# - qué variables necesitan;
# - qué tipo de datos tienen;
# - qué gráfica conviene usar;
# - cómo verificar el código en R.
#
# Objetivo:
# Seleccionar variables de una base amplia, identificar tipos de datos,
# elegir una gráfica adecuada y verificar el resultado en R.
#
# Ruta general de la actividad:
#
# Base de datos
# ↓
# Pregunta
# ↓
# Variables necesarias
# ↓
# Tipo de datos
# ↓
# Gráfica adecuada
# ↓
# Código
# ↓
# Verificación en R
# ↓
# Exportación
#
# Convención de nombres:
# Usaremos nombres descriptivos y snake_case para los objetos creados
# durante el script.
#
# Ejemplos:
# datos_actividad
# datos_caso_1_distribucion
# figura_caso_2_boxplot
# figura_caso_3_facetas
#
# ============================================================


# ------------------------------------------------------------
# 0. Preparar ambiente
# ------------------------------------------------------------

# Si no tienes instalado tidyverse, ejecuta esta línea una sola vez:
# install.packages("tidyverse")

# Cargamos tidyverse.
# tidyverse incluye varios paquetes útiles:
# - readr: para leer archivos .csv con read_csv()
# - dplyr: para seleccionar, filtrar y resumir datos
# - ggplot2: para construir gráficas
# - tibble: para trabajar con tablas ordenadas
library(tidyverse)

# Crear la carpeta results si no existe.
# Aquí se guardarán las figuras exportadas.
if (!dir.exists("results")) {
  dir.create("results")
}


# ------------------------------------------------------------
# 1. Definir paleta de colores de la Unidad 3
# ------------------------------------------------------------
# Usaremos una paleta corta para mantener consistencia visual
# con los materiales de la unidad.
#
# Azul turquesa: #1699B5
# Azul medio:    #1F5FAF
# Dorado suave:  #E8B84A
#
# Esta paleta se usará para etapas, tratamientos o grupos.

paleta_u3 <- c("#1699B5", "#1F5FAF", "#E8B84A")

paleta_u3_2_grupos <- c("#1699B5", "#E8B84A")


# ------------------------------------------------------------
# 2. Cargar la base de actividad
# ------------------------------------------------------------
# Esta actividad usa una sola base amplia:
#
# data/U3_actividad.csv
#
# La base contiene más observaciones que U3_2.csv para que las gráficas
# de dispersión tengan más puntos y permitan observar mejor patrones.
#
# En scripts anteriores del curso se usó read.csv(), que pertenece a R base.
# En esta unidad usamos read_csv(), de readr/tidyverse.
#
# Diferencia general:
# - read.csv() devuelve un data.frame clásico.
# - read_csv() devuelve un tibble, que se imprime de forma más limpia
#   y se integra bien con dplyr y ggplot2.
#
# show_col_types = FALSE evita el mensaje automático donde read_csv()
# informa qué tipo de dato detectó en cada columna.

if (!file.exists("data/U3_actividad.csv")) {
  stop(
    "No se encontró el archivo data/U3_actividad.csv. ",
    "Verifica que esté dentro de la carpeta data/ del proyecto."
  )
}

datos_actividad <- read_csv(
  "data/U3_actividad.csv",
  show_col_types = FALSE
)


# ------------------------------------------------------------
# 3. Revisar la base antes de graficar
# ------------------------------------------------------------
# Antes de hacer cualquier gráfica, revisamos la estructura de la tabla.

# head() muestra las primeras filas.
head(datos_actividad)

# glimpse() muestra:
# - número de filas;
# - número de columnas;
# - nombres de variables;
# - tipo de dato de cada variable;
# - algunos valores de ejemplo.
glimpse(datos_actividad)

# names() muestra los nombres exactos de las columnas.
# Esto es importante porque R distingue mayúsculas, minúsculas,
# singular y plural.
names(datos_actividad)

# summary() genera un resumen general de cada columna.
summary(datos_actividad)

# Contar cuántas observaciones hay por etapa.
table(datos_actividad$Etapa)

# Contar cuántas observaciones hay por tratamiento.
table(datos_actividad$Tratamiento)

# Contar cuántas observaciones hay por sitio.
table(datos_actividad$Sitio)

# Otra forma de contar con dplyr:
datos_actividad %>%
  count(Etapa, Tratamiento, Sitio)


# ============================================================
# CASO 1. Distribución de una variable
# ============================================================

# ------------------------------------------------------------
# 4. Pregunta del caso 1
# ------------------------------------------------------------
# Pregunta:
# ¿Cómo se distribuye la expresión de TAR?
#
# Para responder esta pregunta necesitamos una variable numérica.
# En este caso usaremos TAR.
#
# Gráfica adecuada:
# Histograma, porque queremos observar la distribución de una
# variable numérica.


# ------------------------------------------------------------
# 5. Seleccionar variables necesarias
# ------------------------------------------------------------
# Conservamos:
# - Muestra: identificador de cada observación;
# - TAR: variable numérica que queremos graficar.
#
# select() responde a la pregunta:
# ¿qué columnas necesito para esta pregunta?

datos_caso_1_distribucion <- datos_actividad %>%
  select(Muestra, TAR)

# Revisar la estructura del objeto creado.
glimpse(datos_caso_1_distribucion)

# Revisar resumen de TAR.
summary(datos_caso_1_distribucion$TAR)


# ------------------------------------------------------------
# 6. Figura del caso 1: histograma
# ------------------------------------------------------------
# En esta figura:
# - eje x: valores de TAR;
# - eje y: frecuencia calculada automáticamente por ggplot2.
#
# bins controla cuántos intervalos tendrá el histograma.
# Con más datos podemos usar un número mayor de bins.

figura_caso_1_histograma <- ggplot(
  datos_caso_1_distribucion,
  aes(x = TAR)
) +
  geom_histogram(
    bins = 30,
    fill = "#1699B5",
    alpha = 0.75,
    color = "white"
  ) +
  labs(
    title = "Distribución de la expresión de TAR",
    subtitle = "Histograma de una variable numérica",
    x = "Expresión de TAR",
    y = "Frecuencia"
  ) +
  theme_minimal()

figura_caso_1_histograma

# Exportar figura.
ggsave(
  filename = "results/actividad_caso_1_distribucion_TAR.png",
  plot = figura_caso_1_histograma,
  width = 7,
  height = 5,
  units = "in",
  dpi = 300
)

# Verificación del caso 1:
# ¿La variable TAR existe?
# ¿TAR es numérica?
# ¿El eje x representa TAR?
# ¿El eje y representa frecuencia?
# ¿El histograma permite observar dónde se concentran los valores?


# ============================================================
# CASO 2. Comparación entre grupos
# ============================================================

# ------------------------------------------------------------
# 7. Pregunta del caso 2
# ------------------------------------------------------------
# Pregunta:
# ¿La expresión de TAR cambia entre etapas?
#
# Para responder esta pregunta necesitamos:
# - una variable numérica: TAR;
# - una variable categórica: Etapa.
#
# Gráfica adecuada:
# Boxplot + puntos individuales.
#
# El boxplot resume la distribución de TAR por etapa.
# Los puntos individuales muestran las observaciones reales.


# ------------------------------------------------------------
# 8. Seleccionar variables necesarias
# ------------------------------------------------------------

datos_caso_2_comparacion <- datos_actividad %>%
  select(Muestra, Etapa, TAR)

# Revisar estructura.
glimpse(datos_caso_2_comparacion)

# Revisar cuántas observaciones hay por etapa.
table(datos_caso_2_comparacion$Etapa)

# Revisar resumen de TAR.
summary(datos_caso_2_comparacion$TAR)


# ------------------------------------------------------------
# 9. Figura del caso 2: boxplot + puntos
# ------------------------------------------------------------
# En esta figura:
# - eje x: Etapa;
# - eje y: TAR;
# - fill: Etapa.
#
# outlier.shape = NA evita que los valores extremos se dibujen dos
# veces, porque geom_jitter() ya mostrará todos los puntos.

figura_caso_2_boxplot <- ggplot(
  datos_caso_2_comparacion,
  aes(x = Etapa, y = TAR, fill = Etapa)
) +
  geom_boxplot(
    alpha = 0.75,
    width = 0.55,
    outlier.shape = NA
  ) +
  geom_jitter(
    width = 0.15,
    alpha = 0.35,
    size = 1.4
  ) +
  scale_fill_manual(values = paleta_u3) +
  labs(
    title = "Expresión de TAR por etapa",
    subtitle = "Boxplot con puntos individuales",
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_minimal()

figura_caso_2_boxplot

ggsave(
  filename = "results/actividad_caso_2_TAR_por_etapa.png",
  plot = figura_caso_2_boxplot,
  width = 7,
  height = 5,
  units = "in",
  dpi = 300
)

# Verificación del caso 2:
# ¿La variable Etapa existe?
# ¿La variable TAR existe?
# ¿Etapa es categórica?
# ¿TAR es numérica?
# ¿Cada punto representa una observación?
# ¿El boxplot resume la distribución por etapa?
#
# Importante:
# Esta gráfica puede sugerir diferencias visuales, pero no prueba
# diferencias estadísticas por sí sola.


# ============================================================
# CASO 3. Relación entre dos variables numéricas
# ============================================================

# ------------------------------------------------------------
# 10. Pregunta del caso 3
# ------------------------------------------------------------
# Pregunta:
# ¿Existe relación visual entre CO y GA?
#
# Para responder esta pregunta necesitamos:
# - dos variables numéricas: CO y GA.
#
# Además conservaremos Etapa para usarla como color.
#
# Gráfica adecuada:
# Gráfica de dispersión.


# ------------------------------------------------------------
# 11. Seleccionar variables necesarias
# ------------------------------------------------------------

datos_caso_3_relacion <- datos_actividad %>%
  select(Muestra, Etapa, CO, GA)

glimpse(datos_caso_3_relacion)

# Revisar que CO y GA sean numéricas.
summary(datos_caso_3_relacion$CO)
summary(datos_caso_3_relacion$GA)

# Revisar grupos.
table(datos_caso_3_relacion$Etapa)


# ------------------------------------------------------------
# 12. Figura del caso 3: dispersión
# ------------------------------------------------------------
# En esta figura:
# - eje x: CO;
# - eje y: GA;
# - color: Etapa.
#
# Como hay muchos puntos, usamos alpha menor a 1 para que la
# sobreposición sea más visible.

figura_caso_3_dispersion <- ggplot(
  datos_caso_3_relacion,
  aes(x = CO, y = GA, color = Etapa)
) +
  geom_point(
    alpha = 0.55,
    size = 1.6
  ) +
  scale_color_manual(values = paleta_u3) +
  labs(
    title = "Relación visual entre CO y GA",
    subtitle = "Gráfica de dispersión con color por etapa",
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_classic()

figura_caso_3_dispersion

ggsave(
  filename = "results/actividad_caso_3_CO_GA_dispersion.png",
  plot = figura_caso_3_dispersion,
  width = 7,
  height = 5,
  units = "in",
  dpi = 300
)

# Verificación del caso 3:
# ¿CO y GA existen?
# ¿CO y GA son numéricas?
# ¿La gráfica usa CO en x y GA en y?
# ¿El color ayuda a distinguir etapas?
# ¿Hay una relación visual positiva, negativa o poco clara?


# ------------------------------------------------------------
# 13. Variante del caso 3: dispersión con facetas
# ------------------------------------------------------------
# Cuando hay muchos puntos o varios grupos, las facetas pueden ayudar.
#
# facet_wrap(~ Etapa) crea un panel por cada etapa.
# Esto permite comparar la relación CO-GA dentro de cada grupo.

figura_caso_3_facetas <- ggplot(
  datos_caso_3_relacion,
  aes(x = CO, y = GA, color = Etapa)
) +
  geom_point(
    alpha = 0.55,
    size = 1.6
  ) +
  facet_wrap(~ Etapa) +
  scale_color_manual(values = paleta_u3) +
  labs(
    title = "Relación entre CO y GA por etapa",
    subtitle = "La misma relación separada en facetas",
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_bw()

figura_caso_3_facetas

ggsave(
  filename = "results/actividad_caso_3_CO_GA_facetas.png",
  plot = figura_caso_3_facetas,
  width = 8,
  height = 5,
  units = "in",
  dpi = 300
)

# Preguntas:
# ¿Las facetas facilitan la comparación?
# ¿La relación entre CO y GA parece similar en todas las etapas?
# ¿Qué se gana y qué se pierde al separar los datos en paneles?


# ============================================================
# CASO EXTRA. Comparación con dos variables categóricas
# ============================================================

# ------------------------------------------------------------
# 14. Pregunta del caso extra
# ------------------------------------------------------------
# Pregunta:
# ¿Cómo se distribuye TAR por etapa y tratamiento?
#
# Para responder esta pregunta necesitamos:
# - una variable numérica: TAR;
# - dos variables categóricas: Etapa y Tratamiento.
#
# Gráfica adecuada:
# Boxplot por etapa, separado en facetas por tratamiento.


# ------------------------------------------------------------
# 15. Seleccionar variables necesarias
# ------------------------------------------------------------

datos_caso_extra_tratamiento <- datos_actividad %>%
  select(Muestra, Etapa, Tratamiento, TAR)

glimpse(datos_caso_extra_tratamiento)

table(datos_caso_extra_tratamiento$Etapa)
table(datos_caso_extra_tratamiento$Tratamiento)


# ------------------------------------------------------------
# 16. Figura del caso extra
# ------------------------------------------------------------
# En esta figura:
# - eje x: Etapa;
# - eje y: TAR;
# - fill: Etapa;
# - facetas: Tratamiento.
#
# Esta gráfica permite comparar etapas dentro de cada tratamiento.

figura_caso_extra_tratamiento <- ggplot(
  datos_caso_extra_tratamiento,
  aes(x = Etapa, y = TAR, fill = Etapa)
) +
  geom_boxplot(
    alpha = 0.75,
    width = 0.55,
    outlier.shape = NA
  ) +
  geom_jitter(
    width = 0.12,
    alpha = 0.25,
    size = 1.2
  ) +
  facet_wrap(~ Tratamiento) +
  scale_fill_manual(values = paleta_u3) +
  labs(
    title = "Expresión de TAR por etapa y tratamiento",
    subtitle = "Ejemplo de comparación con facetas",
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_classic()

figura_caso_extra_tratamiento

ggsave(
  filename = "results/actividad_caso_extra_TAR_etapa_tratamiento.png",
  plot = figura_caso_extra_tratamiento,
  width = 8,
  height = 5,
  units = "in",
  dpi = 300
)

# Preguntas:
# ¿El patrón por etapa se mantiene en ambos tratamientos?
# ¿Las facetas ayudan a evitar una figura demasiado cargada?
# ¿Qué otra variable podría usarse para separar paneles?


# ============================================================
# Mini prompt de IA
# ============================================================
#
# Este prompt puede usarse después de que el participante ya eligió:
# - pregunta;
# - variables;
# - tipo de datos;
# - gráfica adecuada.
#
# La idea no es subir la base completa, sino describir su estructura.
#
# Copiar y adaptar:
#
# Estoy aprendiendo a hacer gráficas en R con ggplot2.
#
# No voy a subir mi base de datos, pero te describo su estructura:
#
# - Mi base se llama: datos_actividad
# - Cada fila representa una muestra.
# - Variables numéricas: TAR, ARF, CO, GA
# - Variables categóricas: Etapa, Tratamiento, Sitio
# - La pregunta que quiero responder es: ¿la expresión de TAR cambia entre etapas?
# - Elegí hacer un boxplot con puntos individuales.
# - Quiero usar:
#   - eje x: Etapa
#   - eje y: TAR
#   - fill: Etapa
#   - facetas: no
#
# Ayúdame a escribir un código base en ggplot2 para construir esa figura.
#
# Condiciones:
# 1. No inventes nombres de columnas distintos a los que te di.
# 2. Incluye comentarios breves en el código.
# 3. Guarda la figura como objeto.
# 4. Incluye ggsave() con width, height, units y dpi = 300.
# 5. Al final dime qué debo verificar en mis datos antes de interpretar la figura.
#
# No inventes conclusiones biológicas.


# ============================================================
# Verificación general de respuestas de IA
# ============================================================
# Antes de confiar en el código propuesto por IA, verifica en R:

names(datos_actividad)
glimpse(datos_actividad)
summary(datos_actividad)

# Si el código usa una variable categórica:
table(datos_actividad$Etapa)

# Si el código usa una variable numérica:
summary(datos_actividad$TAR)

# Preguntas de cierre:
# ¿Qué pregunta elegiste?
# ¿Qué variables necesitaste?
# ¿Qué tipo de datos eran?
# ¿Qué gráfica elegiste y por qué?
# ¿El código generado por IA fue correcto?
# ¿Qué tuviste que corregir o verificar?
# ¿La interpretación se limita a lo que muestra la figura?


# ------------------------------------------------------------
# 17. Verificación final de archivos exportados
# ------------------------------------------------------------
# Revisar qué figuras se guardaron en results/.

list.files("results")


# Fin de la guía contestada.

# Fundamentos de programación en R
# Unidad 6. Reportes reproducibles con Quarto
# Script para ejercicio: del script al reporte reproducible

# Este script corre completo, pero no está explicado línea por línea.
# La actividad consiste en identificar qué hace cada bloque y organizarlo
# dentro de un reporte Quarto (.qmd).


# Paquetes ---------------------------------------------------------------

library(readxl)
library(dplyr)
library(ggplot2)


# Datos ------------------------------------------------------------------

# Importar datos desde Excel.
# Recuerda: este script está pensado para ejecutarse desde la raíz del proyecto.
datos <- read_excel("../data/U6_datos_pca.xlsx")

# Exploración inicial de la tabla.
head(datos)
dim(datos)
names(datos)
str(datos)


# Preparación de datos ---------------------------------------------------

# Separar columnas de metadatos.
metadatos <- datos %>%
  select(muestra, etapa, tratamiento, sitio)

# Seleccionar variables numéricas para el PCA.
genes <- c("TAR", "ARF", "CO", "GA")

datos_pca <- datos %>%
  select(all_of(genes))

# Revisar objetos creados.
head(metadatos)
head(datos_pca)


# PCA --------------------------------------------------------------------

# Ejecutar PCA con variables centradas y escaladas.
pca_resultado <- prcomp(
  datos_pca,
  center = TRUE,
  scale. = TRUE
)

# Revisar estructura general del resultado.
str(pca_resultado)


# Varianza explicada -----------------------------------------------------

# Calcular la varianza explicada por cada componente principal.
varianza <- pca_resultado$sdev^2
varianza_explicada <- varianza / sum(varianza)

tabla_varianza <- data.frame(
  componente = paste0("PC", seq_along(varianza_explicada)),
  varianza_explicada = varianza_explicada,
  porcentaje = varianza_explicada * 100
)

tabla_varianza

# Guardar porcentajes para etiquetas de los ejes.
pc1 <- round(tabla_varianza$porcentaje[1], 1)
pc2 <- round(tabla_varianza$porcentaje[2], 1)


# Coordenadas de muestras ------------------------------------------------

# Extraer coordenadas de las muestras en el espacio del PCA.
pca_scores <- as.data.frame(pca_resultado$x)

# Agregar metadatos a las coordenadas del PCA.
pca_scores <- bind_cols(metadatos, pca_scores)

head(pca_scores)


# Figura -----------------------------------------------------------------

# Construir figura principal del PCA.
pca_etapa <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.8, alpha = 0.45) +
  labs(
    title = "PCA exploratorio coloreado por etapa",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_etapa


# Exportar ---------------------------------------------------------------

# Guardar figura y tablas principales en results/.
ggsave(
  filename = "results/U6_pca_reporte_etapa.png",
  plot = pca_etapa,
  width = 7,
  height = 5,
  dpi = 300
)

write.csv(
  tabla_varianza,
  "results/U6_pca_reporte_varianza_explicada.csv",
  row.names = FALSE
)

write.csv(
  pca_scores,
  "results/U6_pca_reporte_scores.csv",
  row.names = FALSE
)


# Preguntas para trasladar al reporte -----------------------------------

# 1. ¿Qué representa cada fila de la tabla original?
# 2. ¿Qué columnas se usaron como metadatos?
# 3. ¿Qué columnas se usaron para calcular el PCA?
# 4. ¿Qué porcentaje de variación explican PC1 y PC2?
# 5. ¿Qué patrón general se observa al colorear por etapa?
# 6. ¿Qué limitación debe mencionarse al interpretar este PCA?

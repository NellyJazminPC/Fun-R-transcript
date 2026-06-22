###### Unidad 6 ######
#### Sesión 6.1: Análisis de Componentes Principales ####

## Curso: Fundamentos de programación en R para análisis transcriptómicos
## Tema: PCA exploratorio con datos biológicos multivariados
## 22 de junio de 2026 - NJ PC

## Objetivo del script -----------------------------------------------------
## Este script guía una práctica general de PCA usando un archivo de Excel.
## La idea es conectar varios elementos vistos en unidades anteriores:
## - importar datos;
## - revisar una tabla;
## - separar metadatos y variables numéricas;
## - ejecutar un PCA con prcomp();
## - visualizar resultados con ggplot2;
## - interpretar los componentes principales con cautela;
## - guardar figuras y tablas en results/.

## IMPORTANTE --------------------------------------------------------------
## Este script está pensado para ejecutarse desde la raíz del proyecto.
## Es decir, la carpeta del proyecto debe contener al menos:
##
## data/U6_datos_pca.xlsx
## bin/U6_1_PCA_practica_general.R
## results/
##
## Si usas RStudio, abre el proyecto del curso antes de ejecutar el script.


# 1. Cargar paquetes -------------------------------------------------------

## Si alguno de estos paquetes no está instalado, puedes instalarlo con:
## install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))

#library(readxl)   # Para importar archivos de Excel (.xlsx)
#library(dplyr)    # Para seleccionar, revisar y manipular datos
#library(tidyr)    # Para reorganizar datos a formato largo
#library(ggplot2)  # Para construir las figuras del PCA


# 2. Definir rutas de trabajo ---------------------------------------------

## Guardamos la ruta del archivo de datos en un objeto.
## Esto facilita corregir la ruta si el archivo cambia de nombre o ubicación.
# ¿cuál es la ruta para tu archivo U6_datos_pca.xlsx? 
# Recuerda revisar en donde estas - ubicación
ruta_datos <- "aquí_va_la_ruta_al_archivo"


# 3. Importar datos desde Excel -------------------------------------------

## Primero podemos revisar qué hojas contiene el archivo de Excel.
## Esto es útil cuando recibimos archivos con varias pestañas.

excel_sheets(ruta_datos)

## Importamos la primera hoja del archivo.
## En esta práctica el archivo contiene una tabla con metadatos y variables numéricas.

datos <- read_excel(ruta_datos, sheet = 1)

## Revisamos las primeras filas para confirmar que la importación funcionó.

head(datos)


# 4. Explorar la estructura de la tabla -----------------------------------

## Antes de analizar una tabla, siempre conviene revisar su estructura.
## Estas funciones responden preguntas básicas:
## ¿cuántas filas tiene?, ¿cuántas columnas?, ¿cómo se llaman?, ¿qué tipo de datos contienen?

dim(datos)      # Número de filas y columnas
names(datos)    # Nombres de las columnas
str(datos)      # Tipo de dato de cada columna
summary(datos)  # Resumen general

## Revisamos cuántas muestras hay por etapa, tratamiento y sitio.
## Estas columnas son metadatos: no entran al PCA, pero ayudan a interpretar las figuras.

datos %>% count(etapa)
datos %>% count(tratamiento)
datos %>% count(sitio)


# 5. Separar metadatos y variables numéricas ------------------------------

## Para el PCA necesitamos una matriz o data frame con variables numéricas.
## En este archivo, las primeras columnas describen las muestras:
## - muestra
## - etapa
## - tratamiento
## - sitio
##
## Las variables numéricas son genes o variables biológicas simuladas:
## - TAR
## - ARF
## - CO
## - GA

metadatos <- datos %>%
  select(muestra, etapa, tratamiento, sitio) %>%
  mutate(
    etapa = as.factor(etapa),
    tratamiento = as.factor(tratamiento),
    sitio = as.factor(sitio)
  )

## Seleccionamos explícitamente las variables que entrarán al PCA.
## También podríamos usar select(where(is.numeric)), pero aquí lo hacemos
## de forma explícita para que sea claro qué variables se están analizando.

datos_pca <- datos %>%
  select() #Qué variables son las que se seleccionaran? - Los genes

## Revisamos ambos objetos.

head(metadatos)
head(datos_pca)

dim(metadatos)
dim(datos_pca)

## Comprobamos que las variables del PCA sean numéricas.

sapply(datos_pca, is.numeric)

## Revisamos si hay valores faltantes.
## Si alguna columna tuviera NA, habría que decidir cómo manejarlos antes del PCA.

colSums(is.na(datos_pca))


# 6. Ejecutar PCA con prcomp() --------------------------------------------

## prcomp() es una función de R base para hacer PCA.
## Usaremos dos argumentos importantes:
##
## center = TRUE
##   Centra cada variable restando su promedio.
##
## scale. = TRUE
##   Escala cada variable dividiendo entre su desviación estándar.
##
## Escalar es importante cuando las variables tienen unidades o rangos diferentes.
## Así evitamos que una variable domine el PCA solo por tener valores más grandes.

pca_resultado <- prcomp(
  datos_pac,
  center = TRUE,
  scale. = TRUE
)
#TIP - revisa que los nombres de las variables (cajas que creaste) sean correctos

## Exploramos brevemente el objeto que devuelve prcomp().

str(pca_resultado)

## Elementos importantes:
## pca_resultado$x        coordenadas de las muestras en PC1, PC2, PC3...
## pca_resultado$sdev     desviación estándar de cada componente
## pca_resultado$rotation relación entre variables originales y componentes


# 7. Calcular varianza explicada ------------------------------------------

## La varianza explicada indica qué porcentaje de la variación total resume
## cada componente principal.

varianza <- pca_resultado$sdev^2
varianza_explicada <- varianza / sum(varianza)

tabla_varianza <- data.frame(
  componente = paste0("PC", seq_along(varianza_explicada)),
  varianza_explicada = varianza_explicada,
  porcentaje = varianza_explicada * 100
)

tabla_varianza

## Guardamos los porcentajes de PC1, PC2 y PC3 en objetos para usarlos
## en las etiquetas de las figuras.

pc1 <- round(tabla_varianza$porcentaje[1], 1)
pc2 <- round(tabla_varianza$porcentaje[2], 1)
pc3 <- round(tabla_varianza$porcentaje[3], 1)


# 8. Crear un scree plot ---------------------------------------------------

## El scree plot muestra cuánta variación explica cada componente principal.
## Ayuda a decidir si PC1 y PC2 resumen una proporción suficiente de la variación.

scree_plot <- ggplot(tabla_varianza, aes(x = componente, y = porcentaje)) +
  labs(
    title = "Varianza explicada por componente principal",
    x = "Componente principal",
    y = "Varianza explicada (%)"
  ) 

# ¿Qué le falta a este bloque de código? Si queremos una gráfica de barras, qué le faltaría?
# ¿Cómo agregarias un theme de ggplot? 
# ¿Como haces que las barras sean de color azul?

scree_plot


# 9. Extraer coordenadas de muestras --------------------------------------

## Para graficar el PCA con ggplot2 necesitamos una tabla.
## Convertimos pca_resultado$x en data frame y agregamos los metadatos.

pca_scores <- as.data.frame(pca_resultado$x)

pca_scores <- bind_cols(metadatos, pca_scores)

head(pca_scores)

## Ahora pca_scores contiene:
## - muestra, etapa, tratamiento y sitio;
## - coordenadas PC1, PC2, PC3, PC4.


# 10. PCA coloreado por etapa ---------------------------------------------

## Este gráfico muestra PC1 contra PC2.
## Cada punto representa una muestra.
## El color indica la etapa.
##
## Como hay muchas muestras, usamos puntos pequeños y transparencia.
## Esto permite ver zonas de mayor densidad y evita que la nube de puntos
## oculte completamente el patrón general.

pca_etapa <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.6, alpha = 0.40) +
  labs(
    title = "PCA exploratorio coloreado por etapa",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_etapa

#¿Cómo cambiamos el tamaño de los puntos?
# De dónde viene pc1 ?

## Preguntas para interpretar:
## - ¿Las muestras de la misma etapa aparecen cercanas?
## - ¿La separación parece ocurrir sobre PC1, sobre PC2 o sobre ambos?
## - ¿Hay traslape entre etapas?


# 11. PCA con elipses por etapa -------------------------------------------

## Las elipses resumen visualmente la dispersión de cada grupo.
## Son útiles como apoyo visual, pero NO son una prueba estadística.
##
## En este ejemplo, las elipses ayudan a ver que hay un gradiente entre etapas,
## pero también muestran que existe traslape entre los grupos.

pca_etapa_elipses <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.5, alpha = 0.30) +
  stat_ellipse(linewidth = 0.8) +
  labs(
    title = "PCA exploratorio con elipses por etapa",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_etapa_elipses

## Precaución:
## Una elipse no demuestra que los grupos sean diferentes.
## Solo resume visualmente cómo se distribuyen los puntos de cada grupo.


# 12. PCA con centroides por etapa ----------------------------------------

## Cuando hay muchos puntos, puede ser difícil ver el patrón general.
## Una estrategia útil es calcular el centro promedio de cada grupo en el
## espacio del PCA.
##
## Los centroides no reemplazan a los datos completos, solo ayudan a visualizar
## la tendencia general de cada etapa.

centroides_etapa <- pca_scores %>%
  group_by(etapa) %>%
  summarise(
    PC1 = mean(PC1),
    PC2 = mean(PC2),
    n_muestras = n(),
    .groups = "drop"
  )

centroides_etapa

pca_etapa_centroides <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.4, alpha = 0.25) +
  geom_point(
    data = centroides_etapa,
    aes(x = PC1, y = PC2, color = etapa),
    size = 5,
    shape = 18
  ) +
  geom_text(
    data = centroides_etapa,
    aes(x = PC1, y = PC2, label = etapa),
    vjust = -1.1,
    show.legend = FALSE
  ) +
  labs(
    title = "PCA exploratorio con centroides por etapa",
    subtitle = "Los puntos grandes indican la posición promedio de cada etapa",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_etapa_centroides

## Pregunta para interpretar:
## - Aunque hay traslape entre muestras, ¿los centroides sugieren un gradiente
##   entre etapas a lo largo de PC1?


# 13. PCA separado por facetas de etapa -----------------------------------

## Otra forma de reducir la saturación visual es separar el mismo PCA en
## paneles o facetas.
##
## Importante:
## - El PCA es el mismo.
## - No estamos calculando un PCA distinto para cada etapa.
## - Solo estamos mostrando cada etapa en un panel separado.

pca_etapa_facetas <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.5, alpha = 0.45) +
  facet_wrap(~ etapa) +
  labs(
    title = "PCA exploratorio separado por etapa",
    subtitle = "Cada panel muestra el mismo espacio PCA, pero solo una etapa",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

pca_etapa_facetas

## Pregunta para interpretar:
## - ¿En qué zona del PCA se concentra cada etapa?


# 14. PCA con subconjunto para visualización ------------------------------

## Si hay muchos puntos, también podemos mostrar un subconjunto balanceado.
##
## Importante:
## - El PCA NO se recalcula con el subconjunto.
## - El PCA se calculó con todas las muestras.
## - El subconjunto solo se usa para hacer una figura más legible.

set.seed(123)

pca_scores_sub <- pca_scores %>%
  group_by(etapa) %>%
  slice_sample(n = 100) %>%
  ungroup()

pca_etapa_subconjunto <- ggplot(pca_scores_sub, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 2.2, alpha = 0.65) +
  labs(
    title = "PCA exploratorio con subconjunto de muestras",
    subtitle = "Se muestran 100 muestras por etapa para facilitar la visualización",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_etapa_subconjunto


# 15. Comparar el PCA usando otros metadatos ------------------------------

## Una ventaja de separar metadatos y variables numéricas es que podemos
## colorear la misma figura usando distintas variables de interpretación.
## Aquí exploramos si el patrón se relaciona más con etapa, tratamiento o sitio.

pca_tratamiento <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = tratamiento)) +
  geom_point(size = 1.6, alpha = 0.40) +
  labs(
    title = "PCA exploratorio coloreado por tratamiento",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Tratamiento"
  ) +
  theme_minimal()

pca_tratamiento

pca_sitio <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = sitio)) +
  geom_point(size = 1.6, alpha = 0.40) +
  labs(
    title = "PCA exploratorio coloreado por sitio",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Sitio"
  ) +
  theme_minimal()

pca_sitio

## Preguntas para comparar:
## - ¿El patrón visual cambia al colorear por etapa, tratamiento o sitio?
## - ¿Qué metadato parece relacionarse más con la separación observada?
## - ¿Podría haber más de una explicación para el patrón?


# 16. Construir un biplot sencillo con ggplot2 ----------------------------

## Un biplot muestra, en la misma figura:
## - las muestras como puntos;
## - las variables originales como flechas.
##
## Es útil cuando tenemos pocas variables, como en este ejemplo.
## En datos transcriptómicos reales puede haber miles de genes, por lo que
## un biplot con todas las variables no siempre es práctico.

## Extraemos las cargas o loadings de las variables en PC1 y PC2.

pca_loadings <- as.data.frame(pca_resultado$rotation[, 1:2])
pca_loadings$variable <- rownames(pca_loadings)

pca_loadings

## Las coordenadas de las flechas suelen ser pequeñas comparadas con las
## coordenadas de las muestras. Por eso usamos un factor de escala para
## que las flechas sean visibles en la misma figura.

rango_scores_pc1 <- max(pca_scores$PC1) - min(pca_scores$PC1)
rango_scores_pc2 <- max(pca_scores$PC2) - min(pca_scores$PC2)

rango_loadings_pc1 <- max(pca_loadings$PC1) - min(pca_loadings$PC1)
rango_loadings_pc2 <- max(pca_loadings$PC2) - min(pca_loadings$PC2)

factor_escala <- min(
  rango_scores_pc1 / rango_loadings_pc1,
  rango_scores_pc2 / rango_loadings_pc2
) * 0.7

pca_loadings <- pca_loadings %>%
  mutate(
    PC1_esc = PC1 * factor_escala,
    PC2_esc = PC2 * factor_escala
  )

pca_loadings

## Ahora construimos el biplot.

pca_biplot <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = etapa)) +
  geom_point(size = 1.4, alpha = 0.25) +
  geom_segment(
    data = pca_loadings,
    aes(x = 0, y = 0, xend = PC1_esc, yend = PC2_esc),
    inherit.aes = FALSE,
    arrow = arrow(length = grid::unit(0.2, "cm")),
    linewidth = 0.7
  ) +
  geom_text(
    data = pca_loadings,
    aes(x = PC1_esc, y = PC2_esc, label = variable),
    inherit.aes = FALSE,
    vjust = -0.7,
    size = 4
  ) +
  labs(
    title = "Biplot del PCA",
    subtitle = "Puntos = muestras; flechas = variables",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Etapa"
  ) +
  theme_minimal()

pca_biplot

## Interpretación básica del biplot:
## - Las flechas indican hacia dónde aumentan las variables.
## - Flechas en direcciones similares sugieren variables positivamente relacionadas.
## - Flechas en direcciones opuestas sugieren variables negativamente relacionadas.
## - Si una etapa se ubica hacia una flecha, podría estar asociada con valores altos de esa variable.
##
## Precaución:
## El biplot ayuda a explorar, pero no prueba causalidad ni significancia estadística.


# 17. Visualizar genes sobre el espacio PCA -------------------------------

## Hasta ahora coloreamos las muestras usando metadatos, como etapa,
## tratamiento o sitio.
##
## Otra forma útil de explorar el PCA es colorear las mismas muestras según
## el valor de expresión de cada gen.
##
## Importante:
## - Los puntos siguen siendo muestras.
## - Las facetas muestran genes distintos.
## - No estamos haciendo un PCA separado por gen.
## - Estamos observando cómo cambia la expresión de cada gen sobre el espacio
##   definido por PC1 y PC2.

pca_scores_genes <- bind_cols(pca_scores, datos_pca)

pca_genes_largo <- pca_scores_genes %>%
  select(muestra, etapa, tratamiento, sitio, PC1, PC2, TAR, ARF, CO, GA) %>%
  pivot_longer(
    cols = c(TAR, ARF, CO, GA),
    names_to = "gen",
    values_to = "expresion"
  )

## Estandarizamos la expresión dentro de cada gen.
## Esto permite comparar patrones visuales entre genes, aunque sus valores
## originales estén en escalas distintas.
##
## Importante:
## - Estandarizamos por gen, no por etapa.
## - Así podemos ver si un gen tiende a expresarse más hacia alguna zona
##   del PCA y comparar ese patrón entre etapas.
## - Si estandarizáramos por gen y etapa al mismo tiempo, perderíamos parte
##   de la comparación entre etapas.

pca_genes_largo <- pca_genes_largo %>%
  group_by(gen) %>%
  mutate(
    expresion_escalada = as.numeric(scale(expresion))
  ) %>%
  ungroup()

# Expresión de genes sobre el espacio PCA, separada por gen y etapa
pca_genes_facetas <- ggplot(
  pca_genes_largo,
  aes(x = PC1, y = PC2, color = expresion_escalada)
) +
  geom_point(size = 0.9, alpha = 0.55) +
  facet_grid(etapa ~ gen) +
  labs(
    title = "Expresión de genes sobre el espacio PCA",
    subtitle = "Cada panel muestra el mismo PCA separado por etapa y coloreado por la expresión de un gen",
    x = paste0("PC1 (", pc1, "%)"),
    y = paste0("PC2 (", pc2, "%)"),
    color = "Expresión\nescalada"
  ) +
  theme_minimal()

pca_genes_facetas

## Preguntas para interpretar:
## - ¿Qué genes parecen tener valores altos hacia la derecha de PC1?
## - ¿Algún gen parece relacionarse más con PC2?
## - ¿Esta visualización prueba expresión diferencial?
##
## Respuesta esperada para la última pregunta:
## No. Esta figura es exploratoria. Para evaluar expresión diferencial se
## necesitan métodos específicos que se revisarán más adelante.


# 18. Guardar figuras y resultados ----------------------------------------

## Guardamos las figuras principales como PNG.
## Estos archivos pueden usarse después en presentaciones, reportes o tareas.

ggsave(
  filename = "results/U6_pca_scree_plot.png",
  plot = scree_plot,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_etapa.png",
  plot = pca_etapa,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_etapa_elipses.png",
  plot = pca_etapa_elipses,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_etapa_centroides.png",
  plot = pca_etapa_centroides,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_etapa_facetas.png",
  plot = pca_etapa_facetas,
  width = 9,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_etapa_subconjunto.png",
  plot = pca_etapa_subconjunto,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_biplot.png",
  plot = pca_biplot,
  width = 7,
  height = 5,
  dpi = 300
)

ggsave(
  filename = "results/U6_pca_genes_facetas.png",
  plot = pca_genes_facetas,
  width = 9,
  height = 6,
  dpi = 300
)

## Guardamos también tablas útiles del análisis.
## Usamos write.csv() para no depender de paquetes adicionales.

write.csv(
  tabla_varianza,
  file = "results/U6_pca_varianza_explicada.csv",
  row.names = FALSE
)

write.csv(
  pca_scores,
  file = "results/U6_pca_scores.csv",
  row.names = FALSE
)

write.csv(
  pca_loadings,
  file = "results/U6_pca_loadings.csv",
  row.names = FALSE
)

write.csv(
  centroides_etapa,
  file = "results/U6_pca_centroides_etapa.csv",
  row.names = FALSE
)


# 19. Cierre: interpretación cuidadosa ------------------------------------

## Una interpretación cuidadosa del PCA puede tener esta estructura:
##
## 1. Mencionar qué representa el gráfico.
## 2. Indicar qué porcentaje de variación explican PC1 y PC2.
## 3. Describir si hay agrupamiento, separación o traslape.
## 4. Aclarar que el PCA es exploratorio.
## 5. Proponer qué análisis o revisión complementaria haría falta.
##
## Ejemplo:
## "El PCA muestra una separación parcial de las muestras por etapa,
## principalmente sobre PC1. PC1 y PC2 explican en conjunto una proporción
## importante de la variación total. Sin embargo, este patrón debe interpretarse
## como exploratorio y no como una prueba estadística de diferencia entre etapas."

## Preguntas finales:
## - ¿Qué variable de metadatos parece explicar mejor el patrón visual?
## - ¿Hay traslape entre grupos?
## - ¿Qué limitación del PCA mencionarías?
## - ¿Qué figura guardarías para incluir en un reporte reproducible?


# Extra: PCA en 3D ---------------------------------------------------------

## El gráfico 3D es opcional. Puede servir para explorar PC1, PC2 y PC3
## al mismo tiempo, pero no sustituye la interpretación cuidadosa del PCA 2D.
##
## Si plotly no está instalado, puedes instalarlo con:
## install.packages("plotly")

library(plotly)

pca_3d <- plot_ly(
  data = pca_scores,
  x = ~PC1,
  y = ~PC2,
  z = ~PC3,
  color = ~etapa,
  type = "scatter3d",
  mode = "markers",
  marker = list(
    size = 2.5,
    opacity = 0.35
  )
) %>%
  layout(
    title = "PCA exploratorio en 3D",
    scene = list(
      xaxis = list(title = paste0("PC1 (", pc1, "%)")),
      yaxis = list(title = paste0("PC2 (", pc2, "%)")),
      zaxis = list(title = paste0("PC3 (", pc3, "%)"))
    )
  )

pca_3d

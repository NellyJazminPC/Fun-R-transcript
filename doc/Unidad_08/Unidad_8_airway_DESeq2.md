# Fundamentos de programación en R
# Unidad 8 – Expresión diferencial y visualización de resultados 

  
**Caso didáctico:** `airway`  
**Paquetes principales:** `airway`, `SummarizedExperiment`, `DESeq2`, `tidyverse`, `AnnotationDbi`, `org.Hs.eg.db`, `pheatmap`, `ggrepel`

---

## Índice

1. [Propósito de este cuaderno][1]
2. [Objetivos de aprendizaje][2]
3. [Dónde estamos dentro del flujo transcriptómico][3]
4. [Contexto biológico del caso `airway`][4]
5. [Qué es un análisis de expresión diferencial][5]
6. [Organización de carpetas y archivos][6]
7. [Preparación del ambiente de trabajo][7]
8. [Carga e inspección del objeto `airway`][8]
9. [Conteos crudos y metadatos][9]
10. [Preparación de metadatos][10]
11. [Construcción del objeto `DESeqDataSet`][11]
12. [Filtrado de genes de baja expresión][12]
13. [Análisis con `DESeq()`][13]
14. [Resultados con `results()`][14]
15. [Anotación de genes][15]
16. [Clasificación de genes: Up, Down y no significativos][16]
17. [Exportación de resultados][17]
18. [Transformación para visualización: `vst()`][18]
19. [PCA: análisis exploratorio de muestras][19]
20. [MA plot][20]
21. [Volcano plot][21]
22. [Heatmap][22]
23. [Actividades de práctica][23]
24. [Errores frecuentes y diagnóstico][24]
25. [Prompt recomendado para revisar el trabajo de la Unidad 8][25]
26. [Checklist final][26]

---

# 1. Propósito de este cuaderno

Este cuaderno está diseñado para acompañarte durante la **Unidad 8** del curso. Funciona como guía de práctica, cuaderno de apuntes y material de consulta posterior. Está inspirado en una estructura de práctica guiada: primero se introduce el contexto, después se explica el fundamento conceptual, luego se desarrolla el código paso a paso y finalmente se proponen actividades de interpretación y revisión.

En esta unidad usaremos el caso didáctico `airway` para trabajar un flujo básico de análisis transcriptómico en R:

```text
conteos crudos
↓
metadatos
↓
diseño experimental
↓
DESeq2
↓
tabla de expresión diferencial
↓
visualización de resultados
```

La intención no es memorizar comandos, sino comprender **qué pregunta responde cada paso** y **qué tipo de conclusión permite o no permite formular**.

---

# 2. Objetivos de aprendizaje

Al finalizar esta unidad podrás:

## Objetivos conceptuales

- Explicar qué representa una matriz de conteos crudos de RNA-seq.
- Explicar la función de los metadatos en un análisis de expresión diferencial.
- Reconocer la diferencia entre conteos crudos, conteos normalizados y datos transformados para visualización.
- Interpretar los campos principales de una tabla de resultados de `DESeq2`.
- Diferenciar significancia estadística de relevancia biológica.

## Objetivos técnicos

- Cargar el paquete `airway` y explorar su estructura.
- Extraer conteos crudos y metadatos desde un objeto `SummarizedExperiment`.
- Verificar que las muestras coincidan entre conteos y metadatos.
- Preparar variables experimentales como factores.
- Construir un objeto `DESeqDataSet`.
- Ejecutar un análisis de expresión diferencial con `DESeq2`.
- Extraer y ordenar resultados con `results()`.
- Anotar genes con `org.Hs.eg.db`.
- Clasificar genes como inducidos, reprimidos o no significativos.
- Generar visualizaciones iniciales: PCA, MA plot, volcano plot y heatmap.

## Objetivos de interpretación

- Leer una tabla de expresión diferencial.
- Interpretar `log2FoldChange`, `pvalue`, `padj` y `baseMean`.
- Explicar qué aporta cada figura al análisis transcriptómico.
- Reconocer posibles errores o limitaciones de interpretación.
- Formular una conclusión cautelosa y sustentada en los resultados.

---

# 3. Dónde estamos dentro del flujo transcriptómico

Un análisis transcriptómico completo puede incluir muchos pasos previos:

1. Extracción de RNA.
2. Evaluación de calidad del RNA.
3. Preparación de bibliotecas.
4. Secuenciación.
5. Control de calidad de lecturas.
6. Alineamiento o mapeo.
7. Generación de una matriz de conteos.

![][image-1]

Pasos previos al análisis:

- Alineamiento o mapeo de lecturas a un genoma de referencia (por ejemplo, usando herramientas como STAR, HISAT2, etc).
- Cuantificación de genes, es decir, contar cuántas lecturas corresponden a cada gen (con herramientas como featureCounts, HTSeq, Salmon o Kallisto).

El resultado es una matriz de expresión, también llamada matriz de conteos crudos, donde:

- Cada fila representa a un gen
- Cada columna representa una muestra biológica
- Cada valor (conteo) es el número de lecturas asignadas a ese gen en esa muestra

Para poder interpretar correctamente los resultados, necesitamos un archivo adicional: el archivo de metadatos (también conocido como diseño experimental o colData), que describe:

- El nombre o identificador de cada muestra
- La condición experimental
- Información adicional como tratamiento, lote, etc (si aplica).


En esta unidad **no trabajaremos con archivos FASTQ**, ni haremos alineamiento, ni cuantificación desde lecturas crudas. Partiremos de un punto posterior:

```text
matriz de conteos por gen + metadatos de las muestras
```

Este es el punto de entrada típico para un análisis de expresión diferencial con `DESeq2`.

---

# 4. Contexto biológico del caso `airway`

El paquete `airway` de Bioconductor[^1], contiene datos de RNA-seq derivados de un estudio sobre el efecto de la **dexametasona** en células humanas de músculo liso de vía aérea, conocidas como **ASM** por sus siglas en inglés: *airway smooth muscle*.

[^2] [\[https://www.bioconductor.org/packages/release/data/experiment/html/airway.html]][28]

## 4.1 Contexto general

El asma es una enfermedad respiratoria inflamatoria crónica. Los glucocorticoides son una parte central del tratamiento porque pueden reducir procesos inflamatorios en distintos tejidos pulmonares.

Sin embargo, los mecanismos moleculares por los cuales los glucocorticoides ejercen efectos antiinflamatorios en el músculo liso de la vía aérea no están completamente entendidos.

## 4.2 Pregunta biológica

Una forma de abordar esta pregunta es observar cómo cambia el transcriptoma de las células ASM cuando se exponen a un glucocorticoide.

En el estudio usado para generar estos datos, se trataron células ASM humanas con:

```text
Dexametasona 1 µM durante 18 horas
```

y se compararon contra células no tratadas.

![][image-2]

## 4.3 Diseño experimental simplificado

En el objeto `airway` tenemos:

- 4 líneas celulares humanas de músculo liso de la vía aérea.
-Para cada línea celular:
  - una condición sin tratamiento;
  - una condición tratada con dexametasona.

Esto genera un diseño donde cada línea celular aporta ambas condiciones.

Por ello, en nuestro análisis usaremos el diseño:

```r
design = ~ cell + dex
```

donde:

- `cell` representa la línea celular;
- `dex` representa el tratamiento con dexametasona.

En términos sencillos, en  
```r
design = ~ variable
```
la virgulilla equivale a "en función de", lo que indica como se deben agrupar los datos para buscar diferencias en la expresión de los genes.

## 4.4 ¿Por qué no usar solamente `~ dex`?

Podríamos pensar que solo queremos comparar tratado contra no tratado. Sin embargo, las líneas celulares pueden tener diferencias basales importantes entre sí. Si ignoramos esa fuente de variación, podríamos confundir diferencias entre líneas celulares con diferencias debidas al tratamiento.

Por eso usamos:

```r
~ cell + dex
```

Esta fórmula puede leerse como:

> Evalúa el efecto de la dexametasona tomando en cuenta que las muestras provienen de distintas líneas celulares.

---

# 5. Qué es un análisis de expresión diferencial

El análisis de expresión diferencial permite identificar genes cuya expresión cambia de manera estadísticamente significativa entre condiciones experimentales.

En este caso, la comparación central es:

```text
Dexametasona vs no tratadas
```

usando los nombres del objeto `airway`:

```text
trt vs untrt
```

## 5.1 Qué significa que un gen esté diferencialmente expresado

Un gen diferencialmente expresado es aquel cuya abundancia de RNA, estimada a partir de conteos de secuenciación, muestra evidencia estadística de ser diferente entre dos condiciones.

Pero hay que tener cuidado:

```text
Diferencialmente expresado ≠ biológicamente importante siempre
Diferencialmente expresado ≠ validado experimentalmente
```

Un análisis transcriptómico genera **candidatos**, **patrones** , **firmas** e **hipótesis**.

## 5.2 Tres niveles de interpretación

| Nivel                    | Ejemplo                                                          |
| ------------------------ | ---------------------------------------------------------------- |
| Resultado computacional  | “Se identificaron genes con `padj < 0.05`.”                      |
| Interpretación biológica | “Algunos genes se relacionan con respuesta a glucocorticoides.”  |
| Hipótesis                | “La dexametasona podría modular rutas antiinflamatorias en ASM.” |

La buena práctica consiste en no saltar directamente del primer nivel al tercero.

---

# 6. Organización de carpetas y archivos

Para esta unidad se recomienda trabajar con una estructura ordenada:

```text
data/Unidad_8
│
├── datos/
└── resultados/figuras
```

Durante la unidad generaremos o usaremos archivos como:

```text
datos/
  airway_counts_raw.csv
  airway_metadata.csv
  airway_annotation.csv

resultados/
  dds_airway.rds
  vsd_airway.rds
  res_deseq2_airway_anotado.csv
  genes_up_airway.csv
  genes_down_airway.csv
  top30_genes_heatmap_airway.csv

figuras/
  PCA_airway.pdf
  MAplot_airway.pdf
  volcano_airway.pdf
  heatmap_top30_airway.pdf
```

---

# 7. Preparación del ambiente de trabajo

## 7.1 Instalación de paquetes

Si no tienes los paquetes instalados, ejecuta:

```r

# Instalar paquetes de CRAN
install.packages("ggplot2")
install.packages("pheatmap")
install.packages("RColorBrewer")
install.packages("dplyr")
install.packages("readr")
install.packages("tibble")
install.packages("tidyverse")
install.packages("ggrepel")

# Instalar BiocManager si no está disponible
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Instalar paquetes de Bioconductor (uno por uno)
BiocManager::install("airway")
BiocManager::install("SummarizedExperiment")
BiocManager::install("DESeq2")
BiocManager::install("EnhancedVolcano")
BiocManager::install("ComplexHeatmap")
BiocManager::install("org.Hs.eg.db")

```

## 7.2 Cargar paquetes

```r
# 2. Cargar los paquetes necesarios

library(airway)
library(SummarizedExperiment)
library(DESeq2)
library(tidyverse)
library(pheatmap)
library(ggrepel)
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(readr)
library(tibble)
library(EnhancedVolcano)
library(ComplexHeatmap)
library (org.Hs.eg.db)
```

## 7.3 Crear carpetas de trabajo

```r
dir.create("data/datos", showWarnings = FALSE)
dir.create("data/resultados", showWarnings = FALSE)
dir.create("data/resultados/figuras", showWarnings = FALSE)
```

---

# 8. Carga e inspección del objeto `airway`

## 8.1 Cargar datos

```r
data("airway")
```

Inspecciona el objeto:

```r
airway
```

El objeto `airway` pertenece a una clase de Bioconductor llamada `RangedSummarizedExperiment`.

## 8.2 Qué contiene un `SummarizedExperiment`

Un `SummarizedExperiment` integra:

- `assay(s)`: matriz o matrices de conteos;
- `colData`: metadatos de las muestras;
- `rowData`: información de genes o regiones genómicas.

Para este ejercicio, lo más importante será extraer:

```r
assay(airway)
colData(airway)
```

---

# 9. Conteos crudos y metadatos

## 9.1 Extraer la matriz de conteos

```r
counts_airway <- assay(airway)
```

Revisa dimensiones:

```r
dim(counts_airway)
```

Visualiza una parte:

```r
head(counts_airway[, 1:4])
```


## 9.2 Cómo leer esta matriz

En una matriz de conteos:

- cada fila representa un gen;
- cada columna representa una muestra;
- cada valor representa el número de lecturas asignadas a ese gen en esa muestra.

Ejemplo:

```text
          muestra1  muestra2  muestra3
genA          120       135       98
genB            0         2        1
genC         3500      4200     3900
```

Los conteos son números enteros porque representan lecturas.

## 9.3 Extraer metadatos

```r
metadata_airway <- as.data.frame(colData(airway))
metadata_airway
```

Revisa los nombres de columnas:

```r
colnames(metadata_airway)
```

## 9.4 Preguntas de revisión

Responde:

1. ¿Cuántas muestras hay?
2. ¿Cuántos genes hay?
3. ¿Cuál columna representa el tratamiento?
4. ¿Cuál columna representa la línea celular?
5. ¿Qué valores toma la variable `dex`?
6. ¿Qué valores toma la variable `cell`?

Puedes usar:

```r
table(metadata_airway$dex)
table(metadata_airway$cell)
```

## 9.5 Paquete de análisis DESeq2

Utilizaremos uno de los paquetes más ampliamente utilizados de Bioconductor: **DESeq2[^3]**.

```
Love, M.I., Huber, W., Anders, S. (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology, 15:550. 10.1186/s13059-014-0550-8
```

Existen otros paquetes similares de Bioconductor como edgeR, limma, DSS, EBSeq, y baySeq. 


---

# 10. Preparación de metadatos

## 10.1 Verificar que las muestras coinciden

En DESeq2 es crítico que:

```text
columnas de counts = filas de metadata
```

Verifica:

```r
colnames(counts_airway)
rownames(metadata_airway)

all(colnames(counts_airway) == rownames(metadata_airway))
```

Si devuelve `TRUE`, puedes continuar. Si devuelve `FALSE`, no debes continuar hasta corregir el problema.

## 10.2 Convertir variables a factores

```r
metadata_airway$dex <- factor(metadata_airway$dex, levels = c("untrt", "trt"))
metadata_airway$cell <- factor(metadata_airway$cell)
```

¿Por qué definimos `untrt` primero?

El primer nivel del factor se toma como referencia.

```r
levels(metadata_airway$dex)
```

La interpretación del contraste será:

```text
trt vs untrt = tratado con dexametasona vs control
```

| `log2FoldChange` | Interpretación                  |
| ---------------: | ------------------------------- |
| positivo         | mayor expresión en dexametasona |
| negativo         | menor expresión en dexametasona |
| cercano a 0      | poca o nula diferencia          |

---

# 11. Construcción del objeto `DESeqDataSet`

```r
dds <- DESeqDataSetFromMatrix(
  countData = counts_airway,
  colData = metadata_airway,
  design = ~ cell + dex
)

dds
```

## 11.1 Componentes del objeto

| Argumento   | Significado                     |
| ----------- | ------------------------------- |
| `countData` | matriz de conteos crudos        |
| `colData`   | metadatos de las muestras       |
| `design`    | fórmula del diseño experimental |

Este objeto es fundamental porque integra tanto los datos de expresión como el diseño experimental. A partir de él realizamos todo el análisis en DESeq2, como la normalización, modelado estadístico y pruebas de hipótesis para detectar genes diferencialmente expresados.

## 11.2 Actividad breve

Explica con tus palabras:

1. ¿Qué representa `countData`?
2. ¿Qué representa `colData`?
3. ¿Qué representa `design`?
4. ¿Por qué este diseño usa dos variables?
5. ¿Cuál es la variable principal de interés?

---

# 12. Filtrado de genes de baja expresión

Antes de continuar con los análisis exploratorios, eliminamos los genes con muy pocos conteos totales en todas las muestras, ya que aportan poco valor y pueden generar ruido estadístico.

```r
# Filtrar genes con pocos conteos
dds <- dds[rowSums(counts(dds)) > 10, ]
dds
```

## 12.1 Por qué filtrar

Los genes con conteos extremadamente bajos:

- aportan poca información;
- pueden tener alta variabilidad relativa;
- complican la estimación estadística;
- aumentan el número de pruebas múltiples.

Filtrar no significa eliminar genes importantes de manera arbitraria, sino retirar genes que no tienen suficiente información para ser evaluados de forma confiable.

## 12.2 Pregunta de reflexión

¿Cuántos genes fueron conservados después del filtrado?

```r
nrow(counts_airway)
nrow(dds)
```

---

# 13. Análisis y normalización con `DESeq()`



```r
dds <- DESeq(dds)
```

Esta función realiza internamente:

1. estimación de factores de tamaño;
2. estimación de dispersión;
3. ajuste del modelo para cada gen;
4. prueba estadística asociada al contraste de interés.

Su objetivo principal es corregir diferencias en la profundidad de secuenciación y composición global entre muestras, para que los conteos sean comparables. DESeq2 usa por defecto el método median of ratios[^4], implementado en estimateSizeFactors() y ejecutado automáticamente dentro de DESeq().

## 13.1 Factores de tamaño

Los factores de tamaño corrigen diferencias de profundidad de secuenciación entre muestras.

## 13.2 Dispersión

La dispersión describe qué tanto varía la expresión de un gen más allá de lo esperado por su abundancia promedio.

## 13.3 Modelo por gen

Para cada gen, DESeq2 pregunta:

> ¿Hay evidencia de que la expresión cambie con dexametasona, después de considerar diferencias entre líneas celulares?

Revisa los coeficientes disponibles:

```r
resultsNames(dds)
```

| Coeficiente               | Cómo explicarlo                                                                                                                    | ¿Es el objetivo principal? |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `Intercept`               | Valor basal del modelo. Representa la condición de referencia: célula de referencia `N052611` y tratamiento de referencia `untrt`. | No                         |
| `cell_N061011_vs_N052611` | Diferencia entre la línea celular `N061011` y la línea de referencia `N052611`, controlando por tratamiento.                       | No                         |
| `cell_N080611_vs_N052611` | Diferencia entre la línea celular `N080611` y la línea de referencia `N052611`, controlando por tratamiento.                       | No                         |
| `cell_N61311_vs_N052611`  | Diferencia entre la línea celular `N61311` y la línea de referencia `N052611`, controlando por tratamiento.                        | No                         |
| `dex_trt_vs_untrt`        | Efecto del tratamiento con dexametasona comparado con no tratado, ajustando por línea celular.                                     | Sí                         |

resultsNames(dds) muestra los coeficientes estimados por el modelo. En airway, los coeficientes de cell ajustan diferencias entre líneas celulares; dex_trt_vs_untrt es el efecto biológico principal: dexametasona vs control.
---

# 14. Resultados con `results()`

## Parámetros de práctica 

En el script podrás modificar estos parámetros y ver cómo cambia el número de genes clasificados y las visualizaciones.

```r
padj_cutoff <- 0.05
log2fc_cutoff <- 1
top_n_heatmap <- 30
```


Ya ajustados los parámetros, podemos correr la línea para obtener los resultados (res):

```r
res <- results(
  dds,
  contrast = c("dex", "trt", "untrt"),
  alpha = 0.05
)
```

## 14.1 Qué significa cada campo

```r
contrast = c("dex", "trt", "untrt")
```

Esto indica:

```text
variable: dex
numerador: trt
denominador: untrt
```

En palabras:

```text
tratamiento con dexametasona vs control sin tratamiento
```

## 14.2 Revisar resumen

```r
summary(res)
```

## 14.3 Ordenar resultados

```r
res_ordered <- res[order(res$padj), ]
head(res_ordered)
```

## 14.4 Campos principales de la tabla

| Campo            | Significado                            |
| ---------------- | -------------------------------------- |
| `baseMean`       | media de conteos normalizados del gen  |
| `log2FoldChange` | cambio de expresión en escala log2     |
| `lfcSE`          | error estándar del log2FC              |
| `stat`           | estadístico de prueba                  |
| `pvalue`         | valor p sin ajustar                    |
| `padj`           | valor p ajustado por múltiples pruebas |

DESeq2 calcula primero un p-value para cada gen y después ajusta esos p-values para controlar la tasa de falsos descubrimientos. Ese valor ajustado es padj. Por defecto, DESeq2 usa el método Benjamini-Hochberg.


---

# 15. Anotación de genes

## 15.1 Convertir resultados a `data.frame`

```r
res_df <- as.data.frame(res_ordered) %>%
  rownames_to_column(var = "ensembl_id")
```

## 15.2 Agregar símbolos de genes

```r
res_df$symbol <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "SYMBOL",
  keytype = "ENSEMBL",
  multiVals = "first"
)
```

## 15.3 Agregar identificadores Entrez

```r
res_df$entrezid <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "ENTREZID",
  keytype = "ENSEMBL",
  multiVals = "first"
)
```

## 15.4 Agregar nombres completos

```r
res_df$gene_name <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "GENENAME",
  keytype = "ENSEMBL",
  multiVals = "first"
)
```

## 15.5 Nota sobre `NA` en anotaciones

Es normal que algunos identificadores no tengan símbolo asignado. Esto no significa necesariamente que el gen no exista; significa que no se encontró una correspondencia en la base de datos usada.

---

# 16. Clasificación de genes: Up, Down y no significativos

```r
res_df <- res_df %>%
  mutate(
    categoria = case_when(
      !is.na(padj) & padj < 0.05 & log2FoldChange > 1  ~ "Up",
      !is.na(padj) & padj < 0.05 & log2FoldChange < -1 ~ "Down",
      TRUE ~ "No significativo"
    )
  )

#Usamos !is.na(padj), que significa “padj no es NA”

table(res_df$categoria)
```

Con esto estamos indicando:

- Clasifica este gen como **Up** solo si tiene un padj válido, si ese padj es menor que el umbral definido y si su log2FoldChange es mayor que el umbral positivo.” 

- Clasifica este gen como **Down** solo si tiene un padj válido, si ese padj es menor que el umbral definido y si su log2FoldChange es menor que el umbral negativo.”

- **No significativo** incluye tanto genes que no cumplen el umbral estadístico como genes que no tienen padj disponible.”


## 16.1 Interpretación de categorías

| Categoría        | Criterio                      | Interpretación                               |
| ---------------- | ----------------------------- | -------------------------------------------- |
| Up               | `padj < 0.05` y `log2FC > 1`  | mayor expresión en dexametasona              |
| Down             | `padj < 0.05` y `log2FC < -1` | menor expresión en dexametasona              |
| No significativo | no cumple criterios           | sin evidencia suficiente bajo estos umbrales |

## 16.2 Cuidado con los umbrales

Los criterios `padj < 0.05` y `abs(log2FC) > 1` son útiles para una práctica didáctica, pero no son universales. La selección de umbrales depende de la pregunta biológica, tamaño de muestra, variabilidad, objetivo del análisis y necesidad de validación.



---

# 17. Exportar resultados

```r
genes_up <- res_df %>%
  filter(categoria == "Up") %>%
  arrange(padj)

genes_down <- res_df %>%
  filter(categoria == "Down") %>%
  arrange(padj)
```

Guardar archivos:

```r
write.csv(
  res_df,
  file = "data/resultados/res_deseq2_airway_anotado.csv",
  row.names = FALSE
)

write.csv(
  genes_up,
  file = "data/resultados/genes_up_airway.csv",
  row.names = FALSE
)

write.csv(
  genes_down,
  file = "data/resultados/genes_down_airway.csv",
  row.names = FALSE
)

saveRDS(dds, file = "data/resultados/dds_airway.rds")
```

Guardamos dds como .rds porque es el objeto completo del análisis de DESeq2. No solo contiene una tabla de resultados, sino también los conteos, metadatos, diseño experimental, normalización y parámetros estimados. Esto nos permite retomar el análisis después sin volver a correr todos los pasos.


---

# 18. Transformación para visualización: `vst()`

Para visualizaciones como PCA y heatmaps, usamos una transformación estabilizadora de varianza.

```r
vsd <- vst(dds, blind = FALSE)
saveRDS(vsd, file = "data/resultados/vsd_airway.rds")
```

## 18.1 Por qué transformar

En RNA-seq, los genes con conteos altos tienden a tener mayor variabilidad absoluta. La transformación `vst()` ayuda a estabilizar la varianza y facilita la comparación visual entre muestras.

## 18.2 Advertencia importante

```text
vst() sirve para visualización y exploración.
No sustituye los conteos crudos para correr DESeq2.
```

El análisis estadístico de expresión diferencial se hace con los conteos crudos dentro del modelo de DESeq2.

---

# 19. PCA: análisis exploratorio de muestras


```r
p_pca <- plotPCA(
  vsd,
  intgroup = c("dex", "cell")
) +
  ggtitle("PCA de muestras airway") +
  theme_minimal()

p_pca
```

Guardar:

```r
ggsave(
  filename = "figuras/PCA_airway.pdf",
  plot = p_pca,
  width = 7,
  height = 5
)
```

Aunque en el script podamos correr DESeq() antes del PCA por comodidad, conceptualmente el PCA pertenece a la etapa exploratoria. Lo usamos para revisar la estructura global de los datos antes de interpretar los resultados de expresión diferencial.

## 19.1 Cómo interpretar el PCA

- Cada punto representa una muestra.
- Muestras cercanas tienen perfiles de expresión global más similares.
- PC1 y PC2 capturan las principales fuentes de variación.
- El PCA ayuda a detectar agrupamientos y posibles muestras atípicas.

![][image-3]

## 19.2 Preguntas guía

1. ¿Las muestras tratadas y no tratadas se separan?
2. ¿La variable `cell` también parece influir?
3. ¿Hay alguna muestra atípica?
4. ¿La separación observada coincide con el diseño experimental?

---

# 20. MA plot

Un MA plot se puede explicar como una gráfica que responde esta pregunta:

¿Los genes que cambian mucho entre condiciones tienen suficiente nivel de expresión promedio como para interpretar ese cambio con confianza?

En RNA-seq, cada punto del MA plot representa un gen.

1. ¿Qué significa “MA”?

El nombre viene de:

| Letra | Significado         | En DESeq2                               |
| ----- | ------------------- | --------------------------------------- |
| **M** | _Minus_ o log-ratio | Cambio de expresión: `log2FoldChange`   |
| **A** | _Average_           | Abundancia promedio del gen: `baseMean` |


```r
plotMA(
  res,
  ylim = c(-5, 5),
  main = "MA plot: dexametasona vs control"
)
```

![][image-4]

¿Cómo leer los ejes?
Eje X: abundancia promedio

El eje X representa qué tanto se expresa un gen en promedio entre las muestras.

Izquierda  → genes con baja expresión
Derecha    → genes con mayor expresión promedio

En DESeq2 corresponde aproximadamente a baseMean, que es la media de conteos normalizados.

Eje Y: log2FoldChange

El eje Y representa el cambio de expresión entre condiciones.

Guardar:

```r
pdf("figuras/MAplot_airway.pdf", width = 7, height = 5)
plotMA(
  res,
  ylim = c(-5, 5),
  main = "MA plot: dexametasona vs control"
)
dev.off()
```

## 20.1 Qué representa

Cada punto representa un gen.

- Eje X: abundancia promedio del gen.
- Eje Y: `log2FoldChange`.

En nuestro contraste:

```r
contrast = c("dex", "trt", "untrt")
```

la interpretación es:

|     |     |
| --- | --- |
|     |     |
|     |     |
|     |     |

## 20.2 Interpretación de `log2FoldChange`

| `log2FoldChange` | Interpretación aproximada |
| ---------------: | ------------------------- |
| 0                | sin cambio                |
| 1                | 2 veces más expresión     |
| 2                | 4 veces más expresión     |
| -1               | 2 veces menos expresión   |
| -2               | 4 veces menos expresión   |

## 20.3 Idea clave












El MA plot nos recuerda que no todos los cambios de expresión tienen el mismo contexto. Un cambio muy grande en un gen con conteos muy bajos puede ser menos estable que un cambio observado en un gen con expresión abundante y consistente.

---

# 21. Volcano plot

## 21.1 Preparar tabla

```r
volcano_df <- res_df %>%
  filter(!is.na(padj)) %>%
  mutate(
    neg_log10_padj = -log10(padj),
    categoria = case_when(
      padj < 0.05 & log2FoldChange > 1  ~ "Up",
      padj < 0.05 & log2FoldChange < -1 ~ "Down",
      TRUE ~ "No significativo"
    ),
    etiqueta = case_when(
      padj < 0.01 & abs(log2FoldChange) > 2 & !is.na(symbol) ~ symbol,
      padj < 0.01 & abs(log2FoldChange) > 2 & is.na(symbol)  ~ ensembl_id,
      TRUE ~ NA_character_
    )
  )
```

## 21.2 Generar gráfico

```r
p_volcano <- ggplot(
  volcano_df,
  aes(x = log2FoldChange, y = neg_log10_padj)
) +
  geom_point(aes(color = categoria), alpha = 0.7, size = 1.8) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
  geom_text_repel(aes(label = etiqueta), max.overlaps = 20, na.rm = TRUE) +
  labs(
    title = "Volcano plot: dexametasona vs control",
    x = "log2 Fold Change",
    y = "-log10(padj)",
    color = "Categoría"
  ) +
  theme_minimal()

p_volcano
```

Guardar:

```r
ggsave(
  filename = "data/resultados/figuras/U8/volcano_airway.pdf",
  plot = p_volcano,
  width = 8,
  height = 6
)
```

## 21.3 Cómo leerlo

![][image-5]

| Región                   | Interpretación                                 |
| ------------------------ | ---------------------------------------------- |
| Centro inferior          | poco cambio y baja evidencia estadística       |
| Derecha superior         | genes inducidos con alta evidencia             |
| Izquierda superior       | genes reprimidos con alta evidencia            |
| Extremos laterales bajos | cambio grande pero menor evidencia estadística |


## Recuerda: 
Puedes modificar tus parámetros de práctica y considera:

| `log2FoldChange` | Fold Change lineal | Interpretación            |
| ---------------: | -----------------: | ------------------------- |
| 0                | 1                  | Sin cambio                |
| 0.585            | 1.5                | 1.5 veces más expresión   |
| 1                | 2                  | 2 veces más expresión     |
| 2                | 4                  | 4 veces más expresión     |
| -0.585           | 0.67               | 1.5 veces menos expresión |
| -1               | 0.5                | 2 veces menos expresión   |
| -2               | 0.25               | 4 veces menos expresión   |


---

































# 22. Heatmap

## 22.1 Seleccionar genes

```r
top_genes <- res_df %>%
  dplyr::filter(!is.na(padj)) %>%
  dplyr::arrange(padj) %>%
  dplyr::slice(1:30) %>%
  dplyr::pull(ensembl_id)
```

## 22.2 Extraer y escalar matriz

```r
mat <- assay(vsd)[top_genes, , drop = FALSE]
mat_z <- t(scale(t(mat)))
```

## 22.3 Preparar anotación

```r
annotation_col <- metadata_airway %>%
  dplyr::select(dex, cell)

rownames(annotation_col) <- rownames(metadata_airway)
```

## 22.4 Generar heatmap

```r
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Top 30 genes diferencialmente expresados",
  filename = "data/resultados/figuras/heatmap_top30_airway.pdf",
  width = 7,
  height = 8
)
```

Para verlo en R:

```r
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Top 30 genes diferencialmente expresados"
)
```

## 22.5 Cómo interpretarlo


![][image-6]

- Cada fila representa un gen.
- Cada columna representa una muestra.
- Los colores representan expresión relativa del gen entre muestras.
- Las anotaciones de columna ayudan a reconocer tratamiento y línea celular.
- El agrupamiento permite explorar si las muestras se parecen más por tratamiento o por línea celular.







---

# 23. Actividades de práctica extra

## Actividad 1. Anatomía de `airway`

Ejecuta:

```r
airway
class(airway)
dim(airway)
assayNames(airway)
colnames(colData(airway))
```

Responde:

1. ¿Qué tipo de objeto es `airway`?
2. ¿Cuántas muestras tiene?
3. ¿Dónde están los conteos?
4. ¿Dónde están los metadatos?

## Actividad 2. Diseño experimental

```r
metadata_airway <- as.data.frame(colData(airway))

table(metadata_airway$dex)
table(metadata_airway$cell)
```

Responde:











1. ¿Cuántas muestras hay por tratamiento?
2. ¿Cuántas líneas celulares hay?
3. ¿Por qué el diseño `~ cell + dex` es más adecuado que `~ dex`?

## Actividad 3. Interpretación de resultados

```r
head(res_df, 10)
```

Para los primeros 10 genes:

1. ¿Cuál tiene menor `padj`?
2. ¿Cuál tiene mayor `log2FoldChange`?
3. ¿Cuál tiene menor `log2FoldChange`?
4. ¿Todos tienen símbolo de gen?
5. ¿Cuál seleccionarías para discutir y por qué?

## Actividad 4. Umbrales

```r
res_df_alt <- res_df %>%
  mutate(
    categoria_alt = case_when(
      !is.na(padj) & padj < 0.05 & log2FoldChange > 0.5  ~ "Up",
      !is.na(padj) & padj < 0.05 & log2FoldChange < -0.5 ~ "Down",
      TRUE ~ "No significativo"
    )
  )

table(res_df$categoria)
table(res_df_alt$categoria_alt)
```

Responde:

1. ¿Cuántos genes cambian de categoría?
2. ¿El criterio más flexible siempre es mejor?
3. ¿Qué riesgo tiene usar umbrales muy laxos?
4. ¿Qué riesgo tiene usar umbrales muy estrictos?

## Actividad 5. Comparar visualizaciones

Completa:

| Visualización | Qué pregunta responde | Qué no permite concluir |
| ------------- | --------------------- | ----------------------- |
| PCA           |                       |                         |
| MA plot       |                       |                         |
| Volcano plot  |                       |                         |
| Heatmap       |                       |                         |

---

# 24. Errores frecuentes y diagnóstico

## Error 1. Paquete no instalado

```text
there is no package called 'DESeq2'
```

Solución:

```r
BiocManager::install("DESeq2")
```

## Error 2. Objeto no encontrado

```text
object 'dds' not found
```

Causas posibles:

- no ejecutaste el bloque donde se crea `dds`;
- cerraste R y no cargaste el objeto guardado;
- el objeto tiene otro nombre.

Verifica:

```r
ls()
```

## Error 3. Muestras no coinciden

```r
all(colnames(counts_airway) == rownames(metadata_airway))
```

Si devuelve `FALSE`, revisa:

```r
colnames(counts_airway)
rownames(metadata_airway)
```

Este error es crítico.

## Error 4. Variable inexistente en el diseño

Si usas:

```r
design = ~ treatment
```

pero no existe una columna llamada `treatment`, fallará. Verifica:

```r
colnames(metadata_airway)
```

En `airway`, el diseño sugerido es:

```r
design = ~ cell + dex
```

## Error 5. Usar `vst()` como entrada de DESeq2

Incorrecto:

```r
DESeqDataSetFromMatrix(
  countData = assay(vsd),
  colData = metadata_airway,
  design = ~ cell + dex
)
```

Correcto:

```r
DESeqDataSetFromMatrix(
  countData = counts_airway,
  colData = metadata_airway,
  design = ~ cell + dex
)
```

## Error 6. `padj` contiene `NA`

Es normal que algunos genes tengan `padj = NA`. Para graficar:

```r
res_df_filtrado <- res_df %>%
  filter(!is.na(padj))
```

## Error 7. `geom_text_repel()` no existe

Carga:

```r
library(ggrepel)
```

Si no está instalado:

```r
install.packages("ggrepel")
```

---

# 25. Prompt recomendado para revisar el trabajo de la Unidad 8

Usa este prompt al final de la sesión:

```text
Actúa como tutor de R para análisis transcriptómicos.

Estoy trabajando con el caso airway de Bioconductor y DESeq2.
Mi objetivo es revisar un flujo básico de expresión diferencial y visualización.

Los pasos que revisé son:
1. Cargar airway.
2. Extraer conteos crudos y metadatos.
3. Preparar factores dex y cell.
4. Crear un objeto DESeqDataSet con diseño ~ cell + dex.
5. Filtrar genes de baja expresión.
6. Ejecutar DESeq().
7. Extraer resultados con contrast = c("dex", "trt", "untrt").
8. Anotar genes.
9. Clasificar genes Up, Down y No significativos.
10. Generar PCA, MA plot, volcano plot y heatmap.

Este es mi código:

[PEGA AQUÍ TU CÓDIGO]

Este es el error o duda que tengo:

[PEGA AQUÍ EL ERROR O TU DUDA]

Por favor:
1. Revisa si hay errores de sintaxis.
2. Revisa si los objetos se crean antes de usarse.
3. Revisa si los nombres de columnas son consistentes con airway.
4. Señala posibles errores conceptuales.
5. No inventes objetos, columnas, genes ni resultados.
6. Sugiere la corrección mínima necesaria.
7. Explícame cómo puedo comprobar en R que la corrección funcionó.
8. Dame una pregunta de reflexión para asegurar que entendí el problema.
```

---

# 26. Checklist final

## Preparación

- [ ] Tengo un proyecto de RStudio o una carpeta de trabajo organizada.
- [ ] Tengo las carpetas `datos/`, `resultados/` y `figuras/`.
- [ ] Puedo cargar todos los paquetes necesarios.
- [ ] Cargué el objeto `airway`.

## Datos

- [ ] Extraje `counts_airway`.
- [ ] Extraje `metadata_airway`.
- [ ] Verifiqué que columnas de conteos y filas de metadatos coinciden.
- [ ] Convertí `dex` y `cell` a factores.
- [ ] Definí `untrt` como referencia.

## DESeq2

- [ ] Construí el objeto `dds`.
- [ ] Usé el diseño `~ cell + dex`.
- [ ] Filtré genes de baja expresión.
- [ ] Ejecuté `DESeq(dds)`.
- [ ] Extraje resultados para `trt` vs `untrt`.
- [ ] Convertí resultados a `data.frame`.
- [ ] Agregué anotación de genes.
- [ ] Clasifiqué genes como Up, Down o No significativos.
- [ ] Guardé resultados en `.csv`.
- [ ] Guardé `dds` en `.rds`.

## Visualización

- [ ] Generé objeto `vsd`.
- [ ] Guardé `vsd` en `.rds`.
- [ ] Generé PCA.
- [ ] Generé MA plot.
- [ ] Generé volcano plot.
- [ ] Generé heatmap.
- [ ] Guardé las figuras en la carpeta `figuras/`.

## Interpretación

- [ ] Puedo explicar qué representa `log2FoldChange`.
- [ ] Puedo explicar qué representa `padj`.
- [ ] Puedo explicar la diferencia entre MA plot y volcano plot.
- [ ] Puedo explicar por qué usamos `vst()` para visualización.
- [ ] Puedo escribir una conclusión cautelosa a partir de los resultados.

[^1]:	[https://www.bioconductor.org/packages/release/data/experiment/html/airway.html][27]

[^2]:	.

[^3]:	[http://127.0.0.1:13512/library/DESeq2/doc/DESeq2.html][29]

[^4]:	¿Cómo funciona el método “median of ratios”?

	De forma simplificada:

	Para cada gen, DESeq2 calcula una especie de “muestra de referencia” usando la media geométrica de los conteos entre muestras.
	Para cada muestra, compara sus conteos contra esa referencia gen por gen.
	Para cada muestra, toma la mediana de esas razones.
	Esa mediana es el size factor de la muestra.

[1]:	#1-propósito-de-este-cuaderno
[2]:	#2-objetivos-de-aprendizaje
[3]:	#3-dónde-estamos-dentro-del-flujo-transcriptómico
[4]:	#4-contexto-biológico-del-caso-airway
[5]:	#5-qué-es-un-análisis-de-expresión-diferencial
[6]:	#6-organización-de-carpetas-y-archivos
[7]:	#7-preparación-del-ambiente-de-trabajo
[8]:	#8-carga-e-inspección-del-objeto-airway
[9]:	#9-conteos-crudos-y-metadatos
[10]:	#10-preparación-de-metadatos
[11]:	#11-construcción-del-objeto-deseqdataset
[12]:	#12-filtrado-de-genes-de-baja-expresión
[13]:	#13-análisis-y-normalización-con-deseq
[14]:	#14-resultados-con-results
[15]:	#15-anotación-de-genes
[16]:	#16-clasificación-de-genes-up-down-y-no-significativos
[17]:	#17-exportar-resultados
[18]:	#18-transformación-para-visualización-vst
[19]:	#19-pca-análisis-exploratorio-de-muestras
[20]:	#20-ma-plot
[21]:	#21-volcano-plot
[22]:	#22-heatmap
[23]:	#23-actividades-de-práctica-extra
[24]:	#24-errores-frecuentes-y-diagnóstico
[25]:	#25-prompt-recomendado-para-revisar-el-trabajo-de-la-unidad-8
[26]:	#26-checklist-final
[27]:	https://www.bioconductor.org/packages/release/data/experiment/html/airway.html
[28]:	https://www.bioconductor.org/packages/release/data/experiment/html/airway.html
[29]:	http://127.0.0.1:13512/library/DESeq2/doc/DESeq2.html

[image-1]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/flujo1.png
[image-2]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/airway_design.png
[image-3]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/PCA.png
[image-4]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/MA%20plot.png
[image-5]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/Volcano.png
[image-6]:	https://github.com/NellyJazminPC/Fun-R-transcript/blob/main/doc/Unidad_08/heatmap.png
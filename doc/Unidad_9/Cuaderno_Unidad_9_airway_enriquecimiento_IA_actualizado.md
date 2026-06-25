# Fundamentos de programación en R
# Unidad 9 – Visualización, enriquecimiento funcional e IA como apoyo para código en R
  
**Caso didáctico:** `airway`  
**Comparación principal:** dexametasona (`trt`) vs control sin tratamiento (`untrt`)  
**Diseño usado en Unidad 8:** `~ cell + dex`  
**Paquetes principales:** `DESeq2`, `tidyverse`, `clusterProfiler`, `enrichplot`, `org.Hs.eg.db`, `pheatmap`, `ggrepel`, `patchwork`, `pathview`  

---

## Índice

1. [Propósito de este cuaderno][1]
2. [Objetivos de aprendizaje de la Unidad 9][2]
3. [Conexión con la Unidad 8][3]
4. [¿Qué haremos en la Unidad 9?][4]
5. [Preparación del ambiente de trabajo][5]
6. [Carga de archivos generados en la Unidad 8][6]
7. [Recapitulación de resultados de expresión diferencial][7]
8. [Visualización de resultados, segunda parte][8]
9. [Gráfico de expresión de genes individuales][9]
10. [Heatmap refinado de genes seleccionados][10]
11. [¿Qué es un análisis de enriquecimiento funcional?][11]
12. [Enfoques principales: ORA, GSEA y análisis de rutas][12]
13. [Gene Ontology: BP, MF y CC][13]
14. [Preparación de listas génicas para ORA][14]
15. [Universo de fondo: un punto crítico][15]
16. [Análisis GO con `enrichGO()` para genes Up][16]
17. [Análisis GO con `enrichGO()` para genes Down][17]
18. [Visualización de resultados GO: dotplot y barplot][18]
19. [Visualizaciones de red: emapplot, cnetplot y heatplot][19]
20. [Comparación funcional entre genes Up y Down][20]
21. [Enriquecimiento de rutas KEGG con `enrichKEGG()`][21]
22. [Visualización de rutas KEGG con `pathview()`][22]
23. [Demostración breve de GSEA][23]
24. [Interpretación biológica cautelosa][24]
25. [IA y R: uso como acompañante para revisar código][25]
26. [Actividades de práctica][26]
27. [Errores frecuentes y diagnóstico][27]
28. [Checklist final de la Unidad 9][28]
29. [Cierre conceptual][29]
30. [Anexo. Código completo mínimo de la Unidad 9]()

---

# 1. Propósito de este cuaderno

Este cuaderno acompaña la **Unidad 9** del curso y está pensado como una guía de trabajo amplia para que puedas regresar a ella después de la sesión.

En la Unidad 8 trabajamos con el caso `airway` para realizar un análisis básico de expresión diferencial con `DESeq2`. En esta Unidad 9 retomaremos esos resultados para:

- recapitular y mejorar algunas visualizaciones;
- preparar listas de genes inducidos y reprimidos;
- realizar análisis de enriquecimiento funcional;
- explorar términos GO;
- analizar rutas KEGG;
- hacer una demostración breve de GSEA;
- usar IA como apoyo para revisar código, corregir errores y adaptar scripts a proyectos propios.

La intención no es convertirte en especialista en enriquecimiento funcional en una sola sesión. El objetivo es que comprendas la lógica de análisis y puedas ejecutar un flujo básico, interpretar sus salidas y reconocer sus límites.

---

# 2. Objetivos de aprendizaje

Al finalizar esta unidad, podrás:

## Objetivos conceptuales

- Explicar para qué sirve el análisis de enriquecimiento funcional.
- Diferenciar entre una lista de genes y una interpretación biológica.
- Distinguir entre análisis ORA y GSEA.
- Diferenciar entre GO y KEGG.
- Interpretar de manera básica términos enriquecidos, rutas y visualizaciones funcionales.

## Objetivos técnicos

- Cargar resultados generados con `DESeq2`.
- Revisar genes Up y Down.
- Preparar listas de genes.
- Ejecutar `enrichGO()` para procesos biológicos.
- Ejecutar `enrichKEGG()` para rutas KEGG.
- Visualizar resultados con:
  - `dotplot()`
  - `barplot()`
  - `emapplot()`
  - `cnetplot()`
  - `heatplot()`
- Comparar resultados entre genes Up y Down con `compareCluster()`.
- Preparar un vector ordenado para una demostración de GSEA.
- Usar IA para revisar código sin sustituir el razonamiento analítico.

## Objetivos de interpretación

- Leer una tabla de resultados funcionales.
- Explicar `GeneRatio`, `BgRatio`, `Count`, `pvalue`, `p.adjust` y `qvalue`.
- Formular conclusiones cautelosas basadas en resultados transcriptómicos.

---

# 3. Conexión con la Unidad 8

En la Unidad 8 partimos del objeto `airway` y realizamos el siguiente flujo:

```text
airway
↓
conteos crudos + metadatos
↓
DESeqDataSet
↓
DESeq()
↓
results()
↓
tabla de expresión diferencial
↓
PCA / MA plot / volcano plot / heatmap
```

En esta unidad retomaremos los archivos generados:

```text
resultados/
  dds_airway.rds
  vsd_airway.rds
  res_deseq2_airway_anotado.csv
  genes_up_airway.csv
  genes_down_airway.csv
```

Si no tienes esos archivos, puedes regenerarlos con el script de la Unidad 8.

---

# 4. ¿Qué haremos en la Unidad 9?

La Unidad 9 se organiza en cuatro grandes bloques.

## Bloque 1. Recapitulación y visualización segunda parte

Revisaremos los resultados de expresión diferencial y refinaremos algunas figuras:

- tabla de genes diferenciales;
- genes Up y Down;
- volcano plot refinado;
- expresión de genes individuales;
- heatmap ajustado.

## Bloque 2. Enriquecimiento funcional

Partiremos de las listas de genes diferenciales para preguntar:

> ¿Qué procesos biológicos o rutas están sobrerrepresentados en mis genes de interés?

Trabajaremos principalmente con:

- GO Biological Process;
- KEGG;
- comparación Up vs Down.

## Bloque 3. Demostración breve de GSEA

Veremos la diferencia entre:

```text
ORA = lista cortada de genes significativos
GSEA = todos los genes ordenados por una métrica
```

La demostración de GSEA será conceptual y breve.

## Bloque 4. IA y R

Usaremos IA como apoyo para:

- revisar código;
- explicar errores;
- comentar scripts;
- adaptar código didáctico a proyectos propios;
- revisar la lógica del flujo de análisis.

La IA no sustituye el criterio estadístico ni biológico.

---

# 5. Preparación del ambiente de trabajo

## 5.1 Paquetes necesarios

Para esta unidad necesitaremos los siguientes paquetes.

### Paquetes de CRAN

```r
install.packages(c(
  "tidyverse",
  "pheatmap",
  "ggrepel",
  "patchwork",
  "RColorBrewer"
))
```

### Paquetes de Bioconductor

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install(c(
  "DESeq2",
  "airway",
  "SummarizedExperiment",
  "GenomicRanges",
  "clusterProfiler",
  "enrichplot",
  "org.Hs.eg.db",
  "pathview"
))
```

## 5.2 Cargar paquetes

```r
library(DESeq2)
library(airway)
library(SummarizedExperiment)
library(GenomicRanges)
library(tidyverse)
library(pheatmap)
library(ggrepel)
library(patchwork)
library(clusterProfiler)
library(enrichplot)
library(org.Hs.eg.db)
library(pathview)
```

## 5.3 Crear carpetas

```r
dir.create("data/resultados/U9", showWarnings = FALSE)
dir.create("data/resultados/U9/figuras", showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/genes_individuales", recursive = TRUE, showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/enriquecimiento", recursive = TRUE, showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/kegg", recursive = TRUE, showWarnings = FALSE)
```

---

# 6. Carga de archivos generados en la Unidad 8

La Unidad 9 parte de los resultados de expresión diferencial de la Unidad 8.

```r
dds <- readRDS("data/resultados/dds_airway.rds")
vsd <- readRDS("data/resultados/vsd_airway.rds")

res_df <- read.csv(
  "data/resultados/res_deseq2_airway_anotado.csv",
  stringsAsFactors = FALSE
)
```

Revisamos la tabla:

```r
head(res_df)
dim(res_df)
colnames(res_df)
```

Esperamos columnas como:

```text
ensembl_id
baseMean
log2FoldChange
lfcSE
stat
pvalue
padj
symbol
entrezid
gene_name
categoria
```

## 6.1 Recuperar metadatos

```r
metadata_airway <- as.data.frame(colData(dds))

head(metadata_airway)
```

## 6.2 Verificación y resumen

```r
table(res_df$categoria)
summary(res_df$log2FoldChange)
summary(res_df$padj)

resumen_degs <- res_df %>%
  filter(!is.na(padj)) %>%
  summarise(
    genes_evaluados = n(),
    genes_padj_005 = sum(padj < 0.05, na.rm = TRUE),
    max_abs_log2FC = max(abs(log2FoldChange), na.rm = TRUE)
  )

resumen_degs
```

---

# 7. Recapitulación de resultados de expresión diferencial

Revisar datos que obtuvimos.

## 7.1 Columnas principales

| Columna          | Significado                               |
| ---------------- | ----------------------------------------- |
| `ensembl_id`     | Identificador Ensembl del gen             |
| `baseMean`       | Promedio de conteos normalizados          |
| `log2FoldChange` | Cambio de expresión en escala log2        |
| `lfcSE`          | Error estándar del log2FoldChange         |
| `stat`           | Estadístico de prueba                     |
| `pvalue`         | Valor p sin ajustar                       |
| `padj`           | Valor p ajustado por múltiples pruebas    |
| `symbol`         | Símbolo génico                            |
| `entrezid`       | Identificador Entrez                      |
| `gene_name`      | Nombre descriptivo del gen                |
| `categoria`      | Clasificación Up, Down o No significativo |

## 7.2 Interpretación del contraste

En la Unidad 8 usamos:

```r
contrast = c("dex", "trt", "untrt")
```

Por tanto:

```text
log2FoldChange positivo  → mayor expresión en dexametasona
log2FoldChange negativo  → menor expresión en dexametasona
```

## 7.3 Criterio didáctico inicial

En la Unidad 8 usamos:

```text
padj < 0.05
abs(log2FoldChange) > 1
```

Este criterio es útil para una práctica, pero no es universal. Para análisis funcional, el número de genes disponibles puede afectar los resultados. Si una lista queda muy pequeña, puede ser necesario revisar el umbral.

---


# 8. Normalización de conteos en RNA-seq: DESeq2, TPM, FPKM y RPKM como enfoques complementarios

En un experimento de RNA-seq, el número de lecturas o fragmentos asignados a cada gen está relacionado con su nivel de expresión. Sin embargo, los conteos observados no dependen únicamente de la cantidad real de RNA presente en la muestra. También están influenciados por factores técnicos y estructurales que no forman parte de la pregunta biológica principal. La **normalización** es el proceso mediante el cual se ajustan los conteos crudos para reducir el efecto de esos factores y hacer que los niveles de expresión sean más comparables entre muestras o dentro de una misma muestra.

Entre los factores que suelen considerarse durante la normalización se encuentran la profundidad de secuenciación, la longitud del gen o transcrito y la composición global del RNA.

La **profundidad de secuenciación** se refiere al número total de lecturas obtenidas para cada muestra. Si una muestra fue secuenciada con mayor profundidad que otra, puede presentar más conteos para muchos genes, no porque esos genes estén más expresados, sino porque se obtuvieron más lecturas en total. Por ello, corregir por profundidad de secuenciación es necesario cuando queremos comparar la expresión de un mismo gen entre diferentes muestras.

La **longitud génica** también influye en los conteos. Un gen más largo puede acumular más lecturas que un gen corto simplemente porque ofrece una región mayor para que las lecturas se alineen. Por esta razón, cuando queremos comparar la abundancia de genes distintos dentro de una misma muestra, es importante considerar la longitud del gen o del transcrito.

La **composición del RNA** se refiere a cómo se distribuyen los conteos entre los genes de una muestra. En algunos casos, unos cuantos genes muy expresados, genes muy diferencialmente expresados o incluso contaminación pueden ocupar una proporción muy grande de las lecturas totales. Esto puede sesgar algunas formas simples de normalización, porque los demás genes parecerían tener menos expresión relativa aunque sus niveles reales no hayan cambiado. Por esta razón, métodos como DESeq2 incorporan estrategias que corrigen no solo por profundidad de secuenciación, sino también por diferencias en la composición global de los conteos.

Aunque la normalización es esencial para los análisis de expresión diferencial, también es útil para la exploración de datos, la visualización y la comparación descriptiva de niveles de expresión. Sin embargo, no todos los métodos de normalización sirven para los mismos objetivos.

| Método                   | Descripción general                                                    | Factores que considera                                         | Uso recomendado                                                                                       |
| ------------------------ | ---------------------------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| CPM                      | Conteos escalados por millón de lecturas                               | Profundidad de secuenciación                                   | Comparación descriptiva entre réplicas o muestras similares; no recomendado para análisis diferencial |
| TPM                      | Conteos corregidos por longitud del transcrito y escalados por millón  | Profundidad de secuenciación y longitud génica/transcripcional | Comparación descriptiva de abundancia dentro de una muestra o exploración de genes individuales       |
| RPKM/FPKM                | Lecturas o fragmentos por kilobase por millón                          | Profundidad de secuenciación y longitud génica                 | Comparación descriptiva entre genes dentro de una muestra; no recomendado para análisis diferencial   |
| DESeq2: median of ratios | Conteos divididos entre factores de tamaño específicos de cada muestra | Profundidad de secuenciación y composición del RNA             | Comparación de un mismo gen entre muestras y análisis de expresión diferencial                        |
| edgeR: TMM               | Media recortada ponderada de razones de expresión entre muestras       | Profundidad de secuenciación y composición del RNA             | Comparación entre muestras y análisis de expresión diferencial                                        |

[^1]

DESeq2 utiliza el método conocido como **median of ratios**. Este método estima un factor de tamaño para cada muestra comparando los conteos de cada gen contra una referencia construida a partir de la media geométrica de los conteos. Después, cada muestra se ajusta mediante su propio factor de tamaño. Esta estrategia permite corregir diferencias en la profundidad de secuenciación y en la composición global del RNA, lo cual es especialmente importante para el análisis de expresión diferencial.

En DESeq2 no es necesario corregir por longitud génica para probar expresión diferencial, porque el análisis compara el mismo gen entre condiciones. La longitud de ese gen es la misma en todas las muestras, por lo que no explica por sí sola las diferencias observadas entre tratamiento y control. En cambio, sí es necesario corregir por diferencias entre muestras, como profundidad de secuenciación y composición global de los conteos.

Por el contrario, TPM, FPKM y RPKM son métricas descriptivas de abundancia que consideran la longitud del gen o transcrito. Estas métricas pueden ser útiles cuando queremos explorar la expresión de genes individuales, comparar la abundancia relativa de distintos genes dentro de una muestra o generar visualizaciones complementarias. Sin embargo, no deben usarse como entrada para DESeq2 ni como sustituto del análisis diferencial.

TPM suele preferirse sobre RPKM/FPKM cuando se desea una métrica descriptiva más comparable entre muestras, porque en TPM la suma de los valores por muestra se escala a un total común. En RPKM/FPKM, la suma total de valores normalizados puede diferir entre muestras, lo que dificulta comparaciones directas entre muestras. Por esta razón, RPKM y FPKM deben interpretarse con mayor cautela, especialmente cuando se busca comparar valores entre condiciones.

---

## Entonces, ¿es válido incorporar en un mismo estudio la normalización de DESeq2 junto con TPM, FPKM y RPKM?

Sí, siempre que se usen de manera complementaria y no como si fueran equivalentes. En un mismo análisis podemos usar DESeq2 para identificar genes diferencialmente expresados y, además, calcular TPM, FPKM o RPKM para describir la abundancia de genes individuales, revisar tendencias, generar gráficas exploratorias o comparar cómo cambia la interpretación visual según la métrica utilizada.

La clave es separar la pregunta estadística de la pregunta descriptiva. Si la pregunta es: “¿este gen cambia significativamente entre tratamiento y control?”, la respuesta debe basarse en DESeq2, usando `log2FoldChange`, `pvalue` y `padj`. Si la pregunta es: “¿qué tan abundante es este gen?” o “¿cómo se observa su expresión usando una métrica que considera longitud génica?”, entonces pueden usarse TPM, FPKM o RPKM como apoyo descriptivo.

Por lo tanto, en este cuaderno usaremos los conteos normalizados por DESeq2 para explorar la expresión de genes individuales entre muestras y usaremos TPM, FPKM y RPKM como métricas complementarias de abundancia. Esta comparación no reemplaza el análisis diferencial, sino que ayuda a comprender mejor el comportamiento de genes seleccionados desde diferentes perspectivas de normalización.


> **Idea clave:** DESeq2 responde la pregunta estadística de expresión diferencial. TPM, FPKM y RPKM ayudan a describir la abundancia de genes o transcritos. Pueden incorporarse en un mismo estudio de manera complementaria, pero las conclusiones sobre genes diferencialmente expresados deben basarse en DESeq2.

---

# 9. Expresión de genes individuales y métricas descriptivas de abundancia

Una forma útil de conectar los resultados globales con datos por muestra es graficar un gen individual. En esta sección usaremos dos aproximaciones complementarias:

1. **`plotCounts()`**, que permite visualizar conteos normalizados por DESeq2 para un gen específico.
2. Una tabla extendida con **conteos crudos, conteos normalizados, RPKM, FPKM y TPM**, que permite comparar diferentes formas descriptivas de abundancia.

> **Idea clave:** estas métricas son útiles para exploración, visualización y reporte descriptivo. No sustituyen el análisis diferencial de DESeq2, que se realiza con conteos crudos y el modelo estadístico de DESeq2.

---

## 9.1 Elegir un gen de interés

Podemos elegir el gen con menor `padj` que tenga símbolo conocido:

```r
gen_interes <- res_df %>%
  filter(!is.na(padj), !is.na(symbol)) %>%
  arrange(padj) %>%
  slice(1) %>%
  pull(ensembl_id)

gen_interes
```

También podemos elegir manualmente un gen de interés biológico. Por ejemplo:

```r
# Ejemplo: elegir manualmente por símbolo
res_df %>%
  filter(symbol == "CRISPLD2") %>%
  select(ensembl_id, symbol, log2FoldChange, pvalue, padj)
```

Si el gen existe en la tabla, podemos guardar su `ensembl_id`:

```r
gen_interes <- res_df %>%
  filter(symbol == "CRISPLD2") %>%
  slice(1) %>%
  pull(ensembl_id)
```

---

## 9.2 Graficar conteos normalizados con `plotCounts()`

`plotCounts()` extrae conteos normalizados por DESeq2 para un gen específico. Es una forma sencilla de ver cómo se comporta un gen en cada muestra.

```r
datos_gen <- plotCounts(
  dds,
  gene = gen_interes,
  intgroup = c("dex", "cell"),
  returnData = TRUE
)

head(datos_gen)
```

Graficamos:

```r
p_gen_counts <- ggplot(datos_gen, aes(x = dex, y = count, color = dex)) +
  geom_point(size = 3, alpha = 0.8) +
  facet_wrap(~ cell) +
  labs(
    title = paste("Conteos normalizados del gen:", gen_interes),
    x = "Condición",
    y = "Conteos normalizados por DESeq2"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

p_gen_counts
```

Guardar:

```r
ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/conteos_normalizados_gen_individual_airway.pdf",
  plot = p_gen_counts,
  width = 8,
  height = 5
)
```

Ahora graficamos con el símbolo del gen:

```r
symbol_gen <- res_df %>%
  filter(ensembl_id == gen_interes) %>%
  pull(symbol) %>%
  unique()

symbol_gen <- symbol_gen[!is.na(symbol_gen)]

if (length(symbol_gen) == 0) {
  symbol_gen <- gen_interes
} else {
  symbol_gen <- symbol_gen[1]
}

p_gen_counts_symbol <- ggplot(datos_gen, aes(x = dex, y = count, color = dex)) +
  geom_jitter(width = 0.1, height = 0, size = 3, alpha = 0.8) +
  facet_wrap(~ cell) +
  labs(
    title = paste("Conteos normalizados del gen:", symbol_gen),
    subtitle = paste("Ensembl ID:", gen_interes),
    x = "Condición",
    y = "Conteos normalizados por DESeq2"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

p_gen_counts_symbol
```

Aunque usamos el Ensembl ID para extraer el gen de manera precisa, en la gráfica mostramos el símbolo génico porque es más fácil de reconocer e interpretar biológicamente.

Guardar:

```r
ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/conteos_normalizados_gen_individual_symbol_airway.pdf",
  plot = p_gen_counts_symbol,
  width = 8,
  height = 5
)
```

---

## 9.3 Preparar longitudes génicas para RPKM, FPKM y TPM

Para calcular RPKM, FPKM y TPM necesitamos una longitud por gen. En el caso de `airway`, podemos obtener una longitud aproximada a partir de los rangos genómicos incluidos en el objeto original del paquete.

```r
library(airway)
library(SummarizedExperiment)
library(GenomicRanges)
library(IRanges)
library(S4Vectors)

data("airway")

# Genes que están actualmente en el objeto dds
genes_dds <- rownames(dds)

# Tomar solo los rangos genómicos de los genes presentes en dds
gene_ranges_dds <- rowRanges(airway)[genes_dds]

# Reducir regiones traslapadas y calcular longitud por gen
gene_ranges_reduced <- GenomicRanges::reduce(gene_ranges_dds)

gene_lengths_bp <- sum(
  IRanges::width(gene_ranges_reduced)
)

# Convertir a vector numérico y conservar nombres
gene_lengths_bp <- as.numeric(gene_lengths_bp)
names(gene_lengths_bp) <- names(gene_ranges_dds)

```

Agregamos la longitud al objeto `dds` para poder usar `fpkm()` de DESeq2:

```r
# Agregar longitud génica al objeto dds
mcols(dds)$basepairs <- gene_lengths_bp[rownames(dds)]

# Verificar
summary(mcols(dds)$basepairs)
sum(is.na(mcols(dds)$basepairs))
```

> **Nota didáctica:** esta longitud es una aproximación basada en la anotación disponible en `airway`. Para análisis propios, lo ideal es documentar con precisión de dónde provienen las longitudes génicas o cuantificar a nivel de transcrito con herramientas adecuadas.

---

## 9.4 Obtener conteos crudos, conteos normalizados, RPKM, FPKM y TPM

Primero extraemos conteos crudos y conteos normalizados por DESeq2:

```r
counts_raw <- counts(dds, normalized = FALSE)
counts_norm <- counts(dds, normalized = TRUE)
```

Después calculamos FPKM con DESeq2:

```r
fpkm_mat <- fpkm(dds)
```

Para calcular RPKM y TPM manualmente necesitamos dividir por la longitud génica en kilobases:

```r
gene_lengths_kb <- mcols(dds)$basepairs / 1000

genes_validos <- !is.na(gene_lengths_kb) & gene_lengths_kb > 0

genes_validos_id <- rownames(counts_raw)[genes_validos]
counts_valid <- counts_raw[genes_validos_id, , drop = FALSE]

gene_lengths_kb_valid <- gene_lengths_kb[genes_validos]

# Reads/fragments per kilobase
rpk <- sweep(
  counts_valid,
  1,
  gene_lengths_kb_valid,
  "/"
)

# RPKM: divide por tamaño de biblioteca en millones
library_size_millions <- colSums(counts_raw) / 1e6

rpkm_mat <- sweep(
  rpk,
  2,
  library_size_millions,
  "/"
)

# TPM: normaliza el total de RPK de cada muestra a un millón
scaling_factors <- colSums(rpk) / 1e6

tpm_mat <- sweep(
  rpk,
  2,
  scaling_factors,
  "/"
)

# Verificación: cada muestra debe sumar aproximadamente un millón en TPM
colSums(tpm_mat)
```

---

## 9.5 Generar un dataframe integrado con todas las métricas

Para graficar y guardar de manera ordenada, convertimos las matrices a formato largo y unimos la anotación de genes y los metadatos de las muestras.

```r
matriz_a_largo <- function(mat, nombre_metrica) {
  as.data.frame(mat) %>%
    rownames_to_column("ensembl_id") %>%
    pivot_longer(
      cols = -ensembl_id,
      names_to = "sample_id",
      values_to = nombre_metrica
    )
}

genes_validos_id <- rownames(counts_raw)[genes_validos]

raw_long <- matriz_a_largo(counts_raw[genes_validos_id, ], "conteos_crudos")
norm_long <- matriz_a_largo(counts_norm[genes_validos_id, ], "conteos_normalizados_DESeq2")
rpkm_long <- matriz_a_largo(rpkm_mat, "RPKM")
fpkm_long <- matriz_a_largo(fpkm_mat[genes_validos_id, ], "FPKM")
tpm_long <- matriz_a_largo(tpm_mat, "TPM")

metadata_df <- as.data.frame(colData(dds)) %>%
  rownames_to_column("sample_id")

anotacion_genes <- res_df %>%
  dplyr::select(
    ensembl_id,
    symbol,
    entrezid,
    gene_name,
    log2FoldChange,
    pvalue,
    padj,
    categoria
  ) %>%
  distinct(ensembl_id, .keep_all = TRUE)










metricas_expresion_df <- raw_long %>%
  left_join(norm_long, by = c("ensembl_id", "sample_id")) %>%
  left_join(rpkm_long, by = c("ensembl_id", "sample_id")) %>%
  left_join(fpkm_long, by = c("ensembl_id", "sample_id")) %>%
  left_join(tpm_long, by = c("ensembl_id", "sample_id")) %>%
  left_join(anotacion_genes, by = "ensembl_id") %>%
  left_join(metadata_df, by = "sample_id")

head(metricas_expresion_df)


```

La tabla resultante contiene una fila por **gen–muestra** y columnas con diferentes métricas de expresión.

---

## 9.6 Guardar la tabla como CSV

```r
write.csv(
  metricas_expresion_df,
  file = "data/resultados/metricas_expresion_airway_RPKM_FPKM_TPM.csv",
  row.names = FALSE
)


```

Verificamos:

```r
file.exists("data/resultados/metricas_expresion_airway_RPKM_FPKM_TPM.csv")
```

---

## 9.7 Graficar un gen individual usando RPKM, FPKM y TPM

Primero filtramos la tabla para el gen de interés:

```r
metricas_gen <- metricas_expresion_df %>%
  filter(ensembl_id == gen_interes)

metricas_gen %>%
  select(ensembl_id, symbol, sample_id, dex, cell,
         conteos_normalizados_DESeq2, RPKM, FPKM, TPM) %>%
  head()
```

Convertimos las métricas a formato largo:

```r
metricas_gen_largo <- metricas_gen %>%
  dplyr::select(
    ensembl_id,
    symbol,
    sample_id,
    dex,
    cell,
    conteos_normalizados_DESeq2,
    RPKM,
    FPKM,
    TPM
  ) %>%
  pivot_longer(
    cols = c(conteos_normalizados_DESeq2, RPKM, FPKM, TPM),
    names_to = "metrica",
    values_to = "valor"
  )
```

Graficamos con escalas libres porque cada métrica puede tener rangos diferentes:

```r
p_gen_metricas <- ggplot(metricas_gen_largo, aes(x = dex, y = valor, color = dex)) +
  geom_jitter(width = 0.1, size = 3, alpha = 0.8) +
  stat_summary(fun = mean, geom = "point", size = 4) +
  facet_grid(metrica ~ cell, scales = "free_y") +
  labs(
    title = paste("Métricas de expresión para:", unique(metricas_gen_largo$symbol)),
    subtitle = gen_interes,
    x = "Condición",
    y = "Valor de expresión"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

p_gen_metricas
```

Guardar:

```r
ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/metricas_RPKM_FPKM_TPM_gen_individual_airway.pdf",
  plot = p_gen_metricas,
  width = 10,
  height = 8
)
```

---

## 9.8 Interpretación

Este análisis permite observar cómo se comporta un gen específico usando distintas escalas de expresión.

Preguntas:

1. ¿El patrón entre tratado y no tratado se mantiene al usar conteos normalizados, RPKM, FPKM y TPM?
2. ¿Cambian las magnitudes aunque el patrón general sea similar?
3. ¿Por qué no usamos RPKM, FPKM o TPM como entrada para `DESeq2`?
4. ¿Qué métrica usarías para describir abundancia y cuál para inferencia estadística?
5. ¿El patrón del gen individual es consistente con su `log2FoldChange`?

Frase de cierre para esta sección:

> **Los conteos normalizados, RPKM, FPKM y TPM ayudan a describir la expresión; el cambio diferencial se interpreta desde el modelo estadístico de DESeq2.**

---

# 
# 10. ¿Qué es un análisis de enriquecimiento funcional?

Un análisis de enriquecimiento funcional busca responder una pregunta general:

> Entre mis genes de interés, ¿hay funciones, procesos o rutas que aparecen más de lo esperado?

En lugar de interpretar gen por gen, el enriquecimiento funcional agrupa la información en términos biológicos.

## 10.1 Ejemplo conceptual

Supongamos que tenemos una lista de 100 genes inducidos por dexametasona. Si muchos de esos genes están relacionados con “respuesta a glucocorticoides”, “respuesta inflamatoria” o “regulación de transcripción”, podríamos decir que esos procesos están sobrerrepresentados.

## 10.2 ¿Qué no significa enriquecimiento?

Un término enriquecido **no significa automáticamente**:

- que todos los genes de esa vía estén cambiando;
- que el proceso esté activado funcionalmente;
- que exista causalidad;
- que el proceso sea exclusivo de nuestra condición;
- que el resultado esté validado experimentalmente.

El enriquecimiento funcional ayuda a formular hipótesis y organizar la interpretación.

---

# 11. Enfoques principales: ORA, GSEA y análisis de rutas

## 11.1 ORA: Over-Representation Analysis

El análisis de sobrerrepresentación parte de una lista de genes seleccionados.

```text
genes significativos
↓
lista Up o Down
↓
prueba de sobrerrepresentación
↓
términos GO o rutas KEGG enriquecidas
```

Ventajas:

- es simple;
- es fácil de explicar;
- funciona bien para prácticas introductorias;
- es rápido.

Limitaciones:

- depende mucho del umbral usado;
- ignora genes que no pasan el corte;
- puede perder señales sutiles pero coordinadas.

## 11.2 GSEA: Gene Set Enrichment Analysis

GSEA usa una lista ordenada de todos los genes.

```text
todos los genes ordenados por log2FC o estadístico
↓
evaluación de acumulación de genes por conjunto
↓
términos enriquecidos hacia extremos del ranking
```

Ventajas:

- no depende de un corte;
- detecta cambios coordinados más sutiles;
- es útil cuando pocos genes individuales son significativos.

Limitaciones:

- requiere más cuidado en preparación del ranking;
- puede ser menos intuitivo al inicio;
- la interpretación requiere entender el sentido del enriquecimiento.

## 11.3 Análisis basado en rutas

Las bases como KEGG organizan genes en rutas metabólicas o de señalización. Podemos preguntar si nuestros genes están sobrerrepresentados en esas rutas y, adicionalmente, visualizar los genes sobre mapas de rutas.

---

# 12. Gene Ontology: BP, MF y CC

Gene Ontology, o GO, organiza anotaciones génicas en tres categorías principales.

| Categoría | Nombre             | Qué describe            |
| --------- | ------------------ | ----------------------- |
| BP        | Biological Process | Procesos biológicos     |
| MF        | Molecular Function | Actividades moleculares |
| CC        | Cellular Component | Localización celular    |

En estudios transcriptómicos, es frecuente comenzar con:

```text
ont = "BP"
```

porque los procesos biológicos suelen ser más interpretables para conectar con la pregunta experimental.

Ejemplos de términos BP podrían ser:

- response to hormone;
- inflammatory response;
- regulation of transcription;
- extracellular matrix organization;
- cell migration;
- apoptotic process.

---

# 13. Preparación de listas génicas para ORA

En esta práctica usaremos la tabla `res_df` generada en Unidad 8.

## 13.1 Seleccionar genes significativos

Criterio principal recomendado:

```r
sig_genes <- res_df %>%
  filter(
    !is.na(padj),
    padj < 0.05,
    abs(log2FoldChange) > 1,
    !is.na(entrezid)
  )
```

## 13.2 Separar genes Up y Down

```r
genes_up <- sig_genes %>%
  filter(log2FoldChange > 1) %>%
  pull(entrezid) %>%
  unique()

genes_down <- sig_genes %>%
  filter(log2FoldChange < -1) %>%
  pull(entrezid) %>%
  unique()

length(genes_up)
length(genes_down)
```

## 13.3 Si hay pocos genes

En algunos datasets o con ciertos umbrales, las listas pueden quedar pequeñas. Para fines didácticos se puede relajar el umbral de magnitud, manteniendo `padj < 0.05`:

```r
sig_genes_flexible <- res_df %>%
  filter(
    !is.na(padj),
    padj < 0.05,
    abs(log2FoldChange) > 0.5,
    !is.na(entrezid)
  )
```

También se puede explorar un criterio con `pvalue`, como se muestra en algunas prácticas introductorias, pero debe hacerse con cautela:

```r
sig_genes_exploratorio <- res_df %>%
  filter(
    !is.na(pvalue),
    pvalue < 0.05,
    abs(log2FoldChange) > 1,
    !is.na(entrezid)
  )
```

## 13.4 Advertencia sobre `pvalue` vs `padj`

El `pvalue` sin ajustar puede incluir más genes, pero aumenta el riesgo de falsos positivos. Para análisis reales se recomienda usar `padj` o FDR.

En una práctica didáctica puede mostrarse el contraste entre ambos criterios para discutir cómo cambian los resultados.

---

# 14. Universo de fondo: un punto crítico

El universo de fondo es el conjunto de genes contra el cual se evalúa la sobrerrepresentación.

No debería ser “todo el genoma” de forma automática. Debe representar los genes que tuvieron oportunidad de ser detectados y evaluados en el análisis.

Para nuestro caso:

```r
universo <- res_df %>%
  filter(!is.na(entrezid)) %>%
  pull(entrezid) %>%
  unique()

length(universo)
```

## 14.1 ¿Por qué importa el universo?

Imagina que evaluaste 15,000 genes, pero usas como universo los 25,000 genes anotados en una base de datos. Estarías comparando contra genes que quizá nunca pudieron detectarse en tu experimento.

Esto puede distorsionar los resultados.

## 14.2 Buen principio

> El universo debe representar los genes medidos y evaluables en tu análisis.

---

# 15. Análisis GO con `enrichGO()` para genes Up

## 15.1 Ejecutar análisis

```r
ego_up <- enrichGO(
  gene = genes_up,
  universe = universo,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.2,
  readable = TRUE
)

ego_up
```

## 15.2 Revisar resultados

```r
head(ego_up)
```

También podemos convertir a tabla:

```r
ego_up_df <- as.data.frame(ego_up)

head(ego_up_df)
```

## 15.3 Guardar resultados

```r
write.csv(
  ego_up_df,
  file = "resultados/GO_BP_genes_up_airway.csv",
  row.names = FALSE
)
```

## 15.4 Columnas importantes

| Columna       | Significado                                           |
| ------------- | ----------------------------------------------------- |
| `ID`          | Identificador del término GO                          |
| `Description` | Nombre del proceso biológico                          |
| `GeneRatio`   | Proporción de genes de tu lista asociados al término  |
| `BgRatio`     | Proporción de genes del universo asociados al término |
| `pvalue`      | Significancia sin ajuste                              |
| `p.adjust`    | Significancia ajustada                                |
| `qvalue`      | Estimación relacionada con FDR                        |
| `geneID`      | Genes de tu lista asociados al término                |
| `Count`       | Número de genes de tu lista asociados al término      |

---

# 16. Análisis GO con `enrichGO()` para genes Down

Repetimos el mismo flujo para genes reprimidos por dexametasona.

```r
ego_down <- enrichGO(
  gene = genes_down,
  universe = universo,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.2,
  readable = TRUE
)

ego_down
```

Convertir y guardar:

```r
ego_down_df <- as.data.frame(ego_down)

write.csv(
  ego_down_df,
  file = "resultados/GO_BP_genes_down_airway.csv",
  row.names = FALSE
)
```

## 16.1 Preguntas de comparación

1. ¿Cuántos términos enriquecidos aparecen en genes Up?
2. ¿Cuántos términos enriquecidos aparecen en genes Down?
3. ¿Los términos Up y Down parecen reflejar procesos diferentes?
4. ¿Hay términos redundantes?
5. ¿Qué términos son biológicamente coherentes con dexametasona y ASM?

---

# 17. Visualización de resultados GO: dotplot y barplot

## 17.1 Dotplot

```r
p_dot_up <- dotplot(
  ego_up,
  showCategory = 15
) +
  ggtitle("GO BP: procesos enriquecidos en genes Up")

p_dot_up
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/dotplot_GO_up_airway.pdf",
  plot = p_dot_up,
  width = 9,
  height = 6
)
```

## 17.2 ¿Cómo leer un dotplot?

En un dotplot de enriquecimiento:

- el eje Y muestra términos GO;
- el eje X muestra `GeneRatio`;
- el tamaño del punto muestra `Count`;
- el color suele representar `p.adjust`.

Preguntas para interpretar:

1. ¿Qué término tiene mayor `GeneRatio`?
2. ¿Qué término tiene menor `p.adjust`?
3. ¿Qué término tiene mayor `Count`?
4. ¿Los términos son específicos o muy generales?
5. ¿Hay términos redundantes?

## 17.3 Barplot

```r
p_bar_up <- barplot(
  ego_up,
  showCategory = 15,
  title = "GO BP: genes Up"
)

p_bar_up
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/barplot_GO_up_airway.pdf",
  plot = p_bar_up,
  width = 9,
  height = 6
)
```

## 17.4 Visualizar genes Down

```r
p_dot_down <- dotplot(
  ego_down,
  showCategory = 15
) +
  ggtitle("GO BP: procesos enriquecidos en genes Down")

p_dot_down
```

```r
ggsave(
  filename = "figuras/enriquecimiento/dotplot_GO_down_airway.pdf",
  plot = p_dot_down,
  width = 9,
  height = 6
)
```

---

# 18. Visualizaciones de red: emapplot, cnetplot y heatplot

Algunas visualizaciones funcionales ayudan a explorar relaciones entre términos y genes.

## 18.1 Similitud semántica con `pairwise_termsim()`

Para usar `emapplot()`, primero calculamos similitud entre términos.

```r
ego_up_sim <- pairwise_termsim(ego_up)
```

## 18.2 Emapplot

```r
p_emap_up <- emapplot(
  ego_up_sim,
  showCategory = 15
) +
  ggtitle("Mapa de términos GO relacionados: genes Up")

p_emap_up
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/emapplot_GO_up_airway.pdf",
  plot = p_emap_up,
  width = 9,
  height = 7
)
```

## 18.3 ¿Cómo interpretar emapplot?

- Cada nodo representa un término enriquecido.
- Las conexiones indican similitud semántica.
- Los grupos de nodos sugieren procesos funcionalmente relacionados.
- Términos muy conectados pueden ser redundantes o formar una familia funcional.

## 18.4 Cnetplot

`cnetplot()` conecta genes con términos enriquecidos.

```r
p_cnet_up <- cnetplot(
  ego_up,
  showCategory = 5,
  circular = FALSE
)

p_cnet_up
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/cnetplot_GO_up_airway.pdf",
  plot = p_cnet_up,
  width = 10,
  height = 8
)
```

## 18.5 Vector de fold change para colorear genes

Para algunas visualizaciones, como `heatplot()` o `cnetplot()` con fold change, necesitamos un vector nombrado.

```r
gene_fc_symbol <- res_df %>%
  filter(!is.na(symbol), !is.na(log2FoldChange)) %>%
  distinct(symbol, .keep_all = TRUE)

fc_vector_symbol <- gene_fc_symbol$log2FoldChange
names(fc_vector_symbol) <- gene_fc_symbol$symbol
```

## 18.6 Heatplot

```r
p_heat_up <- heatplot(
  ego_up,
  foldChange = fc_vector_symbol,
  showCategory = 10
)

p_heat_up
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/heatplot_GO_up_airway.pdf",
  plot = p_heat_up,
  width = 10,
  height = 7
)
```

## 18.7 ¿Cómo interpretar heatplot?

El heatplot muestra qué genes contribuyen a qué términos funcionales. Puede ayudar a identificar genes que participan en varios términos y procesos que comparten genes.

No debe interpretarse como un heatmap de expresión por muestra. Es una visualización de relación entre genes y términos funcionales.

---

# 19. Comparación funcional entre genes Up y Down

`compareCluster()` permite comparar enriquecimiento funcional entre varias listas.

## 19.1 Preparar listas

```r
lista_genes <- list(
  Up = genes_up,
  Down = genes_down
)
```

## 19.2 Ejecutar comparación

```r
ego_comparado <- compareCluster(
  geneCluster = lista_genes,
  fun = "enrichGO",
  universe = universo,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.2
)
```

## 19.3 Visualizar

```r
p_compare <- dotplot(
  ego_comparado,
  showCategory = 10
) +
  ggtitle("Comparación funcional: genes Up vs Down")

p_compare
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/compareCluster_GO_Up_Down_airway.pdf",
  plot = p_compare,
  width = 10,
  height = 7
)
```

## 19.4 Preguntas

1. ¿Qué procesos aparecen principalmente en genes Up?
2. ¿Qué procesos aparecen principalmente en genes Down?
3. ¿Hay procesos compartidos?
4. ¿Qué interpretación biológica cautelosa puede formularse?
5. ¿Qué términos requerirían revisión bibliográfica?

---

# 20. Enriquecimiento de rutas KEGG con `enrichKEGG()`

Además de GO, podemos analizar rutas KEGG.

## 20.1 ¿Qué es KEGG?

KEGG organiza genes en rutas biológicas, metabólicas y de señalización. En lugar de términos amplios, KEGG permite explorar rutas específicas.

Ejemplos generales:

- vías de señalización;
- metabolismo;
- respuesta inmune;
- enfermedades;
- rutas relacionadas con fármacos.

## 20.2 KEGG para genes Up

```r
ekegg_up <- enrichKEGG(
  gene = genes_up,
  universe = universo,
  organism = "hsa",
  pvalueCutoff = 0.05
)

ekegg_up
```

Convertir a nombres legibles puede requerir:

```r
ekegg_up_readable <- setReadable(
  ekegg_up,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID"
)
```

## 20.3 Guardar resultados

```r
ekegg_up_df <- as.data.frame(ekegg_up_readable)

write.csv(
  ekegg_up_df,
  file = "resultados/KEGG_genes_up_airway.csv",
  row.names = FALSE
)
```

## 20.4 Visualizar KEGG

```r
p_kegg_up <- dotplot(
  ekegg_up,
  showCategory = 10
) +
  ggtitle("KEGG: rutas enriquecidas en genes Up")

p_kegg_up
```

Guardar:

```r
ggsave(
  filename = "figuras/kegg/dotplot_KEGG_up_airway.pdf",
  plot = p_kegg_up,
  width = 9,
  height = 6
)
```

## 20.5 KEGG para genes Down

```r
ekegg_down <- enrichKEGG(
  gene = genes_down,
  universe = universo,
  organism = "hsa",
  pvalueCutoff = 0.05
)

ekegg_down_readable <- setReadable(
  ekegg_down,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID"
)

write.csv(
  as.data.frame(ekegg_down_readable),
  file = "resultados/KEGG_genes_down_airway.csv",
  row.names = FALSE
)
```

## 20.6 Consideración importante

`enrichKEGG()` puede requerir conexión a internet para consultar anotaciones actualizadas. Si no funciona durante la sesión, se puede continuar con GO y dejar KEGG como demostración o actividad posterior.

---

# 21. Visualización de rutas KEGG con `pathview()`

`pathview()` permite proyectar cambios de expresión sobre una ruta KEGG específica.

## 21.1 Preparar vector de expresión

Para `pathview()`, necesitamos un vector donde:

- nombres = Entrez IDs;
- valores = `log2FoldChange`.

```r
gene_fc_df <- res_df %>%
  filter(!is.na(entrezid), !is.na(log2FoldChange)) %>%
  distinct(entrezid, .keep_all = TRUE)

gene_fc_vector <- gene_fc_df$log2FoldChange
names(gene_fc_vector) <- gene_fc_df$entrezid
```

## 21.2 Elegir una ruta

Si `ekegg_up` tiene resultados, puedes revisar:

```r
as.data.frame(ekegg_up) %>%
  select(ID, Description, p.adjust, Count) %>%
  head()
```

Luego elige un `ID` de ruta.

Por ejemplo, si existe una ruta con ID `"hsa04010"`:

```r
pathview(
  gene.data = gene_fc_vector,
  pathway.id = "hsa04010",
  species = "hsa",
  out.suffix = "airway",
  limit = list(gene = 2, cpd = 1)
)
```

## 21.3 Advertencia

No todas las rutas KEGG estarán enriquecidas. No conviene elegir una ruta solo porque “se ve interesante”. Lo ideal es elegir una ruta que aparezca en el resultado de `enrichKEGG()` o que esté justificada por la pregunta biológica.

## 21.4 ¿Qué produce `pathview()`?

El paquete genera archivos de imagen en tu directorio de trabajo, generalmente `.png`. Estos archivos muestran genes coloreados según su cambio de expresión.

## 21.5 Entornos gráficos para ORA

Existen varias herramientas de entorno gráfico para realizar análisis de ORA, entre ellos uno que resalta por practicidad y funcionalidad es EnrichR:

[https://maayanlab.cloud/Enrichr/][32]

---

# 22. Demostración breve de GSEA

ORA depende de una lista cortada de genes. GSEA usa una lista ordenada de todos los genes.

## 22.1 Preparar ranking

Podemos ordenar genes por `log2FoldChange`.

```r
gene_list_df <- res_df %>%
  filter(
    !is.na(entrezid),
    !is.na(log2FoldChange)
  ) %>%
  distinct(entrezid, .keep_all = TRUE)

gene_list <- gene_list_df$log2FoldChange
names(gene_list) <- gene_list_df$entrezid

gene_list <- sort(gene_list, decreasing = TRUE)
```

## 22.2 Ejecutar `gseGO()`

```r
gsea_go <- gseGO(
  geneList = gene_list,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  minGSSize = 10,
  maxGSSize = 500,
  pvalueCutoff = 0.05,
  verbose = FALSE
)

gsea_go
```

## 22.3 Visualizar resultados

```r
p_gsea_dot <- dotplot(
  gsea_go,
  showCategory = 10
) +
  ggtitle("GSEA GO BP: airway")

p_gsea_dot
```

Guardar:

```r
ggsave(
  filename = "figuras/enriquecimiento/dotplot_GSEA_GO_airway.pdf",
  plot = p_gsea_dot,
  width = 9,
  height = 6
)
```

## 22.4 Gráfico de un término

```r
gseaplot2(
  gsea_go,
  geneSetID = 1,
  title = gsea_go@result$Description[1]
)
```

## 22.5 ¿Cómo explicar GSEA?

> “ORA pregunta qué procesos aparecen en mi lista de genes significativos. GSEA pregunta si los genes de un proceso tienden a acumularse hacia los extremos de una lista ordenada de todos los genes.”

## 22.6 Precaución

En esta sesión GSEA se presenta como demostración breve. No es necesario dominar todos sus parámetros. Lo importante es entender cuándo conviene usarlo y cómo se diferencia de ORA.

---

# 23. Interpretación biológica cautelosa

Después del enriquecimiento funcional, es tentador escribir conclusiones fuertes. Debemos evitarlo.

## 23.1 Niveles de afirmación

| Nivel               | Ejemplo                                                                 |
| ------------------- | ----------------------------------------------------------------------- |
| Resultado           | “Se encontraron términos GO enriquecidos relacionados con X.”           |
| Interpretación      | “Estos términos sugieren que X podría estar modulado por dexametasona.” |
| Hipótesis           | “Dexametasona podría regular procesos asociados con X en ASM.”          |
| Sobreinterpretación | “Dexametasona causa directamente X mediante todos estos genes.”         |

## 23.2 Qué sí podemos decir

- “Los genes inducidos por dexametasona muestran enriquecimiento en...”
- “Los resultados sugieren procesos asociados con...”
- “Estos términos podrían orientar hipótesis sobre...”
- “Se requiere revisión bibliográfica y validación experimental.”

## 23.3 Qué no debemos decir sin más evidencia

- “La vía está activada.”
- “El proceso está causalmente demostrado.”
- “Este gen explica el fenotipo.”
- “El tratamiento funciona por esta vía.”
- “Todos los genes de la ruta están regulados.”

## 23.4 Preguntas de control

Antes de interpretar un término, pregunta:

1. ¿Cuántos genes lo sostienen?
2. ¿Qué genes aparecen?
3. ¿El término es específico o muy general?
4. ¿El resultado usa `p.adjust`?
5. ¿El término se repite con nombres similares?
6. ¿Tiene sentido con el modelo experimental?
7. ¿Requiere apoyo bibliográfico?

---

# 24. IA y R: uso como acompañante para revisar código

En esta unidad, la IA se usará como apoyo para código, no como intérprete biológico automático.

## 24.1 Usos adecuados

La IA puede ayudarte a:

- revisar errores de sintaxis;
- identificar objetos no creados;
- revisar nombres de columnas;
- explicar mensajes de error;
- comentar bloques de código;
- adaptar código didáctico a otros archivos;
- sugerir formas de verificar resultados.

## 24.2 Usos que debemos evitar

No conviene pedirle a la IA que:

- invente resultados;
- interprete enriquecimientos sin ver tablas;
- haga afirmaciones biológicas sin evidencia;
- reemplace la documentación;
- decida umbrales sin contexto;
- concluya causalidad.

## 24.3 Prompt para revisar código de enriquecimiento funcional

```text
Actúa como tutor de R para análisis transcriptómico.

Estoy trabajando con resultados de DESeq2 del caso airway y quiero revisar mi código de enriquecimiento funcional.

Mi flujo incluye:
1. Cargar res_deseq2_airway_anotado.csv.
2. Separar genes Up y Down.
3. Preparar listas de Entrez IDs.
4. Definir un universo de fondo.
5. Ejecutar enrichGO().
6. Ejecutar enrichKEGG().
7. Visualizar con dotplot(), barplot(), emapplot(), cnetplot() o heatplot().

Este es mi código:

[PEGA AQUÍ TU CÓDIGO]

Este es el error o duda:

[PEGA AQUÍ EL ERROR O TU DUDA]

Por favor:
1. Revisa errores de sintaxis.
2. Revisa si los objetos se crean antes de usarse.
3. Revisa si los nombres de columnas coinciden con mi tabla.
4. Revisa si estoy usando correctamente ENTREZID.
5. Revisa si definí adecuadamente el universo de fondo.
6. Sugiere una corrección mínima.
7. No inventes genes, columnas, rutas ni resultados.
8. Dime cómo comprobar en R que la corrección funcionó.
```

## 24.4 Prompt para explicar un error

```text
Actúa como tutor de R para principiantes.

Estoy usando clusterProfiler para análisis de enriquecimiento funcional.
Me apareció este error:

[PEGA AQUÍ EL ERROR]

Este es el código que lo produjo:

[PEGA AQUÍ EL CÓDIGO]

Explícame:
1. Qué significa el error en palabras sencillas.
2. Cuál es la causa más probable.
3. Qué objeto o columna debo revisar.
4. Qué cambio mínimo puedo hacer.
5. Cómo verifico que la solución funcionó.

No inventes objetos ni resultados.
```

## 24.5 Prompt para adaptar el flujo a un proyecto propio

```text
Tengo este código didáctico hecho con airway:

[PEGA AQUÍ EL CÓDIGO]

Quiero adaptarlo a mi propio análisis de RNA-seq.
Mi tabla de resultados tiene estas columnas:

[PEGA AQUÍ colnames(mi_tabla)]

Mi comparación biológica es:

[DESCRIBE TU COMPARACIÓN]

Ayúdame a identificar qué partes del código debo cambiar para:
1. Filtrar genes significativos.
2. Separar Up y Down.
3. Preparar ENTREZ IDs.
4. Ejecutar enrichGO().
5. Visualizar resultados.

No inventes columnas. Si falta información, pregúntame exactamente qué debo revisar.
```

---

# 25. Actividades de práctica

## Actividad 1. Recapitulación de resultados

Ejecuta:

```r
table(res_df$categoria)

res_df %>%
  filter(!is.na(padj), padj < 0.05) %>%
  summarise(
    n_genes = n(),
    min_padj = min(padj),
    max_abs_log2FC = max(abs(log2FoldChange))
  )
```

Responde:

1. ¿Cuántos genes tienen `padj < 0.05`?
2. ¿Cuántos son Up?
3. ¿Cuántos son Down?
4. ¿Qué criterio usaste para clasificarlos?
5. ¿Qué cambiaría si usas `abs(log2FC) > 0.5`?

---
9. Visualización de resultados, segunda parte

Antes de pasar al enriquecimiento funcional, refinaremos algunas visualizaciones. 

## Actividad 2. Refinar resultados de visualización 

# Volcano plot refinado

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
    subtitle = "Caso didáctico airway",
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
  filename = "figuras/volcano_airway_refinado.pdf",
  plot = p_volcano,
  width = 8,
  height = 6
)
```

## Preguntas de interpretación

1. ¿Qué genes se etiquetan?
2. ¿Qué ocurre si cambias el umbral de etiquetado?
3. ¿Los genes más extremos son necesariamente los más importantes?
4. ¿Qué información aporta el volcano plot antes del enriquecimiento funcional?

---

# Heatmap refinado de genes seleccionados

En Unidad 8 generamos un heatmap de los 30 genes con menor `padj`. En Unidad 9 podemos refinar la selección con ese mismo script.

## Seleccionar genes Up y Down

```r
top_up <- res_df %>%
  filter(categoria == "Up", !is.na(padj)) %>%
  arrange(padj) %>%
  slice_head(n = 20) %>%
  pull(ensembl_id)

top_down <- res_df %>%
  filter(categoria == "Down", !is.na(padj)) %>%
  arrange(padj) %>%
  slice_head(n = 20) %>%
  pull(ensembl_id)

top_genes_ud <- c(top_up, top_down)
```

Si alguna lista queda vacía, usa un criterio más flexible:

```r
top_up <- res_df %>%
  filter(!is.na(padj), padj < 0.05, log2FoldChange > 0.5) %>%
  arrange(padj) %>%
  slice_head(n = 20) %>%
  pull(ensembl_id)

top_down <- res_df %>%
  filter(!is.na(padj), padj < 0.05, log2FoldChange < -0.5) %>%
  arrange(padj) %>%
  slice_head(n = 20) %>%
  pull(ensembl_id)
```

## Preparar matriz

```r
mat <- assay(vsd)[top_genes_ud, , drop = FALSE]
mat_z <- t(scale(t(mat)))
```

## Preparar anotación

```r
annotation_col <- metadata_airway %>%
  select(dex, cell)

rownames(annotation_col) <- rownames(metadata_airway)
```

## Generar heatmap

```r
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Genes Up y Down seleccionados",
  filename = "figuras/heatmap_up_down_airway.pdf",
  width = 7,
  height = 8
)
```

Para visualizar en la sesión:

```r
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Genes Up y Down seleccionados"
)
```

## Preguntas de interpretación

1. ¿Se observa una separación por tratamiento?
2. ¿Se observa una separación por línea celular?
3. ¿Qué genes parecen comportarse de manera coordinada?
4. ¿Qué ocurre si seleccionamos más genes?
5. ¿Qué ocurre si seleccionamos menos genes?

---

## Actividad 3. Preparar listas de genes

Ejecuta:

```r
sig_genes <- res_df %>%
  filter(
    !is.na(padj),
    padj < 0.05,
    abs(log2FoldChange) > 1,
    !is.na(entrezid)
  )

genes_up <- sig_genes %>%
  filter(log2FoldChange > 1) %>%
  pull(entrezid) %>%
  unique()

genes_down <- sig_genes %>%
  filter(log2FoldChange < -1) %>%
  pull(entrezid) %>%
  unique()
```

Responde:

1. ¿Cuántos genes Up tienen Entrez ID?
2. ¿Cuántos genes Down tienen Entrez ID?
3. ¿Cuántos genes se pierden por falta de Entrez ID?
4. ¿Por qué esto importa?

---

## Actividad 4. GO para genes Up

Ejecuta `enrichGO()` para genes Up.

Responde:

1. ¿Cuántos términos aparecen?
2. ¿Cuál es el término con menor `p.adjust`?
3. ¿Qué genes contribuyen a ese término?
4. ¿Ese término es específico o general?
5. ¿Tiene sentido con el caso `airway`?

---

## Actividad 5. GO para genes Down

Repite el análisis con genes Down.

Responde:

1. ¿Aparecen términos diferentes?
2. ¿Qué procesos podrían estar reducidos por dexametasona?
3. ¿Hay términos redundantes?
4. ¿Qué resultado requiere revisión bibliográfica?

---

## Actividad 6. Comparar dotplot y barplot

Genera ambos gráficos.

Completa:

| Gráfico | Qué muestra mejor | Limitación |
| ------- | ----------------- | ---------- |
| Dotplot |                   |            |
| Barplot |                   |            |

---

## Actividad 7. ORA vs GSEA

Completa:

| Método | Entrada | Ventaja | Limitación |
| ------ | ------- | ------- | ---------- |
| ORA    |         |         |            |
| GSEA   |         |         |            |

Responde:

1. ¿Por qué ORA depende del umbral?
2. ¿Por qué GSEA puede detectar cambios sutiles?
3. ¿Cuál usarías para una primera práctica y por qué?

---

## Actividad 8. IA como revisor de código

Toma uno de tus scripts de la Unidad 9 y usa el prompt de revisión.

Después responde:

1. ¿Qué error o mejora detectó la IA?
2. ¿La sugerencia fue correcta?
3. ¿Cómo la verificaste en R?
4. ¿Hubo alguna sugerencia que no aceptaste? ¿Por qué?

---

# 26. Errores frecuentes y diagnóstico

## Error 1. No existe la columna `entrezid`

Verifica:

```r
colnames(res_df)
```

Si no existe, necesitas anotar genes o convertir identificadores.

## Error 2. `enrichGO()` no devuelve resultados

Posibles causas:

- lista de genes muy pequeña;
- IDs incorrectos;
- organismo incorrecto;
- universo mal definido;
- umbral demasiado estricto;
- genes sin anotación GO.

Revisa:

```r
length(genes_up)
head(genes_up)
length(universo)
```

## Error 3. IDs duplicados

Solución:

```r
genes_up <- unique(genes_up)
genes_down <- unique(genes_down)
universo <- unique(universo)
```

## Error 4. Mezclar símbolos con Entrez IDs

Si usas:

```r
keyType = "ENTREZID"
```

entonces la lista debe contener Entrez IDs, no símbolos.

## Error 5. `pathview()` no genera figura

Posibles causas:

- no hay conexión a internet;
- ruta KEGG incorrecta;
- vector sin nombres Entrez;
- directorio sin permisos de escritura.

Verifica:

```r
head(gene_fc_vector)
names(gene_fc_vector)[1:5]
```

## Error 6. `emapplot()` falla

Asegúrate de haber ejecutado:

```r
ego_up_sim <- pairwise_termsim(ego_up)
```

y luego:

```r
emapplot(ego_up_sim)
```

## Error 7. Las etiquetas del dotplot son muy largas

Puedes reducir categorías:

```r
dotplot(ego_up, showCategory = 8)
```

O guardar más grande:

```r
ggsave("figuras/enriquecimiento/dotplot_GO_up_grande.pdf", width = 12, height = 8)
```

## Error 8. Sobreinterpretación

Síntoma:

> “La vía está activada y causa el efecto de dexametasona.”

Corrección:

> “Los genes inducidos por dexametasona muestran enriquecimiento en términos asociados con esa vía, lo que sugiere una posible participación que requiere validación.”


## Error 9. `fpkm()` devuelve error o valores no interpretables

Posibles causas:

- el objeto `dds` no tiene longitudes génicas;
- `mcols(dds)$basepairs` no fue creado;
- las longitudes no están alineadas con `rownames(dds)`;
- estás intentando calcular RPKM/FPKM/TPM sin una longitud válida por gen.

Verifica:

```r
head(mcols(dds)$basepairs)
summary(mcols(dds)$basepairs)
all(rownames(dds) %in% names(gene_lengths_bp))
```

Corrección mínima:

```r
mcols(dds)$basepairs <- gene_lengths_bp[rownames(dds)]
fpkm_mat <- fpkm(dds)
```

---

# 27. Checklist final de la Unidad 9

## Archivos

- [ ]() Cargué `dds_airway.rds`.
- [ ]() Cargué `vsd_airway.rds`.
- [ ]() Cargué `res_deseq2_airway_anotado.csv`.
- [ ]() Verifiqué que existe la columna `entrezid`.
- [ ]() Verifiqué que existe la columna `log2FoldChange`.

## Visualización

- [ ]() Generé volcano plot refinado.
- [ ]() Generé gráfico de gen individual con conteos normalizados.
- [ ]() Calculé RPKM, FPKM y TPM.
- [ ]() Guardé `metricas_expresion_airway_RPKM_FPKM_TPM.csv`.
- [ ]() Generé gráfico de gen individual con métricas descriptivas.
- [ ]() Generé heatmap Up/Down.
- [ ]() Guardé las figuras.

## Enriquecimiento funcional

- [ ]() Preparé genes Up.
- [ ]() Preparé genes Down.
- [ ]() Definí universo de fondo.
- [ ]() Ejecuté `enrichGO()` para Up.
- [ ]() Ejecuté `enrichGO()` para Down.
- [ ]() Generé dotplot.
- [ ]() Generé barplot.
- [ ]() Generé al menos una visualización de red.
- [ ]() Guardé tablas de resultados GO.

## KEGG y GSEA

- [ ]() Ejecuté `enrichKEGG()` o entendí por qué no fue posible.
- [ ]() Preparé vector para `pathview()`.
- [ ]() Comprendí la diferencia entre ORA y GSEA.
- [ ]() Ejecuté o revisé una demostración de `gseGO()`.

## IA y código

- [ ]() Usé IA para revisar código, no para inventar resultados.
- [ ]() Verifiqué en R cualquier sugerencia de la IA.
- [ ]() Documenté al menos un error y su solución.
- [ ]() Puedo explicar qué cambió en mi código y por qué.

---

# 28. Cierre conceptual

En la Unidad 8 identificamos genes diferencialmente expresados. En la Unidad 9 dimos un paso adicional: usamos esos genes para buscar procesos y rutas sobrerrepresentadas.

Este paso permite pasar de una lista de genes a una lectura funcional más integrada, pero requiere cuidado.

La idea central es:

> **El enriquecimiento funcional no demuestra mecanismos; organiza evidencia transcriptómica para generar interpretaciones e hipótesis biológicas.**

Y la frase guía de esta unidad es:

> **R ejecuta el análisis; las bases funcionales organizan los genes; la biología interpreta; la IA acompaña la revisión del código, pero no sustituye el criterio científico.**

[^1]:	[https://hbctraining.github.io/DGE\_workshop\_salmon/lessons/02\_DGE\_count\_normalization.html][31]

[1]:	#1-propósito-de-este-cuaderno
[2]:	#2-objetivos-de-aprendizaje
[3]:	#3-conexión-con-la-unidad-8
[4]:	#4-qué-haremos-en-la-unidad-9
[5]:	#5-preparación-del-ambiente-de-trabajo
[6]:	#6-carga-de-archivos-generados-en-la-unidad-8
[7]:	#7-recapitulación-de-resultados-de-expresión-diferencial
[8]:	#8-normalización-de-conteos-en-rna-seq-deseq2-tpm-fpkm-y-rpkm-como-enfoques-complementarios
[9]:	#9-gr%C3%A1fico-de-expresi%C3%B3n-de-genes-individuales
[10]:	#heatmap-refinado-de-genes-seleccionados
[11]:	#10-qué-es-un-análisis-de-enriquecimiento-funcional
[12]:	#11-enfoques-principales-ora-gsea-y-análisis-de-rutas
[13]:	#12-gene-ontology-bp-mf-y-cc
[14]:	#13-preparación-de-listas-génicas-para-ora
[15]:	#14-universo-de-fondo-un-punto-crítico
[16]:	#15-análisis-go-con-enrichgo-para-genes-up
[17]:	#16-análisis-go-con-enrichgo-para-genes-down
[18]:	#17-visualización-de-resultados-go-dotplot-y-barplot
[19]:	#18-visualizaciones-de-red-emapplot-cnetplot-y-heatplot
[20]:	#19-comparación-funcional-entre-genes-up-y-down
[21]:	#20-enriquecimiento-de-rutas-kegg-con-enrichkegg
[22]:	#21-visualización-de-rutas-kegg-con-pathview
[23]:	#22-demostración-breve-de-gsea
[24]:	#23-interpretación-biológica-cautelosa
[25]:	#24-ia-y-r-uso-como-acompañante-para-revisar-código
[26]:	#25-actividades-de-práctica
[27]:	#26-errores-frecuentes-y-diagnóstico
[28]:	#27-checklist-final-de-la-unidad-9
[29]:	#28-cierre-conceptual
[31]:	https://hbctraining.github.io/DGE_workshop_salmon/lessons/02_DGE_count_normalization.html
[32]:	https://maayanlab.cloud/Enrichr/

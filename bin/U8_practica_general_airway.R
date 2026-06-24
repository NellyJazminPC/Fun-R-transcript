# =============================================================================
# U8_practica_general_airway.R
# Unidad 8 – Expresión diferencial y visualización de resultados
# Curso: Fundamentos de Programación en R para análisis transcriptómicos
# Caso didáctico: airway
# Elaboró: Teresa Ortiz
# Fecha: 24/06/2026
#
# Objetivo general:
#   Ejecutar un flujo básico de análisis de expresión diferencial con DESeq2
#   usando el paquete airway y generar visualizaciones iniciales:
#   PCA, MA plot, volcano plot y heatmap.
#
#
# =============================================================================

# 1. Instalar paquetes

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


# 3. Crear carpetas de trabajo -------------------------------------------------

dir.create("data/datos", showWarnings = FALSE)
dir.create("data/resultados", showWarnings = FALSE)
dir.create("data/resultados/figuras", showWarnings = FALSE)


# 4. Cargar el caso airway -------------------------------------------

# airway es un objeto RangedSummarizedExperiment.
# Contiene conteos de RNA-seq y metadatos de muestras de células ASM tratadas o
# no con dexametasona.

data("airway")

airway


# 5. Extraer conteos crudos y metadatos ----------------------------------------

# Matriz de conteos:
#   filas = genes
#   columnas = muestras

counts_airway <- assay(airway)

# Metadatos:
#   filas = muestras
#   columnas = variables experimentales

metadata_airway <- as.data.frame(colData(airway))

# Exploración inicial
dim(counts_airway)
head(counts_airway[, 1:4])
metadata_airway
colnames(metadata_airway)


# Actividad:
# 1. ¿Cuántos genes hay?
# 2. ¿Cuántas muestras hay?
# 3. ¿Qué columna representa el tratamiento?
# 4. ¿Qué columna representa la línea celular?


# 6. Verificar correspondencia entre conteos y metadatos (indispensable) -----------------------

colnames(counts_airway)
rownames(metadata_airway)

coinciden_muestras <- all(colnames(counts_airway) == rownames(metadata_airway))
coinciden_muestras

if (!coinciden_muestras) {
  stop("Las muestras no coinciden entre conteos y metadatos. Revisa el orden.")
}


# 7. Preparar variables experimentales -----------------------------------------

# En airway:
#   dex = tratamiento
#   untrt = no tratado
#   trt = tratado con dexametasona
#   cell = línea celular

metadata_airway$dex <- factor(metadata_airway$dex, levels = c("untrt", "trt"))
metadata_airway$cell <- factor(metadata_airway$cell)

table(metadata_airway$dex)
table(metadata_airway$cell)

# Guardar datos de respaldo
write.csv(
  counts_airway,
  file = "data/datos/airway_counts_raw.csv"
)

write.csv(
  metadata_airway,
  file = "data/datos/airway_metadata.csv"
)


# 8. Construir objeto DESeqDataSet ---------------------------------------------

# Diseño:
#   ~ cell + dex
#
# Interpretación:
#   Evaluamos el efecto de dexametasona ajustando por diferencias entre las
#   líneas celulares.


dds <- DESeqDataSetFromMatrix(
  countData = counts_airway,
  colData = metadata_airway,
  design = ~ cell + dex)

dds


# 8. Filtrar genes de baja expresión ------------------------------------------

# Conservamos genes con suma total de conteos > 10.

dds <- dds[rowSums(counts(dds)) > 10, ]
dds


# 9. Ejecutar DESeq2 -----------------------------------------------------------

# DESeq() estima factores de tamaño, dispersión y ajusta el modelo.

dds <- DESeq(dds)

# Revisar coeficientes disponibles
resultsNames(dds)


# 10. Extraer resultados de expresión diferencial ------------------------------

# Comparación:
#   trt vs untrt para la variable dex
#
# Interpretación:
#   log2FoldChange positivo = mayor expresión en dexametasona
#   log2FoldChange negativo = menor expresión en dexametasona

# Parámetros de práctica ----------------------------------------------------

# Puedes modificar estos umbrales durante la práctica para observar
# cómo cambia el número de genes clasificados y las visualizaciones.

padj_cutoff <- 0.05
log2fc_cutoff <- 1
top_n_heatmap <- 30


res <- results(
  dds,
  contrast = c("dex", "trt", "untrt"),
  alpha = padj_cutoff
)

res
summary(res)

# Ordenar por padj
res_ordered <- res[order(res$padj), ]
head(res_ordered)


# 11. Convertir resultados a data.frame ----------------------------------------

res_df <- as.data.frame(res_ordered) %>%
  rownames_to_column(var = "ensembl_id")

head(res_df)

write.csv(
  res_df,
  file = "data/resultados/airway_counts_normalized_DESeq2.csv"
)

# 12. Anotar genes -------------------------------------------------------------

# Se agregan:
#   symbol   = símbolo del gen
#   entrezid = identificador Entrez
#   gene_name = nombre descriptivo

#Agregar símbolo de genes

res_df$symbol <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "SYMBOL",
  keytype = "ENSEMBL",
  multiVals = "first"
)

#Agregar identificadores Entrez
res_df$entrezid <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "ENTREZID",
  keytype = "ENSEMBL",
  multiVals = "first"
)


#Agregar nombres completos

res_df$gene_name <- mapIds(
  org.Hs.eg.db,
  keys = res_df$ensembl_id,
  column = "GENENAME",
  keytype = "ENSEMBL",
  multiVals = "first"
)


head(res_df)


# 13. Clasificar genes ---------------------------------------------------------

res_df <- res_df %>%
  mutate(
    categoria = case_when(
      !is.na(padj) & padj < padj_cutoff & log2FoldChange >  log2fc_cutoff ~ "Up",
      !is.na(padj) & padj < padj_cutoff & log2FoldChange < -log2fc_cutoff ~ "Down",
      TRUE ~ "No significativo"
    )
  )

table(res_df$categoria)


# 14. Guardar tablas de resultados --------------------------------------------

genes_up <- res_df %>%
  dplyr::filter(categoria == "Up") %>%
  arrange(padj)

genes_down <- res_df %>%
  dplyr::filter(categoria == "Down") %>%
  arrange(padj)

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

annotation_airway <- res_df %>%
  dplyr::select(ensembl_id, symbol, entrezid, gene_name)

write.csv(
  annotation_airway,
  file = "data/datos/airway_annotation.csv",
  row.names = FALSE
)

saveRDS(dds, file = "data/resultados/dds_airway.rds")

# 15. Transformación para visualización ----------------------------------------

# vst() estabiliza la varianza para visualización.
# No se usa para correr DESeq2.

vsd <- vst(dds, blind = FALSE)
saveRDS(vsd, file = "data/resultados/vsd_airway.rds")

# 16. PCA ----------------------------------------------------------------------

plotPCA(vsd, intgroup = c("dex", "cell"))


p_pca <- plotPCA(
  vsd,
  intgroup = c("dex", "cell")
) +
  ggtitle("PCA de muestras airway") +
  theme_minimal()

p_pca

#Guardar

ggsave(
  filename = "data/resultados/figuras/PCA_airway.pdf",
  plot = p_pca,
  width = 7,
  height = 5
)



# Preguntas:
# 1. ¿Las muestras tratadas y no tratadas se separan?
# 2. ¿La variable `cell` también parece influir?
# 3. ¿Hay alguna muestra atípica?
# 4. ¿La separación observada coincide con el diseño experimental?



# 17. MA plot ------------------------------------------------------------------

plotMA(
  res,
  ylim = c(-5, 5),
  main = "MA plot: dexametasona vs control"
)

pdf("data/resultados/figuras/MAplot_airway.pdf", width = 7, height = 5)
plotMA(
  res,
  ylim = c(-5, 5),
  main = "MA plot: dexametasona vs control"
)
dev.off()



# Preguntas:
# 1. ¿Qué representa cada punto?
# 2. ¿Qué representa el eje X?
# 3. ¿Qué representa el eje Y?
# 4. ¿Por qué puede haber mayor dispersión en genes de baja expresión?


# 18. Volcano plot -------------------------------------------------------------

volcano_df <- res_df %>%
  dplyr::filter(!is.na(padj)) %>%
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

p_volcano <- ggplot(
  volcano_df,
  aes(x = log2FoldChange, y = neg_log10_padj)
) +
  geom_point(aes(color = categoria), alpha = 0.7, size = 1.8) +
  geom_vline(xintercept = c(-log2fc_cutoff, log2fc_cutoff), linetype = "dashed") +
  geom_hline(yintercept = -log10(padj_cutoff), linetype = "dashed") +
  geom_text_repel(aes(label = etiqueta), max.overlaps = 20, na.rm = TRUE) +
  labs(
    title = "Volcano plot: dexametasona vs control",
    subtitle = "Caso airway",
    x = "log2 Fold Change",
    y = "-log10(padj)",
    color = "Categoría"
  ) +
  theme_minimal()

p_volcano

ggsave(
  filename = "data/resultados/figuras/U8/volcano_airway.pdf",
  plot = p_volcano,
  width = 8,
  height = 6
)


# 19. Heatmap ------------------------------------------------------------------

top_genes <- res_df %>%
  dplyr::filter(!is.na(padj)) %>%
  dplyr::arrange(padj) %>%
  dplyr::slice(1:30) %>%
  dplyr::pull(ensembl_id)

mat <- assay(vsd)[top_genes, , drop = FALSE]

# Escalamiento por gen
mat_z <- t(scale(t(mat)))

# Preparar anotación

annotation_col <- metadata_airway %>%
  dplyr::select(dex, cell)

rownames(annotation_col) <- rownames(metadata_airway)

pheatmap::pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Top 30 genes diferencialmente expresados",
  filename = "data/resultados/figuras/heatmap_top30_airway.pdf",
  width = 7,
  height = 8
)

dev.off()

# Mostrar en pantalla
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  fontsize_col = 9,
  main = "Top 30 genes diferencialmente expresados"
)


top_genes_tabla <- res_df %>%
  dplyr::filter(ensembl_id %in% top_genes) %>%
  dplyr::arrange(padj)

write.csv(
  top_genes_tabla,
  file = "data/resultados/top30_genes_heatmap_airway.csv",
  row.names = FALSE
)


# 20. Resumen final y tarea------------------------------------------------------------

# Has terminado esta práctica, ahora puedes ir a las actividades de práctica extra.








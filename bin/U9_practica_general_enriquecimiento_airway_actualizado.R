# =============================================================================
# U9_practica_general_enriquecimiento_airway.R
# Unidad 9 – Visualización segunda parte y enriquecimiento funcional
# Curso: Fundamentos de Programación en R para análisis transcriptómicos
# Caso didáctico: airway
# Elaboró: Teresa Ortiz
# Fecha: 25/06/2026
#
# Objetivo general:
#   Retomar los resultados de expresión diferencial de la Unidad 8,
#   preparar listas de genes Up/Down y realizar análisis de enriquecimiento
#   funcional GO con clusterProfiler.
#
# =============================================================================



# 1. Verificar y cargar paquetes ----------------------------------------------

# Paquetes de CRAN

install.packages(c(
  "tidyverse",
  "pheatmap",
  "ggrepel",
  "patchwork",
  "RColorBrewer"
))



# Paquetes de Bioconductor

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



library(DESeq2)
library(airway)
library(SummarizedExperiment)
library(GenomicRanges)
library(tidyverse)
library(clusterProfiler)
library(enrichplot)
library(org.Hs.eg.db)
library(ggplot2)
library(dplyr)


# 2. Crear carpetas ------------------------------------------------------------

dir.create("data/resultados/U9", showWarnings = FALSE)
dir.create("data/resultados/U9/figuras", showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/genes_individuales", recursive = TRUE, showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/enriquecimiento", recursive = TRUE, showWarnings = FALSE)
dir.create("data/resultados/U9/figuras/kegg", recursive = TRUE, showWarnings = FALSE)


# 3. Cargar resultados de Unidad 8 --------------------------------------------

if (!file.exists("data/resultados/res_deseq2_airway_anotado.csv")) {
  stop("No se encontró resultados/res_deseq2_airway_anotado.csv. Ejecuta primero U8_practica_general_airway.R.")
}

dds <- readRDS("data/resultados/dds_airway.rds")
vsd <- readRDS("data/resultados/vsd_airway.rds")

res_df <- read.csv(
  "data/resultados/res_deseq2_airway_anotado.csv",
  stringsAsFactors = FALSE
)


head(res_df)
dim(res_df)
colnames(res_df)

metadata_airway <- as.data.frame(colData(dds))

head(metadata_airway)

# 4. Revisión rápida de resultados y resumen --------------------------------------------

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


# 5. Punto 9 del cuaderno: genes individuales y métricas ----------------------

# Esta sección complementa plotCounts() con una tabla extendida que contiene:
# conteos crudos, conteos normalizados por DESeq2, RPKM, FPKM y TPM.
# Estas métricas son descriptivas; no sustituyen el análisis diferencial de DESeq2.

if (!file.exists("resultados/dds_airway.rds")) {
  stop(
    "No se encontró resultados/dds_airway.rds. Ejecuta primero U8_practica_general_airway.R ",
    "y asegúrate de guardar el objeto con saveRDS(dds, file = 'resultados/dds_airway.rds')."
  )
}

dds <- readRDS("data/resultados/dds_airway.rds")


# Elegir un gen de interés: por defecto usaremos el gen con menor padj y símbolo conocido.

gen_interes <- res_df %>%
  filter(!is.na(padj), !is.na(symbol)) %>%
  arrange(padj) %>%
  slice(1) %>%
  pull(ensembl_id)

gen_interes


# También podemos elegir manualmente un gen de interés biológico.

# Ejemplo: elegir manualmente por símbolo

res_df %>%
  dplyr::filter(symbol == "CRISPLD2") %>%
  dplyr::select(ensembl_id, symbol, log2FoldChange, pvalue, padj)

gen_interes_2 <- res_df %>%
  filter(symbol == "CRISPLD2") %>%
  slice(1) %>%
  pull(ensembl_id)

# 5.1 Graficar conteos normalizados con plotCounts() ---------------------------

datos_gen <- plotCounts(
  dds,
  gene = gen_interes,
  intgroup = c("dex", "cell"),
  returnData = TRUE
)

head(datos_gen)

#Graficamos:

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

ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/conteos_normalizados_gen_individual_airway.pdf",
  plot = p_gen_counts,
  width = 8,
  height = 5
)


#Ahora graficamos con el símbolo del gen:

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

ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/conteos_normalizados_gen_individual_symbol_airway.pdf",
  plot = p_gen_counts_symbol,
  width = 8,
  height = 5
)

# 5.2 Obtener longitudes génicas desde airway ----------------------------------

# Para RPKM, FPKM y TPM necesitamos una longitud por gen. En airway, esta
# información puede aproximarse a partir de rowRanges(airway).

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

# Agregar longitud génica al objeto dds
mcols(dds)$basepairs <- gene_lengths_bp[rownames(dds)]

# Verificar
summary(mcols(dds)$basepairs)
sum(is.na(mcols(dds)$basepairs))

# sum(is.na(mcols(dds)$basepairs)) debe darte como resultado 0, ya que eso significa
# que ninguno de tus genes quedó sin datos de rangos genómicos

# 5.3 Calcular conteos crudos, normalizados, RPKM, FPKM y TPM ------------------

counts_raw <- counts(dds, normalized = FALSE)

counts_norm <- counts(dds, normalized = TRUE)

# FPKM calculado por DESeq2. Requiere mcols(dds)$basepairs.
fpkm_mat <- fpkm(dds)

#Para calcular RPKM y TPM manualmente necesitamos dividir por la
#longitud génica en kilobases:
gene_lengths_kb <- mcols(dds)$basepairs / 1000
genes_validos <- !is.na(gene_lengths_kb) & gene_lengths_kb > 0

genes_validos_id <- rownames(counts_raw)[genes_validos]
counts_valid <- counts_raw[genes_validos_id, , drop = FALSE]

gene_lengths_kb_valid <- gene_lengths_kb[genes_validos]

# Reads/fragments per kilobase.
rpk <- sweep(
  counts_valid,
  1,
  gene_lengths_kb_valid,
  "/"
)

# RPKM: divide RPK entre el tamaño de biblioteca en millones.
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


# Verificación: las columnas de TPM deben sumar cerca de 1,000,000.
colSums(tpm_mat)

# 5.4 Generar dataframe integrado ---------------------------------------------

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

write.csv(
  metricas_expresion_df,
  file = "data/resultados/metricas_expresion_airway_RPKM_FPKM_TPM.csv",
  row.names = FALSE
)

file.exists("data/resultados/metricas_expresion_airway_RPKM_FPKM_TPM.csv")

# 5.5 Graficar gen individual con varias métricas ------------------------------

metricas_gen <- metricas_expresion_df %>%
  filter(ensembl_id == gen_interes)

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

ggsave(
  filename = "data/resultados/U9/figuras/genes_individuales/metricas_RPKM_FPKM_TPM_gen_individual_airway.pdf",
  plot = p_gen_metricas,
  width = 10,
  height = 8
)


# 6. Preparar genes significativos --------------------------------------------

# 0. Parámetros de práctica ----------------------------------------------------

padj_cutoff <- 0.05
log2fc_cutoff <- 1

# Si las listas quedan muy pequeñas para enriquecimiento, se puede activar
# un criterio didáctico más flexible. Esto NO debe usarse sin explicación en
# un reporte formal.

usar_umbral_flexible_si_hay_pocos_genes <- TRUE
min_genes_para_enriquecimiento <- 5
log2fc_cutoff_flexible <- 0.5


preparar_listas <- function(tabla, padj_cutoff, log2fc_cutoff) {

  sig_genes <- tabla %>%
    filter(
      !is.na(padj),
      padj < padj_cutoff,
      abs(log2FoldChange) > log2fc_cutoff,
      !is.na(entrezid)
    )

  genes_up <- sig_genes %>%
    filter(log2FoldChange > log2fc_cutoff) %>%
    pull(entrezid) %>%
    unique() %>%
    as.character()

  genes_down <- sig_genes %>%
    filter(log2FoldChange < -log2fc_cutoff) %>%
    pull(entrezid) %>%
    unique() %>%
    as.character()

  list(
    sig_genes = sig_genes,
    genes_up = genes_up,
    genes_down = genes_down
  )
}

listas <- preparar_listas(res_df, padj_cutoff, log2fc_cutoff)

sig_genes <- listas$sig_genes
genes_up <- listas$genes_up
genes_down <- listas$genes_down

cat("Genes Up:", length(genes_up), "\n")
cat("Genes Down:", length(genes_down), "\n")


# 7. Umbral flexible si es necesario ------------------------------------------

if (
  usar_umbral_flexible_si_hay_pocos_genes &&
  (length(genes_up) < min_genes_para_enriquecimiento ||
   length(genes_down) < min_genes_para_enriquecimiento)
) {
  message("Una de las listas tiene pocos genes. Se usará un umbral didáctico flexible:")
  message("padj < ", padj_cutoff, " y |log2FC| > ", log2fc_cutoff_flexible)

  listas <- preparar_listas(res_df, padj_cutoff, log2fc_cutoff_flexible)

  sig_genes <- listas$sig_genes
  genes_up <- listas$genes_up
  genes_down <- listas$genes_down

  cat("Genes Up con umbral flexible:", length(genes_up), "\n")
  cat("Genes Down con umbral flexible:", length(genes_down), "\n")
}


# 8. Definir universo de fondo -------------------------------------------------

# El universo debe representar genes medidos/evaluables en el análisis.

universo <- res_df %>%
  filter(!is.na(entrezid)) %>%
  pull(entrezid) %>%
  unique() %>%
  as.character()

length(universo)


# 9. Guardar listas de genes ---------------------------------------------------

write.csv(
  sig_genes,
  file = "data/resultados/genes_significativos_para_enriquecimiento_airway.csv",
  row.names = FALSE
)

write.csv(
  data.frame(entrezid = genes_up),
  file = "data/resultados/lista_entrez_genes_up_airway.csv",
  row.names = FALSE
)

write.csv(
  data.frame(entrezid = genes_down),
  file = "data/resultados/lista_entrez_genes_down_airway.csv",
  row.names = FALSE
)


# 10. Función segura para enrichGO ----------------------------------------------

correr_enrichGO <- function(genes, universo, etiqueta) {

  if (length(genes) < min_genes_para_enriquecimiento) {
    message("No se ejecuta enrichGO para ", etiqueta, ": lista demasiado pequeña (", length(genes), " genes).")
    return(NULL)
  }

  enrichGO(
    gene = genes,
    universe = universo,
    OrgDb = org.Hs.eg.db,
    keyType = "ENTREZID",
    ont = "BP",
    pAdjustMethod = "BH",
    pvalueCutoff = 0.05,
    qvalueCutoff = 0.2,
    readable = TRUE
  )
}


# 11. Enriquecimiento GO Biological Process ------------------------------------

ego_up <- correr_enrichGO(genes_up, universo, "genes Up")
ego_down <- correr_enrichGO(genes_down, universo, "genes Down")

ego_up
ego_down


# 12. Guardar resultados GO ----------------------------------------------------

if (!is.null(ego_up)) {
  ego_up_df <- as.data.frame(ego_up)

  write.csv(
    ego_up_df,
    file = "data/resultados/GO_BP_genes_up_airway.csv",
    row.names = FALSE
  )
}

if (!is.null(ego_down)) {
  ego_down_df <- as.data.frame(ego_down)

  write.csv(
    ego_down_df,
    file = "data/resultados/GO_BP_genes_down_airway.csv",
    row.names = FALSE
  )
}


# 13. Visualización: dotplot y barplot -----------------------------------------

if (!is.null(ego_up) && nrow(as.data.frame(ego_up)) > 0) {

  p_dot_up <- dotplot(ego_up, showCategory = 15) +
    ggtitle("GO BP: procesos enriquecidos en genes Up")

  p_dot_up

  ggsave(
    filename = "data/resultados/U9/figuras/enriquecimiento/dotplot_GO_up_airway.pdf",
    plot = p_dot_up,
    width = 9,
    height = 6
  )

  p_bar_up <- barplot(
    ego_up,
    showCategory = 15,
    title = "GO BP: genes Up"
  )

  p_bar_up

  ggsave(
    filename = "data/resultados/U9/figuras/enriquecimiento/barplot_GO_up_airway.pdf",
    plot = p_bar_up,
    width = 9,
    height = 6
  )
}

if (!is.null(ego_down) && nrow(as.data.frame(ego_down)) > 0) {

  p_dot_down <- dotplot(ego_down, showCategory = 15) +
    ggtitle("GO BP: procesos enriquecidos en genes Down")

  p_dot_down

  ggsave(
    filename = "data/resultados/U9/figuras/enriquecimiento/dotplot_GO_down_airway.pdf",
    plot = p_dot_down,
    width = 9,
    height = 6
  )

  p_bar_down <- barplot(
    ego_down,
    showCategory = 15,
    title = "GO BP: genes Down"
  )

  p_bar_down

  ggsave(
    filename = "data/resultados/U9/figuras/enriquecimiento/barplot_GO_down_airway.pdf",
    plot = p_bar_down,
    width = 9,
    height = 6
  )
}


# 14. Comparación funcional Up vs Down -----------------------------------------

lista_genes <- list(
  Up = genes_up,
  Down = genes_down
)

# Solo se ejecuta si ambas listas tienen suficientes genes.
if (length(genes_up) >= min_genes_para_enriquecimiento &&
    length(genes_down) >= min_genes_para_enriquecimiento) {

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

  ego_comparado

  write.csv(
    as.data.frame(ego_comparado),
    file = "resultados/GO_BP_compareCluster_Up_Down_airway.csv",
    row.names = FALSE
  )

  if (nrow(as.data.frame(ego_comparado)) > 0) {
    p_compare <- dotplot(ego_comparado, showCategory = 10) +
      ggtitle("Comparación funcional: genes Up vs Down")

    p_compare

    ggsave(
      filename = "figuras/U9/enriquecimiento/compareCluster_GO_Up_Down_airway.pdf",
      plot = p_compare,
      width = 10,
      height = 7
    )
  }

} else {
  message("No se ejecutó compareCluster porque una lista tiene pocos genes.")
}


# 15. Preguntas de interpretación ---------------------------------------------

# 1. ¿Cuántos genes Up y Down entraron al enriquecimiento?
# 2. ¿Qué procesos aparecen enriquecidos para genes Up?
# 3. ¿Qué procesos aparecen enriquecidos para genes Down?
# 4. ¿Qué términos son muy generales?
# 5. ¿Qué términos tienen sentido con dexametasona y células ASM?
# 6. ¿Qué resultados requieren revisión bibliográfica?


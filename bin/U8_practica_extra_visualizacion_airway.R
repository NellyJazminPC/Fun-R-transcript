# =============================================================================
# U8_practica_extra_visualizacion_airway.R
# Unidad 8 – Práctica extra de visualización
# Curso: Fundamentos de Programación en R para análisis transcriptómicos
# Caso didáctico: airway
# Fecha: 24/06/2026
#
# Objetivo:
#   Explorar visualizaciones adicionales y modificaciones de umbrales usando
#   los resultados generados en U8_practica_general_airway.R.
#
# =============================================================================


# 1. Cargar paquetes -----------------------------------------------------------

paquetes <- c(
  "DESeq2",
  "tidyverse",
  "pheatmap",
  "ggrepel",
  "patchwork"
)

faltantes <- paquetes[!sapply(paquetes, requireNamespace, quietly = TRUE)]

if (length(faltantes) > 0) {
  stop(
    "Faltan paquetes por instalar: ",
    paste(faltantes, collapse = ", ")
  )
}

library(DESeq2)
library(tidyverse)
library(pheatmap)
library(ggrepel)
library(patchwork)


# 2. Crear carpetas ------------------------------------------------------------

dir.create("data/resultados/figuras/U8_extra", recursive = TRUE, showWarnings = FALSE)


# 3. Cargar resultados de Unidad 8 --------------------------------------------

dds <- readRDS("data/resultados/dds_airway.rds")
vsd <- readRDS("data/resultados/vsd_airway.rds")

res_df <- read.csv(
  "data/resultados/res_deseq2_airway_anotado.csv",
  stringsAsFactors = FALSE
)

metadata_airway <- as.data.frame(colData(dds))


# 4. Actividad extra 1: comparar umbrales en volcano plot ----------------------

# Esta función genera un volcano plot para diferentes umbrales.
# Úsala para discutir cómo cambian las categorías Up/Down.

hacer_volcano <- function(tabla, padj_cutoff = 0.05, log2fc_cutoff = 1, titulo = "") {

  volcano_df <- tabla %>%
    filter(!is.na(padj)) %>%
    mutate(
      categoria_umbral = case_when(
        padj < padj_cutoff & log2FoldChange >  log2fc_cutoff ~ "Up",
        padj < padj_cutoff & log2FoldChange < -log2fc_cutoff ~ "Down",
        TRUE ~ "No significativo"
      ),
      neg_log10_padj = -log10(padj),
      etiqueta = case_when(
        padj < padj_cutoff & abs(log2FoldChange) > (log2fc_cutoff * 2) & !is.na(symbol) ~ symbol,
        TRUE ~ NA_character_
      )
    )

  ggplot(volcano_df, aes(x = log2FoldChange, y = neg_log10_padj)) +
    geom_point(aes(color = categoria_umbral), alpha = 0.7, size = 1.6) +
    geom_vline(xintercept = c(-log2fc_cutoff, log2fc_cutoff), linetype = "dashed") +
    geom_hline(yintercept = -log10(padj_cutoff), linetype = "dashed") +
    geom_text_repel(aes(label = etiqueta), max.overlaps = 15, na.rm = TRUE) +
    labs(
      title = titulo,
      subtitle = paste0("padj < ", padj_cutoff, ", |log2FC| > ", log2fc_cutoff),
      x = "log2 Fold Change",
      y = "-log10(padj)",
      color = "Categoría"
    ) +
    theme_minimal()
}

p_v1 <- hacer_volcano(res_df, padj_cutoff = 0.05, log2fc_cutoff = 1,
                      titulo = "Volcano: criterio base")

p_v2 <- hacer_volcano(res_df, padj_cutoff = 0.05, log2fc_cutoff = 0.5,
                      titulo = "Volcano: log2FC flexible")

p_v3 <- hacer_volcano(res_df, padj_cutoff = 0.01, log2fc_cutoff = 1,
                      titulo = "Volcano: padj estricto")

p_v1
p_v2
p_v3

ggsave("figuras/U8_extra/volcano_umbral_base.pdf", p_v1, width = 8, height = 6)
ggsave("figuras/U8_extra/volcano_log2fc_flexible.pdf", p_v2, width = 8, height = 6)
ggsave("figuras/U8_extra/volcano_padj_estricto.pdf", p_v3, width = 8, height = 6)


# Preguntas:
# 1. ¿Cómo cambia el número de genes Up y Down?
# 2. ¿Más genes significan mejor interpretación?
# 3. ¿Qué umbral usarías para exploración y cuál para un reporte formal?


# 5. Actividad extra 2: comparar heatmaps top 20, 30 y 50 ----------------------

hacer_heatmap_top <- function(n_top = 30, archivo = NULL) {

  top_genes <- res_df %>%
    filter(!is.na(padj)) %>%
    arrange(padj) %>%
    slice_head(n = n_top) %>%
    pull(ensembl_id)

  mat <- assay(vsd)[top_genes, , drop = FALSE]
  mat_z <- t(scale(t(mat)))

  annotation_col <- metadata_airway %>%
    select(dex, cell)

  rownames(annotation_col) <- rownames(metadata_airway)

  pheatmap(
    mat_z,
    annotation_col = annotation_col,
    show_rownames = FALSE,
    fontsize_col = 9,
    main = paste("Top", n_top, "genes por padj"),
    filename = archivo,
    width = 7,
    height = 8
  )
}

hacer_heatmap_top(20, "figuras/U8_extra/heatmap_top20_airway.pdf")
hacer_heatmap_top(30, "figuras/U8_extra/heatmap_top30_airway_extra.pdf")
hacer_heatmap_top(50, "figuras/U8_extra/heatmap_top50_airway.pdf")


# Preguntas:
# 1. ¿Cuál heatmap es más claro?
# 2. ¿Cuándo conviene mostrar más genes?
# 3. ¿Qué se pierde cuando mostramos demasiados genes?


# 6. Actividad extra 3: genes individuales del estudio airway ------------------

# Algunos genes asociados con respuesta a glucocorticoides reportados en el
# estudio son DUSP1, KLF15, PER1, TSC22D3 y CRISPLD2.
# Primero revisamos si están presentes en la tabla anotada.

genes_estudio <- c("DUSP1", "KLF15", "PER1", "TSC22D3", "CRISPLD2")

res_df %>%
  filter(symbol %in% genes_estudio) %>%
  select(ensembl_id, symbol, gene_name, baseMean, log2FoldChange, pvalue, padj, categoria)


# Función para graficar un gen por símbolo
graficar_gen_simbolo <- function(simbolo) {

  gen_id <- res_df %>%
    filter(symbol == simbolo) %>%
    arrange(padj) %>%
    slice(1) %>%
    pull(ensembl_id)

  if (length(gen_id) == 0) {
    message("No se encontró el símbolo: ", simbolo)
    return(NULL)
  }

  datos_gen <- plotCounts(
    dds,
    gene = gen_id,
    intgroup = c("dex", "cell"),
    returnData = TRUE
  )

  ggplot(datos_gen, aes(x = dex, y = count, color = dex)) +
    geom_jitter(width = 0.1, size = 3, alpha = 0.8) +
    stat_summary(fun = mean, geom = "point", size = 5) +
    facet_wrap(~ cell) +
    labs(
      title = paste("Expresión de", simbolo),
      subtitle = paste("Ensembl:", gen_id),
      x = "Condición",
      y = "Conteos normalizados"
    ) +
    theme_minimal() +
    theme(legend.position = "none")
}

plots_genes <- lapply(genes_estudio, graficar_gen_simbolo)
names(plots_genes) <- genes_estudio

# Mostrar un ejemplo
plots_genes$CRISPLD2

# Guardar todos los genes encontrados
for (simbolo in names(plots_genes)) {
  p <- plots_genes[[simbolo]]
  if (!is.null(p)) {
    ggsave(
      filename = paste0("figuras/U8_extra/expresion_", simbolo, "_airway.pdf"),
      plot = p,
      width = 8,
      height = 5
    )
  }
}


# 7. Actividad extra 4: figura combinada ---------------------------------------

# Combinar PCA y volcano plot en una sola figura.

# Rehacer PCA
p_pca <- plotPCA(vsd, intgroup = c("dex", "cell")) +
  ggtitle("PCA") +
  theme_minimal()

p_volcano_base <- hacer_volcano(res_df, 0.05, 1, "Volcano")

p_combinada <- p_pca + p_volcano_base

p_combinada

ggsave(
  filename = "figuras/U8_extra/PCA_volcano_combinados.pdf",
  plot = p_combinada,
  width = 12,
  height = 5
)


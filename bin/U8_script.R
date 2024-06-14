######################################################
## Tema: Expresion diferencial                      ##
## Autor: Olga Andrea Hernandez Miranda, Miranda H  ##
## Fecha: 29/01/2024                                ##
## Nota: Calculo de expresión diferencial,          ##
######################################################

#Permite comparar los patrones de expresión entre las muestras.
#Se identifican cambios en los perfiles de expresión
#entre tejidos, etapas, genotipos o tratamientos.
#Es posible localizar genes que se expresan diferente entre 
#los experimentos y conocer las diferencias entre las muestras 
#a través de una prueba de T

#---------------Directorio de trabajo-----------------
# Se establece un directorio de trabajo

directorio <- "C:/Users/andii/OneDrive/Documents/02Fun-R-transcript/data"
setwd(directorio)

######### Calculo de expresion diferencial ###########
# De un archivo con datos de expresion TPM se calcula la
# expresion diferencial entre tratamientos, para ello

# se requieren la siguientes librerias:
#--------------------Librerias------------------------

#install.packages("BiocManager")
#BiocManager::install("DESeq2")
library("DESeq2")

# Usamos grep para buscar los archivos 
samplefiles <- grep('conteo', list.files(directorio),value = T)
samplefiles

# Asignamos el nombre de la condicionn en simplefiles y ponemos 
#los números al principio para forzar el orden deseado. 

samplecondition <- c('Etapa1','Etapa1','Etapa2','Etapa2')

# creamos un dataframe entre archivos y etiquetas
sampletable <- data.frame(sampleName=samplefiles,
                          fileName=samplefiles,
                          condition=samplecondition)

sampletable

# trabajamos con DESeq2 y los datos de conteo
ddsHTSeq <- DESeqDataSetFromHTSeqCount(
  sampleTable = sampletable,
  directory = directorio,
  design =~condition
)
ddsHTSeq

# creamos un factor con las etiquetas de las condiciones 
colData(ddsHTSeq)$condition <- factor(colData(ddsHTSeq)$condition,
                                      levels = c('Etapa2','Etapa1'))
# analizamos de expresion diferencial
dds <- DESeq(ddsHTSeq)
res <- results(dds)
res <- res[order(res$padj),]
head(res)

# resumen de los resultados
summary(dds)
#write.csv(res, file = "U8_tabla_ed_crudos.csv")

#Librerias para volcano plot
install.packages("gplots")
install.packages("RColorBrewer")
library("gplots")
library("RColorBrewer")

# valor de corte de p value
alpha <- 0.05 #filtrado de los valores alpha
cols <- densCols(res$log2FoldChange,-log10(res$pvalue)) #trabajar con gradiente de color
plot(res$log2FoldChange, -log10(res$padj), col=cols, panel.first=grid(),
     main="Volcano plot", xlab="log2(fold-change)", ylab="-log10(p-value)",
     pch=20, cex=0.6)

#Incorporando lineas
#Linea en el eje X
abline(v=c(-2,2), col="brown") # -2 y 2 (valor significativo)
#Linea en el eje Y
abline(h=-log10(alpha), col="brown") # p value, valor de corte de alpha (en 0.05)

# el p value se transforma a log10 para que se vea la forma de volcan

#Asignando texto a los puntos  significativos en la grafica
gn.selected <- abs(res$log2FoldChange) > 2 & res$padj < alpha 
text(res$log2FoldChange[gn.selected],
     -log10(res$padj)[gn.selected],
     lab=rownames(res)[gn.selected ], cex=0.4)



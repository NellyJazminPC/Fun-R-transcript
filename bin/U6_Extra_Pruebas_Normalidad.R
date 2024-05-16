# Código extra con pruebas para saber si los datos tienen una distribución normal
# Nelly Pacheco
# Mayo de 2024

#De manera individual:
# Visualización
hist(data_expresion$ARF, main= "Histograma de variable", xlab="Valores", ylab="Frecuencia", col="lightblue", border="black")
qqnorm(data_expresion$ARF)
qqline(data_expresion$ARF, col = "red")

# Pruebas de Normalidad
shapiro_result <- shapiro.test(data_expresion$ARF)
ks_result <- ks.test(data_expresion$ARF, "pnorm", mean=mean(data_expresion$ARF), sd=sd(data$variable))
ad_result <- ad.test(data_expresion$ARF)
jb_result <- jarque.bera.test(data_expresion$ARF)

# Imprimir Resultados
print(shapiro_result)
print(ks_result)
print(ad_result)
print(jb_result)



# Cargar las librerías necesarias
library(factoextra)
library(ggplot2)
library(nortest) # Para pruebas estadísticas para evaluar la normalidad de una distribución de datos
library(tseries) # Para la prueba de Jarque-Bera, prueba de bondad de ajuste que evalúa la hipótesis nula de que los datos son normalmente distribuidos

# Lista de variables a analizar
variables <- list("ARF", "TAR", "CO", "GA")

# Bucle (for) para iterar sobre cada variable
for (var in variables) {
  # Crear una expresión para seleccionar la columna del data frame
  var_data <- data_expresion[[var]]
  
  # Visualización
  hist(var_data, main=paste("Histograma de", var), xlab="Valores", ylab="Frecuencia", col="lightblue", border="black")
  qqnorm(var_data, main=paste("Q-Q Plot de", var))
  qqline(var_data, col = "red")
  
  # Pruebas de Normalidad
  shapiro_result <- shapiro.test(var_data)
  ks_result <- ks.test(var_data, "pnorm", mean=mean(var_data), sd=sd(var_data))
  ad_result <- ad.test(var_data)
  jb_result <- jarque.bera.test(var_data)
  
  # Imprimir Resultados
  cat("\nResultados de la prueba de normalidad para", var, ":\n")
  print(shapiro_result)
  print(ks_result)
  print(ad_result)
  print(jb_result)
}

###### Creamos un data frame ###### 
DatosE <- data.frame(
  gen = c("ARF", "TIR", "CO", "GA"),
  ed = c(2,10,10,15)
)

DatosE

#Graficamos los datos con la función "plot()"
plot(DatosE$ed)

#Vamos a agregar los titulos de los ejes
plot(DatosE$ed,
     main = "Etapa 1", #titulo
     xlab = "Gen", #titulo eje x
     ylab = "Expresion") #titulo eje y


#Generamos graficas de barras con la función "barplot()".
barplot(DatosE$ed,
        names.arg = DatosE$gen, #agregamos el nombre de los genes
        main = "Etapa 1",
        xlab = "Gen",
        ylab = "Expresion",
        ylim = c(0, max(DatosE$ed) + 2) #el eje y va de 0 al maximo de la expresion
)

#Agregamos color
barplot(DatosE$ed,
        names.arg = DatosE$gen,
        main = "Etapa 1",
        xlab = "Gen",
        ylab = "Expresion",
        col = "skyblue",#color
        border = "black", #color del borde
        ylim = c(0, max(DatosE$ed) + 2) #Limite del eje y
)

directorio <- "../data/"
setwd(directorio)

DatosE2 <- read.table("U3_1.csv", sep = ",", header = T) #Se lee
DatosE2

barplot(DatosE2$ED,
        names.arg = DatosE2$Gen,#se grafica Gen
        main = "Etapa 2",
        xlab = "Gen",
        ylab = "Expresion",
        col = "purple",
        border = "black",
        ylim = c(0, max(DatosE2$ED) + 2)#limite del eje
)

#Cargamos base de datos de expresión genética
E <- read.table("U3_2.csv", sep = ",", header = T)
head(E)

#Generamos un histograma con la función "hist()"
hist(E$ARF,
     main="Histograma de datos de expresion de ARF",
     xlab="Expresion", ylab="Frecuencia", 
     col="yellow"
)

#Generamos un vector para grafcarlo con la función "boxplot()".
TAR <- c(8, 5, 14, -9, 19, 12, 3, 9, 7, 4,
         4, 6, 8, 12, -8, 2, 0, -1, 5, 3)

#Graficamos el vector
boxplot(TAR,
        horizontal = T)

#Utilizamos los datos del archivo U3_2.csv para crear diagramas de cajas y bigotes.
#Si el conjunto de datos tiene una variable categórica que contiene grupos,
#puedes crear un diagrama de caja especificando la fórmula
#(variable_continua \~ variable_categorica).

#Vemos los datos
head(E)

boxplot(E$TAR~ E$Etapas) #columnas

#Agregamos color y titulos
boxplot(E$TAR~ E$Etapas,#agregamos todas las columnas que vamos a graficar
        main="Diagramas de caja",#titulo
        xlab="Genes",#titulo x
        ylab="Expresion de TAR",
        col=c("red", "blue", "orange")#colores
)

#Iniciamos instalando la librería "ggplot2" y cargandola para después 
#visualizar los datos del archivo U3_1.csv que guardamos en 
#la variable (objeto) DatosE2
#install.packages("ggplot2")
library(ggplot2)
head(DatosE2) 

#Gráfico de barras
ggplot(DatosE2,aes(x = Gen, y = ED)) + #Indicamos los datos y ejes
  geom_bar(stat = 'identity') #Indicamos la geometria (como se posicionará)

#Cambiamos las barras a color morado transparente y tema clasico
ggplot(DatosE2, aes(x = Gen, y = ED)) + # Indicamos los datos y ejes
  geom_bar(stat = 'identity', fill = "purple3", alpha = 0.7) + # Indicamos la geometría y color
  theme_classic() # Aplicamos el tema clásico

#Para personalizar paletas de colores
colores <- c("blue", "red", "green3", "orange2")

ggplot(DatosE2, aes(x = Gen, y = ED, fill = Gen)) +
  geom_bar(stat = 'identity', alpha = 0.7, width = 0.5) + #geometría, transparencia y ancho de las barras
  theme_classic() + # Aplicamos el tema clásico
  scale_fill_manual(values = colores)  # Asignamos los colores manualmente

#Paleta de colores con código
colores2 <- c("#00FFC3", "#7A00FF", "#FFCF00", "#FF5733") 

ggplot(DatosE2, aes(x = Gen, y = ED, fill = Gen)) +
  geom_bar(stat = 'identity', alpha = 0.7, width = 0.5) +
  theme_classic() +
  scale_fill_manual(values = colores2)

#Para colocar las barras horizontalmente sólo movemos el orden de los ejes x y y
ggplot(DatosE2, aes(x = ED, y = Gen, fill = Gen)) + 
  geom_bar(stat = 'identity', alpha = 0.7, width = 0.4) + 
  theme_classic() +
  scale_fill_manual(values = colores2)

#Para crear un histograma de la frecuencia de espresión que tiene el gen TAR
#Primero vemos los datos guardados en la variable (objeto E) y graficamos
#la columna TAR

head(E)

ggplot(E, aes(x = TAR)) + #variable (objeto E), columna TAR
  geom_histogram(fill = "blue", bins = 20, alpha = 0.7) +  #geometria histograma, tamaño barra
  labs(x = "TAR", y = "Frecuencia") +
  theme_minimal()

#Difereciar datos que pertenecen a cada etapa del desarrollo
ggplot(E, aes(x = TAR, fill = Etapas)) + #Separar datos por etapa
  geom_histogram(bins = 20) +
  labs(x = "TAR", y = "Frecuencia") +
  theme_minimal ()

#Para graficar datos de cada etapa por separado
ggplot(E, aes(x = TAR, fill = Etapas)) +
  geom_histogram(bins = 15, alpha = 0.7) +
  labs(x = "TAR", y = "Frecuencia") +
  facet_wrap(~ Etapas) + #Graficar Etapas por separado
  scale_fill_manual(values = c("#00FFC3", "#7A00FF", "#FFCF00")) +
  theme_light()


#Boxplot
ggplot(data = E, aes(x = Etapas, y = TAR, fill = Etapas)) +
  geom_boxplot(alpha = 0.7) +  # Añadir cajas con transparencia
  geom_jitter(alpha = 0.3, width = 0.3) +  # Añadir puntos jitter
  scale_fill_manual(values = c("#00FFC3", "#7A00FF", "#FFCF00")) +
  theme_minimal()

#--Aplicación--

#Vamos a utilizar los datos de Expresion del gen TAR y optener el promedio y desviación
#estandar de la expresión genética por etapa 

#Instalamos la librería "dplyer"si se requiere y la cargamos
#install.packages("dplyr")
library(dplyr)

# Calcular el promedio y la desviación estándar con dplyr
resumen_E <- E %>% #Especificamos donde se va a guardar
  group_by(Etapas) %>% #Agrupamos por etapas
  summarise(Expresion_promedio = mean(TAR), DE = sd(TAR)) #calculamos promedio y desviación

resumen_E #vemos la variable

# Definir los colores para cada especie
colores <- c("#00FFC3", "#7A00FF", "#FFCF00")

#Grafica de barras con barras de error
ggplot(resumen_E, aes(x = Etapas, y = Expresion_promedio, fill = Etapas)) +
  geom_bar(stat = "identity", alpha = 0.7, width = 0.5) +
  geom_errorbar(aes(ymin = Expresion_promedio - DE,
                    ymax = Expresion_promedio + DE),
                width = 0.1, color = "black",
                position = position_dodge(0.9), size = 0.5) + #datos de la barra de error
  scale_fill_manual(values = colores) +  # colores
  labs(x = "Etapas", y = "Expresion promedio") +
  theme_classic()

#Agregar recta de regresión lineal 
E #vemos a la variable (objeto) E

ggplot(data = E, mapping = aes(x = CO, y = GA)) + #mapeamos los datos
  geom_point(aes(color = Etapas)) + #Diferenciamos con puntos entre etapas
  geom_smooth(method = "lm") + #Utilizamos el método de regresión llineal 
  theme_classic()

#Tambien podemos separar los datos de cada etapa
ggplot(data = E, mapping = aes(x = CO, y = GA)) + #mapeamos los datos
  geom_point(aes(color = Etapas)) + #Diferenciamos con puntos entre etapas
  geom_smooth(method = "lm") +
  facet_wrap(~Etapas) + #separamos datos por etapa
  theme_bw()


##### Hacer incapie en Dplyr de group_by y summarise - mean y sd


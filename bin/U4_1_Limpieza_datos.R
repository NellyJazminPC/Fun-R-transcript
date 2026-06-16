install.packages(c(
  "tidyverse",
  "magrittr",
  "dslabs",
  "ggplot2",
  "ggrepel",
  "psych",
  "broom",
  "lm4",
  "marginaleffects"
))
library(tidyverse)
library(magrittr)
library(readxl)
library(readr)
#revisemos el df de la clase pasada
U3_2 <- read_csv("Documents/Clases/cursos_2024-2/Programacion R/Fun-R-transcript-main/data/U3_2.csv")
View(U3_2)

#acomodando en una sola columna los genes
U4_1 <- U3_2 %>%
  pivot_longer(
    cols = c(TAR, ARF, CO, GA),
    names_to = "genes",
    values_to = "conteo"
  )
head(U4_1)
tail(U4_1)
View(U4_1)
#revisemos unicamente los datos de los genes TAR

TARgen <- U4_1 %>%
  filter(genes == "TAR")
TARgen

#Ejercicio con la base de datos de asesinatos por estado en EE.UU.
library(dslabs)
data(murders) #Esto carga el conjunto de datos murders en tu entorno de trabajo (si pertenece a un paquete que está instalado y disponible).
head(murders)
murders %>% select(state, population, total)

#Calcular la tasa de asesinatos por cada 100 mil habitantes, Conserva únicamente los estados que cumplen ambas condiciones:
#tasa de asesinatos menor a 0.9 por 100,000 habitantes
#pertenecen a las regiones South o West

murders_filtrado <- murders %>%
  mutate(ratio = total / population * 100000) %>%
  filter(
    ratio < 0.9,
    region %in% c("South", "West")
  ) %>%
  select(state, abb, ratio)

murders_filtrado

#representar la relación entre la población y el número total de asesinatos.
library(ggplot2)
library(ggrepel)

ggplot(murders,
       aes(population/10^6, total, label = abb)) +
  geom_point() +
  geom_text_repel() +
  labs(
    x = "Población (millones)",
    y = "Total de asesinatos",
    title = "Asesinatos totales vs población por estado"
  )
#para visualizar mejor todos los datos con logaritmo
ggplot(murders,
       aes(x = population,
           y = total,
           label = abb)) +
  geom_point() +
  geom_text_repel() +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    x = "Población",
    y = "Total de asesinatos",
    title = "Asesinatos vs población por estado"
  )

#asesinatos tasa por cada 100 mil habitantes
murders %>%
  mutate(rate = total/population*100000) %>%
  ggplot(aes(x = reorder(state, rate), y = rate)) +
  geom_col() +
  coord_flip() +  #Aquí los nombres de los estados aparecen automáticamente en el eje Y
  labs(
    x = "Estado",
    y = "Asesinatos por 100,000 habitantes",
    title = "Tasa de asesinatos por estado"
  )
############################################################################################
#Ejercicio 1

murders %>%
  mutate(ratio = total / population * 50000) %>%
  filter(ratio < 0.5,
         region %in% c("Northeast", "North Central")) %>%
  select(state, abb, ratio)
###########################################################################################
#Revisar estadisticas descriptivas
mean(murders$total)
sd(murders$total)
min(murders$total)
max(murders$total)
range(murders$population)
summary(murders)
dim(murders)
length(murders$total)
murders %>% 
  group_by(region) %>% 
  summarise(m.total = mean(total))

library(psych)
describe(murders)
z <- describe(murders) 
z
z2 <- describeBy(murders$total, group = murders$region)
z2
#Calcula el promedio, la desviacion y el error de la tasa de asesinatos por 100,000 habitantes
murders_summary <- murders %>%
  mutate(rate = total/population*100000) %>%
  group_by(region) %>%
  summarise(
    media_rate = mean(rate),
    sd_rate = sd(rate),
    se_rate = sd(rate) / sqrt(n())
  )
murders_summary

#Graficamos
ggplot(murders_summary, aes(region, media_rate, fill = region)) +
  geom_col() +
  geom_errorbar(
    aes(ymin = media_rate - se_rate,
        ymax = media_rate + se_rate),
    width = 0.2
  ) +
  theme_minimal()
####################################################################################################
#Ejercicio 2
summary(U3_2)
ggplot(U4_1, aes(x = Etapas, y = conteo)) +
  geom_boxplot(fill = "skyblue") +
  facet_wrap(~genes) +
  labs(title = "Cuartiles por gen y etapa",
       x = "Etapas",
       y = "Conteo")

ggplot(subset(U4_1, genes == "TAR"),
       aes(x = Etapas, y = conteo)) +
  geom_boxplot(fill = "orange") +
  labs(title = "TAR por etapas")

####################################################################################################
#Prueba de t student
peso_pollos <-ChickWeight
#Filtramos los datos de las dietas 1 y 2
datos <- subset(peso_pollos, Diet %in% c("1", "2"))
#Calculamos prueba t, ¿Hay diferencias entre las medias de peso de las dietas 1 y 2?
t.test(weight ~ Diet, data = datos)
#prueba t pareada
pollito1 <- subset(peso_pollos, Chick == 2)

t.test(pollito1$weight[pollito1$Time == 0],
       pollito1$weight[pollito1$Time == 20],
       paired = TRUE)
#############################################################################################
#Ejercicio 3
x_ARF <- U4_1 %>%
  filter(
    genes == "ARF",
    Etapas %in% c("Etapa2", "Etapa3")
  )
t.test(conteo ~ Etapas, data = x_ARF) #realiza una prueba t de Student para dos grupos, comparando los valores de ARF entre los niveles de la variable Etapas.
##Hipótesis
# H0 (nula): la media de conteo es igual en Etapa2 y Etapa3.
# H1 (alternativa): las medias son diferentes.
#p = 0.0427 < 0.05, Por lo tanto, hay evidencia de que la expresión  de ARF difiere entre Etapa2 y Etapa3.

#¿Los estados grandes tienen una tasa de asesinatos distinta a la de los estados pequeños?
murders2 <- murders %>%
  mutate(
    rate = total/population*100000,
    tamano = ifelse(population > median(population),
                    "Grande", "Pequeño")
  )

t.test(rate ~ tamano, data = murders2)
####################################################################################################

##Prueba de Mann-Whitney) Wilcox
Hombres = c(19, 22, 16, 29, 24)
Mujeres = c(20, 11, 17, 12)

wilcox.test(Hombres, Mujeres, exact = TRUE) #porque con muestras tan pequeñas R puede calcular el valor p exacto en lugar de una aproximación

#Hipótesis
#H₀: las dos poblaciones tienen la misma localización (misma mediana/distribución).
#H₁: las poblaciones difieren.
################################################################################################
#ANOVA
modelo <- aov(weight ~ Diet, data = ChickWeight) #el peso depende de la dieta
summary(modelo)

#Prueba de Tukey para saber que dietas tienen diferencias significativas
tukey<- TukeyHSD(modelo)
install.packages("multcompView")
library(multcompView)
library(dplyr)
library(ggplot2)
letras <- multcompLetters4(modelo, tukey)
letras
tabla <- ChickWeight %>%
  group_by(Diet) %>%
  summarise(media = mean(weight)) %>%
  arrange(desc(media))

tabla$letra <- letras$Diet$Letters
tabla
ggplot(tabla, aes(x = Diet, y = media, fill = Diet)) +
  geom_col() +
  geom_text(aes(label = letra), vjust = -0.5, size = 5) +
  theme_minimal() +
  labs(title = "Peso promedio por dieta (Tukey)",
       y = "Peso promedio",
       x = "Dieta")
#Anova de dos factores
modelo2 <- aov(weight ~ Diet * Time, data = ChickWeight)
summary(modelo2)
TukeyHSD(aov(weight ~ Diet, data = subset(ChickWeight, Time == 20)))

## Test de Friedman
datos_Fried <- subset(ChickWeight, Diet == "1")
datos_Fried_wide <- pivot_wider(datos, #cambio a formato datos ancho
                          names_from = Time,
                          values_from = weight)
##¿El peso de los pollos cambia significativamente con el tiempo dentro de la dieta 1?
friedman.test(as.matrix(datos_Fried_wide[,-1]))
##Chi cuadrada
#Usaremos murders y crearemos dos variables:
#Región (ya existe)
#Nivel de homicidios (lo creamos)
murders3 <- murders %>%
  mutate(nivel = cut(total,
                     breaks = c(0, 50, 100, Inf),
                     labels = c("bajo", "medio", "alto")))
tabla <- table(murders3$region, murders3$nivel)
tabla #numero de estados en cada categoria por region
chisq.test(tabla)
#Hipótesis del test:
#H0 (nula): región y nivel de homicidios son independientes
#H1 (alternativa): están relacionados
#¿Se rechaza o acepta la hipotesis nula?

#############################################################################################

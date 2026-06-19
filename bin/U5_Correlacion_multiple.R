#Regresion lineal y multiple
install.packages("car")
library(magrittr)
library(readxl)
library(readr)
library(tidyr)
library(dplyr)
library(car)
library(broom)

datos_prop <- read.csv("data/U5_prop.csv") #leer el archivo desde la ubicacion en tu computadora
head(datos_prop)

#ajustamos modelo de regresion lineal simple
modelo_prop <- lm(Resistencia ~ Edad, data = datos_prop)
summary(modelo_prop)
#graficamos
ggplot(datos_prop, aes(x = Edad, y = Resistencia)) +
  geom_point(color = "darkred", size = 2) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) + #Añade la recta de regresión ajustada mediante lm() y lo sombreado (se = True) el intervalo de confianza del 95% para la media estimada de la respuesta.
  theme_minimal() +
  labs(title = "Resistencia vs Edad del material",
       x = "Edad",
       y = "Resistencia")

#analisis con murders
#Este modelo intenta explicar la población (en millones) usando únicamente el número total de asesinatos. A mayor poblacion, mayor asesinatos?
murd.mod1 <- lm(population/10^6 ~ total, data = murders) 
broom::tidy(murd.mod1) #Convierte los coeficientes en un data frame
head(murders)
#la region tiene algun efecto? 
#prediciendo la población en millones de habitantes a partir del número total de homicidios y de la región del estado
murd.mod2 <- lm(population/10^6 ~ total + region, data = murders)
summary(murd.mod2)
broom::tidy(murd.mod2)
anova(murd.mod1,murd.mod2)
#La hipótesis es:

#H₀: agregar region no mejora el modelo.
#H₁: agregar region sí mejora el modelo.

#Ahora mejor comparar la tasa de asesinatos
murders4 <- murders %>%
  mutate(rate = total/population*100000) 

lm(rate ~ region, data = murders4) #¿La tasa media de asesinatos es igual en las cuatro regiones de EE.UU.?
anova(lm(rate ~ region, data = murders4))
#porque usar aov con Tukey
# anova no hace modelos, los resume en tabla
# aov si modela con lm

TukeyHSD(aov(rate ~ region, data = murders4)) #entre que regiones hay diferencias significativas

ggplot(murders4, aes(x = region, y = rate, fill = region)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.15, size = 2, alpha = 0.7) +
  theme_minimal()
##########################################################################################
#Ejercicio 1
data(CO2)
head(CO2)

lm(uptake ~ conc, data = CO2) #modelo, a absorción de CO₂ (uptake) en función de la concentración (conc)
anova(lm(uptake ~ conc, data = CO2))

ggplot(CO2, aes(x = conc, y = uptake, color = Type)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
######################################################################################
##Regresion multiple####
plantas <- read_csv("data/U5_plantas.csv")
plantas

##Ajustando modelo
mod <- lm(biomasa ~ nitrogeno + luz, data = plantas) #la biomasa cambia con relacion al nitrogeno y la luz?
summary(mod)
#biomasa = β0 + β1·nitrogeno + β2·luz
library(car)

vif(mod)
#valores > a 5 pueden indicar  multicolinealidad (dos o mas variables altamente relacionadas entre si)

ggplot(plantas, aes(nitrogeno, biomasa, color = luz)) +
  geom_point(size = 3) +
  scale_color_gradient(low = "blue", high = "red")
###################################################################################
#Ejercicios 2
#Ajustar tres modelos y compararlos#
mod1 <- lm(biomasa ~ nitrogeno, data = plantas)

mod2 <- lm(biomasa ~ luz, data = plantas)

mod3 <- lm(biomasa ~ nitrogeno + luz, data = plantas)

summary(mod1)
summary(mod2)
summary(mod3)

anova(mod1, mod3)
anova(mod2, mod3)

####Preguntas##
##¿Qué variable explica mejor la biomasa?
##¿Mejora el ajuste al incluir ambas variables?
##¿Cuál tiene mayor efecto?

#############################################################################
#Modelos lineales generalizados y mixtos

# Calculamos los vivos, la probabilidad de morir, y el 
# logaritmo de dosis que es la forma habitual de medir 
# en este tipo de situaciones
Dosis = read_csv("https://goo.gl/w23RGz", col_types = "cdii") #tipo de datos que tiene cada columna
Dosis
#Agrega la columna vivos, probabilidad y ldosis
Dosis_2 = Dosis %>%  
  mutate(alive = total - dead, probabilidad = dead/total, ldosis = log(dosis))
Dosis_2
# Representamos la probabilidad de morir en función de 
# las covariables sex y ldosis
ggplot(Dosis_2,aes(x = ldosis, y = probabilidad, color = sex)) + 
  geom_point() +
  labs(x = "Logaritmo Dosis", y = "Probabilidad de morir") 
#Se genera un vector con la relación de insectos muertos y vivos
Yres <- cbind(Dosis_2$dead,Dosis_2$alive)
Yres

#La relación entre dosis y mortalidad NO es la misma para ambos sexos
fit.dosis <- glm(Yres  ~ sex * ldosis,
                 family = binomial(link = "logit"),
                 data = Dosis_2)
summary(fit.dosis)
#El efecto de la dosis es el mismo para ambos sexos; solo cambia el nivel base
fit.dosis <- glm(Yres ~ sex + ldosis,
                 family = binomial(link = logit),
                 data = Dosis_2)
summary(fit.dosis)

#como elegir cual modelo es el mejor
m1 <- glm(Yres ~ sex + ldosis, family = binomial, data = Dosis_2) #sin interaccion
m2 <- glm(Yres ~ sex * ldosis, family = binomial, data = Dosis_2) #con interaccion

anova(m1, m2, test = "Chisq")

# prob = Probabilidad buscada (LD50) en concentración de insectícida
predictor <- qlogis(0.5) # qlogis es la función inversa del logit:
predictor
machos <-exp((predictor+2.372)/1.535) #la dosis necesaria para alcanzar una probabilidad dada (0.5)
hembras <- exp((predictor+3.473)/1.535) #la dosis necesaria para alcanzar una probabilidad dada (0.5)
machos
hembras

# Trabajamos con dosis 
prob <- seq(0.05,0.95,0.01) #probabilidades de muerte
predictor <- qlogis(prob) #transformadas a escala logit
predictor

ggplot(Dosis_2,
       aes(x = dosis,
           y = probabilidad,
           color = sex)) +
  geom_point()

##############################################################################
#Modelos lineales generalizados mixtos
library(lme4)

View(CO2)
glmm.CO2 <-lmer ( uptake ~ conc + Type + Treatment + (1| Type / Plant ),data = CO2, REML = TRUE) #REML REML corrige esto: elimina el efecto de los parámetros fijos al estimar las varianzas
summary ( glmm.CO2)
anova(glmm.CO2)

##########################################################################
#el paquete lmerTest te da los valores de p-value
install.packages("lmerTest")
library(lmerTest)
mod <- lmer(uptake ~ conc + Type + Treatment +
              (1 | Type/Plant),
            data = CO2)
summary(mod)

#calcula el valor esperado de uptake según el modelo.
CO2$pred <- predict(glmm.CO2)
#grafica las predicciones en Uptake segun el modelo
ggplot(CO2, aes(conc, uptake, group = Plant)) +
  geom_point(alpha = 0.6) +
  geom_line(aes(y = pred), color = "blue", alpha = 0.3) +
  theme_minimal()




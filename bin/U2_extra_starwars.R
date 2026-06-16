############################################################
# Curso: Fundamentos de programación en R para análisis
# transcriptómicos
# Unidad 2
#
# Script extra: práctica con starwars
#
# Este script es un ejercicio complementario para practicar las
# funciones vistas en el tema 2.3:
#
# select()
# filter()
# mutate()
# arrange()
# group_by()
# summarise()
#
# La base starwars viene incluida en dplyr.
# No se usará como práctica central de la sesión; es un ejercicio
# extra para seguir practicando manipulación de data frames.
############################################################


############################################################
# 0. Cargar paquete
############################################################

# Pregunta:
# ¿Qué paquete necesitamos cargar para usar la base starwars
# y las funciones de manipulación de datos?

library(dplyr)


############################################################
# 1. Explorar la base de datos
############################################################

# Pregunta:
# ¿Qué contiene la base starwars?
# Antes de manipular una tabla, siempre conviene revisarla.

starwars

# Ver las primeras filas
head(starwars)

# Ver dimensiones: número de filas y columnas
dim(starwars)

# Ver nombres de columnas
names(starwars)

# Ver la estructura general de la tabla
glimpse(starwars)

# Nota:
# Algunas columnas, como films, vehicles y starships, son listas.
# Por ahora no trabajaremos con ellas, porque en esta unidad nos
# enfocaremos en columnas simples: texto, números y categorías.


############################################################
# 2. Seleccionar columnas con select()
############################################################

# Pregunta:
# ¿Qué columnas necesitamos conservar si queremos analizar
# características generales de los personajes?

starwars_select <- starwars %>%
  select(name, species, homeworld, height, mass)

starwars_select

# Pregunta:
# ¿Qué columnas quedaron en el nuevo data frame?

names(starwars_select)


############################################################
# 3. Filtrar filas con filter()
############################################################

# Pregunta:
# ¿Qué personajes tienen datos registrados de altura y masa?
# Para responder, quitaremos las filas donde height o mass sean NA.

starwars_filtrado <- starwars %>%
  filter(!is.na(height), !is.na(mass))

starwars_filtrado

# Revisar cuántos personajes quedan después del filtrado
dim(starwars_filtrado)

# Pregunta:
# ¿Cuántos personajes quedaron con datos completos de altura y masa?


############################################################
# 4. Crear una nueva columna con mutate()
############################################################

# Pregunta:
# ¿Podemos convertir la altura de centímetros a metros?
# La columna height está en centímetros, así que crearemos height_m.

starwars_altura_m <- starwars_filtrado %>%
  mutate(height_m = height / 100)

starwars_altura_m %>%
  select(name, height, height_m, mass)

# Pregunta:
# ¿Por qué conviene guardar esta conversión en una nueva columna?


############################################################
# 5. Crear una variable derivada: masa / altura
############################################################

# Pregunta:
# ¿Podemos crear una variable nueva usando dos columnas numéricas?
# Aquí calculamos una relación simple entre masa y altura.
#
# Nota importante:
# Esta variable NO debe interpretarse biológicamente de forma seria,
# porque la base incluye especies ficticias muy distintas entre sí.
# La usamos solo para practicar mutate().

starwars_relacion <- starwars_filtrado %>%
  mutate(
    height_m = height / 100,
    mass_height_ratio = mass / height_m
  )

starwars_relacion %>%
  select(name, species, height_m, mass, mass_height_ratio)


############################################################
# 6. Ordenar filas con arrange()
############################################################

# Pregunta:
# ¿Qué personajes tienen mayor masa registrada?

starwars_masa_desc <- starwars_filtrado %>%
  arrange(desc(mass))

starwars_masa_desc %>%
  select(name, species, height, mass)

# Pregunta:
# ¿Qué personajes tienen menor altura registrada?

starwars_altura_asc <- starwars_filtrado %>%
  arrange(height)

starwars_altura_asc %>%
  select(name, species, height, mass)


############################################################
# 7. Combinar select(), filter(), mutate() y arrange()
############################################################

# Pregunta:
# ¿Qué personajes humanos tienen datos de altura y masa,
# y cómo se ordenan de mayor a menor altura?

humanos_altura <- starwars %>%
  select(name, species, homeworld, height, mass) %>%
  filter(species == "Human", !is.na(height), !is.na(mass)) %>%
  mutate(height_m = height / 100) %>%
  arrange(desc(height))

humanos_altura

# Pregunta:
# ¿Qué función se usó para seleccionar columnas?
# ¿Qué función se usó para filtrar personajes humanos?
# ¿Qué función creó la columna height_m?
# ¿Qué función ordenó la tabla?


############################################################
# 8. Resumir información por grupos
############################################################

# Pregunta:
# ¿Cuántos personajes hay registrados por especie?

starwars_por_especie <- starwars %>%
  filter(!is.na(species)) %>%
  group_by(species) %>%
  summarise(
    n_personajes = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(n_personajes))

starwars_por_especie

# Pregunta:
# ¿Cuáles son las especies con más personajes registrados?


############################################################
# 9. Calcular promedios por grupo
############################################################

# Pregunta:
# ¿Cuál es la altura promedio registrada por especie?
# Para evitar promedios basados en un solo personaje, primero
# calcularemos cuántos personajes tiene cada especie.

starwars_altura_por_especie <- starwars %>%
  filter(!is.na(species), !is.na(height)) %>%
  group_by(species) %>%
  summarise(
    n_personajes = n(),
    altura_promedio = mean(height),
    .groups = "drop"
  ) %>%
  filter(n_personajes >= 2) %>%
  arrange(desc(altura_promedio))

starwars_altura_por_especie

# Pregunta:
# ¿Por qué filtramos especies con al menos 2 personajes?
# ¿Qué podría pasar si calculamos un promedio con un solo dato?


############################################################
# 10. Ejercicio guiado
############################################################

# Pregunta:
# ¿Podemos construir una tabla final con personajes que:
# 1) tengan especie registrada,
# 2) tengan altura registrada,
# 3) tengan masa registrada,
# 4) incluyan una columna con altura en metros,
# 5) estén ordenados de mayor a menor masa?

starwars_tabla_final <- starwars %>%
  select(name, species, homeworld, height, mass) %>%
  filter(!is.na(species), !is.na(height), !is.na(mass)) %>%
  mutate(height_m = height / 100) %>%
  arrange(desc(mass))

starwars_tabla_final

# Preguntas de cierre:
# ¿Qué representa cada fila de starwars_tabla_final?
# ¿Qué columnas conservamos?
# ¿Qué filas eliminamos con filter()?
# ¿Qué columna nueva creamos con mutate()?
# ¿Con qué variable ordenamos la tabla?


############################################################
# 11. Desafío extra
############################################################

# Desafío:
# Exporta la tabla starwars_tabla_final dentro de la carpeta results.
#
# Pista:
# Puedes usar dir.create() y write.csv(), como en el script de
# práctica general de la Unidad 2.

# Crear carpeta results si no existe
#dir.create("results", showWarnings = FALSE)

# Exportar resultado
write.csv(
  starwars_tabla_final,
  "results/starwars_tabla_final.csv",
  row.names = FALSE
)

############################################################
# 
# Bienvenido al lado de R.
#
############################################################

#                  .-.
#                 |_:_|
#                /(_Y_)\
#               ( \/M\/ )
#              _.'-/'-'\-'._
# No, yo soy tu data frame.
# Fin del ejercicio extra.
############################################################
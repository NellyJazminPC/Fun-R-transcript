# ============================================================
# Fundamentos de programación en R para análisis transcriptómicos
# Unidad 3. Visualización de datos con R y ggplot2
# Script: Para seguir explorando
# 17 de junio de 2026 - NJ PC
# ============================================================
#
# Este script contiene ejemplos complementarios para practicar después
# de la sesión principal.
#
# No forma parte del núcleo obligatorio de la clase. Su función es abrir
# pequeñas puertas para seguir explorando visualización de datos:
#
# 1. Violin plots
# 2. Gráficas de densidad
# 3. Paletas accesibles
# 4. Paletas viridis para variables continuas
# 5. Personalización avanzada de temas
# 6. Facetas
# 7. Figuras multipanel con patchwork
# 8. Ejercicio extra con starwars
# 9. Notas sobre gráficos 3D
# 10. Notas sobre figuras publicadas
#
# Convención de nombres:
# Usaremos nombres descriptivos en snake_case.
#
# Ejemplos:
# datos_expresion
# figura_violin_tar
# figura_densidad_tar
# tema_oscuro_serif
#
# ============================================================


# ------------------------------------------------------------
# 0. Preparar ambiente
# ------------------------------------------------------------

# Si no tienes instalados estos paquetes, puedes instalarlos una sola vez:
# install.packages("tidyverse")
# install.packages("viridis")
# install.packages("patchwork")

# tidyverse incluye:
# - readr: para leer archivos .csv con read_csv()
# - dplyr: para manipular datos
# - ggplot2: para construir gráficas
library(tidyverse)

# Crear la carpeta results si no existe.
# Aquí guardaremos algunas figuras generadas en este script.
if (!dir.exists("results")) {
  dir.create("results")
}


# ------------------------------------------------------------
# 1. Leer la base principal
# ------------------------------------------------------------
# En la práctica general usamos el archivo U3_2.csv.
# Aquí lo volveremos a cargar para que este script pueda ejecutarse
# de manera independiente.
#
# Usamos read_csv(), de readr/tidyverse.
# show_col_types = FALSE evita que se imprima el mensaje automático
# sobre los tipos de columnas detectados.

datos_expresion <- read_csv(
  "data/U3_2.csv",
  show_col_types = FALSE
)

# Revisamos la estructura de la tabla.
# glimpse() muestra filas, columnas, tipos de datos y algunos valores.
glimpse(datos_expresion)

# Revisamos los nombres exactos de las columnas.
names(datos_expresion)


# ------------------------------------------------------------
# 2. Paleta base de la Unidad 3
# ------------------------------------------------------------
# Definimos una paleta para reutilizarla en varias figuras.
#
# Azul turquesa: #1699B5
# Azul medio:    #1F5FAF
# Dorado suave:  #E8B84A
# Violeta:       #7B63C9

paleta_u3 <- c("#1699B5", "#1F5FAF", "#E8B84A")

paleta_u3_completa <- c(
  azul_turquesa = "#1699B5",
  azul_medio = "#1F5FAF",
  dorado_suave = "#E8B84A",
  violeta = "#7B63C9",
  azul_marino = "#1E1D72"
)


# ------------------------------------------------------------
# 3. Violin plot
# ------------------------------------------------------------
# Un violin plot muestra la forma de la distribución por grupo.
#
# A diferencia del boxplot, el violin plot permite observar dónde
# se concentran más los valores.
#
# En este ejemplo:
# - eje x: Etapas
# - eje y: TAR
# - fill: Etapas
#
# Además combinamos geom_violin() con geom_boxplot() para mostrar
# tanto la forma de la distribución como un resumen compacto.

figura_violin_tar <- ggplot(
  datos_expresion,
  aes(x = Etapas, y = TAR, fill = Etapas)
) +
  geom_violin(
    alpha = 0.7,
    trim = FALSE
  ) +
  geom_boxplot(
    width = 0.15,
    alpha = 0.6,
    outlier.shape = NA
  ) +
  scale_fill_manual(values = paleta_u3) +
  labs(
    title = "Distribución de TAR por etapa",
    subtitle = "Violin plot con boxplot interno",
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_minimal()

figura_violin_tar

ggsave(
  filename = "results/extra_violin_TAR_etapas.png",
  plot = figura_violin_tar,
  width = 7,
  height = 5,
  units = "in",
  dpi = 300
)

# Preguntas para explorar:
# ¿El violin plot muestra diferencias de forma entre etapas?
# ¿El boxplot interno ayuda o satura la figura?
# ¿En qué casos preferirías un boxplot simple?


# ------------------------------------------------------------
# 4. Gráfica de densidad
# ------------------------------------------------------------
# Una gráfica de densidad también permite explorar la distribución
# de una variable numérica.
#
# A diferencia del histograma, la densidad muestra una curva suavizada.
# Esto puede ser útil para comparar grupos, pero hay que recordar que
# la curva depende de un procedimiento de suavizado.

figura_densidad_tar <- ggplot(
  datos_expresion,
  aes(x = TAR, fill = Etapas)
) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = paleta_u3) +
  labs(
    title = "Densidad de TAR por etapa",
    subtitle = "Distribución suavizada de los valores de TAR",
    x = "Expresión de TAR",
    y = "Densidad",
    fill = "Etapa"
  ) +
  theme_minimal()

figura_densidad_tar

# Preguntas para explorar:
# ¿Las curvas se enciman mucho?
# ¿La densidad permite comparar mejor o peor que el histograma?
# ¿Qué se pierde al suavizar la distribución?


# ------------------------------------------------------------
# 5. Paleta accesible tipo Okabe-Ito
# ------------------------------------------------------------
# Esta paleta se usa con frecuencia porque es más amigable para
# personas con deficiencias en la visión del color.
#
# No significa que siempre sea la única opción, pero es una buena
# referencia para pensar en accesibilidad visual.

paleta_okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73",
  "#F0E442", "#0072B2", "#D55E00",
  "#CC79A7"
)

figura_okabe_ito <- ggplot(
  datos_expresion,
  aes(x = Etapas, y = TAR, fill = Etapas)
) +
  geom_boxplot(
    alpha = 0.7,
    outlier.shape = NA
  ) +
  geom_jitter(
    aes(color = Etapas),
    width = 0.15,
    alpha = 0.45,
    size = 1.8,
    show.legend = FALSE
  ) +
  scale_fill_manual(values = paleta_okabe_ito[1:3]) +
  scale_color_manual(values = paleta_okabe_ito[1:3]) +
  labs(
    title = "Expresión de TAR por etapa",
    subtitle = "Ejemplo con paleta accesible tipo Okabe-Ito",
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa"
  ) +
  theme_classic()

figura_okabe_ito

# Preguntas para explorar:
# ¿Los colores se distinguen claramente?
# ¿La figura podría entenderse si se imprimiera en escala de grises?
# ¿Qué otros elementos además del color ayudan a interpretar la figura?


# ------------------------------------------------------------
# 6. Paletas viridis para variables continuas
# ------------------------------------------------------------
# viridis ofrece paletas útiles para variables continuas.
#
# En este ejemplo:
# - eje x: CO
# - eje y: GA
# - color: TAR
#
# TAR es una variable numérica continua, por eso usamos
# scale_color_viridis_c().
#
# Este bloque solo se ejecuta si el paquete viridis está instalado.

if (requireNamespace("viridis", quietly = TRUE)) {

  library(viridis)

  figura_viridis_tar <- ggplot(
    datos_expresion,
    aes(x = CO, y = GA, color = TAR)
  ) +
    geom_point(size = 2, alpha = 0.8) +
    scale_color_viridis_c() +
    labs(
      title = "Relación entre CO y GA",
      subtitle = "Color continuo según TAR",
      x = "CO",
      y = "GA",
      color = "TAR"
    ) +
    theme_minimal()

  figura_viridis_tar

} else {

  message(
    "El paquete 'viridis' no está instalado. ",
    "Puedes instalarlo con install.packages('viridis')."
  )

}

# Preguntas para explorar:
# ¿Qué aporta usar una variable continua como color?
# ¿El color ayuda a interpretar o agrega demasiada información?


# ------------------------------------------------------------
# 7. Personalizar un tema: fondo oscuro y tipografía serif
# ------------------------------------------------------------
# En la práctica general usamos temas sencillos como theme_minimal()
# o theme_classic().
#
# Aquí modificaremos más elementos para que el cambio sea notorio:
#
# - fondo oscuro;
# - letras claras;
# - título en dorado;
# - cuadrícula tenue;
# - tiras de facetas oscuras;
# - tipografía serif.
#
# Sobre la tipografía:
# En ggplot2 podemos usar base_family = "serif".
# Esta opción es más portable entre computadoras. En muchos sistemas
# se verá como Times, Times New Roman o una fuente serif parecida.
#
# También podrías probar base_family = "Times New Roman", pero puede
# fallar si esa fuente no está registrada en el sistema gráfico de R.

tema_oscuro_serif <- theme_minimal(
  base_size = 13,
  base_family = "serif"
) +
  theme(
    # Fondo general de toda la figura
    plot.background = element_rect(
      fill = "#111827",
      color = NA
    ),

    # Fondo del panel donde se dibujan los datos
    panel.background = element_rect(
      fill = "#111827",
      color = NA
    ),

    # Cuadrícula principal: visible pero discreta
    panel.grid.major = element_line(
      color = "#374151",
      linewidth = 0.35
    ),

    # Quitamos la cuadrícula menor para limpiar la figura
    panel.grid.minor = element_blank(),

    # Título y subtítulo
    plot.title = element_text(
      color = "#E8B84A",
      face = "bold",
      size = 17
    ),
    plot.subtitle = element_text(
      color = "#F3F4F6",
      size = 12
    ),

    # Ejes
    axis.title = element_text(
      color = "#F9FAFB",
      face = "bold"
    ),
    axis.text = element_text(
      color = "#E5E7EB"
    ),

    # Leyenda
    legend.background = element_rect(
      fill = "#111827",
      color = NA
    ),
    legend.key = element_rect(
      fill = "#111827",
      color = NA
    ),
    legend.title = element_text(
      color = "#F9FAFB",
      face = "bold"
    ),
    legend.text = element_text(
      color = "#E5E7EB"
    ),

    # Facetas, si se usan
    strip.background = element_rect(
      fill = "#1E1D72",
      color = NA
    ),
    strip.text = element_text(
      color = "white",
      face = "bold"
    ),

    # Pie de figura
    plot.caption = element_text(
      color = "#9CA3AF",
      hjust = 0
    )
  )

# Aplicamos el tema oscuro a una figura tipo boxplot + puntos.
#
# Importante:
# En fondos oscuros conviene revisar que los puntos, líneas y textos
# tengan suficiente contraste.

figura_tema_oscuro <- ggplot(
  datos_expresion,
  aes(x = Etapas, y = TAR, fill = Etapas)
) +
  geom_boxplot(
    alpha = 0.75,
    width = 0.55,
    outlier.shape = NA,
    color = "#F9FAFB"
  ) +
  geom_jitter(
    aes(color = Etapas),
    width = 0.12,
    alpha = 0.7,
    size = 1.9,
    show.legend = FALSE
  ) +
  scale_fill_manual(values = paleta_u3) +
  scale_color_manual(values = paleta_u3) +
  labs(
    title = "Expresión de TAR por etapa",
    subtitle = "Ejemplo con fondo oscuro y tipografía serif",
    x = "Etapa",
    y = "Expresión de TAR",
    fill = "Etapa",
    caption = "Tema personalizado para explorar decisiones visuales."
  ) +
  tema_oscuro_serif

figura_tema_oscuro

ggsave(
  filename = "results/extra_tema_oscuro_serif_TAR.png",
  plot = figura_tema_oscuro,
  width = 7,
  height = 5,
  units = "in",
  dpi = 300
)

# Preguntas para explorar:
# ¿El fondo oscuro mejora o dificulta la lectura?
# ¿Los colores siguen siendo distinguibles?
# ¿La tipografía serif cambia la percepción visual de la figura?
# ¿Usarías este estilo para un artículo, una clase o una presentación?


# ------------------------------------------------------------
# 8. Facetas con fondo oscuro
# ------------------------------------------------------------
# Podemos reutilizar el mismo tema en una gráfica con facetas.
#
# En este ejemplo separamos la relación entre CO y GA por etapa.
# Así podemos comparar paneles sin encimar toda la información.

figura_facetas_oscuras <- ggplot(
  datos_expresion,
  aes(x = CO, y = GA, color = Etapas)
) +
  geom_point(alpha = 0.75, size = 2) +
  facet_wrap(~ Etapas) +
  scale_color_manual(values = paleta_u3) +
  labs(
    title = "Relación entre CO y GA por etapa",
    subtitle = "Facetas con tema oscuro personalizado",
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  tema_oscuro_serif

figura_facetas_oscuras

# Preguntas para explorar:
# ¿Las facetas ayudan a observar patrones por etapa?
# ¿La cuadrícula oscura es suficiente para leer los ejes?
# ¿Qué cambiarías si la figura se va a proyectar en clase?


# ------------------------------------------------------------
# 9. Facetas con un tema claro y limpio
# ------------------------------------------------------------
# Ahora haremos una versión más común para figuras científicas:
#
# - fondo blanco;
# - sin cuadrícula;
# - ejes visibles;
# - colores de la paleta de la unidad;
# - estructura más sobria.
#
# Esta versión puede ser más adecuada para reportes, artículos,
# tareas o materiales donde se busca una figura limpia y fácil de leer.
#
# theme_classic() genera una figura con fondo blanco, sin líneas de
# cuadrícula y con ejes visibles. Es una opción frecuente cuando queremos
# evitar que el fondo compita con los datos.

figura_facetas_claras <- ggplot(
  datos_expresion,
  aes(x = CO, y = GA, color = Etapas)
) +
  geom_point(
    alpha = 0.75,
    size = 2
  ) +
  facet_wrap(~ Etapas) +
  scale_color_manual(values = paleta_u3) +
  labs(
    title = "Relación entre CO y GA por etapa",
    subtitle = "Facetas con fondo blanco y estilo limpio",
    x = "CO",
    y = "GA",
    color = "Etapa"
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 14
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    axis.title = element_text(
      face = "bold"
    ),
    strip.background = element_rect(
      fill = "#F2F2F2",
      color = "gray70"
    ),
    strip.text = element_text(
      face = "bold"
    ),
    legend.position = "right"
  )

figura_facetas_claras

ggsave(
  filename = "results/extra_facetas_claras_CO_GA.png",
  plot = figura_facetas_claras,
  width = 8,
  height = 5,
  units = "in",
  dpi = 300
)


# Mini desafío:
# Cambia el tema de la figura y compara los resultados.
#
# Opción A:
# + theme_minimal()
#
# Opción B:
# + theme_bw()
#
# Opción C:
# + theme_light()
#
# Opción D:
# + theme_classic()
#
# Preguntas:
# ¿Cuál tema permite leer mejor los puntos?
# ¿Cuál facilita comparar las facetas?
# ¿Cuál usarías en una presentación?
# ¿Cuál usarías en un reporte o artículo?
# ¿La cuadrícula ayuda o distrae?


# Preguntas para explorar:
# ¿Cuál versión se lee mejor: la oscura o la clara?
# ¿El fondo blanco facilita comparar los paneles?
# ¿La ausencia de cuadrícula mejora o dificulta leer los valores?
# ¿Qué estilo usarías para una presentación y cuál para un manuscrito?


# ------------------------------------------------------------
# 10. Figuras multipanel con patchwork
# ------------------------------------------------------------
# patchwork permite unir varias figuras en una sola composición.
#
# Esto es útil cuando queremos preparar figuras tipo artículo con
# paneles A, B, C.
#
# Este bloque solo se ejecuta si patchwork está instalado.

if (requireNamespace("patchwork", quietly = TRUE)) {

  library(patchwork)

  figura_histograma_tar <- ggplot(
    datos_expresion,
    aes(x = TAR, fill = Etapas)
  ) +
    geom_histogram(bins = 20, alpha = 0.7) +
    scale_fill_manual(values = paleta_u3) +
    labs(
      title = "A. Distribución de TAR",
      x = "TAR",
      y = "Frecuencia",
      fill = "Etapa"
    ) +
    theme_minimal()

  figura_boxplot_tar <- ggplot(
    datos_expresion,
    aes(x = Etapas, y = TAR, fill = Etapas)
  ) +
    geom_boxplot(alpha = 0.7, outlier.shape = NA) +
    geom_jitter(
      aes(color = Etapas),
      width = 0.15,
      alpha = 0.4,
      show.legend = FALSE
    ) +
    scale_fill_manual(values = paleta_u3) +
    scale_color_manual(values = paleta_u3) +
    labs(
      title = "B. TAR por etapa",
      x = "Etapa",
      y = "TAR",
      fill = "Etapa"
    ) +
    theme_minimal()

  # Unimos las figuras con el operador + de patchwork.
  figura_panel_tar <- figura_histograma_tar + figura_boxplot_tar

  figura_panel_tar

  ggsave(
    filename = "results/extra_panel_patchwork_TAR.png",
    plot = figura_panel_tar,
    width = 10,
    height = 5,
    units = "in",
    dpi = 300
  )

} else {

  message(
    "El paquete 'patchwork' no está instalado. ",
    "Puedes instalarlo con install.packages('patchwork')."
  )

}

# Preguntas para explorar:
# ¿Qué aporta poner dos gráficas juntas?
# ¿Las dos figuras cuentan partes distintas de la misma historia?
# ¿La composición queda equilibrada?


# ------------------------------------------------------------
# 11. Ejercicio extra con starwars
# ------------------------------------------------------------
# La base starwars está incluida en dplyr.
# Sirve para practicar visualización en un contexto más ligero.
#
# Aquí aplicamos varias ideas vistas en la Unidad 2 y Unidad 3:
# - select(): seleccionar columnas;
# - filter(): quitar valores faltantes;
# - ggplot(): construir una gráfica;
# - geom_point(): mostrar relación entre dos variables numéricas.

datos_starwars_limpios <- starwars %>%
  select(name, species, height, mass, gender) %>%
  filter(!is.na(height), !is.na(mass))

glimpse(datos_starwars_limpios)

figura_starwars <- ggplot(
  datos_starwars_limpios,
  aes(x = height, y = mass)
) +
  geom_point(aes(color = gender), alpha = 0.7) +
  labs(
    title = "Relación entre altura y masa en starwars",
    subtitle = "Ejemplo extra para practicar dispersión",
    x = "Altura",
    y = "Masa",
    color = "Género"
  ) +
  theme_minimal()

figura_starwars

# Preguntas:
# ¿Hay valores extremos?
# ¿Qué ocurre con la escala del eje y?
# ¿El color por género ayuda a interpretar o satura la figura?
# ¿Qué otra variable podrías usar como color?


# ------------------------------------------------------------
# 12. Nota sobre gráficos 3D
# ------------------------------------------------------------
# Los gráficos 3D pueden ser atractivos, pero no siempre facilitan
# la interpretación. En muchos casos, una figura 2D bien construida
# comunica mejor el patrón.
#
# En análisis transcriptómico, algunas visualizaciones interactivas
# o reducciones de dimensión pueden explorarse en 3D, pero antes de
# usarlas conviene preguntar:
#
# - ¿la tercera dimensión aporta información real?
# - ¿la figura sigue siendo interpretable?
# - ¿puede exportarse o compartirse de forma clara?
# - ¿una versión 2D sería suficiente?
#
# Por ahora no haremos gráficos 3D en este script. La prioridad es
# dominar la relación entre pregunta, variables, tipo de datos y gráfica.


# ------------------------------------------------------------
# 13. Nota sobre figuras publicadas
# ------------------------------------------------------------
# Si una figura publicada sirve como inspiración:
#
# 1. Busca si el artículo publicó datos o scripts.
# 2. Revisa la licencia.
# 3. Adapta la idea visual, no copies la figura.
# 4. Usa tus propios datos.
# 5. Cita el trabajo si la estructura visual inspiró tu análisis.
#
# Prompt sugerido:
#
# Vi en un artículo una figura con boxplot, puntos individuales
# y facetas. No quiero copiar la figura original. Quiero construir
# una figura con una estructura similar usando mis propios datos.
# Mi base tiene estas variables: [...]
# Sugiere un código base en ggplot2 y dime qué debo verificar.


# ------------------------------------------------------------
# 14. Verificación final
# ------------------------------------------------------------
# Revisa qué figuras se guardaron en results/.

list.files("results")

# Fin del script Para seguir explorando.

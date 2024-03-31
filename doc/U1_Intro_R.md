# Fundamentos de programación en R
## Unidad 1: Introducción a R

---
### ¿Qué es R?  

R es un lenguaje de programación y un entorno de software ampliamente utilizado en estadística y análisis de datos. 
A continuación se mencionan seis puntos que explican qué es R:

1. **Lenguaje de programación orientado a estadísticas:**  R es un lenguaje diseñado específicamente para el análisis estadístico y la visualización de datos. Ofrece una amplia gama de funciones y bibliotecas especializadas para realizar tareas estadísticas avanzadas como modelado, pruebas de hipótesis, análisis de series temporales y más.

2. **Entorno de software de código abierto:** R es un software de código abierto, lo que significa que su código fuente está disponible públicamente y es gratuito para su uso y modificación. Esta característica ha llevado a una comunidad activa de desarrolladores que contribuyen con paquetes, extensiones y mejoras constantes al ecosistema de R.

3. **Gráficos y visualización de datos:** Una de las fortalezas principales de R es su capacidad para generar gráficos de alta calidad y visualizaciones de datos. Con paquetes como ggplot2, R proporciona herramientas flexibles y potentes para crear una amplia variedad de gráficos, desde simples diagramas de dispersión hasta complejos gráficos de series temporales y mapas geoespaciales.

4. **Análisis de datos reproducibles:** R fomenta la práctica de análisis de datos reproducibles al permitir a los usuarios escribir scripts y documentos dinámicos utilizando herramientas como R Markdown y knitr. Estas herramientas permiten combinar código, resultados y visualizaciones en un solo documento, facilitando la comunicación y la replicabilidad de los análisis.

5. **Amplia comunidad y soporte:** R cuenta con una comunidad activa de usuarios y desarrolladores que contribuyen con tutoriales, documentación, paquetes y soporte en línea a través de foros, listas de correo y sitios web especializados. Esta comunidad ayuda a los usuarios a resolver problemas, compartir conocimientos y mantenerse actualizados sobre las últimas tendencias y técnicas en análisis de datos.

6. **Integración con otras tecnologías:** R se integra fácilmente con otras tecnologías y lenguajes de programación, lo que lo hace interoperable con una variedad de herramientas y plataformas. Por ejemplo, existen paquetes que permiten la conexión de R con bases de datos, sistemas de almacenamiento en la nube, herramientas de big data como Hadoop y Spark, y lenguajes como Python, facilitando la integración de R en flujos de trabajo complejos y entornos tecnológicos diversos.

---
### Datos curiosos

R fue desarrollado inicialmente por Ross Ihaka y Robert Gentleman en 1993.  

La pregunta más frecuente sobre R: **"¿Por qué las versiones de R tienen nombres raros?"**


![alt text](Imagen_1_1.png)


> R version 4.3.3 (Angel Food Cake) has been released on 2024-02-29.

Respuesta: "Todos los nombres de los lanzamientos son referencias a las tiras/películas de Peanuts".

---
### ¿Por qué usar R en las ciencias?

**Pros:**

1. **Amplia gama de herramientas estadísticas:** R ofrece una amplia variedad de paquetes y funciones especializadas en análisis estadístico, lo que permite realizar análisis complejos y avanzados de datos.

2. **Gráficos de alta calidad:** R proporciona herramientas poderosas para la visualización de datos, lo que permite crear gráficos de alta calidad que son fundamentales para la presentación e interpretación de resultados.

3. **Flexibilidad y personalización:** R es altamente flexible y permite a los usuarios personalizar y adaptar análisis y visualizaciones según las necesidades específicas de su investigación.

4. **Reproducibilidad y transparencia:** R fomenta la práctica de la ciencia reproducible al permitir a los investigadores escribir scripts y documentos dinámicos para llevar un registro y compartir su análisis de datos de manera transparente.

5. **Comunidad activa:** R cuenta con una comunidad activa de usuarios y desarrolladores en el campo de las ciencias, lo que facilita el acceso a recursos, tutoriales y soporte en línea.

6. **Integración con otras herramientas y tecnologías:** R se integra fácilmente con otras herramientas y tecnologías utilizadas en las ciencias biológicas, como bases de datos, software de secuenciación genómica y herramientas de análisis bioinformático, lo que facilita la integración de R en flujos de trabajo complejos.

**Contras:**

1. **Curva de aprendizaje inicial:** Para los principiantes, R puede tener una curva de aprendizaje pronunciada debido a su sintaxis y estructura de programación, lo que puede requerir tiempo y esfuerzo para dominar.

2. **Dependencia de scripts y programación:** Utilizar R efectivamente en las ciencias a menudo requiere escribir scripts y código, lo que puede ser una barrera para los científicos biológicos que no tienen experiencia en programación.

3. **Actualización y mantenimiento de paquetes:** Dado que R es un ecosistema en constante evolución con nuevos paquetes y versiones que se lanzan regularmente, puede requerir esfuerzos significativos para mantenerse al día con las últimas actualizaciones y mantener la compatibilidad entre paquetes.

4. **Documentación mayoritariamente en inglés:** la predominancia del inglés en la documentación de R puede representar una barrera pero también es importante reconocer los esfuerzos de la comunidad de R para traducir la documentación a otros idiomas y hacer que R sea más accesible para una audiencia global.


- **¿Limitaciones en el manejo de grandes conjuntos de datos?**
Ver [¿Cuantos Datos Puede Manejar R?](https://www.youtube.com/watch?v=5bhqkMMrBmU)

---

**¿Hay otras razones para aprender R?**
- Diversas herramientas, desde análisis de regresión hasta el análisis bayesiano.
- R es el segundo lenguaje más utilizado en la minería de datos, después de SQL.
- Tiene la facilidad de generar reportes en formatos html, pdf, word y presentaciones con Rmarkdown.
- R puede conectarse a una variedad de bases de datos con dbplyr
- Se pueden crear aplicaciones web interactivas con flexdashboard y convertirlas en videojuegos al estilo de NES con nessy. 
- Se pueden crear APIs web a partir de funciones de R, permitiendo su integración en otras aplicaciones. 

Estas capacidades hacen de R una herramienta versátil y poderosa para el análisis de datos y el desarrollo de aplicaciones.



## Fuentes de información recomendadas:
- https://bookdown.org/martin_monkman/DataScienceResources_book/r-release-names.html
- https://www.nytimes.com/2009/01/07/technology/business-computing/07program.html

**Cursos introductorios de R**

- https://datacarpentry.org/genomics-r-intro/00-introduction.html
- https://melbournebioinformatics.github.io/r-intro-biologists/intro_r_biologists.html

**R en las ciencias**
- The Use of R and R Packages in Biodiversity Conservation Research https://www.mdpi.com/1424-2818/15/12/1202
- Ten simple rules for teaching yourself R https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010372
- The R Language: An Engine for Bioinformatics and Data Science https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9148156/
- Why is R one of the best Statistical programming languages for Biomedical and Pharmaceutical industries. https://www.linkedin.com/pulse/why-r-one-best-statistical-programming-languages-biomedical-medin/

**R en español**
- Traducción del libro [**“R for Data Science”**](https://es.r4ds.hadley.nz/), de Hadley Wickham y Garrett Grolemund.
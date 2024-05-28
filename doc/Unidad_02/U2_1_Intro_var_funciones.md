# Fundamentos de programación en R

## Unidad 2

---

## 2.1 Introducción a las variables y funciones

---

### ¿Qué es una variable?

En R, **una variable es un contenedor donde se pueden almacenar y manipular datos**. Para reconocer "algo" como una variable hay que **asignarle un nombre único**. Puede almacenar **diferentes tipos de datos** (i.e., números, caractéres, matrices, vectores, data frames, listas).

Al definir una variable en R, estás creando un espacio en la memoria donde puedes almacenar valores y referenciarlos mediante el nombre asignado a esa variable.

Una analogía para entender qué es una variable en R es pensar en ella como un contenedor físico, por ejemplo, una caja o un recipiente, donde puedes colocar diferentes objetos. Cada contenedor tiene un nombre único que te permite identificarlo y acceder a su contenido cuando lo necesites.

![alt text](image_2.1_01.png)

Una variable en R es como un contenedor virtual donde puedes **guardar datos** y **referenciarlos** mediante un nombre único, como **caja1** en el ejemplo.

Así como puedes guardar **diferentes tipos de objetos en diferentes contenedores físicos**, en R puedes almacenar **diferentes tipos de datos en diferentes variables**.

---

#### EXTRA: ¿Variable es igual a objeto?

En el contexto de programación en R, los términos "variable" y "objeto" tienen significados específicos y relacionados, pero **no son completamente intercambiables**. 

1. **Variable:**
   - Una variable es un nombre simbólico que se utiliza para almacenar un valor o una referencia a un objeto. En otras palabras, una variable es un contenedor que puede contener diferentes tipos de datos a lo largo de su ciclo de vida.
   - En R, una variable se define mediante el operador de asignación `<-` o `=`.
   - Ejemplo:
     ```R
     x <- 42        # x es una variable que almacena el valor 42
     nombre <- "Juan" # nombre es una variable que almacena el string "Juan"
     ```

2. **Objeto:**
   - Un objeto es una instancia de una clase que puede almacenar datos y métodos para manipular esos datos. En R, casi todo es un objeto, incluyendo vectores, matrices, data.frames, listas, funciones, etc.
   - Los objetos en R tienen atributos y pueden ser manipulados mediante funciones.
   - Ejemplo:
   
     ```R
     vector <- c(1, 2, 3)          # vector es un objeto de clase "numeric"
     matriz <- matrix(1:9, nrow=3) # matriz es un objeto de clase "matrix"
     df <- data.frame(a = 1:3, b = c("x", "y", "z")) # df es un objeto de clase "data.frame"
     ```

##### Relación entre Variables y Objetos

- En R, las variables actúan como etiquetas o nombres que apuntan a objetos almacenados en la memoria. Cuando asignas un valor a una variable, estás creando un objeto y asignándolo a esa variable.
- Una variable puede cambiar el objeto al que apunta, pero el objeto en sí puede mantenerse igual si no se modifica explícitamente.

##### Ejemplo para ilustrar la diferencia:

```R
# Crear un objeto (vector) y asignarlo a una variable
mi_vector <- c(1, 2, 3, 4)

# Aquí, mi_vector es una variable que referencia un objeto de tipo vector

# Modificar el objeto
mi_vector <- mi_vector * 2

# La variable mi_vector ahora referencia un nuevo objeto, que es el resultado de multiplicar el original por 2
```

En resumen, una variable es una referencia o un nombre simbólico que apunta a un objeto, mientras que un objeto es una entidad en la memoria que puede contener datos y métodos para manipular esos datos. En R, casi todo es considerado un objeto, y las variables se utilizan para acceder y manipular estos objetos.

---

### Repaso: ¿qué es una variable?

- Una variable es un caracter o palabra que guarda un valor/objeto

- Operador flecha (**<-**), **debe apuntar hacia la variable**:

#### Ejercicio

Escribe los siguiente en tu editor en RStudio 

> Recuerda que para ejecutar cada operación hay que dar click en **Run** o **Ctrl + Enter** (Windows) o **Command + Enter** (MacOs).

```R
# Recordando el ejemplo de la caja, la caja en donde guardaras el valor 5 se llamará x
 x <- 5
# Ahora revisa lo que tiene tu variable x
x
```

La dirección de la flecha, ¿funciona en ambas direcciones? Haz la prueba y dinos que pasa.

```R
# La caja, es decir la variable se llama x y el valor u objeto que estamos asignado es 10
10 -> x
#Imprime x
x
# ¿Qué pasa en este caso?
10 <- x
```

---

### Tips para escoger los nombres de las variables

Aquí estan algunas recomendaciones al elegir como nombrarás a una nueva variable:

- Usa nombres descriptivos.
- Sigue una convención de nombres consistente.
- Usa nombres en inglés.
- Sé conciso pero claro.
- Usa prefijos y sufijos cuando sea necesario.
- Utiliza comentarios cuando sea necesario.

Por otro lado, aquí está lo que debes evitar al nombrar una nueva variable:

- Evita palabras reservadas.
- Evita nombres confusos, ambiguos o crípticos.
- Evita nombres de variables similares.
- Evita nombres de una sola letra, excepto en contextos específicos (como en una prueba rápida).
- No uses nombres que coincidan con funciones integradas.
- No empieces los nombres de variables con un número.
- Evita caracteres especiales en los nombres de variables.
- Usa nombres descriptivos pero concisos.

#### Ejemplo

De la siguiente lista, ¿cuáles son los nombres de variables que debemos evitar?

| Nombres        | Válido |
|----------------|--------|
| min_height     | ✓      |
| max.height     | ✓      |
| _age           | ✗      |
| .mass          | ✗      |
| MaxLength      | ✓      |
| min-length     | ✗      |
| 2widths        | ✗      |
| celsius2kelvin | ✓      |

---

#### Ejercicio: reescribir el valor de una variable o asignarlo a una nueva

Vamos a practicar en R cómo asignar valores a una variable.

```R
# Agregar un valor a la variable
x <- 5

# Imprime lo que contiene la variable X
x 

# Suma 1 a "x"
x + 1 

# Revisa si se guardo el valor de 6 en "x"
x

#¿Qué sucedió? 
```

**Si no se guarda el valor**, es decir, sino se vuelve a asignar con el operador flecha **<-**, el resultado de la operación solo se imprime. En este caso estamos manipulando los objetos (sumando el objeto de la variable **x**, que es **5**, más **1**, que es otro objeto) pero no estamos modificando la variable.

```R
#Para guardar este valor podemos reescribir la variable
# Incrementamos x en 1:
x <- x + 1
x

# O podemos asignar este nuevo valor a otra variable
# y es el valor de x multiplicado por dos
y <- x * 2 

# Verifica que valores tiene "x" y "y"
x
y
```

> PRECAUCIÓN:

Sobrescribir variables es una práctica común en R y puede ser útil en contextos específicos, por ejemplo, ayuda a reducir el uso de memoria de la computadora. Sin embargo, hay que tener cuidado con la potencial pérdida de información al sobrescribir una variable por error, además de que puede ser difícil rastrear los cambios.

Por otro lado, el crear muchas variables nuevas en tus scripts también tiene sus propias ventajas y desventajas a considerar:

| Ventajas                         | Desventajas                            |
|----------------------------------|----------------------------------------|
| Claridad y legibilidad           | Consumo de memoria                     |
| Trazabilidad y depuración        | Complejidad y mantenimiento            |
| Evitar sobrescritura accidental  | Posibilidad de confusión               |
| Facilitar el reuso de datos      | Dificultad para seguir el flujo de datos|

En resumen, se recomienda buscar un equilibrio entre tus decisiones de crear nuevas variables o sobreescribir las que tienes, esto puede depender de la cantidad de datos que manejes, la memoria de tu computadora y que tan complejo puede ser el rastreo de los cambios en tu script.

---

## Conceptos básicos: funciones

Previamente, vimos de manera general que con las funciones damos instrucciones a R para llevar a cabo alguna operación. La siguiente imagen muestra cómo usamos la función `plot`para realizar una operación, que en este caso es generar un gráfico. 

> REPASO: Recordemos cómo se "llama" una función. Empiezan por el nombre de la función (plot), seguido por paréntesis, en donde estan los argumentos y parámetros:

![alt text](image_2.1_02.png)

Hemos vistó como podemos **usar una función**, pero **¿qué es una función?**

En R, las funciones pueden compararse con una caja que recibe **entradas** (inputs), las procesa y luego genera **salidas** (outputs).

Imagina que una función es como una maquina a la que agregas diferentes ingredientes y aunque no vez a simple vista lo que pasa dentro de la maquina, el resultado final es una increible barra de chocolate.

![alt text](image_2.1_05.png)

En "Charlie y la fábrica de chocolate" de Roald Dahl, Willy Wonka tiene varias máquinas y dispositivos que transforman ingredientes en deliciosos y mágicos dulces y chocolates.

Esos ejemplos ilustran bien la idea de una caja o dispositivo mágico donde se introducen materiales y se obtiene un resultado final de manera sorprendente, similar a cómo funcionan las funciones en R: introduciendo **argumentos (inputs)**, procesándolos y obteniendo un **resultado (output)**.

![alt text](image_2.1_04.png)

El cuerpo de la función, donde se procesan estos **inputs** para convertirlos en **outputs**, se encuentra **dentro de llaves**.

### Ejemplo - función

En tu editor vamos a ver cómo luce por dentro la función `plot`.

```R
#Ejecuta la siguiente línea así como está
plot.default

```

¿Qué obtuviste?

```R
> plot.default
function (x, y = NULL, type = "p", xlim = NULL, ylim = NULL, 
    log = "", main = NULL, sub = NULL, xlab = NULL, ylab = NULL, 
    ann = par("ann"), axes = TRUE, frame.plot = axes, panel.first = NULL, 
    panel.last = NULL, asp = NA, xgap.axis = NA, ygap.axis = NA, 
    ...) 
{
    localAxis <- function(..., col, bg, pch, cex, lty, lwd) Axis(...)
    localBox <- function(..., col, bg, pch, cex, lty, lwd) box(...)
    localWindow <- function(..., col, bg, pch, cex, lty, lwd) plot.window(...)
    localTitle <- function(..., col, bg, pch, cex, lty, lwd) title(...)
    xlabel <- if (!missing(x)) 
        deparse1(substitute(x))
    ylabel <- if (!missing(y)) 
        deparse1(substitute(y))
    xy <- xy.coords(x, y, xlabel, ylabel, log)
    xlab <- if (is.null(xlab)) 
        xy$xlab
    else xlab
    ylab <- if (is.null(ylab)) 
        xy$ylab
    else ylab
    xlim <- if (is.null(xlim)) 
        range(xy$x[is.finite(xy$x)])
    else xlim
    ylim <- if (is.null(ylim)) 
        range(xy$y[is.finite(xy$y)])
    else ylim
    dev.hold()
    on.exit(dev.flush())
    plot.new()
    localWindow(xlim, ylim, log, asp, ...)
    panel.first
    plot.xy(xy, type, ...)
    panel.last
    if (axes) {
        localAxis(if (is.null(y)) 
            xy$x
        else x, side = 1, gap.axis = xgap.axis, ...)
        localAxis(if (is.null(y)) 
            x
        else y, side = 2, gap.axis = ygap.axis, ...)
    }
    if (frame.plot) 
        localBox(...)
    if (ann) 
        localTitle(main = main, sub = sub, xlab = xlab, ylab = ylab, 
            ...)
    invisible()
}
<bytecode: 0x7fa9fadefc68>
<environment: namespace:graphics>
```

Si quieres saber como esta construida otra función, escribe el nombre de la función sin los paréntesis.

```R
# por ejemplo la función lm - modelos lineales
lm
```

---

### Tips en el editor y en la línea de comandos de la consola

En la [Unidad 1.2 RStudio](../Unidad_01/U1_2_Rstudio.md) mencionamos brevemente la utilidad de **Tab**. Recordemoslo ahora:

- Al presionar 1 vez Tab (tabulador), se muestran sugerencias

- Al presionar 2 veces Tab, se auto-completa en nombre de la función con la primera sugerencia.

![alt text](image_2.1_03.png)

### REPASO: Ejemplos de funciones básicas

- Como vimos previamente, para instalar un paquete necesitamos de la función `install.packages()`. En este ejemplo se muestra la línea de comando para instalar el paquete `ggplot2` desde el Editor.

```R
#Para instalar un nuevo paquete necesitas la función install.packages
#Generalmente el nombre del paquete va entre comillas. 
#Versiones más recientes pueden aceptar el nombre sin comillas

install.packages("ggplot2")
```

- Para saber más acerca de como utilizar una función, qué es lo que necesitas ingresar como argumentos y parámetros, podemos usar la función `help()`

```R
# La función Help
help()
# Para buscar un paquete o función en específico. 
# Por ejemplo, para la función "plot"
help(plot)
# ¿Qué pasa si usas la función help() para saber más de "help"?
help("help")
```

#### Fuentes de información

- [Funciones básicas de R](https://fhernanb.github.io/Manual-de-R/funbas.html
)

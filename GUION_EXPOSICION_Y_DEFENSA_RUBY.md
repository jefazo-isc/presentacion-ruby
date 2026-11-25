# Guion Verbatim, Explicación Sintáctica y Banco de Defensa — Exposición Ruby (Compiladores II)

> [!IMPORTANT]
> **Regla de Oro de la Rúbrica (70 pts Equipo + 30 pts Individual):**
> - **Todos** los integrantes deben dominar **toda** la exposición (la docente puede preguntar a cualquiera sobre cualquier bloque).
> - **Prohibido** memorizar sin entender: cada afirmación (*"tipado fuerte"*, *"YARV"*, *"todo es objeto"*, *"GVL"*) debe justificarse con razones técnicas y ejemplos.
> - **Sin relojes ni tiempos visibles** en pantalla; mantengan un ritmo fluido, natural y seguro (~50 min en total con ronda de preguntas).
> - **Vestimenta formal** obligatoria y asistencia a todas las presentaciones (la rúbrica descuenta 5 pts por inasistencia).

---

## 1. Tabla de Distribución de los 6 Integrantes

| # | Integrante | Bloque Temático | Diapositivas en Pantalla (`N / 31`) | IDs Internos | Criterios de Rúbrica que Cubre |
| :-: | :--- | :--- | :--- | :--- | :--- |
| **1** | **Américo Ismael Calzada Martínez** | **Bloque 1:** Introducción, historia y origen | `1 / 31` a `7 / 31` | Slides `1`, `2`, `3`, `101`, `4`, `5`, `6` | **C1 (10 pts):** Identidad, Matz, evolución hasta 4.0, influencias y fuentes. **C2:** "Todo es objeto". |
| **2** | **Jesús Eduardo Tapia Ávalos** | **Bloque 2:** Filosofía y arquitectura YARV/YJIT | `8 / 31` a `11 / 31` | Slides `102`, `7`, `8`, `9` | **C3 (14 pts):** Pipeline Lexer/Ripper → Parser/AST (Prism) → Bytecode YARV → YJIT. **C2:** Tipado dinámico fuerte y POLS. |
| **3** | **Luis Antonio García Gómez** | **Bloque 3:** Sintaxis y fundamentos técnicos | `12 / 31` a `15 / 31` | Slides `103`, `10`, `11`, `12` | **C2 (14 pts):** Sigils (`@`, `@@`, `$`), operador `<=>`, Símbolos vs Strings, interpolación, `&`, E/S. **C6 (8 pts):** Demo viva. |
| **4** | **José Alberto Vázquez Guerrero** | **Bloque 4:** Control de flujo y POO pura | `16 / 31` a `20 / 31` | Slides `104`, `13`, `14`, `15`, `16` | **C2 (14 pts):** Todo es expresión, `unless`, `===`, `yield`, Procs vs Lambdas, `BasicObject`, herencia `<` y mixins. **C6:** Demo viva. |
| **5** | **Ricardo Padilla Hernández** | **Bloque 5:** Ecosistema y aplicaciones reales | `21 / 31` a `24 / 31` | Slides `105`, `17`, `18`, `19` | **C5 (6 pts):** Ruby vs RubyGems vs Bundler (`Gemfile.lock`) vs Rails (MVC, CoC, DRY), casos reales (GitHub, Shopify) y script OS. |
| **6** | **Yahir Guevara Cardona** | **Bloque 6:** Evaluación crítica, rendimiento y cierre | `25 / 31` a `31 / 31` | Slides `106`, `20`, `21`, `22`, `23`, `24`, `25` | **C4 (14 pts):** Ventajas vs límites (GVL/GIL, CPU vs I/O, YJIT/ZJIT), comparativa Ruby/Python/Java, cuándo SÍ/NO usar y cierre. |

---

## 2. Guion Verbatim Diapositiva por Diapositiva (con Explicación Sintáctica)

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 1: Américo Ismael Calzada Martínez (Bloque 1: Introducción, historia y origen)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 1 / 31 (ID 1): Portada — *Ruby*
│ "Buenos días, maestra y compañeros. Somos el equipo encargado de presentar el lenguaje de programación Ruby para la Unidad V de Compiladores II. A lo largo de esta exposición analizaremos su historia, su filosofía, su arquitectura interna de compilación y ejecución en la máquina virtual YARV, su sintaxis paso a paso, la programación orientada a objetos pura, su ecosistema en producción y una evaluación crítica profesional. Yo soy Américo Ismael Calzada Martínez y daré inicio con el primer bloque."

* **Código en consola (`hola_ruby.rb`):** `puts "¡Hola, Ruby!"`
  * **Explicación sintáctica rápida:** `puts` (*put string*) es un método del módulo `Kernel` (mezclado en `Object`); observa que en Ruby **los paréntesis son opcionales** al invocar métodos (`puts "¡Hola, Ruby!"` equivale a `puts("¡Hola, Ruby!")`) y no requiere `;` al final de la línea.
  * **Qué señalar en la consola:** Al aparecer `¡Hola, Ruby!` con el indicador verde (`✔ ... ms`), señala que **no hubo compilación manual previa** ni función `main`: el servidor ejecutó el archivo en tiempo real con `ruby` y `puts` agregó automáticamente el salto de línea final.

#### 🎙 Diapositiva 2 / 31 (ID 2): Objetivos de aprendizaje
│ "Nuestros objetivos al exponer Ruby se alinean directamente con el análisis de lenguajes de la materia. Primero, comprender su origen, su filosofía orientada al programador y su arquitectura de ejecución desde código fuente hasta bytecode en YARV y código nativo con YJIT. Segundo, explicar con precisión su sintaxis, sus prefijos léxicos y su paradigma orientado a objetos puro. Tercero, distinguir correctamente entre el lenguaje Ruby, las bibliotecas en RubyGems y el framework Ruby on Rails. Y cuarto, evaluar técnicamente sus ventajas, sus límites de concurrencia y su vigencia frente a Python y Java."

#### 🎙 Diapositiva 3 / 31 (ID 3): Distribución de expositores
│ "La exposición está estructurada en seis bloques para los seis integrantes del equipo. Su servidor, Américo Calzada, presenta la introducción, historia y origen. Después, Eduardo Tapia explicará la filosofía y el pipeline de traducción y ejecución en YARV. Luis García detallará la sintaxis, los sigils y los tipos de datos. Alberto Vázquez abordará las estructuras de control y la programación orientada a objetos pura. Ricardo Padilla cubrirá el ecosistema, RubyGems, Rails y casos reales. Finalmente, Yahir Guevara cerrará con la evaluación crítica de rendimiento, GVL y conclusiones."

#### 🎙 Diapositiva 4 / 31 (ID 101): Portada del Bloque 1 — *Introducción, historia y origen*
│ "Comenzamos con el primer bloque de nuestra exposición: qué es técnicamente Ruby y por qué todo valor en él es un objeto, su origen con Yukihiro Matsumoto hasta Ruby 4.0, y las influencias de cinco lenguajes que definieron su diseño."

#### 🎙 Diapositiva 5 / 31 (ID 4): ¿Qué es Ruby? *(Foto de Matz + Código en vivo)*
│ "¿Qué es Ruby técnicamente? Es un lenguaje de programación de alto nivel, de propósito general, con tipado dinámico y fuerte, diseñado por Yukihiro Matsumoto —conocido en la comunidad como Matz— en Japón y lanzado públicamente en 1995 bajo licencia libre."
│
│ "A diferencia de lenguajes híbridos como Java o C++ donde los números o booleanos son tipos primitivos sin métodos, en Ruby absolutamente todo valor es un objeto en tiempo de ejecución. Como vemos en la demostración viva de la derecha: al número 5 le enviamos el mensaje .class y responde Integer; a la cadena "Ruby" le invocamos .length y devuelve 4; incluso nil, que representa ausencia de valor, es una instancia de NilClass y responde a .nil? devolviendo true; y en la última línea el objeto 3 ejecuta el iterador .times pasándole un bloque de código."

* **Explicación sintáctica línea por línea (`todo_es_objeto.rb`):**
  1. `# Todo es un objeto` $\to$ Los comentarios de una línea inician con `#`.
  2. `puts 5.class` $\to$ `5` es una instancia real de `Integer`; el operador `.` envía el mensaje `class` al receptor `5`.
  3. `puts "Ruby".length` $\to$ Literal `String` al que se le invoca el método `.length` sin paréntesis.
  4. `puts nil.nil?` $\to$ `nil` es el único objeto instancia de `NilClass` (no es un puntero nulo crudo tipo `NULL` en C). El sufijo `?` indica por convención que el método retorna un booleano.
  5. `3.times { puts "¡Hola!" }` $\to$ Invoca el método iterador `times` sobre el objeto `3` pasando un bloque anónimo delimitado por llaves `{ ... }`.
* **Qué señalar en la consola:** Señala las cuatro salidas (`Integer`, `4`, `true`, y tres líneas `¡Hola!`): demuestran que **no existen tipos primitivos** en Ruby —incluso el literal numérico `5`, `3` y `nil` son objetos con clase propia y métodos invocables en tiempo de ejecución.

#### 🎙 Diapositiva 6 / 31 (ID 5): Origen y evolución *(Línea de tiempo hasta Ruby 4.0)*
│ "Recorriendo su evolución histórica: en febrero de 1993 Matz comenzó el diseño porque buscaba un lenguaje verdaderamente orientado a objetos para scripting, más limpio que Perl y más flexible que Python. En 1995 liberó la versión 0.95 y en 1996 publicó Ruby 1.0."
│
│ "El gran punto de inflexión ocurrió en 2004, cuando David Heinemeier Hansson extrajo Ruby on Rails de su producto Basecamp, convirtiendo a Ruby en referente del desarrollo web ágil. Desde la perspectiva de compiladores, el salto más importante llegó en 2007 con Ruby 1.9, al abandonar la interpretación directa del árbol AST para introducir YARV (Yet Another Ruby VM), compilando el código a bytecode."
│
│ "Más adelante, Ruby 3.0 en 2020 cumplió la iniciativa de rendimiento Ruby 3x3 incorporando paralelismo seguro con Ractors y tipado opcional con RBS, hasta llegar a la rama actual Ruby 4.0 lanzada el 25 de diciembre de 2025."

#### 🎙 Diapositiva 7 / 31 (ID 6): Diseño e importancia *(Mapa de influencias SVG)*
│ "Como muestra el mapa de influencias de la derecha, Matz no inventó ideas aisladas; sintetizó las fortalezas de cinco lenguajes: de Smalltalk heredó el modelo puro donde todo es un objeto y los métodos funcionan como paso de mensajes; de Perl adoptó los prefijos léxicos y expresiones regulares integradas; de Eiffel tomó la claridad expresiva; de Ada los bloques legibles cerrados con la palabra reservada end; y de Lisp el manejo de closures, lambdas y bloques anónimos."
│
│ "Su importancia en la ingeniería de software radica en demostrar que la legibilidad y la convención sobre configuración aceleran la creación de sistemas reales que hoy procesan millones de peticiones en GitHub o Shopify, respaldados por una comunidad acogedora resumida en el lema MINASWAN."
│
│ **[Transición]:** "Cedo ahora la palabra a mi compañero Eduardo Tapia, quien explicará la filosofía y la arquitectura interna de ejecución de Ruby."

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 2: Jesús Eduardo Tapia Ávalos (Bloque 2: Filosofía y arquitectura)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 8 / 31 (ID 102): Portada del Bloque 2 — *Filosofía y arquitectura*
│ "Muchas gracias, Américo. En este segundo bloque analizaremos la filosofía de Ruby centrada en el Principio de Menor Sorpresa, la ruta completa de compilación y ejecución desde el código fuente hasta bytecode en YARV y código nativo con YJIT, y su comparativa arquitectónica frente a Python y Java."

#### 🎙 Diapositiva 9 / 31 (ID 7): Filosofía de Ruby *(Código con 3 formas de iterar)*
│ "Muchas gracias, Américo. La filosofía de Ruby se sostiene en el Principio de Menor Sorpresa (POLS): el lenguaje busca minimizar la fricción cognitiva comportándose de manera consistente e intuitiva. Matz diseñó Ruby pensando primero en las personas y luego en la máquina, aceptando un mayor trabajo del entorno de ejecución a cambio de código sumamente expresivo."
│
│ "Además, Ruby ofrece flexibilidad deliberada: casi siempre existen múltiples formas idiomáticas de resolver una tarea. En la consola de la derecha vemos tres iteraciones distintas que producen exactamente la misma salida: primero usando el método .each con un bloque entre llaves; segundo con un ciclo clásico for..in; y tercero enviando el mensaje .upto(3) directamente al entero 1. Todas imprimen 1, 2 y 3."

* **Explicación sintáctica línea por línea (`flexibilidad_ciclos.rb`):**
  1. `[1, 2, 3].each { |n| puts n }` $\to$ Literal de `Array` que invoca `.each`; `|n|` entre tuberías (*pipes*) declara el parámetro que recibe el bloque en cada iteración.
  2. `for n in [1, 2, 3] do puts n end` $\to$ Sintaxis imperativa tradicional delimitada por `do ... end` (internamente Ruby la traduce a `.each`, aunque sin crear nuevo ámbito local para `n`).
  3. `1.upto(3) { |n| puts n }` $\to$ Método de instancia de `Integer` que itera de `1` a `3` inclusivo enviando cada valor al bloque.
* **Qué señalar en la consola:** Señala la secuencia `1, 2, 3` repetida **tres veces seguidas**: prueba la filosofía POLS y de múltiples caminos, donde un iterador funcional (`.each`), un ciclo imperativo (`for..in`) y un método numérico (`1.upto(3)`) producen exactamente el mismo resultado.

#### 🎙 Diapositiva 10 / 31 (ID 8): Características técnicas *(Diagrama `yarv_pipeline.svg`)*
│ "Es un error común decir simplemente que Ruby es interpretado línea por línea. En realidad, como ilustra el diagrama superior, la implementación oficial CRuby ejecuta un pipeline de seis etapas: toma el archivo fuente .rb, el analizador léxico (Lexer/Ripper) genera los tokens identificando palabras clave y sigils; luego el parser (como Prism en versiones modernas) construye el Árbol de Sintaxis Abstracta (AST) verificando la gramática."
│
│ "A continuación, el compilador interno traduce ese AST a bytecode para YARV, una máquina virtual basada en pila. YARV interpreta estas instrucciones de bytecode y, gracias a YJIT —escrito en Rust—, compila dinámicamente las rutas de código calientes directamente a instrucciones nativas x86_64 o ARM64."
│
│ "En cuanto a su sistema de tipos, Ruby es de tipado dinámico pero FUERTE: las variables no se declaran con tipo fijo, pero cada valor en memoria conoce su clase y Ruby prohíbe conversiones implícitas peligrosas, lanzando TypeError si intentas sumar un texto con un entero. Finalmente, la memoria se gestiona automáticamente mediante un recolector de basura generacional con compactación."

#### 🎙 Diapositiva 11 / 31 (ID 9): Ruby frente a otros lenguajes *(Tabla + `type_quadrant.svg`)*
│ "Al contrastar arquitecturas frente a Python y Java y observar el cuadrante de sistemas de tipos de la derecha, vemos diferencias muy claras. En el eje horizontal, Ruby y Python tienen tipado dinámico (el tipo se verifica en ejecución), mientras que Java es estático (se valida en compilación). En el eje vertical, los tres comparten tipado fuerte, a diferencia de JavaScript o C donde ocurren conversiones implícitas."
│
│ "En el modelo de ejecución, tanto Ruby con YARV como Python con CPython compilan a bytecode interpretado por una máquina virtual, mientras que Java compila a bytecode de la JVM altamente optimizado por HotSpot JIT. En paradigma, Ruby destaca por ser orientado a objetos puro sin tipos primitivos, mientras que Java conserva primitivos como int o boolean por rendimiento."
│
│ **[Transición]:** "Respecto a concurrencia, CRuby emplea el GVL (Global VM Lock) y CPython el GIL para proteger la memoria de extensiones en C, complementando con Fibers y Ractors para paralelismo real en Ruby 3+. Con esta base arquitectónica, doy paso a mi compañero Luis García para explicar la sintaxis de Ruby a profundidad."

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 3: Luis Antonio García Gómez (Bloque 3: Sintaxis y fundamentos técnicos)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 12 / 31 (ID 103): Portada del Bloque 3 — *Sintaxis y fundamentos*
│ "Gracias, Eduardo. Entramos al tercer bloque para revisar la anatomía sintáctica de Ruby: el uso de sigils para definir alcances, el tipado dinámico fuerte, el operador nave espacial, la diferencia entre símbolos y cadenas, y un ejemplo completo de entrada y salida estándar."

#### 🎙 Diapositiva 13 / 31 (ID 10): Variables, tipos y operadores *(Infografía `syntax_sigils.svg` + Código)*
│ "Gracias, Eduardo. Analicemos ahora la sintaxis de Ruby desde el punto de vista léxico y gramatical. Una regla clave en Ruby es que no se utilizan palabras reservadas como var, let o int para declarar variables. Como se observa en la infografía de la izquierda, el propio analizador léxico identifica el alcance mediante prefijos o sigils: un identificador en minúscula como edad es una variable local; con una arroba (@nombre) es una variable de instancia propia de un objeto; con doble arroba (@@total) pertenece a la clase; con signo de pesos ($global) tiene alcance global; y si inicia con mayúscula como PI, Ruby la trata como constante."
│
│ "En el código ejecutable de la derecha notamos tres detalles sintácticos fundamentales: primero, los paréntesis en llamadas como puts son opcionales. Segundo, Ruby preserva la precisión aritmética según el tipo de los operandos: edad / 3 divide dos objetos Integer y retorna el entero 6, mientras que edad / 3.0 usa un Float y devuelve 6.666... Tercero, el operador de doble asterisco ** calcula potencias y el operador nave espacial (<=>) realiza comparación de tres vías devolviendo -1 cuando 5 es menor que 8, 0 si son iguales, 1 si es mayor o nil si no son comparables."
│
│ "Finalmente, observamos que los métodos predicado terminan por convención en signo de interrogación (?) y los métodos que mutan al objeto en su lugar llevan exclamación (!)."

* **Explicación sintáctica línea por línea (`variables_y_tipos.rb`):**
  1. `nombre = "Ana"; PI = 3.14159` $\to$ Identificador en minúscula (`snake_case`) crea variable local (`String`); `PI` en mayúscula es clasificada como **constante** por el parser. El `;` actúa como separador opcional para colocar dos expresiones en la misma línea (no es terminador obligatorio como en C/Java).
  2. `edad = 20; precio = 19.99` $\to$ Inferencia dinámica en runtime: `edad` referencia a un `Integer` y `precio` a un `Float`.
  3. `puts edad / 3` $\to$ División entera (`Integer / Integer` $\to$ `6`, truncado).
  4. `puts edad / 3.0` $\to$ Promoción automática a punto flotante (`Integer / Float` $\to$ `6.666666666666667`).
  5. `puts 2 ** 10` $\to$ Operador de exponenciación (`1024`).
  6. `puts 5 <=> 8` $\to$ Operador nave espacial (*spaceship*): retorna `-1` porque `5 < 8`.
  7. `puts :id.class` $\to$ El prefijo `:` crea un literal `Symbol` (inmutable y único en la tabla de símbolos).
* **Qué señalar en la consola:** Señala el contraste entre `6` y `6.666666666666667` (prueba que la división depende del tipo real de los operandos), el `-1` del operador `<=>` (base de `Comparable`) y `Symbol` al final (prueba que incluso un símbolo literal es un objeto con clase propia).

#### 🎙 Diapositiva 14 / 31 (ID 11): Cadenas, arreglos y hashes
│ "Veamos cómo se expresa la sintaxis en las estructuras de datos principales. En las cadenas, Ruby distingue entre comillas simples (literales puros) y comillas dobles, que habilitan interpolación con la sintaxis #{expresion}. Dentro de #{nombre} Ruby evalúa cualquier expresión válida y la convierte a texto automáticamente llamando a .to_s."
│
│ "En el bloque de arreglos usamos frutas << "mango"; el operador << no es un desplazamiento de bits aquí, sino un método del Array que agrega elementos al final. Después vemos una expresión muy idiomática de Ruby: frutas.map(&:upcase). El prefijo ampersand (&) invoca al método to_proc sobre el símbolo :upcase, evitando escribir un bloque completo { |f| f.upcase }."
│
│ "En la parte inferior construimos un Hash usando llaves de tipo Symbol (nombre: "Ana"). Es muy importante destacar por qué usamos símbolos en lugar de cadenas como llaves: cada cadena "nombre" crea un objeto nuevo en el heap, mientras que un símbolo :nombre es inmutable y se almacena una sola vez en la tabla interna de símbolos, haciendo la búsqueda en el Hash casi instantánea."

* **Explicación sintáctica línea por línea (`cadenas_arreglos_hashes.rb`):**
  1. `nombre = "Ana"` $\to$ Variable local con literal `String`.
  2. `puts "Hola, #{nombre}".upcase` $\to$ Interpolación `#{nombre}` dentro de comillas dobles, seguida de encadenamiento `.upcase` (`"HOLA, ANA"`).
  3. `frutas = %w[uva pera kiwi] << "mango"` $\to$ Literal `%w[...]` (*word array*): crea `["uva", "pera", "kiwi"]` sin comillas ni comas, y se encadena directo con `<<` (*shovel*) para agregar `"mango"` al final.
  4. `p frutas.map(&:upcase)` $\to$ Azúcar sintáctico `&:upcase` (`&` invoca `:upcase.to_proc`, equivalente a `{ |x| x.upcase }`); `p` es el método de `Kernel` que imprime `.inspect` directamente.
  5. `alumno = { nombre: "Ana", edad: 20 }` $\to$ Sintaxis JSON-like de Hash donde `nombre:` equivale a `:nombre =>` (llave `Symbol` inmutable).
  6. `alumno[:carrera] = "ISC"` $\to$ Inserción de nueva pareja clave-valor mediante el operador `[]=`.
  7. `puts alumno[:nombre]` $\to$ Acceso al valor asociado a la llave `:nombre`.
  8. `alumno.each { |k, v| puts "#{k}: #{v}" }` $\to$ Bloque con **dos parámetros** `|k, v|` para descomponer cada par del Hash.
* **Qué señalar en la consola:** Señala `["UVA", "PERA", "KIWI", "MANGO"]` (prueba el encadenamiento `%w[...] <<` + `map(&:upcase)` con `p` imprimiendo la representación literal) y los pares `nombre: Ana`, `edad: 20`, `carrera: ISC` (prueba la mutabilidad del `Hash` con llaves `Symbol`).

#### 🎙 Diapositiva 15 / 31 (ID 12): Entrada, salida y un ejemplo
│ "Para cerrar este bloque, analicemos sintácticamente un programa completo de entrada, proceso y salida. La función Kernel#gets lee una línea completa desde la entrada estándar, incluyendo el carácter invisible de salto de línea (\n). Por eso encadenamos el método .chomp, que recorta exactamente ese salto final. Encadenar métodos con punto de izquierda a derecha es parte esencial del estilo fluido de Ruby."
│
│ "En la cuarta línea leemos la edad con gets.to_i. Como Ruby posee tipado fuerte, si intentáramos sumar edad + 1 manteniendo la lectura como String, lanzaría un TypeError; .to_i transforma explícitamente el texto en una instancia de Integer."
│
│ **[Transición]:** "Para imprimir distinguimos print —que deja el cursor en la misma línea—, puts —que añade salto de línea automáticamente— y format("%.2f", ...), que aplica formato decimal estilo C para imprimir 9.00. Ahora le cedo la palabra a mi compañero Alberto Vázquez, quien explicará las estructuras de control y el paradigma orientado a objetos."

* **Explicación sintáctica línea por línea (`entrada_y_salida.rb`):**
  1. `print "¿Cómo te llamas? "; nom = gets.chomp` $\to$ `print` imprime sin `\n`; `;` separa la lectura encadenada `gets.chomp` que lee de `stdin` y recorta el salto de línea final.
  2. `print "¿Edad? "; edad = gets.to_i` $\to$ Conversión explícita obligatoria por el **tipado fuerte** (`String#to_i` $\to$ `Integer`).
  3. `puts "Hola, #{nom}. Tendrás #{edad + 1}."` $\to$ Evalúa la expresión aritmética `edad + 1` dentro de `#{}` y aplica `.to_s` automático.
  4. `puts format("Prom: %.2f", (8+9+10)/3.0)` $\to$ `3.0` fuerza división real; `format` (alias de `sprintf`) formatea a 2 decimales (`9.00`).
* **Qué señalar en la consola:** Señala que `¿Cómo te llamas? ¿Edad? Hola, Yahir. Tendrás 22.` aparece en una sola línea inicial (prueba que `print` no agrega `\n` y que `.chomp` recortó el `\n` de `"Yahir\n"`), mientras `22` y `Prom: 9.00` prueban la conversión explícita `.to_i` exigida por el tipado fuerte y el formato decimal.

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 4: José Alberto Vázquez Guerrero (Bloque 4: Control y programación orientada a objetos)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 16 / 31 (ID 104): Portada del Bloque 4 — *Control y programación orientada a objetos*
│ "Muchas gracias, Luis. En el cuarto bloque veremos cómo en Ruby las estructuras de control son expresiones que devuelven valores, cómo operan los métodos y bloques con yield, y cómo se implementa la programación orientada a objetos pura con clases, herencia simple y encapsulamiento."

#### 🎙 Diapositiva 17 / 31 (ID 13): Condicionales y ciclos
│ "Muchas gracias, Luis. Al estudiar la gramática de las estructuras de control en Ruby descubrimos una propiedad fundamental desde el punto de vista de compiladores: en Ruby casi no existen sentencias vacías (statements); prácticamente todo es una expresión que evalúa y devuelve un valor."
│
│ "Como vemos en la pantalla, podemos asignar directamente el resultado de todo un bloque if/elsif/else a la variable estado sin necesitar un operador ternario extra. Observen también que la palabra reservada se escribe elsif sin la letra 'e', y que los bloques de control no llevan llaves ni punto y coma: se delimitan únicamente con la palabra clave end."
│
│ "También destacamos el condicional invertido unless (a menos que) usado como modificador al final de la línea, lo que permite validar precondiciones en una sola lectura natural. En los ciclos, Ruby privilegia los iteradores orientados a objetos como 3.times o recorrer el rango inclusivo (1..4).each, donde el operador de dos puntos incluye el límite superior 4, mientras que tres puntos (1...4) lo excluye."

* **Explicación sintáctica línea por línea (`condicionales_y_ciclos.rb`):**
  1. `nota = 85` $\to$ Variable local `Integer`.
  2. `estado = if nota >= 90 then "Excelente"` / `elsif nota >= 70 then "Aprobado"` / `else "Reprobado" end` $\to$ `if` es una **expresión** que retorna la última línea de la rama ejecutada; la palabra clave `then` permite escribir la condición y su cuerpo en una sola línea, `elsif` va sin `'e'` y el bloque cierra con `end`.
  3. `puts estado` $\to$ Imprime `"Aprobado"`.
  4. `puts "Pasa" unless nota < 70` $\to$ Modificador posterior (*trailing modifier*): `unless` equivale a `if !(...)` y se evalúa antes de ejecutar `puts "Pasa"`.
  5. `3.times { |i| puts "Vuelta #{i}" }` $\to$ Iterador sobre `Integer` con índice `0, 1, 2`.
  6. `(1..4).each { |n| puts n * n }` $\to$ Paréntesis necesarios para llamar `.each` sobre el objeto `Range` `1..4` (inclusivo: `1, 2, 3, 4`; con `1...4` sería exclusivo: `1, 2, 3`).
* **Qué señalar en la consola:** Señala `Aprobado` y `Pasa` (demuestran que `if` retorna un valor asignable a `estado` y que `unless` invierte la condición de forma legible), seguidos de `Vuelta 0..2` y los cuadrados `1, 4, 9, 16` (demuestran iteradores orientados a objetos sobre `Integer` y `Range`).

#### 🎙 Diapositiva 18 / 31 (ID 14): Métodos y bloques
│ "Los métodos se declaran con la palabra clave def y cuentan con retorno implícito: el valor de la última expresión evaluada dentro del cuerpo es devuelto al invocador sin escribir return. Además, desde Ruby 3.0 existe la sintaxis de método de una línea con '=', como vemos en def par?(n) = n % 2 == 0, que además ilustra la convención de usar signo de interrogación en métodos que retornan booleanos."
│
│ "La característica más poderosa de la sintaxis de Ruby son los bloques y closures. En el método repetir, la palabra reservada yield suspende temporalmente la ejecución del método y transfiere el flujo —junto con el argumento i— al bloque anónimo { |n| puts "Paso #{n}" } que se adjuntó en la llamada, verificando antes con block_given? que exista un bloque."
│
│ "Cuando necesitamos guardar un bloque como objeto en una variable, usamos Proc o Lambda. La diferencia técnica clave es que una Lambda valida estrictamente el número de argumentos (aridad) y su return solo sale de la lambda, mientras que en un Proc el return sale de todo el método que lo contiene."

* **Explicación sintáctica línea por línea (`metodos_y_bloques.rb`):**
  1. `def area(b, h = 1) = b * h / 2.0` $\to$ *Endless method definition* (`def ... = ...`, Ruby 3.0+) sin `end`, con parámetro opcional `h = 1` y **retorno implícito**.
  2. `puts area(6, 4)` $\to$ Invoca el método y muestra `12.0`.
  3. `def par?(n) = n % 2 == 0` $\to$ Método predicado de una línea; el sufijo `?` denota retorno booleano.
  4. `def repetir(n)` / `n.times { |i| yield i if block_given? }` / `end` $\to$ Combina el iterador `.times`, el predicado `block_given?` y `yield i` para ceder temporalmente el control al bloque externo.
  5. `puts par?(4)` $\to$ Imprime `true`.
  6. `repetir(3) { |i| puts "Paso #{i}" }` $\to$ Adjunta el bloque anónimo `{ |i| ... }` fuera de los paréntesis de argumentos.
* **Qué señalar en la consola:** Señala `12.0` (retorno implícito sin `return` en `def ... = ...`), `true` (predicado `par?`) y `Paso 0`, `Paso 1`, `Paso 2` (prueba que `yield i` transfiere el control y el argumento desde `repetir` hacia el bloque anónimo en cada vuelta).

#### 🎙 Diapositiva 19 / 31 (ID 15): Clases y objetos *(Diagrama `object_hierarchy.svg`)*
│ "En el modelo orientado a objetos de Ruby —como muestra la jerarquía inferior desde BasicObject hasta Object— absolutamente todas las estructuras heredan de una raíz común y las propias clases son objetos instanciables en tiempo de ejecución."
│
│ "En el código de la derecha definimos la clase Persona. La primera línea interior, attr_reader :nombre, es en realidad un método de clase (metaprogramación) que genera automáticamente en runtime el método lector para devolver @nombre. El constructor se llama initialize y se invoca cuando ejecutamos Persona.new("Ana", 20), reservando memoria para el objeto y guardando los datos en las variables de instancia @nombre y @edad."
│
│ "Un detalle clave de diseño es que en Ruby ninguna variable de instancia (@) es accesible desde el exterior a menos que definamos un getter o usemos attr_reader / attr_accessor, garantizando encapsulamiento estricto del estado."

* **Explicación sintáctica línea por línea (`clase_persona.rb`):**
  1. `class Persona` $\to$ Nombre de clase obligatorio en `CamelCase` (es una constante de tipo `Class`).
  2. `attr_reader :nombre` $\to$ Metaprogramación en tiempo de carga de la clase: define dinámicamente el getter `def nombre; @nombre; end`.
  3. `def initialize(n, e) = (@nombre, @edad = n, e)` $\to$ Constructor en sintaxis *endless* con **asignación múltiple/paralela** entre paréntesis: `@nombre` recibe `n` y `@edad` recibe `e` en una sola expresión; los sigils `@` vinculan ambos atributos al estado privado de la instancia.
  4. `def info = "Soy #{@nombre}, #{@edad} años"` $\to$ Método de instancia de una línea que interpola los atributos privados `@nombre` y `@edad`.
  5. `ana = Persona.new("Ana", 20)` / `puts ana.info` $\to$ `new` es un método de clase sobre `Persona` (no un operador especial como en Java/C++) que reserva memoria e invoca `initialize`; luego enviamos el mensaje `info` a `ana`.
* **Qué señalar en la consola:** Señala la salida `Soy Ana, 20 años`: prueba que `Persona.new("Ana", 20)` ejecutó `initialize`, almacenó `@nombre` y `@edad` en la instancia `ana` mediante asignación paralela, y los expuso de forma controlada mediante `ana.info`.

#### 🎙 Diapositiva 20 / 31 (ID 16): Herencia y encapsulamiento
│ "Ruby implementa herencia simple de clases mediante el símbolo menor que: class Estudiante < Persona. Dentro de los métodos sobreescritos, la palabra clave super busca el método homónimo en la cadena de ancestros (superclase) y combina su resultado, como en super + " y estudio #{@carrera}". Para evitar los conflictos de la herencia múltiple tipo C++, Ruby utiliza Mixins: módulos que se inyectan en una clase mediante include."
│
│ "Respecto al encapsulamiento, todo método es público por defecto hasta encontrar las directivas protected o private. El método secreto definido bajo private solo puede ejecutarse de forma implícita dentro de la propia instancia; si alguien intenta invocar e.secreto desde fuera, Ruby lanza una excepción NoMethodError."
│
│ **[Transición]:** "Con esto cerramos el núcleo del lenguaje y la POO. Ahora cedo la palabra a mi compañero Ricardo Padilla para explorar el ecosistema y las aplicaciones de Ruby en la industria."

* **Explicación sintáctica línea por línea (`herencia_estudiante.rb`):**
  1. `class Persona` / `def initialize(n, e) = (@nom, @edad = n, e)` / `def info = "Soy #{@nom}, #{@edad} años"` $\to$ Clase base autocontenida con asignación paralela `@nom, @edad = n, e` y método `info`.
  2. `class Estudiante < Persona` $\to$ El operador `<` indica herencia simple de `Persona`.
  3. `def initialize(n, e, c) = (super(n, e); @c = c)` $\to$ Método *endless* cuyo cuerpo agrupa dos expresiones separadas por `;`: primero delega `n, e` al `initialize` del padre con `super(n, e)` y luego guarda `@c`.
  4. `def info = "#{super} (#{@c})"` $\to$ Sobreescribe `info` e invoca `Persona#info` directamente dentro de la interpolación `#{super}` para concatenar la carrera `(@c)`.
  5. `private def secreto = "interno"` $\to$ Modificador de visibilidad en línea: en Ruby `def` es una expresión que retorna el `Symbol` `:secreto`, el cual se pasa como argumento a `private(:secreto)`; llamarlo desde fuera (`e.secreto`) dispara `NoMethodError`.
  6. `puts Estudiante.new("Luis", 21, "ISC").info` $\to$ Encadenamiento directo: instancia `Estudiante` e invoca `.info` sin variable intermedia.
* **Qué señalar en la consola:** Señala `Soy Luis, 21 años (ISC)`: demuestra que `super(n, e)` inicializó `@nom` y `@edad` en la superclase `Persona`, y que `#{super}` dentro de `Estudiante#info` reutilizó la salida del padre añadiendo ` (ISC)`.

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 5: Ricardo Padilla Hernández (Bloque 5: Ecosistema y aplicaciones)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 21 / 31 (ID 105): Portada del Bloque 5 — *Ecosistema y aplicaciones*
│ "Gracias, Alberto. En este quinto bloque distinguiremos con precisión el lenguaje Ruby de RubyGems, Bundler y el framework Ruby on Rails con su arquitectura MVC, además de revisar casos reales en producción y un script en vivo de automatización de archivos."

#### 🎙 Diapositiva 22 / 31 (ID 17): RubyGems y herramientas *(Logo oficial `rubygems.png`)*
│ "Gracias, Alberto. Uno de los puntos clave que exige la rúbrica es distinguir perfectamente el lenguaje de sus herramientas. Como muestra la pila de capas a la izquierda: en la base está Ruby como lenguaje e intérprete; encima está RubyGems, el gestor oficial de bibliotecas empaquetadas como archivos .gem en rubygems.org."
│
│ "Para garantizar compilaciones y entornos reproducibles en equipo, usamos Bundler, que lee el archivo Gemfile —como el ejemplo que ven en pantalla— y resuelve el árbol completo de dependencias bloqueando versiones exactas en Gemfile.lock."
│
│ "Además, el ecosistema incluye irb (el intérprete interactivo REPL para probar expresiones al vuelo), Rake para automatizar tareas, RSpec y Minitest para pruebas automatizadas, y RuboCop para mantener consistencia sintáctica."

* **Explicación sintáctica del `Gemfile`:**
  * `source "https://rubygems.org"` y `gem "rails", "~> 8.0"` son en realidad llamadas a métodos DSL en Ruby (sin paréntesis) que configuran el repositorio origen y el operador pesimista `~>` (permite parches `8.0.x` sin romper hacia `9.0`).

#### 🎙 Diapositiva 23 / 31 (ID 18): Ruby on Rails *(Pipeline MVC + Logo oficial Rails)*
│ "Ruby on Rails, creado en 2004, es el framework web estrella escrito sobre Ruby aprovechando su capacidad de metaprogramación y bloques DSL. Sigue el patrón arquitectónico Modelo-Vista-Controlador: como ilustra el flujo superior, la petición HTTP del navegador entra por el Router, este despacha la acción al Controlador, el Controlador consulta o persiste datos mediante el Modelo usando el ORM Active Record, y finalmente renderiza la Vista en HTML mediante plantillas ERB."
│
│ "Rails revolucionó la industria con dos principios: Convención sobre Configuración —asumiendo nombres estándar entre clases y tablas sin configuración manual— y DRY (Don't Repeat Yourself). Con apenas cinco comandos de CLI que vemos en consola podemos generar un CRUD completo conectado a base de datos."

#### 🎙 Diapositiva 24 / 31 (ID 19): Empresas y automatización *(Logos `companies_logos.svg` + Script OS en vivo)*
│ "A la izquierda vemos evidencia verificable de empresas y proyectos globales construidos sobre Ruby y Rails: GitHub aloja millones de repositorios sobre un monolito Rails; Shopify procesa cientos de miles de transacciones por minuto en picos de Black Friday e incluso financia el compilador YJIT dentro de Ruby; GitLab y Airbnb nacieron sobre Rails; 37signals creó Basecamp; y fuera de la web, Homebrew —el gestor de paquetes de macOS y Linux— está programado íntegramente en Ruby."
│
│ "A la derecha demostramos en tiempo real la potencia de Ruby para automatización de sistemas operativos: importamos la biblioteca estándar fileutils y tmpdir, creamos un directorio temporal seguro que se limpia solo al cerrar el bloque, detectamos archivos con Dir.glob("*.txt") y los movemos con FileUtils.mv usando un bloque iterador claro en apenas doce líneas."
│
│ **[Transición]:** "Para concluir la presentación con el análisis crítico profesional y el estado actual del lenguaje, cedo la palabra a nuestro compañero Yahir Guevara."

* **Explicación sintáctica línea por línea (`automatizacion_backup.rb`):**
  1. `require "fileutils"; require "tmpdir"` $\to$ Carga módulos de la biblioteca estándar en una línea usando `;` (no requieren gemas externas).
  2. `Dir.mktmpdir do |d| ... end` $\to$ Patrón *resource management* con bloque `do..end`: garantiza el borrado automático del directorio temporal `d` al finalizar el bloque, incluso si ocurre una excepción.
  3. `Dir.chdir(d) do ... end` $\to$ Cambia temporalmente el directorio de trabajo a `d` solo mientras dura el bloque interno y lo restaura al salir.
  4. `File.write("a.txt", "1"); File.write("b.txt", "2")` y `FileUtils.mkdir_p("bak")` $\to$ Crea dos archivos de prueba y la carpeta destino `bak`.
  5. `Dir["*.txt"].each do |f|` $\to$ `Dir["*.txt"]` es la forma abreviada de `Dir.glob("*.txt")`; devuelve el arreglo de archivos `.txt` y los recorre con `.each`.
  6. `FileUtils.mv(f, "bak/#{f}"); puts "OK: #{f}"` $\to$ Mueve cada archivo al subdirectorio `bak/` usando interpolación de cadenas e imprime la confirmación.
* **Qué señalar en la consola:** Señala `OK: a.txt` y `OK: b.txt`: prueban que el script creó archivos reales en un directorio temporal del sistema operativo, los filtró con `Dir["*.txt"]`, los movió a `bak/` y limpió el directorio temporal automáticamente sin dejar basura en el disco.

────────────────────────────────────────────────────────────────────────────────
### INTEGRANTE 6: Yahir Guevara Cardona (Bloque 6: Evaluación crítica, rendimiento y cierre)
────────────────────────────────────────────────────────────────────────────────

#### 🎙 Diapositiva 25 / 31 (ID 106): Portada del Bloque 6 — *Evaluación y conclusiones*
│ "Muchas gracias, Ricardo. Cerramos la exposición con el sexto bloque: una evaluación crítica de las ventajas y límites de Ruby frente al GVL y YJIT, la comparativa práctica con Python y Java, su vigencia en Ruby 4.0 y nuestras conclusiones finales."

#### 🎙 Diapositiva 26 / 31 (ID 20): Ventajas, límites y rendimiento *(Matriz 4 cuadrantes)*
│ "Muchas gracias, Ricardo. Para cumplir con el análisis crítico profesional que exige ingeniería, debemos justificar con argumentos técnicos cuándo conviene elegir Ruby y cuándo debemos descartarlo."
│
│ "Sus fortalezas indiscutibles son su alta expresividad sintáctica, la velocidad de desarrollo de productos MVP y APIs con Rails, y un ecosistema de gems sumamente maduro. Sin embargo, sus límites técnicos son reales: al depender de tipado dinámico y una máquina virtual interpretada, su rendimiento bruto en CPU es menor que el de lenguajes compilados estáticamente como C++, Rust o Go. Además, el GVL (Global VM Lock) en CRuby serializa la ejecución del bytecode entre hilos del sistema, por lo que no escala en paralelo multi-núcleo para cargas intensivas de CPU con hilos tradicionales, requiriendo procesos independientes o Ractors."
│
│ "Por eso recomendamos Ruby para aplicaciones web, microservicios I/O-bound, scripts DevOps y herramientas CLI; y recomendamos descartarlo para entrenamiento de Inteligencia Artificial, videojuegos 3D de bajo nivel o sistemas embebidos de memoria restringida. En rendimiento, YJIT (y ZJIT experimental en Ruby 4.0) aceleran notablemente las aplicaciones web reales en producción."

#### 🎙 Diapositiva 27 / 31 (ID 21): Ruby, Python y Java *(Tabla con iconos SVG/PNG)*
│ "Resumiendo la comparativa estratégica frente a las dos alternativas más cercanas en la industria: Ruby brilla en desarrollo web rápido con Rails, automatización y creación de DSLs gracias a su sintaxis flexible sin indentación obligatoria; Python domina actualmente ciencia de datos, aprendizaje automático y automatización científica por su ecosistema numérico en C (NumPy, PyTorch); y Java lidera sistemas empresariales de alta concurrencia y baja latencia gracias al tipado estático y la compilación JIT avanzada de la JVM."
│
│ "La elección correcta nunca parte de fanatismo por un lenguaje, sino de analizar el tipo de carga de trabajo, los requisitos de concurrencia CPU frente a E/S y la productividad del equipo."

#### 🎙 Diapositiva 28 / 31 (ID 22): Instalación y vigencia *(Ruby 4.0.6, julio 2026)*
│ "Para trabajar profesionalmente con Ruby en Linux o macOS se recomiendan gestores de versiones como rbenv, mise o RVM, y en Windows RubyInstaller con soporte MSYS2; en el editor, VS Code junto con Ruby LSP desarrollado por Shopify brinda autocompletado y análisis estático."
│
│ "En cuanto a la vigencia del lenguaje: lejos de estar obsoleto, Ruby mantiene un calendario estricto con lanzamientos cada Navidad (25 de diciembre) y unos tres años de mantenimiento por rama. La rama estable vigente es Ruby 4.0 (con la actualización 4.0.6 de julio de 2026), impulsada activamente en producción por empresas de alto tráfico."

#### 🎙 Diapositiva 29 / 31 (ID 23): Conclusiones
│ "En conclusión, sintetizamos cuatro pilares técnicos aprendidos: Primero, Ruby demuestra un diseño coherente donde todo es un objeto y toda estructura es una expresión, con tipado dinámico pero estricto en su seguridad de tipos. Segundo, internamente traduce el código fuente mediante lexer y AST a bytecode de la máquina virtual basada en pila YARV, optimizado hoy con compilación JIT nativa mediante YJIT."
│
│ "Tercero, su ecosistema liderado por RubyGems, Bundler y Rails ha influido profundamente en la ingeniería web moderna con Convención sobre Configuración. Y cuarto, aunque sus límites frente al GVL y el cómputo CPU intensivo lo descartan para IA o sistemas de tiempo real estricto, sigue plenamente vigente en Ruby 4.0 para desarrollo ágil, APIs y automatización."

#### 🎙 Diapositiva 30 / 31 (ID 24): Referencias bibliográficas
│ "Dejamos visibles nuestras fuentes oficiales y bibliografía técnica verificada, incluyendo la documentación oficial de Ruby y YARV, los artículos de ingeniería de Shopify sobre el compilador YJIT, las guías de Rails y los textos clásicos de Yukihiro Matsumoto y Dave Thomas."

#### 🎙 Diapositiva 31 / 31 (ID 25): ¿Preguntas? *(Código final `despedida.rb`)*
│ "De parte de los seis integrantes —Américo Calzada, Eduardo Tapia, Luis García, Alberto Vázquez, Ricardo Padilla y su servidor Yahir Guevara— agradecemos profundamente su atención, maestra y compañeros. Todo el equipo conoce a detalle tanto la sintaxis como el funcionamiento interno de Ruby, por lo que quedamos a su total disposición para responder cualquier pregunta frente al grupo. ¡Muchas gracias!"

* **Código en consola (`despedida.rb`):** `puts "¡Gracias por su atención!"`
  * **Qué señalar en la consola:** Cierra con la ejecución en vivo de `despedida.rb` imprimiendo `¡Gracias por su atención!` en verde (`✔ ... ms`), dejando el entorno listo para abrir el código fuente de `presentacion_ruby.rb` si la docente solicita **"Pasar a su código"**.

---

## 3. Guía de Estudio de Sintaxis de Ruby (Nivel Compiladores II)

Todos los integrantes deben dominar estos 7 mecanismos internos del lenguaje para explicar cualquier código en pantalla:

1. **Todo es una expresión (No hay *statements* puros):**
   - Estructuras como `if/elsif/else`, `unless`, `case/when`, definiciones `def` y asignaciones siempre retornan el valor de la última expresión evaluada.
   - Por eso `estado = if nota >= 70 then "Aprobado" else "Reprobado" end` es completamente válido sin necesidad de operador ternario `?:`.
2. **Sigils léxicos para alcance de identificadores (sin palabras `var`/`let`):**
   - `variable` (minúscula / `snake_case`) $\to$ **Local**: vive en el marco de pila (*stack frame*) del método o bloque actual.
   - `@variable` $\to$ **De instancia**: almacenada en la tabla de atributos interna (`ivars`) del objeto receptor `self`.
   - `@@variable` $\to$ **De clase**: compartida entre la clase y todas sus subclases.
   - `$variable` $\to$ **Global**: tabla global del runtime; visible en todo el programa.
   - `CONSTANTE` (inicia en mayúscula) $\to$ **Constante**: el intérprete emite un *warning* si se reasigna, no un error de compilación.
3. **Azúcar sintáctico y legibilidad POLS:**
   - **Paréntesis opcionales** en llamadas a métodos (`puts "hola"` $\equiv$ `puts("hola")`), excepto en ambigüedades de precedencia o llamadas encadenadas sobre literales como `(1..4).each`.
   - **Retorno implícito:** no hace falta `return` al final de un método; `return` solo se usa para salidas tempranas (*early return*).
   - **Modificadores *trailing*:** `return if x.nil?` o `puts "OK" unless error?` evalúan la condición antes de ejecutar la expresión de la izquierda.
4. **Convenciones semánticas en identificadores de método (`?` y `!`):**
   - El signo `?` al final forma parte del nombre del método e indica que retorna un valor booleano (*predicado*), por ejemplo: `nil?`, `empty?`, `par?(n)`.
   - El signo `!` al final (*bang method*) advierte que el método muta el objeto receptor en memoria (*in-place*) o lanza excepción en lugar de retornar copia o `nil` (`sort!` vs `sort`, `upcase!` vs `upcase`).
5. **Operador Nave Espacial (`<=>`) y el módulo `Comparable`:**
   - Comparación de tres vías: retorna `-1` si izquierda `<` derecha, `0` si iguales, `1` si izquierda `>` derecha, o `nil` si son tipos incompatibles.
   - Es la base del módulo `Comparable`: al definir únicamente `<=>` en una clase e incluir `include Comparable`, Ruby sintetiza automáticamente `<`, `<=`, `==`, `>=`, `>` y `between?`.
6. **Igualdad de casos (`===`) en `case/when`:**
   - A diferencia de `switch` en C/Java (que solo compara enteros/cadenas constantes con igualdad exacta), `case x; when patron` evalúa `patron === x`.
   - Si `patron` es un `Range` `(1..10)`, comprueba inclusión; si es una `Class` (`Integer`), comprueba `is_a?`; si es una `Regexp` `/^\d+$/`, comprueba coincidencia de patrón.
7. **Diferencias técnicas entre Bloques (`yield`), `Proc` y `Lambda`:**
   - **Bloque (`{ ... }` o `do ... end`):** No es un objeto por sí solo, sino una construcción sintáctica adjunta a una llamada de método que se invoca con `yield` (o se captura con `&block`). Por convención, `{}` tiene mayor precedencia y se usa en una línea; `do..end` tiene menor precedencia y se usa en múltiples líneas.
   - **`Proc` (`Proc.new` / `proc`):** Es un objeto (*closure*). **No** valida estrictamente la cantidad de argumentos (aridad: los sobrantes se ignoran y los faltantes valen `nil`). Si contiene un `return`, intenta retornar **del método contenedor exterior** donde se definió.
   - **`Lambda` (`->(x) { ... }` / `lambda`):** También es un objeto `Proc` con flag de lambda (`lambda? == true`). **Sí** valida estrictamente la aridad (lanza `ArgumentError` si difiere) y su `return` **solo retorna de la propia lambda** hacia quien la invocó.

---

## 4. Banco de Preguntas de Defensa frente a la Docente (30 pts Individuales)

> [!TIP]
> **Consejo para responder frente al grupo:** Responde en 3 pasos: **(1) Afirmación directa**, **(2) Mecanismo interno en compilador/VM**, **(3) Ejemplo concreto de la presentación**.

### Bloque 1 — Preguntas para Américo Ismael Calzada Martínez
1. **¿Qué significa exactamente que en Ruby "todo es un objeto" y en qué se diferencia de Java o C++?**
   * *Respuesta:* En Java o C++ existen tipos primitivos (`int`, `boolean`, `double`) que viven directamente como bytes crudos en memoria sin métodos ni clase asociada (Java requiere *boxing* con `Integer` para tratarlos como objetos). En Ruby no hay primitivos: `5` es instancia de `Integer`, `nil` de `NilClass`, `true` de `TrueClass` y hasta la clase `Persona` es un objeto instancia de `Class`. Por eso `5.class` y `3.times { ... }` funcionan directamente mediante envío de mensajes. *(Nota de bajo nivel: YARV optimiza enteros pequeños con tagged pointers para no saturar el heap, pero semánticamente siempre son objetos).*
2. **¿Por qué Matz diseñó Ruby si ya existían Perl y Python en los años 90?**
   * *Respuesta:* Matz admiraba la potencia de procesamiento de texto de Perl pero consideraba su sintaxis ruidosa y su POO añadida posteriormente. También apreciaba la legibilidad de Python, pero consideraba que no era verdaderamente orientado a objetos puro (en Python usas `len(lista)` como función global, mientras que en Ruby envías `lista.length` al objeto). Por eso fusionó el modelo de mensajes de Smalltalk con la expresividad de Perl, la claridad de Eiffel/Ada y los closures de Lisp.
3. **¿Qué representa el salto de Ruby 1.8 a Ruby 1.9 (2007) desde el punto de vista de Compiladores?**
   * *Respuesta:* Fue el cambio arquitectónico más grande del lenguaje: hasta Ruby 1.8 el intérprete MRI recorría directamente los nodos del árbol AST en memoria durante la ejecución, lo que era muy lento. En Ruby 1.9 se introdujo **YARV** (Yet Another Ruby VM), un compilador a bytecode y una máquina virtual basada en pila, multiplicando varias veces la velocidad de ejecución.

### Bloque 2 — Preguntas para Jesús Eduardo Tapia Ávalos
1. **La rúbrica prohíbe decir solo "es interpretado". ¿Qué ocurre paso a paso desde `ruby app.rb` hasta la CPU?**
   * *Respuesta:* En CRuby ocurre un pipeline multi-etapa: **(1) Lexer/Tokenizador:** convierte el texto fuente en tokens identificando palabras clave, operadores y sigils (`@`, `$`, `:`). **(2) Parser (Bison/Prism):** construye el **AST** (Árbol de Sintaxis Abstracta) validando la gramática. **(3) Compilador de Bytecode:** traduce el AST a instrucciones portables de pila (`RubyVM::InstructionSequence`). **(4) YARV:** la máquina virtual basada en pila ejecuta ese bytecode. **(5) YJIT:** en rutas calientes (*hot paths*), el compilador JIT escrito en Rust genera código máquina nativo x86_64 o ARM64 mediante *Lazy Basic Block Versioning*.
2. **¿Cómo puede Ruby tener tipado dinámico y a la vez tipado FUERTE?**
   * *Respuesta:* Porque son ejes ortogonales. **Dinámico** significa que las variables no tienen un tipo estático en tiempo de compilación; una variable `x` puede referenciar hoy a un `Integer` y luego a un `String` (el tipo pertenece al objeto en memoria). **Fuerte** significa que el runtime protege la integridad de los tipos y **prohíbe coerciones implícitas inseguras**: si ejecutas `"5" + 5`, Ruby lanza inmediatamente `TypeError: no implicit conversion of Integer into String`, a diferencia de JavaScript o PHP que convertirían implícitamente a `"55"` o `10`.
3. **¿Cómo gestiona Ruby la memoria sin `malloc`/`free`?**
   * *Respuesta:* Utiliza gestión automática en el heap mediante un **Recolector de Basura (GC) Generacional e Incremental Tri-color Mark & Sweep con compactación** (`GC.compact`). Clasifica objetos en jóvenes y viejos (para no escanear toda la memoria cada ciclo) y reorganiza los slots vivos para reducir la fragmentación.

### Bloque 3 — Preguntas para Luis Antonio García Gómez
1. **¿Por qué Ruby permite omitir paréntesis en llamadas a métodos y qué desafío supone para el Parser?**
   * *Respuesta:* Se omiten por ergonomía (POLS) y para crear DSLs legibles como en Rails (`gem "rails"`). Para el parser (LALR/Pratt), omitir paréntesis introduce **ambigüedades gramaticales** en llamadas anidadas (como `f g h`, que podría interpretarse como `f(g(h))` o `f(g, h)`) o al combinar argumentos con bloques `{ ... }` vs `do ... end`. Ruby lo resuelve mediante reglas estrictas de precedencia léxica y la diferencia de precedencia entre `{}` (más fuerte) y `do..end` (más débil).
2. **¿Cuál es la diferencia técnica y en memoria entre usar `"nombre"` (String) y `:nombre` (Symbol) como llave de un Hash?**
   * *Respuesta:* Cada literal `"nombre"` es mutable y asigna un nuevo objeto `String` en el heap cada vez que se evalúa (distinto `object_id`). En cambio, `:nombre` es un `Symbol` **inmutable** que se registra una única vez en la tabla interna de símbolos: todas las apariciones de `:nombre` comparten exactamente el mismo `object_id`, evitando asignaciones repetidas de memoria y permitiendo comparar llaves de Hash por igualdad directa de puntero/ID entero.
3. **¿Qué devuelve el operador `<=>` y qué significa la sintaxis `frutas.map(&:upcase)`?**
   * *Respuesta:* El operador `<=>` (nave espacial) realiza comparación de tres vías retornando `-1`, `0`, `1` o `nil`, y habilita automáticamente `<, <=, ==, >=, >` al incluir `Comparable`. En cuanto a `frutas.map(&:upcase)`, el prefijo `&` invoca `Symbol#to_proc`, convirtiendo el símbolo en un `Proc` que envía el mensaje `.upcase` a cada elemento; es azúcar sintáctico equivalente a `frutas.map { |f| f.upcase }`.

### Bloque 4 — Preguntas para José Alberto Vázquez Guerrero
1. **¿Por qué `case/when` en Ruby es más flexible que el `switch` de C o Java?**
   * *Respuesta:* En C/Java, `switch` compara igualdad exacta de enteros, caracteres o literales constantes. En Ruby, `case x; when P` ejecuta internamente el método **`P === x`** (*case equality*). Como cada clase implementa su propio `===`, un `when` puede evaluar pertenencia a un rango `(90..100) === x`, coincidencia con expresión regular `/^[A-Z]/ === x` o pertenencia de clase `Integer === x`.
2. **¿Cuál es la diferencia real entre un `Proc` y una `Lambda`?**
   * *Respuesta:* Ambos son instancias de la clase `Proc` que encapsulan un bloque como closure, pero difieren en dos puntos críticos: **(1) Aridad:** la `lambda` valida estrictamente el número de argumentos y lanza `ArgumentError` si faltan o sobran; el `Proc` los ajusta con `nil` o los ignora. **(2) Flujo de `return`:** en una `lambda`, `return` sale únicamente de la lambda y devuelve el control al método que la llamó; en un `Proc`, `return` sale del **método contenedor exterior** donde se creó el Proc.
3. **Si Ruby no soporta herencia múltiple de clases, ¿cómo reutiliza comportamiento entre clases no emparentadas?**
   * *Respuesta:* Mediante **Mixins** con `Module` y `include` (o `prepend` / `extend`). Ruby evita el problema del diamante de C++ manteniendo herencia simple de clase (`<`), pero insertando módulos linealmente en la cadena de ancestros (`Class.ancestors`), logrando polimorfismo y reutilización ordenada sin ambigüedad.

### Bloque 5 — Preguntas para Ricardo Padilla Hernández
1. **¿Qué diferencia existe entre Ruby, RubyGems, Bundler y Ruby on Rails?**
   * *Respuesta:* **Ruby** es el lenguaje y su máquina virtual. **RubyGems** es el gestor oficial de paquetes (`.gem`) y el registro central `rubygems.org`. **Bundler** es la herramienta que resuelve versiones compatibles entre gemas leyendo `Gemfile` y congelando el grafo exacto en `Gemfile.lock`. **Ruby on Rails** es un framework web MVC construido sobre Ruby y distribuido precisamente como un conjunto de gemas.
2. **¿Por qué Rails popularizó "Convención sobre Configuración" y cómo se relaciona con Ruby?**
   * *Respuesta:* En lugar de obligar al programador a mantener enormes archivos XML o anotaciones repetitivas para enlazar rutas, controladores y tablas SQL, Rails asume reglas preestablecidas (ej. el modelo `Libro` mapea automáticamente a la tabla `libros`). Esto es posible gracias a la **metaprogramación dinámica** y reflexión de Ruby (`Active Record` inspecciona las columnas de la base de datos en tiempo de ejecución y define los métodos de acceso dinámicamente).
3. **¿Por qué empresas como Shopify o GitHub usan Ruby si no es el lenguaje más rápido en CPU?**
   * *Respuesta:* Porque las aplicaciones web empresariales son mayoritariamente **I/O-bound** (esperan bases de datos, red o caché), no CPU-bound. Ruby maximiza la velocidad de iteración del equipo de ingeniería y, donde el cuello de botella sí llega a la VM, empresas como Shopify han invertido directamente en **YJIT**, acelerando sus servidores Rails en producción con menor costo de ingeniería.

### Bloque 6 — Preguntas para Yahir Guevara Cardona
1. **¿Qué es el GVL / GIL en CRuby, por qué existe y cuándo se vuelve un límite?**
   * *Respuesta:* El **GVL (Global VM Lock)** en CRuby (equivalente al GIL de CPython) es un candado mutex que permite crear múltiples hilos nativos del sistema operativo, pero impide que más de un hilo ejecute bytecode de Ruby simultáneamente en varios núcleos de CPU. Existe para proteger la integridad de memoria del recolector de basura y de las extensiones escritas en C que no son *thread-safe*. Para operaciones I/O-bound el GVL se libera mientras espera la red/disco; pero para cómputo paralelo puro en CPU sí es un límite, por lo que se usan múltiples procesos (como Puma workers), **Fibers** asíncronos o **Ractors** (introducidos en Ruby 3 con aislamiento de objetos).
2. **Si un proyecto requiere Machine Learning o procesamiento masivo de matrices en tiempo real, ¿recomendarías Ruby?**
   * *Respuesta:* **No.** Aunque existen bindings experimentales, Ruby carece del ecosistema nativo optimizado en C/CUDA que Python posee (NumPy, PyTorch, TensorFlow), y para tiempo real estricto o sistemas embebidos de baja memoria la máquina virtual, el GC y el tipado dinámico añaden latencia impredecible frente a C, C++ o Rust.
3. **¿Cómo mejora YJIT (y ZJIT en Ruby 4.0) la velocidad de Ruby sin romper su naturaleza dinámica?**
   * *Respuesta:* En lenguajes dinámicos, cualquier objeto puede redefinir métodos en tiempo de ejecución (*monkey patching*). **YJIT** utiliza *Lazy Basic Block Versioning*: observa qué tipos reales llegan a un bloque de bytecode frecuente en ejecución y genera código máquina especializado para ese tipo exacto; si en algún momento entra otro tipo o se redefine un método, invalida esa suposición rápida y vuelve de forma segura al intérprete YARV.

---

### Preguntas Transversales de Compiladores (Para CUALQUIER Integrante)
* **¿Qué herramientas de Ruby permiten inspeccionar sus propias fases de compilación?**
  * *Respuesta:* Desde el propio código Ruby podemos usar `Ripper.tokenize("x = 1 + 2")` para ver los **tokens léxicos**, `RubyVM::AbstractSyntaxTree.parse(...)` (o `Prism.parse`) para inspeccionar el **AST**, y `RubyVM::InstructionSequence.compile(...).disasm` para desensamblar y leer directamente el **bytecode de YARV**.
* **¿Qué pasa si llamo `e.secreto` sobre un método `private` desde fuera de la clase?**
  * *Respuesta:* En tiempo de ejecución el despachador de métodos (*method dispatch*) busca en la tabla de métodos y comprueba la visibilidad respecto al receptor (`self`); al detectar que se llamó con un receptor explícito externo sobre un método `private`, lanza la excepción `NoMethodError: private method 'secreto' called`.
* **¿Por qué `"5" + 5` falla en Ruby mientras `"5" * 3` sí funciona?**
  * *Respuesta:* Porque el operador `+` es en realidad un método (`String#+`) que exige otro `String` (por el **tipado fuerte** no convierte el `5` a `"5"`). En cambio, `String#*` está sobrecargado deliberadamente para recibir un `Integer` y repetir la cadena `"555"`, mientras `5 * "3"` sí falla con `TypeError`.


---

## 5. Guion de 3–4 Minutos: "Pasar a su código" (`presentacion_ruby.rb`)

> [!NOTE]
> **Cuándo usar esta sección:** Al finalizar las diapositivas o cuando la docente indique *"Pasen a su código"* (Criterio 6 de la rúbrica). Abre [`presentacion_ruby.rb`](presentacion_ruby.rb) en el editor y recorre exactamente estos 4 bloques en 3–4 minutos.

### Qué mostrar en pantalla y qué decir (Verbatim)

1. **Bloque A — Dependencias estándar y carga de datos (líneas 12–21):**
   │ "Toda la presentación web que acaban de ver no depende de frameworks pesados ni de servidores externos: corre en un único programa escrito en Ruby puro (`presentacion_ruby.rb`) usando únicamente cinco bibliotecas de la librería estándar: `webrick` para el servidor HTTP, `json` para serialización, `open3` para ejecutar subprocesos capturando flujos, `timeout` para proteger contra ciclos infinitos y `erb` para plantillas HTML."
   │ "Al iniciar, carga el archivo `data/slides_data.json` en la constante `SLIDES` y compila la plantilla `HTML_PAGE` con `ERB.new(HTML_PAGE).result(binding)`, inyectando dinámicamente `RUBY_VERSION` en la interfaz."

2. **Bloque B — Servidor WEBrick, rutas y seguridad de archivos (líneas 1363–1403):**
   │ "En la parte inferior levantamos `WEBrick::HTTPServer` en el puerto `4567` (o `ENV['PORT']`) y montamos cuatro rutas: `/` entrega el HTML renderizado; `/api/slides` y `/data/slides_data.json` devuelven el arreglo JSON de diapositivas; y `/assets/img` sirve los PNG y SVG validando `File.basename` y `path.start_with?(IMG_DIR + File::SEPARATOR)` para prevenir ataques de *path traversal*. Además, si pasamos `--build-static`, el mismo script genera `index.html` listo para GitHub Pages."

3. **Bloque C — Ejecución real de Ruby en vivo con `Open3.capture3` (líneas 1404–1434):**
   │ "El corazón de la demostración en vivo es el endpoint `POST /api/run`. Cuando cambiamos a una diapositiva con código, el navegador envía el código fuente y el `stdin` por `fetch` a `/api/run`."
   │ "En el servidor envolvemos la ejecución en `Timeout.timeout(3)` para evitar bloqueos y llamamos a `Open3.capture3({ 'LANG' => 'C.UTF-8' }, 'ruby', '-E', 'UTF-8', '-e', utf8_code, stdin_data: stdin_data)`. Esto lanza un subproceso real del intérprete `ruby` con codificación UTF-8, captura por separado `stdout`, `stderr` y `status.exitstatus`, mide el tiempo exacto con `Process.clock_gettime(Process::CLOCK_MONOTONIC)` y responde un JSON con la salida y los milisegundos reales."

4. **Bloque D — Integración en el frontend `autoRunSlideCode` (líneas 881–929):**
   │ "Finalmente, en el cliente JavaScript, `autoRunSlideCode(s, token)` hace la petición `POST` a `api/run` (o usa `s.expected_output` como respaldo si se abre como página estática sin servidor), cambia el punto indicador a verde al recibir respuesta y anima la consola línea por línea. Con esto demostramos no solo la sintaxis de Ruby en diapositivas, sino una aplicación cliente-servidor real programada en Ruby."

### Preguntas rápidas de defensa sobre `presentacion_ruby.rb`

* **¿Por qué usaron `Open3.capture3` en un subproceso en lugar de `eval(code)` dentro del mismo proceso WEBrick?**
  * *Respuesta:* Por aislamiento y estabilidad: `eval` ejecutaría el código de ejemplo en el mismo espacio de memoria del servidor (pudiendo modificar constantes globales, `Dir.chdir` o bloquear el hilo de WEBrick). Con `Open3.capture3` cada snippet corre en su propio proceso `ruby`, con `stdin_data` inyectado de forma segura, `stdout`/`stderr` separados y control de tiempo mediante `Timeout.timeout(3)`.
* **¿Para qué sirve `# encoding: utf-8\n` y `-E UTF-8` en la llamada a `ruby -e`?**
  * *Respuesta:* Garantiza que caracteres como tildes (`á`, `ñ`) y símbolos (`¡`, `¿`) en los ejemplos de código se interpreten y escriban en UTF-8 sin importar la configuración regional del sistema operativo anfitrión.
* **¿Cómo garantizan que el servidor no quede colgado si alguien cierra la terminal o hay un ciclo infinito?**
  * *Respuesta:* `Timeout.timeout(3)` corta cualquier ejecución que supere 3 segundos devolviendo código `124` y un mensaje de error controlado, mientras que `trap("INT")` y `trap("TERM")` ejecutan `server.shutdown` para un apagado limpio.

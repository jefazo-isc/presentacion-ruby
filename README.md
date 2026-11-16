# Presentación Académica de Ruby (16:9 en Tiempo Real)

Presentación interactiva de **25 diapositivas** sobre el lenguaje de programación **Ruby**, programada en **Ruby** (`WEBrick`) con ejecución de ejemplos en vivo y animaciones 16:9.

## Estructura del Proyecto
```text
.
├── presentacion_ruby.rb          # Servidor WEBrick y aplicación web 16:9
├── data/
│   └── slides_data.json          # Contenido y diálogos de las 25 diapositivas
├── assets/
│   └── img/                      # Recursos gráficos (ruby, matz, rubygems, rails)
└── docs/                         # Guion de exposición (.docx) y PPTX base
```

## Requisitos
- Ruby `3.x` (probado en Ruby `3.3.13`).

## Cómo ejecutar
```bash
ruby presentacion_ruby.rb
```
Luego abre en tu navegador: **`http://localhost:4567`**

## Controles
- **`→`** / **`←`**: avanzar o retroceder diapositivas (incluye animación de apertura en la Diapositiva 1).
- Los ejemplos de código se ejecutan automáticamente con el intérprete local de Ruby y muestran su salida en bucle.

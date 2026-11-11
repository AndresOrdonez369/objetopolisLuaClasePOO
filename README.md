# Objetópolis — aprende POO jugando (Lua + LÖVE)

> *"Acabas de ser instanciado. No sabes qué eres. Tu clase te espera."*

Juego top-down para la clase de **Programación de Videojuegos** (CUN). El jugador es un
objeto recién creado que recorre 6 barrios. Cada barrio es un concepto de POO: **se juega,
se ve su código (TAB) y se reprograma en clase**. Con los 6 sellos se abre la Puerta del
Arquitecto y aparece la revelación: `local tu = Jugador.new(...)`.

## Cómo correrlo

- **VS Code:** abre la carpeta `Objetopolis` y presiona **Ctrl + Shift + B**. La tarea ya está
  en `.vscode/tasks.json` y apunta a `C:\Program Files\LOVE\love.exe`; si tus estudiantes
  instalaron LÖVE en otra ruta, que cambien esa línea.
- **Consola:** `love .` dentro de la carpeta.
- **Explorador:** arrastra la carpeta sobre `love.exe`.
- Probado en **LÖVE 11.5**. La extensión *Lua* (sumneko) ya queda configurada para reconocer `love`.

**Controles:** WASD o flechas para moverte · **E** usar/hablar · **TAB** ver el código de lo que tienes
cerca · **H** ocultar o mostrar los paneles (modo juego o modo clase) · **F11** pantalla completa (para el proyector) · Esc salir · R reiniciar (en la pantalla final).

## La pantalla: jugar y ver el código al mismo tiempo

```
+-------------------------------------------------------------+
| OBJETÓPOLIS   (1) (2) (3) (4) (5) (6) sellos     Oro        |
+------------------------------------+------------------------+
|                                    | 1 QUÉ ESTÁS VIENDO     |
|            JUEGO                   |   clase, cadena        |
|   (el objeto cercano tiene un      |   __index y ESTADO     |
|    marco azul: es el que explica   |   en vivo (self)       |
|    el panel)                       +------------------------+
|                                    | 2 QUÉ ESTÁS APRENDIENDO|
+------------------------------------+   idea + analogía      |
| CONSOLA EN VIVO                    +------------------------+
|  evento | línea de código ejecutada| 3 CÓMO ESTÁ HECHO      |
|  oyentes| qué significa            |   métodos REALES del   |
|                                    |   archivo .lua         |
+------------------------------------+------------------------+
```

- **Panel 1, QUÉ ESTÁS VIENDO:** el nombre de la clase, su familia (`SlimeVeloz -> Slime -> Entidad`),
  una frase y **solo 2 o 3 datos clave de `self`**, actualizándose en vivo (por ejemplo `self.vida`
  o `self.velocidad`). En el Cofre no aparece `oro`: es privado.
- **Panel 2, QUÉ ESTÁS APRENDIENDO:** el concepto del barrio en una frase, su analogía y una
  **barra de avance** de la misión.
- **Panel 3, CÓMO ESTÁ HECHO:** **un solo método**, el más importante, leído del archivo `.lua`
  mientras juegas. **TAB** abre el archivo completo justo en ese método.
- **CONSOLA EN VIVO:** solo las **3 últimas acciones**: el evento, la línea que se ejecutó y qué
  significa. Al presionar E dice **en qué clase encontró Lua el método**
  (por ejemplo `SlimeVeloz (no) -> Slime (sí)`).
- **Tecla H, modo juego:** oculta el panel y la consola y agranda el mapa. Útil para que primero
  jueguen sin distracciones y luego, con H, explicar lo que pasó.
- **Diálogos:** los maestros tienen retrato, texto con efecto de máquina de escribir y recuadros de
  código. Lo que va entre `` `comillas invertidas` `` se pinta como código.
- **Al ganar un sello** aparece un anuncio con confeti y la frase ancla del concepto.

### Juego y herramientas didácticas, separados

Las herramientas para enseñar **solo leen** el juego y no lo modifican. Si borras `ui/panel.lua`,
`ui/consola.lua` y `ui/pergamino.lua` (y sus líneas en `main.lua`), el juego sigue funcionando igual.

| Capa | Archivos | Qué hace |
|---|---|---|
| Juego | `entities/`, `components/`, `core/mundo.lua`, `core/eventos.lua`, `systems/` | Las reglas y los objetos |
| Contenido pedagógico | `data/guia.lua`, `data/lecciones.lua` | Todo el texto que explica; se edita sin programar |
| Herramientas para enseñar | `ui/panel.lua`, `ui/consola.lua`, `ui/pergamino.lua`, `core/introspeccion.lua`, `ui/codigo_fuente.lua`, `ui/resaltado.lua` | Muestran el juego por dentro |
| Presentación | `ui/hud.lua`, `ui/dialogo.lua`, `ui/pantallas.lua`, `ui/estilo.lua`, `core/pantalla.lua` | La interfaz |

**Fuente monoespaciada (opcional):** el código se ve con la fuente estándar de LÖVE. Si pones una
fuente gratuita como JetBrains Mono o Fira Code en `assets/mono.ttf`, el juego la usa automáticamente
y el código se verá como en VS Code.

## Los 6 barrios

| # | Barrio | Concepto | Analogía | Archivos para mostrar con TAB |
|---|---|---|---|---|
| 1 | Plaza del Molde | Clase, objeto, constructor, `self` | Molde de galletas | `entidad.lua`, `moneda.lua` |
| 2 | Barrio Familia | Herencia, override, llamar al padre | La abuela y sus nietos | `slime.lua`, `slime_veloz.lua`, `slime_gigante.lua` |
| 3 | La Bóveda | Encapsulación (closure privado) | Cajero automático | `cofre.lua`, `llave.lua` |
| 4 | El Mercado | Polimorfismo | El botón de *play* | `lampara.lua`, `fuente.lua`, `cartel.lua`, `main.lua` |
| 5 | Taller LEGO | Composición, abstracción, contratos | Piezas LEGO (TIENE-UN contra ES-UN) | `components/botas.lua`, `components/iman.lua`, `jugador.lua` |
| 6 | Torre del Pregonero | Desacoplamiento (Observer) | Emisora de radio | `core/eventos.lua`, `pregonero.lua`, `ui/hud.lua`, `systems/sonido.lua` |

El pergamino (TAB) muestra además la **cadena `__index`** del objeto, por ejemplo
`SlimeGigante -> Slime -> Entidad`: es literalmente el camino que recorre Lua al buscar un método.

## Arquitectura

```
main.lua              Solo orquesta. No conoce ningún tipo concreto.
conf.lua              Ventana redimensionable (lienzo virtual de 1600x900).
core/
  eventos.lua         Pub/Sub: Eventos.on / Eventos.emit / Eventos.cuantos.
  mundo.lua           Lista de entidades: update, contactos AABB, dibujar.
  fabrica.lua         Datos -> objetos. Registro de clases (aquí se agrega una clase nueva).
  pantalla.lua        Escala el lienzo a cualquier ventana; define las 3 zonas.
  introspeccion.lua   Lee cadenas __index, campos y métodos de un objeto.
entities/             Una clase por archivo. Todas heredan de Entidad.
components/           Piezas componibles con contrato aplicar() / dibujar().
systems/              Oyentes de eventos sin dibujo: misiones, sonido.
ui/                   Panel, consola, HUD, diálogo, pergamino, pantallas, estilo, resaltado.
data/                 Solo tablas: mapa, misiones, lecciones y guía (texto pedagógico).
```

Árbol de herencia:

```
Entidad
├── Jugador          (además COMPONE: Botas, Imán)
├── Moneda
├── NPC
│   └── Pregonero    (nieto: reusa NPC.dibujar y agrega su tablero)
├── Slime
│   ├── SlimeVeloz   (override de update + llama al padre)
│   └── SlimeGigante (override de recibirGolpe + llama al padre)
├── Llave, Cofre, Cartel, Lampara, Fuente, Pieza, Campana, Puerta
```

Flujo de eventos (nadie se conoce):

```
Moneda:alTocar ──emit("moneda_recogida")──► HUD (suma oro)
                                        ├─► Sonido (bip)
                                        ├─► Misiones (cuenta, emite "sello_obtenido")
                                        └─► Pregonero (lo anota)
"sello_obtenido" ──► HUD, Sonido, Puerta (cuenta sellos), Pregonero
```

## Dónde está cada pilar y cada principio

| Idea | Dónde verla en el código |
|---|---|
| **Abstracción** | `Mundo:update` solo llama `e:update()` y `e:alTocar()`. El Imán pregunta `e.atraible`, no el tipo. |
| **Encapsulación** | `cofre.lua`: `oro` es un `local` del constructor; solo `abrir()` lo toca. `Jugador:recibirLlave()` en vez de escribir campos ajenos. |
| **Herencia** | `setmetatable(Hija, { __index = Padre })` en todas las entidades. |
| **Polimorfismo** | `main.lua`: `cerca:interactuar(jugador, mundo)`. Cada clase responde distinto. |
| **S** (responsabilidad única) | Un archivo, un trabajo: el mundo actualiza, el HUD muestra, el sonido suena, las misiones evalúan. |
| **O** (abierto/cerrado) | Clase nueva = archivo nuevo + una línea en `fabrica.lua` + datos en `mapa.lua`. `main.lua` no se toca. |
| **L** (sustitución de Liskov) | Cualquier hija de `Entidad` funciona en `Mundo` sin cambios. |
| **I** (segregación de interfaces) | El contrato de los componentes es mínimo: `aplicar` y `dibujar`. |
| **D** (inversión de dependencias) | HUD, misiones y sonido dependen de eventos, no de `Moneda` ni de `Cofre`. El mundo se pasa por parámetro (`update(dt, mundo)`), sin globales. |
| **Datos sobre código** | `data/mapa.lua`, `data/misiones.lua` y `data/lecciones.lua` cambian el juego sin tocar la lógica. |

## Guion sugerido para cada barrio (unos 15 minutos)

1. **Jugar** (2 min): que alguien conduzca el juego en el proyector y la clase decida. Mientras
   juegan, señala el panel derecho (qué ves, qué aprendes, cómo está hecho) y la consola.
2. **TAB** (5 min): abrir el archivo completo, leer la cadena `__index` y señalar 2 o 3 líneas clave.
3. **Reto en vivo** (5 a 8 min): ver la tabla siguiente.
4. **Frase ancla**: la que aparece en la pantalla final para ese sello (está en `data/misiones.lua`).

## Retos en vivo

| Barrio | Reto | Pista o solución |
|---|---|---|
| 1 | Agrega una moneda que valga 5 y sea naranja. | En `mapa.lua`: `{ tipo = "Moneda", x = 60, y = 290, valor = 5, color = {1, .5, .1} }`. Es el mismo molde con otro estado. |
| 1+ | Crea la **clase** `MonedaDorada` que herede de `Moneda` y gire. | Copia el patrón de `slime_veloz.lua`, regístrala en `fabrica.lua` y úsala en `mapa.lua`. |
| 2 | Crea `SlimeSaltarin` que rebote en vertical. | Hereda de `Slime`; en `update` llama `Slime.update(self, dt)` y suma `math.sin(love.timer.getTime()*8)*2` a `self.y`. |
| 3 | En `Cofre:interactuar` escribe `self.oro = 999` antes de abrir. ¿Cuánto oro sale? | Siguen saliendo 50: `self.oro` es un campo nuevo; el oro real es un `local` invisible. |
| 4 | Crea un `Gato` que al presionar E diga "Miau". | `Eventos.emit("aviso", "Miau")` dentro de `Gato:interactuar`. Regístralo y ubícalo en el Mercado. **No toques `main.lua`.** |
| 5 | Crea el componente `Escudo` que anule los empujones de los slimes. | `function Escudo:aplicar(dueno) dueno.empujeX, dueno.empujeY = 0, 0 end`. Agrégalo a `COMPONENTES` en `pieza.lua` y ponlo en el mapa. |
| 6 | Crea `systems/logros.lua`: al recoger 10 monedas avisa "¡Logro: Millonario!". | `Eventos.on("moneda_recogida", ...)` y un contador. Una sola línea nueva en `main.lua`: `logros.iniciar()`. `moneda.lua` no cambia. |
| 6+ | Comenta `sonido.iniciar()` en `main.lua`. | El juego sigue funcionando, pero en silencio. Eso demuestra que el sonido está desacoplado. |

## Construirlo por capas (si lo programas en vivo)

Cada capa usa solo lo que ya se vio. Las tablas `data/` se pueden ir llenando de a poco.

1. **Clase y objeto:** `entidad.lua`, `moneda.lua`, `jugador.lua` y un `main.lua` mínimo que crea monedas en un ciclo `for`.
2. **Herencia y polimorfismo de update/dibujar:** los tres slimes y `core/mundo.lua`.
3. **Encapsulación y polimorfismo de interactuar:** cofre, llave, lámpara, fuente y cartel; luego `fabrica.lua` y `mapa.lua` (datos, OCP).
4. **Composición y desacoplamiento:** componentes, `eventos.lua`, HUD, sonido, misiones y Pregonero. Cierre con SOLID.

## Editar el contenido sin programar

- **Textos de los maestros (con recuadros de código):** `data/lecciones.lua`.
- **Panel y consola (frase de cada clase, qué datos y qué método mostrar, cómo explicar cada evento):** `data/guia.lua`.
- **Posiciones y objetos:** `data/mapa.lua`.
- **Metas de los sellos y frases ancla:** `data/misiones.lua`.

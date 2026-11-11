-- GUÍA: el contenido PEDAGÓGICO, separado del código del juego.
-- El panel derecho y la consola leen esta tabla. Puedes reescribir cualquier
-- explicación aquí sin tocar una sola clase. Regla: textos CORTOS.
--
--   barrios : tarjeta 2 "QUÉ ESTÁS APRENDIENDO"
--   clases  : tarjeta 1 "QUÉ ESTÁS VIENDO" (texto + campos a mostrar)
--             tarjeta 3 "CÓMO ESTÁ HECHO" (qué método enseñar)
--   eventos : cómo explicar en la consola cada evento

local introspeccion = require("core.introspeccion")

return {
  barrios = {
    molde   = { mision = "Recoge las 5 monedas", titulo = "CLASE Y OBJETO",  idea = "La clase es el molde. Cada objeto sale del molde con su propio estado.",
                analogia = "Un molde de galletas, muchas galletas." },
    familia = { mision = "Aplasta los 3 slimes con E", titulo = "HERENCIA",        idea = "La hija reusa todo lo del padre y solo cambia lo que la hace distinta.",
                analogia = "Los nietos heredan los ojos de la abuela." },
    boveda  = { mision = "Halla la llave y abre el cofre", titulo = "ENCAPSULACIÓN",   idea = "Los datos se esconden. Solo se tocan con métodos.",
                analogia = "Un cajero: usas los botones, no metes la mano." },
    mercado = { mision = "Usa lámpara, fuente y cartel", titulo = "POLIMORFISMO",    idea = "Un mismo mensaje, interactuar(), y cada objeto responde a su manera.",
                analogia = "El botón play: música en la radio, película en la tele." },
    taller  = { mision = "Equípate Botas e Imán", titulo = "COMPOSICIÓN",     idea = "El objeto TIENE piezas en vez de SER algo. Solo importa el contrato aplicar().",
                analogia = "Piezas LEGO que se encajan." },
    torre   = { mision = "Toca las 3 campanas", titulo = "DESACOPLAMIENTO", idea = "Quien emite un evento no sabe quién lo escucha.",
                analogia = "Una emisora de radio." },
  },

  clases = {
    Jugador      = { metodo = "equipar",      campos = { "velocidad", "velocidadBase", "llave" },
                     viendo = "Eres TÚ: Jugador.new(). Ponte las Botas y mira tu velocidad." },
    Moneda       = { metodo = "alTocar",      campos = { "valor", "x", "y" },
                     viendo = "Mismo molde, pero cada moneda tiene SU x y SU y." },
    NPC          = { metodo = "interactuar",  campos = { "nombre", "hablado" },
                     viendo = "Solo emite \"dialogo\". No sabe dibujar la caja." },
    Pregonero    = { metodo = "new",          campos = { "nombre" },
                     viendo = "Escucha TODOS los eventos con Eventos.on(\"*\")." },
    Slime        = { metodo = "recibirGolpe", campos = { "vida", "velocidad" },
                     viendo = "El PADRE de los slimes: sabe moverse y recibir golpes." },
    SlimeVeloz   = { metodo = "update",       campos = { "vida", "velocidad" },
                     viendo = "Hijo de Slime. Solo cambia update()." },
    SlimeGigante = { metodo = "recibirGolpe", campos = { "vida", "w", "h" },
                     viendo = "Hijo de Slime. Al recibir un golpe, se encoge." },
    Llave        = { metodo = "alTocar",      campos = { "id" },
                     viendo = "Le pide al jugador recibirLlave(). No toca sus campos." },
    Cofre        = { metodo = "new",          campos = { "x", "y" },
                     viendo = "¿Dónde está el oro? No aparece aquí: es PRIVADO." },
    Cartel       = { metodo = "interactuar",  campos = {},
                     viendo = "interactuar() = hablar." },
    Lampara      = { metodo = "interactuar",  campos = { "encendida" },
                     viendo = "interactuar() = encender o apagar. Presiona E." },
    Fuente       = { metodo = "interactuar",  campos = {},
                     viendo = "interactuar() = crear una Moneda nueva." },
    Pieza        = { metodo = "alTocar",      campos = {},
                     viendo = "Al tocarla: jugador:equipar(componente)." },
    Campana      = { metodo = "interactuar",  campos = { "nota" },
                     viendo = "Solo emite un evento. No conoce a quien la escucha." },
    Puerta       = { metodo = "interactuar",  campos = { "sellos", "necesarios" },
                     viendo = "Cuenta sellos escuchando \"sello_obtenido\"." },
  },

  -- Cada función recibe los datos del evento y devuelve: código, explicación.
  eventos = {
    interaccion = function(e)
      return "cerca:interactuar(jugador, mundo)",
             "Lua lo busca en: " .. introspeccion.buscarMetodo(e, "interactuar")
    end,
    moneda_recogida = function()
      return 'Eventos.emit("moneda_recogida", self)', "La moneda avisa y se olvida."
    end,
    golpe = function(s)
      return "self.vida = self.vida - 1", "A este " .. s.clase .. " le queda vida = " .. s.vida
    end,
    enemigo_derrotado = function()
      return "self.muerta = true", "El mundo retira los objetos muertos."
    end,
    llave_recogida = function()
      return "jugador:recibirLlave(self.id)", "Usa un método, no escribe en campos ajenos."
    end,
    cofre_cerrado = function()
      return "self:abrir(jugador.llave)  -- nil", "Sin la llave, el oro privado no sale."
    end,
    cofre_abierto = function(_, botin)
      return "self:abrir(jugador.llave)  -- " .. botin, "Solo abrir() puede leer el oro privado."
    end,
    componente_equipado = function(c)
      return "jugador:equipar(" .. c.nombre .. ")", "Ahora cada frame se llama " .. c.nombre .. ":aplicar()."
    end,
    campana_tocada = function()
      return 'Eventos.emit("campana_tocada", self)', "La campana no sabe quién la escucha."
    end,
    sello_obtenido = function(sello)
      return 'Eventos.emit("sello_obtenido", "' .. sello .. '")', "La Puerta, el HUD y el sonido lo escuchan."
    end,
  },
}

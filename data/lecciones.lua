-- LECCIONES: lo que dice cada maestro. Solo texto: edítalo sin miedo.
-- Cada elemento es una "página" del diálogo:
--   "texto"                               -> solo texto
--   { texto = "...", codigo = "..." }     -> texto + un recuadro de código
-- Lo que va entre `comillas invertidas` se pinta como código.

return {
  molde = {
    "¡Bienvenido, recién instanciado! Aquí todo empieza con un MOLDE.",
    { texto = "Una CLASE es como mi molde de galletas: no se come, pero con él haces todas las galletas que quieras. En Lua, una clase es solo una tabla:",
      codigo = "local Moneda = {}\nMoneda.__index = Moneda   -- \"si a un objeto le falta algo, búscalo aquí\"" },
    { texto = "Cada galleta es un OBJETO. Se fabrica con el constructor `Moneda.new(d)` y guarda su propio estado en `self`:",
      codigo = "function Moneda.new(d)\n  local self = Entidad.new(d)   -- x, y, tamaño...\n  setmetatable(self, Moneda)    -- ahora \"es\" una Moneda\n  self.valor = d.valor or 1     -- estado PROPIO\n  return self\nend" },
    "Mira el PANEL de la derecha: al acercarte a una moneda verás SU estado (x, y, valor). Acércate a otra: mismo molde, otros valores.",
    "Abajo, la CONSOLA EN VIVO te muestra lo que el código ejecuta cuando haces algo. Recoge las 5 monedas y gana el sello CLASE Y OBJETO.",
  },
  familia = {
    "Soy la Abuela Entidad. Todo en esta ciudad desciende de mí: posición, tamaño, saber dibujarse, saber si choca.",
    { texto = "Eso es HERENCIA. Un `Slime` ES-UNA `Entidad`. Una sola línea conecta al hijo con el padre:",
      codigo = "setmetatable(Slime, { __index = Entidad })\n-- si a Slime le falta un método, Lua lo busca en Entidad" },
    { texto = "Cada nieto tiene su carácter. `SlimeVeloz` SOBRESCRIBE `update()`: primero hace lo del padre y luego lo suyo.",
      codigo = "function SlimeVeloz:update(dt, mundo)\n  Slime.update(self, dt, mundo)            -- 1) lo del padre\n  self.cambio = math.min(self.cambio, 0.4) -- 2) lo extra\nend" },
    "Golpea a mis nietos con E y mira la consola: dice EN QUÉ CLASE encontró Lua el método. Para el Veloz dirá: SlimeVeloz (no) -> Slime (sí).",
    "Aplasta a los tres (tranquilo, son de gelatina) y te doy el sello de la HERENCIA.",
  },
  boveda = {
    "Bienvenido a La Bóveda. Ese cofre guarda oro, pero aquí nadie mete la mano.",
    { texto = "Eso es ENCAPSULACIÓN. El oro NO es `self.oro`: es una variable `local` del constructor. Solo la ven las funciones creadas ahí mismo.",
      codigo = "local oro = d.oro or 50           -- PRIVADO\n\nfunction self:abrir(llave)        -- PÚBLICO\n  if llave ~= llaveCorrecta then return nil end\n  local botin = oro; oro = 0\n  return botin\nend" },
    "Es como un cajero automático: no abres la máquina, usas sus botones. El único botón de este cofre es `cofre:abrir(llave)`.",
    "Acércate al cofre y mira el panel: en su estado NO aparece 'oro'. Aunque alguien escriba `cofre.oro = 999`, solo crea un campo falso.",
    "Se me cayó la llave por aquí cerca. Encuéntrala, abre el cofre y gana el sello de la ENCAPSULACIÓN.",
  },
  mercado = {
    "¡Siga, siga! En mi mercado todo responde a la misma tecla: E.",
    { texto = "El código del juego NO sabe qué tienes enfrente. Solo envía el mismo mensaje a lo que esté cerca:",
      codigo = "local cerca = mundo:masCercano(70, true)\ncerca:interactuar(jugador, mundo)   -- ¿qué pasará? ¡depende del objeto!" },
    "La lámpara se enciende, la fuente regala monedas, el cartel habla. Eso es POLIMORFISMO: como el botón de play en la radio o en el televisor.",
    { texto = "Cada clase escribe SU versión de `interactuar`:",
      codigo = "function Lampara:interactuar()  self.encendida = not self.encendida  end\nfunction Fuente:interactuar(j, mundo)  mundo:agregar(Moneda.new({...}))  end\nfunction Cartel:interactuar()  Eventos.emit(\"dialogo\", \"Cartel\", {...})  end" },
    "Prueba la lámpara, la fuente y el cartel para ganar el sello del POLIMORFISMO.",
  },
  taller = {
    "Bienvenido al Taller LEGO. Aquí no heredamos: ENCAJAMOS piezas.",
    "Heredar es decir ES-UN: un Slime ES-UNA Entidad. Componer es decir TIENE-UN: el jugador TIENE-UNAS botas.",
    { texto = "Cada pieza cumple un CONTRATO sencillo: tener `aplicar(dueno, dt, mundo)`. El jugador las recorre sin saber qué hace cada una:",
      codigo = "for _, c in ipairs(self.componentes) do\n  c:aplicar(self, dt, mundo)   -- Botas, Imán... ¡o lo que inventes!\nend" },
    { texto = "Eso es ABSTRACCIÓN. El imán no pregunta '¿eres una Moneda?', pregunta '¿eres atraible?':",
      codigo = "if e.atraible then\n  -- acercarlo al dueño\nend" },
    "Equípate las Botas y el Imán. Mira en el panel cómo cambia tu 'velocidad' al ponerte las botas.",
  },
  torre = {
    "¡Oigan, oigan! Soy el Pregonero. Escucho todo lo que pasa en Objetópolis y lo anoto en mi tablero.",
    { texto = "Cuando recoges una moneda, la moneda no llama al HUD ni al sonido. Solo grita:",
      codigo = "Eventos.emit(\"moneda_recogida\", self)" },
    { texto = "Quien quiera enterarse se suscribe. Como una emisora de radio: el locutor no sabe quién escucha.",
      codigo = "-- en ui/hud.lua\nEventos.on(\"moneda_recogida\", function(moneda)\n  hud.oro = hud.oro + moneda.valor\nend)" },
    "Eso es DESACOPLAMIENTO: puedes quitar el sonido o agregar logros sin tocar ni una línea de la moneda. La consola te dice cuántos oyentes tiene cada evento.",
    "Toca las tres campanas y mira: el HUD, el sonido, la consola y mi tablero reaccionan sin conocerse. Así ganas el sello del DESACOPLAMIENTO.",
  },
  cartel = "Soy un Cartel. Yo también entiendo `interactuar()`, pero respondo a mi manera: hablando. La lámpara responde encendiéndose. ¡Eso es polimorfismo!",
}

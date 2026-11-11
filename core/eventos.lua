-- EVENTOS: la "emisora de radio" del juego (patrón Observer / Pub-Sub).
-- Quien EMITE no sabe quién escucha. Quien ESCUCHA no sabe quién emite.
-- Eso es DESACOPLAMIENTO: las piezas se comunican sin conocerse.
--
-- Es un MÓDULO (una sola tabla), no una clase: en el juego hay UN solo canal.

local Eventos = {}

-- Privado: 'local' hace que nadie fuera de este archivo pueda tocarla.
-- oyentes["moneda_recogida"] = { funcion1, funcion2, ... }
local oyentes = {}

-- Suscribirse: "avísame cuando pase <nombre>".
function Eventos.on(nombre, funcion)
  oyentes[nombre] = oyentes[nombre] or {}
  table.insert(oyentes[nombre], funcion)
end

-- Publicar: "¡pasó <nombre>!" y se avisa a todos los suscritos.
-- Los suscritos a "*" escuchan TODO (el Pregonero y la consola) y se avisan primero.
function Eventos.emit(nombre, ...)
  for _, funcion in ipairs(oyentes["*"] or {}) do funcion(nombre, ...) end
  for _, funcion in ipairs(oyentes[nombre] or {}) do funcion(...) end
end

-- ¿Cuántos oyentes tiene un evento? (la consola lo muestra en clase)
function Eventos.cuantos(nombre)
  return #(oyentes[nombre] or {})
end

return Eventos

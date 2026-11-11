-- MISIONES: escucha eventos y, cuando se cumple una meta, entrega un sello.
-- Las misiones son DATOS (data/misiones.lua). Este archivo solo tiene la regla:
-- "cuenta cosas DISTINTAS que acepte la misión; al llegar a la meta, emite el sello".

local Eventos  = require("core.eventos")
local MISIONES = require("data.misiones")

local misiones = {}

function misiones.iniciar()
  for _, m in ipairs(MISIONES) do
    local vistos, cuenta, hecha = {}, 0, false
    Eventos.on(m.evento, function(dato)
      if hecha then return end
      local clave = m.acepta(dato)
      if clave and not vistos[clave] then
        vistos[clave] = true
        cuenta = cuenta + 1
        if cuenta >= m.meta then
          hecha = true
          Eventos.emit("sello_obtenido", m.sello)
        else
          Eventos.emit("progreso", m.sello, cuenta, m.meta)
        end
      end
    end)
  end
end

return misiones

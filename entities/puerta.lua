-- PUERTA DEL ARQUITECTO: se abre con los 6 sellos.
-- No sabe nada de barrios ni misiones: solo ESCUCHA "sello_obtenido" y cuenta.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Puerta = {}
Puerta.__index = Puerta
setmetatable(Puerta, { __index = Entidad })

Puerta.clase         = "Puerta"
Puerta.tipo          = "puerta"
Puerta.archivo       = "entities/puerta.lua"
Puerta.interactuable = true

function Puerta.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Puerta)
  self.w, self.h    = 64, 80
  self.necesarios   = d.necesarios or 6
  self.sellos       = 0
  Eventos.on("sello_obtenido", function() self.sellos = self.sellos + 1 end)
  return self
end

function Puerta:interactuar(jugador, mundo)
  if self.sellos >= self.necesarios then
    Eventos.emit("juego_completado")
  else
    Eventos.emit("dialogo", "Puerta del Arquitecto", {
      ("Tengo %d de %d sellos. No abro sin todos."):format(self.sellos, self.necesarios),
      "Recorre los barrios, aprende de sus maestros y vuelve. Mira la barra de arriba.",
    })
  end
end

function Puerta:dibujar()
  local lista = self.sellos >= self.necesarios
  love.graphics.setColor(0.5, 0.5, 0.55)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 30, 30)            -- arco
  if lista then love.graphics.setColor(1, 0.9, 0.5) else love.graphics.setColor(0.12, 0.1, 0.15) end
  love.graphics.rectangle("fill", self.x + 10, self.y + 14, self.w - 20, self.h - 14, 20, 20)
  for i = 1, self.necesarios do                                                      -- luces
    if i <= self.sellos then love.graphics.setColor(1, 0.85, 0.2) else love.graphics.setColor(0.25, 0.25, 0.3) end
    love.graphics.circle("fill", self.x + 7 + (i - 1) * 10, self.y - 8, 4)
  end
end

return Puerta

-- LÁMPARA: responde a interactuar() encendiéndose o apagándose. (Polimorfismo, versión 2)

local Entidad = require("entities.entidad")

local Lampara = {}
Lampara.__index = Lampara
setmetatable(Lampara, { __index = Entidad })

Lampara.clase         = "Lampara"
Lampara.tipo          = "lampara"
Lampara.archivo       = "entities/lampara.lua"
Lampara.interactuable = true

function Lampara.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Lampara)
  self.w, self.h  = 20, 56
  self.encendida  = false
  return self
end

function Lampara:interactuar(jugador, mundo)
  self.encendida = not self.encendida
end

function Lampara:dibujar()
  local cx = self.x + self.w / 2
  if self.encendida then
    love.graphics.setColor(1, 0.9, 0.4, 0.15)
    love.graphics.circle("fill", cx, self.y + 8, 70)
  end
  love.graphics.setColor(0.35, 0.35, 0.4)
  love.graphics.rectangle("fill", cx - 2, self.y + 12, 4, self.h - 12)   -- poste
  if self.encendida then love.graphics.setColor(1, 0.95, 0.5) else love.graphics.setColor(0.4, 0.4, 0.35) end
  love.graphics.circle("fill", cx, self.y + 8, 9)                        -- bombillo
end

return Lampara

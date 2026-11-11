-- FUENTE: responde a interactuar() creando una Moneda nueva. (Polimorfismo, versión 3)
-- Fíjate: crear un objeto en pleno juego es solo llamar al constructor.

local Entidad = require("entities.entidad")
local Moneda  = require("entities.moneda")

local Fuente = {}
Fuente.__index = Fuente
setmetatable(Fuente, { __index = Entidad })

Fuente.clase         = "Fuente"
Fuente.tipo          = "fuente"
Fuente.archivo       = "entities/fuente.lua"
Fuente.interactuable = true

function Fuente.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Fuente)
  self.w, self.h = 56, 40
  return self
end

function Fuente:interactuar(jugador, mundo)
  local moneda = Moneda.new({
    x = self.x + math.random(-30, self.w + 30),
    y = self.y + self.h + math.random(10, 40),
    barrio = self.barrio,
  })
  mundo:agregar(moneda)
end

function Fuente:dibujar()
  local cx, cy = self:centro()
  love.graphics.setColor(0.5, 0.5, 0.55)
  love.graphics.ellipse("fill", cx, cy + 6, self.w / 2, self.h / 3)
  love.graphics.setColor(0.3, 0.6, 1)
  love.graphics.ellipse("fill", cx, cy + 4, self.w / 2 - 6, self.h / 3 - 4)
  local chorro = 6 + math.sin(love.timer.getTime() * 6) * 2
  love.graphics.rectangle("fill", cx - 2, cy - 14 - chorro, 4, 16 + chorro)
end

return Fuente

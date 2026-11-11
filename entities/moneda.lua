-- MONEDA: la primera clase HIJA. Un molde -> muchas monedas.
-- Moneda ES-UNA Entidad: hereda centro(), toca(), distanciaA()... sin escribirlos.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Moneda = {}
Moneda.__index = Moneda
setmetatable(Moneda, { __index = Entidad })   -- HERENCIA: lo que no esté aquí, búscalo en Entidad

Moneda.clase    = "Moneda"
Moneda.tipo     = "moneda"
Moneda.archivo  = "entities/moneda.lua"
Moneda.atraible = true   -- el Imán atrae lo "atraible" (no le importa que sea Moneda)

function Moneda.new(d)
  local self = Entidad.new(d)     -- 1) el padre construye lo común (x, y, barrio...)
  setmetatable(self, Moneda)      -- 2) y ahora el objeto "es" una Moneda
  self.w, self.h = 16, 16
  self.valor  = d.valor or 1
  self.color  = d.color or { 1, 0.85, 0.2 }
  self.tiempo = math.random() * 6 -- estado PROPIO: cada moneda brilla a su ritmo
  return self
end

function Moneda:update(dt)
  self.tiempo = self.tiempo + dt
end

function Moneda:alTocar(jugador)
  self.muerta = true
  Eventos.emit("moneda_recogida", self)   -- grita y se olvida: no sabe quién escucha
end

-- SOBRESCRIBE el dibujar() de Entidad: una moneda es un círculo, no un cuadrado.
function Moneda:dibujar()
  local cx, cy = self:centro()
  local brillo = 0.8 + 0.2 * math.sin(self.tiempo * 4)
  local c = self.color
  love.graphics.setColor(c[1] * brillo, c[2] * brillo, c[3] * brillo)
  love.graphics.circle("fill", cx, cy, 8)
  love.graphics.setColor(1, 1, 1, 0.6)
  love.graphics.circle("line", cx, cy, 8)
end

return Moneda

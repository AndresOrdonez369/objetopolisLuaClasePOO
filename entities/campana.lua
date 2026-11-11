-- CAMPANA: al tocarla con E, solo EMITE "campana_tocada".
-- No llama al sonido, ni al HUD, ni al Pregonero. Ellos escuchan por su cuenta.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Campana = {}
Campana.__index = Campana
setmetatable(Campana, { __index = Entidad })

Campana.clase         = "Campana"
Campana.tipo          = "campana"
Campana.archivo       = "entities/campana.lua"
Campana.interactuable = true

function Campana.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Campana)
  self.w, self.h = 34, 36
  self.nota      = d.nota or 523     -- frecuencia en Hz (523 = Do)
  self.sonando   = 0
  return self
end

function Campana:interactuar(jugador, mundo)
  self.sonando = 0.8
  Eventos.emit("campana_tocada", self)
end

function Campana:update(dt)
  self.sonando = math.max(0, self.sonando - dt)
end

function Campana:dibujar()
  local cx = self.x + self.w / 2
  local giro = math.sin(self.sonando * 20) * self.sonando * 6
  love.graphics.setColor(0.45, 0.3, 0.15)
  love.graphics.rectangle("fill", cx - 2, self.y - 6, 4, 8)                       -- soporte
  love.graphics.setColor(0.95, 0.75, 0.25)
  love.graphics.arc("fill", cx + giro, self.y + 20, self.w / 2, math.pi, 2 * math.pi)
  love.graphics.rectangle("fill", self.x + giro, self.y + 20, self.w, 10)
  love.graphics.setColor(0.6, 0.45, 0.1)
  love.graphics.circle("fill", cx + giro * 1.5, self.y + 32, 4)                    -- badajo
end

return Campana

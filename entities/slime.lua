-- SLIME: un enemigo de gelatina. Clase PADRE de SlimeVeloz y SlimeGigante.
-- Se mueve al azar dentro de su barrio. Con E lo aplastas.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Slime = {}
Slime.__index = Slime
setmetatable(Slime, { __index = Entidad })

Slime.clase         = "Slime"
Slime.tipo          = "slime"
Slime.archivo       = "entities/slime.lua"
Slime.interactuable = true

function Slime.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Slime)
  self.w, self.h  = 30, 24
  self.color      = { 0.4, 0.9, 0.4 }
  self.vida       = 1
  self.velocidad  = 50
  self.zona       = d.zona               -- el rectángulo de su barrio
  self.angulo     = math.random() * math.pi * 2
  self.cambio     = 0                    -- segundos para cambiar de rumbo
  self.golpeado   = 0                    -- destello blanco al recibir golpe
  return self
end

function Slime:update(dt)
  self.cambio = self.cambio - dt
  if self.cambio <= 0 then
    self.angulo = math.random() * math.pi * 2
    self.cambio = 1 + math.random() * 2
  end
  self.x = self.x + math.cos(self.angulo) * self.velocidad * dt
  self.y = self.y + math.sin(self.angulo) * self.velocidad * dt

  -- Rebotar en los bordes de su barrio
  local z = self.zona
  if self.x < z.x + 4 or self.x + self.w > z.x + z.w - 4 then self.angulo = math.pi - self.angulo end
  if self.y < z.y + 44 or self.y + self.h > z.y + z.h - 4 then self.angulo = -self.angulo end
  self.x = math.max(z.x + 4, math.min(z.x + z.w - 4 - self.w, self.x))
  self.y = math.max(z.y + 44, math.min(z.y + z.h - 4 - self.h, self.y))

  self.golpeado = math.max(0, self.golpeado - dt)
end

function Slime:recibirGolpe()
  self.vida = self.vida - 1
  self.golpeado = 0.15
  Eventos.emit("golpe", self)
  if self.vida <= 0 then
    self.muerta = true
    Eventos.emit("enemigo_derrotado", self)
  end
end

function Slime:interactuar(jugador, mundo)
  self:recibirGolpe()
end

function Slime:alTocar(jugador)   -- un empujoncito de gelatina
  local jx, jy = jugador:centro()
  local sx, sy = self:centro()
  local d = math.max(1, math.sqrt((jx - sx) ^ 2 + (jy - sy) ^ 2))
  jugador:empujar((jx - sx) / d * 320, (jy - sy) / d * 320)
end

function Slime:dibujar()
  local cx, cy = self:centro()
  if self.golpeado > 0 then love.graphics.setColor(1, 1, 1) else love.graphics.setColor(self.color) end
  love.graphics.ellipse("fill", cx, cy, self.w / 2, self.h / 2)
  love.graphics.setColor(0.1, 0.1, 0.15)
  love.graphics.circle("fill", cx - self.w * 0.18, cy - self.h * 0.1, 3)
  love.graphics.circle("fill", cx + self.w * 0.18, cy - self.h * 0.1, 3)
end

return Slime

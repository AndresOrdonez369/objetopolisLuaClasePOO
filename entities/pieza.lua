-- PIEZA: un pedestal que guarda un COMPONENTE. Al tocarla, el jugador se lo equipa.

local Entidad = require("entities.entidad")

local COMPONENTES = {
  botas = require("components.botas"),
  iman  = require("components.iman"),
}

local Pieza = {}
Pieza.__index = Pieza
setmetatable(Pieza, { __index = Entidad })

Pieza.clase   = "Pieza"
Pieza.tipo    = "pieza"
Pieza.archivo = "entities/pieza.lua"

function Pieza.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Pieza)
  self.w, self.h   = 30, 30
  self.componente  = COMPONENTES[d.componente].new()
  return self
end

function Pieza:alTocar(jugador)
  self.muerta = true
  jugador:equipar(self.componente)
end

function Pieza:dibujar()
  local cx = self.x + self.w / 2
  local flota = math.sin(love.timer.getTime() * 3) * 4
  love.graphics.setColor(0.35, 0.35, 0.4)
  love.graphics.rectangle("fill", self.x - 4, self.y + self.h - 6, self.w + 8, 10, 2, 2)  -- pedestal
  love.graphics.setColor(self.componente.color)
  love.graphics.rectangle("fill", self.x + 5, self.y + flota, self.w - 10, self.w - 10, 4, 4)
  love.graphics.setColor(1, 1, 1, 0.85)
  love.graphics.printf(self.componente.nombre, cx - 40, self.y + self.h + 6, 80, "center")
end

return Pieza

-- LLAVE: al tocarla, el jugador la guarda. Abre el cofre de La Bóveda.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Llave = {}
Llave.__index = Llave
setmetatable(Llave, { __index = Entidad })

Llave.clase   = "Llave"
Llave.tipo    = "llave"
Llave.archivo = "entities/llave.lua"

function Llave.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Llave)
  self.w, self.h = 26, 14
  self.id = d.id or "llave_boveda"
  return self
end

function Llave:alTocar(jugador)
  jugador:recibirLlave(self.id)   -- usa el MÉTODO del jugador, no escribe en sus campos
  self.muerta = true
  Eventos.emit("llave_recogida", self)
end

function Llave:dibujar()
  local flota = math.sin(love.timer.getTime() * 3) * 3
  love.graphics.setColor(1, 0.85, 0.2)
  love.graphics.circle("line", self.x + 6, self.y + 7 + flota, 6)
  love.graphics.rectangle("fill", self.x + 12, self.y + 5 + flota, 14, 4)
  love.graphics.rectangle("fill", self.x + 20, self.y + 9 + flota, 3, 5)
end

return Llave

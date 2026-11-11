-- CARTEL: responde a interactuar() hablando. (Polimorfismo, versión 1)

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Cartel = {}
Cartel.__index = Cartel
setmetatable(Cartel, { __index = Entidad })

Cartel.clase         = "Cartel"
Cartel.tipo          = "cartel"
Cartel.archivo       = "entities/cartel.lua"
Cartel.interactuable = true

function Cartel.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Cartel)
  self.w, self.h = 40, 40
  self.texto = d.texto or "..."
  return self
end

function Cartel:interactuar(jugador, mundo)
  Eventos.emit("dialogo", "Cartel", { self.texto })
end

function Cartel:dibujar()
  love.graphics.setColor(0.45, 0.3, 0.15)
  love.graphics.rectangle("fill", self.x + self.w / 2 - 3, self.y + 16, 6, self.h - 16)  -- palo
  love.graphics.setColor(0.85, 0.7, 0.45)
  love.graphics.rectangle("fill", self.x, self.y, self.w, 22, 3, 3)                       -- tabla
  love.graphics.setColor(0.3, 0.2, 0.1)
  love.graphics.printf("LEE", self.x, self.y + 4, self.w, "center")
end

return Cartel

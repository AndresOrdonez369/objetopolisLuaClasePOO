-- NPC: un personaje que enseña. Al presionar E, abre un diálogo.
-- Ojo: el NPC no dibuja la caja de diálogo ni sabe que existe.
-- Solo emite "dialogo" y la interfaz (ui/dialogo.lua) se encarga.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local NPC = {}
NPC.__index = NPC
setmetatable(NPC, { __index = Entidad })

NPC.clase         = "NPC"
NPC.tipo          = "npc"
NPC.archivo       = "entities/npc.lua"
NPC.interactuable = true

function NPC.new(d)
  local self = Entidad.new(d)
  setmetatable(self, NPC)
  self.w, self.h = 28, 36
  self.nombre  = d.nombre or "Alguien"
  self.lineas  = d.lineas or { "..." }
  self.color   = d.color or { 0.9, 0.6, 0.4 }
  self.hablado = false
  return self
end

function NPC:interactuar(jugador, mundo)
  self.hablado = true
  Eventos.emit("dialogo", self.nombre, self.lineas, self.color)
end

function NPC:dibujar()
  local cx = self.x + self.w / 2
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y + 12, self.w, self.h - 12, 6, 6)  -- cuerpo
  love.graphics.circle("fill", cx, self.y + 8, 10)                                 -- cabeza
  love.graphics.setColor(0.1, 0.1, 0.15)
  love.graphics.circle("fill", cx - 4, self.y + 7, 2)
  love.graphics.circle("fill", cx + 4, self.y + 7, 2)
  love.graphics.setColor(1, 1, 1, 0.8)
  love.graphics.printf(self.nombre, cx - 60, self.y + self.h + 2, 120, "center")
  if not self.hablado then   -- un "!" que salta: "¡háblame!"
    local salto = math.abs(math.sin(love.timer.getTime() * 4)) * 4
    love.graphics.setColor(1, 0.9, 0.2)
    love.graphics.printf("!", cx + 6, self.y - 16 - salto, 20, "left")
  end
end

return NPC

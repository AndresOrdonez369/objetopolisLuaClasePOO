-- PREGONERO: un NPC especial. Cadena: Pregonero -> NPC -> Entidad (¡nieto de Entidad!)
-- Se suscribe a TODOS los eventos ("*") y los anota en su tablero.
-- Nadie le avisa directamente: él escucha la "radio" del juego.

local NPC     = require("entities.npc")
local Eventos = require("core.eventos")

local Pregonero = {}
Pregonero.__index = Pregonero
setmetatable(Pregonero, { __index = NPC })

Pregonero.clase   = "Pregonero"
Pregonero.archivo = "entities/pregonero.lua"

function Pregonero.new(d)
  local self = NPC.new(d)
  setmetatable(self, Pregonero)
  self.anuncios = {}
  Eventos.on("*", function(nombre, dato) self:anunciar(nombre, dato) end)
  return self
end

function Pregonero:anunciar(nombre, dato)
  local detalle = ""
  if nombre == "dialogo" then return end   -- hablar no es noticia
  if type(dato) == "string" then detalle = dato:sub(1, 22) end
  if type(dato) == "table" and dato.clase then detalle = dato.clase end
  table.insert(self.anuncios, 1, nombre .. "  (" .. detalle .. ")")
  if #self.anuncios > 3 then table.remove(self.anuncios) end
end

-- SOBRESCRIBE dibujar(), pero REUSA el del padre y le agrega el tablero.
function Pregonero:dibujar()
  NPC.dibujar(self)                       -- 1) lo que dibuja cualquier NPC
  local tx, ty = self.x + 64, self.y - 10 -- 2) lo propio: el tablero de anuncios
  love.graphics.setColor(0.08, 0.1, 0.12, 0.9)
  love.graphics.rectangle("fill", tx, ty, 280, 82, 6, 6)
  love.graphics.setColor(1, 0.9, 0.3)
  love.graphics.print("TABLERO DE EVENTOS", tx + 10, ty + 6)
  for i, texto in ipairs(self.anuncios) do
    love.graphics.setColor(1, 1, 1, 1 - i * 0.2)
    love.graphics.print("> " .. texto, tx + 10, ty + 8 + i * 17)
  end
end

return Pregonero

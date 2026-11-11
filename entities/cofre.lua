-- COFRE: el ejemplo de ENCAPSULACIÓN.
-- El oro NO es un campo de la tabla (self.oro). Es una variable LOCAL del
-- constructor que solo ven las funciones creadas ahí dentro (un "closure").
-- Desde fuera, la única forma de sacar el oro es el método abrir(llave).
-- Analogía: un cajero automático. No metes la mano: usas los botones.

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Cofre = {}
Cofre.__index = Cofre
setmetatable(Cofre, { __index = Entidad })

Cofre.clase         = "Cofre"
Cofre.tipo          = "cofre"
Cofre.archivo       = "entities/cofre.lua"
Cofre.interactuable = true

function Cofre.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Cofre)
  self.w, self.h = 48, 34

  -- PRIVADO: viven aquí, no en 'self'. Nadie de afuera puede leerlas ni cambiarlas.
  local oro     = d.oro or 50
  local abierto = false
  local llaveCorrecta = d.llave or "llave_boveda"

  -- PÚBLICO: métodos creados AQUÍ DENTRO, por eso sí "ven" las variables privadas.
  function self:abrir(llave)
    if abierto then return 0 end
    if llave ~= llaveCorrecta then return nil end   -- llave equivocada: no hay oro
    abierto = true
    local botin = oro
    oro = 0
    return botin
  end

  function self:estaAbierto()
    return abierto
  end

  return self
end

function Cofre:interactuar(jugador)
  local botin = self:abrir(jugador.llave)
  if botin == nil then
    Eventos.emit("cofre_cerrado", self)
  elseif botin > 0 then
    Eventos.emit("cofre_abierto", self, botin)
  end
end

function Cofre:dibujar()
  love.graphics.setColor(0.55, 0.35, 0.15)
  love.graphics.rectangle("fill", self.x, self.y + 10, self.w, self.h - 10, 3, 3)
  if self:estaAbierto() then
    love.graphics.setColor(1, 0.85, 0.2, 0.7)                          -- brillo del oro
    love.graphics.rectangle("fill", self.x + 4, self.y + 8, self.w - 8, 6)
    love.graphics.setColor(0.45, 0.28, 0.12)
    love.graphics.rectangle("fill", self.x, self.y - 6, self.w, 8, 3, 3) -- tapa abierta
  else
    love.graphics.setColor(0.45, 0.28, 0.12)
    love.graphics.rectangle("fill", self.x, self.y + 2, self.w, 12, 3, 3) -- tapa cerrada
    love.graphics.setColor(1, 0.85, 0.2)
    love.graphics.rectangle("fill", self.x + self.w / 2 - 4, self.y + 10, 8, 8) -- cerradura
  end
end

return Cofre

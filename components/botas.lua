-- BOTAS: un COMPONENTE. No es una Entidad: es una pieza que se le encaja a alguien.
-- CONTRATO (interfaz implícita) que cumple todo componente:
--   aplicar(dueno, dt, mundo)   -> su efecto, cada frame
--   dibujar(dueno)              -> cómo se ve puesto
-- Quien cumpla el contrato, sirve. Eso es ABSTRACCIÓN.

local Botas = {}
Botas.__index = Botas

function Botas.new()
  return setmetatable({ nombre = "Botas", color = { 0.6, 0.35, 0.15 }, multiplicador = 1.8 }, Botas)
end

function Botas:aplicar(dueno, dt, mundo)
  dueno.velocidad = dueno.velocidad * self.multiplicador
end

function Botas:dibujar(dueno)
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", dueno.x - 2, dueno.y + dueno.h - 6, 12, 8, 2, 2)
  love.graphics.rectangle("fill", dueno.x + dueno.w - 10, dueno.y + dueno.h - 6, 12, 8, 2, 2)
end

return Botas

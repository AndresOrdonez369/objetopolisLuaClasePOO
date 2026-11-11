-- ENTIDAD: la clase base, la "abuela" de todo lo que existe en Objetópolis.
-- Monedas, slimes, cofres, el jugador... todos SON-UNA Entidad.
--
-- El patrón de clase en Lua tiene 4 pasos:
--   1) la clase es una tabla
--   2) Clase.__index = Clase   ("si a un objeto le falta algo, búscalo aquí")
--   3) un constructor que usa setmetatable
--   4) métodos definidos con ":" (reciben 'self' = el objeto que llama)

local Entidad = {}            -- 1)
Entidad.__index = Entidad     -- 2)

-- Campos de CLASE: existen UNA sola vez aquí; los objetos los leen vía __index.
Entidad.clase         = "Entidad"
Entidad.tipo          = "entidad"
Entidad.archivo       = "entities/entidad.lua"   -- el pergamino (TAB) lo lee
Entidad.interactuable = false                    -- ¿responde a la tecla E?

-- 3) Constructor: crea una tabla, le pone la metatabla y la devuelve.
--    Recibe una tabla 'd' con datos: { x = 100, y = 50, color = {...} }
function Entidad.new(d)
  local self = setmetatable({}, Entidad)
  -- Campos de INSTANCIA: cada objeto tiene los suyos.
  self.x, self.y = d.x, d.y
  self.w, self.h = d.w or 32, d.h or 32
  self.color     = d.color or { 1, 1, 1 }
  self.barrio    = d.barrio      -- id del barrio donde vive
  self.muerta    = false         -- cuando sea true, el mundo la retira
  return self
end

-- 4) Métodos por defecto. Las clases hijas pueden SOBRESCRIBIRLOS (override).
function Entidad:update(dt, mundo) end              -- por defecto: nada
function Entidad:alTocar(jugador, mundo) end        -- el jugador la toca
function Entidad:interactuar(jugador, mundo) end    -- el jugador presiona E

function Entidad:dibujar()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 4, 4)
end

-- Utilidades que TODAS las hijas heredan gratis.
function Entidad:centro()
  return self.x + self.w / 2, self.y + self.h / 2
end

function Entidad:distanciaA(otra)
  local ax, ay = self:centro()
  local bx, by = otra:centro()
  return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2)
end

-- Colisión AABB: ¿se solapan dos rectángulos?
function Entidad:toca(otra)
  return self.x < otra.x + otra.w and otra.x < self.x + self.w
     and self.y < otra.y + otra.h and otra.y < self.y + self.h
end

return Entidad

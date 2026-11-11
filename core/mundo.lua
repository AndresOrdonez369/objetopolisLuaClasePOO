-- MUNDO: el "director de orquesta". Guarda las entidades y las pone a trabajar.
-- Responsabilidad única (SRP): actualizar, detectar contactos y dibujar el juego.
-- Fíjate: el mundo NUNCA pregunta "¿eres una Moneda? ¿eres un Slime?".
-- Solo llama e:update(), e:alTocar(), e:dibujar(). Eso es POLIMORFISMO.

local fuentes = require("ui.fuentes")

local Mundo = {}
Mundo.__index = Mundo

function Mundo.new(barrios, limites)
  local self = setmetatable({}, Mundo)
  self.barrios   = barrios
  self.limites   = limites    -- rectángulo donde se puede caminar
  self.entidades = {}
  self.jugador   = nil
  return self
end

function Mundo:agregar(entidad)
  table.insert(self.entidades, entidad)
  return entidad
end

function Mundo:update(dt)
  local jugador = self.jugador
  jugador:update(dt, self)

  for _, e in ipairs(self.entidades) do
    e:update(dt, self)                                   -- cada quien sabe actualizarse
    if jugador:toca(e) then e:alTocar(jugador, self) end -- y sabe qué hacer si lo tocan
  end

  -- Retirar las entidades "muertas" (de atrás hacia adelante para no saltarse ninguna)
  for i = #self.entidades, 1, -1 do
    if self.entidades[i].muerta then table.remove(self.entidades, i) end
  end
end

-- La entidad más cercana al jugador (dentro de un radio).
function Mundo:masCercano(radio, soloInteractuables)
  local mejor, mejorDistancia = nil, radio
  for _, e in ipairs(self.entidades) do
    if e.interactuable or not soloInteractuables then
      local d = self.jugador:distanciaA(e)
      if d < mejorDistancia then mejor, mejorDistancia = e, d end
    end
  end
  return mejor
end

-- ¿En qué barrio está una entidad?
function Mundo:barrioDe(entidad)
  local cx, cy = entidad:centro()
  for _, b in ipairs(self.barrios) do
    if cx >= b.x and cx < b.x + b.w and cy >= b.y and cy < b.y + b.h then return b end
  end
  return self.barrios[1]
end

-- 'foco' = el objeto que el panel está explicando (se resalta en azul).
function Mundo:dibujar(foco)
  -- 1) el suelo: un rectángulo de color por barrio
  for _, b in ipairs(self.barrios) do
    love.graphics.setColor(b.color)
    love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
    love.graphics.setColor(1, 1, 1, 0.08)
    love.graphics.rectangle("line", b.x + 0.5, b.y + 0.5, b.w - 1, b.h - 1)
    love.graphics.setFont(fuentes.normal)
    love.graphics.setColor(1, 1, 1, 0.85)
    love.graphics.print(b.numero .. ". " .. b.nombre, b.x + 10, b.y + 8)
  end

  -- 2) las entidades: cada una se dibuja a SU manera
  love.graphics.setFont(fuentes.chica)
  for _, e in ipairs(self.entidades) do e:dibujar() end
  self.jugador:dibujar()

  -- 3) marco azul alrededor del objeto que explica el panel
  if foco and foco ~= self.jugador then
    local pulso = 0.5 + 0.3 * math.sin(love.timer.getTime() * 5)
    love.graphics.setColor(0.45, 0.8, 1, pulso)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", foco.x - 6, foco.y - 6, foco.w + 12, foco.h + 12, 6, 6)
    love.graphics.setLineWidth(1)
  end

  -- 4) el aviso "E" sobre lo que se puede usar
  local cerca = self:masCercano(70, true)
  if cerca then
    local cx = cerca.x + cerca.w / 2
    love.graphics.setColor(1, 1, 1, 0.95)
    love.graphics.circle("fill", cx, cerca.y - 16, 10)
    love.graphics.setColor(0.1, 0.1, 0.15)
    love.graphics.printf("E", cx - 10, cerca.y - 23, 20, "center")
  end
end

return Mundo

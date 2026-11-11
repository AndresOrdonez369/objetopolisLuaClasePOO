-- JUGADOR: tú. Un objeto recién instanciado con Jugador.new(...).
-- Usa HERENCIA (ES-UNA Entidad) y COMPOSICIÓN (TIENE-UNOS componentes).

local Entidad = require("entities.entidad")
local Eventos = require("core.eventos")

local Jugador = {}
Jugador.__index = Jugador
setmetatable(Jugador, { __index = Entidad })

Jugador.clase   = "Jugador"
Jugador.tipo    = "jugador"
Jugador.archivo = "entities/jugador.lua"

function Jugador.new(d)
  local self = Entidad.new(d)
  setmetatable(self, Jugador)
  self.w, self.h      = 26, 26
  self.color          = { 0.35, 0.8, 1 }
  self.velocidadBase  = 170
  self.velocidad      = self.velocidadBase
  self.componentes    = {}      -- COMPOSICIÓN: piezas que se le encajan
  self.llave          = nil
  self.empujeX, self.empujeY = 0, 0
  return self
end

-- Cualquier tabla con un método aplicar() sirve. Al jugador no le importa QUÉ es.
function Jugador:equipar(componente)
  table.insert(self.componentes, componente)
  Eventos.emit("componente_equipado", componente)
end

function Jugador:recibirLlave(id)   -- un método, en vez de que otros escriban jugador.llave
  self.llave = id
end

function Jugador:empujar(fx, fy)
  self.empujeX, self.empujeY = fx, fy
end

function Jugador:update(dt, mundo)
  -- 1) cada frame se parte de la velocidad base...
  self.velocidad = self.velocidadBase
  -- 2) ...y cada componente aplica su efecto (Botas, Imán...)
  for _, c in ipairs(self.componentes) do c:aplicar(self, dt, mundo) end

  -- 3) leer el teclado
  local tecla = love.keyboard.isDown
  local dx, dy = 0, 0
  if tecla("left", "a")  then dx = dx - 1 end
  if tecla("right", "d") then dx = dx + 1 end
  if tecla("up", "w")    then dy = dy - 1 end
  if tecla("down", "s")  then dy = dy + 1 end
  if dx ~= 0 and dy ~= 0 then dx, dy = dx * 0.707, dy * 0.707 end  -- diagonal justa

  -- 4) mover (+ el empujón de algún slime, que se va apagando)
  self.x = self.x + (dx * self.velocidad + self.empujeX) * dt
  self.y = self.y + (dy * self.velocidad + self.empujeY) * dt
  local freno = math.max(0, 1 - 8 * dt)
  self.empujeX, self.empujeY = self.empujeX * freno, self.empujeY * freno

  -- 5) no salirse del mapa
  local l = mundo.limites
  self.x = math.max(l.x, math.min(l.x + l.w - self.w, self.x))
  self.y = math.max(l.y, math.min(l.y + l.h - self.h, self.y))
end

function Jugador:dibujar()
  Entidad.dibujar(self)   -- primero el cuerpo, usando el dibujar() del PADRE
  love.graphics.setColor(0.1, 0.1, 0.15)
  love.graphics.rectangle("fill", self.x + 6, self.y + 7, 4, 7)    -- ojos
  love.graphics.rectangle("fill", self.x + 16, self.y + 7, 4, 7)
  for _, c in ipairs(self.componentes) do c:dibujar(self) end      -- cada pieza se dibuja sola
end

return Jugador

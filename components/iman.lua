-- IMÁN: otro COMPONENTE con el mismo contrato que las Botas.
-- Atrae todo lo que sea "atraible". No pregunta "¿eres una Moneda?":
-- le importa QUÉ haces, no QUIÉN eres. Mañana puede atraer gemas sin cambiar nada.

local Iman = {}
Iman.__index = Iman

function Iman.new()
  return setmetatable({ nombre = "Imán", color = { 0.8, 0.3, 1 }, radio = 150, fuerza = 260 }, Iman)
end

function Iman:aplicar(dueno, dt, mundo)
  local cx, cy = dueno:centro()
  for _, e in ipairs(mundo.entidades) do
    if e.atraible then
      local ex, ey = e:centro()
      local distancia = math.sqrt((cx - ex) ^ 2 + (cy - ey) ^ 2)
      if distancia < self.radio and distancia > 1 then
        e.x = e.x + (cx - ex) / distancia * self.fuerza * dt
        e.y = e.y + (cy - ey) / distancia * self.fuerza * dt
      end
    end
  end
end

function Iman:dibujar(dueno)
  local cx, cy = dueno:centro()
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.08)
  love.graphics.circle("fill", cx, cy, self.radio)
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.35)
  love.graphics.circle("line", cx, cy, self.radio)
end

return Iman

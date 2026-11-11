-- SLIME VELOZ: hijo de Slime, nieto de Entidad.
-- Cadena de búsqueda (__index): SlimeVeloz -> Slime -> Entidad
-- SOBRESCRIBE update(): hace lo del padre y además se pone nervioso.

local Slime = require("entities.slime")

local SlimeVeloz = {}
SlimeVeloz.__index = SlimeVeloz
setmetatable(SlimeVeloz, { __index = Slime })

SlimeVeloz.clase   = "SlimeVeloz"
SlimeVeloz.archivo = "entities/slime_veloz.lua"

function SlimeVeloz.new(d)
  local self = Slime.new(d)          -- reusa TODO el constructor del padre...
  setmetatable(self, SlimeVeloz)     -- ...y cambia de clase
  self.velocidad = 140               -- solo cambia lo que lo hace distinto
  self.color     = { 1, 0.6, 0.2 }
  return self
end

function SlimeVeloz:update(dt, mundo)
  Slime.update(self, dt, mundo)              -- 1) lo que hace el padre
  self.cambio = math.min(self.cambio, 0.4)   -- 2) lo extra: cambia de rumbo cada rato
end

return SlimeVeloz

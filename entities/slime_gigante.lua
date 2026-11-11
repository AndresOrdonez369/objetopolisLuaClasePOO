-- SLIME GIGANTE: otro hijo de Slime.
-- SOBRESCRIBE recibirGolpe(): recibe el golpe normal y además se encoge.

local Slime = require("entities.slime")

local SlimeGigante = {}
SlimeGigante.__index = SlimeGigante
setmetatable(SlimeGigante, { __index = Slime })

SlimeGigante.clase   = "SlimeGigante"
SlimeGigante.archivo = "entities/slime_gigante.lua"

function SlimeGigante.new(d)
  local self = Slime.new(d)
  setmetatable(self, SlimeGigante)
  self.w, self.h  = 56, 44
  self.vida       = 3
  self.velocidad  = 30
  self.color      = { 0.7, 0.4, 1 }
  return self
end

function SlimeGigante:recibirGolpe()
  Slime.recibirGolpe(self)                      -- 1) el golpe normal del padre
  self.w, self.h = self.w - 10, self.h - 8      -- 2) lo extra: se encoge
end

return SlimeGigante

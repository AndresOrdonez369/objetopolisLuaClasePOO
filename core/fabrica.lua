-- FÁBRICA: convierte DATOS (las tablas de data/mapa.lua) en OBJETOS.
--
-- ¿Quieres una clase nueva? 1) crea su archivo en entities/
--                            2) regístrala en CLASES
--                            3) úsala en data/mapa.lua
-- main.lua NO se toca. Abierto a extensión, cerrado a modificación (OCP).

local CLASES = {
  NPC          = require("entities.npc"),
  Pregonero    = require("entities.pregonero"),
  Moneda       = require("entities.moneda"),
  Slime        = require("entities.slime"),
  SlimeVeloz   = require("entities.slime_veloz"),
  SlimeGigante = require("entities.slime_gigante"),
  Llave        = require("entities.llave"),
  Cofre        = require("entities.cofre"),
  Cartel       = require("entities.cartel"),
  Lampara      = require("entities.lampara"),
  Fuente       = require("entities.fuente"),
  Pieza        = require("entities.pieza"),
  Campana      = require("entities.campana"),
  Puerta       = require("entities.puerta"),
}

local fabrica = {}

function fabrica.crear(d, barrio)
  local datos = {}
  for clave, valor in pairs(d) do datos[clave] = valor end  -- copia: no dañamos el original

  -- Las posiciones del mapa son relativas al barrio; aquí pasan a la pantalla.
  datos.x, datos.y = barrio.x + d.x, barrio.y + d.y
  datos.barrio     = barrio.id
  datos.zona       = barrio

  local Clase = CLASES[d.tipo] or error("Clase desconocida en el mapa: " .. tostring(d.tipo))
  return Clase.new(datos)
end

function fabrica.poblar(mundo, barrios)
  for _, barrio in ipairs(barrios) do
    for _, d in ipairs(barrio.entidades) do
      mundo:agregar(fabrica.crear(d, barrio))
    end
  end
end

return fabrica

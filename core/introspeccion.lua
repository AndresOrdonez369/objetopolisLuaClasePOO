-- INTROSPECCIÓN: funciones para que el juego se mire a sí mismo.
-- Las usan el panel, la consola y el pergamino para mostrar en vivo
-- cómo están hechos los objetos. Solo LEEN; nunca cambian nada.

local introspeccion = {}

-- La cadena de herencia: objeto -> su clase -> el padre -> el abuelo...
-- Es el camino EXACTO que recorre Lua con __index cuando busca algo.
function introspeccion.cadena(objeto)
  local clases = {}
  local clase = getmetatable(objeto)
  while clase do
    table.insert(clases, clase)
    local meta = getmetatable(clase)
    clase = meta and meta.__index
  end
  return clases
end

function introspeccion.nombreDe(clase)
  return rawget(clase, "clase") or "?"
end

function introspeccion.cadenaTexto(objeto)
  local nombres = {}
  for _, clase in ipairs(introspeccion.cadena(objeto)) do
    table.insert(nombres, introspeccion.nombreDe(clase))
  end
  return table.concat(nombres, " -> ")
end

-- ¿Dónde encuentra Lua un método? Ej: "SlimeVeloz (no) -> Slime (sí)"
function introspeccion.buscarMetodo(objeto, metodo)
  if rawget(objeto, metodo) then return "el propio objeto (sí)" end
  local pasos = {}
  for _, clase in ipairs(introspeccion.cadena(objeto)) do
    local tiene = rawget(clase, metodo) ~= nil
    table.insert(pasos, introspeccion.nombreDe(clase) .. (tiene and " (sí)" or " (no)"))
    if tiene then break end
  end
  return table.concat(pasos, " -> ")
end

-- La clase que realmente define un método (la primera de la cadena que lo tiene).
function introspeccion.claseQueDefine(objeto, metodo)
  for _, clase in ipairs(introspeccion.cadena(objeto)) do
    if rawget(clase, metodo) then return clase end
  end
end

-- Campos de INSTANCIA simples (números, textos, booleanos), ordenados.
function introspeccion.campos(objeto)
  local lista = {}
  for clave, valor in pairs(objeto) do
    local t = type(valor)
    if t == "number" or t == "string" or t == "boolean" then table.insert(lista, { clave, valor }) end
  end
  table.sort(lista, function(a, b) return a[1] < b[1] end)
  return lista
end

-- Funciones guardadas DENTRO del objeto (closures, como en el Cofre).
function introspeccion.funcionesDelObjeto(objeto)
  local lista = {}
  for clave, valor in pairs(objeto) do
    if type(valor) == "function" then table.insert(lista, clave .. "()") end
  end
  table.sort(lista)
  return lista
end

-- Métodos que define la clase misma (sin contar los heredados).
function introspeccion.metodosPropios(clase)
  local lista = {}
  for clave, valor in pairs(clase) do
    if type(valor) == "function" then table.insert(lista, clave .. "()") end
  end
  table.sort(lista)
  return lista
end

return introspeccion

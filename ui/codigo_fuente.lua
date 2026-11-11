-- CÓDIGO FUENTE: lee los archivos .lua del propio juego y encuentra funciones.
-- Así el panel puede mostrar el método REAL, no una copia que se desactualiza.

local codigo = {}
local cache = {}   -- cada archivo se lee una sola vez

function codigo.lineas(archivo)
  if not cache[archivo] then
    local texto = love.filesystem.read(archivo) or ("-- No encontré " .. archivo)
    local lineas = {}
    for linea in (texto .. "\n"):gmatch("(.-)\r?\n") do table.insert(lineas, linea) end
    cache[archivo] = lineas
  end
  return cache[archivo]
end

-- Devuelve inicio y fin (números de línea) de "function Clase:metodo(" o "Clase.metodo(",
-- incluyendo los comentarios que tenga justo encima.
function codigo.buscarFuncion(archivo, clase, metodo)
  local lineas = codigo.lineas(archivo)
  local patron = "^function%s+" .. clase .. "[%.:]" .. metodo .. "%s*%("
  for i, linea in ipairs(lineas) do
    if linea:find(patron) then
      local inicio, fin = i, i
      while inicio > 1 and lineas[inicio - 1]:find("^%-%-") do inicio = inicio - 1 end
      while fin < #lineas and not lineas[fin]:find("^end%s*$") do fin = fin + 1 end
      return inicio, fin
    end
  end
end

return codigo

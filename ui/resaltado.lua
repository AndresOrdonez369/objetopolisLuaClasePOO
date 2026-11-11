-- RESALTADO: colorea una línea de Lua como un editor de código.
-- Devuelve un "texto coloreado" de LÖVE: { color1, "trozo1", color2, "trozo2", ... }

local resaltado = {}

resaltado.colores = {
  texto      = { 0.88, 0.89, 0.93 },
  palabra    = { 0.98, 0.47, 0.70 },   -- local, function, return...
  cadena     = { 0.98, 0.80, 0.45 },   -- "textos"
  numero     = { 0.65, 0.80, 1.00 },
  comentario = { 0.45, 0.76, 0.45 },   -- -- comentarios
  self       = { 0.45, 0.85, 1.00 },
  clase      = { 0.45, 0.92, 0.80 },   -- Palabras con Mayúscula: Moneda, Entidad...
  llamada    = { 0.75, 0.70, 1.00 },   -- nombre( ... )
}
local C = resaltado.colores

local PALABRAS = {}
for p in ("local function end return if then else elseif for in do while not and or nil true false"):gmatch("%a+") do
  PALABRAS[p] = true
end

function resaltado.linea(linea)
  local out = {}
  local function agregar(color, trozo) out[#out + 1] = color; out[#out + 1] = trozo end
  local i, n = 1, #linea
  while i <= n do
    local c = linea:sub(i, i)
    if linea:sub(i, i + 1) == "--" then
      agregar(C.comentario, linea:sub(i)); break
    elseif c == '"' or c == "'" then
      local j = linea:find(c, i + 1, true) or n
      agregar(C.cadena, linea:sub(i, j)); i = j + 1
    elseif c:match("[%a_]") then
      local j = linea:find("[^%w_]", i) or n + 1
      local palabra = linea:sub(i, j - 1)
      local color = C.texto
      if PALABRAS[palabra] then color = C.palabra
      elseif palabra == "self" then color = C.self
      elseif linea:sub(j, j) == "(" then color = C.llamada
      elseif palabra:match("^%u") then color = C.clase end
      agregar(color, palabra); i = j
    elseif c:match("%d") then
      local j = linea:find("[^%d%.]", i) or n + 1
      agregar(C.numero, linea:sub(i, j - 1)); i = j
    else
      local j = linea:find("[%w_\"'%-]", i + 1) or n + 1
      agregar(C.texto, linea:sub(i, j - 1)); i = j
    end
  end
  if #out == 0 then agregar(C.texto, "") end
  return out
end

return resaltado

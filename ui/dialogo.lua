-- DIÁLOGO: la caja de conversación sobre el área de juego.
--   * retrato del personaje
--   * texto con efecto máquina de escribir; lo que va entre `comillas` se pinta como código
--   * recuadro de código opcional (páginas { texto = ..., codigo = ... })
-- Se abre cuando alguien emite "dialogo". Los NPC no saben cómo está hecha.

local utf8      = require("utf8")
local Eventos   = require("core.eventos")
local pantalla  = require("core.pantalla")
local resaltado = require("ui.resaltado")
local estilo    = require("ui.estilo")
local fuentes   = require("ui.fuentes")

local dialogo = { abierto = false, nombre = "", lineas = {}, pagina = 1, color = nil, letras = 0 }
local VELOCIDAD = 55   -- letras por segundo

local function paginaActual()
  local p = dialogo.lineas[dialogo.pagina]
  if type(p) == "string" then return p, nil end
  return p.texto, p.codigo
end

-- "Usa `Moneda.new()` así" -> { {"Usa ", false}, {"Moneda.new()", true}, {" así", false} }
local function trozos(texto)
  local lista, esCodigo = {}, false
  for parte in (texto .. "`"):gmatch("(.-)`") do
    table.insert(lista, { parte, esCodigo })
    esCodigo = not esCodigo
  end
  return lista
end

-- Texto coloreado mostrando solo las primeras 'n' letras (máquina de escribir)
local function textoVisible(texto, n)
  local salida = {}
  for _, t in ipairs(trozos(texto)) do
    local parte, largo = t[1], utf8.len(t[1])
    if n < largo then parte = parte:sub(1, utf8.offset(parte, n + 1) - 1) end
    table.insert(salida, t[2] and resaltado.colores.clase or estilo.blanco)
    table.insert(salida, parte)
    n = math.max(0, n - largo)
  end
  return salida
end

local function largoTotal()
  local texto = paginaActual()
  return utf8.len((texto:gsub("`", "")))
end

function dialogo.iniciar()
  Eventos.on("dialogo", function(nombre, lineas, color)
    dialogo.abierto, dialogo.nombre, dialogo.lineas = true, nombre, lineas
    dialogo.pagina, dialogo.color, dialogo.letras = 1, color, 0
  end)
end

function dialogo.update(dt)
  if dialogo.abierto then dialogo.letras = dialogo.letras + dt * VELOCIDAD end
end

function dialogo.tecla(tecla)
  if tecla == "e" or tecla == "space" or tecla == "return" then
    if dialogo.letras < largoTotal() then          -- 1er toque: termina de escribir
      dialogo.letras = largoTotal()
    else                                           -- 2do toque: siguiente página
      dialogo.pagina, dialogo.letras = dialogo.pagina + 1, 0
      if dialogo.pagina > #dialogo.lineas then dialogo.abierto = false end
    end
  elseif tecla == "escape" then
    dialogo.abierto = false
  end
end

local function retrato(x, y, color)
  estilo.color({ 0.14, 0.15, 0.19 })
  love.graphics.rectangle("fill", x, y, 110, 120, 10, 10)
  if color then                                   -- una persona
    estilo.color(color)
    love.graphics.rectangle("fill", x + 25, y + 58, 60, 62, 14, 14)
    love.graphics.circle("fill", x + 55, y + 40, 24)
    estilo.color({ 0.1, 0.1, 0.15 })
    love.graphics.circle("fill", x + 46, y + 38, 4)
    love.graphics.circle("fill", x + 64, y + 38, 4)
  else                                            -- un cartel o una puerta
    estilo.color({ 0.85, 0.7, 0.45 })
    love.graphics.rectangle("fill", x + 20, y + 25, 70, 45, 6, 6)
    estilo.color({ 0.45, 0.3, 0.15 })
    love.graphics.rectangle("fill", x + 51, y + 70, 8, 40)
  end
end

function dialogo.dibujar()
  if not dialogo.abierto then return end
  local j = pantalla.juego
  local texto, codigo = paginaActual()
  local lineasCodigo = {}
  if codigo then for l in (codigo .. "\n"):gmatch("(.-)\n") do table.insert(lineasCodigo, l) end end

  local h = 170 + (codigo and (#lineasCodigo * 19 + 24) or 0)
  local x, y, w = j.x + 16, j.y + j.h - h - 12, j.w - 32

  estilo.color({ 0.04, 0.045, 0.06 }, 0.96)
  love.graphics.rectangle("fill", x, y, w, h, 12, 12)
  estilo.color(dialogo.color or estilo.oro, 0.9)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", x, y, w, h, 12, 12)
  love.graphics.setLineWidth(1)

  retrato(x + 18, y + 22, dialogo.color)
  local tx, tw = x + 148, w - 170
  love.graphics.setFont(fuentes.media)
  estilo.color(dialogo.color or estilo.oro)
  love.graphics.print(dialogo.nombre, tx, y + 18)

  love.graphics.setFont(fuentes.media)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(textoVisible(texto, math.floor(dialogo.letras)), tx, y + 52, tw)

  local escrito = dialogo.letras >= largoTotal()
  if codigo and escrito then                       -- el código aparece al terminar el texto
    local cy = y + 150
    estilo.color({ 0.08, 0.09, 0.12 })
    love.graphics.rectangle("fill", tx, cy, tw, #lineasCodigo * 19 + 14, 6, 6)
    estilo.color(estilo.hecho)
    love.graphics.rectangle("fill", tx, cy + 4, 3, #lineasCodigo * 19 + 6)
    love.graphics.setFont(fuentes.codigoG)
    love.graphics.setColor(1, 1, 1)
    for i, linea in ipairs(lineasCodigo) do
      love.graphics.print(resaltado.linea(linea), tx + 14, cy + 6 + (i - 1) * 19)
    end
  end

  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  local pista = escrito and "E para continuar" or "E para terminar de leer"
  love.graphics.printf(dialogo.pagina .. " / " .. #dialogo.lineas .. "     " .. pista, x, y + h - 24, w - 20, "right")
end

return dialogo

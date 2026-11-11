-- ESTILO: colores y piezas de dibujo que comparten todas las pantallas.
-- Un solo lugar para el "look" del juego: si cambias un color aquí, cambia en todas partes.

local fuentes = require("ui.fuentes")

local estilo = {
  fondo     = { 0.06, 0.065, 0.085 },
  superficie = { 0.10, 0.11, 0.14 },
  borde     = { 1, 1, 1, 0.08 },
  tenue     = { 0.62, 0.64, 0.70 },
  blanco    = { 0.94, 0.95, 0.97 },
  oro       = { 1.00, 0.84, 0.25 },
  viendo    = { 0.45, 0.80, 1.00 },   -- 1) QUÉ ESTÁS VIENDO
  aprendo   = { 1.00, 0.78, 0.30 },   -- 2) QUÉ ESTÁS APRENDIENDO
  hecho     = { 0.50, 0.88, 0.55 },   -- 3) CÓMO ESTÁ HECHO
  consola   = { 0.80, 0.60, 1.00 },
}

function estilo.color(c, alfa)
  love.graphics.setColor(c[1], c[2], c[3], alfa or c[4] or 1)
end

-- Tarjeta con una franja de color a la izquierda y un rótulo arriba.
function estilo.tarjeta(x, y, w, h, color, rotulo)
  estilo.color(estilo.superficie)
  love.graphics.rectangle("fill", x, y, w, h, 8, 8)
  estilo.color(color)
  love.graphics.rectangle("fill", x, y + 8, 4, h - 16, 2, 2)
  if rotulo then
    love.graphics.setFont(fuentes.mini)
    estilo.color(color)
    love.graphics.print(rotulo, x + 16, y + 10)
  end
end

-- Una "pastilla" de texto (chip). Devuelve el ancho para poner otra al lado.
function estilo.chip(texto, x, y, color, fuente)
  fuente = fuente or fuentes.chica
  local w = fuente:getWidth(texto) + 16
  estilo.color(color, 0.18)
  love.graphics.rectangle("fill", x, y, w, fuente:getHeight() + 6, 9, 9)
  estilo.color(color)
  love.graphics.setFont(fuente)
  love.graphics.print(texto, x + 8, y + 3)
  return w
end

-- Párrafo con ajuste de línea. Devuelve la 'y' donde termina.
function estilo.parrafo(texto, x, y, w, fuente, color)
  love.graphics.setFont(fuente)
  estilo.color(color)
  love.graphics.printf(texto, x, y, w)
  local _, lineas = fuente:getWrap(texto, w)
  return y + #lineas * fuente:getHeight()
end

return estilo

-- PANTALLA: todo se dibuja en un lienzo "virtual" de 1600x900 y se escala
-- a la ventana real (portátil, monitor o proyector) sin deformarse.
--
-- Distribución (las 3 zonas están SEPARADAS a propósito):
--   +------------------------------+-------------+
--   |  BARRA SUPERIOR (sellos, oro)               |
--   +------------------------------+-------------+
--   |  JUEGO   (1152 x 608)        |   PANEL     |
--   |                              |  1 viendo   |
--   +------------------------------+  2 aprendo  |
--   |  CONSOLA EN VIVO             |  3 código   |
--   +------------------------------+-------------+

local pantalla = {
  ancho = 1600, alto = 900,
  juego   = { x = 0,    y = 44,  w = 1152, h = 608 },
  panel   = { x = 1152, y = 44,  w = 448,  h = 856 },
  consola = { x = 0,    y = 652, w = 1152, h = 248 },
  escala = 1, ox = 0, oy = 0,
}

function pantalla.ajustar()
  local w, h = love.graphics.getDimensions()
  pantalla.escala = math.min(w / pantalla.ancho, h / pantalla.alto)
  pantalla.ox = math.floor((w - pantalla.ancho * pantalla.escala) / 2)
  pantalla.oy = math.floor((h - pantalla.alto * pantalla.escala) / 2)
end

function pantalla.iniciar()
  local dw, dh = love.window.getDesktopDimensions()
  if dw < 1640 or dh < 980 then   -- pantalla pequeña: ventana al 90 %
    local w = math.floor(math.min(dw * 0.9, (dh * 0.85) * 16 / 9))
    love.window.setMode(w, math.floor(w * 9 / 16), { resizable = true, minwidth = 800, minheight = 450 })
  end
  pantalla.ajustar()
end

function pantalla.comenzar()
  love.graphics.push()
  love.graphics.translate(pantalla.ox, pantalla.oy)
  love.graphics.scale(pantalla.escala)
end

function pantalla.terminar()
  love.graphics.pop()
end

-- MODO CLASE (con panel y consola) o MODO JUEGO (solo el mapa, más grande). Tecla H.
pantalla.modoClase = true

function pantalla.alternarModo()
  pantalla.modoClase = not pantalla.modoClase
end

-- En modo juego, el área de juego se agranda para ocupar todo el espacio.
function pantalla.comenzarJuego()
  love.graphics.push()
  if not pantalla.modoClase then
    local j = pantalla.juego
    local libreW, libreH = pantalla.ancho, pantalla.alto - j.y
    local e = math.min(libreW / j.w, libreH / j.h)
    love.graphics.translate((libreW - j.w * e) / 2, j.y + (libreH - j.h * e) / 2)
    love.graphics.scale(e)
    love.graphics.translate(-j.x, -j.y)
  end
end

function pantalla.terminarJuego()
  love.graphics.pop()
end

-- setScissor trabaja en píxeles REALES; esto convierte desde coordenadas virtuales.
function pantalla.recortar(x, y, w, h)
  if not x then return love.graphics.setScissor() end
  local e = pantalla.escala
  love.graphics.setScissor(pantalla.ox + x * e, pantalla.oy + y * e, w * e, h * e)
end

function pantalla.alternarCompleta()
  love.window.setFullscreen(not love.window.getFullscreen())
  pantalla.ajustar()
end

return pantalla

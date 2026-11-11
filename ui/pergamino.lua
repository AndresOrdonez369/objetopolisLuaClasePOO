-- PERGAMINO (tecla TAB): el archivo .lua COMPLETO del objeto que tienes cerca,
-- abierto justo en el método que explica el panel (resaltado en verde).
-- El juego se explica a sí mismo: lo que ves en pantalla es lo que está escrito.

local introspeccion = require("core.introspeccion")
local pantalla      = require("core.pantalla")
local codigoFuente  = require("ui.codigo_fuente")
local resaltado     = require("ui.resaltado")
local estilo        = require("ui.estilo")
local fuentes       = require("ui.fuentes")

local pergamino = { abierto = false, lineas = {}, scroll = 0, titulo = "", cadena = "", desde = 0, hasta = -1 }
local VISIBLES, ALTO = 36, 19

function pergamino.desplazar(cuanto)
  local maximo = math.max(0, #pergamino.lineas - VISIBLES)
  pergamino.scroll = math.max(0, math.min(maximo, pergamino.scroll + cuanto))
end

function pergamino.abrir(objeto, metodo)
  pergamino.lineas  = codigoFuente.lineas(objeto.archivo)
  pergamino.titulo  = objeto.archivo
  pergamino.cadena  = introspeccion.cadenaTexto(objeto)
  pergamino.desde, pergamino.hasta = 0, -1
  pergamino.scroll  = 0
  local inicio, fin = codigoFuente.buscarFuncion(objeto.archivo, objeto.clase, metodo or "new")
  if inicio then
    pergamino.desde, pergamino.hasta = inicio, fin
    pergamino.desplazar(inicio - 4)
  end
  pergamino.abierto = true
end

function pergamino.tecla(tecla)
  if tecla == "tab" or tecla == "escape" then pergamino.abierto = false
  elseif tecla == "down" or tecla == "s" then pergamino.desplazar(1)
  elseif tecla == "up" or tecla == "w" then pergamino.desplazar(-1)
  elseif tecla == "pagedown" or tecla == "space" then pergamino.desplazar(VISIBLES)
  elseif tecla == "pageup" then pergamino.desplazar(-VISIBLES)
  end
end

function pergamino.dibujar()
  if not pergamino.abierto then return end
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle("fill", 0, 0, pantalla.ancho, pantalla.alto)
  local x, y, w, h = 80, 40, pantalla.ancho - 160, pantalla.alto - 80
  estilo.color({ 0.05, 0.055, 0.075 })
  love.graphics.rectangle("fill", x, y, w, h, 12, 12)
  estilo.color(estilo.hecho)
  love.graphics.rectangle("line", x, y, w, h, 12, 12)

  love.graphics.setFont(fuentes.media)
  estilo.color(estilo.blanco)
  love.graphics.print(pergamino.titulo, x + 24, y + 14)
  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.viendo)
  love.graphics.print("Cadena __index:  " .. pergamino.cadena, x + 24, y + 44)

  local cy = y + 78
  pantalla.recortar(x + 10, cy - 2, w - 20, VISIBLES * ALTO + 4)
  love.graphics.setFont(fuentes.codigoG)
  for i = 1, VISIBLES do
    local n = i + pergamino.scroll
    local linea = pergamino.lineas[n]
    if not linea then break end
    local ly = cy + (i - 1) * ALTO
    if n >= pergamino.desde and n <= pergamino.hasta then   -- el método del panel
      estilo.color(estilo.hecho, 0.12)
      love.graphics.rectangle("fill", x + 12, ly - 1, w - 24, ALTO)
    end
    estilo.color(estilo.tenue, 0.6)
    love.graphics.printf(n, x + 10, ly, 36, "right")
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(resaltado.linea(linea), x + 60, ly)
  end
  pantalla.recortar()

  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  love.graphics.printf("Flechas / rueda: desplazar      TAB: volver al juego", x, y + h - 26, w - 24, "right")
end

return pergamino

-- PANEL (derecha): explica EN VIVO lo que tienes cerca, en tres tarjetas.
--   1) QUÉ ESTÁS VIENDO      -> el objeto, su familia y sus datos clave (self)
--   2) QUÉ ESTÁS APRENDIENDO -> el concepto del barrio y el avance de la misión
--   3) CÓMO ESTÁ HECHO       -> UN método real, leído del archivo .lua
-- Solo LEE el juego: si borras este archivo, el juego sigue funcionando.

local Eventos       = require("core.eventos")
local introspeccion = require("core.introspeccion")
local pantalla      = require("core.pantalla")
local guia          = require("data.guia")
local MISIONES      = require("data.misiones")
local codigoFuente  = require("ui.codigo_fuente")
local resaltado     = require("ui.resaltado")
local estilo        = require("ui.estilo")
local fuentes       = require("ui.fuentes")

local panel = { avance = {} }   -- avance["Herencia"] = 2

function panel.iniciar()
  Eventos.on("progreso", function(sello, cuenta) panel.avance[sello] = cuenta end)
  Eventos.on("sello_obtenido", function(sello) panel.avance[sello] = "hecho" end)
end

local function infoDe(foco)
  return guia.clases[foco.clase] or { metodo = "new", campos = {}, viendo = "" }
end

-- 1) QUÉ ESTÁS VIENDO --------------------------------------------------------
local function tarjetaViendo(foco, x, y, w)
  local h = 210
  estilo.tarjeta(x, y, w, h, estilo.viendo, "1  QUÉ ESTÁS VIENDO")
  local ix, iw = x + 18, w - 34
  local info = infoDe(foco)

  love.graphics.setFont(fuentes.grande)
  estilo.color(estilo.blanco)
  love.graphics.print(foco.clase, ix, y + 26)

  -- Su familia (cadena __index) en una línea: Moneda -> Entidad
  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.viendo)
  love.graphics.print("familia:  " .. introspeccion.cadenaTexto(foco), ix, y + 66)

  local cy = estilo.parrafo(info.viendo, ix, y + 88, iw, fuentes.texto, estilo.blanco) + 10

  -- Solo los datos que importan para ESTE concepto
  love.graphics.setFont(fuentes.codigoG)
  for _, campo in ipairs(info.campos) do
    local valor = foco[campo]
    if type(valor) == "number" then valor = math.floor(valor + 0.5) end
    love.graphics.print({ resaltado.colores.self, "self." .. campo, estilo.tenue, "  =  ",
                          estilo.blanco, tostring(valor) }, ix, cy)
    cy = cy + 21
  end
  return y + h
end

-- 2) QUÉ ESTÁS APRENDIENDO ---------------------------------------------------
local function tarjetaAprendiendo(barrio, x, y, w)
  local h = 170
  estilo.tarjeta(x, y, w, h, estilo.aprendo, "2  QUÉ ESTÁS APRENDIENDO")
  local ix, iw = x + 18, w - 34
  local info = guia.barrios[barrio.id]

  love.graphics.setFont(fuentes.media)
  estilo.color(estilo.aprendo)
  love.graphics.print(info.titulo, ix, y + 26)
  local cy = estilo.parrafo(info.idea, ix, y + 54, iw, fuentes.texto, estilo.blanco) + 4
  estilo.parrafo(info.analogia, ix, cy, iw, fuentes.chica, estilo.tenue)

  -- Barra de avance de la misión del barrio
  local mision
  for _, m in ipairs(MISIONES) do if m.barrio == barrio.id then mision = m end end
  local avance = panel.avance[mision.sello] or 0
  local hecho = avance == "hecho"
  local fraccion = hecho and 1 or avance / mision.meta
  local by = y + h - 34
  estilo.color({ 0.2, 0.21, 0.26 })
  love.graphics.rectangle("fill", ix, by + 16, iw, 8, 4, 4)
  estilo.color(hecho and estilo.hecho or estilo.aprendo)
  love.graphics.rectangle("fill", ix, by + 16, iw * fraccion, 8, 4, 4)
  love.graphics.setFont(fuentes.chica)
  love.graphics.print(hecho and ("¡Sello " .. mision.sello .. " conseguido!") or ("Misión: " .. info.mision), ix, by - 2)
  if not hecho then
    love.graphics.printf(avance .. " / " .. mision.meta, ix, by - 2, iw, "right")
  end
  return y + h
end

-- 3) CÓMO ESTÁ HECHO ---------------------------------------------------------
local function tarjetaCodigo(foco, x, y, w, h)
  estilo.tarjeta(x, y, w, h, estilo.hecho, "3  CÓMO ESTÁ HECHO")
  local ix = x + 18
  local metodo = infoDe(foco).metodo
  local lineas = codigoFuente.lineas(foco.archivo)
  local inicio, fin = codigoFuente.buscarFuncion(foco.archivo, foco.clase, metodo)

  local firma = foco.clase .. (metodo == "new" and ".new()" or (":" .. metodo .. "()"))
  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.blanco)
  love.graphics.print(firma, ix, y + 26)
  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  love.graphics.print(foco.archivo, ix, y + 48)
  if not inicio then return end

  local alto = 20
  local filas = math.floor((h - 100) / alto)
  pantalla.recortar(x + 6, y + 72, w - 12, h - 96)
  love.graphics.setFont(fuentes.codigoG)
  for n = inicio, math.min(fin, inicio + filas - 1) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(resaltado.linea(lineas[n]), ix, y + 76 + (n - inicio) * alto)
  end
  pantalla.recortar()

  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  love.graphics.printf("TAB: ver el archivo completo", ix, y + h - 24, w - 34, "right")
end

function panel.dibujar(foco, barrio)
  local z = pantalla.panel
  estilo.color(estilo.fondo)
  love.graphics.rectangle("fill", z.x, z.y, z.w, z.h)
  local x, w = z.x + 10, z.w - 20

  -- Cabecera: en qué barrio estás
  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  love.graphics.print("BARRIO " .. barrio.numero, x + 6, z.y + 10)
  love.graphics.setFont(fuentes.media)
  estilo.color(estilo.blanco)
  love.graphics.print(barrio.nombre, x + 6, z.y + 26)

  local y = z.y + 62
  y = tarjetaViendo(foco, x, y, w) + 10
  y = tarjetaAprendiendo(barrio, x, y, w) + 10
  tarjetaCodigo(foco, x, y, w, z.y + z.h - y - 10)
end

-- El pergamino usa esto para abrir el archivo en el mismo método.
function panel.metodoDe(foco)
  return infoDe(foco).metodo
end

return panel

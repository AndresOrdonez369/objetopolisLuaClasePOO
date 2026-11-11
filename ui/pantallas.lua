-- PANTALLAS: el título (con un mapa de las 3 zonas) y la revelación final.

local introspeccion = require("core.introspeccion")
local pantalla      = require("core.pantalla")
local MISIONES      = require("data.misiones")
local resaltado     = require("ui.resaltado")
local estilo        = require("ui.estilo")
local fuentes       = require("ui.fuentes")

local pantallas = {}

local function zona(z, color, titulo, texto)
  estilo.color(estilo.fondo)
  love.graphics.rectangle("fill", z.x + 6, z.y + 6, z.w - 12, z.h - 12, 10, 10)
  estilo.color(color, 0.12)
  love.graphics.rectangle("fill", z.x + 6, z.y + 6, z.w - 12, z.h - 12, 10, 10)
  estilo.color(color)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", z.x + 6, z.y + 6, z.w - 12, z.h - 12, 10, 10)
  love.graphics.setLineWidth(1)
  love.graphics.setFont(fuentes.media)
  love.graphics.print(titulo, z.x + 24, z.y + 20)
  estilo.parrafo(texto, z.x + 24, z.y + 50, z.w - 48, fuentes.texto, estilo.blanco)
end

function pantallas.titulo()
  love.graphics.setColor(0.03, 0.03, 0.05, 0.93)
  love.graphics.rectangle("fill", 0, 0, pantalla.ancho, pantalla.alto)

  local p = pantalla.panel
  zona(pantalla.consola, estilo.consola, "CONSOLA EN VIVO",
       "La línea de código que se acaba de ejecutar.")
  zona(p, estilo.viendo, "PANEL",
       "1  Qué estás viendo\n\n2  Qué estás aprendiendo\n\n3  Cómo está hecho\n\n\nH oculta los paneles.")

  local j = pantalla.juego
  love.graphics.setFont(fuentes.titulo)
  estilo.color(estilo.oro)
  love.graphics.printf("OBJETÓPOLIS", j.x, j.y + 110, j.w, "center")
  love.graphics.setFont(fuentes.media)
  estilo.color(estilo.blanco)
  love.graphics.printf("Acabas de ser instanciado. No sabes qué eres.", j.x, j.y + 200, j.w, "center")
  estilo.color(estilo.blanco, 0.7)
  love.graphics.printf("Recorre los 6 barrios, aprende de sus maestros, gana sus sellos\n" ..
                       "y vuelve a la Puerta del Arquitecto para descubrir quién eres.", j.x, j.y + 240, j.w, "center")
  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.viendo)
  love.graphics.printf("WASD / flechas: moverte      E: usar / hablar      TAB: ver código      F11: pantalla completa",
                       j.x, j.y + 340, j.w, "center")
  local alfa = 0.5 + 0.5 * math.sin(love.timer.getTime() * 3)
  love.graphics.setFont(fuentes.grande)
  estilo.color(estilo.blanco, alfa)
  love.graphics.printf("ENTER para nacer", j.x, j.y + 430, j.w, "center")
end

function pantallas.final(jugador, oro)
  love.graphics.setColor(0.03, 0.03, 0.05, 0.985)
  love.graphics.rectangle("fill", 0, 0, pantalla.ancho, pantalla.alto)
  love.graphics.setFont(fuentes.titulo)
  estilo.color(estilo.oro)
  love.graphics.printf("¡Eres un objeto!", 0, 60, pantalla.ancho, "center")

  local nombres = {}
  for _, c in ipairs(jugador.componentes) do table.insert(nombres, c.nombre) end
  local codigo = {
    "local tu = Jugador.new({ x = 40, y = 210 })",
    "-- cadena __index:  " .. introspeccion.cadenaTexto(jugador),
    "-- tu estado:       velocidadBase = " .. jugador.velocidadBase .. ", llave = " .. tostring(jugador.llave),
    "-- tus componentes: " .. (#nombres > 0 and table.concat(nombres, ", ") or "ninguno"),
    "-- oro reunido:     " .. oro .. "  (lo contó el HUD escuchando eventos)",
  }
  estilo.color({ 0.08, 0.09, 0.12 })
  love.graphics.rectangle("fill", 330, 170, 940, 140, 10, 10)
  love.graphics.setFont(fuentes.codigoG)
  love.graphics.setColor(1, 1, 1)
  for i, linea in ipairs(codigo) do love.graphics.print(resaltado.linea(linea), 356, 184 + (i - 1) * 24) end

  for i, m in ipairs(MISIONES) do
    local y = 350 + i * 56
    estilo.color(estilo.oro)
    love.graphics.circle("fill", 350, y + 11, 13)
    love.graphics.setFont(fuentes.normal)
    estilo.color({ 0.1, 0.08, 0.02 })
    love.graphics.printf(i, 337, y + 1, 26, "center")
    estilo.color(estilo.oro)
    love.graphics.print(m.sello, 380, y)
    estilo.color(estilo.blanco, 0.9)
    love.graphics.print(m.frase, 600, y)
  end
  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.tenue)
  love.graphics.printf("R para volver a instanciarte      Esc para salir", 0, 850, pantalla.ancho, "center")
end

return pantallas

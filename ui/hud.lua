-- HUD: el marcador del estadio. Nadie le habla directamente:
-- él ESCUCHA eventos y actualiza lo que muestra.
--   * barra superior con los 6 sellos y el oro
--   * avisos (tarjetas que entran por la derecha del juego)
--   * gran anuncio al ganar un sello, con confeti

local Eventos  = require("core.eventos")
local pantalla = require("core.pantalla")
local MISIONES = require("data.misiones")
local estilo   = require("ui.estilo")
local fuentes  = require("ui.fuentes")

local hud = { oro = 0, sellos = {}, avisos = {}, anuncio = nil, confeti = {} }

-- Un aviso: { texto, color, tiempo }
function hud.avisar(texto, color)
  table.insert(hud.avisos, { texto = texto, color = color or estilo.blanco, tiempo = 3, entrada = 0 })
  if #hud.avisos > 3 then table.remove(hud.avisos, 1) end
end

local function fraseDe(sello)
  for _, m in ipairs(MISIONES) do if m.sello == sello then return m.frase end end
  return ""
end

local function celebrar(sello)
  hud.anuncio = { sello = sello, frase = fraseDe(sello), tiempo = 3.5 }
  local j = pantalla.juego
  for _ = 1, 70 do
    table.insert(hud.confeti, {
      x = j.x + j.w / 2, y = j.y + j.h / 2 - 40,
      vx = (math.random() - 0.5) * 700, vy = -math.random() * 500 - 100,
      color = { math.random(), math.random() * 0.5 + 0.5, math.random() * 0.5 + 0.3 },
      vida = 1.6 + math.random(),
    })
  end
end

function hud.iniciar()
  Eventos.on("moneda_recogida", function(m) hud.oro = hud.oro + m.valor end)
  Eventos.on("cofre_abierto", function(_, botin)
    hud.oro = hud.oro + botin
    hud.avisar("+" .. botin .. " de oro: solo el método abrir() pudo sacarlo", estilo.oro)
  end)
  Eventos.on("cofre_cerrado", function() hud.avisar("El cofre está cerrado. Necesitas la llave.", estilo.tenue) end)
  Eventos.on("sello_obtenido", function(sello) hud.sellos[sello] = true; celebrar(sello) end)
  Eventos.on("componente_equipado", function(c) hud.avisar("Equipaste: " .. c.nombre, estilo.hecho) end)
  Eventos.on("llave_recogida", function() hud.avisar("Recogiste la llave de La Bóveda", estilo.oro) end)
  Eventos.on("aviso", function(texto) hud.avisar(texto) end)
end

function hud.update(dt)
  for i = #hud.avisos, 1, -1 do
    local a = hud.avisos[i]
    a.tiempo, a.entrada = a.tiempo - dt, math.min(1, a.entrada + dt * 5)
    if a.tiempo <= 0 then table.remove(hud.avisos, i) end
  end
  if hud.anuncio then
    hud.anuncio.tiempo = hud.anuncio.tiempo - dt
    if hud.anuncio.tiempo <= 0 then hud.anuncio = nil end
  end
  for i = #hud.confeti, 1, -1 do
    local c = hud.confeti[i]
    c.vy = c.vy + 900 * dt
    c.x, c.y, c.vida = c.x + c.vx * dt, c.y + c.vy * dt, c.vida - dt
    if c.vida <= 0 then table.remove(hud.confeti, i) end
  end
end

local function barraSuperior()
  estilo.color({ 0.035, 0.04, 0.055 })
  love.graphics.rectangle("fill", 0, 0, pantalla.ancho, 44)
  love.graphics.setFont(fuentes.media)
  estilo.color(estilo.oro)
  love.graphics.print("OBJETÓPOLIS", 16, 10)

  local x = 190
  for i, m in ipairs(MISIONES) do
    local tiene = hud.sellos[m.sello]
    estilo.color(tiene and estilo.oro or { 0.22, 0.23, 0.28 })
    love.graphics.circle("fill", x + 11, 22, 11)
    love.graphics.setFont(fuentes.chica)
    estilo.color(tiene and { 0.1, 0.08, 0.02 } or estilo.tenue)
    love.graphics.printf(i, x, 15, 22, "center")
    estilo.color(estilo.blanco, tiene and 1 or 0.45)
    love.graphics.print(m.sello, x + 28, 15)
    x = x + 40 + fuentes.chica:getWidth(m.sello)
  end

  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.oro)
  love.graphics.print("Oro: " .. hud.oro, 1000, 12)
  love.graphics.setFont(fuentes.chica)
  estilo.color(estilo.tenue)
  love.graphics.printf("WASD mover  ·  E usar  ·  TAB código  ·  H ocultar paneles  ·  F11", 0, 15, pantalla.ancho - 16, "right")
end

local function avisos()
  local j = pantalla.juego
  for i, a in ipairs(hud.avisos) do
    local w, h = 360, 34
    local x = j.x + j.w - (w + 12) * a.entrada
    local y = j.y + 50 + (i - 1) * (h + 6)
    local alfa = math.min(1, a.tiempo * 2)
    estilo.color({ 0.05, 0.055, 0.075 }, 0.92 * alfa)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)
    estilo.color(a.color, alfa)
    love.graphics.rectangle("fill", x, y + 6, 4, h - 12, 2, 2)
    love.graphics.setFont(fuentes.texto)
    love.graphics.printf(a.texto, x + 14, y + 8, w - 20)
  end
end

local function anuncioDeSello()
  local a = hud.anuncio
  if not a then return end
  local j = pantalla.juego
  local t = 3.5 - a.tiempo
  local escala = math.min(1, t * 6) * (1 + 0.08 * math.max(0, 1 - t * 3))  -- "pop"
  local alfa = math.min(1, a.tiempo * 2)
  love.graphics.push()
  love.graphics.translate(j.x + j.w / 2, j.y + j.h / 2 - 20)
  love.graphics.scale(escala)
  estilo.color({ 0.05, 0.05, 0.07 }, 0.94 * alfa)
  love.graphics.rectangle("fill", -330, -80, 660, 160, 14, 14)
  estilo.color(estilo.oro, alfa)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", -330, -80, 660, 160, 14, 14)
  love.graphics.setLineWidth(1)
  love.graphics.setFont(fuentes.chica)
  love.graphics.printf("SELLO OBTENIDO", -330, -64, 660, "center")
  love.graphics.setFont(fuentes.grande)
  love.graphics.printf(a.sello, -330, -44, 660, "center")
  love.graphics.setFont(fuentes.normal)
  estilo.color(estilo.blanco, alfa)
  love.graphics.printf('"' .. a.frase .. '"', -310, 8, 620, "center")
  love.graphics.pop()
end

-- Lo que va sobre el área de juego (avisos, anuncio, confeti)
function hud.dibujarSobreJuego()
  avisos()
  anuncioDeSello()
  for _, c in ipairs(hud.confeti) do
    love.graphics.setColor(c.color[1], c.color[2], c.color[3], math.min(1, c.vida))
    love.graphics.rectangle("fill", c.x, c.y, 6, 4)
  end
end

function hud.dibujarBarra()
  barraSuperior()
end

return hud

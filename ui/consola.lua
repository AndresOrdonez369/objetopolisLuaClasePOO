-- CONSOLA EN VIVO (abajo): las últimas 3 cosas que hizo el código.
-- Cada fila: el evento, la línea que se ejecutó y qué significa.
-- Escucha TODOS los eventos con "*". Nadie le avisa directamente.

local Eventos   = require("core.eventos")
local pantalla  = require("core.pantalla")
local guia      = require("data.guia")
local resaltado = require("ui.resaltado")
local estilo    = require("ui.estilo")
local fuentes   = require("ui.fuentes")

local consola = { entradas = {} }
local MAX = 3

function consola.iniciar()
  Eventos.on("*", function(nombre, ...)
    local explicar = guia.eventos[nombre]
    if not explicar then return end                 -- eventos sin explicación: se ignoran
    local codigo, explica = explicar(...)
    local oyentes = Eventos.cuantos(nombre)
    table.insert(consola.entradas, 1, {
      evento = nombre, codigo = codigo, brillo = 1,
      explica = explica .. "   (" .. oyentes .. (oyentes == 1 and " oyente)" or " oyentes)"),
    })
    if #consola.entradas > MAX then table.remove(consola.entradas) end
  end)
end

function consola.update(dt)
  for _, e in ipairs(consola.entradas) do e.brillo = math.max(0, e.brillo - dt) end
end

function consola.dibujar()
  local z = pantalla.consola
  estilo.color(estilo.fondo)
  love.graphics.rectangle("fill", z.x, z.y, z.w, z.h)
  estilo.tarjeta(z.x + 10, z.y + 8, z.w - 20, z.h - 16, estilo.consola, "CONSOLA EN VIVO  ·  lo que el código acaba de hacer")

  if #consola.entradas == 0 then
    estilo.parrafo("Aún no pasa nada. Recoge una moneda o presiona E cerca de algo.",
                   z.x + 28, z.y + 50, z.w - 60, fuentes.texto, estilo.tenue)
    return
  end

  for i, e in ipairs(consola.entradas) do
    local y = z.y + 36 + (i - 1) * 66
    local alfa = i == 1 and 1 or 0.55
    if e.brillo > 0 then                                   -- destello al llegar
      estilo.color(estilo.consola, 0.15 * e.brillo)
      love.graphics.rectangle("fill", z.x + 20, y - 4, z.w - 40, 60, 6, 6)
    end
    estilo.chip(e.evento, z.x + 28, y + 4, estilo.consola)
    love.graphics.setFont(fuentes.codigoG)
    love.graphics.setColor(1, 1, 1, alfa)
    love.graphics.print(resaltado.linea(e.codigo), z.x + 230, y)
    love.graphics.setFont(fuentes.texto)
    estilo.color(estilo.blanco, alfa * 0.8)
    love.graphics.print(e.explica, z.x + 230, y + 24)
  end
end

return consola

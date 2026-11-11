-- SONIDO: otro oyente más. Nadie lo llama: él escucha eventos y suena.
-- Si borras la línea sonido.iniciar() en main.lua, el juego sigue igual pero mudo.
-- Eso prueba que está DESACOPLADO.

local Eventos = require("core.eventos")

local sonido = {}

-- Fabrica un "bip" sintetizado: una onda seno que se apaga poco a poco.
local function tono(frecuencia, duracion)
  local muestras = 44100
  local total = math.floor(muestras * duracion)
  local datos = love.sound.newSoundData(total, muestras, 16, 1)
  for i = 0, total - 1 do
    local apagado = 1 - i / total
    datos:setSample(i, math.sin(2 * math.pi * frecuencia * i / muestras) * apagado * 0.3)
  end
  return love.audio.newSource(datos, "static")
end

local function tocar(fuente) fuente:clone():play() end

function sonido.iniciar()
  local moneda = tono(988, 0.12)
  local golpe  = tono(160, 0.15)
  local sello  = tono(660, 0.6)
  local aviso  = tono(300, 0.1)
  local campanas = {}   -- una por nota, creada la primera vez que suena

  Eventos.on("moneda_recogida", function() tocar(moneda) end)
  Eventos.on("golpe",           function() tocar(golpe) end)
  Eventos.on("sello_obtenido",  function() tocar(sello) end)
  Eventos.on("cofre_cerrado",   function() tocar(aviso) end)
  Eventos.on("campana_tocada",  function(campana)
    campanas[campana.nota] = campanas[campana.nota] or tono(campana.nota, 0.9)
    tocar(campanas[campana.nota])
  end)
end

return sonido

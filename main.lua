-- OBJETÓPOLIS — un juego para aprender Programación Orientada a Objetos en Lua + LÖVE.
--
-- main.lua solo ORQUESTA: crea las piezas, las conecta y delega.
-- No sabe qué es una Moneda, un Slime o un Cofre. Por eso casi nunca se toca.

local Eventos   = require("core.eventos")
local Mundo     = require("core.mundo")
local fabrica   = require("core.fabrica")
local pantalla  = require("core.pantalla")
local mapa      = require("data.mapa")
local Jugador   = require("entities.jugador")
local misiones  = require("systems.misiones")
local sonido    = require("systems.sonido")
local hud       = require("ui.hud")
local panel     = require("ui.panel")
local consola   = require("ui.consola")
local dialogo   = require("ui.dialogo")
local pergamino = require("ui.pergamino")
local pantallas = require("ui.pantallas")

local estado = "titulo"   -- "titulo" -> "jugando" -> "final"  (máquina de estados)
local mundo, jugador
local foco               -- el objeto que el panel está explicando

function love.load()
  pantalla.iniciar()

  mundo = Mundo.new(mapa.barrios, mapa.limites)
  fabrica.poblar(mundo, mapa.barrios)          -- datos -> objetos
  jugador = Jugador.new(mapa.inicio)           -- ¡aquí naces tú!
  mundo.jugador = jugador
  foco = jugador

  -- Cada sistema se suscribe a los eventos que le interesan. Ninguno conoce a los otros.
  misiones.iniciar()
  sonido.iniciar()
  hud.iniciar()
  panel.iniciar()
  consola.iniciar()
  dialogo.iniciar()
  Eventos.on("juego_completado", function() estado = "final" end)
end

function love.update(dt)
  if estado == "jugando" and not dialogo.abierto and not pergamino.abierto then
    mundo:update(dt)
    foco = mundo:masCercano(110) or jugador
  end
  hud.update(dt)
  consola.update(dt)
  dialogo.update(dt)
end

function love.draw()
  love.graphics.clear(0, 0, 0)
  pantalla.comenzar()
    pantalla.comenzarJuego()                   -- zona JUEGO
      mundo:dibujar(foco)
      hud.dibujarSobreJuego()
      dialogo.dibujar()
    pantalla.terminarJuego()
    if pantalla.modoClase then                 -- zonas PANEL y CONSOLA (tecla H)
      panel.dibujar(foco, mundo:barrioDe(jugador))
      consola.dibujar()
    end
    hud.dibujarBarra()                         -- barra superior
    pergamino.dibujar()
    if estado == "titulo" then pantallas.titulo() end
    if estado == "final" then pantallas.final(jugador, hud.oro) end
  pantalla.terminar()
end

function love.keypressed(tecla)
  if tecla == "f11" then return pantalla.alternarCompleta() end
  if tecla == "h" and estado == "jugando" then return pantalla.alternarModo() end

  if estado == "titulo" then
    if tecla == "return" or tecla == "space" then estado = "jugando" end
    if tecla == "escape" then love.event.quit() end
    return
  end
  if estado == "final" then
    if tecla == "r" then love.event.quit("restart") end
    if tecla == "escape" then love.event.quit() end
    return
  end

  -- Si hay una ventana abierta, ella recibe la tecla
  if dialogo.abierto then return dialogo.tecla(tecla) end
  if pergamino.abierto then return pergamino.tecla(tecla) end

  if tecla == "e" or tecla == "space" then
    local cerca = mundo:masCercano(70, true)
    if cerca then
      Eventos.emit("interaccion", cerca)
      cerca:interactuar(jugador, mundo)     -- POLIMORFISMO: ¿qué hará? ¡Depende del objeto!
    end
  elseif tecla == "tab" then
    pergamino.abrir(foco, panel.metodoDe(foco))
  elseif tecla == "escape" then
    love.event.quit()
  end
end

function love.wheelmoved(_, y)
  if pergamino.abierto then pergamino.desplazar(-y * 3) end
end

function love.resize()
  pantalla.ajustar()
end

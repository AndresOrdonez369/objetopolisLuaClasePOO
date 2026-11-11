-- conf.lua: LÖVE lo lee ANTES que main.lua. Configura la ventana.
-- El juego se dibuja siempre en 1600x900 "virtuales" y se escala a la ventana
-- (ver core/pantalla.lua). F11 = pantalla completa, ideal para el proyector.
function love.conf(t)
  t.identity         = "objetopolis"
  t.version          = "11.5"
  t.window.title     = "Objetópolis — aprende POO jugando"
  t.window.width     = 1600
  t.window.height    = 900
  t.window.resizable = true
  t.window.minwidth  = 800
  t.window.minheight = 450
end

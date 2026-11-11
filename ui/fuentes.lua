-- FUENTES: se crean UNA vez y todos las comparten (crearlas cada frame es lento).
-- Opcional: si pones una fuente monoespaciada en assets/mono.ttf (por ejemplo
-- JetBrains Mono o Fira Code, ambas gratuitas), el código se verá como en VS Code.

local function codigo(tamano)
  if love.filesystem.getInfo("assets/mono.ttf") then
    return love.graphics.newFont("assets/mono.ttf", tamano)
  end
  return love.graphics.newFont(tamano)
end

return {
  mini    = love.graphics.newFont(11),
  chica   = love.graphics.newFont(12),
  texto   = love.graphics.newFont(14),
  normal  = love.graphics.newFont(16),
  media   = love.graphics.newFont(20),
  grande  = love.graphics.newFont(30),
  titulo  = love.graphics.newFont(64),
  codigo  = codigo(14),
  codigoG = codigo(16),
}

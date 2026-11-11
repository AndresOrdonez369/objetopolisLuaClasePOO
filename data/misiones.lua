-- MISIONES (datos): qué evento escucha cada sello, cuántas cosas DISTINTAS pide
-- y cuáles acepta. acepta(dato) devuelve una "clave" para contar, o nil para ignorar.
-- Cambiar una misión = cambiar esta tabla. La lógica (systems/misiones.lua) no se toca.

return {
  {
    sello  = "Clase y Objeto", barrio = "molde", evento = "moneda_recogida", meta = 5,
    acepta = function(moneda) if moneda.barrio == "molde" then return moneda end end,
    frase  = "Una clase es el molde; cada objeto es una galleta con su propio estado.",
  },
  {
    sello  = "Herencia", barrio = "familia", evento = "enemigo_derrotado", meta = 3,
    acepta = function(slime) return slime end,
    frase  = "Lo que al hijo le falta, lo busca en el padre (__index).",
  },
  {
    sello  = "Encapsulación", barrio = "boveda", evento = "cofre_abierto", meta = 1,
    acepta = function(cofre) return cofre end,
    frase  = "Los datos se esconden; solo se tocan a través de métodos.",
  },
  {
    sello  = "Polimorfismo", barrio = "mercado", evento = "interaccion", meta = 3,
    acepta = function(e) if e.barrio == "mercado" and e.tipo ~= "npc" then return e.tipo end end,
    frase  = "Mismo mensaje, interactuar(); cada objeto responde a su manera.",
  },
  {
    sello  = "Composición", barrio = "taller", evento = "componente_equipado", meta = 2,
    acepta = function(componente) return componente.nombre end,
    frase  = "Mejor TENER piezas que SER de una familia. Importa el contrato.",
  },
  {
    sello  = "Desacoplamiento", barrio = "torre", evento = "campana_tocada", meta = 3,
    acepta = function(campana) return campana end,
    frase  = "Quien emite no conoce a quien escucha. Cambias una pieza sin romper otra.",
  },
}

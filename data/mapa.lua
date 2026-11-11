-- MAPA: el mundo descrito como DATOS, no como código.
-- Cada barrio es un rectángulo con entidades. Las posiciones (x, y) son
-- RELATIVAS a la esquina del barrio. core/fabrica.lua convierte esto en objetos.
-- ¿Quieres otra moneda? Agrega una línea. No hace falta tocar ninguna clase.

local L = require("data.lecciones")

local ANCHO, ALTO = 384, 304          -- 3 columnas x 2 filas = 1152 x 608
local FILA1, FILA2 = 44, 44 + ALTO    -- debajo de la barra superior

return {
  inicio  = { x = 40, y = 210 },                         -- donde nace el jugador
  limites = { x = 0, y = FILA1, w = ANCHO * 3, h = ALTO * 2 },

  barrios = {
    {
      id = "molde", numero = 1, nombre = "Plaza del Molde", concepto = "Clase · Objeto · Constructor · self",
      x = 0, y = FILA1, w = ANCHO, h = ALTO, color = { 0.20, 0.17, 0.12 },
      entidades = {
        { tipo = "NPC", x = 30, y = 64, nombre = "La Panadera", lineas = L.molde, color = { 0.95, 0.75, 0.5 } },
        { tipo = "Puerta", x = 300, y = 60, necesarios = 6 },
        { tipo = "Moneda", x = 110, y = 120 },
        { tipo = "Moneda", x = 190, y = 180 },
        { tipo = "Moneda", x = 250, y = 110 },
        { tipo = "Moneda", x = 130, y = 250 },
        { tipo = "Moneda", x = 280, y = 230 },
      },
    },
    {
      id = "familia", numero = 2, nombre = "Barrio Familia", concepto = "Herencia · Sobrescritura (override)",
      x = ANCHO, y = FILA1, w = ANCHO, h = ALTO, color = { 0.12, 0.20, 0.14 },
      entidades = {
        { tipo = "NPC", x = 30, y = 64, nombre = "Abuela Entidad", lineas = L.familia, color = { 0.85, 0.85, 0.9 } },
        { tipo = "Slime",        x = 150, y = 150 },
        { tipo = "SlimeVeloz",   x = 250, y = 210 },
        { tipo = "SlimeGigante", x = 280, y = 100 },
      },
    },
    {
      id = "boveda", numero = 3, nombre = "La Bóveda", concepto = "Encapsulación · Datos privados",
      x = ANCHO * 2, y = FILA1, w = ANCHO, h = ALTO, color = { 0.13, 0.15, 0.22 },
      entidades = {
        { tipo = "NPC", x = 30, y = 64, nombre = "La Banquera", lineas = L.boveda, color = { 0.5, 0.75, 0.95 } },
        { tipo = "Cofre", x = 290, y = 140, oro = 50 },
        { tipo = "Llave", x = 80, y = 245 },
      },
    },
    {
      id = "mercado", numero = 4, nombre = "El Mercado", concepto = "Polimorfismo · Mismo mensaje, otra respuesta",
      x = ANCHO * 2, y = FILA2, w = ANCHO, h = ALTO, color = { 0.22, 0.14, 0.14 },
      entidades = {
        { tipo = "NPC", x = 30, y = 64, nombre = "El Mercader", lineas = L.mercado, color = { 1, 0.55, 0.45 } },
        { tipo = "Lampara", x = 140, y = 110 },
        { tipo = "Fuente",  x = 220, y = 180 },
        { tipo = "Cartel",  x = 320, y = 80, texto = L.cartel },
      },
    },
    {
      id = "taller", numero = 5, nombre = "Taller LEGO", concepto = "Composición · Abstracción · Contratos",
      x = ANCHO, y = FILA2, w = ANCHO, h = ALTO, color = { 0.17, 0.13, 0.22 },
      entidades = {
        { tipo = "NPC", x = 30, y = 64, nombre = "La Ingeniera", lineas = L.taller, color = { 0.8, 0.6, 1 } },
        { tipo = "Pieza", x = 150, y = 130, componente = "botas" },
        { tipo = "Pieza", x = 280, y = 130, componente = "iman" },
        { tipo = "Moneda", x = 180, y = 250, valor = 2, color = { 1, 0.55, 0.15 } },
        { tipo = "Moneda", x = 230, y = 258, valor = 2, color = { 1, 0.55, 0.15 } },
        { tipo = "Moneda", x = 280, y = 250, valor = 2, color = { 1, 0.55, 0.15 } },
      },
    },
    {
      id = "torre", numero = 6, nombre = "Torre del Pregonero", concepto = "Desacoplamiento · Eventos (Observer)",
      x = 0, y = FILA2, w = ANCHO, h = ALTO, color = { 0.12, 0.18, 0.21 },
      entidades = {
        { tipo = "Pregonero", x = 30, y = 64, nombre = "El Pregonero", lineas = L.torre, color = { 1, 0.85, 0.3 } },
        { tipo = "Campana", x = 90,  y = 226, nota = 523 },
        { tipo = "Campana", x = 180, y = 226, nota = 659 },
        { tipo = "Campana", x = 270, y = 226, nota = 784 },
      },
    },
  },
}

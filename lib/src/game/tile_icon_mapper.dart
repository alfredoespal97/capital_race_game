
import 'package:flutter/material.dart';

// Este mapa asocia el nombre de las casillas especiales y de evento
// con un icono específico de la librería de Material Icons.
// Esto nos permite centralizar la lógica de los iconos y hacerla fácilmente extensible.

final Map<String, IconData> tileIcons = {
  // --- Casillas Especiales ---
  'Salida': Icons.flag_circle_outlined,
  'Impuestos': Icons.receipt_long_rounded,
  'Subsidio': Icons.redeem_rounded,
  'Descanso': Icons.free_breakfast_rounded,

  // --- Casillas de Evento ---
  'Evento Económico': Icons.trending_up_rounded,
  'Crisis Financiera': Icons.trending_down_rounded,
  'Burbuja Tecnológica': Icons.bubble_chart_rounded,
};

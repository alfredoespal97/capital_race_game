
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HouseComponent extends PositionComponent {
  final int houseNumber; // Para saber qué casa es (1ra, 2da, etc.)

  HouseComponent({required this.houseNumber});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    size = Vector2.all(12); // Tamaño de la casa
    anchor = Anchor.center;

    // Usamos un simple rectángulo coloreado para representar la casa
    final paint = Paint()..color = Colors.red.shade800;
    add(RectangleComponent(size: size, paint: paint));

    // Posicionamos las casas en una fila dentro de la casilla
    // Este posicionamiento es relativo al TileComponent que lo contendrá
    position = Vector2(size.x * 1.5 * (houseNumber - 1) + 15, 10);
  }
}

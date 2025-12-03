
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:capital_race/src/models/tile.dart';
import 'package:capital_race/src/game/tile_icon_mapper.dart'; // El mapa 'tileIcons' se usa desde aquí
import 'package:capital_race/src/game/board_config.dart';

class TileComponent extends PositionComponent {
  final Tile tile;
  Component? _ownerIndicator;

  TileComponent({required this.tile, required double tileSize})
      : super(size: Vector2.all(tileSize));

  Color get _tileColor {
    if (tile is PropertyTile) {
      return sectorColors[(tile as PropertyTile).property.sector] ?? Colors.grey;
    } else if (tile is SpecialTile) {
      return Colors.grey.shade300;
    } else if (tile is EventTile) {
      return Colors.blueGrey.shade200;
    }
    return Colors.white;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    final rect = size.toRect();
    final paint = Paint()..color = _tileColor;
    canvas.drawRect(rect, paint);

    final borderPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(rect, borderPaint);

    _renderTileName(canvas);
    _renderIcon(canvas);
    _updateOwnerIndicator();
  }

  void _renderTileName(ui.Canvas canvas) {
    final textStyle = GoogleFonts.poppins(
      fontSize: size.x * 0.1,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
    );
    final textSpan = TextSpan(text: tile.name, style: textStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: size.x * 0.9);
    textPainter.paint(canvas, Offset(size.x * 0.05, size.y * 0.75));
  }

  void _renderIcon(ui.Canvas canvas) {
    // CORREGIDO: Se busca el icono en el mapa 'tileIcons' usando el nombre de la casilla.
    final iconData = tileIcons[tile.name];

    if (iconData != null) {
      final iconStyle = TextStyle(
        fontFamily: 'MaterialIcons',
        fontSize: size.x * 0.5,
        color: Colors.black.withOpacity(0.6),
      );
      final iconSpan = TextSpan(text: String.fromCharCode(iconData.codePoint), style: iconStyle);
      final iconPainter = TextPainter(text: iconSpan, textDirection: TextDirection.ltr);
      iconPainter.layout();
      iconPainter.paint(canvas, Offset((size.x - iconPainter.width) / 2, size.y * 0.15));
    }
  }

  void _updateOwnerIndicator() {
    if (tile is PropertyTile) {
      final property = (tile as PropertyTile).property;
      if (property.owner != null && _ownerIndicator == null) {
        _ownerIndicator = RectangleComponent(
          size: Vector2(size.x, size.y * 0.1),
          position: Vector2(0, 0),
          paint: Paint()..color = property.owner!.pieceColor,
        );
        add(_ownerIndicator!);
      } else if (property.owner == null && _ownerIndicator != null) {
        remove(_ownerIndicator!);
        _ownerIndicator = null;
      }
    }
  }
}

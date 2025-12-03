
import 'package:flame/components.dart';
import 'package:capital_race/src/models/tile.dart';
import 'package:capital_race/src/game/board_config.dart';
import 'package:capital_race/src/game/tile_component.dart'; 
import 'package:capital_race/src/models/property.dart';

class Board extends PositionComponent {
  final int tilesPerSide = 9; 
  late final double tileSize;
  final List<Tile> tiles = boardTiles; 

  List<Property> get properties => tiles
      .where((tile) => tile is PropertyTile)
      .map((tile) => (tile as PropertyTile).property)
      .toList();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(700);
    position = Vector2.all(50);
    anchor = Anchor.topLeft;
    
    _renderTiles();
  }

  void _renderTiles() {
    tileSize = size.x / tilesPerSide;
    
    for (int i = 0; i < tiles.length; i++) {
      final tileComponent = TileComponent(
        tile: tiles[i],
        tileSize: tileSize, // <- CORREGIDO: Se pasa 'tileSize' en lugar de 'size'
      );
      tileComponent.position = _getTilePosition(i);
      add(tileComponent);
    }
  }

  Vector2 _getTilePosition(int index) {
    final int side = index ~/ (tilesPerSide - 1);
    final int posInSide = index % (tilesPerSide - 1);
    
    final double maxPos = (tilesPerSide - 1) * tileSize;

    switch (side) {
      case 0: return Vector2(maxPos - posInSide * tileSize, maxPos);
      case 1: return Vector2(0, maxPos - posInSide * tileSize);
      case 2: return Vector2(posInSide * tileSize, 0);
      case 3: return Vector2(maxPos, posInSide * tileSize);
      default: return Vector2.zero();
    }
  }

  Vector2 getPositionForTile(int index) {
    final position = _getTilePosition(index);
    // Devuelve la posición central de la casilla para que la pieza se sitúe en el medio.
    return position + Vector2.all(tileSize / 2);
  }
}

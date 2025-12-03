
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:capital_race/src/game/board.dart';
import 'package:capital_race/src/models/player.dart';

class PlayerPiece extends PositionComponent {
  final Player player;
  final Board board;
  final String svgAssetPath;
  int currentTileIndex = 0;

  PlayerPiece({
    required this.player,
    required this.board,
    required this.svgAssetPath,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    size = Vector2.all(board.size.x / board.tilesPerSide * 0.7);
    anchor = Anchor.center;

    final svg = await Svg.load(svgAssetPath);
    add(SvgComponent(svg: svg, size: size));

    position = board.getPositionForTile(currentTileIndex);
  }

  Future<void> moveTo(int newIndex) async {
    final path = _calculatePath(currentTileIndex, newIndex);
    
    final effectSequence = SequenceEffect([]);

    for (final tileIndex in path) {
      final targetPosition = board.getPositionForTile(tileIndex);
      
      // CORREGIDO: Se adjunta el sonido al inicio del efecto de movimiento.
      // Ya no se necesita el ParallelEffect ni instanciar una clase abstracta.
      final moveEffect = MoveToEffect(
        targetPosition, 
        EffectController(duration: 0.25),
        onComplete: () {
          FlameAudio.play('move_piece.wav', volume: 0.5);
        }
      );

      effectSequence.add(moveEffect);
    }
    
    await add(effectSequence);
    currentTileIndex = newIndex;
  }

  List<int> _calculatePath(int from, int to) {
    final path = <int>[];
    int current = from;
    
    if (from == to) return [];
    
    while (current != to) {
      current = (current + 1) % board.tiles.length;
      path.add(current);
    }
    
    return path;
  }
}

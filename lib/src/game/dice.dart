
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Dice extends PositionComponent with TapCallbacks {
  final Random _rng = Random();
  int _roll1 = 1;
  int _roll2 = 1;

  int get totalRoll => _roll1 + _roll2;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(100, 50);
    // TODO: Add dice images
  }

  void roll() {
    _roll1 = _rng.nextInt(6) + 1;
    _roll2 = _rng.nextInt(6) + 1;
  }
}

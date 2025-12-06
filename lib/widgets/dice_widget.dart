import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class DiceWidget extends StatelessWidget {
  const DiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDie(gameProvider.dice1, gameProvider.isRolling),
            const SizedBox(width: 16),
            _buildDie(gameProvider.dice2, gameProvider.isRolling),
          ],
        );
      },
    );
  }

  Widget _buildDie(int value, bool isRolling) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: _buildDots(value),
      ),
    );
  }

  Widget _buildDots(int value) {
    return CustomPaint(
      size: const Size(50, 50),
      painter: DiePainter(value),
    );
  }
}

class DiePainter extends CustomPainter {
  final int value;

  DiePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double dotRadius = size.width * 0.08;
    final double padding = size.width * 0.2;
    final double center = size.width / 2;

    switch (value) {
      case 1:
        canvas.drawCircle(Offset(center, center), dotRadius, paint);
        break;
      case 2:
        canvas.drawCircle(Offset(padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, size.height - padding), dotRadius, paint);
        break;
      case 3:
        canvas.drawCircle(Offset(padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(center, center), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, size.height - padding), dotRadius, paint);
        break;
      case 4:
        canvas.drawCircle(Offset(padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(padding, size.height - padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, size.height - padding), dotRadius, paint);
        break;
      case 5:
        canvas.drawCircle(Offset(padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(center, center), dotRadius, paint);
        canvas.drawCircle(Offset(padding, size.height - padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, size.height - padding), dotRadius, paint);
        break;
      case 6:
        canvas.drawCircle(Offset(padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, padding), dotRadius, paint);
        canvas.drawCircle(Offset(padding, center), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, center), dotRadius, paint);
        canvas.drawCircle(Offset(padding, size.height - padding), dotRadius, paint);
        canvas.drawCircle(Offset(size.width - padding, size.height - padding), dotRadius, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(DiePainter oldDelegate) => oldDelegate.value != value;
}

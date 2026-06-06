import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to GameProvider to update UI when save status changes
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF8B0000),
              const Color(0xFF4B0000),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // Logo and Title
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.yellow.shade200],
                        ).createShader(bounds),
                        child: Text(
                          'MONOPOLY',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 8,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(4, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'The Classic Board Game',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Resume Game Button (Only if save exists)
                if (gameProvider.hasSaveFile) ...[
                  _buildMenuButton(
                    context,
                    label: 'RESUME GAME',
                    icon: Icons.restore,
                    color: Colors.orange,
                    onPressed: () async {
                      bool success = await gameProvider.loadGame();
                      if (success && context.mounted) {
                        Navigator.pushNamed(context, '/game');
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to load save game.'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Play Button
                _buildMenuButton(
                  context,
                  label: 'NEW GAME',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, '/mode');
                  },
                ),

                const SizedBox(height: 20),

                // Rules Button
                _buildMenuButton(
                  context,
                  label: 'HOW TO PLAY',
                  icon: Icons.help_outline_rounded,
                  onPressed: () {
                    _showRulesDialog(context);
                  },
                ),

                const SizedBox(height: 20),

                // About Button
                _buildMenuButton(
                  context,
                  label: 'ABOUT',
                  icon: Icons.info_outline_rounded,
                  onPressed: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRuleItem('🎲', 'Roll the dice to move around the board'),
              _buildRuleItem('🏠', 'Buy properties and build houses/hotels'),
              _buildRuleItem('💰', 'Collect rent from other players'),
              _buildRuleItem('🎯', 'Pass GO to collect \$200'),
              _buildRuleItem('🚫', 'Avoid bankruptcy to stay in the game'),
              _buildRuleItem('👑', 'Last player standing wins!'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Monopoly'),
        content: const Text(
          'A digital recreation of the classic Monopoly board game.\n\n'
          'Built with Flutter\n'
          'Version 1.0.0\n\n'
          '© 2024 Monopoly Game',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

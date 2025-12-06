import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../models/bot_player.dart';
import '../providers/game_provider.dart';

class BotSetupDialog extends StatefulWidget {
  const BotSetupDialog({super.key});

  @override
  State<BotSetupDialog> createState() => _BotSetupDialogState();
}

class _BotSetupDialogState extends State<BotSetupDialog> {
  final TextEditingController _playerNameController = TextEditingController(
    text: 'You',
  );
  BotDifficulty _botDifficulty = BotDifficulty.medium;
  int _numberOfBots = 1;

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    'VS Bot Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Player Name
                    const Text(
                      'Your Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _playerNameController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Number of Bots
                    const Text(
                      'Number of Bots',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(3, (index) {
                        int bots = index + 1;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _buildBotCountButton(bots),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // Bot Difficulty
                    const Text(
                      'Bot Difficulty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildDifficultyOption(
                      BotDifficulty.easy,
                      'Easy',
                      'Bot makes simple decisions',
                      Colors.green,
                      Icons.sentiment_satisfied,
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyOption(
                      BotDifficulty.medium,
                      'Medium',
                      'Bot plays strategically',
                      Colors.orange,
                      Icons.sentiment_neutral,
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyOption(
                      BotDifficulty.hard,
                      'Hard',
                      'Bot plays aggressively',
                      Colors.red,
                      Icons.sentiment_very_dissatisfied,
                    ),
                  ],
                ),
              ),
            ),

            // Start Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'START GAME',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotCountButton(int count) {
    bool isSelected = _numberOfBots == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          _numberOfBots = count;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.purple.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '$count Bot${count > 1 ? 's' : ''}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(
    BotDifficulty difficulty,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    bool isSelected = _botDifficulty == difficulty;
    return GestureDetector(
      onTap: () {
        setState(() {
          _botDifficulty = difficulty;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    List<Player> players = [];

    // Add human player
    players.add(
      Player(
        id: 'player_0',
        name: _playerNameController.text.trim().isEmpty
            ? 'You'
            : _playerNameController.text.trim(),
        color: Colors.blue,
        icon: Icons.person,
      ),
    );

    // Add bot players
    final List<Color> botColors = [Colors.red, Colors.green, Colors.yellow];
    final List<IconData> botIcons = [
      Icons.smart_toy,
      Icons.android,
      Icons.precision_manufacturing,
    ];
    final List<String> botNames = ['Bot Alpha', 'Bot Beta', 'Bot Gamma'];

    for (int i = 0; i < _numberOfBots; i++) {
      players.add(
        BotPlayer(
          id: 'bot_$i',
          name: botNames[i],
          color: botColors[i],
          icon: botIcons[i],
          difficulty: _botDifficulty,
        ),
      );
    }

    Provider.of<GameProvider>(context, listen: false).initializeGame(players);

    Navigator.pop(context);
    Navigator.pushNamed(context, '/game');
  }
}

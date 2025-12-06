import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../providers/game_provider.dart';

class PlayerSetupDialog extends StatefulWidget {
  const PlayerSetupDialog({super.key});

  @override
  State<PlayerSetupDialog> createState() => _PlayerSetupDialogState();
}

class _PlayerSetupDialogState extends State<PlayerSetupDialog> {
  int _numberOfPlayers = 2;
  final List<TextEditingController> _nameControllers = [];
  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  final List<IconData> _availableIcons = [
    Icons.directions_car,
    Icons.directions_boat,
    Icons.flight,
    Icons.pets,
    Icons.sports_soccer,
    Icons.star,
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameControllers.clear();
    for (int i = 0; i < 6; i++) {
      _nameControllers.add(TextEditingController(text: 'Player ${i + 1}'));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
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
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
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
                  const Icon(
                    Icons.group_add,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Setup Players',
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
                    // Number of Players Selector
                    const Text(
                      'Number of Players',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(5, (index) {
                        int players = index + 2;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _buildPlayerCountButton(players),
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Player Names
                    const Text(
                      'Player Names',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    ...List.generate(_numberOfPlayers, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildPlayerNameField(index),
                      );
                    }),
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

  Widget _buildPlayerCountButton(int count) {
    bool isSelected = _numberOfPlayers == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          _numberOfPlayers = count;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.blue.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected 
                ? Colors.blue
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerNameField(int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _availableColors[index].withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _availableColors[index],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _availableIcons[index],
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _nameControllers[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter player name',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    List<Player> players = [];
    
    for (int i = 0; i < _numberOfPlayers; i++) {
      players.add(Player(
        id: 'player_$i',
        name: _nameControllers[i].text.trim().isEmpty 
            ? 'Player ${i + 1}' 
            : _nameControllers[i].text.trim(),
        color: _availableColors[i],
        icon: _availableIcons[i],
      ));
    }

    Provider.of<GameProvider>(context, listen: false).initializeGame(players);
    
    Navigator.pop(context);
    Navigator.pushNamed(context, '/game');
  }
}

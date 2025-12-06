import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/game_provider.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // If it's a bot's turn, show a message instead of controls
        if (gameProvider.isCurrentPlayerBot) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.purple.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '🤖 ${gameProvider.currentPlayer.name} is thinking...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // If player is in jail, show jail-specific controls
        if (gameProvider.currentPlayer.isInJail) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.orange.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_police, color: Colors.orange, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      '🚔 You are in JAIL!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose an option to get out:',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pay $50 to get out
                    _buildControlButton(
                      context,
                      label: 'PAY \$50',
                      icon: Icons.attach_money,
                      color: Colors.green,
                      onPressed: gameProvider.currentPlayer.money >= 50
                          ? () {
                              gameProvider.payToLeaveJail();
                            }
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Roll for doubles
                    _buildControlButton(
                      context,
                      label: 'ROLL FOR DOUBLES',
                      icon: Icons.casino,
                      color: Colors.blue,
                      onPressed:
                          (gameProvider.isRolling || gameProvider.hasRolledDice)
                          ? null
                          : () {
                              gameProvider.rollDice();
                            },
                    ),
                    if (gameProvider.currentPlayer.getOutOfJailCards > 0) ...[
                      const SizedBox(width: 16),
                      _buildControlButton(
                        context,
                        label:
                            'USE CARD (${gameProvider.currentPlayer.getOutOfJailCards})',
                        icon: Icons.confirmation_number,
                        color: Colors.purple,
                        onPressed: () {
                          gameProvider.useGetOutOfJailCard();
                        },
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 12),
                Text(
                  'Turns in jail: ${gameProvider.currentPlayer.jailTurns}/3',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        // Human player controls (normal turn)
        return LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;

            return Wrap(
              alignment: WrapAlignment.center,
              spacing: isMobile ? 8 : 12,
              runSpacing: isMobile ? 8 : 12,
              children: [
                // Roll Dice Button
                _buildControlButton(
                  context,
                  label: isMobile ? 'ROLL' : 'ROLL DICE',
                  icon: Icons.casino,
                  color: Colors.green,
                  isMobile: isMobile,
                  onPressed:
                      (gameProvider.isRolling || gameProvider.hasRolledDice)
                      ? null
                      : () {
                          gameProvider.rollDice();
                        },
                ),

                // Buy Property Button
                _buildControlButton(
                  context,
                  label: 'BUY',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                  isMobile: isMobile,
                  onPressed: () {
                    var space = gameProvider
                        .boardSpaces[gameProvider.currentPlayer.position];
                    if (space.property != null &&
                        space.property!.owner == null) {
                      gameProvider.buyProperty();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot buy this property'),
                        ),
                      );
                    }
                  },
                ),

                // Build Button
                _buildControlButton(
                  context,
                  label: 'BUILD',
                  icon: Icons.home_work,
                  color: Colors.orange,
                  isMobile: isMobile,
                  onPressed: () {
                    _showBuildDialog(context, gameProvider);
                  },
                ),

                // End Turn Button
                _buildControlButton(
                  context,
                  label: isMobile ? 'END' : 'END TURN',
                  icon: Icons.skip_next,
                  color: Colors.red,
                  isMobile: isMobile,
                  onPressed: () {
                    gameProvider.endTurn();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isMobile = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isMobile ? 18 : 24),
      label: Text(label, style: TextStyle(fontSize: isMobile ? 12 : 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }

  void _showBuildDialog(BuildContext context, GameProvider gameProvider) {
    var currentPlayer = gameProvider.currentPlayer;
    var ownedProperties = gameProvider.boardSpaces
        .where((space) => space.property?.owner == currentPlayer.id)
        .map((space) => space.property!)
        .toList();

    if (ownedProperties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You don\'t own any properties')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Build Houses/Hotels'),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ownedProperties.length,
            itemBuilder: (context, index) {
              var property = ownedProperties[index];
              if (property.type != PropertyType.street) return const SizedBox();

              return Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: property.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  title: Text(property.name),
                  subtitle: Text(
                    'Houses: ${property.houses}/5 | Cost: \$${property.housePrice}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: Colors.green,
                    onPressed: () {
                      gameProvider.buildHouse(property.name);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
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

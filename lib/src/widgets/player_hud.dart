
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:capital_race/src/game_state.dart';
import 'package:capital_race/src/models/player.dart';
import 'package:capital_race/src/game/board_config.dart';

class PlayerHUD extends StatelessWidget {
  const PlayerHUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Consumer<Player>(
          builder: (context, player, child) {
            return Positioned(
              top: 20,
              left: 20,
              child: Card(
                elevation: 8.0,
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PlayerHeader(player: player),
                      const SizedBox(height: 12),
                      _PlayerStats(player: player),
                      const SizedBox(height: 12),
                      _PlayerActions(player: player),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final Player player;

  const _PlayerHeader({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: player.pieceColor,
          radius: 20,
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Icon(Icons.send, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            player.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PlayerStats extends StatelessWidget {
  final Player player;

  const _PlayerStats({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Capital: \$${player.capital.toStringAsFixed(0)}',
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green[800]),
        ),
        const SizedBox(height: 4),
        Text(
          'Propiedades: ${player.ownedProperties.length}',
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue[800]),
        ),
      ],
    );
  }
}

class _PlayerActions extends StatelessWidget {
  final Player player;

  const _PlayerActions({required this.player});

  void _showPropertiesDialog(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<Player>(
          builder: (context, player, child) {
            final properties = player.ownedProperties;
            return AlertDialog(
              title: const Text('Gestionar Propiedades'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    final canBuild = player.canBuildHouse(property, gameState.game.board.properties);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Icon(Icons.location_city, color: sectorColors[property.sector]),
                        title: Text(property.name),
                        subtitle: Text('Casas: ${property.houseCount} | Alquiler: \$${property.currentRent.toStringAsFixed(0)}'),
                        trailing: ElevatedButton(
                          onPressed: canBuild
                              ? () {
                                  gameState.game.buildHouseForPlayer(property);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canBuild ? Colors.green : Colors.grey,
                          ),
                          child: const Text('Construir'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: player.ownedProperties.isNotEmpty ? () => _showPropertiesDialog(context) : null,
      icon: const Icon(Icons.build_circle_outlined),
      label: const Text('Gestionar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

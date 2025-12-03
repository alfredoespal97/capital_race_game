
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capital_race/src/models/player.dart';

class PlayerInfoWidget extends StatelessWidget {
  final Alignment alignment;
  final Player player;

  const PlayerInfoWidget({super.key, required this.player, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player>(
        builder: (context, player, child) {
          return Align(
            alignment: alignment,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.85), // Corregido withOpacity
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey, width: 2)
                ),
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Capital: \$${player.capital.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green, 
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Propiedades:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Corregido: usar ownedProperties
                        final properties = player.ownedProperties;
                        return SizedBox(
                          height: properties.isEmpty ? 20 : (properties.length * 22.0).clamp(0, 150.0),
                          child: properties.isEmpty
                            ? const Text(
                                '-- Ninguna --',
                                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black45),
                              )
                            : ListView.builder(
                                itemCount: properties.length,
                                itemBuilder: (context, index) {
                                  final prop = properties[index];
                                  return Text(
                                    '- ${prop.name}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  );
                                },
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/game_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:myapp/src/models/player.dart';
import 'package:myapp/src/models/property.dart';
import 'package:myapp/src/game/board_config.dart';

class PlayerHud extends StatelessWidget {
  final Player player;
  final String avatarAsset;
  final Alignment alignment;

  const PlayerHud({
    super.key,
    required this.player,
    required this.avatarAsset,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player>(
        builder: (context, player, child) {
          return Align(
            alignment: alignment,
            child: Card(
              elevation: 8.0,
              color: const Color.fromRGBO(255, 255, 255, 0.85), // Corregido
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 12.0),
                      _buildCapitalInfo(),
                      const SizedBox(height: 8.0),
                      _buildManageButton(context),
                      const SizedBox(height: 12.0),
                      _buildPropertiesList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset(avatarAsset, height: 50, width: 50),
        const SizedBox(width: 12.0),
        Text(
          player.name,
          style: GoogleFonts.oswald(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCapitalInfo() {
    return Text(
      'Capital: \$${player.capital.toStringAsFixed(0)}',
      style: GoogleFonts.robotoCondensed(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.green[800],
      ),
    );
  }

  Widget _buildManageButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.build_circle_outlined),
        label: const Text('Gestionar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () => _showManagementDialog(context),
      ),
    );
  }

  void _showManagementDialog(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // El Consumer<Player> reconstruirá el contenido si el jugador cambia (ej. capital)
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
                    // Corregido: La lógica de si se puede construir reside en el Player
                    final canBuild = player.canBuildHouse(
                      property,
                      gameState.game.board.properties,
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: sectorColors[property.sector],
                        ),
                        title: Text(property.name),
                        subtitle: Text(
                          'Casas: ${property.houseCount} | Alquiler: \$${property.currentRent.toStringAsFixed(0)}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: canBuild
                              ? () {
                                  // Usamos el GameState para ejecutar la acción centralizada
                                  gameState.buildHouse(property);
                                }
                              : null,
                          child: const Text('Construir'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPropertiesList() {
    // Corregido: usar ownedProperties
    final properties = player.ownedProperties;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Propiedades:',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const Divider(thickness: 1.5),
        if (properties.isEmpty)
          const Text('Ninguna', style: TextStyle(fontStyle: FontStyle.italic))
        else
          // Para evitar overflow, hacemos la lista scrollable si es necesario
          SizedBox(
            height: 100, // Altura máxima fija
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final Property property = properties[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: sectorColors[property.sector],
                        margin: const EdgeInsets.only(right: 8.0),
                      ),
                      Expanded(
                        child: Text(
                          property.name,
                          style: GoogleFonts.lato(fontSize: 14),
                        ),
                      ),
                      Text(
                        'x${property.houseCount}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

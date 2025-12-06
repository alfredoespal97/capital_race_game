import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/property.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double boardSize = constraints.maxWidth;
              // 11x11 Grid: 1 Corner + 9 Properties + 1 Corner
              double spaceSize = boardSize / 11;

              return Stack(
                children: [
                  // Center Logo
                  Center(
                    child: Container(
                      width: boardSize - (spaceSize * 2),
                      height: boardSize - (spaceSize * 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B0000),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: boardSize * 0.15,
                            color: const Color(0xFFFFD700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'MONOPOLY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: boardSize * 0.08,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.casino,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Dice: ${gameProvider.dice1} + ${gameProvider.dice2}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Board Spaces
                  ...List.generate(40, (index) {
                    return _buildBoardSpace(
                      context,
                      gameProvider,
                      index,
                      spaceSize,
                      boardSize,
                    );
                  }),

                  // Player Tokens
                  ...gameProvider.players.map((player) {
                    return _buildPlayerToken(
                      player,
                      spaceSize,
                      boardSize,
                      gameProvider.players.indexOf(player),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBoardSpace(
    BuildContext context,
    GameProvider gameProvider,
    int position,
    double spaceSize,
    double boardSize,
  ) {
    BoardSpace space = gameProvider.boardSpaces[position];
    Offset offset = _getSpaceOffset(position, spaceSize, boardSize);

    // Homogeneous size for everyone
    double size = spaceSize;

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onTap: () => _showSpaceInfo(context, space),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _getSpaceColor(space),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: _buildSpaceContent(context, space, position, size),
        ),
      ),
    );
  }

  Widget _buildSpaceContent(
    BuildContext context,
    BoardSpace space,
    int position,
    double size,
  ) {
    bool isCorner = position % 10 == 0;

    if (isCorner) {
      return Container(
        color: Colors.red.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCornerIcon(position),
                size: size * 0.4,
                color: Colors.white,
              ),
              SizedBox(height: size * 0.05),
              Text(
                space.name,
                style: TextStyle(
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Checking if property is mortgaged for visual feedback
    bool isMortgaged = space.property?.isMortgaged ?? false;

    return Column(
      children: [
        // Color header
        if (space.property != null &&
            space.property!.type == PropertyType.street)
          Container(
            height: size * 0.25,
            decoration: BoxDecoration(
              color: isMortgaged ? Colors.grey : space.property!.color,
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
          ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(size * 0.02),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Property name
                Flexible(
                  child: Text(
                    space.name,
                    style: TextStyle(
                      fontSize: size * 0.1,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      decoration: isMortgaged
                          ? TextDecoration.lineThrough
                          : null,
                      color: isMortgaged ? Colors.grey : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Price or Mortgaged Tag
                if (space.property != null) ...[
                  SizedBox(height: size * 0.02),
                  if (isMortgaged)
                    Text(
                      'M',
                      style: TextStyle(
                        fontSize: size * 0.15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      '\$${space.property!.price}',
                      style: TextStyle(
                        fontSize: size * 0.09,
                        color: Colors.black,
                      ),
                    ),
                ],

                // Owner indicator
                if (space.property?.owner != null) ...[
                  SizedBox(height: size * 0.02),
                  Container(
                    width: size * 0.2,
                    height: size * 0.2,
                    decoration: BoxDecoration(
                      color: _getPlayerColor(context, space.property!.owner!),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                ],

                // Houses/Hotels indicator
                if (space.property != null &&
                    space.property!.houses > 0 &&
                    !isMortgaged) ...[
                  SizedBox(height: size * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        space.property!.houses == 5 ? Icons.hotel : Icons.home,
                        size: size * 0.15,
                        color: space.property!.houses == 5
                            ? Colors.red[700]
                            : Colors.green[700],
                      ),
                      if (space.property!.houses < 5)
                        Text(
                          'x${space.property!.houses}',
                          style: TextStyle(
                            fontSize: size * 0.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerToken(
    player,
    double spaceSize,
    double boardSize,
    int playerIndex,
  ) {
    Offset baseOffset = _getSpaceOffset(player.position, spaceSize, boardSize);

    // Offset multiple players on same space
    double offsetX = (playerIndex % 2) * (spaceSize * 0.2);
    double offsetY = (playerIndex ~/ 2) * (spaceSize * 0.2);

    return Positioned(
      left: baseOffset.dx + offsetX + spaceSize * 0.1,
      top: baseOffset.dy + offsetY + spaceSize * 0.1,
      child: Container(
        width: spaceSize * 0.4,
        height: spaceSize * 0.4,
        decoration: BoxDecoration(
          color: player.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(player.icon, color: Colors.white, size: spaceSize * 0.25),
        ),
      ),
    );
  }

  Offset _getSpaceOffset(int position, double spaceSize, double boardSize) {
    // 11x11 Grid Logic
    // Grid indices go from 0 to 10.

    // Position 0: GO (Bottom Right: 10, 10)
    if (position == 0) {
      return Offset(10 * spaceSize, 10 * spaceSize);
    }
    // Positions 1-9: Bottom row (Right to Left: 9,10 -> 1,10)
    else if (position < 10) {
      return Offset((10 - position) * spaceSize, 10 * spaceSize);
    }
    // Position 10: Jail (Bottom Left: 0, 10)
    else if (position == 10) {
      return Offset(0, 10 * spaceSize);
    }
    // Positions 11-19: Left column (Bottom to Top: 0,9 -> 0,1)
    else if (position < 20) {
      return Offset(0, (19 - position + 1) * spaceSize);
    }
    // Position 20: Free Parking (Top Left: 0, 0)
    else if (position == 20) {
      return const Offset(0, 0);
    }
    // Positions 21-29: Top row (Left to Right: 1,0 -> 9,0)
    else if (position < 30) {
      return Offset((position - 20) * spaceSize, 0);
    }
    // Position 30: Go to Jail (Top Right: 10, 0)
    else if (position == 30) {
      return Offset(10 * spaceSize, 0);
    }
    // Positions 31-39: Right column (Top to Bottom: 10,1 -> 10,9)
    else {
      return Offset(10 * spaceSize, (position - 30) * spaceSize);
    }
  }

  Color _getSpaceColor(BoardSpace space) {
    if (space.position % 10 == 0) {
      return Colors.red.shade900;
    }
    if (space.type == SpaceType.chance) {
      return Colors.orange.shade300;
    }
    if (space.type == SpaceType.communityChest) {
      return Colors.blue.shade300;
    }
    if (space.type == SpaceType.tax) {
      return Colors.grey.shade400;
    }
    return Colors.white;
  }

  IconData _getCornerIcon(int position) {
    switch (position) {
      case 0:
        return Icons.arrow_forward;
      case 10:
        return Icons.local_police;
      case 20:
        return Icons.local_parking;
      case 30:
        return Icons.gavel;
      default:
        return Icons.help;
    }
  }

  Color _getPlayerColor(BuildContext context, String playerId) {
    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      return gameProvider.players.firstWhere((p) => p.id == playerId).color;
    } catch (e) {
      return Colors.blue;
    }
  }

  void _showSpaceInfo(BuildContext context, BoardSpace space) {
    if (space.property == null) return;

    // We don't save 'property' here to avoid stale state.

    showDialog(
      context: context,
      builder: (context) => Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          // Get the *current* property state from the provider
          Property prop = gameProvider.boardSpaces[space.position].property!;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
              child: Stack(
                children: [
                  // Property Card
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5DC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (prop.type == PropertyType.street)
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: prop.color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(9),
                                  topRight: Radius.circular(9),
                                ),
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  prop.name.toUpperCase(),
                                  style: TextStyle(
                                    color: _getContrastColor(prop.color),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          if (prop.type != PropertyType.street)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                prop.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          // MORTGAGED BANNER
                          if (prop.isMortgaged)
                            Container(
                              width: double.infinity,
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const Text(
                                'MORTGAGED',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (prop.type == PropertyType.street) ...[
                                  _buildRentRow('RENT', '\$${prop.rent}'),
                                  const SizedBox(height: 8),
                                  _buildRentRow(
                                    'With 1 House',
                                    '\$${prop.rentWithHouses[0]}',
                                  ),
                                  _buildRentRow(
                                    'With 2 Houses',
                                    '\$${prop.rentWithHouses[1]}',
                                  ),
                                  _buildRentRow(
                                    'With 3 Houses',
                                    '\$${prop.rentWithHouses[2]}',
                                  ),
                                  _buildRentRow(
                                    'With 4 Houses',
                                    '\$${prop.rentWithHouses[3]}',
                                  ),
                                  _buildRentRow(
                                    'With HOTEL',
                                    '\$${prop.rentWithHouses[4]}',
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Mortgage Value',
                                    '\$${prop.getMortgageValue()}',
                                  ),
                                  _buildInfoRow(
                                    'House cost',
                                    '\$${prop.housePrice} each',
                                  ),
                                  _buildInfoRow(
                                    'Hotel cost',
                                    '\$${prop.housePrice} plus 4 houses',
                                  ),
                                ] else if (prop.type ==
                                    PropertyType.railroad) ...[
                                  _buildRentRow('RENT', '\$25'),
                                  _buildRentRow(
                                    'If 2 R.R.\'s are owned',
                                    '\$50',
                                  ),
                                  _buildRentRow(
                                    'If 3 R.R.\'s are owned',
                                    '\$100',
                                  ),
                                  _buildRentRow(
                                    'If 4 R.R.\'s are owned',
                                    '\$200',
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Mortgage Value',
                                    '\$${prop.getMortgageValue()}',
                                  ),
                                ] else if (prop.type ==
                                    PropertyType.utility) ...[
                                  const Text(
                                    'If one "Utility" is owned, rent is 4 times amount shown on dice.',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'If both "Utilities" are owned, rent is 10 times amount shown on dice.',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Mortgage Value',
                                    '\$${prop.getMortgageValue()}',
                                  ),
                                ],
                                if (prop.owner != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getPlayerColor(
                                        context,
                                        prop.owner!,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getPlayerColor(
                                          context,
                                          prop.owner!,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Owner: ${prop.owner}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (prop.houses > 0) ...[
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                prop.houses == 5
                                                    ? Icons.hotel
                                                    : Icons.home,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                prop.houses == 5
                                                    ? 'HOTEL'
                                                    : '${prop.houses} House${prop.houses > 1 ? 's' : ''}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),

                                // ACTIONS
                                if (prop.owner ==
                                        gameProvider.currentPlayer.id &&
                                    !prop.isMortgaged)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    onPressed: () {
                                      gameProvider.mortgageProperty(prop);
                                    },
                                    child: Text(
                                      'MORTGAGE for \$${prop.getMortgageValue()}',
                                    ),
                                  ),

                                if (prop.owner ==
                                        gameProvider.currentPlayer.id &&
                                    prop.isMortgaged)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    onPressed: () {
                                      gameProvider.unmortgageProperty(prop);
                                    },
                                    child: Text(
                                      'UNMORTGAGE for \$${(prop.getMortgageValue() * 1.1).round()}',
                                    ),
                                  ),

                                const SizedBox(height: 10),
                                if (prop.owner == null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'PRICE: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '\$${prop.price}',
                                          style: const TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ); // End Dialog
        }, // End Consumer builder
      ), // End Consumer
    ); // End showDialog
  }

  Widget _buildRentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate relative luminance
    double luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    // Return black for light colors, white for dark colors
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

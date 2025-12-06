import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import '../models/property.dart';
import '../widgets/board_widget.dart';
import '../widgets/player_info_panel.dart';
import '../widgets/dice_widget.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isCardDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              // Dialog Side Effect Handler
              if (gameProvider.currentCardDialog != null &&
                  !_isCardDialogShowing) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showCardDialog(
                    context,
                    gameProvider.currentCardDialog!,
                    gameProvider,
                  );
                });
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Determine layout based on screen size
                  bool isMobile = constraints.maxWidth < 600;
                  bool isTablet =
                      constraints.maxWidth >= 600 &&
                      constraints.maxWidth < 1024;
                  //bool isDesktop = constraints.maxWidth >= 1024;

                  if (isMobile) {
                    return _buildMobileLayout(context, gameProvider);
                  } else if (isTablet) {
                    return _buildTabletLayout(context, gameProvider);
                  } else {
                    return _buildDesktopLayout(context, gameProvider);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCardDialog(
    BuildContext context,
    Map<String, dynamic> data,
    GameProvider provider,
  ) {
    setState(() {
      _isCardDialogShowing = true;
    });

    String title = data['title'];
    String content = data['content'];
    bool isChance = data['type'] == 'chance';
    Color color = isChance ? Colors.orange : Colors.blueAccent;

    // Auto-close timer
    Timer? autoHideTimer;

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent clicking outside, require button or timer
      builder: (ctx) {
        // Start timer when dialog builds
        autoHideTimer ??= Timer(const Duration(seconds: 15), () {
          if (ctx.mounted) {
            Navigator.of(ctx).pop();
          }
        });

        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color, width: 4),
          ),
          title: Row(
            children: [
              Icon(
                isChance ? Icons.question_mark : Icons.card_giftcard,
                color: color,
                size: 40,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Autoclosing in 15 seconds...',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    ).then((_) {
      // On close (manual or timer)
      autoHideTimer?.cancel();
      setState(() {
        _isCardDialogShowing = false;
      });
      provider.clearCardDialog();
    });
  }

  // Mobile Layout (Portrait)
  Widget _buildMobileLayout(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        // Header
        _buildHeader(context, gameProvider, isMobile: true),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Board
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(aspectRatio: 1, child: BoardWidget()),
                ),

                // Dice and Controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      DiceWidget(),
                      const SizedBox(height: 16),
                      GameControls(),
                    ],
                  ),
                ),

                // Player Info (Horizontal scroll)
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: gameProvider.players.length,
                    itemBuilder: (context, index) {
                      var player = gameProvider.players[index];
                      // bool isCurrentPlayer = index == gameProvider.currentPlayerIndex; // Unused
                      bool isCurrentPlayer =
                          (gameProvider.currentPlayer.id == player.id);
                      // Fixed logic: currentPlayerIndex might mismatch list order if we didn't rely on it.
                      // But gameProvider uses list index. So index == currentPlayerIndex is safer if synced.
                      // Let's stick to GameProvider logic:
                      isCurrentPlayer =
                          index == gameProvider.currentPlayerIndex;

                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 8),
                        child: _buildPlayerCard(
                          context,
                          player,
                          isCurrentPlayer,
                          gameProvider,
                        ),
                      );
                    },
                  ),
                ),

                // Game Message
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildGameMessage(gameProvider),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        // Header
        _buildHeader(context, gameProvider, isMobile: false),

        Expanded(
          child: Row(
            children: [
              // Left: Player Info
              Expanded(flex: 2, child: PlayerInfoPanel()),

              // Center: Board and Controls
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: BoardWidget(),
                          ),
                        ),
                      ),
                    ),

                    // Dice and Controls
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DiceWidget(),
                          const SizedBox(height: 16),
                          GameControls(),
                          const SizedBox(height: 8),
                          _buildGameMessage(gameProvider),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Desktop Layout (Original)
  Widget _buildDesktopLayout(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        // Header
        _buildHeader(context, gameProvider, isMobile: false),

        // Main Game Area
        Expanded(
          child: Row(
            children: [
              // Left Panel - Player Info
              Expanded(flex: 2, child: PlayerInfoPanel()),

              // Center - Game Board
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: BoardWidget(),
                        ),
                      ),
                    ),

                    // Dice and Controls
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DiceWidget(),
                          const SizedBox(height: 20),
                          GameControls(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right Panel - Game Info
              Expanded(flex: 2, child: _buildGameInfoPanel(gameProvider)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GameProvider gameProvider, {
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _showExitDialog(context);
            },
          ),
          if (!isMobile) ...[
            const SizedBox(width: 16),
            const Icon(Icons.account_balance, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            const Text(
              'MONOPOLY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: isMobile ? 6 : 10,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  color: gameProvider.currentPlayer.color,
                  size: isMobile ? 16 : 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isMobile
                      ? gameProvider.currentPlayer.name
                      : '${gameProvider.currentPlayer.name}\'s Turn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameMessage(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Text(
        gameProvider.gameMessage,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    player,
    bool isCurrentPlayer,
    GameProvider gameProvider,
  ) {
    return GestureDetector(
      onTap: () {
        // Show properties dialog on tap
        if (player.properties.isNotEmpty) {
          _showPlayerPropertiesDialog(context, player, gameProvider);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCurrentPlayer
                ? [player.color.withOpacity(0.4), player.color.withOpacity(0.2)]
                : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentPlayer
                ? player.color
                : Colors.white.withOpacity(0.2),
            width: isCurrentPlayer ? 3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: player.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(player.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: Colors.greenAccent,
                    size: 16,
                  ),
                  Text(
                    '${player.money}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Properties button
            if (player.properties.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${player.properties.length} Properties',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 10,
                    ),
                  ],
                ),
              )
            else
              Text(
                'No Properties',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPlayerPropertiesDialog(
    BuildContext context,
    player,
    GameProvider gameProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                player.color.withOpacity(0.8),
                player.color.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: player.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(player.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${player.money}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Properties List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: player.properties.length,
                  itemBuilder: (context, index) {
                    String propertyName = player.properties[index];
                    var space = gameProvider.boardSpaces.firstWhere(
                      (s) => s.property?.name == propertyName,
                    );
                    var property = space.property!;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        children: [
                          // Color header for streets
                          if (property.type == PropertyType.street)
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: property.color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),

                          // Property info
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rent: \$${property.getCurrentRent()}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    if (property.houses > 0)
                                      Row(
                                        children: [
                                          Icon(
                                            property.houses == 5
                                                ? Icons.hotel
                                                : Icons.home,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            property.houses == 5
                                                ? 'Hotel'
                                                : '${property.houses}H',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfoPanel(GameProvider gameProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Game Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Game Message
          _buildGameMessage(gameProvider),

          const SizedBox(height: 20),

          // Quick Stats
          _buildStatRow(
            'Active Players',
            '${gameProvider.players.where((p) => !p.isBankrupt).length}',
          ),
          _buildStatRow(
            'Total Properties',
            '${gameProvider.boardSpaces.length}',
          ),

          const Spacer(),

          // Legend
          const Text(
            'Property Colors',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildColorLegend('Brown', const Color(0xFF8B4513)),
          _buildColorLegend('Light Blue', const Color(0xFF87CEEB)),
          _buildColorLegend('Pink', const Color(0xFFFF1493)),
          _buildColorLegend('Orange', Colors.orange),
          _buildColorLegend('Red', Colors.red),
          _buildColorLegend('Yellow', Colors.yellow),
          _buildColorLegend('Green', Colors.green),
          _buildColorLegend('Dark Blue', Colors.blue[900]!),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorLegend(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('EXIT'),
          ),
        ],
      ),
    );
  }
}

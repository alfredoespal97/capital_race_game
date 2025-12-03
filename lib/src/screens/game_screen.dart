
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:myapp/src/widgets/educational_popup.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/game/capital_race_game.dart';
import 'package:myapp/src/models/bot_profile.dart';
import 'package:myapp/src/widgets/player_hud.dart';
import 'package:myapp/src/game_state.dart';
import 'package:myapp/src/widgets/buy_dialog.dart';

class GameScreenWrapper extends StatelessWidget {
  final BotProfile botProfile;

  const GameScreenWrapper({super.key, required this.botProfile});

  @override
  Widget build(BuildContext context) {
    final game = CapitalRaceGame(botProfile: botProfile);
    globalGameState = GameState(game: game);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: globalGameState),
        ChangeNotifierProvider.value(value: game.player1),
        ChangeNotifierProvider.value(value: game.bot),
      ],
      child: GameScreen(game: game),
    );
  }
}

class GameScreen extends StatefulWidget {
  final CapitalRaceGame game;
  const GameScreen({super.key, required this.game});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: widget.game),

          PlayerHud(
            player: widget.game.player1,
            avatarAsset: 'assets/images/player_avatar.svg',
            alignment: Alignment.topLeft,
          ),
          PlayerHud(
            player: widget.game.bot,
            avatarAsset: 'assets/images/bot_avatar.svg',
            alignment: Alignment.topRight,
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
              onPressed: () {
                // Bloquear el dado si hay algún popup en pantalla
                if (gameState.propertyToBuy == null && gameState.educationalContentToShow == null) {
                  widget.game.rollDiceAndMove();
                }
              },
              child: const Text('Lanzar Dados', style: TextStyle(fontSize: 16)),
            ),
          ),

          // Popup para comprar propiedades
          if (gameState.propertyToBuy != null)
            BuyDialog(
              property: gameState.propertyToBuy!,
              onBuy: (property) => widget.game.buyProperty(property),
              onDecline: () => widget.game.declineProperty(),
            ),

          // Popup educativo
          if (gameState.educationalContentToShow != null)
            EducationalPopup(
              content: gameState.educationalContentToShow!,
              onDismiss: () => globalGameState.dismissEducationalContent(),
            ),
        ],
      ),
    );
  }
}

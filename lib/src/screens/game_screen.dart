
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:capital_race/src/widgets/educational_popup.dart';
import 'package:provider/provider.dart';

import 'package:capital_race/src/game/capital_race_game.dart';
import 'package:capital_race/src/models/bot_profile.dart';
import 'package:capital_race/src/widgets/player_hud.dart';
import 'package:capital_race/src/game_state.dart';
import 'package:capital_race/src/widgets/buy_dialog.dart';

class GameScreenWrapper extends StatelessWidget {
  final BotProfile botProfile;

  const GameScreenWrapper({super.key, required this.botProfile});

  @override
  Widget build(BuildContext context) {
    final game = CapitalRaceGame(botProfile: botProfile);
    globalGameState = GameState(game: game);
    game.globalGameState = globalGameState;

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
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          GameWidget(game: widget.game),

          const PlayerHUD(),

          if (gameState.propertyToBuy != null)
            BuyDialog(
              property: gameState.propertyToBuy!,
              onBuy: () {
                widget.game.playerBuyProperty();
              },
              onDecline: () {
                widget.game.playerPassProperty();
              },
            ),
          
          if (gameState.educationalContentToShow != null)
            EducationalPopup(
              content: gameState.educationalContentToShow!,
              onDismiss: () {
                gameState.clearEducationalContent();
              },
            ),
        ],
      ),
    );
  }
}

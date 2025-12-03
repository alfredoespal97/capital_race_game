
import 'package:flutter/material.dart';
import 'package:myapp/src/game/capital_race_game.dart';
import 'package:myapp/src/models/property.dart';
import 'package:myapp/src/models/educational_content.dart';

// Referencia global al GameState para poder acceder desde el juego
late final GameState globalGameState;

class GameState with ChangeNotifier {
  final CapitalRaceGame game;
  Property? _propertyToBuy;
  EducationalContent? educationalContentToShow;

  GameState({required this.game});

  Property? get propertyToBuy => _propertyToBuy;

  void setPropertyToBuy(Property? property) {
    _propertyToBuy = property;
    notifyListeners();
  }

  void buildHouse(Property property) {
    game.buildHouseOnProperty(property);
    notifyListeners();
  }

  void setEducationalContent(EducationalContent? content) {
    educationalContentToShow = content;
    notifyListeners();
  }

  void dismissEducationalContent() {
    final wasPlayerTurnAction = game.currentTurn == Turn.bot;

    educationalContentToShow = null;
    notifyListeners();

    // Si el popup apareció tras una acción del jugador (como comprar),
    // ahora es el momento de ceder el turno al bot.
    if (wasPlayerTurnAction) {
      game.declineProperty(); // Usamos esto para pasar el turno de forma segura.
    }
  }
}


import 'package:flutter/material.dart';
import 'package:capital_race/src/game/capital_race_game.dart';
import 'package:capital_race/src/models/property.dart';
import 'package:capital_race/src/models/educational_content.dart';

// Referencia global al GameState para poder acceder desde el juego
late final GameState globalGameState;

class GameState with ChangeNotifier {
  final CapitalRaceGame game;
  Property? _propertyToBuy;
  EducationalContent? _educationalContentToShow;

  GameState({required this.game});

  Property? get propertyToBuy => _propertyToBuy;
  EducationalContent? get educationalContentToShow => _educationalContentToShow;

  void setPropertyToBuy(Property? property) {
    _propertyToBuy = property;
    notifyListeners();
  }
  
  void clearPropertyToBuy() {
    _propertyToBuy = null;
    notifyListeners();
  }

  void setEducationalContent(EducationalContent? content) {
    _educationalContentToShow = content;
    notifyListeners();
  }

  void clearEducationalContent() {
    final wasShowingContent = _educationalContentToShow != null;
    _educationalContentToShow = null;
    notifyListeners();

    if (wasShowingContent && _propertyToBuy == null) {
      game.playerPassProperty();
    }
  }
}


import 'package:flutter/material.dart';

import 'package:capital_race/src/models/player.dart';
import 'package:capital_race/src/models/property.dart';
import 'package:capital_race/src/models/bot_profile.dart';

class BotPlayer extends Player {
  final BotProfile profile;

  BotPlayer({
    required String name,
    required double capital,
    required Color pieceColor,
    required this.profile,
  }) : super(name: name, capital: capital, pieceColor: pieceColor);

  bool shouldBuyProperty(Property property, List<Property> allProperties) {
    if (capital < property.price) {
      return false;
    }
    if ((capital - property.price) < profile.liquidityThreshold) {
      return false;
    }
    final double ve = _calculateExpectedValue(property, allProperties);
    return ve > profile.purchaseThreshold;
  }

  double _calculateExpectedValue(Property property, List<Property> allProperties) {
    final double sectorRentability = property.rentByHouseCount.first.toDouble();
    final double monopolyBonus = _calculateMonopolyBonus(property, allProperties);
    final double sectorFactor = profile.sectorFactor;

    final double potentialBenefit = (sectorRentability * sectorFactor) + monopolyBonus;
    final double expectedValue = potentialBenefit - property.price;
    
    return expectedValue;
  }

  double _calculateMonopolyBonus(Property property, List<Property> allProperties) {
    final String sector = property.sector;
    final int totalPropertiesInSector = allProperties.where((p) => p.sector == sector).length;
    if (totalPropertiesInSector <= 1) return 0.0;

    final int ownedInSector = ownedProperties.where((p) => p.sector == sector).length;
    final double bonusFactor = (profile.sectorFactor - 1.0);
    if (bonusFactor <= 0) return 0.0;

    if (ownedInSector == totalPropertiesInSector - 1) {
      return property.price * bonusFactor;
    }
    if (totalPropertiesInSector > 2 && ownedInSector == totalPropertiesInSector - 2) {
      return property.price * (bonusFactor / 2.5);
    }
    return 0.0;
  }

  /// La decisión de construir ahora se basa en la lógica centralizada en Player,
  /// pero con una capa de decisión del perfil del bot.
  bool shouldBuildHouse(Property property, List<Property> allProperties) {
    // Primero, usa la lógica base para ver si es posible construir.
    if (!canBuildHouse(property, allProperties)) {
      return false;
    }
    
    // Luego, aplica la estrategia del bot.
    // ¿El capital restante supera el umbral de liquidez del bot?
    if ((capital - property.houseCost) < profile.liquidityThreshold) {
      return false;
    }

    // Finalmente, el factor de riesgo. Un bot agresivo (alto riskFactor) construirá.
    return profile.riskFactor > 0.5;
  }
}

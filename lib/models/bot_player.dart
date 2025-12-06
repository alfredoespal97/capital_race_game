import 'package:flutter/material.dart';
import 'dart:async';
import 'player.dart';

enum BotDifficulty { easy, medium, hard }

class BotPlayer extends Player {
  final BotDifficulty difficulty;

  BotPlayer({
    required super.id,
    required super.name,
    required super.color,
    required super.icon,
    required this.difficulty,
    super.money,
    super.position,
    super.properties,
    super.isInJail,
    super.jailTurns,
    super.getOutOfJailCards,
    super.isBankrupt,
  });

  // Bot decision making methods

  bool shouldBuyProperty(int propertyPrice, int currentMoney) {
    switch (difficulty) {
      case BotDifficulty.easy:
        // Easy bot: Buy if has enough money with 50% buffer
        return currentMoney >= propertyPrice * 1.5;

      case BotDifficulty.medium:
        // Medium bot: Buy if has enough money with 30% buffer
        return currentMoney >= propertyPrice * 1.3;

      case BotDifficulty.hard:
        // Hard bot: Buy if has enough money with 20% buffer
        // Also considers strategic value
        return currentMoney >= propertyPrice * 1.2;
    }
  }

  bool shouldBuildHouse(int housePrice, int currentMoney, bool hasMonopoly) {
    if (!hasMonopoly) return false;

    switch (difficulty) {
      case BotDifficulty.easy:
        // Easy bot: Build if has plenty of money
        return currentMoney >= housePrice * 3;

      case BotDifficulty.medium:
        // Medium bot: Build more aggressively
        return currentMoney >= housePrice * 2;

      case BotDifficulty.hard:
        // Hard bot: Build very aggressively
        return currentMoney >= housePrice * 1.5;
    }
  }

  bool shouldPayToLeaveJail(int currentMoney, int turnsInJail) {
    switch (difficulty) {
      case BotDifficulty.easy:
        // Easy bot: Only pays on last turn
        return turnsInJail >= 2 && currentMoney >= 100;

      case BotDifficulty.medium:
        // Medium bot: Pays if has good money
        return currentMoney >= 300;

      case BotDifficulty.hard:
        // Hard bot: Pays early to keep playing
        return turnsInJail >= 1 && currentMoney >= 200;
    }
  }

  String getPropertyToBuild(
    List<String> ownedProperties,
    Map<String, dynamic> propertyData,
  ) {
    // Returns the property name where the bot should build
    // For now, just return the first property that can be built on
    if (ownedProperties.isEmpty) return '';

    switch (difficulty) {
      case BotDifficulty.easy:
        // Random selection
        return ownedProperties.first;

      case BotDifficulty.medium:
      case BotDifficulty.hard:
        // Prefer properties with higher rent potential
        // For now, just return first property
        return ownedProperties.first;
    }
  }

  int getThinkingDelay() {
    // Delay in milliseconds before bot makes a decision
    switch (difficulty) {
      case BotDifficulty.easy:
        return 2000; // 2 seconds
      case BotDifficulty.medium:
        return 1500; // 1.5 seconds
      case BotDifficulty.hard:
        return 1000; // 1 second
    }
  }

  void decideToBuy(dynamic property, dynamic gameProvider) {
    // Using dynamic to avoid circular dependencies if possible
    // Assuming gameProvider has buyProperty() and endTurn()

    // Using Future.delayed to simulate thinking
    Future.delayed(Duration(milliseconds: getThinkingDelay()), () {
      if (shouldBuyProperty(property.price, money)) {
        gameProvider.buyProperty();

        // Add a small delay after buying to show the action results
        Future.delayed(const Duration(milliseconds: 1000), () {
          gameProvider.endTurn();
        });
      } else {
        // Did not buy, just end turn implicitly
        gameProvider.endTurn();
      }
    });
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['type'] = 'bot';
    json['difficulty'] = difficulty.index;
    return json;
  }

  factory BotPlayer.fromJson(Map<String, dynamic> json) {
    return BotPlayer(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      difficulty: BotDifficulty.values[json['difficulty']],
      money: json['money'],
      position: json['position'],
      properties: List<String>.from(json['properties']),
      isInJail: json['isInJail'],
      jailTurns: json['jailTurns'],
      getOutOfJailCards: json['getOutOfJailCards'],
      isBankrupt: json['isBankrupt'],
    );
  }
}

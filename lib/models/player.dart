import 'package:flutter/material.dart';

class Player {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  int money;
  int position;
  List<String> properties;
  bool isInJail;
  int jailTurns;
  int getOutOfJailCards;
  bool isBankrupt;

  Player({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.money = 1500,
    this.position = 0,
    List<String>? properties,
    this.isInJail = false,
    this.jailTurns = 0,
    this.getOutOfJailCards = 0,
    this.isBankrupt = false,
  }) : properties = properties ?? [];

  void addMoney(int amount) {
    money += amount;
  }

  void subtractMoney(int amount) {
    money -= amount;
    if (money < 0) {
      isBankrupt = true;
    }
  }

  void addProperty(String propertyName) {
    if (!properties.contains(propertyName)) {
      properties.add(propertyName);
    }
  }

  void removeProperty(String propertyName) {
    properties.remove(propertyName);
  }

  void goToJail() {
    isInJail = true;
    position = 10; // Jail position
    jailTurns = 0;
  }

  void releaseFromJail() {
    isInJail = false;
    jailTurns = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'human',
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint, // Store codePoint for IconData
      'money': money,
      'position': position,
      'properties': properties,
      'isInJail': isInJail,
      'jailTurns': jailTurns,
      'getOutOfJailCards': getOutOfJailCards,
      'isBankrupt': isBankrupt,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
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

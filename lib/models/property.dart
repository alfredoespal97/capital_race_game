import 'package:flutter/material.dart';

class Property {
  final String name;
  final int position;
  final PropertyType type;
  final int price;
  final int rent;
  final List<int> rentWithHouses; // Rent with 1, 2, 3, 4 houses and hotel
  final int housePrice;
  final PropertyGroup group;
  final Color color;

  String? owner;
  int houses;
  bool isMortgaged;

  Property({
    required this.name,
    required this.position,
    required this.type,
    required this.price,
    required this.rent,
    required this.rentWithHouses,
    required this.housePrice,
    required this.group,
    required this.color,
    this.owner,
    this.houses = 0,
    this.isMortgaged = false,
  });

  int getCurrentRent() {
    if (isMortgaged) return 0;
    if (houses == 0) return rent;
    if (houses <= 5) return rentWithHouses[houses - 1];
    return rentWithHouses[4]; // Hotel
  }

  int getMortgageValue() => price ~/ 2;
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'houses': houses,
      'isMortgaged': isMortgaged,
    };
  }

  void updateFromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    houses = json['houses'] ?? 0;
    isMortgaged = json['isMortgaged'] ?? false;
  }
}

enum PropertyType { street, railroad, utility, special }

enum PropertyGroup {
  brown,
  lightBlue,
  pink,
  orange,
  red,
  yellow,
  green,
  darkBlue,
  railroad,
  utility,
  special,
}

class BoardSpace {
  final String name;
  final int position;
  final SpaceType type;
  final Property? property;
  final String? action;

  BoardSpace({
    required this.name,
    required this.position,
    required this.type,
    this.property,
    this.action,
  });
}

enum SpaceType {
  property,
  railroad,
  utility,
  chance,
  communityChest,
  tax,
  corner, // GO, Jail, Free Parking, Go to Jail
}

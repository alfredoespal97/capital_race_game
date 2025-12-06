import 'package:flutter/material.dart';
import '../models/property.dart';

class BoardData {
  static List<BoardSpace> getBoardSpaces() {
    return [
      // Position 0: GO
      BoardSpace(
        name: 'GO',
        position: 0,
        type: SpaceType.corner,
        action: 'collect_200',
      ),
      
      // Position 1: Mediterranean Avenue
      BoardSpace(
        name: 'Mediterranean Avenue',
        position: 1,
        type: SpaceType.property,
        property: Property(
          name: 'Mediterranean Avenue',
          position: 1,
          type: PropertyType.street,
          price: 60,
          rent: 2,
          rentWithHouses: [10, 30, 90, 160, 250],
          housePrice: 50,
          group: PropertyGroup.brown,
          color: const Color(0xFF8B4513),
        ),
      ),
      
      // Position 2: Community Chest
      BoardSpace(
        name: 'Community Chest',
        position: 2,
        type: SpaceType.communityChest,
      ),
      
      // Position 3: Baltic Avenue
      BoardSpace(
        name: 'Baltic Avenue',
        position: 3,
        type: SpaceType.property,
        property: Property(
          name: 'Baltic Avenue',
          position: 3,
          type: PropertyType.street,
          price: 60,
          rent: 4,
          rentWithHouses: [20, 60, 180, 320, 450],
          housePrice: 50,
          group: PropertyGroup.brown,
          color: const Color(0xFF8B4513),
        ),
      ),
      
      // Position 4: Income Tax
      BoardSpace(
        name: 'Income Tax',
        position: 4,
        type: SpaceType.tax,
        action: 'pay_200',
      ),
      
      // Position 5: Reading Railroad
      BoardSpace(
        name: 'Reading Railroad',
        position: 5,
        type: SpaceType.railroad,
        property: Property(
          name: 'Reading Railroad',
          position: 5,
          type: PropertyType.railroad,
          price: 200,
          rent: 25,
          rentWithHouses: [50, 100, 200, 0, 0],
          housePrice: 0,
          group: PropertyGroup.railroad,
          color: Colors.black,
        ),
      ),
      
      // Position 6: Oriental Avenue
      BoardSpace(
        name: 'Oriental Avenue',
        position: 6,
        type: SpaceType.property,
        property: Property(
          name: 'Oriental Avenue',
          position: 6,
          type: PropertyType.street,
          price: 100,
          rent: 6,
          rentWithHouses: [30, 90, 270, 400, 550],
          housePrice: 50,
          group: PropertyGroup.lightBlue,
          color: const Color(0xFF87CEEB),
        ),
      ),
      
      // Position 7: Chance
      BoardSpace(
        name: 'Chance',
        position: 7,
        type: SpaceType.chance,
      ),
      
      // Position 8: Vermont Avenue
      BoardSpace(
        name: 'Vermont Avenue',
        position: 8,
        type: SpaceType.property,
        property: Property(
          name: 'Vermont Avenue',
          position: 8,
          type: PropertyType.street,
          price: 100,
          rent: 6,
          rentWithHouses: [30, 90, 270, 400, 550],
          housePrice: 50,
          group: PropertyGroup.lightBlue,
          color: const Color(0xFF87CEEB),
        ),
      ),
      
      // Position 9: Connecticut Avenue
      BoardSpace(
        name: 'Connecticut Avenue',
        position: 9,
        type: SpaceType.property,
        property: Property(
          name: 'Connecticut Avenue',
          position: 9,
          type: PropertyType.street,
          price: 120,
          rent: 8,
          rentWithHouses: [40, 100, 300, 450, 600],
          housePrice: 50,
          group: PropertyGroup.lightBlue,
          color: const Color(0xFF87CEEB),
        ),
      ),
      
      // Position 10: Jail (Just Visiting)
      BoardSpace(
        name: 'Jail',
        position: 10,
        type: SpaceType.corner,
      ),
      
      // Position 11: St. Charles Place
      BoardSpace(
        name: 'St. Charles Place',
        position: 11,
        type: SpaceType.property,
        property: Property(
          name: 'St. Charles Place',
          position: 11,
          type: PropertyType.street,
          price: 140,
          rent: 10,
          rentWithHouses: [50, 150, 450, 625, 750],
          housePrice: 100,
          group: PropertyGroup.pink,
          color: const Color(0xFFFF1493),
        ),
      ),
      
      // Position 12: Electric Company
      BoardSpace(
        name: 'Electric Company',
        position: 12,
        type: SpaceType.utility,
        property: Property(
          name: 'Electric Company',
          position: 12,
          type: PropertyType.utility,
          price: 150,
          rent: 0, // 4x or 10x dice roll
          rentWithHouses: [0, 0, 0, 0, 0],
          housePrice: 0,
          group: PropertyGroup.utility,
          color: Colors.yellow,
        ),
      ),
      
      // Position 13: States Avenue
      BoardSpace(
        name: 'States Avenue',
        position: 13,
        type: SpaceType.property,
        property: Property(
          name: 'States Avenue',
          position: 13,
          type: PropertyType.street,
          price: 140,
          rent: 10,
          rentWithHouses: [50, 150, 450, 625, 750],
          housePrice: 100,
          group: PropertyGroup.pink,
          color: const Color(0xFFFF1493),
        ),
      ),
      
      // Position 14: Virginia Avenue
      BoardSpace(
        name: 'Virginia Avenue',
        position: 14,
        type: SpaceType.property,
        property: Property(
          name: 'Virginia Avenue',
          position: 14,
          type: PropertyType.street,
          price: 160,
          rent: 12,
          rentWithHouses: [60, 180, 500, 700, 900],
          housePrice: 100,
          group: PropertyGroup.pink,
          color: const Color(0xFFFF1493),
        ),
      ),
      
      // Position 15: Pennsylvania Railroad
      BoardSpace(
        name: 'Pennsylvania Railroad',
        position: 15,
        type: SpaceType.railroad,
        property: Property(
          name: 'Pennsylvania Railroad',
          position: 15,
          type: PropertyType.railroad,
          price: 200,
          rent: 25,
          rentWithHouses: [50, 100, 200, 0, 0],
          housePrice: 0,
          group: PropertyGroup.railroad,
          color: Colors.black,
        ),
      ),
      
      // Position 16: St. James Place
      BoardSpace(
        name: 'St. James Place',
        position: 16,
        type: SpaceType.property,
        property: Property(
          name: 'St. James Place',
          position: 16,
          type: PropertyType.street,
          price: 180,
          rent: 14,
          rentWithHouses: [70, 200, 550, 750, 950],
          housePrice: 100,
          group: PropertyGroup.orange,
          color: Colors.orange,
        ),
      ),
      
      // Position 17: Community Chest
      BoardSpace(
        name: 'Community Chest',
        position: 17,
        type: SpaceType.communityChest,
      ),
      
      // Position 18: Tennessee Avenue
      BoardSpace(
        name: 'Tennessee Avenue',
        position: 18,
        type: SpaceType.property,
        property: Property(
          name: 'Tennessee Avenue',
          position: 18,
          type: PropertyType.street,
          price: 180,
          rent: 14,
          rentWithHouses: [70, 200, 550, 750, 950],
          housePrice: 100,
          group: PropertyGroup.orange,
          color: Colors.orange,
        ),
      ),
      
      // Position 19: New York Avenue
      BoardSpace(
        name: 'New York Avenue',
        position: 19,
        type: SpaceType.property,
        property: Property(
          name: 'New York Avenue',
          position: 19,
          type: PropertyType.street,
          price: 200,
          rent: 16,
          rentWithHouses: [80, 220, 600, 800, 1000],
          housePrice: 100,
          group: PropertyGroup.orange,
          color: Colors.orange,
        ),
      ),
      
      // Position 20: Free Parking
      BoardSpace(
        name: 'Free Parking',
        position: 20,
        type: SpaceType.corner,
      ),
      
      // Position 21: Kentucky Avenue
      BoardSpace(
        name: 'Kentucky Avenue',
        position: 21,
        type: SpaceType.property,
        property: Property(
          name: 'Kentucky Avenue',
          position: 21,
          type: PropertyType.street,
          price: 220,
          rent: 18,
          rentWithHouses: [90, 250, 700, 875, 1050],
          housePrice: 150,
          group: PropertyGroup.red,
          color: Colors.red,
        ),
      ),
      
      // Position 22: Chance
      BoardSpace(
        name: 'Chance',
        position: 22,
        type: SpaceType.chance,
      ),
      
      // Position 23: Indiana Avenue
      BoardSpace(
        name: 'Indiana Avenue',
        position: 23,
        type: SpaceType.property,
        property: Property(
          name: 'Indiana Avenue',
          position: 23,
          type: PropertyType.street,
          price: 220,
          rent: 18,
          rentWithHouses: [90, 250, 700, 875, 1050],
          housePrice: 150,
          group: PropertyGroup.red,
          color: Colors.red,
        ),
      ),
      
      // Position 24: Illinois Avenue
      BoardSpace(
        name: 'Illinois Avenue',
        position: 24,
        type: SpaceType.property,
        property: Property(
          name: 'Illinois Avenue',
          position: 24,
          type: PropertyType.street,
          price: 240,
          rent: 20,
          rentWithHouses: [100, 300, 750, 925, 1100],
          housePrice: 150,
          group: PropertyGroup.red,
          color: Colors.red,
        ),
      ),
      
      // Position 25: B&O Railroad
      BoardSpace(
        name: 'B&O Railroad',
        position: 25,
        type: SpaceType.railroad,
        property: Property(
          name: 'B&O Railroad',
          position: 25,
          type: PropertyType.railroad,
          price: 200,
          rent: 25,
          rentWithHouses: [50, 100, 200, 0, 0],
          housePrice: 0,
          group: PropertyGroup.railroad,
          color: Colors.black,
        ),
      ),
      
      // Position 26: Atlantic Avenue
      BoardSpace(
        name: 'Atlantic Avenue',
        position: 26,
        type: SpaceType.property,
        property: Property(
          name: 'Atlantic Avenue',
          position: 26,
          type: PropertyType.street,
          price: 260,
          rent: 22,
          rentWithHouses: [110, 330, 800, 975, 1150],
          housePrice: 150,
          group: PropertyGroup.yellow,
          color: Colors.yellow,
        ),
      ),
      
      // Position 27: Ventnor Avenue
      BoardSpace(
        name: 'Ventnor Avenue',
        position: 27,
        type: SpaceType.property,
        property: Property(
          name: 'Ventnor Avenue',
          position: 27,
          type: PropertyType.street,
          price: 260,
          rent: 22,
          rentWithHouses: [110, 330, 800, 975, 1150],
          housePrice: 150,
          group: PropertyGroup.yellow,
          color: Colors.yellow,
        ),
      ),
      
      // Position 28: Water Works
      BoardSpace(
        name: 'Water Works',
        position: 28,
        type: SpaceType.utility,
        property: Property(
          name: 'Water Works',
          position: 28,
          type: PropertyType.utility,
          price: 150,
          rent: 0, // 4x or 10x dice roll
          rentWithHouses: [0, 0, 0, 0, 0],
          housePrice: 0,
          group: PropertyGroup.utility,
          color: Colors.yellow,
        ),
      ),
      
      // Position 29: Marvin Gardens
      BoardSpace(
        name: 'Marvin Gardens',
        position: 29,
        type: SpaceType.property,
        property: Property(
          name: 'Marvin Gardens',
          position: 29,
          type: PropertyType.street,
          price: 280,
          rent: 24,
          rentWithHouses: [120, 360, 850, 1025, 1200],
          housePrice: 150,
          group: PropertyGroup.yellow,
          color: Colors.yellow,
        ),
      ),
      
      // Position 30: Go to Jail
      BoardSpace(
        name: 'Go to Jail',
        position: 30,
        type: SpaceType.corner,
        action: 'go_to_jail',
      ),
      
      // Position 31: Pacific Avenue
      BoardSpace(
        name: 'Pacific Avenue',
        position: 31,
        type: SpaceType.property,
        property: Property(
          name: 'Pacific Avenue',
          position: 31,
          type: PropertyType.street,
          price: 300,
          rent: 26,
          rentWithHouses: [130, 390, 900, 1100, 1275],
          housePrice: 200,
          group: PropertyGroup.green,
          color: Colors.green,
        ),
      ),
      
      // Position 32: North Carolina Avenue
      BoardSpace(
        name: 'North Carolina Avenue',
        position: 32,
        type: SpaceType.property,
        property: Property(
          name: 'North Carolina Avenue',
          position: 32,
          type: PropertyType.street,
          price: 300,
          rent: 26,
          rentWithHouses: [130, 390, 900, 1100, 1275],
          housePrice: 200,
          group: PropertyGroup.green,
          color: Colors.green,
        ),
      ),
      
      // Position 33: Community Chest
      BoardSpace(
        name: 'Community Chest',
        position: 33,
        type: SpaceType.communityChest,
      ),
      
      // Position 34: Pennsylvania Avenue
      BoardSpace(
        name: 'Pennsylvania Avenue',
        position: 34,
        type: SpaceType.property,
        property: Property(
          name: 'Pennsylvania Avenue',
          position: 34,
          type: PropertyType.street,
          price: 320,
          rent: 28,
          rentWithHouses: [150, 450, 1000, 1200, 1400],
          housePrice: 200,
          group: PropertyGroup.green,
          color: Colors.green,
        ),
      ),
      
      // Position 35: Short Line Railroad
      BoardSpace(
        name: 'Short Line',
        position: 35,
        type: SpaceType.railroad,
        property: Property(
          name: 'Short Line',
          position: 35,
          type: PropertyType.railroad,
          price: 200,
          rent: 25,
          rentWithHouses: [50, 100, 200, 0, 0],
          housePrice: 0,
          group: PropertyGroup.railroad,
          color: Colors.black,
        ),
      ),
      
      // Position 36: Chance
      BoardSpace(
        name: 'Chance',
        position: 36,
        type: SpaceType.chance,
      ),
      
      // Position 37: Park Place
      BoardSpace(
        name: 'Park Place',
        position: 37,
        type: SpaceType.property,
        property: Property(
          name: 'Park Place',
          position: 37,
          type: PropertyType.street,
          price: 350,
          rent: 35,
          rentWithHouses: [175, 500, 1100, 1300, 1500],
          housePrice: 200,
          group: PropertyGroup.darkBlue,
          color: Colors.blue[900]!,
        ),
      ),
      
      // Position 38: Luxury Tax
      BoardSpace(
        name: 'Luxury Tax',
        position: 38,
        type: SpaceType.tax,
        action: 'pay_100',
      ),
      
      // Position 39: Boardwalk
      BoardSpace(
        name: 'Boardwalk',
        position: 39,
        type: SpaceType.property,
        property: Property(
          name: 'Boardwalk',
          position: 39,
          type: PropertyType.street,
          price: 400,
          rent: 50,
          rentWithHouses: [200, 600, 1400, 1700, 2000],
          housePrice: 200,
          group: PropertyGroup.darkBlue,
          color: Colors.blue[900]!,
        ),
      ),
    ];
  }
}

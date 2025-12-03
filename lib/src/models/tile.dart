
import 'package:capital_race/src/models/property.dart';

abstract class Tile {
  String get name;
}

class PropertyTile extends Tile {
  final Property property;

  PropertyTile({required this.property});

  @override
  String get name => property.name;
}

class EventTile extends Tile {
  @override
  final String name;

  EventTile({required this.name});
}

class SpecialTile extends Tile {
  @override
  final String name;

  SpecialTile({required this.name});
}

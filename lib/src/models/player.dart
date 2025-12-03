
import 'package:flutter/material.dart';
import 'package:capital_race/src/models/property.dart';

class Player with ChangeNotifier {
  final String name;
  final Color pieceColor;
  double _capital;
  final List<Property> _ownedProperties; // Renombrado para claridad interna

  Player({
    required this.name, 
    required double capital, 
    required this.pieceColor,
    List<Property>? properties
  }) : _capital = capital,
       _ownedProperties = properties ?? [];

  double get capital => _capital;
  
  // El getter público para acceder a la lista de propiedades.
  List<Property> get ownedProperties => _ownedProperties;

  set capital(double value) {
    _capital = value;
    notifyListeners();
  }

  void addProperty(Property property) {
    _ownedProperties.add(property);
    property.owner = this;
    notifyListeners();
  }

  void removeProperty(Property property) {
    _ownedProperties.remove(property);
    property.owner = null;
    notifyListeners();
  }

  /// Lógica de construcción centralizada. Determina si se puede construir en una propiedad.
  bool canBuildHouse(Property property, List<Property> allProperties) {
    if (!_ownedProperties.contains(property)) return false;
    if (property.isFullyDeveloped) return false;
    if (capital < property.houseCost) return false;

    // Comprobar monopolio
    final propertiesInSector = allProperties.where((p) => p.sector == property.sector);
    final ownedInSector = _ownedProperties.where((p) => p.sector == property.sector);
    if (propertiesInSector.length != ownedInSector.length) return false;

    return true;
  }

  /// Ejecuta la construcción de una casa en una propiedad.
  void buildHouse(Property property, List<Property> allProperties) {
    if (canBuildHouse(property, allProperties)) {
      capital -= property.houseCost;
      property.houseCount++;
      notifyListeners();
    }
  }
}

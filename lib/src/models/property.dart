
import 'package:myapp/src/models/player.dart';

class Property {
  final String name;
  final double price;
  final String sector;
  final int houseCost;
  final List<double> rentByHouseCount;

  Player? owner;
  int houseCount = 0;

  Property({
    required this.name,
    required this.price,
    required this.sector,
    required this.houseCost,
    required this.rentByHouseCount,
    this.owner,
  });

  /// Devuelve el alquiler actual basado en el número de casas.
  double get currentRent {
    if (owner == null) return 0;
    // Si tiene 0 casas, el alquiler es el primero de la lista. Si tiene 1 casa, el segundo, etc.
    if (houseCount < rentByHouseCount.length) {
      return rentByHouseCount[houseCount];
    } else {
      // Como fallback, si por alguna razón houseCount excede el límite, devolver el máximo alquiler.
      return rentByHouseCount.last;
    }
  }

  /// Indica si la propiedad ha alcanzado el máximo nivel de desarrollo.
  /// El número de casas es 0-indexed. El length de la lista de alquileres es el número total de estados.
  /// Por ej, una lista de 5 alquileres corresponde a 0, 1, 2, 3, 4 casas. El máximo es 4.
  bool get isFullyDeveloped {
    return houseCount >= rentByHouseCount.length - 1;
  }
}

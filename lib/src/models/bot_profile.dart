
// Perfiles de comportamiento para la IA del Bot

abstract class BotProfile {
  final String name;
  // Umbral para decidir si comprar directamente una propiedad.
  final double purchaseThreshold;
  // Umbral de efectivo mínimo que el bot intenta mantener después de una compra o construcción.
  final double liquidityThreshold;
  // Factor de riesgo para determinar la puja máxima en una subasta.
  final double riskFactor;
  // Factor de importancia del sector.
  final double sectorFactor;

  const BotProfile({
    required this.name,
    required this.purchaseThreshold,
    required this.liquidityThreshold,
    required this.riskFactor,
    required this.sectorFactor,
  });
}

class AggressiveBotProfile extends BotProfile {
  const AggressiveBotProfile() : super(
    name: 'Agresivo',
    purchaseThreshold: 0,       // Compra si el Valor Esperado es positivo
    liquidityThreshold: 200,    // Mantiene poco efectivo, invierte agresivamente
    riskFactor: 0.8,            // Arriesga hasta el 80% de su liquidez en una puja importante
    sectorFactor: 1.5,          // Da más importancia a completar sectores
  );
}

class BalancedBotProfile extends BotProfile {
  const BalancedBotProfile() : super(
    name: 'Equilibrado',
    purchaseThreshold: 100,     // Necesita un VE más alto para comprar
    liquidityThreshold: 500,    // Mantiene una reserva de efectivo moderada
    riskFactor: 0.6,            // Más cauteloso en las pujas
    sectorFactor: 1.2,
  );
}

class ConservativeBotProfile extends BotProfile {
  const ConservativeBotProfile() : super(
    name: 'Conservador',
    purchaseThreshold: 200,     // Muy selectivo con las compras
    liquidityThreshold: 800,    // Prioritiza tener mucho efectivo disponible
    riskFactor: 0.4,            // Arriesga muy poco en subastas
    sectorFactor: 1.0,          // Evalúa los sectores de forma estándar
  );
}

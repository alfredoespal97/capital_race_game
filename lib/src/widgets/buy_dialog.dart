
import 'package:flutter/material.dart';
import 'package:myapp/src/models/property.dart';

class BuyDialog extends StatelessWidget {
  final Property property;
  final Function(Property) onBuy;
  final VoidCallback onDecline;

  const BuyDialog({
    super.key, 
    required this.property,
    required this.onBuy,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Comprar ${property.name}?', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text('Sector: ${property.sector}'),
                Text('Precio: \$${property.price.toStringAsFixed(0)}'),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: onDecline,
                      child: const Text('No, gracias'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => onBuy(property),
                      child: const Text('¡Comprar!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/src/common_widgets/quantity_selector.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Asumiendo que tienes tus colores aquí

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.iconColor = AppColors.primary, // Color por defecto para los iconos
    this.backgroundColor = Colors.transparent, // Fondo transparente por defecto
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Para que no ocupe todo el ancho disponible
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove, size: iconSize, color: iconColor),
            padding: EdgeInsets.zero,
            constraints:
                BoxConstraints(), // Para quitar padding extra del IconButton
            onPressed: onDecrement,
            splashRadius: iconSize,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: iconSize, color: iconColor),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: onIncrement,
            splashRadius: iconSize,
          ),
        ],
      ),
    );
  }
}

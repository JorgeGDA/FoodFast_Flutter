import 'package:flutter/material.dart';

class AppColors {
  // Paleta de colores principal
  static const Color primary = Color(
    0xFFFF9800,
  ); // Naranja vibrante (similar al que teníamos)
  static const Color primaryDark = Color(0xFFF57C00); // Un naranja más oscuro
  static const Color primaryLight = Color(0xFFFFE0B2); // Un naranja claro

  // Colores de acento
  static const Color accent = Color(
    0xFF4CAF50,
  ); // Un verde para acciones positivas o destacados
  static const Color accentDark = Color(0xFF388E3C);
  static const Color accentLight = Color(0xFFC8E6C9);

  // Colores de texto
  static const Color textPrimary = Color(
    0xFF212121,
  ); // Negro principal para texto
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Gris para texto secundario o menos importante
  static const Color textOnPrimary =
      Colors.white; // Texto sobre fondos primarios (ej. botones naranjas)
  static const Color textOnAccent =
      Colors.white; // Texto sobre fondos de acento

  // Colores de fondo
  static const Color background = Color(
    0xFFF5F5F5,
  ); // Un gris muy claro para el fondo general
  static const Color surface = Colors.white; // Para tarjetas, diálogos, etc.

  // Otros colores
  static const Color error = Color(0xFFD32F2F); // Rojo para errores
  static const Color disabled = Color(
    0xFFBDBDBD,
  ); // Gris para elementos deshabilitados
  static const Color divider = Color(0xFFE0E0E0); // Color para separadores
}

import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importamos nuestros colores

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontFamily: 'Poppins', // Elegiremos una fuente moderna más adelante
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textOnPrimary, // Típicamente blanco sobre botón de color
    letterSpacing: 1.1,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Puedes añadir más estilos según necesites (ej. para precios, etiquetas, etc.)
  static const TextStyle price = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.accent, // Usamos el color de acento para precios
  );
}

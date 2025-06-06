// lib/src/features/favorites/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart'; // Para el color del AppBar

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Favoritos'),
        // backgroundColor: AppColors.primary, // Ya lo toma del tema global si está bien configurado
        // titleTextStyle: TextStyle(
        //   color: AppColors.textOnPrimary,
        //   fontSize: 20,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'Aún no tienes favoritos',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              '¡Marca tus platos preferidos para verlos aquí!',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

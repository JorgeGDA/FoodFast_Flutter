// lib/src/navigation/main_navigator.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart';
import 'package:food_app_portfolio/src/features/home/screens/home_screen.dart';
import 'package:food_app_portfolio/src/features/favorites/screens/favorites_screen.dart';
import 'package:food_app_portfolio/src/features/cart/screens/cart_screen.dart';
import 'package:food_app_portfolio/src/features/profile/screens/profile_screen.dart';
import 'package:food_app_portfolio/src/services/cart_service.dart';

class MainNavigator extends StatefulWidget {
  final CartService cartService;

  const MainNavigator({Key? key, required this.cartService}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  void navigateToTab(int index) {
    if (index >= 0 && index < _screens.length) {
      // Validación básica
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        cartService: widget.cartService,
        navigateToCartTab: () =>
            navigateToTab(2), // 2 es el índice de CartScreen
      ),
      FavoritesScreen(),
      // Pasamos la función navigateToTab a CartScreen
      CartScreen(
        cartService: widget.cartService,
        navigateToHome: () => navigateToTab(0), // 0 es el índice de HomeScreen
      ),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los colores del tema actual para la barra de navegación
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // El AppBar se maneja DENTRO de cada pantalla individual (HomeScreen, FavoritesScreen, etc.)
      // Esto da más flexibilidad para cada pantalla.
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(
              Icons.home_filled,
            ), // Icono más relleno cuando está activo
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        // Usamos los colores del tema para consistencia
        selectedItemColor:
            colorScheme.primary, // Color del ítem activo (tu naranja)
        unselectedItemColor: theme.unselectedWidgetColor.withOpacity(
          0.8,
        ), // Color sutil para inactivos
        backgroundColor: theme.cardColor, // O colorScheme.surface si prefieres
        type: BottomNavigationBarType.fixed, // Muestra todos los labels
        showUnselectedLabels: true, // Muestra labels de ítems no seleccionados
        elevation: 8.0, // Sombra
        onTap: _onItemTapped,
      ),
    );
  }
}

// lib/src/navigation/main_navigator.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart';
import 'package:food_app_portfolio/src/features/home/screens/home_screen.dart';
import 'package:food_app_portfolio/src/features/favorites/screens/favorites_screen.dart';
import 'package:food_app_portfolio/src/features/cart/screens/cart_screen.dart';
import 'package:food_app_portfolio/src/features/profile/screens/profile_screen.dart';
import 'package:food_app_portfolio/src/services/cart_service.dart';
import 'package:food_app_portfolio/src/services/favorites_service.dart';

class MainNavigator extends StatefulWidget {
  final CartService cartService;
  final FavoritesService favoritesService;

  const MainNavigator({
    Key? key,
    required this.cartService,
    required this.favoritesService,
  }) : super(key: key);

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
        favoritesService: widget.favoritesService,
        navigateToCartTab: () =>
            navigateToTab(2), // 2 es el índice de CartScreen
        navigateToProfileTab: () =>
            navigateToTab(3), // 3 es el índice de ProfileScreen
      ),
      FavoritesScreen(
        // <--- PASAR A FavoritesScreen
        favoritesService: widget.favoritesService,
        cartService: widget
            .cartService, // También necesitará cartService para los ProductCard
        navigateToHome: () => navigateToTab(0), // Para el botón de "Explorar"
      ),
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
      bottomNavigationBar: Container(
        // Margen opcional para separar un poco la barra de navegación del borde inferior
        // o si quieres que "flote" un poco.
        // margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          // No es necesario el color aquí si ClipRRect lo maneja,
          // pero el boxShadow sí va en el Container externo.
          // color: Colors.transparent, // El Container externo es solo para la sombra y el margen.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Sombra más pronunciada
              blurRadius: 15,
              spreadRadius: 2, // Extiende un poco la sombra
              offset: Offset(0, -5), // Sombra que se proyecta hacia arriba
            ),
          ],
          // El borderRadius se aplica al ClipRRect
        ),
        child: ClipRRect(
          // Bordes superiores redondeados. Puedes ajustar el radio.
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), // Radio más grande para que se note
            topRight: Radius.circular(40.0),
            // Si también quieres redondear abajo (no es común si está pegado al borde):
            // bottomLeft: Radius.circular( (margin != null) ? 30.0 : 0),
            // bottomRight: Radius.circular( (margin != null) ? 30.0 : 0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_filled),
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
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: theme.unselectedWidgetColor.withOpacity(
              0.7,
            ), // Un poco menos opaco
            // IMPORTANTE: El fondo del BottomNavigationBar debe ser el color que quieres VER.
            // Si el ClipRRect no tuviera un child Container con color, este sería el color visible.
            backgroundColor: colorScheme
                .surface, // O el color de fondo deseado para la barra
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            // IMPORTANTE: La elevación del BottomNavigationBar debe ser 0 para que no interfiera
            // con la sombra del Container exterior.
            elevation: 0,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

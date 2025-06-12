// lib/src/features/favorites/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart';
import 'package:food_app_portfolio/src/data/models/product_model.dart';
import 'package:food_app_portfolio/src/features/products/widgets/product_card.dart';
import 'package:food_app_portfolio/src/services/cart_service.dart';
import 'package:food_app_portfolio/src/services/favorites_service.dart';
import 'package:food_app_portfolio/src/data/mock_data.dart'; // Para sugerencias
import 'package:food_app_portfolio/src/features/products/screens/product_detail_screen.dart'; // Para navegar a detalles

class FavoritesScreen extends StatelessWidget {
  final FavoritesService favoritesService;
  final CartService cartService; // Necesario para ProductCard
  final VoidCallback navigateToHome; // Para el botón de explorar

  const FavoritesScreen({
    super.key,
    required this.cartService,
    required this.favoritesService,
    required this.navigateToHome,
  });

  Widget _buildSuggestionsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Sugerencias simples: tomar algunos productos populares o destacados
    final suggestedProducts = MockData.products
        .where((p) => p.isPopular || p.isFeatured)
        .where(
          (p) => !favoritesService.isFavorite(p.id),
        ) // No sugerir si ya es favorito
        .take(5)
        .toList();

    if (suggestedProducts.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
          child: Text(
            'Quizás te interese',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 290, // Ajustar según ProductCard
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: suggestedProducts.length,
            itemBuilder: (ctx, index) {
              final prod = suggestedProducts[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.55,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ProductCard(
                  product: prod,
                  // cartService: cartService,
                  favoritesService: favoritesService,
                  onAddToCart: () {
                    /* ... */
                  },
                  onViewDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: prod,
                          cartService: cartService,
                          favoritesService: favoritesService,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation:
            0, // La sombra la dará el shape y el container que lo envuelve (o directamente con elevation si funciona bien)
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight:
            55, // Un poco más de altura para que se vean bien las curvas y la sombra
        shape: ContinuousRectangleBorder(
          // Para la sombra y poder redondear esquinas inferiores
          // No podemos redondear solo abajo con ContinuousRectangleBorder directamente en AppBar.
          // Necesitaremos un enfoque diferente si queremos solo esquinas inferiores redondeadas
          // o usar un AppBar personalizado.
          // Por ahora, redondearemos todo y la sombra ayudará.
          // borderRadius: BorderRadius.circular(20), // Redondea todas las esquinas
        ),
        // Para controlar la sombra y el redondeado inferior, es mejor un AppBar personalizado
        // o engañar con un Container debajo. Vamos a probar con elevation y un shape más simple primero.

        // Nuevo enfoque para el AppBar con esquinas inferiores redondeadas:
        // Necesitamos un PreferredSize para un AppBar personalizado si queremos un shape complejo.
        // Solución más simple si `shape` no da el efecto exacto:
        // Dejar el AppBar estándar y poner un Container con el diseño *debajo* de él,
        // pero esto no es lo ideal.

        // Vamos a mantener el AppBar estándar y aplicar la sombra con elevation.
        // El redondeo de solo esquinas inferiores es complicado con AppBar.shape estándar.
        // Lo que SÍ podemos hacer es usar un `flexibleSpace` o un `bottom` para el diseño.

        // OPCIÓN MÁS SIMPLE con AppBar estándar:
        // No podremos redondear SOLO las esquinas inferiores con `shape` fácilmente.
        // El `shape` aplica a todo el AppBar.
        // Si quieres el efecto exacto de la imagen, necesitarías un `PreferredSize`
        // con un `Container` que tenga `BoxDecoration` para el `borderRadius` inferior
        // y la sombra, y el contenido del AppBar (icon, title) dentro de ese Container.

        // INTENTO CON AppBar estándar y propiedades:
        flexibleSpace: Container(
          // Usamos flexibleSpace para simular el fondo con bordes
          decoration: BoxDecoration(
            color: colorScheme.surface, // Fondo blanco
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35.0), // REDONDEO SOLO ABAJO
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 9.0,
                offset: Offset(0, 2), // Sombra hacia abajo
              ),
            ],
          ),
        ),
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(
            Icons.favorite_outline_rounded, // Icono de Favoritos
            color: AppColors.primary, // Color del icono (oscuro sobre blanco)
            size: 28,
          ),
        ),
        title: Text(
          'Mis Favoritos',
          style: TextStyle(
            color: AppColors.textPrimary, // Texto oscuro sobre blanco
            fontWeight: FontWeight.w600,
            fontSize: 20, // El tema global debería manejarlo
          ),
        ),
        actions: [
          SizedBox(
            width: 56,
          ), // Espacio vacío para equilibrar el leading si no hay actions
        ],
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: favoritesService.favoriteIdsNotifier,
        builder: (context, favoriteIds, child) {
          final List<ProductModel> favoriteProductsList =
              favoritesService.favoriteProducts;

          if (favoriteProductsList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aún no tienes favoritos',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      '¡Marca tus platos preferidos con un corazón para verlos aquí!',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(Icons.explore_outlined),
                      label: Text('Explorar Menú'),
                      onPressed: navigateToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: textTheme.labelLarge,
                      ),
                    ),
                    // También podrías poner la sección de sugerencias aquí
                    // si quieres que se vea incluso cuando no hay favoritos.
                    // _buildSuggestionsSection(context),
                  ],
                ),
              ),
            );
          }

          // Mostrar lista de favoritos y sugerencias
          return CustomScrollView(
            // Usar CustomScrollView para combinar Grid y ListView horizontal
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio:
                        0.70, // Ajustar según el contenido de ProductCard
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final product = favoriteProductsList[index];
                    return ProductCard(
                      product: product,
                      // cartService: cartService,
                      favoritesService: favoritesService,
                      onAddToCart: () {
                        cartService.addItem(product);
                        // ... SnackBar ...
                      },
                      onViewDetails: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                              product: product,
                              cartService: cartService,
                              // Aquí necesitarás pasar favoritesService si ProductDetailScreen lo requiere
                              favoritesService: favoritesService,
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: favoriteProductsList.length),
                ),
              ),
              SliverToBoxAdapter(child: _buildSuggestionsSection(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ), // Espacio al final
            ],
          );
        },
      ),
    );
  }
}

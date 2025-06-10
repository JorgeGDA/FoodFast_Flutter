// lib/src/features/products/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:food_app_portfolio/src/constants/app_colors.dart'; // No es necesario si usas colorScheme
import '../../../data/models/product_model.dart';
import '../../../data/mock_data.dart';
import '../../../services/cart_service.dart';
import '../widgets/product_card.dart';
import '../../../services/favorites_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final CartService cartService;
  final FavoritesService favoritesService; // <--- AÑADIR

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.cartService,
    required this.favoritesService,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ValueNotifier<bool> _isAppBarCollapsedNotifier = ValueNotifier(false);

  final Map<String, IconData> ingredientIcons = {
    'carne de res': Icons.kebab_dining_rounded,
    'queso cheddar': Icons.woman_2,
    'lechuga': Icons.eco_rounded,
    'tomate': Icons.spa_rounded,
    'salsa especial': Icons.blender_rounded,
    'pan brioche': Icons.bakery_dining_rounded,
    'pepinillos': Icons.grass_rounded,
    'pepperoni': Icons.local_pizza_outlined,
    'mozzarella': Icons.texture_rounded, // Ejemplo para mozzarella
    'salsa de tomate picante': Icons.local_fire_department_rounded,
    'chili en polvo': Icons.scatter_plot_rounded, // Ejemplo
    // Añade más mapeos
  };

  @override
  void dispose() {
    _isAppBarCollapsedNotifier.dispose();
    super.dispose();
  }

  IconData _getIngredientIcon(String ingredientName) {
    String lowerIngredient = ingredientName.toLowerCase();
    for (var key in ingredientIcons.keys) {
      if (lowerIngredient.contains(key)) {
        return ingredientIcons[key]!;
      }
    }
    return Icons.kitchen_rounded;
  }

  Widget _buildSectionHeaderWithDivider(
    BuildContext context,
    String title,
    Color dividerColor, {
    bool isForRelatedList = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isForRelatedList
                ? 0.0
                : 0.0, // El padding general ya está en el contenedor padre
            top: isForRelatedList
                ? 0
                : 0, // Ajuste para que el título de relacionados esté bien alineado
            bottom: isForRelatedList
                ? 12
                : 0, // Espacio antes del listview de relacionados
          ),
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 6),
        // No mostrar divisor justo antes del ListView de "También te podría gustar"
        if (!isForRelatedList)
          Container(
            height: 2.5,
            width: 50.0,
            decoration: BoxDecoration(
              color: dividerColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(2.0),
            ),
            margin: const EdgeInsets.only(bottom: 0),
          ),
      ],
    );
  }

  Widget _buildRelatedProductsSection(BuildContext context) {
    final relatedProducts = MockData.products
        .where(
          (p) =>
              p.category == widget.product.category &&
              p.id != widget.product.id,
        )
        .take(5)
        .toList();

    if (relatedProducts.isEmpty) {
      return SizedBox.shrink();
    }
    // El título ahora se maneja fuera, solo devolvemos el ListView
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ), // Ajustar padding del ListView
        itemCount: relatedProducts.length,
        itemBuilder: (ctx, index) {
          final relatedProd = relatedProducts[index];
          return Container(
            width:
                MediaQuery.of(context).size.width * 0.55, // Un poco más pequeño
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ProductCard(
              product: relatedProd,
              favoritesService: widget.favoritesService,
              onAddToCart: () {
                widget.cartService.addItem(relatedProd);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${relatedProd.name} añadido al carrito'),
                  ),
                );
              },
              onViewDetails: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: relatedProd,
                      cartService: widget.cartService,
                      favoritesService: widget.favoritesService,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight:
                screenHeight * 0.42, // Un poco más de altura para la imagen
            pinned: true,
            floating: false,
            elevation: 0, // Para un look más plano cuando está colapsado
            backgroundColor: colorScheme.surface, // Fondo del AppBar colapsado
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                // Ajusta este valor si es necesario, kToolbarHeight es 56.0
                // El +1 es un pequeño margen.
                bool isCollapsed =
                    top <=
                    kToolbarHeight + MediaQuery.of(context).padding.top + 1.5;

                // Actualiza el notifier DESPUÉS de que el frame se haya construido
                // para evitar errores de setState durante el build.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_isAppBarCollapsedNotifier.value != isCollapsed) {
                    _isAppBarCollapsedNotifier.value = isCollapsed;
                  }
                });

                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: isCollapsed
                        ? 72.0
                        : 20.0, // Ajusta para el botón de atrás
                    bottom: isCollapsed
                        ? 14.0
                        : 20.0, // Más abajo cuando expandido
                  ),
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 250),
                    opacity: isCollapsed
                        ? 1.0
                        : 0.0, // Visible solo cuando está colapsado
                    child: Text(
                      widget.product.name,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight
                            .w600, // Un poco menos bold que el título principal
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  background: Hero(
                    tag: 'product_image_${widget.product.id}',
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: _isAppBarCollapsedNotifier,
                    builder: (context, isCollapsed, child) {
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 150),
                        opacity: isCollapsed
                            ? 0.0
                            : 1.0, // Visible solo cuando NO está colapsado
                        child: isCollapsed
                            ? SizedBox.shrink()
                            : child, // Oculta el espacio si no es visible
                      );
                    },
                    child: Text(
                      // Título principal del producto
                      widget.product.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: widget.product.rating,
                            itemBuilder: (context, index) =>
                                Icon(Icons.star_rounded, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 22.0,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} reseñas)',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  _buildSectionHeaderWithDivider(
                    context,
                    'Descripción',
                    colorScheme.primary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),

                  if (widget.product.ingredients.isNotEmpty) ...[
                    _buildSectionHeaderWithDivider(
                      context,
                      'Ingredientes',
                      colorScheme.primary,
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: widget.product.ingredients.map((ingredient) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.4),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.08),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getIngredientIcon(ingredient),
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                ingredient,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ), // Padding para el título de relacionados
              child: _buildSectionHeaderWithDivider(
                context,
                'También te podría gustar',
                colorScheme.primary,
                isForRelatedList: true,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildRelatedProductsSection(context)),
          SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ), // Espacio para el botón flotante
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          20.0,
          12.0,
          20.0,
          20.0,
        ), // Más padding inferior para safe area
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.add_shopping_cart_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
          label: Text('Añadir al Carrito'),
          onPressed: () {
            widget.cartService.addItem(widget.product);
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.product.name} añadido al carrito'),
                backgroundColor: colorScheme.secondary,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).size.height *
                      0.12, // Sube el SnackBar
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: textTheme.labelLarge?.copyWith(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}

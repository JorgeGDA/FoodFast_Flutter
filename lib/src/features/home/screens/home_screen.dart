// lib/src/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../products/widgets/product_card.dart';
import '../../products/screens/product_detail_screen.dart';
import '../../../services/cart_service.dart'; // <-- Importa CartService
import '../../cart/screens/cart_screen.dart'; // <-- Importaremos esto pronto
import '../../../data/models/cart_item_model.dart';

class HomeScreen extends StatefulWidget {
  final CartService cartService; // <-- Añade cartService

  const HomeScreen({Key? key, required this.cartService})
    : super(key: key); // <-- Actualiza constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _displayedProducts = [];
  List<ProductModel> _popularProducts = []; // Para el carrusel

  // Usaremos el enum ProductCategory para el estado de la categoría seleccionada
  ProductCategory? _selectedCategory; // Nullable para "Todos"

  final List<CategoryModel> _categories =
      mockCategories; // Usamos las de category_model.dart

  @override
  void initState() {
    super.initState();
    _allProducts = MockData.products;
    _popularProducts = _allProducts
        .where((p) => p.isPopular || p.isFeatured)
        .toList();
    _filterProducts(); // Llama al filtro inicial
  }

  void _filterProducts() {
    if (_selectedCategory == null) {
      _displayedProducts = List.from(_allProducts); // Mostrar todos
    } else {
      _displayedProducts = _allProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }
    setState(() {}); // Actualizar la UI
  }

  void _onCategorySelected(ProductCategory? category) {
    setState(() {
      _selectedCategory = category;
      _filterProducts();
    });
  }

  void _handleAddToCart(ProductModel product) {
    widget.cartService.addItem(product); // <-- Usa cartService
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} añadido al carrito'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
    widget.cartService.printCart(); // Para depuración
  }

  void _handleViewDetails(ProductModel product) {
    // En _HomeScreenState, _handleViewDetails
    // Necesitarías importar 'package:animations/animations.dart';
    Navigator.push(
      context,
      PageRouteBuilder(
        // Usar PageRouteBuilder para transiciones personalizadas
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(
              product: product,
              cartService: widget.cartService,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            // O FadeThroughTransition, etc.
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType:
                SharedAxisTransitionType.scaled, // O .horizontal, .vertical
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Pasaremos cartService a CartScreen
        builder: (context) => CartScreen(cartService: widget.cartService),
      ),
    );
  }

  Widget _buildCategorySelector() {
    // Usaremos un SingleChildScrollView para la fila de categorías si son muchas
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      height: 60, // Altura fija para la fila de categorías
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Opción para "Todos"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('Todos'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                if (selected) _onCategorySelected(null);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedCategory == null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.5),
              shape: StadiumBorder(), // Bordes redondeados tipo "píldora"
            ),
          ),
          // Chips para cada categoría
          ..._categories.map((category) {
            bool isSelected = _selectedCategory == category.type;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(category.name),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) _onCategorySelected(category.type);
                },
                avatar: category.type == ProductCategory.pizza
                    ? Icon(
                        Icons.local_pizza_outlined,
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      )
                    : category.type == ProductCategory.burger
                    ? Icon(
                        Icons.lunch_dining_outlined,
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      )
                    : null, // Añade más iconos si quieres
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.5),
                shape: StadiumBorder(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPopularProductsCarousel() {
    if (_popularProducts.isEmpty)
      return SizedBox.shrink(); // No mostrar nada si no hay populares

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Populares Esta Semana',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          CarouselSlider(
            options: CarouselOptions(
              height: 240.0, // Altura de las tarjetas del carrusel
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              enlargeCenterPage: true, // La tarjeta del centro es más grande
              viewportFraction:
                  0.8, // Cuánto de la siguiente/anterior tarjeta se ve
              aspectRatio: 16 / 9, // Puede ser redundante si height está fijo
            ),
            items: _popularProducts.map((product) {
              // Usaremos una versión ligeramente modificada de ProductCard o una nueva
              // Por ahora, vamos a hacer una tarjeta simple aquí
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => _handleViewDetails(product),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 5.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3, // Más espacio para la imagen
                            child: Hero(
                              tag:
                                  'popular_product_image_${product.id}', // Tag único para Hero
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  // Añade loadingBuilder y errorBuilder si es necesario
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2, // Espacio para nombre y precio
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(
      context,
    ).colorScheme; // También útil, puedes añadirla si no está
    return Scaffold(
      appBar: AppBar(
        title: Text('Paradise Fast Food'),
        actions: [
          // Widget para mostrar el número de ítems en el carrito
          ValueListenableBuilder<List<CartItemModel>>(
            valueListenable: widget.cartService.itemsNotifier,
            builder: (context, items, child) {
              int itemCount = widget.cartService.totalItemsCount;
              if (itemCount == 0) {
                return IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: _navigateToCartScreen,
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                    ), // Icono relleno si hay ítems
                    onPressed: _navigateToCartScreen,
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        // Envolvemos todo en una Column
        crossAxisAlignment:
            CrossAxisAlignment.start, // Para alinear el título de "Productos"
        children: [
          _buildCategorySelector(), // Añadimos el selector de categorías
          _buildPopularProductsCarousel(), // Añadimos el carrusel de populares
          // Título para la lista principal de productos
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              _selectedCategory == null
                  ? 'Todos los Productos'
                  // Aquí usamos textTheme, así que debe estar definido
                  : _categories
                        .firstWhere((c) => c.type == _selectedCategory)
                        .name,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ), // <--- Aquí se usa
            ),
          ),

          Expanded(
            // ListView.builder necesita estar en un Expanded dentro de Column
            child: _displayedProducts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'No hay productos disponibles para esta categoría.',
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ), // Ajusta padding
                    itemCount: _displayedProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = _displayedProducts[index];
                      // Asegúrate de que el tag de Hero aquí sea diferente al del carrusel si el producto puede estar en ambos
                      // Si ProductCard ya tiene Hero, no necesitas otro aquí.
                      // Pero si el producto popular usa un Hero con tag diferente, está bien.
                      return ProductCard(
                        product: product,
                        onAddToCart: () => _handleAddToCart(product),
                        onViewDetails: () => _handleViewDetails(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

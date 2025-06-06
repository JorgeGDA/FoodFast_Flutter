// lib/src/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../products/widgets/product_card.dart';
import '../../products/screens/product_detail_screen.dart';
import '../../../services/cart_service.dart'; // <-- Importa CartService
import '../../cart/screens/cart_screen.dart'; // <-- Importaremos esto pronto
import '../../../data/models/cart_item_model.dart';
import '../../../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final CartService cartService; // <-- Añade cartService
  final VoidCallback navigateToCartTab; // Nueva función

  const HomeScreen({
    Key? key,
    required this.cartService,
    required this.navigateToCartTab,
  }) : super(key: key); // <-- Actualiza constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _displayedProducts = [];
  List<ProductModel> _popularProducts = []; // Para el carrusel

  // Usaremos el enum ProductCategory para el estado de la categoría seleccionada
  ProductCategory? _selectedCategory; // Nullable para "Todos"

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = ''; // Para guardar el término de búsqueda actual

  bool _showOnlyPopular = false; // Para el filtro de popularidad
  String?
  _sortBy; // Para el ordenamiento, ej: 'price_asc', 'price_desc', 'name_asc'

  final List<CategoryModel> _categories =
      mockCategories; // Usamos las de category_model.dart

  @override
  void dispose() {
    _searchController.dispose(); // Desechar el controlador
    // widget.cartService.itemsNotifier.removeListener(_updateCartIcon); // Si tenías esto
    super.dispose();
  }

  void initState() {
    super.initState();
    _allProducts = MockData.products;
    _popularProducts = _allProducts
        .where((p) => p.isPopular || p.isFeatured)
        .toList();
    _filterProducts(); // Llama al filtro inicial
  }

  // Dentro de la clase _HomeScreenState

  void _filterProducts() {
    List<ProductModel> tempProducts = List.from(_allProducts);

    // 1. Filtrar por categoría
    if (_selectedCategory != null) {
      tempProducts = tempProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // 2. Filtrar por "Solo Populares"
    if (_showOnlyPopular) {
      tempProducts = tempProducts
          .where((product) => product.isPopular)
          .toList();
    }

    // 3. Filtrar por término de búsqueda
    if (_searchTerm.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.name.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    // 4. Ordenar los productos
    if (_sortBy != null) {
      tempProducts.sort((a, b) {
        switch (_sortBy) {
          case 'price_asc':
            return a.price.compareTo(b.price);
          case 'price_desc':
            return b.price.compareTo(a.price);
          case 'name_asc':
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          // Puedes añadir más casos de ordenamiento (ej. 'rating_desc')
          default:
            return 0;
        }
      });
    }

    _displayedProducts =
        tempProducts; // Asignar la lista final filtrada y ordenada
    setState(() {});
  }

  void _onCategorySelected(ProductCategory? category) {
    setState(() {
      _selectedCategory = category;
      _filterProducts(); // Esto aplicará el filtro de categoría Y el filtro de búsqueda actual
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
    // En lugar de Navigator.push, llama a la función para cambiar de pestaña
    widget.navigateToCartTab();
  }

  Widget _buildAdvancedFilters() {
    final colorScheme = Theme.of(context).colorScheme; // Obtener colorScheme

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 0.0,
      ), // Menos padding vertical
      child: Wrap(
        // Usamos Wrap para que los filtros se ajusten si no caben en una línea
        spacing: 8.0, // Espacio horizontal entre elementos del Wrap
        runSpacing: 4.0, // Espacio vertical si hay múltiples líneas
        alignment: WrapAlignment.start, // Alineación
        children: <Widget>[
          // --- Filtro de Popularidad (ToggleButton o Chip) ---
          FilterChip(
            label: Text(
              'Populares',
              style: TextStyle(
                color: _showOnlyPopular
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            selected: _showOnlyPopular,
            onSelected: (bool selected) {
              setState(() {
                _showOnlyPopular = selected;
                _filterProducts();
              });
            },
            avatar: Icon(
              Icons.star_border_rounded,
              size: 18,
              color: _showOnlyPopular
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            selectedColor: colorScheme.primary,
            checkmarkColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
            shape: StadiumBorder(),
          ),

          // --- Menú Desplegable para Ordenamiento ---
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                if (value == 'clear_sort') {
                  _sortBy = null; // Limpiar el ordenamiento
                } else {
                  _sortBy = value;
                }
                _filterProducts();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'price_asc',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 18),
                    SizedBox(width: 8),
                    Text('Precio (Menor)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'price_desc',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 18),
                    SizedBox(width: 8),
                    Text('Precio (Mayor)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'name_asc',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 18),
                    SizedBox(width: 8),
                    Text('Nombre (A-Z)'),
                  ],
                ),
              ),
              // Opción para limpiar el ordenamiento
              if (_sortBy != null) ...[
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'clear_sort', // Un valor especial para limpiar
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 18, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text('Limpiar Orden'),
                    ],
                  ),
                ),
              ],
            ],
            child: Container(
              // El widget que activa el PopupMenuButton
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 6),
                  Text(
                    _sortBy == null
                        ? 'Ordenar por'
                        : _sortBy == 'price_asc'
                        ? 'Precio (Menor)'
                        : _sortBy == 'price_desc'
                        ? 'Precio (Mayor)'
                        : 'Nombre (A-Z)', // Debería ser más genérico o reflejar el estado actual
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // Aquí podrías añadir más filtros (ej. un Slider para rango de precios)
        ],
      ),
    );
  }

  // Dentro de la clase _HomeScreenState

  Widget _buildSearchBarAndFilters() {
    // Renombrado para mayor claridad
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list_rounded,
              color: colorScheme.primary,
              size: 28,
            ), // Icono de filtro
            tooltip: 'Ordenar y Filtrar', // Tooltip para accesibilidad
            onSelected: (String value) {
              setState(() {
                if (value == 'clear_sort') {
                  _sortBy = null;
                } else if (value == 'toggle_popular') {
                  // Nuevo caso para el toggle de populares
                  _showOnlyPopular = !_showOnlyPopular;
                } else {
                  _sortBy =
                      value; // Asumimos que otros valores son para ordenamiento
                }
                _filterProducts();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Opción para Populares
              CheckedPopupMenuItem<String>(
                // Para mostrar un check si está activo
                value: 'toggle_popular',
                checked: _showOnlyPopular,
                child: Text('Mostrar solo Populares'),
              ),
              PopupMenuDivider(), // Divisor
              // Opciones de Ordenamiento
              PopupMenuItem<String>(
                value: 'price_asc',
                enabled:
                    _sortBy !=
                    'price_asc', // Deshabilitar si ya está seleccionado
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 18),
                    SizedBox(width: 8),
                    Text('Precio (Menor)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'price_desc',
                enabled: _sortBy != 'price_desc',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 18),
                    SizedBox(width: 8),
                    Text('Precio (Mayor)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'name_asc',
                enabled: _sortBy != 'name_asc',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 18),
                    SizedBox(width: 8),
                    Text('Nombre (A-Z)'),
                  ],
                ),
              ),
              if (_sortBy != null) ...[
                // Solo mostrar si hay un ordenamiento activo
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'clear_sort',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 18, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text('Limpiar Orden'),
                    ],
                  ),
                ),
              ],
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ), // Bordes redondeados para el menú
            offset: Offset(0, 40), // Desplazar el menú un poco hacia abajo
          ),
          // --- CAMPO DE BÚSQUEDA ---
          Expanded(
            // Para que el TextField ocupe el espacio disponible
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Pizzas, Hamburguesas...',
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                suffixIcon: _searchTerm.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchTerm = '';
                            _filterProducts(); // Volver a filtrar sin término de búsqueda
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: AppColors.divider.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                  _filterProducts();
                });
              },
            ),
          ),
          SizedBox(width: 10), // Espacio entre la búsqueda y el botón de filtro
          // --- BOTÓN DE FILTRO (CON PopupMenuButton) ---
        ],
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

  Widget _buildSectionTitle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String titleText = _selectedCategory == null
        ? 'Todos los Productos'
        : _categories
              .firstWhere(
                (c) => c.type == _selectedCategory,
                orElse: () => CategoryModel(
                  id: '',
                  name: 'Productos',
                  type: ProductCategory.pizza,
                ),
              )
              .name;
    // El orElse es por si acaso, aunque no debería pasar si _categories está bien.

    IconData sectionIcon =
        Icons.list_alt_rounded; // Icono por defecto para "Todos"
    if (_selectedCategory != null) {
      switch (_selectedCategory!) {
        // Usamos ! porque ya comprobamos que no es null
        case ProductCategory.pizza:
          sectionIcon = Icons.local_pizza_rounded;
          break;
        case ProductCategory.burger:
          sectionIcon = Icons.lunch_dining_rounded;
          break;
        // Añade más casos para otras categorías si las tienes
        default:
          sectionIcon = Icons.fastfood_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Fondo naranja
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4), // Sombra hacia abajo
          ),
          BoxShadow(
            // Sombra interna sutil para efecto de profundidad (opcional)
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Para que el contenedor no ocupe todo el ancho
        children: [
          Icon(
            sectionIcon,
            color: AppColors.textOnPrimary, // Icono blanco
            size: 22,
          ),
          SizedBox(width: 10),
          Text(
            titleText,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary, // Texto blanco
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(
    //   context,
    // ).colorScheme; // También útil, puedes añadirla si no está
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Food Paradise'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primary,

        actions: [
          // Widget para mostrar el número de ítems en el carrito
          ValueListenableBuilder<List<CartItemModel>>(
            valueListenable: widget.cartService.itemsNotifier,
            builder: (context, items, child) {
              int itemCount = widget.cartService.totalItemsCount;
              if (itemCount == 0) {
                return IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: _navigateToCartScreen,
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
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
                          color: Colors.green,
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
      body: CustomScrollView(
        slivers: <Widget>[
          // Cada widget que antes estaba en el Column ahora es un SliverToBoxAdapter
          SliverToBoxAdapter(child: _buildCategorySelector()),
          SliverToBoxAdapter(child: _buildPopularProductsCarousel()),
          SliverToBoxAdapter(child: _buildSearchBarAndFilters()),
          // SliverToBoxAdapter(
          //   child: _buildAdvancedFilters(), // Si decides re-añadirlo
          // ),
          SliverToBoxAdapter(
            child: _buildSectionTitle(context), // ¡Ahora esto se desplazará!
          ),

          // Ahora, en lugar de Expanded(GridView.builder(...)), usamos SliverGrid
          // o un mensaje si no hay productos.
          _displayedProducts.isEmpty
              ? SliverFillRemaining(
                  // O SliverToBoxAdapter si prefieres un control más fino del tamaño
                  hasScrollBody:
                      false, // Importante si el child no es scrollable por sí mismo
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'No hay productos que coincidan con tu búsqueda o filtros.',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  // Añade padding alrededor del Grid
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio:
                          0.75, // Ajusta según el contenido de tu ProductCard
                    ),
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final product = _displayedProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () => _handleAddToCart(product),
                        onViewDetails: () => _handleViewDetails(product),
                      );
                    }, childCount: _displayedProducts.length),
                  ),
                ),
        ],
      ),
    );
  }
}

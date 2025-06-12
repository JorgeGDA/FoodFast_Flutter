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
import 'package:food_app_portfolio/src/features/profile/screens/profile_screen.dart';
import 'package:food_app_portfolio/src/services/favorites_service.dart';
import 'package:food_app_portfolio/src/data/models/address_model.dart';
import 'package:food_app_portfolio/src/features/profile/screens/addresses_screen.dart';
import '/../../../utils/app_notifications.dart';

class HomeScreen extends StatefulWidget {
  final CartService cartService; // <-- Añade cartService
  final FavoritesService favoritesService;
  final VoidCallback navigateToCartTab; // Nueva función
  final VoidCallback navigateToProfileTab; // <--- NUEVA PROPIEDAD

  const HomeScreen({
    super.key,
    required this.cartService,
    required this.favoritesService,
    required this.navigateToCartTab,
    required this.navigateToProfileTab,
  }); // <-- Actualiza constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
// Puedes crear este widget dentro de home_screen.dart si solo se usa ahí,
// o en una carpeta de widgets comunes si planeas reutilizarlo.

class CategoryCircleItem extends StatelessWidget {
  final String name;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCircleItem({
    super.key,
    required this.name,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Ancho total del ítem, incluyendo padding si quieres
        width: 70, // Ajusta este ancho según necesites
        margin: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ), // Espacio entre ítems
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Para que la columna no ocupe más espacio del necesario
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo con el icono
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: const EdgeInsets.all(
                12.0,
              ), // Padding interno del círculo
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.white,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        // Sombra más pronunciada cuando está seleccionado
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.1),
                          blurRadius: 14,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                        BoxShadow(
                          // Sombra interna sutil para efecto de profundidad
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : [
                        // Sombra sutil cuando no está seleccionado
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                border:
                    isSelected // Borde opcional cuando está seleccionado
                    ? Border.all(
                        color: colorScheme.onPrimary.withOpacity(0.3),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Icon(
                iconData,
                size: 28, // Tamaño del icono
                color: isSelected ? colorScheme.onPrimary : Colors.grey,
              ),
            ),
            SizedBox(height: 8), // Espacio entre el círculo y el texto
            // Nombre de la categoría
            Text(
              name,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 11, // Tamaño de letra pequeño
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _displayedProducts = [];
  List<ProductModel> _popularProducts = []; // Para el carrusel
  AddressModel? _selectedDeliveryAddress;

  // Usaremos el enum ProductCategory para el estado de la categoría seleccionada
  ProductCategory? _selectedCategory; // Nullable para "Todos"

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = ''; // Para guardar el término de búsqueda actual

  bool _showOnlyPopular = false; // Para el filtro de popularidad
  String?
  _sortBy; // Para el ordenamiento, ej: 'price_asc', 'price_desc', 'name_asc'

  final List<CategoryModel> _categories =
      mockCategories; // Usamos las de category_model.dart

  static const String _userAvatarPath = "assets/images/oahh.jpg";
  @override
  void dispose() {
    _searchController.dispose(); // Desechar el controlador
    // widget.cartService.itemsNotifier.removeListener(_updateCartIcon); // Si tenías esto
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _allProducts = MockData.products;
    _popularProducts = _allProducts
        .where((p) => p.isPopular || p.isFeatured)
        .toList();
    _filterProducts(); // Llama al filtro inicial
    if (MockData.userAddresses.isNotEmpty) {
      _selectedDeliveryAddress = MockData.userAddresses.firstWhere(
        (addr) => addr.isPrimary,
        orElse: () => MockData.userAddresses.first,
      );
    }
  }

  // Dentro de la clase _HomeScreenState
  // En _HomeScreenState
  void _navigateToChangeAddress() async {
    // Navegamos a AddressesScreen y esperamos un resultado (AddressModel)
    final result = await Navigator.push<AddressModel>(
      // Especificamos el tipo de resultado
      context,
      MaterialPageRoute(
        builder: (context) => AddressesScreen(
          // Si AddressesScreen necesitara saber cuál está seleccionada inicialmente:
          // initiallySelectedAddress: _selectedDeliveryAddress,
        ),
      ),
    );

    // Si el usuario seleccionó una dirección y volvió
    // En _HomeScreenState, _navigateToChangeAddress, dentro del if (result != null)
    if (result != null) {
      setState(() {
        _selectedDeliveryAddress = result;
      });
      showAppNotification(
        context: context,
        title: 'Dirección Actualizada',
        description: 'Entregaremos tu pedido en: ${result.streetAddress}.',
        type: AppNotificationType.success, // O .info
      );
    }
  }

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
    showAppNotification(
      context: context,
      title: '¡Al Carrito!', // Título más corto y amigable
      description: '${product.name} se añadió correctamente.',
      type: AppNotificationType.cart, // Nuevo tipo específico
      // Opcional: Añadir un botón de acción
      // action: TextButton(
      //   onPressed: () {
      //     widget.navigateToCartTab(); // Asume que esta función existe y navega al carrito
      //     ElegantNotification.clearAll(context: context); // Cierra la notificación
      //   },
      //   child: Text("VER CARRITO", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      // ),
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
              favoritesService: widget.favoritesService,
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

  void _navigateToProfileScreen() {
    widget.navigateToProfileTab();
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
            width: 80.0,
            decoration: BoxDecoration(
              color: dividerColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(2.0),
            ),
            margin: const EdgeInsets.only(bottom: 0),
          ),
      ],
    );
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
            backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(
              0.5,
            ),
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
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
                hintText: '¿Que se te antoja hoy..?',
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

  // En _HomeScreenState dentro de lib/src/features/home/screens/home_screen.dart

  Widget _buildCategorySelector() {
    final colorScheme = Theme.of(
      context,
    ).colorScheme; // Necesario para el ítem "Todos"

    return Container(
      // Aumentamos la altura para dar espacio a los círculos y el texto debajo
      height:
          100, // Ajusta esta altura según el tamaño de tus CategoryCircleItem
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ), // Padding vertical para el contenedor
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ), // Padding para el inicio y fin del ListView
        physics: BouncingScrollPhysics(), // Efecto de rebote agradable
        children: [
          // --- Opción para "Todos" ---
          CategoryCircleItem(
            name: 'Todos',
            iconData:
                Icons.apps_rounded, // O el icono que prefieras para "Todos"
            isSelected: _selectedCategory == null,
            onTap: () => _onCategorySelected(null),
          ),

          // --- Resto de las categorías ---
          ..._categories.map((category) {
            return CategoryCircleItem(
              name: category.name,
              iconData: category.iconData, // Usamos el icono del CategoryModel
              isSelected: _selectedCategory == category.type,
              onTap: () => _onCategorySelected(category.type),
            );
          }),
        ],
      ),
    );
  }

  // En _HomeScreenState dentro de lib/src/features/home/screens/home_screen.dart

  Widget _buildPopularProductsCarousel() {
    if (_popularProducts.isEmpty) {
      return SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
      ), // Un poco más de margen vertical
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 4.0,
            ), // Ajuste de padding
            child: _buildSectionHeaderWithDivider(
              // Reutilizamos el header
              context,
              'Populares Semanal',
              colorScheme.primary, // Usamos el color del tema
            ),
          ),
          SizedBox(height: 16), // Más espacio antes del carrusel
          CarouselSlider.builder(
            // Usamos CarouselSlider.builder para mejor rendimiento
            itemCount: _popularProducts.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              final product = _popularProducts[itemIndex];

              // --- Tarjeta de Producto para el Carrusel ---
              return GestureDetector(
                onTap: () => _handleViewDetails(product),
                child: Container(
                  // El margen ahora se controla por el viewportFraction y el padding del CarouselSlider
                  // margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // Fondo de la tarjeta
                    borderRadius: BorderRadius.circular(
                      18.0,
                    ), // Bordes bien redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Imagen ---
                      Expanded(
                        flex: 6, // Más espacio para la imagen en el carrusel
                        child: Hero(
                          tag: 'popular_product_image_${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18.0),
                            ),
                            child: product.imageUrl.startsWith('http')
                                ? Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, progress) =>
                                            progress == null
                                            ? child
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                    errorBuilder: (context, error, stack) =>
                                        Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey[300],
                                            size: 50,
                                          ),
                                        ),
                                  )
                                : Image.asset(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    // loadingBuilder:
                                    //     (context, child, progress) =>
                                    //         progress == null
                                    //         ? child
                                    //         : Center(
                                    //             child:
                                    //                 CircularProgressIndicator(
                                    //                   strokeWidth: 2,
                                    //                 ),
                                    //           ),
                                    errorBuilder: (context, error, stack) =>
                                        Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey[300],
                                            size: 50,
                                          ),
                                        ),
                                  ),
                          ),
                        ),
                      ),
                      // --- Información y Acciones ---
                      Expanded(
                        flex: 4, // Espacio para nombre, precio y acciones
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            12.0,
                            10.0,
                            12.0,
                            10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Distribuye el espacio
                            children: [
                              Text(
                                product.name,
                                style: textTheme.titleMedium?.copyWith(
                                  // Un poco más grande
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines:
                                    1, // Una línea para el carrusel para mantenerlo compacto
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: 4), // Quitado para usar MainAxisAlignment.spaceBetween
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: textTheme.titleLarge?.copyWith(
                                      // Precio más grande
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Botón de Favorito
                                      ValueListenableBuilder<List<String>>(
                                        valueListenable: widget
                                            .favoritesService
                                            .favoriteIdsNotifier,
                                        builder: (context, favoriteIds, child) {
                                          final bool isCurrentlyFavorite =
                                              widget.favoritesService
                                                  .isFavorite(product.id);
                                          return InkWell(
                                            onTap: () => widget.favoritesService
                                                .toggleFavorite(product),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Icon(
                                                isCurrentlyFavorite
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                          .favorite_border_rounded,
                                                color: isCurrentlyFavorite
                                                    ? Colors.redAccent[400]
                                                    : AppColors.textSecondary
                                                          .withOpacity(0.6),
                                                size: 24,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(width: 6),
                                      // Botón de Añadir al Carrito
                                      InkWell(
                                        onTap: () => _handleAddToCart(product),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: colorScheme
                                                .primary, // Usar color secundario o primario
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: colorScheme.primary
                                                    .withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.add_shopping_cart_outlined,
                                            color: colorScheme.onSecondary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            options: CarouselOptions(
              height:
                  250.0, // Aumentamos la altura para acomodar más contenido y mejor imagen
              autoPlay: true,
              autoPlayInterval: Duration(
                seconds: 4,
              ), // Un poco más lento para apreciar
              enlargeCenterPage: true,
              enlargeFactor:
                  0.25, // Cuánto más grande se hace la tarjeta central
              viewportFraction:
                  0.68, // Fracción del viewport para cada ítem (0.7 a 0.8 suele ser bueno)
              aspectRatio:
                  1.0, // Menos relevante si height está fijo, pero ayuda a la proporción
              // Opcional: añadir un poco de padding si quieres más espacio entre tarjetas
              // cuando no están en el centro y viewportFraction es < 1
              pageViewKey: PageStorageKey<String>(
                'popular_carousel',
              ), // Para mantener el estado del scroll
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSectionTitle(BuildContext context) {
  //   final textTheme = Theme.of(context).textTheme;
  //   final colorScheme = Theme.of(context).colorScheme;

  //   String titleText = _selectedCategory == null
  //       ? 'Todos los Productos'
  //       : _categories
  //             .firstWhere(
  //               (c) => c.type == _selectedCategory,
  //               orElse: () => CategoryModel(
  //                 id: '',
  //                 name: 'Productos',
  //                 type: ProductCategory.pizza,
  //                 iconData: Icons.local_pizza_rounded,
  //               ),
  //             )
  //             .name;
  //   // El orElse es por si acaso, aunque no debería pasar si _categories está bien.

  //   IconData sectionIcon =
  //       Icons.list_alt_rounded; // Icono por defecto para "Todos"
  //   if (_selectedCategory != null) {
  //     switch (_selectedCategory!) {
  //       // Usamos ! porque ya comprobamos que no es null
  //       case ProductCategory.pizza:
  //         sectionIcon = Icons.local_pizza_rounded;
  //         break;
  //       case ProductCategory.burger:
  //         sectionIcon = Icons.lunch_dining_rounded;
  //         break;
  //       // Añade más casos para otras categorías si las tienes
  //       default:
  //         sectionIcon = Icons.fastfood_rounded;
  //     }
  //   }

  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //     decoration: BoxDecoration(
  //       color: colorScheme.primary, // Fondo naranja
  //       borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
  //       boxShadow: [
  //         BoxShadow(
  //           color: colorScheme.primary.withOpacity(0.4),
  //           blurRadius: 8,
  //           offset: Offset(0, 4), // Sombra hacia abajo
  //         ),
  //         BoxShadow(
  //           // Sombra interna sutil para efecto de profundidad (opcional)
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 1,
  //           spreadRadius: 1,
  //           offset: Offset(0, 1),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize:
  //           MainAxisSize.min, // Para que el contenedor no ocupe todo el ancho
  //       children: [
  //         Icon(
  //           sectionIcon,
  //           color: AppColors.textOnPrimary, // Icono blanco
  //           size: 22,
  //         ),
  //         SizedBox(width: 10),
  //         Text(
  //           titleText,
  //           style: textTheme.titleLarge?.copyWith(
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textOnPrimary, // Texto blanco
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(
    //   context,
    // ).colorScheme; // También útil, puedes añadirla si no está
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          70.0,
        ), // Altura del AppBar personalizado, ajusta según necesites
        child: Container(
          // Margen para que el AppBar "flote" y se vean los bordes redondeados por todas partes
          margin: const EdgeInsets.only(bottom: 6.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ), // Padding interno
          decoration: BoxDecoration(
            color: Colors
                .white, // O AppColors.primary si prefieres el fondo naranja
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                40.0,
              ), // Radio más grande para que se note
              bottomRight: Radius.circular(40.0),

              // Si también quieres redondear abajo (no es común si está pegado al borde):
              // bottomLeft: Radius.circular( (margin != null) ? 30.0 : 0),
              // bottomRight: Radius.circular( (margin != null) ? 30.0 : 0),
            ), // Bordes bien redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 1,
                offset: Offset(0, 1), // Sombra suave
              ),
            ],
          ),
          child: SafeArea(
            // SafeArea para evitar el notch/barra de estado si el AppBar es muy alto
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // --- IZQUIERDA: FOTO DE PERFIL ---
                InkWell(
                  onTap: _navigateToProfileScreen, // Ya tienes esta función
                  customBorder: CircleBorder(),
                  child: Container(
                    // padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Opcional: un borde sutil alrededor del avatar
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.8),
                        width: 1.8,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20, // Tamaño del avatar
                      backgroundImage: AssetImage(_userAvatarPath),
                      backgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                ),

                // --- CENTRO: DIRECCIÓN DE ENTREGA ---
                // En el método build de _HomeScreenState, dentro del PreferredSize > Container > SafeArea > Row:

                // --- CENTRO: DIRECCIÓN DE ENTREGA ---
                Expanded(
                  child: InkWell(
                    onTap:
                        _navigateToChangeAddress, // <--- LLAMAR A LA NUEVA FUNCIÓN
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ), // Para el efecto ripple
                    child: Padding(
                      // Añadimos un poco de padding para que el InkWell no sea tan ajustado
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ENTREGAR EN',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  // Mostrar la dirección seleccionada o un mensaje por defecto
                                  _selectedDeliveryAddress?.streetAddress ??
                                      'Seleccionar Dirección',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.expand_more_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ... (resto del AppBar: carrito, etc.)

                // --- DERECHA: ICONO DEL CARRITO ---
                ValueListenableBuilder<List<CartItemModel>>(
                  valueListenable: widget.cartService.itemsNotifier,
                  builder: (context, items, child) {
                    int itemCount = widget.cartService.totalItemsCount;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            itemCount == 0
                                ? Icons
                                      .shopping_cart_outlined // Un ícono diferente para el carrito
                                : Icons.shopping_cart,
                            color: AppColors.primary, // Color del ícono
                            size: 26, // Tamaño del ícono
                          ),
                          onPressed:
                              _navigateToCartScreen, // Ya tienes esta función
                          tooltip: 'Ver Carrito',
                        ),
                        if (itemCount > 0)
                          Positioned(
                            right: 4, // Ajusta para el badge
                            top: 4, // Ajusta para el badge
                            child: Container(
                              padding: EdgeInsets.all(itemCount > 9 ? 3 : 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 1.0,
                                ),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 17,
                                minHeight: 17,
                              ),
                              child: Text(
                                '$itemCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // Cada widget que antes estaba en el Column ahora es un SliverToBoxAdapter
          SliverToBoxAdapter(child: _buildSearchBarAndFilters()),
          SliverToBoxAdapter(child: _buildPopularProductsCarousel()),
          SliverToBoxAdapter(child: _buildCategorySelector()),

          // SliverToBoxAdapter(
          //   child: _buildAdvancedFilters(), // Si decides re-añadirlo
          // ),
          // SliverToBoxAdapter(
          //   child: _buildSectionTitle(context), // ¡Ahora esto se desplazará!
          // ),

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
                      background:
                      AppColors.background;
                      final product = _displayedProducts[index];
                      return ProductCard(
                        product: product,
                        // cartService: widget
                        //     .cartService, // Si ProductCard aún lo necesita directamente
                        favoritesService: widget.favoritesService,
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

// lib/src/features/products/widgets/product_card.dart
import 'package:flutter/material.dart';
// import 'dart:math' as math; // Lo quitamos si no usamos ingredientes aleatorios por ahora
import '../../../data/models/product_model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onViewDetails;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.product.isFavorite = _isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.product.name} añadido a favoritos'
              : '${widget.product.name} quitado de favoritos',
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Ya no usamos alturas fijas aquí, dejamos que GridView y AspectRatio lo manejen.
    // El Container externo ahora es solo para el diseño de la tarjeta (bordes, sombra).
    return GestureDetector(
      onTap: widget.onViewDetails,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface, // Fondo blanco de la tarjeta
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Para que la imagen ocupe el ancho
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distribuye el espacio vertical
          children: <Widget>[
            // --- SECCIÓN DE IMAGEN ---
            Expanded(
              // La imagen tomará el espacio vertical disponible que le deje el contenido inferior
              flex: 3, // Dale más peso a la imagen
              child: Stack(
                alignment: Alignment
                    .topCenter, // Alinea el círculo naranja de fondo arriba
                clipBehavior: Clip
                    .none, // Permite que el círculo naranja se salga un poco si es necesario
                children: [
                  // Círculo naranja de fondo (opcional, o más sutil)
                  // Si quieres un círculo exacto como el diseño anterior, sería:
                  // Positioned(
                  //   top: -20, // Ajusta para que "salga" un poco
                  //   child: Container(
                  //     width: 100, height: 100, // Ajusta tamaño
                  //     decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.8), shape: BoxShape.circle),
                  //   ),
                  // ),
                  Padding(
                    // Padding para la imagen para que no toque los bordes de la tarjeta
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      left: 12.0,
                      right: 12.0,
                      bottom: 6.0,
                    ),
                    child: Hero(
                      tag: 'product_image_${widget.product.id}',
                      child: ClipRRect(
                        // Para redondear la imagen si no es perfectamente circular
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit
                              .contain, // Contain para ver toda la imagen sin recortar, o Cover si prefieres
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                          errorBuilder: (context, error, stack) => Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- SECCIÓN DE INFORMACIÓN (DEBAJO DE LA IMAGEN) ---
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                bottom: 10.0,
                top: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // Para que esta columna no se expanda innecesariamente
                children: [
                  Text(
                    widget.product.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tamaño ${widget.product.sizeText.toLowerCase()}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(
                          fontSize: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                      Row(
                        // Fila para los dos botones pequeños
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: _toggleFavorite,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              // Padding para hacer el área táctil un poco más grande
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                _isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: _isFavorite
                                    ? Colors.redAccent
                                    : AppColors.textSecondary.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ), // Espacio entre favorito y carrito
                          InkWell(
                            onTap: widget.onAddToCart,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_shopping_cart_outlined,
                                color: AppColors.textOnPrimary,
                                size: 16,
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
          ],
        ),
      ),
    );
  }
}

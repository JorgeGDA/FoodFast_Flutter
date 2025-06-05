// lib/src/features/products/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // Para el path de recorte si lo necesitamos
import '../../../data/models/product_model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class ProductCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const double cardHeight = 168.0;
    const double imageDiameter = 130.0; // Diámetro para la imagen y su fondo

    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        // Contenedor externo para manejar el margen y la altura total si es necesario
        // La altura total será cardHeight + parte de la imagen que sobresale
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: imageDiameter / 4,
        ), // Margen para que la imagen no se corte
        height: cardHeight + imageDiameter / 3.5, // Altura total aproximada
        child: Stack(
          clipBehavior: Clip.none, // Permite que los hijos se salgan del Stack
          children: <Widget>[
            // 1. Contenedor de información (la tarjeta blanca/naranja)
            Positioned(
              left: 0,
              right:
                  imageDiameter / 3, // Deja espacio a la derecha para la imagen
              top:
                  imageDiameter /
                  4, // Baja la tarjeta para que la imagen se asiente arriba
              child: Container(
                height: cardHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface, // O el color de fondo de la tarjeta
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  // Para el efecto ripple del InkWell si se usa
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    // Para que toda la tarjeta sea clickeable (opcional si GestureDetector es suficiente)
                    onTap: onViewDetails,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Distribuye el espacio
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: AppTextStyles.headline2.copyWith(
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                // Ejemplo de subtítulo, puedes añadirlo a tu ProductModel si quieres
                                product.category == ProductCategory.pizza
                                    ? 'Pizza deliciosa'
                                    : 'Hamburguesa jugosa',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4),
                              // "Ingredientes" y placeholders
                              // Podrías hacer esto más dinámico o quitarlo si no aplica
                              // Text(
                              //   'Ingredientes:',
                              //   style: textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                              // ),
                              // Row(
                              //   children: List.generate(3, (_) =>
                              //     Padding(
                              //       padding: const EdgeInsets.only(right: 4.0),
                              //       child: Text('----', style: textTheme.labelSmall?.copyWith(color: Colors.grey[400])),
                              //     )
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Icono de favorito (ejemplo)
                              // Container(
                              //   padding: EdgeInsets.all(6),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     shape: BoxShape.circle,
                              //     boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 3, spreadRadius: 1)]
                              //   ),
                              //   child: Icon(Icons.favorite_border, color: colorScheme.primary, size: 20),
                              // ),
                              // SizedBox(width: 8), // Espacio
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: AppTextStyles.price.copyWith(
                                  fontSize: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: onAddToCart,
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  size: 20,
                                  color: AppColors.textOnPrimary,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(
                                    10,
                                  ), // Ajusta el padding para hacerlo circular
                                  minimumSize: Size(
                                    40,
                                    40,
                                  ), // Tamaño mínimo para el botón
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Círculo naranja de fondo para la imagen
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: imageDiameter,
                height: imageDiameter,
                decoration: BoxDecoration(
                  color: colorScheme.primary, // Naranja
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Sombra también para el círculo de la imagen
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Imagen del producto
            Positioned(
              right:
                  5, // Ligeramente desplazada para que no esté justo en el borde del círculo naranja
              top: 5,
              child: Hero(
                tag: 'product_image_${product.id}', // Mantenemos el Hero tag
                child: ClipOval(
                  // Para hacer la imagen circular
                  child: Image.network(
                    product.imageUrl,
                    width:
                        imageDiameter -
                        10, // Un poco más pequeña que el círculo naranja
                    height: imageDiameter - 10,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : Container(
                            width: imageDiameter - 10,
                            height: imageDiameter - 10,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                    errorBuilder: (context, error, stack) => Container(
                      width: imageDiameter - 10,
                      height: imageDiameter - 10,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

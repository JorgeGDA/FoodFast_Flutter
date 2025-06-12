// lib/src/features/products/widgets/product_card.dart
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'package:food_app_portfolio/src/services/favorites_service.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '/../../../utils/app_notifications.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onViewDetails;
  final FavoritesService favoritesService;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onViewDetails,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Ancho base de la tarjeta. El GridView lo ajustará.
    // Usamos esto para calcular la altura de la imagen y el padding.
    final double cardBaseWidth = MediaQuery.of(context).size.width * 0.42;
    // Altura de la imagen (ej. una proporción común para imágenes de producto)
    final double imageHeight = cardBaseWidth * 0.75;
    // Altura estimada para la sección de texto + botones
    final double infoSectionHeight =
        95.0; // Ajusta este valor si tu texto/botones necesitan más/menos
    // La tarjeta blanca empieza más abajo de la mitad de la imagen + altura de la sección de info
    final double cardEstimatedHeight =
        (imageHeight * 0.5) +
        infoSectionHeight +
        10; // +10 para padding inferior

    return GestureDetector(
      onTap: onViewDetails,
      child: SizedBox(
        width: cardBaseWidth, // Ayuda a que el Stack tenga un tamaño base
        height: cardEstimatedHeight, // Damos una altura al contenedor del Stack
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // --- CONTENEDOR DE INFORMACIÓN (TARJETA BLANCA) ---
            Positioned(
              // Empieza un poco antes de la mitad de la imagen para que la imagen sobresalga bien
              top: imageHeight * 0.40,
              left: 0,
              right: 0,
              bottom: 0, // Se extiende hasta el final del Stack
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface, // O colorScheme.surface
                  borderRadius: BorderRadius.circular(
                    18.0,
                  ), // Bordes redondeados para la tarjeta
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0, 5), // Sombra suave para la tarjeta
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  // Padding superior para dejar espacio a la imagen que sobresale.
                  // (Mitad de la altura de la imagen) + (un poco de espacio)
                  top: imageHeight * 0.60 + 10,
                  left: 10.0,
                  right: 10.0,
                  bottom: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Importante para evitar overflow
                  children: [
                    Text(
                      product.name,
                      style: textTheme.titleMedium?.copyWith(
                        // Un poco más grande
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 14, // Ajusta si es necesario
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Tamaño ${product.sizeText.toLowerCase()}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(), // Empuja el contenido inferior hacia abajo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 17,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<List<String>>(
                              valueListenable:
                                  favoritesService.favoriteIdsNotifier,
                              builder: (context, favoriteIds, child) {
                                final bool isCurrentlyFavorite =
                                    favoritesService.isFavorite(product.id);
                                return InkWell(
                                  onTap: () {
                                    favoritesService.toggleFavorite(product);
                                    // Mostramos la notificación desde aquí, ya que ProductCard tiene el contexto
                                    final bool isNowFavorite = favoritesService
                                        .isFavorite(product.id);
                                    showAppNotification(
                                      context: context,
                                      title: isNowFavorite
                                          ? '¡Favorito Añadido!'
                                          : 'Favorito Eliminado',
                                      description: isNowFavorite
                                          ? '${product.name} ahora está en tus favoritos.'
                                          : '${product.name} ya no está en tus favoritos.',
                                      type: isNowFavorite
                                          ? AppNotificationType.favorite
                                          : AppNotificationType
                                                .info, // O .warning para eliminar
                                      position: Alignment
                                          .bottomCenter, // Quizás abajo para esta acción
                                      animation: AnimationType.fromBottom,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      isCurrentlyFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: isCurrentlyFavorite
                                          ? Colors.redAccent[400]
                                          : AppColors.textSecondary.withOpacity(
                                              0.5,
                                            ),
                                      size: 22,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // SizedBox(width: 2), // Puedes quitarlo si quieres los iconos más juntos
                            InkWell(
                              onTap: onAddToCart,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: colorScheme
                                      .primary, // O colorScheme.secondary
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: AppColors.textOnPrimary,
                                  size: 17,
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

            // --- IMAGEN RECTANGULAR CON BORDES REDONDEADOS (SOBRESALIENDO) ---
            Positioned(
              top: 0, // Imagen desde la parte superior del Stack
              child: Container(
                width:
                    cardBaseWidth *
                    0.9, // La imagen es un poco más estrecha que la tarjeta base
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ), // Bordes redondeados para la imagen
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(
                  //       0.20,
                  //     ), // Sombra más notoria para la imagen
                  //     blurRadius: 16.0,
                  //     // spreadRadius: -2.0, // Puedes jugar con esto
                  //     offset: Offset(
                  //       0,
                  //       8.0,
                  //     ), // Sombra que se proyecta hacia abajo
                  //   ),
                  // ],
                ),

                // ... (dentro del build method de ProductCard, donde está la imagen) ...
                // Asumo que 'colorScheme' y 'imageHeight' están definidos en el alcance de este build method.
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: product.imageUrl.startsWith('http')
                        ? Image.network(
                            // Si la URL comienza con http(s), usa Image.network
                            product.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (
                                  context,
                                  child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null)
                                    return child; // Imagen cargada
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null, // Muestra progreso si está disponible
                                    ),
                                  );
                                },
                            errorBuilder: (context, error, stackTrace) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.grey[200],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons
                                      .broken_image_outlined, // Icono para error de red
                                  color: Colors.grey[400],
                                  size: imageHeight * 0.5,
                                ),
                              ),
                            ),
                          )
                        : Image.asset(
                            // Si no, asume que es una ruta de asset local
                            product.imageUrl,
                            fit: BoxFit.cover,
                            // El loadingBuilder para Image.asset no es tan relevante porque la carga es casi instantánea.
                            // Lo podrías quitar o dejar un placeholder simple si quieres.
                            // loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: SizedBox(width:20, height:20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary))),
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  // Este error se dispara si el asset no se encuentra o hay un problema al decodificarlo.
                                  print(
                                    'Error cargando asset: ${product.imageUrl}, Error: $error',
                                  );
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons
                                            .image_not_supported_outlined, // Icono para asset no encontrado/erróneo
                                        color: Colors.grey[400],
                                        size: imageHeight * 0.5,
                                      ),
                                    ),
                                  );
                                },
                          ),
                  ),
                ),
                // ...
              ),
            ),
          ],
        ),
      ),
    );
  }
}

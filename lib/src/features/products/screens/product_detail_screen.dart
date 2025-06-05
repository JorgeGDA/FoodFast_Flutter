// lib/src/features/products/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // <-- Importa flutter_rating_bar
import '../../../data/models/product_model.dart'; // Importa tu ProductModel
// Importa tus colores y estilos si los necesitas directamente
// import '../../../constants/app_colors.dart';
// import '../../../constants/app_text_styles.dart';
import '../../../data/mock_data.dart';
import '../../../services/cart_service.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final CartService cartService;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.cartService,
  }) : super(key: key);

  // Método para construir la sección de productos relacionados
  Widget _buildRelatedProductsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Obtener productos de la misma categoría, excluyendo el actual
    final relatedProducts = MockData.products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(5) // Tomar hasta 5 productos relacionados
        .toList();

    if (relatedProducts.isEmpty) {
      return SizedBox.shrink(); // No mostrar nada si no hay relacionados
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'También te podría gustar',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          height:
              270, // Altura para las tarjetas de productos relacionados (ajusta según ProductCard)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            itemBuilder: (ctx, index) {
              final relatedProd = relatedProducts[index];
              // Usamos una versión de ProductCard que no ocupe toda la pantalla
              // o ajustamos el ancho de la tarjeta. Por ahora, ProductCard
              // se adaptará si el ListView horizontal le da un ancho acotado por item.
              // Para un mejor control, podríamos crear una `RelatedProductCard`.
              // Envolvemos ProductCard en un SizedBox para darle un ancho.
              return SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.55, // Ancho de cada tarjeta relacionada
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ), // Espacio entre tarjetas
                  child: ProductCard(
                    // Reutilizamos ProductCard
                    product: relatedProd,
                    onAddToCart: () {
                      cartService.addItem(relatedProd);
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${relatedProd.name} añadido al carrito',
                          ),
                        ),
                      );
                      cartService.printCart();
                    },
                    onViewDetails: () {
                      // Navegar al detalle del producto relacionado
                      // Usar pushReplacement para evitar acumular pantallas si se navega mucho entre relacionados
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: relatedProd,
                            cartService: cartService,
                          ),
                        ),
                      );
                    },
                  ),
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
        title: Text(product.name), // Título con el nombre del producto
        leading: IconButton(
          // Botón para volver atrás
          icon: Icon(Icons.arrow_back_ios_new), // Icono moderno para "atrás"
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        // Permite scroll si el contenido es muy largo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Aquí irá el contenido detallado del producto ---
            // Imagen Grande
            Center(
              child: Hero(
                // Para animación de transición de imagen (veremos después)
                tag:
                    'product_image_${product.id}', // Tag único para la animación Hero
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    product.imageUrl,
                    height: 250, // O un tamaño más adaptable
                    fit: BoxFit.cover,
                    // Puedes añadir loadingBuilder y errorBuilder aquí también
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nombre del Producto (más grande)
            Text(
              product.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            // --- SECCIÓN DE CALIFICACIÓN ---
            Row(
              children: [
                RatingBarIndicator(
                  rating: product.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded, // Icono de estrella más redondeado
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0, // Tamaño de las estrellas
                  direction: Axis.horizontal,
                ),
                SizedBox(width: 8),
                Text(
                  '${product.rating.toStringAsFixed(1)} (${product.reviewCount} reseñas)',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Precio
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: textTheme.headlineSmall?.copyWith(
                // Precio un poco más grande
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Descripción:',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(product.description, style: textTheme.bodyLarge),
            SizedBox(height: 20),

            if (product.ingredients.isNotEmpty) ...[
              Text(
                'Ingredientes:',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              // Wrap para que los ingredientes fluyan si son muchos
              Wrap(
                spacing: 8.0, // Espacio horizontal entre chips
                runSpacing: 4.0, // Espacio vertical entre filas de chips
                children: product.ingredients
                    .map(
                      (ingredient) => Chip(
                        label: Text(ingredient),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withOpacity(0.6),
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
            ],

            // TODO: Sección de Calificación (estrellas)
            // TODO: Botón de "Añadir al Carrito" más prominente
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Añadir al Carrito'),
                onPressed: () {
                  cartService.addItem(product); // Correcto para StatelessWidget
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} añadido al carrito'),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                  cartService.printCart(); // Para depuración
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontSize: 16),
                ),
              ),
            ),
            _buildRelatedProductsSection(context),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

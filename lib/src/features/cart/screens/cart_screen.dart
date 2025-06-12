// lib/src/features/cart/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../../../services/cart_service.dart';
import '../../../data/models/cart_item_model.dart';
// Importa tus estilos si los necesitas
// import '../../../constants/app_text_styles.dart';
import '../../../constants/app_colors.dart';
import '../../../common_widgets/quantity_selector.dart';

class CartScreen extends StatelessWidget {
  // Podría ser StatefulWidget para manejar rebuilds locales
  final CartService cartService;
  final VoidCallback navigateToHome;

  const CartScreen({
    super.key,
    required this.cartService,
    required this.navigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Usamos ValueListenableBuilder para escuchar los cambios en el carrito y reconstruir
    return ValueListenableBuilder<List<CartItemModel>>(
      valueListenable: cartService.itemsNotifier,
      builder: (context, cartItems, child) {
        return Scaffold(
          // ...
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            toolbarHeight: 55,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            leadingWidth: 50,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            title: ValueListenableBuilder<List<CartItemModel>>(
              valueListenable: cartService.itemsNotifier,
              builder: (context, cartItems, _) {
                return Text(
                  'Mi Carrito (${cartService.totalItemsCount})',
                  style: TextStyle(
                    color: AppColors.textPrimary, // Texto oscuro sobre blanco
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                );
              },
            ),
            actions: [
              if (cartItems.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Vaciar carrito',
                  onPressed: () {
                    // Confirmación antes de vaciar
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Confirmar'),
                        content: Text('¿Seguro que quieres vaciar el carrito?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Vaciar',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              cartService.clearCart();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          // ...
          body: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tu carrito está vacío',
                        style: textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Añade algunos productos deliciosos.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: Icon(Icons.restaurant_menu),
                        label: Text('Explorar Menú'),
                        onPressed:
                            navigateToHome, // <-- ¡USA LA FUNCIÓN PASADA!
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Theme.of(context).colorScheme.primary, // Color primario
                          // foregroundColor: Theme.of(context).colorScheme.onPrimary, // Texto sobre primario
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              cartService.removeItem(item.product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item.product.name} eliminado del carrito',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            },
                            background: Container(
                              color: Colors.redAccent.withOpacity(0.8),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ), // Ligero ajuste de margen
                              elevation: 2.0, // Elevación sutil
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ), // Bordes más redondeados
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10), // Padding uniforme
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // Bordes más redondeados para la imagen
                                      child:
                                          item.product.imageUrl.startsWith(
                                            'http',
                                          )
                                          ? Image.network(
                                              item.product.imageUrl,
                                              width:
                                                  80, // Imagen un poco más grande
                                              height: 80,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    progress,
                                                  ) => progress == null
                                                  ? child
                                                  : SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stack,
                                                  ) => Container(
                                                    width: 80,
                                                    height: 80,
                                                    color: Colors.grey[200],
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                            )
                                          : Image.asset(
                                              item.product.imageUrl,
                                              width:
                                                  80, // Imagen un poco más grande
                                              height: 80,
                                              fit: BoxFit.cover,
                                              // loadingBuilder:
                                              //     (
                                              //       context,
                                              //       child,
                                              //       progress,
                                              //     ) => progress == null
                                              //     ? child
                                              //     : SizedBox(
                                              //         width: 80,
                                              //         height: 80,
                                              //         child: Center(
                                              //           child:
                                              //               CircularProgressIndicator(
                                              //                 strokeWidth: 2,
                                              //               ),
                                              //         ),
                                              //       ),
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stack,
                                                  ) => Container(
                                                    width: 80,
                                                    height: 80,
                                                    color: Colors.grey[200],
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                            ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.name,
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Precio: \$${item.product.price.toStringAsFixed(2)}',
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color: textTheme
                                                      .bodySmall
                                                      ?.color
                                                      ?.withOpacity(0.7),
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          QuantitySelector(
                                            quantity: item.quantity,
                                            onIncrement: () {
                                              cartService.updateQuantity(
                                                item.product.id,
                                                item.quantity + 1,
                                              );
                                            },
                                            onDecrement: () {
                                              cartService.updateQuantity(
                                                item.product.id,
                                                item.quantity - 1,
                                              );
                                              // updateQuantity ya maneja la eliminación si la cantidad es <= 0
                                            },
                                            iconColor: colorScheme.primary,
                                            iconSize: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    // Precio total del ítem
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ), // Espacio antes del borde de la tarjeta
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Resumen del Carrito y Botón de Checkout
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                      ), // Padding seguro para la barra inferior
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).scaffoldBackgroundColor, // Color de fondo del scaffold para que se funda
                        border: Border(
                          // Borde superior sutil
                          top: BorderSide(
                            color: AppColors.divider.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        boxShadow: [
                          // Sombra más pronunciada y difusa
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, -10),
                          ),
                        ],
                        // No necesitamos borderRadius aquí si queremos que se funda con el fondo
                        // y solo tenga el borde superior.
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Subtotal:', style: textTheme.titleMedium),
                              Text(
                                '\$${cartService.subtotal.toStringAsFixed(2)}',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Aquí podrías añadir "Costo de Envío" o "Descuentos" si los tuvieras
                          // Ejemplo:
                          // if (costoEnvio > 0)
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: <Widget>[
                          //       Text('Envío:', style: textTheme.bodyLarge),
                          //       Text('\$${costoEnvio.toStringAsFixed(2)}', style: textTheme.bodyLarge),
                          //     ],
                          //   ),
                          // SizedBox(height: costoEnvio > 0 ? 8 : 0),
                          Divider(
                            height: 20,
                            thickness: 1,
                            color: AppColors.divider.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total:',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${cartService.subtotal.toStringAsFixed(2)}', // Actualizar si hay envío/descuentos
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: cartItems.isEmpty
                                ? null
                                : () {
                                    // Lógica para el checkout (próximamente)
                                    print('Procediendo al pago...');
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ), // Botón más redondeado "píldora"
                              ),
                              elevation: 2, // Sombra sutil para el botón
                            ),
                            child: Padding(
                              // Padding interno para el texto del botón
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Text(
                                'Proceder al Pago',
                                style: textTheme.labelLarge?.copyWith(
                                  fontSize: 16, // Ajusta tamaño
                                  color: AppColors.textOnPrimary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

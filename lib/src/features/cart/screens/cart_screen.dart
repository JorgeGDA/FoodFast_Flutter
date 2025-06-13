// lib/src/features/cart/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/data/models/product_model.dart';
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

  // <--- 3. DEFINIR _buildSummaryRow COMO MÉTODO DE LA CLASE --->
  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: labelStyle ?? Theme.of(context).textTheme.bodyLarge),
        Text(
          value == 0.0 && label == "Costo de Envío:"
              ? 'Gratis'
              : '\$${value.toStringAsFixed(2)}', // Condición para "Gratis"
          style:
              valueStyle ??
              Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // <--- MÉTODO DE CONFIRMACIÓN PARA VACIAR CARRITO (ASEGÚRATE QUE ESTÉ AQUÍ) --->
  void _showClearCartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar'),
        content: Text('¿Seguro que quieres vaciar el carrito?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Vaciar', style: TextStyle(color: Colors.red)),
            onPressed: () {
              cartService.clearCart();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    const String placeholderAddress = "Av. Siempre Viva 742, Springfield";
    final String displayAddress = /*selectedAddress ??*/ placeholderAddress;

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
                    // _showClearCartConfirmationDialog(context),
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
                    // --- SECCIÓN DE DIRECCIÓN DE ENTREGA ---
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.location_on_outlined,
                    //         color: colorScheme.primary,
                    //         size: 22,
                    //       ),
                    //       SizedBox(width: 8),
                    //       Text(
                    //         "Entregar en: ",
                    //         style: textTheme.bodyMedium?.copyWith(
                    //           color: Colors.grey[700],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           displayAddress,
                    //           style: textTheme.bodyMedium?.copyWith(
                    //             fontWeight: FontWeight.w600,
                    //             color: colorScheme.onSurface,
                    //           ),
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       Icon(
                    //         Icons.arrow_forward_ios_rounded,
                    //         size: 16,
                    //         color: Colors.grey[600],
                    //       ), // Para cambiar dirección
                    //     ],
                    //   ),
                    // ),
                    // Divider(indent: 16, endIndent: 16, height: 1),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: ValueKey(
                              item.product.id +
                                  (item.selectedSize?.toString() ?? ''),
                            ), // Key única
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              // Pasar el productId Y el selectedSize para asegurar que se elimina el ítem correcto
                              cartService.removeItem(
                                item.product.id,
                                selectedSize: item
                                    .selectedSize, // <--- PASAR EL TAMAÑO DEL ÍTEM
                              );
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
                                      borderRadius: BorderRadius.circular(17),
                                      // Bordes más redondeados para la imagen
                                      child:
                                          item.product.imageUrl.startsWith(
                                            'http',
                                          )
                                          ? Container(
                                              decoration: BoxDecoration(
                                                // color: colorScheme.surface,
                                                // borderRadius:
                                                //     BorderRadius.vertical(
                                                //       bottom: Radius.circular(
                                                //         25.0,
                                                //       ),
                                                //     ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 8.0,
                                                    offset: Offset(0, 9),
                                                  ),
                                                ],
                                              ),
                                              child: Image.network(
                                                item.product.imageUrl,
                                                width:
                                                    95, // Imagen un poco más grande
                                                height: 95,
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
                                              ),
                                            )
                                          : Image.asset(
                                              item.product.imageUrl,
                                              width:
                                                  100, // Imagen un poco más grande
                                              height: 110,
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
                                          // if (item.selectedSize !=
                                          //     null) // Mostrar tamaño si existe
                                          //   Padding(
                                          //     padding: const EdgeInsets.only(
                                          //       top: 2.0,
                                          //     ),
                                          //     child: Text(
                                          //       'Tamaño: ${ProductModel.getSizeTextStatic(item.selectedSize!)}',
                                          //       style: textTheme.bodySmall
                                          //           ?.copyWith(
                                          //             color: Colors.grey[600],
                                          //           ),
                                          //     ),
                                          //   ),
                                          SizedBox(height: 4),
                                          Text(
                                            // Muestra el precio unitario del tamaño específico si lo guardaste
                                            'Precio: \$${(item.priceAtPurchase ?? item.product.price).toStringAsFixed(2)}',
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
                                              // <--- 2. AJUSTE/VERIFICACIÓN AQUÍ (ver CartService más abajo) --->
                                              cartService.updateQuantity(
                                                item.product.id,
                                                item.quantity + 1,
                                                selectedSize: item
                                                    .selectedSize, // Pasando como parámetro nombrado
                                              );
                                            },
                                            onDecrement: () {
                                              // <--- 2. AJUSTE/VERIFICACIÓN AQUÍ (ver CartService más abajo) --->
                                              cartService.updateQuantity(
                                                item.product.id,
                                                item.quantity - 1,
                                                selectedSize: item
                                                    .selectedSize, // Pasando como parámetro nombrado
                                              );
                                            },
                                            iconColor: colorScheme.primary,
                                            iconSize: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      // Precio total del ítem (cantidad * precio unitario)
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
                    // --- SECCIÓN DE RESUMEN Y PAGO ---
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16, // Padding reducido
                        bottom:
                            MediaQuery.of(context).padding.bottom +
                            12, // Padding inferior seguro y compacto
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.08,
                            ), // Sombra más sutil
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, -3),
                          ),
                        ],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ), // Radio de borde más pequeño
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Clave para que la columna no se expanda innecesariamente
                        children: [
                          // --- DIRECCIÓN DE ENTREGA ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: colorScheme.primary,
                                size: 20,
                              ), // Icono más pequeño
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Entregar en:",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 11,
                                      ),
                                    ), // Fuente más pequeña
                                    SizedBox(height: 1),
                                    Text(
                                      displayAddress, // Asumo que displayAddress está definido
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onSurface,
                                        fontSize: 13,
                                      ), // Fuente más pequeña
                                      maxLines:
                                          1, // Una línea para compactar, o 2 si es necesario
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Cambiar dirección (pendiente)",
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ), // Padding del botón reducido
                                  minimumSize: Size(
                                    0,
                                    28,
                                  ), // Altura mínima reducida
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textStyle: textTheme.labelSmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ), // Texto del botón más pequeño
                                ),
                                child: Text(
                                  "Cambiar",
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20,
                            thickness: 0.8,
                            color: AppColors.divider.withOpacity(0.2),
                          ),

                          // --- RESUMEN DE COSTOS ---
                          _buildSummaryRow(
                            context,
                            "Subtotal:",
                            cartService.subtotal,
                            textTheme.bodyMedium?.copyWith(fontSize: 13),
                            textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6), // Espacio reducido
                          _buildSummaryRow(
                            context,
                            "Costo de Envío:",
                            cartService.shippingCost,
                            textTheme.bodyMedium?.copyWith(fontSize: 13),
                            textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),

                          SizedBox(height: 12), // Espacio antes del total/botón
                          // --- FILA DE TOTAL Y BOTÓN DE PAGO ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Alinear verticalmente
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Total:',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartService.totalPrice.toStringAsFixed(2)}',
                                    style: textTheme.titleLarge?.copyWith(
                                      // Mantenemos el total un poco más grande
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 12,
                              ), // Espacio entre total y botón
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: cartItems.isEmpty
                                      ? null
                                      : () {
                                          print('Procediendo al pago...');
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ), // Padding vertical del botón reducido
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ), // Bordes un poco menos redondeados
                                    textStyle: textTheme.labelLarge?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ), // Texto del botón más pequeño
                                    elevation: 1.5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Proceder al Pago'),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                      ), // Icono del botón más pequeño
                                    ],
                                  ),
                                ),
                              ),
                            ],
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

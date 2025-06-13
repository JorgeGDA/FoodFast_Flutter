// lib/src/services/cart_service.dart
import 'package:flutter/foundation.dart'; // Para ValueNotifier y ChangeNotifier si los usamos luego
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class CartService {
  // Usamos ValueNotifier para que los widgets puedan escuchar cambios fácilmente.
  // Es una forma simple de reactividad.
  final ValueNotifier<List<CartItemModel>> _itemsNotifier = ValueNotifier([]);
  ValueListenable<List<CartItemModel>> get itemsNotifier => _itemsNotifier;

  List<CartItemModel> get items => _itemsNotifier.value;

  // Método para añadir un producto al carrito
  void addItem(
    ProductModel product, {
    int quantity = 1,
    ProductSize? selectedSize,
    double? priceAtTimeOfAdding,
  }) {
    // Encuentra el ítem considerando el ID del producto Y el tamaño seleccionado
    int index = items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize ==
              (selectedSize ??
                  product
                      .size), // Compara con el tamaño pasado o el por defecto del producto
    );

    if (index != -1) {
      items[index].quantity += quantity;
    } else {
      items.add(
        CartItemModel(
          id: product.id,
          product: product,
          quantity: quantity,
          selectedSize: selectedSize ?? product.size,
          priceAtPurchase: priceAtTimeOfAdding ?? product.price,
        ),
      );
    }
    _itemsNotifier.value = List.from(items);
  }

  // Método para remover un producto del carrito
  void removeItem(String productId, {ProductSize? selectedSize}) {
    // Si selectedSize es null, esta lógica debería funcionar si los ítems en el carrito
    // también tienen selectedSize como null para productos sin variantes de tamaño,
    // o si solo comparas por productId cuando selectedSize no se proporciona.
    // La clave es que la condición de eliminación coincida con cómo se identifican
    // unívocamente los ítems en tu lista _items.

    items.removeWhere((item) {
      bool idMatches = item.product.id == productId;
      bool sizeMatches =
          true; // Asumir que el tamaño coincide si no se especifica o no es relevante

      // Solo compara tamaños si ambos (el del item y el `selectedSize` pasado) están definidos.
      // O si tu lógica requiere que siempre se pase un `selectedSize` para productos con variantes.
      if (selectedSize != null && item.selectedSize != null) {
        sizeMatches = item.selectedSize == selectedSize;
      } else if (selectedSize != null && item.selectedSize == null) {
        // Caso: intentando quitar un tamaño específico de un producto que no tiene tamaño en el carrito. No debería quitar.
        sizeMatches = false;
      } else if (selectedSize == null && item.selectedSize != null) {
        // Caso: intentando quitar un producto genérico cuando en el carrito hay uno con tamaño específico.
        // Esto depende de tu lógica. Si un producto solo puede estar una vez independientemente del tamaño,
        // entonces no necesitarías `selectedSize` aquí.
        // Pero si el mismo producto ID puede estar con diferentes tamaños, necesitas `selectedSize`.
        // Para la key del Dismissible: `item.product.id + (item.selectedSize?.toString() ?? '')`
        // implica que `selectedSize` ES parte de la identidad del ítem.
        sizeMatches =
            false; // No quitar si el item en carrito tiene tamaño y no se especificó cuál quitar.
      }
      // Si selectedSize es null Y item.selectedSize es null, sizeMatches sigue true.

      return idMatches && sizeMatches;
    });
    _itemsNotifier.value = List.from(items); // ¡MUY IMPORTANTE notificar!
    print("Item eliminado. Nuevo carrito: $items"); // Para debug
  }

  // Método para actualizar la cantidad de un ítem
  void updateQuantity(
    String productId,
    int newQuantity, {
    ProductSize? selectedSize,
  }) {
    // Encuentra el ítem considerando el ID del producto Y el tamaño seleccionado
    // Si selectedSize es null en el CartItem, y aquí también es null, coincidirán.
    // Si el producto en el carrito NO tiene tamaño (selectedSize es null), y aquí pasamos un tamaño, NO coincidirán.
    // La lógica de búsqueda debe ser consistente con cómo se añaden.
    int index = items.indexWhere(
      (item) =>
          item.product.id == productId && item.selectedSize == selectedSize,
    );

    if (index != -1) {
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = newQuantity;
      }
      _itemsNotifier.value = List.from(items);
    }
  }

  // Método para limpiar el carrito
  void clearCart() {
    _itemsNotifier.value = [];
    // printCart();
  }

  // Getter para el subtotal del carrito
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Getter para el número total de ítems (no productos únicos, sino unidades)
  int get totalItemsCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // --- NUEVO: COSTO DE ENVÍO (EJEMPLO) ---
  double get shippingCost {
    if (items.isEmpty) return 0.0; // Sin envío si no hay ítems
    return 2.50; // Costo de envío fijo de ejemplo
  }

  // --- ACTUALIZADO: PRECIO TOTAL ---
  double get totalPrice {
    return subtotal + shippingCost; // Ahora incluye el costo de envío
  }

  // Para depuración
  void printCart() {
    if (items.isEmpty) {
      print("CART_SERVICE: El carrito está vacío.");
      return;
    }
    print("CART_SERVICE: Contenido del carrito:");
    for (var item in items) {
      print(
        "- ${item.product.name} (x${item.quantity}): \$${item.totalPrice.toStringAsFixed(2)}",
      );
    }
    print("Subtotal: \$${subtotal.toStringAsFixed(2)}");
    print("------------------------------------");
  }
}

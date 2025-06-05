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
  void addItem(ProductModel product, {int quantity = 1}) {
    final List<CartItemModel> currentItems = List.from(
      _itemsNotifier.value,
    ); // Copia para modificar
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      // El producto ya está en el carrito, actualiza la cantidad
      currentItems[index].quantity += quantity;
    } else {
      // El producto no está en el carrito, añádelo
      currentItems.add(
        CartItemModel(id: product.id, product: product, quantity: quantity),
      );
    }
    _itemsNotifier.value = currentItems; // Notifica a los oyentes
    // printCart(); // Para depuración
  }

  // Método para remover un producto del carrito
  void removeItem(String productId) {
    final List<CartItemModel> currentItems = List.from(_itemsNotifier.value);
    currentItems.removeWhere((item) => item.product.id == productId);
    _itemsNotifier.value = currentItems;
    // printCart();
  }

  // Método para actualizar la cantidad de un ítem
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final List<CartItemModel> currentItems = List.from(_itemsNotifier.value);
    final index = currentItems.indexWhere(
      (item) => item.product.id == productId,
    );
    if (index != -1) {
      currentItems[index].quantity = newQuantity;
      _itemsNotifier.value = currentItems;
      // printCart();
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

  // Para depuración
  void printCart() {
    if (items.isEmpty) {
      print("CART_SERVICE: El carrito está vacío.");
      return;
    }
    print("CART_SERVICE: Contenido del carrito:");
    items.forEach((item) {
      print(
        "- ${item.product.name} (x${item.quantity}): \$${item.totalPrice.toStringAsFixed(2)}",
      );
    });
    print("Subtotal: \$${subtotal.toStringAsFixed(2)}");
    print("------------------------------------");
  }
}

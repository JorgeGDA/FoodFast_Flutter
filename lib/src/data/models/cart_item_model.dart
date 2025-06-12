// lib/src/data/models/cart_item_model.dart
import 'product_model.dart'; // Necesitamos la definición del producto

class CartItemModel {
  final String
  id; // Podría ser el mismo ID del producto o uno único para el ítem del carrito
  final ProductModel product;
  int quantity;
  final ProductSize? selectedSize; // Opcional
  final double? priceAtPurchase; // Opcional: precio del tamaño específico

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.priceAtPurchase, // Por defecto, se añade 1 unidad
  });

  // Calculadora para el precio total de este ítem (producto.precio * cantidad)
  double get totalPrice => product.price * quantity;

  // Métodos para serialización (opcionales por ahora pero buena práctica)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId':
          product.id, // Guardamos el ID del producto para reconstruirlo
      'quantity': quantity,
    };
  }

  // Nota: El factory fromMap para CartItemModel sería un poco más complejo
  // porque necesitaríamos cargar el ProductModel completo basado en productId.
  // Lo omitiremos por ahora para simplificar, ya que no estamos cargando el carrito desde una BBDD.
}

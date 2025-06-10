// lib/src/services/favorites_service.dart
import 'package:flutter/foundation.dart';
import 'package:food_app_portfolio/src/data/models/product_model.dart';
import 'package:food_app_portfolio/src/data/mock_data.dart'; // Para obtener todos los productos

class FavoritesService {
  // Usamos una lista de IDs para los favoritos
  final List<String> _favoriteProductIds = [];

  // Notificador para que la UI reaccione a los cambios
  final ValueNotifier<List<String>> favoriteIdsNotifier = ValueNotifier([]);

  List<String> get favoriteProductIds => List.unmodifiable(_favoriteProductIds);

  // Obtener la lista completa de ProductModel favoritos
  List<ProductModel> get favoriteProducts {
    return MockData.products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(ProductModel product) {
    final productId = product.id;
    if (isFavorite(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    // Notificar a los listeners que la lista de IDs ha cambiado
    favoriteIdsNotifier.value = List.from(_favoriteProductIds);
    // print("Favoritos actualizados: $_favoriteProductIds");
  }

  // Podrías añadir un método para cargar favoritos desde SharedPreferences en el futuro
}

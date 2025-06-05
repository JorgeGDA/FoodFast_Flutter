// lib/src/data/models/product_model.dart

enum ProductCategory {
  pizza,
  burger,
  drink, // Podríamos añadir más luego
  side, // Acompañamientos
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final ProductCategory category;
  final List<String> ingredients;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isPopular;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.ingredients = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isPopular = false,
  });

  // Método para convertir una instancia de ProductModel a un Map (útil para BBDD o JSON)
  // No lo usaremos mucho ahora, pero es buena práctica tenerlo.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category.toString(), // Convertir enum a string
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
    };
  }

  // Método factory para crear una instancia de ProductModel desde un Map
  // (útil si cargáramos datos desde JSON o una BBDD)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toDouble(), // Asegurarse que es double
      imageUrl: map['imageUrl'],
      category: ProductCategory.values.firstWhere(
        (e) => e.toString() == map['category'],
        orElse: () => ProductCategory.pizza,
      ), // Valor por defecto si no se encuentra
      ingredients: List<String>.from(map['ingredients'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount']?.toInt() ?? 0,
      isFeatured: map['isFeatured'] ?? false,
      isPopular: map['isPopular'] ?? false,
    );
  }
}

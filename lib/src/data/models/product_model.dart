// lib/src/data/models/product_model.dart

enum ProductCategory {
  pizza,
  burger,
  drink, // Podríamos añadir más luego
  side, // Acompañamientos
  icecream, // Acompañamientos
}

enum ProductSize { pequeno, mediano, grande, extraGrande }

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final ProductCategory category;
  final List<String> ingredients; // Lista específica del producto
  final ProductSize size; // <-- NUEVO CAMPO
  final List<String> basePossibleIngredients; // <-- NUEVO CAMPO
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isPopular;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.size,
    this.ingredients = const [],
    this.basePossibleIngredients = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isPopular = false,
    this.isFavorite = false,
  });

  String get sizeText {
    switch (size) {
      case ProductSize.pequeno:
        return 'Pequeño';
      case ProductSize.mediano:
        return 'Mediano';
      case ProductSize.grande:
        return 'Grande';
      case ProductSize.extraGrande:
        return 'Extra Grande';
      default:
        return '';
    }
  }

  static String getSizeTextStatic(ProductSize productSize) {
    switch (productSize) {
      case ProductSize.pequeno:
        return 'Pequeño';
      case ProductSize.mediano:
        return 'Mediano';
      case ProductSize.grande:
        return 'Grande';
      case ProductSize.extraGrande:
        return 'Extra Grande';
      default:
        return '';
    }
  }

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
      'size': size,
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
      size: map['size'],
      ingredients: List<String>.from(map['ingredients'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount']?.toInt() ?? 0,
      isFeatured: map['isFeatured'] ?? false,
      isPopular: map['isPopular'] ?? false,
    );
  }
}

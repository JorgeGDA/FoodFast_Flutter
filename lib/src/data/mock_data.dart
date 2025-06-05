// lib/src/data/mock_data.dart
import 'models/product_model.dart'; // Importa tu modelo

class MockData {
  static final List<ProductModel> products = [
    // --- PIZZAS ---
    ProductModel(
      id: 'pizza001',
      name: 'Pizza Margarita Clásica',
      description:
          'La auténtica pizza italiana con tomate fresco, mozzarella y albahaca.',
      price: 8.99,
      imageUrl:
          'https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.pizza,
      size: ProductSize.mediano,
      ingredients: [
        'Tomate',
        'Mozzarella',
        'Albahaca Fresca',
        'Aceite de Oliva',
      ],
      basePossibleIngredients: [
        'Extra Queso',
        'Jamón',
        'Pimiento',
      ], // <-- AÑADIDO
      rating: 4.5,
      reviewCount: 120,
      isFeatured: true,
      isPopular: true,
      isFavorite: false,
    ),
    ProductModel(
      id: 'pizza002',
      name: 'Pizza Pepperoni Picante',
      description:
          'Para los amantes del picante, con abundante pepperoni y un toque de chili.',
      price: 10.50,
      imageUrl:
          'https://images.pexels.com/photos/2619967/pexels-photo-2619967.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.pizza,
      size: ProductSize.grande,
      ingredients: [
        'Pepperoni',
        'Mozzarella',
        'Salsa de Tomate Picante',
        'Chili en Polvo',
      ],
      basePossibleIngredients: ['Pepperoni', 'Chili', 'Mozzarella'],
      rating: 4.7,
      reviewCount: 95,
      isPopular: true,
      // isFavorite: false,
    ),
    ProductModel(
      id: 'pizza003',
      name: 'Pizza Vegetariana Suprema',
      description:
          'Una explosión de sabor vegetal con pimientos, champiñones, cebolla y aceitunas.',
      price: 9.75,
      imageUrl:
          'https://images.pexels.com/photos/3764990/pexels-photo-3764990.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.pizza,
      size: ProductSize.extraGrande,
      ingredients: [
        'Pimiento Rojo',
        'Pimiento Verde',
        'Champiñones',
        'Cebolla Morada',
        'Aceitunas Negras',
        'Mozzarella',
      ],
      basePossibleIngredients: ['Aceitunas', 'Cebolla', 'Champiñones'],
      rating: 4.3,
      reviewCount: 70,
      isFeatured: true,
      // isFavorite: false,
    ),

    // --- HAMBURGUESAS ---
    ProductModel(
      id: 'burger001',
      name: 'Hamburguesa Clásica Americana',
      description:
          'Carne de res jugosa, queso cheddar, lechuga, tomate y nuestra salsa especial.',
      price: 7.50,
      imageUrl:
          'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.burger,
      size: ProductSize.pequeno,
      ingredients: [
        'Carne de Res',
        'Queso Cheddar',
        'Lechuga Iceberg',
        'Tomate',
        'Pepinillos',
        'Salsa Especial',
        'Pan Brioche',
      ],
      basePossibleIngredients: ['Carne Res', 'Cheddar', 'lechuga'],
      rating: 4.6,
      reviewCount: 150,
      isFeatured: true,
      isPopular: true,
      // isFavorite: false,
    ),
    ProductModel(
      id: 'burger002',
      name: 'Hamburguesa BBQ Bacon',
      description:
          'Irresistible combinación de carne, bacon crujiente, queso y salsa BBQ ahumada.',
      price: 9.20,
      imageUrl:
          'https://images.pexels.com/photos/2983101/pexels-photo-2983101.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.burger,
      size: ProductSize.extraGrande,
      ingredients: [
        'Carne de Res',
        'Bacon Crujiente',
        'Queso Suizo',
        'Cebolla Caramelizada',
        'Salsa BBQ',
        'Pan Artesanal',
      ],
      basePossibleIngredients: ['Carne Res', 'Queso Suizo', 'Salsa BBQ'],
      rating: 4.8,
      reviewCount: 110,
      isPopular: true,
      isFavorite: false,
    ),
    ProductModel(
      id: 'burger003',
      name: 'Hamburguesa de Pollo Crispy',
      description:
          'Pechuga de pollo empanizada y crujiente, con mayonesa de ajo y lechuga fresca.',
      price: 8.00,
      imageUrl:
          'https://images.pexels.com/photos/2725744/pexels-photo-2725744.jpeg?auto=compress&cs=tinysrgb&w=600', // Reemplaza con una URL real
      category: ProductCategory.burger,
      size: ProductSize.grande,
      ingredients: [
        'Pechuga de Pollo Crispy',
        'Mayonesa de Ajo',
        'Lechuga Romana',
        'Tomate',
        'Pan con Sésamo',
      ],
      basePossibleIngredients: ['Pechuga', 'Mayonesa Ajo', 'Salsa BBQ'],
      rating: 4.4,
      reviewCount: 80,
      // isFavorite: false,
    ),
    // Puedes añadir más productos de cada categoría o incluso de nuevas categorías (bebidas, postres)
  ];

  // Podríamos tener listas separadas por categoría si es más fácil luego
  static List<ProductModel> get pizzas =>
      products.where((p) => p.category == ProductCategory.pizza).toList();
  static List<ProductModel> get burgers =>
      products.where((p) => p.category == ProductCategory.burger).toList();

  // Método para obtener un producto por ID (útil para la pantalla de detalle)
  static ProductModel? getProductById(String id) {
    // AÑADE EL '?' AQUÍ
    try {
      // firstWhere lanza un error si no encuentra y no hay orElse.
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      // Si no se encuentra, firstWhere lanza un StateError. Lo capturamos y devolvemos null.
      return null;
    }
    // Alternativamente, si prefieres la sintaxis con orElse:
    // return products.firstWhere((product) => product.id == id, orElse: () => null);
    // En este caso, como ProductModel? PUEDE ser null, el orElse: () => null ya es válido.
  }
}

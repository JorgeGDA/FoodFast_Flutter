// lib/src/data/models/category_model.dart
import 'package:flutter/material.dart'; // Para IconData o Color si los usamos
import 'product_model.dart'; // Para el enum ProductCategory

class CategoryModel {
  final String id;
  final String name;
  final ProductCategory type; // El tipo de categoría del enum
  // Opcional: Podríamos añadir un icono o una imagen para la categoría
  // final IconData icon;
  // final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    // this.icon,
    // this.imageUrl,
  });
}

// Lista de categorías de ejemplo (podríamos ponerla en mock_data.dart también)
// Esto es útil si queremos mostrar una lista de categorías seleccionables.
final List<CategoryModel> mockCategories = [
  CategoryModel(id: 'cat_pizza', name: 'Pizzas', type: ProductCategory.pizza),
  CategoryModel(
    id: 'cat_burger',
    name: 'Hamburguesas',
    type: ProductCategory.burger,
  ),
  // CategoryModel(id: 'cat_drink', name: 'Bebidas', type: ProductCategory.drink),
  // CategoryModel(id: 'cat_side', name: 'Acompañamientos', type: ProductCategory.side),
];

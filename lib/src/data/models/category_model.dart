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
  final IconData iconData;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconData,
    // this.icon,
    // this.imageUrl,
  });
}

// Lista de categorías de ejemplo (podríamos ponerla en mock_data.dart también)
// Esto es útil si queremos mostrar una lista de categorías seleccionables.
final List<CategoryModel> mockCategories = [
  CategoryModel(
    id: 'cat1',
    name: 'Pizzas',
    type: ProductCategory.pizza,
    iconData: Icons.local_pizza_rounded,
  ),
  CategoryModel(
    id: 'cat2',
    name: 'Hamburguesas',
    type: ProductCategory.burger,
    iconData: Icons.lunch_dining_rounded,
  ),
  CategoryModel(
    id: 'cat_drink',
    name: 'Bebidas',
    type: ProductCategory.drink,
    iconData: Icons.local_drink_rounded,
  ),
  CategoryModel(
    id: 'cat_postres',
    name: 'Postres',
    type: ProductCategory.side,
    iconData: Icons.cake_rounded,
  ),
  CategoryModel(
    id: 'cat_icecream',
    name: 'Helados',
    type: ProductCategory.icecream,
    iconData: Icons.icecream_rounded,
  ),
];

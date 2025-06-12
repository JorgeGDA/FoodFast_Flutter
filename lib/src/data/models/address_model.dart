// lib/src/data/models/address_model.dart
import 'package:flutter/material.dart';

enum AddressType { home, work, other }

class AddressModel {
  final String id;
  final String alias; // Ej: "Casa", "Oficina de Mamá"
  final String streetAddress;
  final String city;
  final String stateOrProvince;
  final String postalCode;
  final String country;
  final AddressType type;
  final bool isPrimary;
  // Opcional: para coordenadas del mapa
  // final double? latitude;
  // final double? longitude;

  AddressModel({
    required this.id,
    required this.alias,
    required this.streetAddress,
    required this.city,
    required this.stateOrProvince,
    required this.postalCode,
    required this.country,
    this.type = AddressType.other,
    this.isPrimary = false,
    // this.latitude,
    // this.longitude,
  });

  String get fullAddressShort => '$streetAddress, $city';
  String get fullAddressLong =>
      '$streetAddress, $city, $stateOrProvince, $postalCode, $country';

  IconData get iconData {
    switch (type) {
      case AddressType.home:
        return Icons.home_rounded;
      case AddressType.work:
        return Icons.work_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}

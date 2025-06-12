// lib/src/features/profile/screens/addresses_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/data/models/address_model.dart';
import 'package:food_app_portfolio/src/data/mock_data.dart'; // Para datos de ejemplo
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importar si usas Google Maps real

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  // En una app real, esto vendría de un servicio o gestor de estado
  List<AddressModel> _userAddresses = MockData.userAddresses;

  // --- Placeholder para el mapa ---
  // GoogleMapController? _mapController;
  // final Set<Marker> _markers = {};
  // static const CameraPosition _initialPosition = CameraPosition(
  //   target: LatLng(4.60971, -74.08175), // Coordenadas de Bogotá (ejemplo)
  //   zoom: 11.0,
  // );

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  //   // Añadir marcadores para cada dirección si tienes lat/lng
  // }

  void _selectAndReturnAddress(AddressModel address) {
    // Aquí, antes de hacer pop, podrías guardar esta preferencia globalmente
    // (ej. usando un servicio de estado o SharedPreferences)
    // Por ahora, solo la devolvemos.
    Navigator.of(context).pop(address); // Devuelve la dirección seleccionada
  }

  void _setAsPrimaryAndReturn(AddressModel addressToSetPrimary) {
    setState(() {
      _userAddresses = _userAddresses.map((addr) {
        return AddressModel(
          // ... (copia los campos como antes)
          id: addr.id,
          alias: addr.alias,
          streetAddress: addr.streetAddress,
          city: addr.city,
          stateOrProvince: addr.stateOrProvince,
          postalCode: addr.postalCode,
          country: addr.country,
          type: addr.type,
          isPrimary: addr.id == addressToSetPrimary.id,
        );
      }).toList();
    });
    // Después de marcarla como primaria, también la seleccionamos para la entrega actual.
    _selectAndReturnAddress(addressToSetPrimary);
  }

  void _addOrEditAddress([AddressModel? address]) {
    // TODO: Navegar a pantalla de añadir/editar dirección
    // Pasando `address` si se está editando, o null si es nueva.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          address == null
              ? 'Añadir nueva dirección (pendiente)'
              : 'Editar ${address.alias} (pendiente)',
        ),
      ),
    );
  }

  void _deleteAddress(AddressModel address) {
    // TODO: Lógica para eliminar dirección (y confirmación)
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Dirección'),
        content: Text(
          '¿Seguro que quieres eliminar "${address.alias}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _userAddresses.removeWhere((a) => a.id == address.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${address.alias} eliminada.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _setAsPrimary(AddressModel addressToSetPrimary) {
    // TODO: Lógica para marcar como primaria
    setState(() {
      _userAddresses = _userAddresses.map((addr) {
        return AddressModel(
          id: addr.id,
          alias: addr.alias,
          streetAddress: addr.streetAddress,
          city: addr.city,
          stateOrProvince: addr.stateOrProvince,
          postalCode: addr.postalCode,
          country: addr.country,
          type: addr.type,
          isPrimary:
              addr.id ==
              addressToSetPrimary.id, // Solo la seleccionada es primaria
        );
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${addressToSetPrimary.alias} marcada como principal.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Direcciones'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt_outlined, size: 26),
            tooltip: 'Añadir Dirección',
            onPressed: () => _addOrEditAddress(),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- SECCIÓN DEL MAPA (Placeholder o Mapa Real) ---
          Container(
            height:
                MediaQuery.of(context).size.height *
                0.25, // 25% de la altura de la pantalla
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: colorScheme.surfaceContainerHighest.withOpacity(
                0.5,
              ), // Un color de fondo suave
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            // Placeholder del Mapa:
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Image.network(
                // Imagen estática de un mapa
                'https://miro.medium.com/v2/resize:fit:1200/1*qYUvh-EtES8dtgKiBRiLsA.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 50,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Vista de mapa no disponible",
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // --- O, si integras google_maps_flutter ---
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(18.0),
            //   child: GoogleMap(
            //     onMapCreated: _onMapCreated,
            //     initialCameraPosition: _initialPosition,
            //     markers: _markers,
            //     myLocationButtonEnabled: false, // Opcional
            //     zoomControlsEnabled: false,      // Opcional
            //   ),
            // ),
          ),

          // --- LISTA DE DIRECCIONES ---
          Expanded(
            child: _userAddresses.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    itemCount: _userAddresses.length,
                    itemBuilder: (context, index) {
                      final address = _userAddresses[index];
                      return _buildAddressCard(context, address);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              'No tienes direcciones guardadas',
              style: textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Añade tu primera dirección para facilitar tus pedidos.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.add_location_alt_rounded),
              label: Text('Añadir Primera Dirección'),
              onPressed: () => _addOrEditAddress(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          _selectAndReturnAddress(address); // <--- ACCIÓN PRINCIPAL AL TOCAR
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(address.iconData, color: colorScheme.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.alias,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          address.fullAddressShort,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (address.isPrimary) ...[
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(
                                0.7,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'PRINCIPAL',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey[600],
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _addOrEditAddress(address);
                      } else if (value == 'delete') {
                        _deleteAddress(address);
                      } else if (value == 'set_primary' && !address.isPrimary) {
                        // Ya no llamamos a _selectAndReturnAddress aquí directamente,
                        // _setAsPrimaryAndReturn lo hará.
                        _setAsPrimaryAndReturn(address);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Editar'),
                            ),
                          ),
                          if (!address
                              .isPrimary) // Solo mostrar si no es ya la primaria
                            PopupMenuItem<String>(
                              value: 'set_primary',
                              child: ListTile(
                                leading: Icon(Icons.star_outline_rounded),
                                title: Text('Marcar como Principal'),
                              ),
                            ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(
                                Icons.delete_outline_rounded,
                                color: colorScheme.error,
                              ),
                              title: Text(
                                'Eliminar',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

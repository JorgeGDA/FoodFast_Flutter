// lib/src/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/features/profile/screens/edit_profile_screen.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart'; // Asegúrate de tener tus colores

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Datos de ejemplo (luego podrías obtenerlos de un servicio de autenticación)
    const String userName = "Jorge Gomez HDA";
    const String userEmail = "Jorgeironhead07@gmail.com";
    const String localAvatarPath =
        "assets/images/oahh.jpg"; // Placeholder con iniciales

    return Scaffold(
      // El AppBar ya se configura globalmente por el tema en MyApp
      // pero si necesitas un título específico para esta pantalla, puedes ponerlo:
      appBar: AppBar(
        title: Text('Mi Perfil'),
        // backgroundColor: AppColors.primary, // Ya debería tomarlo del tema
        // titleTextStyle: TextStyle(color: AppColors.textOnPrimary, ...), // Ya debería tomarlo del tema
        automaticallyImplyLeading:
            false, // Si no quieres el botón de atrás de MainNavigator
      ),
      body: SingleChildScrollView(
        physics:
            BouncingScrollPhysics(), // Efecto de rebote agradable en el scroll
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estirar hijos horizontalmente
          children: <Widget>[
            // --- 1. HEADER DEL PERFIL ---
            _buildProfileHeader(
              context,
              userName,
              userEmail,
              localAvatarPath,
              colorScheme,
              textTheme,
            ),
            const SizedBox(height: 24.0),

            // --- 2. SECCIÓN DE OPCIONES DE CUENTA ---
            _buildSectionTitle(context, "Cuenta", textTheme),
            _buildProfileOptionCard(
              context: context,
              icon: Icons.person_outline_rounded,
              title: 'Editar Perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      currentName: userName, // Pasa los datos actuales
                      currentEmail: userEmail,
                      currentAvatarPath: localAvatarPath,
                    ),
                  ),
                );
                // .then((updatedData) {
                //   // Opcional: Si EditProfileScreen devuelve datos, actualiza el estado aquí
                //   if (updatedData != null && updatedData is Map) {
                //     setState(() {
                //       // Aquí tendrías que hacer que userName, userEmail, localAvatarPath
                //       // sean variables de estado de ProfileScreen si quieres que se actualicen en vivo.
                //       // Por ahora, ProfileScreen es StatelessWidget, así que esto es más complejo.
                //       // print("Datos actualizados recibidos: $updatedData");
                //     });
                //   }
                // });
              },
            ),
            _buildProfileOptionCard(
              context: context,
              icon: Icons.receipt_long_outlined,
              title: 'Mis Pedidos',
              onTap: () {
                // TODO: Navegar a pantalla de historial de pedidos
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navegar a Mis Pedidos (pendiente)')),
                );
              },
            ),
            _buildProfileOptionCard(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Direcciones Guardadas',
              onTap: () {
                // TODO: Navegar a pantalla de direcciones
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navegar a Direcciones (pendiente)')),
                );
              },
            ),
            const SizedBox(height: 20.0),

            // --- 3. SECCIÓN DE CONFIGURACIÓN Y AYUDA ---
            _buildSectionTitle(context, "Aplicación", textTheme),
            _buildProfileOptionCard(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Configuración',
              onTap: () {
                // TODO: Navegar a pantalla de configuración
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navegar a Configuración (pendiente)'),
                  ),
                );
              },
            ),
            _buildProfileOptionCard(
              context: context,
              icon: Icons.help_outline_rounded,
              title: 'Centro de Ayuda',
              onTap: () {
                // TODO: Navegar a pantalla de ayuda
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navegar a Ayuda (pendiente)')),
                );
              },
            ),
            const SizedBox(height: 30.0),

            // --- 4. BOTÓN DE CERRAR SESIÓN ---
            _buildLogoutButton(context, colorScheme),
            const SizedBox(height: 20.0), // Espacio al final
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildProfileHeader(
    BuildContext context,
    String userName,
    String userEmail,
    String avatarPath,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: colorScheme.primary.withOpacity(
              0.2,
            ), // Un fondo suave para el avatar
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(avatarPath),
              onBackgroundImageError: (exception, stackTrace) {
                // Este callback es más relevante para NetworkImage, pero no está de más tenerlo.
                // Para AssetImage, el error principal sería que el asset no se encuentre (mal declarado en pubspec.yaml o ruta incorrecta).
                print('Error cargando imagen de avatar local: $exception');
                // Podrías tener un child aquí para mostrar iniciales si AssetImage falla,
                // aunque si el asset está bien declarado, no debería fallar en la carga como tal.
              },
              // El child se mostrará si backgroundImage es null o falla en cargar (más común con NetworkImage)
              // O si quieres superponer algo sobre la imagen.
              // Para mostrar iniciales si el asset no se carga (difícil de simular si está bien puesto),
              // necesitarías una lógica más compleja o confiar en que esté bien puesto.
              // Vamos a asumir que si usas AssetImage, la imagen existe.
              // Si quisieras un fallback por si el asset está mal, se complica un poco
              // porque AssetImage no tiene un "estado de error" tan directo como NetworkImage.
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            userName,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            userEmail,
            style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: textTheme.labelLarge?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.primary, // Usar el color primario
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildProfileOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor, // Opcional para colorear iconos específicos
    bool isDestructive = false, // Para el botón de logout
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Card(
        elevation: 2.0, // Sombra sutil
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // side: BorderSide(color: Colors.grey[300]!, width: 0.5), // Borde opcional
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive
                ? colorScheme.error
                : iconColor ??
                      colorScheme.primary, // Color primario por defecto
          ),
          title: Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: isDestructive
                  ? colorScheme.error
                  : null, // Color de error para destructivo
            ),
          ),
          trailing: isDestructive
              ? null // Sin flecha para logout
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[500],
                ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ), // Padding interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ), // Para efecto ripple
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colorScheme) {
    // Reutilizamos _buildProfileOptionCard para consistencia, pero con estilo destructivo
    return _buildProfileOptionCard(
      context: context,
      icon: Icons.logout_rounded,
      title: 'Cerrar Sesión',
      onTap: () {
        // TODO: Implementar lógica de cierre de sesión
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Cerrar Sesión'),
            content: Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: Text(
                  'Sí, Cerrar Sesión',
                  style: TextStyle(color: colorScheme.error),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Cierra el diálogo
                  // Aquí iría la lógica real de logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cerrando sesión... (pendiente)')),
                  );
                },
              ),
            ],
          ),
        );
      },
      isDestructive: true, // Esto aplicará los colores de error
    );
  }
}

// lib/src/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/features/profile/screens/edit_profile_screen.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart'; // Asegúrate de tener tus colores
import 'package:food_app_portfolio/src/features/profile/screens/addresses_screen.dart';
import 'package:food_app_portfolio/src/features/auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    // required this.cartService,
    // required this.navigateToCartTab,
  }) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- ESTADO DE AUTENTICACIÓN SIMULADO ---
  bool _isLoggedIn = false; // Por defecto, no ha iniciado sesión

  // Datos de usuario (solo se usan si _isLoggedIn es true)
  String _userName = "Carlos Rojas";
  String _userEmail = "carlos.rojas@example.com";
  String _avatarPath = "assets/images/avatar.png"; // Tu avatar local

  void _handleLoginSuccess(String name, String email, String avatar) {
    setState(() {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
      _avatarPath = avatar; // Si la imagen de perfil cambia con el login
    });
  }

  void _handleLogout() {
    // TODO: Implementar lógica real de logout con el servicio de autenticación
    setState(() {
      _isLoggedIn = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Sesión cerrada (simulado)')));
  }

  void _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        // <--- USAR PageRouteBuilder
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Puedes usar la misma _slideTransition o crear una específica
          const begin = Offset(0.0, 1.0); // Desde abajo hacia arriba
          const end = Offset.zero;
          const curve = Curves.easeOutQuint;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ), // Añadir Fade también
          );
        },
        transitionDuration: Duration(
          milliseconds: 500,
        ), // Duración de la transición
      ),
    );

    if (result != null && result is Map<String, String>) {
      _handleLoginSuccess(
        result['name'] ?? 'Usuario Ejemplo',
        result['email'] ?? 'usuario@example.com',
        result['avatar'] ?? _avatarPath,
      );
    }
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colorScheme) {
    return _buildProfileOptionCard(
      context: context,
      icon: Icons.logout_rounded,
      title: 'Cerrar Sesión',
      onTap: () {
        // <--- CAMBIO AQUÍ
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
                  Navigator.of(ctx).pop();
                  _handleLogout(); // Llama al método de logout del estado
                },
              ),
            ],
          ),
        );
      },
      isDestructive: true,
    );
  }

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
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 55,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            color: AppColors.textPrimary, // Texto oscuro sobre blanco
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          SizedBox(width: 56), // Espacio para balancear
        ],
      ),
      body: _isLoggedIn
          ? _buildLoggedInProfileView(
              context,
              colorScheme,
              textTheme,
              userName,
              userEmail,
              localAvatarPath,
            ) // Vista si está logueado
          : _buildLoggedOutView(
              context,
              colorScheme,
              textTheme,
            ), // Vista si NO está logueado
    );
  }

  Widget _buildLoggedInProfileView(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    userName,
    userEmail,
    localAvatarPath,
  ) {
    return SingleChildScrollView(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Si AddressesScreen necesita saber la dirección seleccionada en HomeScreen:
                  // builder: (context) => AddressesScreen(initiallySelectedAddress: homeScreenSelectedAddress),
                  // Por ahora, la mantenemos simple
                  builder: (context) => AddressesScreen(),
                ),
              );
              // No necesitamos manejar el resultado aquí si la selección es solo para HomeScreen
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
                SnackBar(content: Text('Navegar a Configuración (pendiente)')),
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
    );
  }

  Widget _buildLoggedOutView(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 100, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'No has iniciado sesión',
              style: textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Inicia sesión o crea una cuenta para acceder a todas las funciones y personalizar tu experiencia.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.login_rounded),
              label: Text('Iniciar Sesión / Registrarse'),
              onPressed: _navigateToLogin, // <--- NAVEGA A LOGIN SCREEN
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
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
            backgroundColor: colorScheme.primary,
            // Un fondo suave para el avatar
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
}

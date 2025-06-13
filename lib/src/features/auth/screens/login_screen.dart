// lib/src/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart'; // Para tus colores
// Importa tu pantalla de registro (la crearemos pronto)
import 'package:food_app_portfolio/src/features/auth/screens/register_screen.dart';
import 'package:food_app_portfolio/src/constants/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // --- FocusNodes para los campos ---
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // --- Estados para los colores dinámicos ---
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _animationController;
  late Animation<double> _cardOpacityAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Listeners para los FocusNodes
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _cardOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _cardSlideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuint,
          ),
        );
    _animationController.forward();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Lógica de inicio de sesión (simulada por ahora)
      String email = _emailController.text;
      // En una app real, aquí llamarías a tu servicio de autenticación
      print('Email: $email, Password: ${_passwordController.text}');

      // Simular login exitoso y devolver datos
      Navigator.pop(context, {
        'name': 'Usuario Logueado', // Nombre de ejemplo
        'email': email,
        'avatar': 'assets/images/avatar.png', // Avatar de ejemplo
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose(); // Disponer FocusNodes
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(
      context,
    ).textTheme; // Usar el textTheme del contexto
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final cardBackgroundColor = Colors.black.withOpacity(
      0.60,
    ); // Un poco más de opacidad
    final cardForegroundColor = Colors.white;
    final focusedInputColor = colorScheme.primary; // Naranja para el foco

    return Scaffold(
      body: Stack(
        // Para la imagen de fondo y el contenido encima
        children: [
          // --- IMAGEN DE FONDO CON OPACIDAD ---
          Positioned.fill(
            child: Image.asset(
              'assets/images/food_background_login.jpg', // CAMBIA ESTO por una imagen tuya
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // --- CONTENIDO DEL LOGIN ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: SlideTransition(
                  // Animación de deslizamiento para la tarjeta
                  position: _cardSlideAnimation,
                  child: FadeTransition(
                    // Animación de opacidad para la tarjeta
                    opacity: _cardOpacityAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90, // Ajusta el ancho deseado para tu logo
                          height: 90, // Ajusta la altura deseada para tu logo
                          // Opcional: añade sombra al logo si quieres que resalte más del fondo
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .circle, // Si tu logo es para un círculo y quieres sombra circular
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/icon1.png', // <-- REEMPLAZA 'tu_logo.png' CON EL NOMBRE REAL DE TU ARCHIVO DE LOGO
                            // Opcional: si tu logo no se ve bien con la opacidad del fondo, puedes envolverlo
                            // en un Container con un color de fondo sutil o ajustar la opacidad del gradiente del fondo general.
                            color: Colors.white.withOpacity(
                              0.9,
                            ), // Si quieres aplicar un tinte blanco al logo (para logos PNG con transparencia)
                            colorBlendMode: BlendMode
                                .modulate, // Junto con 'color' para tintar
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback si el logo no carga (importante tenerlo)
                              print('Error cargando logo: $error');
                              return Icon(
                                Icons.bakery_dining_outlined,
                                size: 70,
                                color: Colors.white.withOpacity(0.7),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Bienvenido de Nuevo',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Inicia sesión para continuar',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.06),

                        Card(
                          elevation: 12.0, // Sombra más pronunciada
                          color:
                              cardBackgroundColor, // <--- FONDO SEMITRANSPARENTE
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 28.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode:
                                        _emailFocusNode, // Asignar FocusNode
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Correo Electrónico',
                                      hintText: 'tu@correo.com',
                                      prefixIcon: Icons.email_outlined,
                                      isFocused:
                                          _isEmailFocused, // Pasar estado de foco
                                      baseColor: cardForegroundColor,
                                      focusedColor: focusedInputColor,
                                      borderColor: Colors.white.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty)
                                        return 'Ingresa tu correo.';
                                      if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                      ).hasMatch(value))
                                        return 'Correo inválido.';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 18),
                                  // Contraseña
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode:
                                        _passwordFocusNode, // Asignar FocusNode
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Contraseña',
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          // Color dinámico para el icono de visibilidad también
                                          color: _isPasswordFocused
                                              ? focusedInputColor
                                              : cardForegroundColor.withOpacity(
                                                  0.7,
                                                ),
                                        ),
                                        onPressed: _togglePasswordVisibility,
                                      ),
                                      isFocused:
                                          _isPasswordFocused, // Pasar estado de foco
                                      baseColor: cardForegroundColor,
                                      focusedColor: focusedInputColor,
                                      borderColor: Colors.white.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Ingresa tu contraseña.';
                                      if (value.length < 6)
                                        return 'Mínimo 6 caracteres.';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      onPressed: () {
                                        /* TODO: Navegar a pantalla de olvidar contraseña */
                                      },
                                      child: Text(
                                        '¿Olvidaste tu contraseña?',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  // Botón Iniciar Sesión
                                  ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.login_rounded,
                                      size: 24,
                                    ), // Icono añadido
                                    label: Text('Iniciar Sesión'),
                                    onPressed: _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                      minimumSize: Size(
                                        double.infinity,
                                        48,
                                      ), // Altura ligeramente reducida
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: textTheme.labelLarge?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ), // Texto un poco más pequeño
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // --- OPCIÓN DE REGISTRO ---
                        SizedBox(height: 20),
                        Row(
                          // Opción de Registro
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No tienes una cuenta?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  // Reemplaza LoginScreen con RegisterScreen
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => RegisterScreen(),
                                    transitionsBuilder:
                                        _slideTransition, // Usaremos la misma transición
                                  ),
                                );
                              },
                              child: Text(
                                'Regístrate aquí',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para InputDecoration (similar al de EditProfileScreen pero adaptado)
  // Helper para InputDecoration AHORA MÁS DINÁMICO
  InputDecoration _inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    required bool isFocused, // Nuevo: para saber si el campo está enfocado
    required Color baseColor, // Color cuando no está enfocado
    required Color
    focusedColor, // Color cuando está enfocado (tu color primario)
    required Color borderColor, // Color del borde normal
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: isFocused ? focusedColor : baseColor.withOpacity(0.8),
      ), // Color dinámico para el label
      hintStyle: TextStyle(color: baseColor.withOpacity(0.5)),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: isFocused ? focusedColor : baseColor.withOpacity(0.7),
              size: 20,
            ) // Color dinámico para el icono
          : null,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      border: OutlineInputBorder(
        // Borde general
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        // Borde cuando no está enfocado pero sí habilitado
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        // Borde cuando está enfocado
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: focusedColor,
          width: 1.8,
        ), // Borde más grueso y de color primario
      ),
      errorStyle: TextStyle(
        fontSize: 11,
        height: 0.8,
        color: Colors.redAccent[100],
      ),
      errorMaxLines: 2,
    );
  }
}

// --- FUNCIÓN DE TRANSICIÓN REUTILIZABLE ---
Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0); // Desde la derecha
  const end = Offset.zero;
  const curve = Curves.easeOutQuint; // Curva suave
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(position: animation.drive(tween), child: child);
}

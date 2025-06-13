// lib/src/features/auth/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app_portfolio/src/constants/app_colors.dart';
import 'package:food_app_portfolio/src/features/auth/screens/login_screen.dart';
import 'package:food_app_portfolio/src/constants/app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _cardOpacityAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
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

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirmPasswordVisibility() =>
      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Lógica de registro (simulada)
      print('Registrando: ${_nameController.text}, ${_emailController.text}');
      // Simular registro exitoso y navegar a Login (o directamente a Profile si se autologuea)
      // Por ahora, volvemos a Login para que el usuario inicie sesión
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: _slideTransitionOut, // Transición de salida
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Registro exitoso! Por favor, inicia sesión.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final cardBackgroundColor = Colors.black.withOpacity(0.65);
    final cardForegroundColor = Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            /* ... Imagen de fondo (misma que login o diferente) ... */
            child: Image.asset(
              'assets/images/food_background_login.jpg',
              fit: BoxFit.cover,
            ), // Usa otra imagen si quieres
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

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: SlideTransition(
                  position: _cardSlideAnimation,
                  child: FadeTransition(
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
                                Icons.person_add_alt_rounded,
                                size: 70,
                                color: Colors.white.withOpacity(0.7),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Crea tu Cuenta',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Únete para descubrir sabores increíbles',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.05),

                        Card(
                          elevation: 12.0,
                          color: cardBackgroundColor,
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
                                  TextFormField(
                                    controller: _nameController,
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Nombre Completo',
                                      prefixIcon: Icons.person_outline_rounded,
                                      iconColor: cardForegroundColor
                                          .withOpacity(0.7),
                                      labelColor: cardForegroundColor
                                          .withOpacity(0.8),
                                      hintColor: cardForegroundColor
                                          .withOpacity(0.5),
                                      focusedBorderColor: colorScheme.primary,
                                    ),
                                    validator: (v) =>
                                        v!.isEmpty ? 'Ingresa tu nombre' : null,
                                  ),
                                  SizedBox(height: 18),
                                  TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Correo Electrónico',
                                      prefixIcon: Icons.email_outlined,
                                      iconColor: cardForegroundColor
                                          .withOpacity(0.7),
                                      labelColor: cardForegroundColor
                                          .withOpacity(0.8),
                                      hintColor: cardForegroundColor
                                          .withOpacity(0.5),
                                      focusedBorderColor: colorScheme.primary,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      /*...*/
                                    },
                                  ),
                                  SizedBox(height: 18),
                                  TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Contraseña',
                                      prefixIcon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: _togglePasswordVisibility,
                                      ),
                                      iconColor: cardForegroundColor
                                          .withOpacity(0.7),
                                      labelColor: cardForegroundColor
                                          .withOpacity(0.8),
                                      hintColor: cardForegroundColor
                                          .withOpacity(0.5),
                                      focusedBorderColor: colorScheme.primary,
                                    ),
                                    obscureText: _obscurePassword,
                                    validator: (v) {
                                      /*...*/
                                    },
                                  ),
                                  SizedBox(height: 18),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    style: TextStyle(
                                      color: cardForegroundColor,
                                    ),
                                    decoration: _inputDecoration(
                                      labelText: 'Confirmar Contraseña',
                                      prefixIcon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed:
                                            _toggleConfirmPasswordVisibility,
                                      ),
                                      iconColor: cardForegroundColor
                                          .withOpacity(0.7),
                                      labelColor: cardForegroundColor
                                          .withOpacity(0.8),
                                      hintColor: cardForegroundColor
                                          .withOpacity(0.5),
                                      focusedBorderColor: colorScheme.primary,
                                    ),
                                    obscureText: _obscureConfirmPassword,
                                    validator: (v) =>
                                        v != _passwordController.text
                                        ? 'Las contraseñas no coinciden'
                                        : null,
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _handleRegister,
                                    child: Text('Registrarse'),
                                    style: ElevatedButton.styleFrom(/* ... */),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes una cuenta?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => LoginScreen(),
                                    transitionsBuilder: _slideTransitionOut,
                                  ),
                                );
                              },
                              child: Text(
                                'Inicia Sesión',
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

  // Reutiliza el helper _inputDecoration (puedes copiarlo de LoginScreen o ponerlo en un archivo común)
  InputDecoration _inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    Color? iconColor,
    Color? labelColor,
    Color? hintColor,
    Color? focusedBorderColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: labelColor ?? Colors.white70),
      hintStyle: TextStyle(color: hintColor ?? Colors.white54),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: iconColor ?? Colors.white70, size: 20)
          : null,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: focusedBorderColor ?? Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorStyle: TextStyle(
        fontSize: 11,
        height: 0.8,
      ), // Estilo de error más compacto
      errorMaxLines: 2,
    );
  }
}

// --- FUNCIONES DE TRANSICIÓN REUTILIZABLES (pueden ir en un archivo utils/transitions.dart) ---
Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeOutQuint;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(position: animation.drive(tween), child: child);
}

Widget _slideTransitionOut(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(-1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeOutQuint; // Desde la izquierda para salir
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(position: animation.drive(tween), child: child);
}

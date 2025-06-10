import 'package:flutter/material.dart';
// Importa tus colores
import 'package:food_app_portfolio/src/constants/app_text_styles.dart'; // Importa tus estilos de texto
import 'package:food_app_portfolio/src/constants/app_colors.dart';
// Importa tu nuevo MainNavigator
import 'package:food_app_portfolio/src/navigation/main_navigator.dart';
import 'package:food_app_portfolio/src/services/cart_service.dart';
import 'package:food_app_portfolio/src/services/favorites_service.dart';
// Podríamos hacer MyApp StatefulWidget para mantener la instancia de CartService,
// o usar un paquete de inyección de dependencias / servicio singleton más adelante.
// Por ahora, una instancia global simple para el aprendizaje (no ideal para producción compleja).

void main() {
  // Inicializa CartService para que sea una única instancia global (o al menos a nivel de la app)
  final CartService cartService = CartService();
  final FavoritesService favoritesService = FavoritesService(); // <--- NUEVO
  runApp(
    MyApp(cartService: cartService, favoritesService: favoritesService),
  ); // <--- PASAR
}

class MyApp extends StatelessWidget {
  final CartService cartService;
  final FavoritesService favoritesService; // <--- NUEVO

  const MyApp({
    Key? key,
    required this.cartService,
    required this.favoritesService,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App Portfolio',
      theme: ThemeData(
        // Paleta de colores
        primaryColor: AppColors.primary, // Color primario principal
        primaryColorDark: AppColors.primaryDark,
        primaryColorLight: AppColors.primaryLight,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent, // Color de acento
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.textOnAccent,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
          onError: AppColors
              .textOnPrimary, // O el color que prefieras para texto sobre error
        ),
        scaffoldBackgroundColor:
            AppColors.background, // Color de fondo para Scaffolds
        // Tipografía (aquí aplicamos los estilos de texto base)
        // Si configuraste la fuente Poppins, asegúrate que pubspec.yaml esté bien.
        // Si no, comenta la línea fontFamily en AppTextStyles por ahora.
        textTheme:
            TextTheme(
              // Mapeo de nuestros estilos personalizados a los slots de TextTheme de Material 3
              // Nuestros nombres en AppTextStyles (headline1, etc.) son nuestros nombres lógicos.
              // Aquí los asignamos a los "slots" del tema de Material 3.

              // Para títulos grandes y destacados:
              displayLarge: AppTextStyles.headline1.copyWith(
                fontSize: 57,
              ), // M3 Display Large (ejemplo de ajuste si es necesario)
              displayMedium: AppTextStyles
                  .headline1, // Mapeamos nuestro headline1 (28pt) a Display Medium (M3 es 45pt, pero podemos usar nuestro tamaño)
              displaySmall: AppTextStyles
                  .headline2, // Mapeamos nuestro headline2 (24pt) a Display Small (M3 es 36pt)
              // Para títulos de sección o elementos importantes:
              headlineLarge: AppTextStyles.headline1.copyWith(
                fontSize: 32,
              ), // M3 Headline Large
              headlineMedium: AppTextStyles
                  .headline1, // O podemos usar nuestro headline1 (28pt) aquí
              headlineSmall: AppTextStyles
                  .headline2, // M3 Headline Small es 24pt, encaja bien con nuestro headline2
              // Para títulos de tarjetas, diálogos, listas:
              titleLarge: AppTextStyles
                  .subtitle1, // Nuestro subtitle1 (18pt) a Title Large (M3 es 22pt, es cercano)
              titleMedium: AppTextStyles.bodyText1.copyWith(
                fontWeight: FontWeight.w500,
              ), // M3 Title Medium (16pt medium)
              titleSmall: AppTextStyles.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
              ), // M3 Title Small (14pt medium)
              // Para el cuerpo del texto principal:
              bodyLarge: AppTextStyles
                  .bodyText1, // Nuestro bodyText1 (16pt) a Body Large (M3 es 16pt)
              bodyMedium: AppTextStyles
                  .bodyText2, // Nuestro bodyText2 (14pt) a Body Medium (M3 es 14pt)
              bodySmall: AppTextStyles
                  .caption, // Nuestro caption (12pt) a Body Small (M3 es 12pt)
              // Para texto de botones y etiquetas:
              labelLarge: AppTextStyles
                  .button, // Nuestro button (16pt medium) a Label Large (M3 es 14pt medium)
              // El estilo del botón ya se define en elevatedButtonTheme,
              // así que esto es para usos generales de labelLarge.
              labelMedium: AppTextStyles.caption.copyWith(
                fontSize: 12,
              ), // M3 Label Medium (12pt medium)
              labelSmall: AppTextStyles.caption.copyWith(
                fontSize: 11,
              ), // M3 Label Small (11pt medium)
            ).apply(
              // Aplica colores base a los textos
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),

        // Estilos para componentes específicos (opcional, pero bueno para consistencia)
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface, // AppBar con fondo blanco/surface
          elevation: 1, // Sombra sutil
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ), // Iconos en AppBar de color primario
          titleTextStyle: AppTextStyles.headline2.copyWith(
            color: AppColors.textPrimary,
          ), // Título del AppBar
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary, // Color de fondo de botones elevados
            foregroundColor: AppColors
                .textOnPrimary, // Color de texto/iconos de botones elevados
            textStyle: AppTextStyles.button,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
            ),
          ),
        ),

        // ... puedes añadir más temas para otros widgets (CardTheme, InputDecoratorTheme, etc.)
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigator(
        cartService: cartService,
        favoritesService: favoritesService,
      ), // <-- Pasa cartService
      debugShowCheckedModeBanner: false,
    );
  }
}

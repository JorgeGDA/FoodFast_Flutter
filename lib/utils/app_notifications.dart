// lib/src/utils/app_notifications.dart
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart' show AnimationType;
import 'package:food_app_portfolio/src/constants/app_colors.dart';

enum AppNotificationType { success, error, info, warning, cart, favorite }

void showAppNotification({
  required BuildContext context,
  required String title,
  required String description,
  required AppNotificationType type,
  Alignment position = Alignment.topCenter,
  AnimationType animation = AnimationType.fromTop,
  Duration duration = const Duration(seconds: 3),
  double? width,
  Widget? action,
}) {
  Color mainAccentColor;
  Color?
  backgroundColor; // Puede ser null si usamos gradiente o queremos blanco por defecto
  IconData iconData;
  TextStyle titleStyle;
  TextStyle descriptionStyle;
  BoxBorder? border; // Para el borde personalizado

  // Colores base de tu tema
  final Color primaryColor = Theme.of(
    context,
  ).colorScheme.primary; // Tu naranja principal
  final Color onPrimaryColor = Theme.of(
    context,
  ).colorScheme.onPrimary; // Texto sobre primario (blanco)
  final Color successColor = Colors.green.shade600;
  final Color errorColor = Colors.red.shade600;
  final Color infoColor = Colors.blue.shade600;
  final Color warningColor = Colors.orange.shade700;
  final Color favoriteColor = Colors.pink.shade500;

  switch (type) {
    case AppNotificationType.success:
      mainAccentColor = successColor;
      backgroundColor = Colors.green.shade50;
      iconData = Icons.check_circle_rounded;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green.shade800,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(color: Colors.green.shade700, fontSize: 14);
      break;
    case AppNotificationType.error:
      mainAccentColor = errorColor;
      backgroundColor = Colors.red.shade50;
      iconData = Icons.highlight_off_rounded;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red.shade800,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(color: Colors.red.shade700, fontSize: 14);
      break;
    case AppNotificationType.info:
      mainAccentColor = infoColor;
      backgroundColor = Colors.white;
      iconData = Icons.info_rounded;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(color: Colors.blue.shade700, fontSize: 14);
      break;
    case AppNotificationType.warning:
      mainAccentColor = warningColor;
      backgroundColor = Colors.white;
      iconData = Icons.warning_rounded;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.orange.shade900,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(color: Colors.orange.shade800, fontSize: 14);
      break;

    // 👇 MODIFICACIONES PARA EL CARRITO 👇
    case AppNotificationType.cart:
      mainAccentColor = primaryColor; // Icono y progreso serán naranjas
      backgroundColor = Colors.white; // Fondo blanco para la notificación
      iconData = Icons
          .shopping_cart_checkout_rounded; // O Icons.check_circle_outline_rounded si prefieres para "éxito"
      // Estilos de texto con color naranja
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: primaryColor,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ); // Naranja un poco más suave
      // Borde naranja sutil
      break;

    case AppNotificationType.favorite:
      mainAccentColor = favoriteColor;
      backgroundColor = Colors.white; // Fondo blanco también para favoritos
      iconData = Icons.favorite_rounded;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: mainAccentColor,
        fontSize: 17,
      );
      descriptionStyle = TextStyle(color: Colors.grey, fontSize: 14);
      // border = Border.all(color: favoriteColor.withOpacity(0.3), width: 1.5);
      break;
  }

  ElegantNotification(
    width:
        width ?? MediaQuery.of(context).size.width * 0.92, // Un poco más ancho
    position: position,
    animation: animation,
    animationDuration: Duration(milliseconds: 50),
    description: Text(
      description,
      style: descriptionStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
    title: Text(title, style: titleStyle),
    icon: Container(
      // Mantenemos el contenedor para el icono si te gusta el fondo sutil
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        // Usamos un color muy claro del mainAccentColor o transparente para el fondo del icono
        color: mainAccentColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: mainAccentColor,
        size: 30,
      ), // Icono un poco más grande
    ),
    progressIndicatorColor: mainAccentColor.withOpacity(
      0.8,
    ), // Color de la barra de progreso
    background:
        backgroundColor!, // Usamos el backgroundColor definido en el switch
    toastDuration: duration,
    showProgressIndicator: true,
    displayCloseButton: false,
    borderRadius: BorderRadius.circular(22.0), // Bordes más redondeados
    border: border, // Aplicamos el borde definido (o null si no se definió)
    shadow: BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 10,
      spreadRadius: 0, // Sombra más contenida
      offset: Offset(0, 4),
    ),
    isDismissable: true,
    onNotificationPressed: () {
      // Opcional: ElegantNotification.clearAll(context: context);
    },
    action: action,
  ).show(context);
}

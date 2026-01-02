import 'package:flutter/material.dart';
import '../models/notification_data.dart';
import '../utils/notification_theme.dart';

/// Widget personalizado para mostrar un SnackBar estilizado
///
/// Proporciona una apariencia consistente y personalizable para
/// las notificaciones tipo SnackBar.
class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required NotificationData notification,
    NotificationTheme? theme,
  }) : super(
         content: _buildContent(notification, theme),
         backgroundColor: _getBackgroundColor(notification, theme),
         duration: notification.duration ?? const Duration(seconds: 2),
         behavior: SnackBarBehavior.floating,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(
             theme?.borderRadius ?? NotificationTheme.current.borderRadius,
           ),
         ),
         elevation: theme?.elevation ?? NotificationTheme.current.elevation,
         action: notification.showCloseButton
             ? SnackBarAction(
                 label: 'Cerrar',
                 textColor: Colors.white,
                 onPressed: () {
                   notification.onClose?.call();
                 },
               )
             : null,
       );

  static Widget _buildContent(
    NotificationData notification,
    NotificationTheme? theme,
  ) {
    final effectiveTheme = theme ?? NotificationTheme.current;

    return Row(
      children: [
        Icon(
          effectiveTheme.getIconForType(notification.type),
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.title != null)
                Text(
                  notification.title!,
                  style:
                      effectiveTheme.titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                ),
              if (notification.title != null) const SizedBox(height: 4),
              Text(
                notification.message,
                style:
                    effectiveTheme.messageStyle ??
                    const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Color _getBackgroundColor(
    NotificationData notification,
    NotificationTheme? theme,
  ) {
    final effectiveTheme = theme ?? NotificationTheme.current;
    return effectiveTheme.getColorForType(notification.type);
  }
}

/// Builder personalizado para crear SnackBars con más control
class CustomSnackBarBuilder {
  final NotificationData notification;
  final NotificationTheme? theme;

  const CustomSnackBarBuilder({required this.notification, this.theme});

  /// Construye un SnackBar estándar
  SnackBar build() {
    return CustomSnackBar(notification: notification, theme: theme);
  }

  /// Construye un SnackBar con diseño minimalista
  SnackBar buildMinimal() {
    final effectiveTheme = theme ?? NotificationTheme.current;
    final color = effectiveTheme.getColorForType(notification.type);

    return SnackBar(
      content: Text(
        notification.message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: notification.duration ?? const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
  }

  /// Construye un SnackBar con diseño expandido
  SnackBar buildExpanded() {
    final effectiveTheme = theme ?? NotificationTheme.current;
    final color = effectiveTheme.getColorForType(notification.type);
    final icon = effectiveTheme.getIconForType(notification.type);

    return SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.title != null) ...[
                    Text(
                      notification.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (notification.showCloseButton)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  notification.onClose?.call();
                },
              ),
          ],
        ),
      ),
      backgroundColor: color,
      duration: notification.duration ?? const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
      ),
      elevation: effectiveTheme.elevation,
    );
  }
}

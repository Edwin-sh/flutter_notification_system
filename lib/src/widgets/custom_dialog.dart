import 'package:flutter/material.dart';
import '../models/notification_data.dart';
import '../models/notification_type.dart';
import '../utils/notification_theme.dart';

/// Widget personalizado para mostrar un Dialog de error
///
/// Se utiliza para notificaciones críticas que requieren atención del usuario.
class CustomDialog extends StatelessWidget {
  final NotificationData notification;
  final NotificationTheme? theme;

  const CustomDialog({super.key, required this.notification, this.theme});

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? NotificationTheme.current;
    final color = effectiveTheme.getColorForType(notification.type);
    final icon = effectiveTheme.getIconForType(notification.type);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
      ),
      title: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notification.title ?? notification.type.defaultTitle,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.message, style: const TextStyle(fontSize: 16)),
          if (notification.error?.message != null) ...[
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text(
                'Detalles técnicos',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    notification.error!.message,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            notification.onClose?.call();
          },
          child: Text('Aceptar', style: TextStyle(color: color)),
        ),
      ],
    );
  }
}

/// Builder personalizado para crear Dialogs con más opciones
class CustomDialogBuilder {
  final NotificationData notification;
  final NotificationTheme? theme;

  const CustomDialogBuilder({required this.notification, this.theme});

  /// Construye un dialog estándar
  Widget build(BuildContext context) {
    return CustomDialog(notification: notification, theme: theme);
  }

  /// Construye un dialog simple sin detalles técnicos
  Widget buildSimple(BuildContext context) {
    final effectiveTheme = theme ?? NotificationTheme.current;
    final color = effectiveTheme.getColorForType(notification.type);

    return AlertDialog(
      title: Text(notification.title ?? notification.type.defaultTitle),
      content: Text(notification.message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            notification.onClose?.call();
          },
          child: Text('Aceptar', style: TextStyle(color: color)),
        ),
      ],
    );
  }

  /// Construye un dialog con acciones personalizadas
  Widget buildWithActions(
    BuildContext context, {
    required List<Widget> actions,
  }) {
    final effectiveTheme = theme ?? NotificationTheme.current;
    final color = effectiveTheme.getColorForType(notification.type);
    final icon = effectiveTheme.getIconForType(notification.type);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
      ),
      title: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notification.title ?? notification.type.defaultTitle,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(notification.message),
      actions: actions,
    );
  }

  /// Muestra el dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => build(context),
    );
  }
}

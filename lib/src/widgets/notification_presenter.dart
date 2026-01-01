import 'package:flutter/material.dart';
import '../models/notification_data.dart';
import '../models/notification_type.dart';
import 'custom_snackbar.dart';
import 'custom_dialog.dart';
import '../utils/notification_theme.dart';

/// Typedef para función de construcción personalizada de notificaciones
typedef NotificationBuilder =
    Widget Function(BuildContext context, NotificationData notification);

/// Presenter que se encarga de mostrar las notificaciones en la UI
///
/// Determina cómo mostrar cada tipo de notificación (SnackBar o Dialog)
/// y gestiona su visualización en el contexto apropiado.
class NotificationPresenter {
  final NotificationTheme? theme;
  final NotificationBuilder? customBuilder;

  const NotificationPresenter({this.theme, this.customBuilder});

  /// Presenta una notificación en el contexto dado
  void present(BuildContext context, NotificationData notification) {
    // Usar builder personalizado si está disponible
    if (customBuilder != null) {
      _presentCustom(context, notification);
      return;
    }

    // Presentar según el tipo
    if (notification.type.shouldShowDialog) {
      _presentDialog(context, notification);
    } else {
      _presentSnackBar(context, notification);
    }
  }

  /// Presenta una notificación usando un builder personalizado
  void _presentCustom(BuildContext context, NotificationData notification) {
    final widget = customBuilder!(context, notification);

    if (widget is Dialog || widget is AlertDialog) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => widget,
      );
    } else {
      // Asumir que es un widget overlay (como un SnackBar personalizado)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: widget,
          duration: notification.duration ?? const Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  /// Presenta una notificación como SnackBar
  void _presentSnackBar(BuildContext context, NotificationData notification) {
    final snackBar = CustomSnackBar(notification: notification, theme: theme);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Presenta una notificación como Dialog
  void _presentDialog(BuildContext context, NotificationData notification) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          CustomDialog(notification: notification, theme: theme),
    );
  }

  /// Cierra cualquier notificación activa
  void dismiss(BuildContext context) {
    // Cerrar SnackBars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Cerrar Dialogs
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

/// Estrategia de presentación personalizable
abstract class PresentationStrategy {
  void present(BuildContext context, NotificationData notification);
}

/// Estrategia que siempre usa SnackBar
class SnackBarStrategy implements PresentationStrategy {
  final NotificationTheme? theme;

  const SnackBarStrategy({this.theme});

  @override
  void present(BuildContext context, NotificationData notification) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CustomSnackBar(notification: notification, theme: theme));
  }
}

/// Estrategia que siempre usa Dialog
class DialogStrategy implements PresentationStrategy {
  final NotificationTheme? theme;

  const DialogStrategy({this.theme});

  @override
  void present(BuildContext context, NotificationData notification) {
    showDialog(
      context: context,
      barrierDismissible: notification.type != NotificationTypeEnum.error,
      builder: (context) =>
          CustomDialog(notification: notification, theme: theme),
    );
  }
}

/// Estrategia automática basada en el tipo de notificación
class AutoStrategy implements PresentationStrategy {
  final NotificationTheme? theme;

  const AutoStrategy({this.theme});

  @override
  void present(BuildContext context, NotificationData notification) {
    final presenter = NotificationPresenter(theme: theme);
    presenter.present(context, notification);
  }
}

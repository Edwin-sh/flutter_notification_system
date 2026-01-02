import 'package:flutter/widgets.dart';
import 'package:flutter_clean_mvvm_toolkit/flutter_clean_mvvm_toolkit.dart';
import 'package:provider/provider.dart';
import '../models/notification_priority.dart';
import '../models/notification_type.dart';
import '../view_models/notification_view_model.dart';
import '../di/notification_di.dart';

/// Clase helper estática para acceso global al sistema de notificaciones
///
/// Permite mostrar notificaciones desde cualquier lugar sin necesidad de BuildContext
///
/// Ejemplo de uso:
/// ```dart
/// NotificationSystem.showSuccess('Operación completada');
/// NotificationSystem.showError(ErrorItem(message: 'Error al guardar'));
/// ```
class NotificationSystem {
  NotificationSystem._();

  /// Obtiene la instancia del ViewModel
  static NotificationViewModel get instance => getNotificationViewModel();

  /// Muestra una notificación de éxito
  static void showSuccess(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.normal,
  }) {
    instance.showSuccess(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación de error
  static void showError(
    ErrorItem error, {
    NotificationPriority priority = NotificationPriority.critical,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    instance.showError(
      error,
      priority: priority,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Muestra una notificación de advertencia
  static void showWarning(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.normal,
  }) {
    instance.showWarning(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación informativa
  static void showInfo(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.low,
  }) {
    instance.showInfo(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación personalizada
  static void showNotification({
    required String message,
    required NotificationTypeEnum type,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    bool? showCloseButton,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    instance.showNotification(
      message: message,
      type: type,
      title: title,
      priority: priority,
      duration: duration,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Limpia la notificación actual
  static void clear() {
    instance.clear();
  }

  /// Limpia toda la cola de notificaciones
  static void clearQueue() {
    instance.clearQueue();
  }

  /// Obtiene el número de notificaciones en cola
  static int get queueLength => instance.queueLength;

  /// Indica si hay notificaciones en cola
  static bool get hasQueuedNotifications => instance.hasQueuedNotifications;
}

/// Extensión de BuildContext para acceso conveniente a notificaciones
///
/// Permite usar notificaciones directamente desde el BuildContext
/// cuando se está dentro del árbol de widgets de AppNotificationListener
///
/// Ejemplo de uso:
/// ```dart
/// context.showSuccess('Datos guardados correctamente');
/// context.showError(ErrorItem(message: 'Error de conexión'));
/// context.showWarning('Advertencia de seguridad');
/// context.showInfo('Nueva actualización disponible');
/// ```
extension NotificationContextExtension on BuildContext {
  /// Obtiene el NotificationViewModel desde el contexto
  NotificationViewModel get notifications => read<NotificationViewModel>();

  /// Muestra una notificación de éxito
  void showSuccess(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.normal,
  }) {
    notifications.showSuccess(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación de error
  void showError(
    ErrorItem error, {
    NotificationPriority priority = NotificationPriority.critical,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    notifications.showError(
      error,
      priority: priority,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Muestra una notificación de advertencia
  void showWarning(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.normal,
  }) {
    notifications.showWarning(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación informativa
  void showInfo(
    String message, {
    String? title,
    Duration? duration,
    NotificationPriority priority = NotificationPriority.low,
  }) {
    notifications.showInfo(
      message: message,
      title: title,
      duration: duration,
      priority: priority,
    );
  }

  /// Muestra una notificación personalizada
  void showNotification({
    required String message,
    required NotificationTypeEnum type,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    bool? showCloseButton,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    notifications.showNotification(
      message: message,
      type: type,
      title: title,
      priority: priority,
      duration: duration,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Limpia la notificación actual
  void clearNotification() {
    notifications.clear();
  }

  /// Limpia toda la cola de notificaciones
  void clearNotificationQueue() {
    notifications.clearQueue();
  }
}

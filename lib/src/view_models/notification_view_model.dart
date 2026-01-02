import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_mvvm_toolkit/flutter_clean_mvvm_toolkit.dart';
import '../models/notification_data.dart';
import '../models/notification_type.dart';
import '../models/notification_priority.dart';
import '../models/notification_config.dart';
import '../utils/notification_queue.dart';

/// ViewModel para gestión centralizada de notificaciones
///
/// Proporciona una interfaz unificada para mostrar notificaciones en toda la aplicación.
/// Gestiona una cola de notificaciones con prioridades y permite personalización completa.
///
/// Ejemplo de uso:
/// ```dart
/// getIt<NotificationViewModel>().showNotification(
///   message: 'Operación exitosa',
///   type: NotificationTypeEnum.success,
/// );
/// ```
class NotificationViewModel extends ChangeNotifier {
  NotificationData? _currentNotification;
  BuildContext? _appContext;
  final NotificationQueue _queue;
  final NotificationConfig _config;
  bool _isShowingNotification = false;

  /// Constructor con configuración opcional
  NotificationViewModel({NotificationConfig? config, int? maxQueueSize})
    : _config = config ?? NotificationConfig.global,
      _queue = NotificationQueue(
        maxSize: maxQueueSize ?? NotificationConfig.global.maxQueueSize,
      );

  /// Notificación actual que debe mostrarse (null si no hay)
  NotificationData? get notification => _currentNotification;

  /// Indica si hay una notificación actualmente visible
  bool get isShowingNotification => _isShowingNotification;

  /// Contexto de la aplicación (necesario para mostrar SnackBars y Dialogs)
  BuildContext? get appContext => _appContext;

  /// Número de notificaciones en cola
  int get queueLength => _queue.length;

  /// Indica si la cola está vacía
  bool get hasQueuedNotifications => !_queue.isEmpty;

  /// Establece el contexto de la aplicación
  void setAppContext(BuildContext context) {
    _appContext = context;
  }

  /// Muestra una notificación del tipo especificado
  ///
  /// [message] - Mensaje a mostrar
  /// [type] - Tipo de notificación (success, error, warning, info)
  /// [title] - Título opcional
  /// [priority] - Prioridad (default: normal)
  /// [duration] - Duración personalizada
  /// [showCloseButton] - Mostrar botón de cerrar
  /// [onClose] - Callback al cerrar
  /// [onTap] - Callback al hacer tap
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
    final notificationData = NotificationData(
      message: message,
      title: title ?? type.defaultTitle,
      type: type,
      priority: priority,
      duration: duration ?? _config.getDurationForType(type),
      showCloseButton: showCloseButton ?? _config.showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );

    _enqueueOrShow(notificationData);
  }

  /// Muestra una notificación de éxito
  void showSuccess({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    showNotification(
      message: message,
      type: NotificationTypeEnum.success,
      title: title,
      priority: priority,
      duration: duration,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Muestra una notificación de información
  void showInfo({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    showNotification(
      message: message,
      type: NotificationTypeEnum.info,
      title: title,
      priority: priority,
      duration: duration,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Muestra una notificación de advertencia
  void showWarning({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.high,
    Duration? duration,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    showNotification(
      message: message,
      type: NotificationTypeEnum.warning,
      title: title,
      priority: priority,
      duration: duration ?? _config.warningDuration,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Muestra una notificación de error desde un ErrorItem
  void showError(
    ErrorItem error, {
    NotificationPriority priority = NotificationPriority.critical,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    final notificationData = NotificationData.error(
      error: error,
      priority: priority,
      showCloseButton: true,
      onClose: onClose,
      onTap: onTap,
    );

    _enqueueOrShow(notificationData);
  }

  /// Encola o muestra directamente una notificación según su prioridad
  void _enqueueOrShow(NotificationData notification) {
    if (kDebugMode) {
      print(
        '🔔 Notification: [${notification.type.name}] ${notification.message}',
      );
    }

    // Si es crítica y hay una notificación mostrándose, interrumpir
    if (notification.priority == NotificationPriority.critical &&
        _isShowingNotification) {
      clear();
    }

    if (_isShowingNotification) {
      _queue.enqueue(notification);
      if (kDebugMode) {
        print('📥 Notification queued. Queue size: ${_queue.length}');
      }
    } else {
      _showNotification(notification);
    }
  }

  /// Muestra internamente una notificación
  void _showNotification(NotificationData notification) {
    _currentNotification = notification;
    _isShowingNotification = true;
    notifyListeners();
  }

  /// Limpia la notificación actual y procesa la siguiente en la cola
  void clear() {
    if (kDebugMode && _currentNotification != null) {
      debugPrint('🧹 Clearing notification: ${_currentNotification!.id}');
    }

    _currentNotification = null;
    _isShowingNotification = false;
    notifyListeners();

    // Procesar siguiente notificación en cola si existe
    _processNextInQueue();
  }

  /// Procesa la siguiente notificación en la cola
  void _processNextInQueue() {
    if (_queue.isEmpty) return;

    final nextNotification = _queue.dequeue();
    if (nextNotification != null) {
      if (kDebugMode) {
        print(
          '▶️ Processing next notification from queue. Remaining: ${_queue.length}',
        );
      }
      Future.microtask(() => _showNotification(nextNotification));
    }
  }

  /// Limpia la cola de notificaciones
  void clearQueue() {
    _queue.clear();
    if (kDebugMode) {
      print('🗑️ Notification queue cleared');
    }
  }

  /// Cancela una notificación específica por ID
  void cancelNotification(String id) {
    if (_currentNotification?.id == id) {
      clear();
    } else {
      _queue.removeById(id);
    }
  }

  @override
  void dispose() {
    _queue.clear();
    super.dispose();
  }
}

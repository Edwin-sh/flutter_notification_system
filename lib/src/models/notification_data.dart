import 'package:equatable/equatable.dart';
import 'package:flutter_clean_mvvm_toolkit/flutter_clean_mvvm_toolkit.dart';
import 'notification_type.dart';
import 'notification_priority.dart';

/// Clase inmutable que representa los datos de una notificación
///
/// Encapsula toda la información necesaria para mostrar una notificación
/// al usuario, incluyendo mensaje, tipo, prioridad y configuración de visualización.
class NotificationData extends Equatable {
  /// Mensaje principal de la notificación
  final String message;

  /// Título opcional de la notificación
  final String? title;

  /// Tipo de notificación (success, error, warning, info)
  final NotificationTypeEnum type;

  /// Prioridad de la notificación
  final NotificationPriority priority;

  /// ErrorItem asociado (solo para notificaciones de tipo error)
  final ErrorItem? error;

  /// Duración de visualización personalizada (null = usar duración por defecto)
  final Duration? duration;

  /// Si se debe mostrar un botón de cerrar
  final bool showCloseButton;

  /// Callback opcional al cerrar la notificación
  final VoidCallback? onClose;

  /// Callback opcional al hacer tap en la notificación
  final VoidCallback? onTap;

  /// ID único de la notificación
  final String id;

  /// Timestamp de creación
  final DateTime timestamp;

  NotificationData({
    required this.message,
    this.title,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.error,
    this.duration,
    this.showCloseButton = false,
    this.onClose,
    this.onTap,
    String? id,
    DateTime? timestamp,
  }) : id = id ?? _generateId(),
       timestamp = timestamp ?? DateTime.now();

  /// Genera un ID único para la notificación
  static String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Constructor factory para crear una notificación de éxito
  factory NotificationData.success({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    bool showCloseButton = false,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    return NotificationData(
      message: message,
      title: title ?? NotificationTypeEnum.success.defaultTitle,
      type: NotificationTypeEnum.success,
      priority: priority,
      duration: duration,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Constructor factory para crear una notificación de información
  factory NotificationData.info({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.normal,
    Duration? duration,
    bool showCloseButton = false,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    return NotificationData(
      message: message,
      title: title ?? NotificationTypeEnum.info.defaultTitle,
      type: NotificationTypeEnum.info,
      priority: priority,
      duration: duration,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Constructor factory para crear una notificación de advertencia
  factory NotificationData.warning({
    required String message,
    String? title,
    NotificationPriority priority = NotificationPriority.high,
    Duration? duration,
    bool showCloseButton = true,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    return NotificationData(
      message: message,
      title: title ?? NotificationTypeEnum.warning.defaultTitle,
      type: NotificationTypeEnum.warning,
      priority: priority,
      duration: duration,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  /// Constructor factory para crear una notificación de error
  factory NotificationData.error({
    required ErrorItem error,
    NotificationPriority priority = NotificationPriority.critical,
    bool showCloseButton = true,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    return NotificationData(
      message: error.message,
      title: error.title ?? NotificationTypeEnum.error.defaultTitle,
      type: NotificationTypeEnum.error,
      priority: priority,
      error: error,
      showCloseButton: showCloseButton,
      onClose: onClose,
      onTap: onTap,
    );
  }

  @override
  List<Object?> get props => [
    message,
    title,
    type,
    priority,
    error,
    duration,
    showCloseButton,
    id,
    timestamp,
  ];

  @override
  String toString() {
    return 'NotificationData(id: $id, type: $type, message: $message, priority: ${priority.name})';
  }

  /// Crea una copia de la notificación con los campos especificados modificados
  NotificationData copyWith({
    String? message,
    String? title,
    NotificationTypeEnum? type,
    NotificationPriority? priority,
    ErrorItem? error,
    Duration? duration,
    bool? showCloseButton,
    VoidCallback? onClose,
    VoidCallback? onTap,
  }) {
    return NotificationData(
      message: message ?? this.message,
      title: title ?? this.title,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      error: error ?? this.error,
      duration: duration ?? this.duration,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      onClose: onClose ?? this.onClose,
      onTap: onTap ?? this.onTap,
      id: id,
      timestamp: timestamp,
    );
  }
}

// Typedef para VoidCallback
typedef VoidCallback = void Function();

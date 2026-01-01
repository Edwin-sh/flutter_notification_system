import 'notification_type.dart';

/// Configuración global del sistema de notificaciones
///
/// Permite personalizar el comportamiento y apariencia de las notificaciones
/// en toda la aplicación.
class NotificationConfig {
  /// Duración por defecto para notificaciones de éxito
  final Duration successDuration;

  /// Duración por defecto para notificaciones de información
  final Duration infoDuration;

  /// Duración por defecto para notificaciones de advertencia
  final Duration warningDuration;

  /// Duración por defecto para notificaciones de error (null = manual)
  final Duration? errorDuration;

  /// Duración de las animaciones
  final Duration animationDuration;

  /// Tamaño máximo de la cola de notificaciones
  final int maxQueueSize;

  /// Si se debe mostrar un botón de cerrar por defecto
  final bool showCloseButton;

  /// Si se deben habilitar las animaciones
  final bool enableAnimations;

  /// Si se debe vibrar al mostrar notificaciones críticas
  final bool enableVibration;

  /// Si se deben reproducir sonidos
  final bool enableSounds;

  /// Si se debe permitir descartar notificaciones con swipe
  final bool enableSwipeToDismiss;

  const NotificationConfig({
    this.successDuration = const Duration(seconds: 2),
    this.infoDuration = const Duration(seconds: 2),
    this.warningDuration = const Duration(seconds: 3),
    this.errorDuration,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxQueueSize = 3,
    this.showCloseButton = false,
    this.enableAnimations = true,
    this.enableVibration = false,
    this.enableSounds = false,
    this.enableSwipeToDismiss = true,
  });

  /// Configuración por defecto
  static const NotificationConfig defaultConfig = NotificationConfig();

  /// Instancia global de configuración (puede ser sobrescrita)
  static NotificationConfig global = defaultConfig;

  /// Obtiene la duración apropiada según el tipo de notificación
  Duration? getDurationForType(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.success:
        return successDuration;
      case NotificationTypeEnum.info:
        return infoDuration;
      case NotificationTypeEnum.warning:
        return warningDuration;
      case NotificationTypeEnum.error:
        return errorDuration;
    }
  }

  /// Crea una copia de la configuración con los valores especificados modificados
  NotificationConfig copyWith({
    Duration? successDuration,
    Duration? infoDuration,
    Duration? warningDuration,
    Duration? errorDuration,
    Duration? animationDuration,
    int? maxQueueSize,
    bool? showCloseButton,
    bool? enableAnimations,
    bool? enableVibration,
    bool? enableSounds,
    bool? enableSwipeToDismiss,
  }) {
    return NotificationConfig(
      successDuration: successDuration ?? this.successDuration,
      infoDuration: infoDuration ?? this.infoDuration,
      warningDuration: warningDuration ?? this.warningDuration,
      errorDuration: errorDuration ?? this.errorDuration,
      animationDuration: animationDuration ?? this.animationDuration,
      maxQueueSize: maxQueueSize ?? this.maxQueueSize,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableVibration: enableVibration ?? this.enableVibration,
      enableSounds: enableSounds ?? this.enableSounds,
      enableSwipeToDismiss: enableSwipeToDismiss ?? this.enableSwipeToDismiss,
    );
  }
}
